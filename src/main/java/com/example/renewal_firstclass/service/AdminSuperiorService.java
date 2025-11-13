package com.example.renewal_firstclass.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import com.example.renewal_firstclass.dao.AdminSuperiorDAO;
import com.example.renewal_firstclass.dao.CodeDAO;
import com.example.renewal_firstclass.dao.TermAmountDAO;
import com.example.renewal_firstclass.dao.UserApplyDAO;
import com.example.renewal_firstclass.domain.AdminAddAmountDTO;
import com.example.renewal_firstclass.domain.AdminUserApprovalDTO;
import com.example.renewal_firstclass.domain.ApplicationDetailDTO;
import com.example.renewal_firstclass.domain.ApplicationSearchDTO;
import com.example.renewal_firstclass.domain.CodeDTO;
import com.example.renewal_firstclass.domain.PageDTO;
import com.example.renewal_firstclass.domain.TermAmountDTO;
import com.example.renewal_firstclass.util.AES256Util;

import lombok.RequiredArgsConstructor;


@Service
@RequiredArgsConstructor
public class AdminSuperiorService {

    private final TermAmountDAO termAmountDAO;
    private final CodeDAO codeDAO;
    private final AdminSuperiorDAO adminSuperiorDAO;
    private final AES256Util aes256Util;
    private final UserApplyDAO userApplyDAO;
    
    public Long getCenterIdByUsername(String username) {
    	return adminSuperiorDAO.selectCenterIdByUsername(username);
    }
    
