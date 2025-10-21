package com.example.renewal_firstclass.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.renewal_firstclass.dao.AdminApprovalDAO;
import com.example.renewal_firstclass.dao.ConfirmApplyDAO;
import com.example.renewal_firstclass.dao.TermAmountDAO;
import com.example.renewal_firstclass.domain.AdminJudgeDTO;
import com.example.renewal_firstclass.domain.ConfirmApplyDTO;
import com.example.renewal_firstclass.domain.TermAmountDTO;
import com.example.renewal_firstclass.util.AES256Util;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j 
public class AdminApprovalService {

    private final AdminApprovalDAO adminApprovalDAO;
    private final ConfirmApplyDAO confirmApplyDAO;
    private final TermAmountDAO termAmountDAO;
    private final AES256Util aes256Util;
    // 신청 상세 조회
    public ConfirmApplyDTO getConfirmDetail(Long confirmNumber) {
        log.info("=== Get Confirm Detail ===");
        log.info("confirmNumber: {}", confirmNumber);
        ConfirmApplyDTO dto = confirmApplyDAO.selectByConfirmNumber(confirmNumber);
        if (dto == null) return null;

        try {
            if (dto.getRegistrationNumber() != null && !dto.getRegistrationNumber().trim().isEmpty()) {
                dto.setRegistrationNumber(aes256Util.decrypt(dto.getRegistrationNumber()));
            }
        } catch (Exception ignore) {}

        try {
            if (dto.getChildResiRegiNumber() != null && !dto.getChildResiRegiNumber().trim().isEmpty()) {
                dto.setChildResiRegiNumber(aes256Util.decrypt(dto.getChildResiRegiNumber()));
            }
        } catch (Exception ignore) {}
        
        List<TermAmountDTO> terms = termAmountDAO.selectByConfirmId(confirmNumber);
        dto.setTermAmounts(terms);
        
        return dto;
    }

    // 승인 처리
    public boolean adminApprove(AdminJudgeDTO judgeDTO, Long userId) {
        log.info("=== Admin Approve Request ===");
        log.info("confirmNumber: {}", judgeDTO.getConfirmNumber());
        log.info("userId: {}", userId);

        // 1. 이미 처리된 신청인지 확인
        int processedCount = adminApprovalDAO.isProcessed(judgeDTO.getConfirmNumber());
        log.info("isProcessed count: {}", processedCount);
        
        if (processedCount > 0) {
            log.warn("Application {} is already processed.", judgeDTO.getConfirmNumber());
            return false;
        }

        // 2. 현재 데이터 조회
        ConfirmApplyDTO currentDto = adminApprovalDAO.selectByConfirmNumber(judgeDTO.getConfirmNumber());
        if (currentDto == null) {
            log.error("Application {} not found in database!", judgeDTO.getConfirmNumber());
            return false;
        }
        log.info("Current status: {}", currentDto.getStatusCode());

        // 3. 승인 처리
        ConfirmApplyDTO updateDto = ConfirmApplyDTO.builder()
                .confirmNumber(judgeDTO.getConfirmNumber())
                .processorId(userId)
                .statusCode("ST_50") 
                .rejectionReasonCode(null) 
                .rejectComment(null)       
                .build();

        log.info("Executing update with: confirmNumber={}, processorId={}, statusCode=ST_50", 
                 updateDto.getConfirmNumber(), updateDto.getProcessorId());
        
        int result = adminApprovalDAO.updateAdminJudge(updateDto);
        log.info("Update result: {} rows affected", result);
        
        if (result > 0) {
            log.info("Application {} approved successfully.", judgeDTO.getConfirmNumber());
            return true;
        } else {
            log.error("Failed to approve application {} - No rows updated!", judgeDTO.getConfirmNumber());
            return false;
        }
    }

    // 반려 처리
    public boolean adminReject(AdminJudgeDTO judgeDTO, Long userId) {
        log.info("=== Admin Reject Request ===");
        log.info("confirmNumber: {}", judgeDTO.getConfirmNumber());
        log.info("userId: {}", userId);
        log.info("rejectionReasonCode: {}", judgeDTO.getRejectionReasonCode());

        // 1. 필수값 체크
        if (judgeDTO.getRejectionReasonCode() == null || judgeDTO.getRejectionReasonCode().isEmpty()) {
            log.warn("Rejection failed: RejectionReasonCode is missing for confirmNumber {}", judgeDTO.getConfirmNumber());
            return false;
        }
        
        // 2. 이미 처리된 신청인지 확인
        int processedCount = adminApprovalDAO.isProcessed(judgeDTO.getConfirmNumber());
        log.info("isProcessed count: {}", processedCount);
        
        if (processedCount > 0) {
            log.warn("Application {} is already processed.", judgeDTO.getConfirmNumber());
            return false;
        }

        // 3. 현재 데이터 조회
        ConfirmApplyDTO currentDto = adminApprovalDAO.selectByConfirmNumber(judgeDTO.getConfirmNumber());
        if (currentDto == null) {
            log.error("Application {} not found in database!", judgeDTO.getConfirmNumber());
            return false;
        }
        log.info("Current status: {}", currentDto.getStatusCode());
        
        // 4. 반려 처리
        ConfirmApplyDTO updateDto = ConfirmApplyDTO.builder()
                .confirmNumber(judgeDTO.getConfirmNumber())
                .processorId(userId)
                .statusCode("ST_60")
                .rejectionReasonCode(judgeDTO.getRejectionReasonCode())
                .rejectComment(judgeDTO.getRejectComment())
                .build();
        
        log.info("Executing update with: confirmNumber={}, processorId={}, statusCode=ST_60, reasonCode={}", 
                 updateDto.getConfirmNumber(), updateDto.getProcessorId(), updateDto.getRejectionReasonCode());
        
        int result = adminApprovalDAO.updateAdminJudge(updateDto);
        log.info("Update result: {} rows affected", result);
        
        if (result > 0) {
            log.info(" Application {} rejected successfully.", judgeDTO.getConfirmNumber());
            return true;
        } else {
            log.error("Failed to reject application {} - No rows updated!", judgeDTO.getConfirmNumber());
            return false;
        }
    }
    
    // 처리 완료 여부 
    public boolean adminChecked(Long confirmNumber) {
        return adminApprovalDAO.isProcessed(confirmNumber) > 0;
    }
    // 심사중으로 변경
 	public void updateStatusCode(Long confirmNumber) {
 		
 		adminApprovalDAO.updateStatusCode(confirmNumber);
 	}
}