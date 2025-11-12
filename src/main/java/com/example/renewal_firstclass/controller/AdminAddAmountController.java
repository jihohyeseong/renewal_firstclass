package com.example.renewal_firstclass.controller;

import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping; // 추가
import org.springframework.web.bind.annotation.RequestMethod; // 추가
import org.springframework.web.bind.annotation.RequestParam; // 추가

import com.example.renewal_firstclass.domain.PageDTO; // 추가
import com.example.renewal_firstclass.service.AdminAddAmountService; // 추가

import lombok.RequiredArgsConstructor; // 추가

@Controller
@RequiredArgsConstructor 
public class AdminAddAmountController {

    // [수정] 서비스 주입
    private final AdminAddAmountService adminAddAmountService;

    @RequestMapping(value = "admin/addamount", method = {RequestMethod.GET, RequestMethod.POST})
    public String showAddAmountList(
            @RequestParam(value = "nameKeyword", required = false) String nameKeyword,
            @RequestParam(value = "appNoKeyword", required = false) String appNoKeyword,
            @RequestParam(value = "date", required = false) String date,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            Model model) {
    	
    	PageDTO pageDTO = new PageDTO(page, size);
        
    	Long appNoKeywordLong = null;
    	if (appNoKeyword != null && !appNoKeyword.trim().isEmpty()) {
    		try {
    			appNoKeywordLong = Long.parseLong(appNoKeyword);
    		}catch (NumberFormatException e) {
    			
    		}
    	}
        // [수정] 새로 만든 서비스 메서드 호출 (ST_50 전용)
        Map<String, Object> result = adminAddAmountService.getAddAmountList(nameKeyword, appNoKeywordLong, date, pageDTO);

        // [수정] Model에 데이터 추가
        model.addAttribute("applicationList", result.get("list"));
        model.addAttribute("pageDTO", result.get("pageDTO"));

        // [수정] 검색어 유지를 위해 Model에 추가
        model.addAttribute("nameKeyword", nameKeyword);
        model.addAttribute("appNoKeyword", appNoKeyword);
        model.addAttribute("date", date);
        
        return "admin/adminaddamount";
    }
}