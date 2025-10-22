package com.example.renewal_firstclass.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.renewal_firstclass.domain.AdminJudgeDTO;
import com.example.renewal_firstclass.domain.ConfirmApplyDTO;
import com.example.renewal_firstclass.domain.CustomUserDetails;
import com.example.renewal_firstclass.domain.UserDTO;
import com.example.renewal_firstclass.service.AdminApprovalService;
import com.example.renewal_firstclass.service.CompanyApplyService;
import com.example.renewal_firstclass.service.UserService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
public class AdminApprovalController {
	private final UserService userService;
	private final AdminApprovalService adminApprovalService;
	private final CompanyApplyService companyApplyService;
	
	private UserDTO currentUserOrNull() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
            return null;
        }
        CustomUserDetails ud = (CustomUserDetails) auth.getPrincipal();
        return userService.findByUsername(ud.getUsername());
    }

	// 관리자 지급 (승인)
    @PostMapping("admin/judge/approve")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> adminApprove(@RequestBody AdminJudgeDTO judgeDTO, HttpServletRequest request){
    	
    	Map<String, Object> response = new HashMap<>();
    	UserDTO userDTO = currentUserOrNull();
        if (userDTO.getId() == null) { 
        	response.put("success", false);
			response.put("message", "로그인 해주세요.");
			response.put("redirectUrl", request.getContextPath()+"/login");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

        boolean updateSuccess = adminApprovalService.adminApprove(judgeDTO, userDTO.getId());
    	
    	if (updateSuccess) {
			response.put("success", true);
            response.put("message", "지급 처리(승인)가 완료되었습니다."); // 메시지 추가
			response.put("redirectUrl", request.getContextPath()+"/admin/confirm");
		}	
		else {
			response.put("success", false);
            response.put("message", "처리 실패: 이미 처리되었거나 데이터베이스 오류가 발생했습니다.");
            response.put("redirectUrl", request.getContextPath()+"/admin/confirm"); 
		}
    	
		return ResponseEntity.status(HttpStatus.OK).body(response);
    }
    
    // 관리자 부지급 (반려)
    @PostMapping("admin/judge/reject")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> adminReject(@RequestBody AdminJudgeDTO judgeDTO, HttpServletRequest request){
    	
    	Map<String, Object> response = new HashMap<>();
    	UserDTO userDTO = currentUserOrNull();
        if (userDTO.getId() == null) { 
        	response.put("success", false);
			response.put("message", "로그인 해주세요.");
			response.put("redirectUrl", request.getContextPath()+"/login");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

    	boolean updateSuccess = adminApprovalService.adminReject(judgeDTO, userDTO.getId());
    	
    	if (updateSuccess) {
			response.put("success", true);
            response.put("message", "부지급 처리(반려)가 완료되었습니다.");
			response.put("redirectUrl", request.getContextPath()+"/admin/confirm");
		}	
		else {
			response.put("success", false);
            // Service에서 필수값(반려 사유) 누락 또는 이미 처리된 경우
			response.put("message", "처리 실패: 거절 사유가 누락되었거나 이미 처리된 신청서입니다.");
		}
    	
		return ResponseEntity.status(HttpStatus.OK).body(response);
    }
    
    // 관리자가 이미 처리했는지 확인
    @GetMapping("admin/judge/check/{confirmNumber}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> adminChecked(@PathVariable("confirmNumber") Long confirmNumber){ // [수정] PathVariable명을 confirmNumber로 통일
    	
    	Map<String, Object> response = new HashMap<>();
    	boolean adminChecked = adminApprovalService.adminChecked(confirmNumber);
    	if(adminChecked) {
    		response.put("adminChecked", true);
    		response.put("msg", "이미 최종 처리(ST_50)된 신청입니다.");
    	}
    	else
    		response.put("adminChecked", false);
    	
    	return ResponseEntity.status(HttpStatus.OK).body(response);
    }
    //상세페이지 조회 
    @GetMapping("admin/judge/detail/{confirmNumber}")
    public String adminCompDetailView(@PathVariable("confirmNumber") Long confirmNumber, Model model,
    		RedirectAttributes ra) {
    	try {
    		ConfirmApplyDTO confirmDTO = adminApprovalService.getConfirmDetail(confirmNumber);
    		ConfirmApplyDTO dto = companyApplyService.findByConfirmNumber(confirmNumber);
            if (confirmDTO == null) {
                ra.addFlashAttribute("error", "확인서를 찾을 수 없습니다.");
                return "redirect:/admin/confirm";
            }
            // 기업(신청자) 정보 조회
            UserDTO userDTO = userService.findById(confirmDTO.getUserId());
            if (userDTO == null) {
                ra.addFlashAttribute("error", "해당 신청자의 기업정보를 찾을 수 없습니다.");
                return "redirect:/admin/confirm";
            }
            // 제출 상태일 경우 심사중으로 변경
            if ("ST_20".equals(dto.getStatusCode())) {
            	adminApprovalService.updateStatusCode(confirmNumber);
                dto.setStatusCode("ST_30"); // DTO에도 반영
            }
            model.addAttribute("termList", dto.getTermAmounts()); 
            model.addAttribute("confirmDTO", confirmDTO);
            model.addAttribute("userDTO", userDTO);
            return "admin/admincompdetail";
            
    	} catch(Exception e) {
    		ra.addFlashAttribute("error", "상세 조회 중 오류 발생: " + e.getMessage());
    		return "redirect:/admin/confirm";
    	}
    }
}