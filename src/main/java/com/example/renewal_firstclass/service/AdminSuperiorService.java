package com.example.renewal_firstclass.service;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import com.example.renewal_firstclass.dao.AdminSuperiorDAO;
import com.example.renewal_firstclass.dao.CodeDAO;
import com.example.renewal_firstclass.dao.TermAmountDAO;
import com.example.renewal_firstclass.domain.AdminUserApprovalDTO;
import com.example.renewal_firstclass.domain.ApplicationSearchDTO;
import com.example.renewal_firstclass.domain.CodeDTO;
import com.example.renewal_firstclass.domain.PageDTO;
import com.example.renewal_firstclass.domain.TermAmountDTO;

import lombok.RequiredArgsConstructor;


@Service
@RequiredArgsConstructor
public class AdminSuperiorService {

    private final TermAmountDAO termAmountDAO;
    private final CodeDAO codeDAO;
    private final AdminSuperiorDAO adminSuperiorDAO;
    
    public Long getCenterIdByUsername(String username) {
    	return adminSuperiorDAO.selectCenterIdByUsername(username);
    }
    
    public String getCenterPositionByUsername(String username) {
    	return adminSuperiorDAO.selectCenterPositionByUsername(username);
    }
    
    public Map<String, Object> getPagedApplicationsAndCounts(String keyword, String status, String date,
    		PageDTO pageDTO) {
        Map<String, Object> result = new HashMap<>();
        
        // 검색 조건에 맞는 게시물 조회
        int totalCnt = adminSuperiorDAO.selectTotalCount(keyword, status, date);
        pageDTO.setTotalCnt(totalCnt); // PageDTO에 총 개수 설정 -> 페이징 계산 완료
        
        // DTO로 묶어서 전달
        ApplicationSearchDTO search = new ApplicationSearchDTO();
        search.setKeyword(keyword);
        search.setStatus(status);
        search.setDate(date);
        search.setPageDTO(pageDTO);

        List<AdminUserApprovalDTO> applicationList = adminSuperiorDAO.selectApplicationList(search);

        // 상태별 건수 조회
        Map<String, Integer> counts = new HashMap<>();
        
        // 전체 신청 건수
        counts.put("total", adminSuperiorDAO.selectTotalCount(null, null, null));

        // 대기 건수 = '2차 심사중'(ST_40)
        List<String> pendingStatusCodes = Arrays.asList("ST_40");
        counts.put("pending", adminSuperiorDAO.selectStatusCountIn(pendingStatusCodes));
        
        // 승인/반려
        counts.put("approved", adminSuperiorDAO.selectStatusCount("ST_50", "Y"));
        counts.put("rejected", adminSuperiorDAO.selectStatusCount("ST_60", "N")); 
        
        //결과 반환
        result.put("list", applicationList);
        result.put("pageDTO", pageDTO);
        result.put("counts", counts);

        return result;
    }
    
    @Transactional
    public void userApplyDetail(long applicationNumber, Model model) {
        // 진입 시 검토중 전환 
        adminSuperiorDAO.whenOpenChangeState(applicationNumber);

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
    }

    /**부지급 사유 코드 목록 */
    public List<CodeDTO> getRejectCodes() {
        return codeDAO.findAllRejectCode();
    }
    
//    @Transactional(readOnly = true)
//    public void userApplyDetail(long applicationNumber, Model model) {
//        adminSuperiorDTO appDTO = adminSuperiorDAO.selectAppDetailByAppNo(applicationNumber);
//        if (appDTO == null) {
//            model.addAttribute("error", "존재하지 않는 신청입니다.");
//            return;
//        }
//        List<TermAmountDTO> terms = termAmountDAO.selectByConfirmId(appDTO.getConfirmNumber());
//        model.addAttribute("appDTO", appDTO);
//        model.addAttribute("terms", terms);
//    }

}
