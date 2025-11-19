package com.example.renewal_firstclass.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import com.example.renewal_firstclass.dao.AdminAddAmountDAO;
import com.example.renewal_firstclass.dao.AdminApprovalDAO;
import com.example.renewal_firstclass.dao.TermAmountDAO;
import com.example.renewal_firstclass.dao.UserApplyDAO;
import com.example.renewal_firstclass.domain.AdminAddAmountDTO;
import com.example.renewal_firstclass.domain.AdminUserApprovalDTO;
import com.example.renewal_firstclass.domain.ApplicationSearchDTO;
import com.example.renewal_firstclass.domain.PageDTO;
import com.example.renewal_firstclass.domain.TermAmountDTO;
import com.example.renewal_firstclass.util.AES256Util;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;


@Service
@Slf4j
@RequiredArgsConstructor
public class AdminAddAmountService {

    private final AdminAddAmountDAO adminAddAmountDAO;
    private final AdminApprovalDAO adminApprovalDAO;
    private final TermAmountDAO termAmountDAO;
    private final AES256Util aes256Util;
    private final UserApplyDAO userApplyDAO;
    
    // 목록 조회
    public Map<String, Object> getPagedApplicationsAndCounts(String nameKeyword, Long appNoKeyword, String status, String date,
            PageDTO pageDTO) {
        Map<String, Object> result = new HashMap<>();
        
        // 검색 조건에 맞는 페이징된 목록 조회
        int totalCnt = adminAddAmountDAO.selectTotalCount(nameKeyword, appNoKeyword, status, date);
        pageDTO.setTotalCnt(totalCnt); 
        
        ApplicationSearchDTO search = new ApplicationSearchDTO();
        search.setNameKeyword(nameKeyword);
        search.setAppNoKeyword(appNoKeyword);
        search.setStatus(status);
        search.setDate(date);
        search.setPageDTO(pageDTO);

        List<AdminUserApprovalDTO> applicationList = adminAddAmountDAO.selectApplicationList(search);

        // 상태별 건수 조회
        Map<String, Integer> counts = new HashMap<>();
        // 전체
        counts.put("total", adminAddAmountDAO.selectTotalCount(null, null, null, null));
        counts.put("possible", adminAddAmountDAO.selectTotalCount(null, null, "POSSIBLE", null));
        // 대기상태
        counts.put("pending", adminAddAmountDAO.selectTotalCount(null, null, "PENDING", null));
        // 승인상태
        counts.put("approved", adminAddAmountDAO.selectTotalCount(null, null, "APPROVED", null));
        // 반려상태
        counts.put("rejected", adminAddAmountDAO.selectTotalCount(null, null, "REJECTED", null));
        
        // 결과 반환
        result.put("list", applicationList);
        result.put("pageDTO", pageDTO);
        result.put("counts", counts);

        return result;
    }
    
    //상세조회
    @Transactional
    public void userApplyDetail(long applicationNumber, Model model) {
        
        AdminUserApprovalDTO dto = adminAddAmountDAO.selectAppDetailByAppNo(applicationNumber);
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
            if (dto.getAccountNumber() != null && !dto.getAccountNumber().trim().isEmpty()) {
                dto.setAccountNumber(aes256Util.decrypt(dto.getAccountNumber()));
            }
        } catch (Exception ignore) {}
        try {
            if (dto.getUpdAccountNumber() != null && !dto.getUpdAccountNumber().trim().isEmpty()) {
                dto.setUpdAccountNumber(aes256Util.decrypt(dto.getUpdAccountNumber()));
            }
        } catch (Exception ignore) {}

        AdminUserApprovalDTO appDTO = adminAddAmountDAO.selectAppDetailByAppNo(applicationNumber);
        if (dto == null) {
            model.addAttribute("error", "존재하지 않는 신청입니다.");
            return;
        }

        List<TermAmountDTO> terms = termAmountDAO.selectByConfirmId(appDTO.getConfirmNumber());
        List<Map<String, Object>> addReasonCodes = adminAddAmountDAO.selectAddAmountReasonCodes();
        // 저장된 내역 조회
        List<AdminAddAmountDTO> addAmountData = adminAddAmountDAO.selectAddAmountDetails(applicationNumber);
        Map<Long, AdminAddAmountDTO> addAmountMap = addAmountData.stream()
                .collect(Collectors.toMap(AdminAddAmountDTO::getTermId, d -> d, (d1, d2) -> d1));
        model.addAttribute("appDTO", dto);
        model.addAttribute("terms", terms);
        model.addAttribute("addReasonCodes", addReasonCodes);
        model.addAttribute("addAmountData", addAmountData);
        model.addAttribute("addAmountMap", addAmountMap);
    }
    
    // 추가지급 신청 처리
    @Transactional
    public void submitAddAmount(Long applicationNumber, Long codeId, String addReason, 
                                List<Long> termIds, List<Long> amounts) {
        
        if (termIds == null || amounts == null || termIds.size() != amounts.size()) {
            throw new IllegalArgumentException("입력된 기간과 금액의 개수가 일치하지 않습니다.");
        }

        List<AdminAddAmountDTO> listToInsert = new ArrayList<>();
        
        for (int i = 0; i < termIds.size(); i++) {
            Long termId = termIds.get(i);
            Long amount = amounts.get(i);

            if (amount != null && amount > 0) {
                AdminAddAmountDTO dto = new AdminAddAmountDTO();
                dto.setApplicationNumber(applicationNumber);
                dto.setTermId(termId);
                dto.setAmount(amount);
                dto.setCodeId(codeId);
                dto.setAddReason((addReason != null && !addReason.isEmpty()) ? addReason : null);
                dto.setStatusCode("ST_40"); // 요청된 상태 코드
                
                listToInsert.add(dto);
            }
        }

        if (listToInsert.isEmpty()) {
            // 아무것도 입력되지 않았으면
            throw new IllegalArgumentException("추가지급액이 1개 이상 입력되어야 합니다.");
        }

        // TB_ADD_AMOUNT 테이블에 배치 INSERT
        adminAddAmountDAO.applyAddAmount(listToInsert);
        
    }
    
}
