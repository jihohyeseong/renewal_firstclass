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
        // 암호화
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
            
            // ### 수정된 부분 (createConfirm) ###
            List<Long> previousConfirmNumbers = confirmApplyDAO.findMyConfirmList(
                dto.getChildBirthDate(), 
                dto.getRegistrationNumber() // 암호화된 값
            );
            
            // 1. 이력 중 가장 빠른 휴직 시작일 찾기 (DAO는 java.sql.Date 반환)
            java.sql.Date sqlStartDate = confirmApplyDAO.findFirstStartDateForPerson(
                dto.getChildBirthDate(), 
                dto.getRegistrationNumber(),
                null // 새 신청이므로 제외할 번호 없음
            );
            LocalDate firstEverStartDate = (sqlStartDate != null) ? sqlStartDate.toLocalDate() : null;

            // 만약 이력이 없으면, 현재 신청이 첫 시작일
            if (firstEverStartDate == null) {
                firstEverStartDate = s;
            }

            // 2. 이전까지의 총 누적 일수 계산
            long totalPreviousDays = 0;
            if (previousConfirmNumbers != null && !previousConfirmNumbers.isEmpty()) {
                // (selectTermsByConfirmNumbers는 DAO에 추가 필요)
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
            // calculateTerms에 새 파라미터 전달
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

    // ### 헬퍼 메서드 1 ###
    /**
     * '월'이 아닌 '일' 기준으로 이론적인 월 만기일을 계산하는 헬퍼 메서드
     * (예: 1월 5일 -> 4월 4일 (3개월차 만기))
     * @param firstEverStartDate 최초 휴직 시작일
     * @param months 누적 개월 수
     * @return
     */
    private LocalDate getGlobalTheoreticalEnd(LocalDate firstEverStartDate, int months) {
        LocalDate nextStart = firstEverStartDate.plusMonths(months);
        if (nextStart.getDayOfMonth() != firstEverStartDate.getDayOfMonth()) {
            nextStart = nextStart.plusMonths(1).withDayOfMonth(1);
        }
        return nextStart.minusDays(1);
    }

    // ### 헬퍼 메서드 2 ###
    /**
     * 누적 '일'을 기준으로 상한액(Cap)을 반환하는 헬퍼 메서드
     * @param firstEverStartDate
     * @param cumulativeDay (1일차, 2일차...)
     * @param regularWage
     * @return
     */
    private long getCapByCumulativeDay(LocalDate firstEverStartDate, long cumulativeDay, long regularWage) {
        // 3개월차 경계일 (예: 1/5 -> 4/4)
        LocalDate end3Months = getGlobalTheoreticalEnd(firstEverStartDate, 3);
        long daysIn3Months = ChronoUnit.DAYS.between(firstEverStartDate, end3Months) + 1; // 예: 90일

        // 6개월차 경계일 (예: 1/5 -> 7/4)
        LocalDate end6Months = getGlobalTheoreticalEnd(firstEverStartDate, 6);
        long daysIn6Months = ChronoUnit.DAYS.between(firstEverStartDate, end6Months) + 1; // 예: 181일

        // 12개월차 경계일 (예: 1/5 -> 1/4)
        LocalDate end12Months = getGlobalTheoreticalEnd(firstEverStartDate, 12);
        long daysIn12Months = ChronoUnit.DAYS.between(firstEverStartDate, end12Months) + 1; // 예: 365일

        
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


    // ### 핵심 수정 메서드 ###
    /**
     * 단위기간 계산 (로직 전체 변경)
     * @param newStart           현재 신청의 시작일 (예: 6/20)
     * @param newEnd             현재 신청의 종료일 (예: 10/25)
     * @param regularWage        통상임금
     * @param monthlyCompanyPay  현재 신청의 사업주 지급액 리스트 (1, 2, 3... 번째 월)
     * @param firstEverStartDate 전체 이력 중 첫 번째 휴직 시작일 (예: 1/5)
     * @param totalPreviousDays  현재 신청 전까지 사용한 총 '일' 수 (예: 69일)
     */
    public List<TermAmountDTO> calculateTerms(LocalDate newStart, LocalDate newEnd,
            long regularWage,
            List<Long> monthlyCompanyPay,
            LocalDate firstEverStartDate, 
            long totalPreviousDays) { 
    	
		if (newStart == null || newEnd == null) throw new IllegalArgumentException("기간 누락");
		if (newEnd.isBefore(newStart)) throw new IllegalArgumentException("종료일이 시작일보다 빠릅니다.");
		
		List<TermAmountDTO> list = new ArrayList<>();
		
		LocalDate curProcessingDate = newStart; // 현재 처리 중인 *Local Month*의 시작일
		long cumulativeDay = totalPreviousDays + 1; // 누적 일수 (예: 84일차부터 시작)
		int localMonthIdx = 1; // 현재 신청 건의 1, 2, 3... 번째 월
		
		// --- 12개월 한도 ---
		LocalDate end12Months = getGlobalTheoreticalEnd(firstEverStartDate, 12);
		long daysIn12Months = ChronoUnit.DAYS.between(firstEverStartDate, end12Months) + 1;
		
		// --- 전역(Global) 상한액 경계일 계산 ---
		LocalDate end3Months = getGlobalTheoreticalEnd(firstEverStartDate, 3);
		long daysIn3Months = ChronoUnit.DAYS.between(firstEverStartDate, end3Months) + 1; // 예: 92일 (3/15~6/14)
		LocalDate end6Months = getGlobalTheoreticalEnd(firstEverStartDate, 6);
		long daysIn6Months = ChronoUnit.DAYS.between(firstEverStartDate, end6Months) + 1; // 예: 184일 (3/15~9/14)
		
		
		// 'Local Month' (예: 8/15~9/14) 단위로 DTO를 생성하는 루프
		while (!curProcessingDate.isAfter(newEnd) && cumulativeDay <= daysIn12Months) {
		
			// 1. 현재 Local Month의 경계 정의
			LocalDate localMonthStart = curProcessingDate;
			
			LocalDate localNextStart = newStart.plusMonths(localMonthIdx);
			if (localNextStart.getDayOfMonth() != newStart.getDayOfMonth()) {
				localNextStart = localNextStart.plusMonths(1).withDayOfMonth(1);
			}
			LocalDate localTheoreticalEnd = localNextStart.minusDays(1); // 예: 9/14 (1차), 10/14 (2차)
			
			LocalDate localMonthEnd = localTheoreticalEnd.isAfter(newEnd) ? newEnd : localTheoreticalEnd; // 예: 9/14 (1차), 10/10 (2차)
			
			if (localMonthStart.isAfter(localMonthEnd)) 
				break;
			
			long companyPay = (monthlyCompanyPay != null && monthlyCompanyPay.size() >= localMonthIdx)
			? nz(monthlyCompanyPay.get(localMonthIdx - 1)) : 0L;
			
			// 2. 이 Local Month의 '이론적 총 일수' (일할계산 분모)
			long daysInFullLocalMonth = ChronoUnit.DAYS.between(localMonthStart, localTheoreticalEnd) + 1; // 예: 31일 (8/15~9/14)
			// 3. 이 Local Month의 '실제 총 일수' (일할계산 분자)
			long daysInThisActualTerm = ChronoUnit.DAYS.between(localMonthStart, localMonthEnd) + 1; // 예: 31일 (1차), 26일 (2차 9/15~10/10)
			
			// 4. 정부지원금 목표액 (통상임금 - 사업주 지급액) 계산
			long targetGovAmount = Math.max(0L, regularWage - companyPay);
			// 이 Term이 부분월(예: 10/10 종료)인 경우, 목표액도 일할계산
			if (daysInThisActualTerm < daysInFullLocalMonth) {
				targetGovAmount = ((long) Math.floor((targetGovAmount * (double) daysInThisActualTerm / daysInFullLocalMonth) / 10)) * 10;
			}
			
			// 5. 상한액(Cap)의 총합 계산 (가중 평균)
			long totalProratedCapForTerm = 0;
			LocalDate tempDate = localMonthStart; // 8/15
			long currentCumulativeDay = cumulativeDay; // 84
			
			// 이 Local Month(8/15~9/14)를 (8/15~8/23)과 (8/24~9/14)로 쪼개서 계산하는 내부 루프
			while(!tempDate.isAfter(localMonthEnd)) {
			
			long monthlyCap = getCapByCumulativeDay(firstEverStartDate, currentCumulativeDay, regularWage); // 예: 250만 (1차)
			
			// 현재 상한액(250만)이 끝나는 날짜 계산
			LocalDate capEndDate;
			if (currentCumulativeDay <= daysIn3Months) {
			// 예: (92 - 84) = 8일 남음
				long daysRemaining = daysIn3Months - currentCumulativeDay; 
				capEndDate = tempDate.plusDays(daysRemaining); // 예: 8/15 + 8일 = 8/23
			} 
			else if (currentCumulativeDay <= daysIn6Months) {
				long daysRemaining = daysIn6Months - currentCumulativeDay;
				capEndDate = tempDate.plusDays(daysRemaining); // 예: 8/24 + (184-93) = 11/24
			} 
			else {
				long daysRemaining = daysIn12Months - currentCumulativeDay;
				capEndDate = tempDate.plusDays(daysRemaining);
			}
			
			// 이 하위 기간(Sub-Period)의 종료일
			// 예: min(Local종료일: 9/14, Cap종료일: 8/23) -> 8/23
			LocalDate subPeriodEnd = localMonthEnd.isAfter(capEndDate) ? capEndDate : localMonthEnd;
			
			long daysInSubPeriod = ChronoUnit.DAYS.between(tempDate, subPeriodEnd) + 1; // 예: 9일 (8/15~8/23)
			
			if (daysInSubPeriod <= 0) break;
			
				// 상한액 일할계산 (가중 평균)
				// 예: (250만 * 9일 / 31일)
				long proratedCap = ((long) Math.floor((monthlyCap * (double) daysInSubPeriod / daysInFullLocalMonth) / 10)) * 10;
				totalProratedCapForTerm += proratedCap; // 예: 725,800
				
				// 다음 하위 기간 계산을 위해 포인터 이동
				tempDate = subPeriodEnd.plusDays(1); // 예: 8/24
				currentCumulativeDay += daysInSubPeriod; // 예: 84 + 9 = 93
			} // --- 내부 루프 종료 ---
			
			// 6. 최종 지급액 결정
			// 예: min( (725,800 + 1,419,350), 2,700,000 )
			long gov = Math.min(totalProratedCapForTerm, targetGovAmount);
			gov = (gov / 10L) * 10L;
			
			// 7. DTO 생성
			TermAmountDTO t = TermAmountDTO.builder()
			.startMonthDate(Date.valueOf(localMonthStart))
			.endMonthDate(Date.valueOf(localMonthEnd))
			.paymentDate(Date.valueOf(localMonthEnd.plusDays(1)))
			.companyPayment(companyPay)
			.govPayment(gov)
			.build();
			list.add(t);
			
			// 8. 다음 'Local Month' 루프를 위한 포인터 이동
			localMonthIdx++;
			cumulativeDay += daysInThisActualTerm; // 실제 사용한 일수(31일)만큼 증가
			curProcessingDate = localMonthEnd.plusDays(1); // 9/15
		} // --- 외부 루프 종료 ---
		
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
            
            // ### 수정된 부분 (updateConfirm) ###
            List<Long> previousConfirmNumbers = confirmApplyDAO.findMyConfirmList(
                dto.getChildBirthDate(), 
                dto.getRegistrationNumber() // 암호화된 값
            );
            
            Long currentConfirmNumber = dto.getConfirmNumber();
            if (previousConfirmNumbers != null && currentConfirmNumber != null) {
                previousConfirmNumbers = previousConfirmNumbers.stream()
                        .filter(num -> !num.equals(currentConfirmNumber))
                        .collect(Collectors.toList());
            }

            // 1. 이력 중 가장 빠른 휴직 시작일 찾기 (DAO는 java.sql.Date 반환)
            java.sql.Date sqlStartDate = confirmApplyDAO.findFirstStartDateForPerson(
                dto.getChildBirthDate(), 
                dto.getRegistrationNumber(),
                currentConfirmNumber // 현재 수정 건 제외
            );
            LocalDate firstEverStartDate = (sqlStartDate != null) ? sqlStartDate.toLocalDate() : null;

            // 만약 이전 이력이 없으면, 현재 수정 건이 첫 시작일
            if (firstEverStartDate == null) {
                firstEverStartDate = s;
            }

            // 2. 이전까지의 총 누적 일수 계산
            long totalPreviousDays = 0;
            if (previousConfirmNumbers != null && !previousConfirmNumbers.isEmpty()) {
                // (selectTermsByConfirmNumbers는 DAO에 추가 필요)
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
            // calculateTerms에 새 파라미터 전달
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