package com.example.renewal_firstclass.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.renewal_firstclass.domain.AdminSuperCheckDTO;
import com.example.renewal_firstclass.domain.CustomUserDetails;
import com.example.renewal_firstclass.service.AdminListService;
import com.example.renewal_firstclass.service.AdminSuperiorService;
import com.example.renewal_firstclass.service.UserService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class AdminSuperiorController {

    private final AdminListService adminListService; 
    private final UserService userService;
    private final AdminSuperiorService adminSuperiorService;
    
    @GetMapping("/admin/superior")
    public String showSuperiorPage(Authentication authentication, Model model) {
    	String username = ((CustomUserDetails) authentication.getPrincipal()).getUsername();
        Long centerId = adminSuperiorService.getCenterIdByUsername(username);
        String centerPosition = adminSuperiorService.getCenterPositionByUsername(username);
        
        AdminSuperCheckDTO checkDto = new AdminSuperCheckDTO();
        checkDto.setCenterId(centerId);
        checkDto.setCenterPosition(centerPosition);
        
        model.addAttribute("adminCheck", checkDto);
        
        // center_position이 leader가 아닐 경우 접근 차단
        if (!"leader".equals(centerPosition)) {
            return "redirect:/admin/user/apply"; 
        }
        return "admin/adminsuperiorlist";
    }
/*    @GetMapping("/admin/user/apply")
    public String showApplicationList(@RequestParam(value= "page", defaultValue="1") int page,
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "status", required = false) String status,
            @RequestParam(value = "date", required = false) String date,
            Model model) {
    	
    	//페이징 DTO 생성
    	int pageSize = 10;
 		PageDTO pageDTO = new PageDTO(page, pageSize); 	// 10개씩 보여줌 
 		//서비스 호출
 		Map<String, Object> result = adminListService.getPagedApplicationsAndCounts(keyword, status, date, pageDTO);

	    model.addAttribute("applicationList", result.get("list"));
	    model.addAttribute("pageDTO", result.get("pageDTO"));
	    model.addAttribute("counts", result.get("counts"));
        
        // 사용자가 입력한 검색어와 상태를 다시 화면에 전달하여 유지시킴
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        model.addAttribute("date", date);

        return "admin/adminlist";
    }
    */
    
}