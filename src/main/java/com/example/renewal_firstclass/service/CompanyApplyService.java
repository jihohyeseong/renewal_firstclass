package com.example.renewal_firstclass.service;

import java.sql.Date;
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
        Long wage   = dto.getRegularWage();

        if (s != null && e != null && wage != null && !e.isBefore(s)) {
            
            // ### 수정된 부분 ###
            // 이전에 승인된(임시저장, 반려 제외) 신청 건들의 confirmNumber 리스트 조회
            // dto.getRegistrationNumber()는 위에서 이미 암호화되었음.
            List<Long> previousConfirmNumbers = confirmApplyDAO.findMyConfirmList(
                dto.getChildBirthDate(), 
                dto.getRegistrationNumber() 
            );

            int previousMonthCount = 0;
            if (previousConfirmNumbers != null && !previousConfirmNumbers.isEmpty()) {
                // 이전 신청들에서 생성된 총 단위기간(월) 수를 카운트
                previousMonthCount = termAmountDAO.countTotalTermsByConfirmNumbers(previousConfirmNumbers);
            }
            
            deleteTerms(dto.getConfirmNumber());
            // calculateTerms에 previousMonthCount 전달
            List<TermAmountDTO> terms = calculateTerms(s, e, wage, monthlyCompanyPay, previousMonthCount);
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

    /**
     * 단위기간 계산
     * @param previousMonthCount 이전에 사용한 총 누적 개월 수
     */
    public List<TermAmountDTO> calculateTerms(LocalDate start, LocalDate end,
            long regularWage,
            List<Long> monthlyCompanyPay,
            int previousMonthCount) { // <-- ### 파라미터 추가 ###
        if (start == null || end == null) throw new IllegalArgumentException("기간 누락");
        if (end.isBefore(start)) throw new IllegalArgumentException("종료일이 시작일보다 빠릅니다.");
        
        List<TermAmountDTO> list = new ArrayList<>();
        LocalDate curStart = start;
        
        // ### 수정된 부분 ###
        // int monthIdx = 1; // (기존)
        
        // localMonthIdx: 현재 신청 건의 1, 2, 3... 번째 월
        int localMonthIdx = 1; 
        // cumulativeMonthIdx: 전체 육아휴직 기간 중 1, 2, 3... 번째 월 (누적)
        int cumulativeMonthIdx = previousMonthCount + 1;
        
        // while (!curStart.isAfter(end) && monthIdx <= 12) { // (기존)
        while (!curStart.isAfter(end) && cumulativeMonthIdx <= 12) { // (수정) 12개월 한도 체크
            
            // LocalDate nextStart = start.plusMonths(monthIdx); // (기존)
            LocalDate nextStart = start.plusMonths(localMonthIdx); // (수정) 현재 신청 시작일 기준
            
            if (nextStart.getDayOfMonth() != start.getDayOfMonth()) {
                nextStart = nextStart.plusMonths(1).withDayOfMonth(1);
            }
            LocalDate theoreticalEnd = nextStart.minusDays(1);
            LocalDate actualEnd = theoreticalEnd.isAfter(end) ? end : theoreticalEnd;
            if (curStart.isAfter(actualEnd)) break;
            
            // long companyPay = (monthlyCompanyPay != null && monthlyCompanyPay.size() >= monthIdx) // (기존)
            //     ? nz(monthlyCompanyPay.get(monthIdx - 1)) : 0L; // (기존)
            
            // (수정) companyPay는 현재 신청 건의 월(localMonthIdx)을 기준으로 가져옴
            long companyPay = (monthlyCompanyPay != null && monthlyCompanyPay.size() >= localMonthIdx)
                ? nz(monthlyCompanyPay.get(localMonthIdx - 1)) : 0L;
            
            // 월별 상한(제도 상한) 계산
            long monthlyCap;
            
            // (수정) 상한액 기준을 누적 월(cumulativeMonthIdx)로 변경
            // if (monthIdx <= 3)     monthlyCap = Math.min(regularWage, 2_500_000L); // (기존)
            // else if (monthIdx <= 6) monthlyCap = Math.min(regularWage, 2_000_000L); // (기존)
            
            if (cumulativeMonthIdx <= 3)     monthlyCap = Math.min(regularWage, 2_500_000L);
            else if (cumulativeMonthIdx <= 6) monthlyCap = Math.min(regularWage, 2_000_000L);
            else                              monthlyCap = Math.min(Math.round(regularWage * 0.8), 1_600_000L);
            
            long daysInTerm = ChronoUnit.DAYS.between(curStart, actualEnd) + 1;
            long daysInFull = ChronoUnit.DAYS.between(curStart, theoreticalEnd) + 1;
            
            // 부분월이면 일할 상한 적용 (10원 단위 내림)
            long proratedCap = (daysInTerm >= daysInFull)
                ? monthlyCap
                : ((long) Math.floor((monthlyCap * (double) daysInTerm / daysInFull) / 10)) * 10;
            
            // 정부지급액 계산
            long gov = Math.min(proratedCap, Math.max(0L, regularWage - companyPay));
            gov = (gov / 10L) * 10L;
            
            TermAmountDTO t = TermAmountDTO.builder()
                .startMonthDate(Date.valueOf(curStart))
                .endMonthDate(Date.valueOf(actualEnd))
                .paymentDate(Date.valueOf(actualEnd.plusDays(1)))
                .companyPayment(companyPay)
                .govPayment(gov)
                .build();
            list.add(t);
            
            curStart = actualEnd.plusDays(1);
            
            // (수정) 두 인덱스 모두 증가
            // monthIdx++; // (기존)
            localMonthIdx++;
            cumulativeMonthIdx++;
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
        Long wage   = dto.getRegularWage();

        if (s != null && e != null && wage != null && !e.isBefore(s)) {
            
            // ### 수정된 부분 (updateConfirm) ###
            // 이전에 승인된 신청 건들의 confirmNumber 리스트 조회
            List<Long> previousConfirmNumbers = confirmApplyDAO.findMyConfirmList(
                dto.getChildBirthDate(), 
                dto.getRegistrationNumber() // 이미 암호화됨
            );

            // (중요) 현재 수정 중인 confirmNumber는 리스트에서 제외해야 함
            Long currentConfirmNumber = dto.getConfirmNumber();
            if (previousConfirmNumbers != null && currentConfirmNumber != null) {
                // Java 8 Stream API 사용
                previousConfirmNumbers = previousConfirmNumbers.stream()
                        .filter(num -> !num.equals(currentConfirmNumber))
                        .collect(Collectors.toList());
            }

            int previousMonthCount = 0;
            if (previousConfirmNumbers != null && !previousConfirmNumbers.isEmpty()) {
                // 이전 신청들에서 생성된 총 단위기간(월) 수를 카운트
                previousMonthCount = termAmountDAO.countTotalTermsByConfirmNumbers(previousConfirmNumbers);
            }
            
            deleteTerms(dto.getConfirmNumber());
            // calculateTerms에 previousMonthCount 전달
            List<TermAmountDTO> terms = calculateTerms(s, e, wage, monthlyCompanyPay, previousMonthCount);
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