    public String getCenterPositionByUsername(String username) {
    	return adminSuperiorDAO.selectCenterPositionByUsername(username);
    }
    //목록 조회
    public Map<String, Object> getPagedApplicationsAndCounts(String nameKeyword, Long appNoKeyword, String status, String date,
    		PageDTO pageDTO) {
        Map<String, Object> result = new HashMap<>();
          
        // DTO로 묶어서 전달
        ApplicationSearchDTO search = new ApplicationSearchDTO();
        search.setNameKeyword(nameKeyword);
        search.setAppNoKeyword(appNoKeyword);
        search.setStatus(status);
        search.setDate(date);
        search.setPageDTO(pageDTO);

        // 두 목록 전체 조회
        List<AdminUserApprovalDTO> applicationList = adminSuperiorDAO.selectApplicationList(search);
        List<AdminUserApprovalDTO> addAmountList = adminSuperiorDAO.selectAddAmountList(search);

        // 두 리스트 병합
        List<AdminUserApprovalDTO> combinedList = new ArrayList<>();
        combinedList.addAll(applicationList);
        combinedList.addAll(addAmountList);

        // 병합된 리스트 정렬 (예: 신청일 내림차순)
        combinedList.sort(Comparator.comparing(
                AdminUserApprovalDTO::getSubmittedDate, 
                Comparator.nullsLast(Comparator.reverseOrder())
        ));

        // 수동 페이징 처리
        int totalCnt = combinedList.size();
        pageDTO.setTotalCnt(totalCnt); 

        int startList = pageDTO.getStartList();
        int endList = Math.min(startList + pageDTO.getListSize(), totalCnt);
        
        List<AdminUserApprovalDTO> paginatedList;
        if (startList >= totalCnt) {
            paginatedList = Collections.emptyList();
        } else {
            paginatedList = combinedList.subList(startList, endList);
        }

        // 상태별 건수 조회 (기존 + 추가지급)
        Map<String, Integer> counts = new HashMap<>();
        
        // 기존 건수
        int pendingApp = adminSuperiorDAO.selectStatusCountIn(Arrays.asList("ST_40"));
        int approvedApp = adminSuperiorDAO.selectStatusCount("ST_50", "Y");
        int rejectedApp = adminSuperiorDAO.selectStatusCount("ST_60", "N");
        int totalApp = pendingApp+approvedApp+rejectedApp;
        
        // 추가지급 건수 (새 DAO 메소드 사용)
        int totalAdd = adminSuperiorDAO.selectAddAmountTotalCount();
        int pendingAdd = adminSuperiorDAO.selectAddAmountStatusCount("ST_40");
        int approvedAdd = adminSuperiorDAO.selectAddAmountStatusCount("ST_50");
        int rejectedAdd = adminSuperiorDAO.selectAddAmountStatusCount("ST_60");

        // 합산
        counts.put("total", totalApp + totalAdd);
        counts.put("pending", pendingApp + pendingAdd);
        counts.put("approved", approvedApp + approvedAdd);
        counts.put("rejected", rejectedApp + rejectedAdd); 
        
        //결과 반환
        result.put("list", paginatedList);
        result.put("pageDTO", pageDTO);
        result.put("counts", counts);

        return result;
    }
    // 지급 상세
    @Transactional
    public void userApplyDetail(long applicationNumber, Model model) {
        // 진입 시 검토중 전환 
        adminSuperiorDAO.whenOpenChangeState(applicationNumber);
        
        AdminUserApprovalDTO dto = adminSuperiorDAO.selectAppDetailByAppNo(applicationNumber);
        try {
            if (dto.getApplicantResiRegiNumber() != null && !dto.getApplicantResiRegiNumber().trim().isEmpty()) {
                dto.setApplicantResiRegiNumber(aes256Util.decrypt(dto.getApplicantResiRegiNumber()));
            }
        } catch (Exception ignore) {}

        try {
            if (dto.getChildResiRegiNumber() != null && !dto.getChildResiRegiNumber().trim().isEmpty()) {
                dto.setChildResiRegiNumber(aes256Util.decrypt(dto.getChildResiRegiNumber()));
            }
        } catch (Exception ignore) {}
        try {
            if (dto.getUpdChildResiRegiNumber() != null && !dto.getUpdChildResiRegiNumber().trim().isEmpty()) {
                dto.setUpdChildResiRegiNumber(aes256Util.decrypt(dto.getUpdChildResiRegiNumber()));
            }
        } catch (Exception ignore) {}
        try {
            if (dto.getUpdAccountNumber() != null && !dto.getUpdAccountNumber().trim().isEmpty()) {
                dto.setUpdAccountNumber(aes256Util.decrypt(dto.getUpdAccountNumber()));
            }
        } catch (Exception ignore) {}

        // 상세 조회
        AdminUserApprovalDTO appDTO = adminSuperiorDAO.selectAppDetailByAppNo(applicationNumber);
        if (appDTO == null) {
            model.addAttribute("error", "존재하지 않는 신청입니다.");
            return;
        }

        // 월별 단위기간 내역
        List<TermAmountDTO> terms = termAmountDAO.selectByConfirmId(appDTO.getConfirmNumber());

        model.addAttribute("appDTO", appDTO);
        model.addAttribute("terms", terms);
        model.addAttribute("isAddAmountDetail", false);
    }
    // 추가지급 상세 
    public void getAddAmountDetail(long applicationNumber, Model model) {
        
    	 AdminUserApprovalDTO dto = adminSuperiorDAO.selectAppDetailByAppNo(applicationNumber);
         try {
             if (dto.getApplicantResiRegiNumber() != null && !dto.getApplicantResiRegiNumber().trim().isEmpty()) {
                 dto.setApplicantResiRegiNumber(aes256Util.decrypt(dto.getApplicantResiRegiNumber()));
             }
         } catch (Exception ignore) {}

         try {
             if (dto.getChildResiRegiNumber() != null && !dto.getChildResiRegiNumber().trim().isEmpty()) {
                 dto.setChildResiRegiNumber(aes256Util.decrypt(dto.getChildResiRegiNumber()));
             }
         } catch (Exception ignore) {}
         try {
             if (dto.getUpdChildResiRegiNumber() != null && !dto.getUpdChildResiRegiNumber().trim().isEmpty()) {
                 dto.setUpdChildResiRegiNumber(aes256Util.decrypt(dto.getUpdChildResiRegiNumber()));
             }
         } catch (Exception ignore) {}
         try {
             if (dto.getUpdAccountNumber() != null && !dto.getUpdAccountNumber().trim().isEmpty()) {
                 dto.setUpdAccountNumber(aes256Util.decrypt(dto.getUpdAccountNumber()));
             }
         } catch (Exception ignore) {}

        // 상세 조회 (새로 만든 매퍼 사용, 내용은 동일함)
        AdminUserApprovalDTO appDTO = adminSuperiorDAO.selectAddAmountDetailByAppNo(applicationNumber);
        if (appDTO == null) {
            model.addAttribute("error", "존재하지 않는 신청입니다.");
            return;
        }

        // 월별 단위기간 내역
        List<TermAmountDTO> terms = termAmountDAO.selectByConfirmId(appDTO.getConfirmNumber());
        
        List<AdminAddAmountDTO> addAmountList = adminSuperiorDAO.selectAddAmountListByAppNo(applicationNumber);
        
        // (1) 버튼 표시 조건 및 기본 정보 출력을 위해 리스트 자체를 담음
        model.addAttribute("addAmountData", addAmountList); 

        // (2) JSP 테이블 매핑을 위해 termId를 Key로 하는 Map 생성
        Map<Long, AdminAddAmountDTO> addAmountMap = new HashMap<>();
        if (addAmountList != null) {
            for (AdminAddAmountDTO item : addAmountList) {
                // termId가 null이 아닐 경우에만 맵에 추가
                if (item.getTermId() != null) {
                    addAmountMap.put(item.getTermId(), item);
                }
            }
        }
        model.addAttribute("addAmountMap", addAmountMap);
        model.addAttribute("appDTO", appDTO);
        model.addAttribute("terms", terms);
        // (JSP에서 구분을 위해)
        model.addAttribute("isAddAmountDetail", true); 
    }
    //추가지급 지급/부지급 처리
    @Transactional
    public void processAddAmount(long applicationNumber, String statusCode) {
        // 'ST_50' (지급) 또는 'ST_60' (부지급)
        int updated = adminSuperiorDAO.updateAddAmountStatus(applicationNumber, statusCode);
        
        if (updated == 0) {
            throw new IllegalStateException("추가지급 처리가 불가능한 상태이거나 이미 처리되었습니다.");
        }
       
    }
    
