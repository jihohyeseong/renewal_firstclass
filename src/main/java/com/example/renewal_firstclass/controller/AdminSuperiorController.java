package com.example.renewal_firstclass.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.renewal_firstclass.domain.AdminSuperCheckDTO;
import com.example.renewal_firstclass.domain.CodeDTO;
import com.example.renewal_firstclass.domain.CustomUserDetails;
import com.example.renewal_firstclass.domain.PageDTO;
import com.example.renewal_firstclass.domain.UserDTO;
import com.example.renewal_firstclass.service.AdminSuperiorService;
import com.example.renewal_firstclass.service.CodeService;
import com.example.renewal_firstclass.service.UserService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class AdminSuperiorController {

    private final CodeService codeService; 
    private final UserService userService;
    private final AdminSuperiorService adminSuperiorService;
    
    //목록 조회
    @GetMapping("/admin/superior")
    public String showSuperiorPage(Authentication authentication, 
    		@RequestParam(value= "page", defaultValue="1") int page,
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "status", required = false) String status,
            @RequestParam(value = "date", required = false) String date, Model model) {
    	
    	//페이징 DTO 생성
    	int pageSize = 10;
 		PageDTO pageDTO = new PageDTO(page, pageSize); 	// 10개씩 보여줌 
 		//서비스 호출
 		Map<String, Object> result = adminSuperiorService.getPagedApplicationsAndCounts(keyword, status, date, pageDTO);

	    model.addAttribute("applicationList", result.get("list"));
	    model.addAttribute("pageDTO", result.get("pageDTO"));
	    model.addAttribute("counts", result.get("counts"));
        
        // 사용자가 입력한 검색어와 상태를 다시 화면에 전달하여 유지시킴
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        model.addAttribute("date", date);
    	
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

    // 상세페이지 조회
    @GetMapping("/admin/superior/detail")
    public String showDetail(@RequestParam long appNo, Model model) {
    	adminSuperiorService.userApplyDetail(appNo, model);
    	return "admin/adminsuperiordetail";
    }
    
    // 부지급 사유 코드 목록
    @GetMapping("/codes/final-reject")
    @ResponseBody
    public List<CodeDTO> rejectCodes() {
        return codeService.getRejectCodeList();
    }
    
    private UserDTO currentUserOrNull() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
            return null;
        }
        CustomUserDetails ud = (CustomUserDetails) auth.getPrincipal();
        return userService.findByUsername(ud.getUsername());
    }

    private Long currentAdminIdOrNull() {
        UserDTO me = currentUserOrNull();
        return (me != null) ? me.getId() : null;
    }
    
	 // 지급(2차 심사: ST_40)
	 @PostMapping("/admin/superior/approve")
	 @ResponseBody
	 public Map<String, Object> approveToSecondReview(@RequestBody Map<String, Object> payload) {
	     Map<String, Object> resp = new HashMap<>();
	     try {
	         long applicationNumber = ((Number) payload.get("applicationNumber")).longValue();
	         Long superiorId = currentAdminIdOrNull();
	         if (superiorId == null) {
	             resp.put("success", false);
	             resp.put("message", "로그인이 필요합니다.");
	             return resp;
	         }
	
	         adminSuperiorService.approveLevel2ToSecondReview(applicationNumber, superiorId);
	
	         resp.put("message", "최종 지급 결정 처리가 완료되었습니다.");
	         resp.put("redirectUrl", "/admin/superior");
	         resp.put("success", true);
	     } catch (IllegalStateException e) {
	         resp.put("message", e.getMessage());
	         resp.put("success", false);
	     } catch (Exception e) {
	         resp.put("message", "처리 중 오류가 발생했습니다.");
	         resp.put("success", false);
	     }
	     return resp;
	 }
	
	 // 부지급 확정
	 @PostMapping("/admin/superior/reject")
	 @ResponseBody
	 public Map<String, Object> reject(@RequestBody Map<String, Object> payload) {
	     Map<String, Object> resp = new HashMap<>();
	     try {
	         long applicationNumber     = ((Number) payload.get("applicationNumber")).longValue();
	         String rejectionReasonCode = (String) payload.get("rejectionReasonCode");
	         String rejectComment       = (String) payload.get("rejectComment");
	         Long superiorId           = currentAdminIdOrNull();
	         if (superiorId == null) {
	             resp.put("success", false);
	             resp.put("message", "로그인이 필요합니다.");
	             return resp;
	         }
	
	         adminSuperiorService.rejectApplication(applicationNumber, rejectionReasonCode, rejectComment, superiorId);
	
	         resp.put("message", "부지급 결정 처리가 완료되었습니다.");
	         resp.put("redirectUrl", "/admin/superior");
	         resp.put("success", true);
	     } catch (IllegalStateException e) {
	         resp.put("message", e.getMessage());
	         resp.put("success", false);
	     } catch (Exception e) {
	         resp.put("message", "처리 중 오류가 발생했습니다.");
	         resp.put("success", false);
	     }
	     return resp;
	 }
}