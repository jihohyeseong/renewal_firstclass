package com.example.renewal_firstclass.controller;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping; // 추가
import org.springframework.web.bind.annotation.RequestMethod; // 추가
import org.springframework.web.bind.annotation.RequestParam; // 추가
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.renewal_firstclass.domain.ApplicationDetailDTO;
import com.example.renewal_firstclass.domain.PageDTO; // 추가
import com.example.renewal_firstclass.service.AdminAddAmountService; // 추가
import com.example.renewal_firstclass.service.UserApplyService;

import lombok.RequiredArgsConstructor; // 추가
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor 
@Slf4j
public class AdminAddAmountController {

    private final AdminAddAmountService adminAddAmountService;
    private final UserApplyService userApplyService;

    @RequestMapping(value = "admin/addamount", method = {RequestMethod.GET, RequestMethod.POST})
    public String showAddAmountList(
            @RequestParam(value = "nameKeyword", required = false) String nameKeyword,
            @RequestParam(value = "appNoKeyword", required = false) String appNoKeyword,
            @RequestParam(value = "date", required = false) String date,
            @RequestParam(value = "status", required = false) String status,
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

        Map<String, Object> result = adminAddAmountService.getPagedApplicationsAndCounts(nameKeyword, appNoKeywordLong, status, date, pageDTO);

        model.addAttribute("applicationList", result.get("list"));
        model.addAttribute("pageDTO", result.get("pageDTO"));
        model.addAttribute("counts", result.get("counts"));

        // 검색어 유지
        model.addAttribute("nameKeyword", nameKeyword);
        model.addAttribute("appNoKeyword", appNoKeyword);
        model.addAttribute("date", date);
        model.addAttribute("status", status);
        
        return "admin/adminaddamount";
    }
 
    //상세조회
    @GetMapping("/admin/addamount/detail") 
    public String showAddAmountDetail(@RequestParam long appNo, Model model){
    	adminAddAmountService.userApplyDetail(appNo, model);
    	ApplicationDetailDTO applicationDetailDTO = userApplyService.getApplicationDetail(appNo);
    	
    	model.addAttribute("dto", applicationDetailDTO);
    	
    	return "admin/adminaddamountdetail";
    }
    
    // 추가지급 신청 처리
    @PostMapping("/admin/addamount/apply")
    public String applyAddAmount(
            @RequestParam("applicationNumber") Long applicationNumber,
            @RequestParam("codeId") Long codeId,
            @RequestParam(value = "addReason", required = false) String addReason,
            @RequestParam("termId") List<Long> termIds,
            @RequestParam("amount") List<Long> amounts, 
            RedirectAttributes rttr) {
        
        try {
            adminAddAmountService.submitAddAmount(applicationNumber, codeId, addReason, termIds, amounts);
            rttr.addFlashAttribute("success", "추가지급 신청이 완료되었습니다.");
            return "redirect:/admin/addamount/detail?appNo=" + applicationNumber; 
            
        } catch (IllegalArgumentException e) {
            log.warn("추가지급 신청 유효성 검사 실패: {}", e.getMessage());
            rttr.addFlashAttribute("error", e.getMessage());
            // 실패 시 상세 페이지로 리다이렉트
            return "redirect:/admin/addamount/detail?appNo=" + applicationNumber;
        } catch (Exception e) {
            log.error("추가지급 신청 처리 중 오류 발생", e);
            rttr.addFlashAttribute("error", "신청 처리 중 심각한 오류가 발생했습니다. 관리자에게 문의하세요.");
            return "redirect:/admin/addamount/detail?appNo=" + applicationNumber;
        }
    }
}