    /**최종 지급 확정*/
    @Transactional
    public void approveLevel2ToSecondReview(long applicationNumber, long superiorId) {
        int updated = adminSuperiorDAO.approveApplicationLevel2(applicationNumber, superiorId);
        if (updated == 0) {
            // 상태 조건 불일치 등으로 갱신 실패
            throw new IllegalStateException("지급 확정 처리가 불가능한 상태이거나 이미 처리되었습니다.");
        }
    }

    /**부지급 확정*/
    @Transactional
    public void rejectApplication(long applicationNumber, String rejectionReasonCode, String rejectComment, long superiorId) {
        int updated = adminSuperiorDAO.rejectApplication(applicationNumber, rejectionReasonCode, rejectComment, superiorId);
        if (updated == 0) {
            throw new IllegalStateException("부지급 처리가 불가능한 상태이거나 이미 처리되었습니다.");
        }
        ApplicationDetailDTO detail = userApplyDAO.findApplicationDetailByApplicationNumber(applicationNumber);
        if (detail == null) return;

        Long confirmNumber = detail.getConfirmNumber();
        List<TermAmountDTO> src = detail.getList();

        if (confirmNumber == null || src == null || src.isEmpty()) return;

        // 3) confirm_number만 채운 복제 리스트 구성
        List<TermAmountDTO> toInsert = new java.util.ArrayList<>(src.size());
        for (TermAmountDTO t : src) {
            TermAmountDTO copy = new TermAmountDTO();
            copy.setPaymentDate(t.getPaymentDate());
            copy.setCompanyPayment(t.getCompanyPayment());
            copy.setGovPayment(t.getGovPayment());
            copy.setStartMonthDate(t.getStartMonthDate());
            copy.setEndMonthDate(t.getEndMonthDate());
            copy.setConfirmNumber(confirmNumber);
            copy.setUpdateAt(t.getUpdateAt());
            copy.setInitAt(t.getInitAt());
            toInsert.add(copy);
        }
        termAmountDAO.insertTermAmount(toInsert);
    }

    /**부지급 사유 코드 목록 */
    public List<CodeDTO> getRejectCodes() {
        return codeDAO.findAllRejectCode();
    }
}
