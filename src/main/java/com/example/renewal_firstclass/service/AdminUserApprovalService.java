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

    
    @Transactional
    public AdminUserApprovalDTO userApplyDetail(long applicationNumber, Model model) {
        adminUserApprovalDAO.whenOpenChangeState(applicationNumber);

        // 상세 조회
        AdminUserApprovalDTO appDTO = adminUserApprovalDAO.selectAppDetailByAppNo(applicationNumber);
        if (appDTO == null) {
            model.addAttribute("error", "존재하지 않는 신청입니다.");
            return null;
        }

        try {
            if (appDTO.getApplicantResiRegiNumber() != null && !appDTO.getApplicantResiRegiNumber().trim().isEmpty()) {
                appDTO.setApplicantResiRegiNumber(aes256Util.decrypt(appDTO.getApplicantResiRegiNumber()));
            }
        } catch (Exception ignore) {}

        try {
            if (appDTO.getChildResiRegiNumber() != null && !appDTO.getChildResiRegiNumber().trim().isEmpty()) {
                appDTO.setChildResiRegiNumber(aes256Util.decrypt(appDTO.getChildResiRegiNumber()));
            }
        } catch (Exception ignore) {}

        try {
            if (appDTO.getUpdChildResiRegiNumber() != null && !appDTO.getUpdChildResiRegiNumber().trim().isEmpty()) {
                appDTO.setUpdChildResiRegiNumber(aes256Util.decrypt(appDTO.getUpdChildResiRegiNumber()));
            }
        } catch (Exception ignore) {}

        try {
            if (appDTO.getUpdAccountNumber() != null && !appDTO.getUpdAccountNumber().trim().isEmpty()) {
                appDTO.setUpdAccountNumber(aes256Util.decrypt(appDTO.getUpdAccountNumber()));
            }
        } catch (Exception ignore) {}
        
        try {
            if (appDTO.getAccountNumber() != null && !appDTO.getAccountNumber().trim().isEmpty()) {
                appDTO.setAccountNumber(aes256Util.decrypt(appDTO.getAccountNumber()));
            }
        } catch (Exception ignore) {}

        List<TermAmountDTO> terms = termAmountDAO.selectByConfirmId(appDTO.getConfirmNumber());

        model.addAttribute("appDTO", appDTO);
        model.addAttribute("terms", terms);

        return appDTO;
    }

    
    /**1차 지급 확정*/
    @Transactional
    public void approveLevel1ToSecondReview(long applicationNumber, Long processorId) {
        int updated = adminUserApprovalDAO.approveApplicationLevel1(applicationNumber, processorId);
        if (updated == 0) {
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
            copy.setUpdateAt(t.getUpdateAt());
            copy.setInitAt("N");
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
            return 0;
        }

        String encChildResiRegiNumber = updChildResiRegiNumber;
        String encAccountNumber = updAccountNumber;

        try {
            if (encChildResiRegiNumber != null && !encChildResiRegiNumber.trim().isEmpty()) {
                encChildResiRegiNumber = aes256Util.encrypt(encChildResiRegiNumber);
            }
            if (encAccountNumber != null && !encAccountNumber.trim().isEmpty()) {
                encAccountNumber = aes256Util.encrypt(encAccountNumber);
            }
        } catch (Exception e) {
            throw new IllegalStateException("암호화 실패", e);
        }

        int updatedBank  = adminUserApprovalDAO
                .updateBankInfoByAppNo(applicationNumber, updBankCode, encAccountNumber);

        int updatedChild = adminUserApprovalDAO
                .updateChildInfoByAppNo(applicationNumber, updChildName, updChildBirthDate, encChildResiRegiNumber);

        return updatedBank + updatedChild;
    }

}
