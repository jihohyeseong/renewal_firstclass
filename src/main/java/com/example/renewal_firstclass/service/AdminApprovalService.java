package com.example.renewal_firstclass.service;

import org.springframework.stereotype.Service;

import com.example.renewal_firstclass.dao.AdminApprovalDAO;
import com.example.renewal_firstclass.domain.AdminJudgeDTO;
import com.example.renewal_firstclass.domain.ConfirmApplyDTO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j 
public class AdminApprovalService {

    private final AdminApprovalDAO adminApprovalDAO;
    /**
     * 신청 상세 조회
     */
    public ConfirmApplyDTO getConfirmDetail(Long confirmNumber) {
        log.info("=== Get Confirm Detail ===");
        log.info("confirmNumber: {}", confirmNumber);
        return adminApprovalDAO.selectByConfirmNumber(confirmNumber);
    }

    /**
     * 관리자 승인 처리
     */
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
            log.info("✅ Application {} approved successfully.", judgeDTO.getConfirmNumber());
            return true;
        } else {
            log.error("❌ Failed to approve application {} - No rows updated!", judgeDTO.getConfirmNumber());
            return false;
        }
    }

    /**
     * 관리자 반려 처리
     */
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
            log.info("✅ Application {} rejected successfully.", judgeDTO.getConfirmNumber());
            return true;
        } else {
            log.error("❌ Failed to reject application {} - No rows updated!", judgeDTO.getConfirmNumber());
            return false;
        }
    }
    
    /**
     * 처리 완료 여부 확인
     */
    public boolean adminChecked(Long confirmNumber) {
        return adminApprovalDAO.isProcessed(confirmNumber) > 0;
    }
}