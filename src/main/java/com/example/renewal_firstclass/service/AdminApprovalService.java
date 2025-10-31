package com.example.renewal_firstclass.service;

import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.renewal_firstclass.dao.AdminApprovalDAO;
import com.example.renewal_firstclass.dao.ConfirmApplyDAO;
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
    private final AES256Util aes256Util;
    
    // 신청 상세 조회
    public ConfirmApplyDTO getConfirmForEditing(Long confirmNumber) {

        // 1. 원본 데이터 조회
        ConfirmApplyDTO originalDto = confirmApplyDAO.selectByConfirmNumber(confirmNumber);
        if (originalDto == null) return null;

        // 2. 수정된 데이터 포함 조회 
        ConfirmApplyDTO updatesDto = adminApprovalDAO.selectByConfirmNumberWithUpdates(confirmNumber);
        if (updatesDto != null) {
            // upd컬럼 업데이트
            originalDto.setUpdStartDate(updatesDto.getUpdStartDate());
            originalDto.setUpdEndDate(updatesDto.getUpdEndDate());
            originalDto.setUpdWeeklyHours(updatesDto.getUpdWeeklyHours());
            originalDto.setUpdRegularWage(updatesDto.getUpdRegularWage());
            originalDto.setUpdChildName(updatesDto.getUpdChildName());
            originalDto.setUpdChildResiRegiNumber(updatesDto.getUpdChildResiRegiNumber());
            originalDto.setUpdChildBirthDate(updatesDto.getUpdChildBirthDate());
        }

        // 3. 주민번호 복호화
        try {
            if (originalDto.getRegistrationNumber() != null && !originalDto.getRegistrationNumber().trim().isEmpty()) {
                originalDto.setRegistrationNumber(aes256Util.decrypt(originalDto.getRegistrationNumber()));
            }
            if (originalDto.getChildResiRegiNumber() != null && !originalDto.getChildResiRegiNumber().trim().isEmpty()) {
                originalDto.setChildResiRegiNumber(aes256Util.decrypt(originalDto.getChildResiRegiNumber()));
            }
        } catch (Exception ignore) {}

        // 4. 원본 단위기간과 수정된 단위기간을 각각 조회하여 DTO에 설정
        originalDto.setTermAmounts(adminApprovalDAO.selectOriginalTermAmounts(confirmNumber));
        originalDto.setUpdatedTermAmounts(adminApprovalDAO.selectUpdatedTermAmounts(confirmNumber));
        
        return originalDto;
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
 	
 	// 수정 업데이트
 	public boolean updateConfirm(ConfirmApplyDTO dto) {

 		int result = adminApprovalDAO.updateConfirmEdit(dto);
 		return result > 0;
 	}
 	
 	// 수정사항 저장
 	@Transactional
 	public boolean saveConfirmEdits(ConfirmApplyDTO dto) {
 		Long confirmNumber = dto.getConfirmNumber();

 		// 1. TB_CONFIRM_APPLICATION 테이블의 upd_ 컬럼들 업데이트
        adminApprovalDAO.updateConfirmEdit(dto);

        // 2. 단위기간 재계산이 필요한지 여부
        List<Long> monthlyCompanyPay = dto.getMonthlyCompanyPay();
        boolean needsRecalculation = (dto.getUpdStartDate() != null ||
                                      dto.getUpdEndDate() != null ||
                                      (dto.getUpdRegularWage() != null && dto.getUpdRegularWage() > 0) ||
                                      (monthlyCompanyPay != null && !monthlyCompanyPay.isEmpty()));

        // 3. 재계산이 필요할 경우에만 단위기간 관련 로직 수행
        if (needsRecalculation) {
            log.info("단위기간 재계산을 시작합니다. ConfirmNumber: {}", confirmNumber);
            
            // 단위기간 테이블에서 update_at='Y' 데이터가 있는지 확인
            int existingUpdatedCount = adminApprovalDAO.countUpdatedTerms(confirmNumber);

            if (existingUpdatedCount > 0) {
                // 재수정이므로 이전 'Y'데이터 삭제후 update_at='Y' 테이블 새로 추가
                log.info("재수정으로 감지. 기존 수정 데이터(Y)를 삭제합니다.");
                adminApprovalDAO.deleteUpdatedTerms(confirmNumber);
            } else {
                // 최초 수정이므로 update_at='Y'로 테이블 새로 추가&원본 데이터의 delt_at을 'Y'로 업데이트
                log.info("최초 수정으로 감지. 원본 데이터(N)를 delt_at='Y'로 처리합니다.");
                adminApprovalDAO.markOriginalTermsAsDeleted(confirmNumber);
            }
            
            // DB에서 최신 원본 데이터를 다시 조회
            ConfirmApplyDTO originalData = confirmApplyDAO.selectByConfirmNumber(confirmNumber);
            if (originalData == null) {
                log.error("Original confirmation data not found for confirmNumber: {}", confirmNumber);
                throw new IllegalStateException("원본 확인서 정보를 찾을 수 없습니다.");
            }

            // 재계산에 사용될 값 결정 
            Date sDate = dto.getUpdStartDate() != null ? dto.getUpdStartDate() : originalData.getStartDate();
            Date eDate = dto.getUpdEndDate() != null ? dto.getUpdEndDate() : originalData.getEndDate();
            Long wage = (dto.getUpdRegularWage() != null && dto.getUpdRegularWage() > 0) ? dto.getUpdRegularWage() : originalData.getRegularWage();
            
            if (sDate == null || eDate == null || wage == null) {
                 throw new IllegalStateException("단위기간 계산에 필요한 시작일, 종료일, 또는 통상임금 정보가 없습니다.");
            }

            LocalDate s = sDate.toLocalDate();
            LocalDate e = eDate.toLocalDate();
            
            // 단위기간 재계산
            List<TermAmountDTO> updatedTerms = calculateUpdatedTerms(s, e, wage, monthlyCompanyPay);
            
            // 재계산된 단위기간을 update_at='Y'로 삽입
            if (!updatedTerms.isEmpty()) {
                for (TermAmountDTO t : updatedTerms) {
                    t.setConfirmNumber(confirmNumber);
                }
                adminApprovalDAO.insertUpdatedTermAmounts(updatedTerms);
            }
        } else {
             log.info("단위기간 관련 정보가 수정되지 않아 재계산을 건너뜁니다. ConfirmNumber: {}", confirmNumber);
        }

        return true;
    }
 	
 	// 재계산 로직(확인서에서 그대로 가져옴)
 	private List<TermAmountDTO> calculateUpdatedTerms(LocalDate start, LocalDate end, long regularWage, List<Long> monthlyCompanyPay) {
 	    List<TermAmountDTO> list = new ArrayList<>();
 	    LocalDate curStart = start;
 	    int monthIdx = 1;

 	    while (!curStart.isAfter(end) && monthIdx <= 12) {
 	        LocalDate nextStart = start.plusMonths(monthIdx);
 	        if (nextStart.getDayOfMonth() != start.getDayOfMonth()) {
 	            nextStart = nextStart.plusMonths(1).withDayOfMonth(1);
 	        }
 	        LocalDate theoreticalEnd = nextStart.minusDays(1);
 	        LocalDate actualEnd = theoreticalEnd.isAfter(end) ? end : theoreticalEnd;
 	        if (curStart.isAfter(actualEnd)) break;

 	        long companyPay = (monthlyCompanyPay != null && monthlyCompanyPay.size() >= monthIdx)
 	                ? (monthlyCompanyPay.get(monthIdx - 1) == null ? 0L : monthlyCompanyPay.get(monthIdx - 1))
 	                : 0L;

 	        long monthlyCap;
 	        if (monthIdx <= 3) monthlyCap = Math.min(regularWage, 2_500_000L);
 	        else if (monthIdx <= 6) monthlyCap = Math.min(regularWage, 2_000_000L);
 	        else monthlyCap = Math.min(Math.round(regularWage * 0.8), 1_600_000L);

 	        long daysInTerm = ChronoUnit.DAYS.between(curStart, actualEnd) + 1;
 	        long daysInFull = ChronoUnit.DAYS.between(curStart, theoreticalEnd) + 1;
 	        long proratedCap = (daysInTerm >= daysInFull)
 	                ? monthlyCap
 	                : ((long) Math.floor((monthlyCap * (double) daysInTerm / daysInFull) / 10)) * 10;

 	        long gov = Math.min(proratedCap, Math.max(0L, regularWage - companyPay));
 	        gov = (gov / 10L) * 10L;

 	        TermAmountDTO t = TermAmountDTO.builder()
 	                .startMonthDate(Date.valueOf(curStart))
 	                .endMonthDate(Date.valueOf(actualEnd))
 	                .paymentDate(Date.valueOf(actualEnd.plusDays(1)))
 	                .companyPayment(companyPay)
 	                .govPayment(gov)
 	                .updateAt("Y")
 	                .build();

 	        list.add(t);
 	        curStart = actualEnd.plusDays(1);
 	        monthIdx++;
 	    }
 	    return list;
 	}


}