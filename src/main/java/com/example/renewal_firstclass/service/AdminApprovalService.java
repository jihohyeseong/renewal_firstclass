package com.example.renewal_firstclass.service;

import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList; // 삭제 (새 로직에서는 미사용)
import java.util.List;
import java.util.stream.Collectors; // ### 추가 ###

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.renewal_firstclass.dao.AdminApprovalDAO;
import com.example.renewal_firstclass.dao.ConfirmApplyDAO;
import com.example.renewal_firstclass.dao.TermAmountDAO; // ### 추가 ###
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
    private final CompanyApplyService companyApplyService; 
    private final TermAmountDAO termAmountDAO;
    
    // 신청 상세 조회
    public ConfirmApplyDTO getConfirmForEditing(Long confirmNumber) {
        // 원본 데이터 조회
        ConfirmApplyDTO originalDto = adminApprovalDAO.selectByConfirmNumber(confirmNumber);
        if (originalDto == null) return null;

        // 수정된 데이터 포함 조회 
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
            originalDto.setUpdName(updatesDto.getUpdName());
            originalDto.setUpdRegistrationNumber(updatesDto.getUpdRegistrationNumber());
        }

        // 주민번호 복호화
        try {
            if (originalDto.getRegistrationNumber() != null && !originalDto.getRegistrationNumber().trim().isEmpty()) {
                originalDto.setRegistrationNumber(aes256Util.decrypt(originalDto.getRegistrationNumber()));
            }
            if (originalDto.getChildResiRegiNumber() != null && !originalDto.getChildResiRegiNumber().trim().isEmpty()) {
                originalDto.setChildResiRegiNumber(aes256Util.decrypt(originalDto.getChildResiRegiNumber()));
            }
            if (originalDto.getUpdRegistrationNumber() != null && !originalDto.getUpdRegistrationNumber().trim().isEmpty()) {
                originalDto.setUpdRegistrationNumber(aes256Util.decrypt(originalDto.getUpdRegistrationNumber()));
            }
            if (originalDto.getUpdChildResiRegiNumber() != null && !originalDto.getUpdChildResiRegiNumber().trim().isEmpty()) {
                originalDto.setUpdChildResiRegiNumber(aes256Util.decrypt(originalDto.getUpdChildResiRegiNumber()));
            }
        } catch (Exception ignore) {}

        // 원본 단위기간과 수정된 단위기간을 각각 조회하여 DTO에 설정
        originalDto.setTermAmounts(adminApprovalDAO.selectOriginalTermAmounts(confirmNumber));
        originalDto.setUpdatedTermAmounts(adminApprovalDAO.selectUpdatedTermAmounts(confirmNumber));
        
        return originalDto;
    }


    // 승인 처리
    public boolean adminApprove(AdminJudgeDTO judgeDTO, Long userId) {
        // 이미 처리된 신청인지 확인
        int processedCount = adminApprovalDAO.isProcessed(judgeDTO.getConfirmNumber());
        
        if (processedCount > 0) {
            return false;
        }

        // 현재 데이터 조회
        ConfirmApplyDTO currentDto = adminApprovalDAO.selectByConfirmNumber(judgeDTO.getConfirmNumber());
        if (currentDto == null) {
            log.error("Application {} not found in database!", judgeDTO.getConfirmNumber());
            return false;
        }

        // 승인 처리
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
        // 필수값 체크
        if (judgeDTO.getRejectionReasonCode() == null || judgeDTO.getRejectionReasonCode().isEmpty()) {
            log.warn("Rejection failed: RejectionReasonCode is missing for confirmNumber {}", judgeDTO.getConfirmNumber());
            return false;
        }
        
        // 이미 처리된 신청인지 확인
        int processedCount = adminApprovalDAO.isProcessed(judgeDTO.getConfirmNumber());
        
        if (processedCount > 0) {
            log.warn("Application {} is already processed.", judgeDTO.getConfirmNumber());
            return false;
        }

        // 현재 데이터 조회
        ConfirmApplyDTO currentDto = adminApprovalDAO.selectByConfirmNumber(judgeDTO.getConfirmNumber());
        if (currentDto == null) {
            log.error("Application {} not found in database!", judgeDTO.getConfirmNumber());
            return false;
        }
        
        // 반려 처리
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
        // 암호화
        try {
            if (dto.getUpdRegistrationNumber() != null && !dto.getUpdRegistrationNumber().trim().isEmpty())
                dto.setUpdRegistrationNumber(aes256Util.encrypt(dto.getUpdRegistrationNumber()));
            if (dto.getUpdChildResiRegiNumber() != null && !dto.getUpdChildResiRegiNumber().trim().isEmpty())
                dto.setUpdChildResiRegiNumber(aes256Util.encrypt(dto.getUpdChildResiRegiNumber()));
        } catch (Exception e) {
            throw new IllegalStateException("개인정보 암호화 오류", e);
        }
        
        Long confirmNumber = dto.getConfirmNumber();

        // TB_CONFIRM_APPLICATION 테이블의 upd_ 컬럼들 업데이트
        adminApprovalDAO.updateConfirmEdit(dto);

        // 단위기간 재계산이 필요한지 여부
        List<Long> monthlyCompanyPay = dto.getMonthlyCompanyPay();
        boolean needsRecalculation = (dto.getUpdStartDate() != null ||
                                      dto.getUpdEndDate() != null ||
                                      (dto.getUpdRegularWage() != null && dto.getUpdRegularWage() > 0) ||
                                      (monthlyCompanyPay != null && !monthlyCompanyPay.isEmpty()));

        // 재계산이 필요할 경우에만 단위기간 관련 로직 수행
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
            
            // 검색 기준이 될 자녀 생년월일과 암호화된 주민번호 결정
            Date searchChildBirthDate = (dto.getUpdChildBirthDate() != null) 
                                    ? dto.getUpdChildBirthDate() 
                                    : originalData.getChildBirthDate();
            
            // dto의 updRegistrationNumber는 메서드 상단에서 이미 암호화되었음
            String searchRegNo = (dto.getUpdRegistrationNumber() != null && !dto.getUpdRegistrationNumber().trim().isEmpty()) 
                                    ? dto.getUpdRegistrationNumber() 
                                    : originalData.getRegistrationNumber();
            
            Long currentConfirmNumber = dto.getConfirmNumber();

            // 이전 승인 건들 조회 (현재 수정 건 제외)
            List<Long> previousConfirmNumbers = confirmApplyDAO.findMyConfirmList(
                searchChildBirthDate, 
                searchRegNo
            );
            if (previousConfirmNumbers != null && currentConfirmNumber != null) {
                previousConfirmNumbers = previousConfirmNumbers.stream()
                        .filter(num -> !num.equals(currentConfirmNumber))
                        .collect(Collectors.toList());
            }

            // 최초 휴직 시작일 조회
            java.sql.Date sqlStartDate = confirmApplyDAO.findFirstStartDateForPerson(
                searchChildBirthDate, 
                searchRegNo,
                currentConfirmNumber // 현재 수정 건 제외
            );
            LocalDate firstEverStartDate = (sqlStartDate != null) ? sqlStartDate.toLocalDate() : null;
            if (firstEverStartDate == null) {
                firstEverStartDate = s; // 이전 이력이 없으면 지금이 최초
            }

            // 이전 누적 일수 계산 (TermAmountDAO 주입 필요)
            long totalPreviousDays = 0;
            if (previousConfirmNumbers != null && !previousConfirmNumbers.isEmpty()) {
                List<TermAmountDTO> previousTerms = termAmountDAO.selectTermsByConfirmNumbers(previousConfirmNumbers);
                for (TermAmountDTO term : previousTerms) {
                    if (term.getStartMonthDate() != null && term.getEndMonthDate() != null) {
                        totalPreviousDays += ChronoUnit.DAYS.between(
                            term.getStartMonthDate().toLocalDate(), 
                            term.getEndMonthDate().toLocalDate()
                        ) + 1;
                    }
                }
            }

            // 단위기간 재계산 (CompanyApplyService 주입 필요)
            List<TermAmountDTO> updatedTerms = companyApplyService.calculateTerms(
                s, e, wage, monthlyCompanyPay, firstEverStartDate, totalPreviousDays
            );
            
            // 재계산된 단위기간을 update_at='Y'로 삽입
            if (!updatedTerms.isEmpty()) {
                for (TermAmountDTO t : updatedTerms) {
                    t.setConfirmNumber(confirmNumber);
                    t.setUpdateAt("Y"); 
                }
                adminApprovalDAO.insertUpdatedTermAmounts(updatedTerms);
            }
        } else {
             log.info("단위기간 관련 정보가 수정되지 않아 재계산을 건너뜁니다. ConfirmNumber: {}", confirmNumber);
        }

        return true;
    }
    

}