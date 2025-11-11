package com.example.renewal_firstclass.service;

import java.util.Date;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import com.example.renewal_firstclass.dao.AdminUserApprovalDAO;
import com.example.renewal_firstclass.dao.CodeDAO;
import com.example.renewal_firstclass.dao.TermAmountDAO;
import com.example.renewal_firstclass.dao.UserApplyDAO;
import com.example.renewal_firstclass.domain.AdminUserApprovalDTO;
import com.example.renewal_firstclass.domain.ApplicationDetailDTO;
import com.example.renewal_firstclass.domain.ApplicationSearchDTO;
import com.example.renewal_firstclass.domain.CodeDTO;
import com.example.renewal_firstclass.domain.ConfirmApplyDTO;
import com.example.renewal_firstclass.domain.PageDTO;
import com.example.renewal_firstclass.domain.TermAmountDTO;
import com.example.renewal_firstclass.util.AES256Util;

import lombok.RequiredArgsConstructor;


@Service
@RequiredArgsConstructor
public class AdminUserApprovalService {

    private final AdminUserApprovalDAO adminUserApprovalDAO;
    private final TermAmountDAO termAmountDAO;
    private final CodeDAO codeDAO;
    private final AES256Util aes256Util;
    private final UserApplyDAO userApplyDAO;

    public Map<String, Object> getPagedApplicationsAndCounts(String keyword, String status, String date,
    		PageDTO pageDTO) {
        Map<String, Object> result = new HashMap<>();
        
        // 검색 조건에 맞는 게시물 조회
        int totalCnt = adminUserApprovalDAO.selectTotalCount(keyword, status, date);
        pageDTO.setTotalCnt(totalCnt); // PageDTO에 총 개수 설정 -> 페이징 계산 완료
        
        // DTO로 묶어서 전달
        ApplicationSearchDTO search = new ApplicationSearchDTO();
        search.setKeyword(keyword);
        search.setStatus(status);
        search.setDate(date);
        search.setPageDTO(pageDTO);

        List<AdminUserApprovalDTO> applicationList = adminUserApprovalDAO.selectApplicationList(search);

        // 상태별 건수 조회
        Map<String, Integer> counts = new HashMap<>();
        
        // 전체 신청 건수
        counts.put("total", adminUserApprovalDAO.selectTotalCount(null, null, null));

        // 대기 건수 ='제출'(ST_20) + '심사중'(ST_30) + '2차 심사중'(ST_40)
        List<String> pendingStatusCodes = Arrays.asList("ST_20", "ST_30", "ST_40");
        counts.put("pending", adminUserApprovalDAO.selectStatusCountIn(pendingStatusCodes));
        
        // 승인/반려
        counts.put("approved", adminUserApprovalDAO.selectStatusCount("ST_50", "Y"));
        counts.put("rejected", adminUserApprovalDAO.selectStatusCount("ST_50", "N")); 
        
        //결과 반환
        result.put("list", applicationList);
        result.put("pageDTO", pageDTO);
        result.put("counts", counts);

        return result;
    }
    
    @Transactional
    public void userApplyDetail(long applicationNumber, Model model) {
        // 진입 시 검토중 전환 
        adminUserApprovalDAO.whenOpenChangeState(applicationNumber);
        
        AdminUserApprovalDTO dto = adminUserApprovalDAO.selectAppDetailByAppNo(applicationNumber);
        if (dto == null) {
            model.addAttribute("error", "존재하지 않는 신청입니다.");
            return; // ← void라서 return; 만
        }
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
        AdminUserApprovalDTO appDTO = adminUserApprovalDAO.selectAppDetailByAppNo(applicationNumber);
        if (appDTO == null) {
            model.addAttribute("error", "존재하지 않는 신청입니다.");
            return;
        }

        // 월별 단위기간 내역
        List<TermAmountDTO> terms = termAmountDAO.selectByConfirmId(appDTO.getConfirmNumber());

        model.addAttribute("appDTO", appDTO);
        model.addAttribute("terms", terms);
    }
    
    /**1차 지급 확정*/
    @Transactional
    public void approveLevel1ToSecondReview(long applicationNumber, Long processorId) {
        int updated = adminUserApprovalDAO.approveApplicationLevel1(applicationNumber, processorId);
        if (updated == 0) {
            // 상태 조건 불일치 등으로 갱신 실패
            throw new IllegalStateException("지급 확정 처리가 불가능한 상태이거나 이미 처리되었습니다.");
        }
    }

    /**부지급 확정*/
    @Transactional
    public void rejectApplication(long applicationNumber, String rejectionReasonCode, String rejectComment, Long processorId) {
        int updated = adminUserApprovalDAO.rejectApplication(applicationNumber, rejectionReasonCode, rejectComment, processorId);
        if (updated == 0) {
            throw new IllegalStateException("부지급 처리가 불가능한 상태이거나 이미 처리되었습니다.");
        }
        ApplicationDetailDTO detail = userApplyDAO.findApplicationDetailByApplicationNumber(applicationNumber);
        if (detail == null) return;

        Long confirmNumber = detail.getConfirmNumber();
        List<TermAmountDTO> src = detail.getList();

        if (confirmNumber == null || src == null || src.isEmpty()) return;

        List<TermAmountDTO> toInsert = new java.util.ArrayList<>(src.size());
        for (TermAmountDTO t : src) {
            TermAmountDTO copy = new TermAmountDTO();
            copy.setPaymentDate(t.getPaymentDate());
            copy.setCompanyPayment(t.getCompanyPayment());
            copy.setGovPayment(t.getGovPayment());
            copy.setStartMonthDate(t.getStartMonthDate());
            copy.setEndMonthDate(t.getEndMonthDate());
            copy.setConfirmNumber(confirmNumber);
            toInsert.add(copy);
        }
        termAmountDAO.insertTermAmount(toInsert);
    }
    

    /**부지급 사유 코드 목록 */
    public List<CodeDTO> getRejectCodes() {
        return codeDAO.findAllRejectCode();
    }
    
    
    @Transactional
    public int updateAdminApply(Long applicationNumber,
                                String updChildName,
                                Date updChildBirthDate,
                                String updChildResiRegiNumber,
                                String updBankCode,
                                String updAccountNumber, Model model) {
        AdminUserApprovalDTO dto = adminUserApprovalDAO.selectAppDetailByAppNo(applicationNumber);
        if (dto == null) {
            model.addAttribute("error", "존재하지 않는 신청입니다.");
        }
        try {
            if (dto.getUpdChildResiRegiNumber() != null && !dto.getUpdChildResiRegiNumber().trim().isEmpty()) {
                dto.setUpdChildResiRegiNumber(aes256Util.encrypt(dto.getUpdChildResiRegiNumber()));
            }
        } catch (Exception ignore) {}
        try {
            if (dto.getUpdAccountNumber() != null && !dto.getUpdAccountNumber().trim().isEmpty()) {
                dto.setUpdAccountNumber(aes256Util.encrypt(dto.getUpdAccountNumber()));
            }
        } catch (Exception ignore) {}

        int updatedBank  = adminUserApprovalDAO
                .updateBankInfoByAppNo(applicationNumber, updBankCode, updAccountNumber);

        int updatedChild = adminUserApprovalDAO
                .updateChildInfoByAppNo(applicationNumber, updChildName, updChildBirthDate, updChildResiRegiNumber);

        return updatedBank + updatedChild;
    }

}
