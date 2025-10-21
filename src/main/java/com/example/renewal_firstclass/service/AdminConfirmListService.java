package com.example.renewal_firstclass.service;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.example.renewal_firstclass.dao.AdminConfirmListDAO;
import com.example.renewal_firstclass.domain.AdminListDTO;
import com.example.renewal_firstclass.domain.ApplicationSearchDTO;
import com.example.renewal_firstclass.domain.PageDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AdminConfirmListService {

    private final AdminConfirmListDAO adminConfirmListDAO;

    public Map<String, Object> getPagedApplicationsAndCounts(String keyword, String status, String date,
    		PageDTO pageDTO) {
        Map<String, Object> result = new HashMap<>();
        
        // 검색 조건에 맞는 게시물 조회
        int totalCnt = adminConfirmListDAO.selectTotalCount(keyword, status, date);
        pageDTO.setTotalCnt(totalCnt); // PageDTO에 총 개수 설정 -> 페이징 계산 완료
        
        // DTO로 묶어서 전달
        ApplicationSearchDTO search = new ApplicationSearchDTO();
        search.setKeyword(keyword);
        search.setStatus(status);
        search.setDate(date);
        search.setPageDTO(pageDTO);

        List<AdminListDTO> confirmList = adminConfirmListDAO.selectConfirmList(search);

        // 상태별 건수 조회
        Map<String, Integer> counts = new HashMap<>();
        
        // 전체 신청 건수
        counts.put("total", adminConfirmListDAO.selectTotalCount(null, null, null));

        // 대기 건수 ='제출'(ST_20) + '심사중'(ST_30)
        List<String> pendingStatusCodes = Arrays.asList("ST_20", "ST_30", "ST_40");
        counts.put("pending", adminConfirmListDAO.selectStatusCountIn(pendingStatusCodes));
        
        // 승인/반려
        counts.put("approved", adminConfirmListDAO.selectTotalCount(null, "APPROVED", null));
        counts.put("rejected", adminConfirmListDAO.selectTotalCount(null, "REJECTED", null)); 
        
        //결과 반환
        result.put("list", confirmList);
        result.put("pageDTO", pageDTO);
        result.put("counts", counts);

        return result;
    }
}