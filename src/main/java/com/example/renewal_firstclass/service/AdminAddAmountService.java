package com.example.renewal_firstclass.service;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import com.example.renewal_firstclass.dao.AdminAddAmountDAO;
import com.example.renewal_firstclass.dao.CodeDAO;
import com.example.renewal_firstclass.dao.TermAmountDAO;
import com.example.renewal_firstclass.dao.UserApplyDAO;
import com.example.renewal_firstclass.domain.AdminUserApprovalDTO;
import com.example.renewal_firstclass.domain.ApplicationSearchDTO;
import com.example.renewal_firstclass.domain.CodeDTO;
import com.example.renewal_firstclass.domain.PageDTO;
import com.example.renewal_firstclass.domain.TermAmountDTO;
import com.example.renewal_firstclass.util.AES256Util;

import lombok.RequiredArgsConstructor;


@Service
@RequiredArgsConstructor
public class AdminAddAmountService {

    private final AdminAddAmountDAO adminAddAmountDAO;
    private final AES256Util aes256Util;
    private final UserApplyDAO userApplyDAO;
    
    public Map<String, Object> getAddAmountList(String nameKeyword, Long appNoKeyword, String date, PageDTO pageDTO) {
        Map<String, Object> result = new HashMap<>();
        
        // [수정] status를 'ST_50'으로 고정
        String status = "ST_50";

        // 1. 검색 조건에 맞는 ST_50 게시물 총 개수 조회
        int totalCnt = adminAddAmountDAO.selectTotalCount(nameKeyword, appNoKeyword, status, date);
        pageDTO.setTotalCnt(totalCnt); // PageDTO에 총 개수 설정 -> 페이징 계산 완료

        // 2. DTO로 묶어서 전달
        ApplicationSearchDTO search = new ApplicationSearchDTO();
        search.setNameKeyword(nameKeyword);
        search.setAppNoKeyword(appNoKeyword);
        search.setStatus(status); // ST_50 고정
        search.setDate(date);
        search.setPageDTO(pageDTO);

        // 3. ST_50 목록 조회
        List<AdminUserApprovalDTO> applicationList = adminAddAmountDAO.selectApplicationList(search);

        // 4. 결과 반환
        result.put("list", applicationList);
        result.put("pageDTO", pageDTO);
        
        // [수정] 불필요한 상태별 카운트(counts) 로직 제거

        return result;
    }
    
    public Map<String, Object> getPagedApplicationsAndCounts(String nameKeyword, Long appNoKeyword, String status, String date,
    		PageDTO pageDTO) {
        Map<String, Object> result = new HashMap<>();
        
        // 검색 조건에 맞는 게시물 조회
        int totalCnt = adminAddAmountDAO.selectTotalCount(nameKeyword, appNoKeyword, status, date);
        pageDTO.setTotalCnt(totalCnt); // PageDTO에 총 개수 설정 -> 페이징 계산 완료
        
        // DTO로 묶어서 전달
        ApplicationSearchDTO search = new ApplicationSearchDTO();
        search.setNameKeyword(nameKeyword);
        search.setAppNoKeyword(appNoKeyword);
        search.setStatus(status);
        search.setDate(date);
        search.setPageDTO(pageDTO);

        List<AdminUserApprovalDTO> applicationList = adminAddAmountDAO.selectApplicationList(search);

        // 상태별 건수 조회
        Map<String, Integer> counts = new HashMap<>();
        
        // 전체 신청 건수
        counts.put("total", adminAddAmountDAO.selectTotalCount(null, null, null, null));
        
        // 승인/반려
        counts.put("approved", adminAddAmountDAO.selectStatusCount("ST_50", "Y"));
        counts.put("rejected", adminAddAmountDAO.selectStatusCount("ST_60", "N")); 
        
        //결과 반환
        result.put("list", applicationList);
        result.put("pageDTO", pageDTO);
        result.put("counts", counts);

        return result;
    }
    
}
