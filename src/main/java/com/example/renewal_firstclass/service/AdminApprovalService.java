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
 	
 	// 수정 업데이트
 	public boolean updateConfirm(ConfirmApplyDTO dto) {

 		int result = adminApprovalDAO.updateConfirmEdit(dto);
 		return result > 0;
 	}
 	
 	// 수정사항 저장
 	@Transactional
 	public boolean saveConfirmEdits(ConfirmApplyDTO dto) {
 		Long confirmNumber = dto.getConfirmNumber();

 	    // ★★★ 1. DB 원본 데이터 조회 (필수: DTO 값이 null일 때 사용) ★★★
 	    // confirmApplyDAO는 원본 데이터(upd_xx가 없는)를 조회하는 메서드라고 가정합니다.
 	    ConfirmApplyDTO originalData = confirmApplyDAO.selectByConfirmNumber(confirmNumber);
 	    if (originalData == null) {
 	        log.error("Original confirmation data not found for confirmNumber: {}", confirmNumber);
 	        return false;
 	    }

 	    List<Long> monthlyCompanyPay = dto.getMonthlyCompanyPay();

 	    // upd 컬럼 업데이트
 	    int updated = adminApprovalDAO.updateConfirmEdit(dto);
 	    // 업데이트 실패(수정사항이 없거나 DB 오류)는 재계산이 필요한지를 결정하는 updExists와 별개로 처리할 수 있습니다.
 	    // 여기서는 일단 업데이트가 성공해야만 다음 로직을 진행한다고 가정하고, 업데이트가 안되면 return false;
 	    // 만약 월별 지급액만 수정될 수 있다면 이 updated == 0 체크는 제거해야 합니다.
 	    if (updated == 0) {
 	         // 월별 지급액 수정만 있는 경우를 허용하기 위해 잠시 주석 처리하거나,
 	         // 월별 지급액이 있으면 통과시키도록 로직 변경이 필요함
 	         // return false; 
 	    } 

 	    // upd 컬럼 존재 여부 확인 (upd_start_date 등이 DB에 Y/N이 아닌 실제로 값이 있는지 체크하는 DAO 메서드)
 	    int updExists = adminApprovalDAO.checkUpdColumnsExist(confirmNumber);
 	    
 	    // 재계산된 단위기간을 담을 리스트
 	    List<TermAmountDTO> updatedTerms;

 	    // 단위기간 테이블 처리
 	    // upd 필드가 수정되었거나, 월별 지급액 리스트가 넘어온 경우 재계산을 수행
 	    if (updExists > 0 || (monthlyCompanyPay != null && !monthlyCompanyPay.isEmpty())) {
 	        
 	        // (1) 기존 Y데이터 삭제
 	        adminApprovalDAO.deleteUpdatedTerms(confirmNumber);

 	        Date sDate = dto.getUpdStartDate() != null ? dto.getUpdStartDate()
 	                   : dto.getStartDate() != null ? dto.getStartDate()
 	                   : originalData.getStartDate(); // ★ 안전 장치

 	        Date eDate = dto.getUpdEndDate() != null ? dto.getUpdEndDate()
 	                   : dto.getEndDate() != null ? dto.getEndDate()
 	                   : originalData.getEndDate(); // ★ 안전 장치

 	        Long wage = dto.getUpdRegularWage() != null ? dto.getUpdRegularWage()
 	                  : dto.getRegularWage() != null ? dto.getRegularWage()
 	                  : originalData.getRegularWage(); // ★ 안전 장치

 	        // Date 객체를 toLocalDate()로 안전하게 변환
 	        // sDate, eDate, wage는 originalData 덕분에 절대 null이 아닙니다.
 	        LocalDate s = sDate.toLocalDate(); 
 	        LocalDate e = eDate.toLocalDate();
 	        
 	        updatedTerms = calculateUpdatedTerms(s, e, wage, monthlyCompanyPay);
 	        
 	    } else {
 	        
 	        // ★★★ 이 else 블록은 삭제하거나, 아래처럼 원본을 기준으로만 재계산을 해야 합니다. ★★★
 	        adminApprovalDAO.deleteUpdatedTerms(confirmNumber);
 	        
 	        LocalDate s = originalData.getStartDate().toLocalDate();
 	        LocalDate e = originalData.getEndDate().toLocalDate();
 	        Long wage = originalData.getRegularWage();

 	        // monthlyCompanyPay는 이 블록에서 null일 가능성이 높으므로 null로 전달됨
 	        updatedTerms = calculateUpdatedTerms(s, e, wage, null); 
 	    }
 	    
 	    // (3) 공통 로직: update_at = 'Y' 지정 및 삽입
 	    for (TermAmountDTO t : updatedTerms) {
 	        t.setConfirmNumber(confirmNumber);
 	        t.setUpdateAt("Y");
 	    }

 	    adminApprovalDAO.insertUpdatedTermAmounts(updatedTerms);

 	    return true;
 	}
 	
 	// 재계산 로직
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