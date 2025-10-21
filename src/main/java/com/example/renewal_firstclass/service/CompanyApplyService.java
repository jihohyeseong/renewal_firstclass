package com.example.renewal_firstclass.service;

import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.renewal_firstclass.dao.ConfirmApplyDAO;
import com.example.renewal_firstclass.dao.TermAmountDAO;
import com.example.renewal_firstclass.dao.UserDAO;
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
    private final UserDAO userDAO;
    private final AES256Util aes256Util;


    /** 신규 저장(ST_10) + (필요 시) 단위기간: 삭제→계산→삽입 */
    @Transactional
    public Long createConfirm(ConfirmApplyDTO dto,
    		List<Long> monthlyCompanyPay) {
        // 0) 암호화
        try {
            if (notBlank(dto.getRegistrationNumber()))
                dto.setRegistrationNumber(aes256Util.encrypt(dto.getRegistrationNumber()));
            if (notBlank(dto.getChildResiRegiNumber()))
                dto.setChildResiRegiNumber(aes256Util.encrypt(dto.getChildResiRegiNumber()));
        } catch (Exception e) {
            throw new IllegalStateException("개인정보 암호화 오류", e);
        }

        // 1) 확인서 저장 (ST_10)
        dto.setStatusCode("ST_10");
        int rows = confirmApplyDAO.insertConfirmApplication(dto);
        if (rows != 1 || dto.getConfirmNumber() == null) {
            throw new IllegalStateException("확인서 저장 실패");
        }

        // 2) 단위기간: 값이 충분할 때만 처리
        LocalDate s = dto.getStartDate() == null ? null : dto.getStartDate().toLocalDate();
        LocalDate e = dto.getEndDate()   == null ? null : dto.getEndDate().toLocalDate();
        Long wage   = dto.getRegularWage();

        if (s != null && e != null && wage != null && !e.isBefore(s)) {
            deleteTerms(dto.getConfirmNumber());
            List<TermAmountDTO> terms = calculateTerms(s, e, wage, monthlyCompanyPay);
            saveTerms(dto.getConfirmNumber(), terms);
        }

        return dto.getConfirmNumber();
    }

    /** 상세보기에서 제출: ST_10 → ST_20 & apply_dt = SYSDATE */
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

    /**단위기간 계산*/
    public List<TermAmountDTO> calculateTerms(LocalDate start, LocalDate end,
            long regularWage,
            List<Long> monthlyCompanyPay) {
	if (start == null || end == null) throw new IllegalArgumentException("기간 누락");
	if (end.isBefore(start)) throw new IllegalArgumentException("종료일이 시작일보다 빠릅니다.");
	
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
	? nz(monthlyCompanyPay.get(monthIdx - 1)) : 0L;
	
	// 월별 상한(제도 상한) 계산
	long monthlyCap;
	if (monthIdx <= 3)      monthlyCap = Math.min(regularWage, 2_500_000L);
	else if (monthIdx <= 6) monthlyCap = Math.min(regularWage, 2_000_000L);
	else                    monthlyCap = Math.min(Math.round(regularWage * 0.8), 1_600_000L);
	
	long daysInTerm = ChronoUnit.DAYS.between(curStart, actualEnd) + 1;
	long daysInFull = ChronoUnit.DAYS.between(curStart, theoreticalEnd) + 1;
	
	// 부분월이면 일할 상한 적용 (10원 단위 내림)
	long proratedCap = (daysInTerm >= daysInFull)
	? monthlyCap
	: ((long) Math.floor((monthlyCap * (double) daysInTerm / daysInFull) / 10)) * 10;
	
	// 정부지급액 계산:
	long gov = Math.min(proratedCap, Math.max(0L, regularWage - companyPay));
	gov = (gov / 10L) * 10L;
	
	TermAmountDTO t = TermAmountDTO.builder()
	.startMonthDate(Date.valueOf(curStart))
	.endMonthDate(Date.valueOf(actualEnd))
	.paymentDate(Date.valueOf(actualEnd.plusMonths(1).withDayOfMonth(1)))
	.companyPayment(companyPay)
	.govPayment(gov)
	.build();
	list.add(t);
	
	curStart = actualEnd.plusDays(1);
	monthIdx++;
	}
	return list;
	}

    /** 3) 계산된 리스트 저장(confirmId만 주입하여 일괄 INSERT) */
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
    
    
    /*메인페이지 + 페이징처리용*/
    public List<ConfirmListDTO> getListByUser(Long userId, int page, int size) {
        int offset = (page - 1) * size;
        return confirmApplyDAO.selectByUserId(userId, offset, size);
    }

    public int countByUser(Long userId) {
        return confirmApplyDAO.countByUser(userId);
    }  
    
    
    

    
}
