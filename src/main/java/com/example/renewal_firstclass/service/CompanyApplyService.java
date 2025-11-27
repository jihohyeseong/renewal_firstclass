package com.example.renewal_firstclass.service;

import java.sql.Date; // ### java.sql.Date 임포트 확인 ###
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.renewal_firstclass.dao.ConfirmApplyDAO;
import com.example.renewal_firstclass.dao.TermAmountDAO;
import com.example.renewal_firstclass.domain.ConfirmApplyDTO;
import com.example.renewal_firstclass.domain.ConfirmListDTO;
import com.example.renewal_firstclass.domain.TermAmountDTO;
import com.example.renewal_firstclass.util.AES256Util;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CompanyApplyService {

    private final ConfirmApplyDAO confirmApplyDAO;
    private final TermAmountDAO termAmountDAO;
    private final AES256Util aes256Util;
    private final AttachedFileService attachedFileService;


    /*신규 저장 */
    @Transactional
    public Long createConfirm(ConfirmApplyDTO dto,
                              List<Long> monthlyCompanyPay) {
        try {
            if (notBlank(dto.getRegistrationNumber()))
                dto.setRegistrationNumber(aes256Util.encrypt(dto.getRegistrationNumber()));
            if (notBlank(dto.getChildResiRegiNumber()))
                dto.setChildResiRegiNumber(aes256Util.encrypt(dto.getChildResiRegiNumber()));
        } catch (Exception e) {
            throw new IllegalStateException("개인정보 암호화 오류", e);
        }

        // 확인서 저장
        dto.setStatusCode("ST_10");
        int rows = confirmApplyDAO.insertConfirmApplication(dto);
        if (rows != 1 || dto.getConfirmNumber() == null) {
            throw new IllegalStateException("확인서 저장 실패");
        }

        // 단위기간
        LocalDate s = dto.getStartDate() == null ? null : dto.getStartDate().toLocalDate();
        LocalDate e = dto.getEndDate()   == null ? null : dto.getEndDate().toLocalDate();
        Long wage = dto.getRegularWage();

        if (s != null && e != null && wage != null && !e.isBefore(s)) {

            List<Long> previousConfirmNumbers = confirmApplyDAO.findMyConfirmList(
                dto.getChildBirthDate(), 
                dto.getRegistrationNumber()
            );
            
            java.sql.Date sqlStartDate = confirmApplyDAO.findFirstStartDateForPerson(
                dto.getChildBirthDate(), 
                dto.getRegistrationNumber(),
                null 
            );
            LocalDate firstEverStartDate = (sqlStartDate != null) ? sqlStartDate.toLocalDate() : null;

            if (firstEverStartDate == null) {
                firstEverStartDate = s;
            }

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
            
            deleteTerms(dto.getConfirmNumber());
            List<TermAmountDTO> terms = calculateTerms(s, e, wage, monthlyCompanyPay, 
                                                    firstEverStartDate, totalPreviousDays);
            saveTerms(dto.getConfirmNumber(), terms);
        }

        return dto.getConfirmNumber();
    }

    /** 상세보기에서 제출*/
    @Transactional
    public void submitConfirm(Long confirmNumber, Long userId) {
        int rows = confirmApplyDAO.submitConfirm(confirmNumber, userId);
        if (rows != 1) throw new IllegalStateException("제출 실패(이미 제출/권한)");
    }

    /** 기존 단위기간 삭제 */
    @Transactional
    public void deleteTerms(Long confirmNumber) {
        if (confirmNumber == null) return;
        termAmountDAO.deleteTermsByConfirmId(confirmNumber);
    }


    private LocalDate getGlobalTheoreticalEnd(LocalDate firstEverStartDate, int months) {
        LocalDate nextStart = firstEverStartDate.plusMonths(months);
        if (nextStart.getDayOfMonth() != firstEverStartDate.getDayOfMonth()) {
            nextStart = nextStart.plusMonths(1).withDayOfMonth(1);
        }
        return nextStart.minusDays(1);
    }


    private long getCapByCumulativeDay(LocalDate firstEverStartDate, long cumulativeDay, long regularWage) {
        LocalDate end3Months = getGlobalTheoreticalEnd(firstEverStartDate, 3);
        long daysIn3Months = ChronoUnit.DAYS.between(firstEverStartDate, end3Months) + 1;

        LocalDate end6Months = getGlobalTheoreticalEnd(firstEverStartDate, 6);
        long daysIn6Months = ChronoUnit.DAYS.between(firstEverStartDate, end6Months) + 1;

        LocalDate end12Months = getGlobalTheoreticalEnd(firstEverStartDate, 12);
        long daysIn12Months = ChronoUnit.DAYS.between(firstEverStartDate, end12Months) + 1;

        
        if (cumulativeDay <= daysIn3Months) {          // 1~3개월차 (예: 1~90일)
            return Math.min(regularWage, 2_500_000L);
        } else if (cumulativeDay <= daysIn6Months) {   // 4~6개월차 (예: 91~181일)
            return Math.min(regularWage, 2_000_000L);
        } else if (cumulativeDay <= daysIn12Months) {  // 7~12개월차 (예: 182~365일)
            return Math.min(Math.round(regularWage * 0.8), 1_600_000L);
        } else {
            return 0L; // 12개월 초과
        }
    }



    public List<TermAmountDTO> calculateTerms(LocalDate newStart, LocalDate newEnd,
            long regularWage,
            List<Long> monthlyCompanyPay,
            LocalDate firstEverStartDate, 
            long totalPreviousDays) { 
    	
		if (newStart == null || newEnd == null) throw new IllegalArgumentException("기간 누락");
		if (newEnd.isBefore(newStart)) throw new IllegalArgumentException("종료일이 시작일보다 빠릅니다.");
		
		List<TermAmountDTO> list = new ArrayList<>();
		
		LocalDate curProcessingDate = newStart; 
		long cumulativeDay = totalPreviousDays + 1; 
		int localMonthIdx = 1; 

		LocalDate end12Months = getGlobalTheoreticalEnd(firstEverStartDate, 12);
		long daysIn12Months = ChronoUnit.DAYS.between(firstEverStartDate, end12Months) + 1;

		LocalDate end3Months = getGlobalTheoreticalEnd(firstEverStartDate, 3);
		long daysIn3Months = ChronoUnit.DAYS.between(firstEverStartDate, end3Months) + 1; 
		LocalDate end6Months = getGlobalTheoreticalEnd(firstEverStartDate, 6);
		long daysIn6Months = ChronoUnit.DAYS.between(firstEverStartDate, end6Months) + 1; 
		

		while (!curProcessingDate.isAfter(newEnd) && cumulativeDay <= daysIn12Months) {

			LocalDate localMonthStart = curProcessingDate;
			
			LocalDate localNextStart = newStart.plusMonths(localMonthIdx);
			if (localNextStart.getDayOfMonth() != newStart.getDayOfMonth()) {
				localNextStart = localNextStart.plusMonths(1).withDayOfMonth(1);
			}
			LocalDate localTheoreticalEnd = localNextStart.minusDays(1); 
			
			LocalDate localMonthEnd = localTheoreticalEnd.isAfter(newEnd) ? newEnd : localTheoreticalEnd; 
			
			if (localMonthStart.isAfter(localMonthEnd)) 
				break;
			
			long companyPay = (monthlyCompanyPay != null && monthlyCompanyPay.size() >= localMonthIdx)
			? nz(monthlyCompanyPay.get(localMonthIdx - 1)) : 0L;
			
			long daysInFullLocalMonth = ChronoUnit.DAYS.between(localMonthStart, localTheoreticalEnd) + 1; 
			long daysInThisActualTerm = ChronoUnit.DAYS.between(localMonthStart, localMonthEnd) + 1; 
			long targetGovAmount = Math.max(0L, regularWage - companyPay);
			if (daysInThisActualTerm < daysInFullLocalMonth) {
				targetGovAmount = ((long) Math.floor((targetGovAmount * (double) daysInThisActualTerm / daysInFullLocalMonth) / 10)) * 10;
			}
			
			long totalProratedCapForTerm = 0;
			LocalDate tempDate = localMonthStart; 
			long currentCumulativeDay = cumulativeDay; 
			
			while(!tempDate.isAfter(localMonthEnd)) {
			
			long monthlyCap = getCapByCumulativeDay(firstEverStartDate, currentCumulativeDay, regularWage); 
			
			// 현재 상한액(250만)이 끝나는 날짜 계산
			LocalDate capEndDate;
			if (currentCumulativeDay <= daysIn3Months) {

				long daysRemaining = daysIn3Months - currentCumulativeDay; 
				capEndDate = tempDate.plusDays(daysRemaining);
			} 
			else if (currentCumulativeDay <= daysIn6Months) {
				long daysRemaining = daysIn6Months - currentCumulativeDay;
				capEndDate = tempDate.plusDays(daysRemaining);
			} 
			else {
				long daysRemaining = daysIn12Months - currentCumulativeDay;
				capEndDate = tempDate.plusDays(daysRemaining);
			}
			

			LocalDate subPeriodEnd = localMonthEnd.isAfter(capEndDate) ? capEndDate : localMonthEnd;
			
			long daysInSubPeriod = ChronoUnit.DAYS.between(tempDate, subPeriodEnd) + 1;
			
			if (daysInSubPeriod <= 0) break;
			
				// 상한액 일할계산 (가중 평균)

				long proratedCap = ((long) Math.floor((monthlyCap * (double) daysInSubPeriod / daysInFullLocalMonth) / 10)) * 10;
				totalProratedCapForTerm += proratedCap; 

				tempDate = subPeriodEnd.plusDays(1);
				currentCumulativeDay += daysInSubPeriod; 
			} 
			
			// 최종 지급액 결정

			long gov = Math.min(totalProratedCapForTerm, targetGovAmount);
			gov = (gov / 10L) * 10L;
			
			//  DTO 생성
			TermAmountDTO t = TermAmountDTO.builder()
			.startMonthDate(Date.valueOf(localMonthStart))
			.endMonthDate(Date.valueOf(localMonthEnd))
			.paymentDate(Date.valueOf(localMonthEnd.plusDays(1)))
			.companyPayment(companyPay)
			.govPayment(gov)
			.build();
			list.add(t);

			localMonthIdx++;
			cumulativeDay += daysInThisActualTerm;
			curProcessingDate = localMonthEnd.plusDays(1);
		} 
		
		return list;
	}


    /** 계산된 리스트 저장*/
    @Transactional
    public void saveTerms(Long confirmNumber, List<TermAmountDTO> terms) {
        if (confirmNumber == null || terms == null || terms.isEmpty()) return;
        for (TermAmountDTO t : terms) {
            t.setConfirmNumber(confirmNumber);
        }
        termAmountDAO.insertTermAmount(terms);
    }

    /* 유틸 */
    private static boolean notBlank(String s) { return s != null && !s.trim().isEmpty(); }
    private static long nz(Long v) { return v == null ? 0L : v; }

    /*상세페이지용*/
    @Transactional(readOnly = true)
    public ConfirmApplyDTO findByConfirmNumber(Long confirmNumber) {
        if (confirmNumber == null) return null;

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

    @Transactional
    public Long updateConfirm (ConfirmApplyDTO dto, List<Long> monthlyCompanyPay) {
        
        try {
             if (notBlank(dto.getRegistrationNumber()))
                  dto.setRegistrationNumber(aes256Util.encrypt(dto.getRegistrationNumber()));
             if (notBlank(dto.getChildResiRegiNumber()))
                  dto.setChildResiRegiNumber(aes256Util.encrypt(dto.getChildResiRegiNumber()));
        } catch (Exception e) {
             throw new IllegalStateException("개인정보 암호화 오류", e);
        }

        // 확인서 다시저장
        int rows = confirmApplyDAO.updateConfirm(dto);
        if (rows != 1 || dto.getConfirmNumber() == null) {
            throw new IllegalStateException("확인서 저장 실패");
        }

        // 단위기간
        LocalDate s = dto.getStartDate() == null ? null : dto.getStartDate().toLocalDate();
        LocalDate e = dto.getEndDate()   == null ? null : dto.getEndDate().toLocalDate();
        Long wage = dto.getRegularWage();

        if (s != null && e != null && wage != null && !e.isBefore(s)) {
            
            List<Long> previousConfirmNumbers = confirmApplyDAO.findMyConfirmList(
                dto.getChildBirthDate(), 
                dto.getRegistrationNumber()
            );
            
            Long currentConfirmNumber = dto.getConfirmNumber();
            if (previousConfirmNumbers != null && currentConfirmNumber != null) {
                previousConfirmNumbers = previousConfirmNumbers.stream()
                        .filter(num -> !num.equals(currentConfirmNumber))
                        .collect(Collectors.toList());
            }

            java.sql.Date sqlStartDate = confirmApplyDAO.findFirstStartDateForPerson(
                dto.getChildBirthDate(), 
                dto.getRegistrationNumber(),
                currentConfirmNumber 
            );
            LocalDate firstEverStartDate = (sqlStartDate != null) ? sqlStartDate.toLocalDate() : null;


            if (firstEverStartDate == null) {
                firstEverStartDate = s;
            }

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
            
            deleteTerms(dto.getConfirmNumber());
            List<TermAmountDTO> terms = calculateTerms(s, e, wage, monthlyCompanyPay, 
                                                    firstEverStartDate, totalPreviousDays);
            saveTerms(dto.getConfirmNumber(), terms);
        }

        return dto.getConfirmNumber();
    }
    
    
    public int recallConfirm(Long confirmNumber, Long userId) {
        return confirmApplyDAO.recallConfirm(confirmNumber, userId);
    }  
    
    public List<ConfirmListDTO> getConfirmList(Long userId,
            String statusCode,
            String nameKeyword,
            String regNoKeyword,
            int page, int size) {
        int offset = Math.max(0, page - 1) * size;
        
        String regNoEnc = null;
        if (regNoKeyword != null) {
        try {
        regNoEnc = aes256Util.encrypt(regNoKeyword); 
        } catch (Exception e) {
        throw new IllegalStateException("주민번호 암호화 실패", e);
        }
        }
        
        return confirmApplyDAO.selectConfirmListSearch(
        userId, statusCode, nameKeyword, regNoEnc, offset, size
        );
    }

    
    public int countConfirmList(Long userId,
                                String statusCode,
                                String nameKeyword,
                                String regNoKeyword) {
        String regNoEnc = null;
        if (regNoKeyword != null) {
        try {
        regNoEnc = aes256Util.encrypt(regNoKeyword); 
        } catch (Exception e) {
        throw new IllegalStateException("주민번호 암호화 실패", e);
        }
        }
        
    return confirmApplyDAO.countConfirmListSearch(userId, statusCode, nameKeyword, regNoEnc);
    }
    
    public List<ConfirmListDTO> getConfirmList(Long userId, int page, int size) {
        int offset = Math.max(0, page - 1) * size;
        
        return confirmApplyDAO.selectConfirmList(
        userId, offset, size
        );
    }

    public int countConfirmList(Long userId) {
    return confirmApplyDAO.countConfirmList(userId);
    }
    
    public Map<String, Object> findLatestPeriodByPerson(String name, String registrationNumber, Long nowConfirmNumber) {
        if (name == null || registrationNumber == null) {
            return java.util.Collections.emptyMap();
        }

        try {
            String regNoEnc = aes256Util.encrypt(registrationNumber);
            Map<String, Object> row = confirmApplyDAO.findLatestPeriodByPerson(name, regNoEnc, nowConfirmNumber);
            return (row != null) ? row : java.util.Collections.emptyMap();
        } catch (Exception e) {
            throw new IllegalStateException("주민번호 암호화 실패", e);
        }
    }
    
    @Transactional
    public int deleteConfirm(Long confirmNumber, Long userId) {
        Long fileId = confirmApplyDAO.findFileIdByConfirmNumber(confirmNumber);
        int affected = confirmApplyDAO.deleteConfirm(confirmNumber, userId);
        if (affected > 0) {
            if (fileId != null) {
                attachedFileService.deleteByFileId(fileId, true);
            }
            termAmountDAO.deleteTermsByConfirmId(confirmNumber);
        }
        return affected;
    }
    
    public boolean compDetailCheck(Long confirmNumber, Long currentUserId) {
        if (confirmNumber == null || currentUserId == null) return false;
        Long ownerId = confirmApplyDAO.findUserIdByConfirmNumber(confirmNumber);
        return ownerId != null && ownerId.equals(currentUserId);
    }
    

}