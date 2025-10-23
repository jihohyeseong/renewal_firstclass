package com.example.renewal_firstclass.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.renewal_firstclass.domain.CodeDTO;
import com.example.renewal_firstclass.domain.CustomUserDetails;
import com.example.renewal_firstclass.domain.PageDTO;
import com.example.renewal_firstclass.domain.UserDTO;
import com.example.renewal_firstclass.service.AdminUserApprovalService;
import com.example.renewal_firstclass.service.CodeService;
import com.example.renewal_firstclass.service.UserService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class AdminUserApprovalController {
    private final AdminUserApprovalService adminUserApprovalService;
    
    private final CodeService codeService;
    
    private final UserService userService;
    

    @GetMapping("/admin/user/apply")
    public String showApplicationList(@RequestParam(value= "page", defaultValue="1") int page,
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "status", required = false) String status,
            @RequestParam(value = "date", required = false) String date,
            Model model) {
    	
    	//페이징 DTO 생성
    	int pageSize = 10;
 		PageDTO pageDTO = new PageDTO(page, pageSize); 	// 10개씩 보여줌 
 		//서비스 호출
 		Map<String, Object> result = adminUserApprovalService.getPagedApplicationsAndCounts(keyword, status, date, pageDTO);

	    model.addAttribute("applicationList", result.get("list"));
	    model.addAttribute("pageDTO", result.get("pageDTO"));
	    model.addAttribute("counts", result.get("counts"));
        
        // 사용자가 입력한 검색어와 상태를 다시 화면에 전달하여 유지시킴
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        model.addAttribute("date", date);

        return "admin/adminuserlist";
    }
    
    @GetMapping("/admin/user/detail")
    public String detail(@RequestParam long appNo, Model model) {
        adminUserApprovalService.userApplyDetail(appNo, model);
        return "admin/adminuserdetail";
    }
    
     // 부지급 사유 코드 목록
    @GetMapping("/codes/reject")
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
    

 // =========================
 // 지급(2차 심사: ST_40)
 // =========================
 @PostMapping("/admin/user/approve")
 @ResponseBody
 public Map<String, Object> approveToSecondReview(@RequestBody Map<String, Object> payload) {
     Map<String, Object> resp = new HashMap<>();
     try {
         long applicationNumber = ((Number) payload.get("applicationNumber")).longValue();
         Long processorId = currentAdminIdOrNull();
         if (processorId == null) {
             resp.put("success", false);
             resp.put("message", "로그인이 필요합니다.");
             return resp;
         }

         adminUserApprovalService.approveLevel1ToSecondReview(applicationNumber, processorId);

         resp.put("message", "2차 심사로 전환되었습니다.");
         resp.put("redirectUrl", "/admin/user/apply");
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

 // =========================
 // 부지급 확정
 // =========================
 @PostMapping("/admin/user/reject")
 @ResponseBody
 public Map<String, Object> reject(@RequestBody Map<String, Object> payload) {
     Map<String, Object> resp = new HashMap<>();
     try {
         long applicationNumber     = ((Number) payload.get("applicationNumber")).longValue();
         String rejectionReasonCode = (String) payload.get("rejectionReasonCode");
         String rejectComment       = (String) payload.get("rejectComment");
         Long processorId           = currentAdminIdOrNull();
         if (processorId == null) {
             resp.put("success", false);
             resp.put("message", "로그인이 필요합니다.");
             return resp;
         }

         adminUserApprovalService.rejectApplication(applicationNumber, rejectionReasonCode, rejectComment, processorId);

         resp.put("message", "부지급 처리가 완료되었습니다.");
         resp.put("redirectUrl", "/admin/user/apply");
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
