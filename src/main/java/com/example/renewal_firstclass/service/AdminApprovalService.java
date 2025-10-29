package com.example.renewal_firstclass.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
    
    // 수정값 상세 조회
    public ConfirmApplyDTO getConfirmDetailWithUpdates(Long confirmNumber) {
   
        ConfirmApplyDTO dto = adminApprovalDAO.selectByConfirmNumberWithUpdates(confirmNumber);
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
    
        // 1. 이미 처리된 신청인지 확인
        int processedCount = adminApprovalDAO.isProcessed(judgeDTO.getConfirmNumber());
        
        if (processedCount > 0) {
            return false;
        }

        // 2. 현재 데이터 조회
        ConfirmApplyDTO currentDto = adminApprovalDAO.selectByConfirmNumber(judgeDTO.getConfirmNumber());
        if (currentDto == null) {
            log.error("Application {} not found in database!", judgeDTO.getConfirmNumber());
            return false;
        }

        // 3. 승인 처리
        ConfirmApplyDTO updateDto = ConfirmApplyDTO.builder()
                .confirmNumber(judgeDTO.getConfirmNumber())
                .processorId(userId)
                .statusCode("ST_50") 
                .rejectionReasonCode(null) 
                .rejectComment(null)       
                .build();
        
        int result = adminApprovalDAO.updateAdminJudge(updateDto);
        
        if (result > 0) {
            return true;
        } else {
            log.error("Failed to approve application {} - No rows updated!", judgeDTO.getConfirmNumber());
            return false;
        }
    }

    // 반려 처리
    public boolean adminReject(AdminJudgeDTO judgeDTO, Long userId) {

        // 1. 필수값 체크
        if (judgeDTO.getRejectionReasonCode() == null || judgeDTO.getRejectionReasonCode().isEmpty()) {
            log.warn("Rejection failed: RejectionReasonCode is missing for confirmNumber {}", judgeDTO.getConfirmNumber());
            return false;
        }
        
        // 2. 이미 처리된 신청인지 확인
        int processedCount = adminApprovalDAO.isProcessed(judgeDTO.getConfirmNumber());
        
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
        
        // 4. 반려 처리
        ConfirmApplyDTO updateDto = ConfirmApplyDTO.builder()
                .confirmNumber(judgeDTO.getConfirmNumber())
                .processorId(userId)
                .statusCode("ST_60")
                .rejectionReasonCode(judgeDTO.getRejectionReasonCode())
                .rejectComment(judgeDTO.getRejectComment())
                .build();
        
        int result = adminApprovalDAO.updateAdminJudge(updateDto);
        
        if (result > 0) {
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
 	// 확인서 수정 업데이트
    @Transactional
    public boolean updateConfirm(ConfirmApplyDTO dto) {
        
        // 1. UPD 컬럼 업데이트 시도
        // TB_CONFIRM_APPLICATION의 UPD 컬럼만 업데이트하고, TB_TERM_AMOUNT의 상태는 변경하지 않음
        int result = adminApprovalDAO.updateConfirmEdit(dto);
        if (result <= 0) {
            log.error("Failed to update confirm application basic info (UPD columns)");
            // TB_CONFIRM_APPLICATION 테이블에서 업데이트된 행이 없는 경우
            return false;
        }

        // 2. 단위기간 데이터 처리
        if (dto.getUpdatedTermAmounts() != null && !dto.getUpdatedTermAmounts().isEmpty()) {
            
            // 2-1. UPD 컬럼이 NULL이 아닌지 확인 
            int updColumnsCount = adminApprovalDAO.checkUpdColumnsExist(dto.getConfirmNumber());
            
            // 2-2. 기존 단위기간 데이터 상태 변경 
            // N -> Y로 처리
            adminApprovalDAO.updateTermAmountStatusToY(dto.getConfirmNumber());
            log.info("Original term amounts status updated to 'Y' for confirmNumber: {}", dto.getConfirmNumber());

            // 2-3. 이전에 삽입했던 수정 단위기간('Y') 데이터 정리
            // 두번째 이상 수정일 경우 Y인 데이터 삭제 후 새로운 단위기간 삽입
            if (updColumnsCount > 0) {
                adminApprovalDAO.deleteUpdatedTerms(dto.getConfirmNumber());
                log.info("Deleted existing updated terms ('Y' flag) for confirmNumber: {}", dto.getConfirmNumber());
            }
            
            // 2-4. 최초 수정: 새로운 단위기간 데이터 삽입 (update_at='Y'로)
            try {
                // PL/SQL 또는 INSERT ALL 사용 시, insertResult 확인 대신 DB 예외를 기다리는 것이 안전합니다.
                adminApprovalDAO.insertUpdatedTermAmounts(dto.getUpdatedTermAmounts()); 
            } catch (Exception e) {
                // 삽입 실패 시, 근본 원인(DB 예외)을 로그에 찍습니다.
                log.error("--- DB INSERT FAILED --- Cause of failure:", e); 
                // 실패 원인 e를 포함하여 재발행 (트랜잭션 롤백 유도)
                throw new RuntimeException("Failed to insert new term amounts", e); 
            }
            // (insertResult 변수 제거 및 if (insertResult <= 0) 조건문 제거)
            
            log.info("Successfully inserted {} new term amounts for confirmNumber: {}", 
                     dto.getUpdatedTermAmounts().size(), dto.getConfirmNumber());
        }
        
        return true;
    }
}