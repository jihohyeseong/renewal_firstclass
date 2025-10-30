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
import com.example.renewal_firstclass.domain.ApplicationDTO;
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

	// 관리자 접수(승인)
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
            response.put("message", "접수 처리(승인)가 완료되었습니다."); 
			response.put("redirectUrl", request.getContextPath()+"/admin/list");
		}	
		else {
			response.put("success", false);
            response.put("message", "처리 실패: 이미 처리되었거나 데이터베이스 오류가 발생했습니다.");
            response.put("redirectUrl", request.getContextPath()+"/admin/list"); 
		}
    	
		return ResponseEntity.status(HttpStatus.OK).body(response);
    }
    
    // 관리자 반려
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
            response.put("message", "반려 처리가 완료되었습니다.");
			response.put("redirectUrl", request.getContextPath()+"/admin/list");
		}	
		else {
			response.put("success", false);
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
    		ConfirmApplyDTO confirmDTO = adminApprovalService.getConfirmDetailWithUpdates(confirmNumber);
    		ConfirmApplyDTO dto = companyApplyService.findByConfirmNumber(confirmNumber);
            if (confirmDTO == null) {
                ra.addFlashAttribute("error", "확인서를 찾을 수 없습니다.");
                return "redirect:/admin/list";
            }
            
            // 기업(신청자) 정보 조회
            UserDTO userDTO = userService.findById(confirmDTO.getUserId());
            if (userDTO == null) {
                ra.addFlashAttribute("error", "해당 신청자의 기업정보를 찾을 수 없습니다.");
                return "redirect:/admin/list";
            }
            
            // 제출 상태일 경우 심사중으로 변경
            if ("ST_20".equals(dto.getStatusCode())) {
            	adminApprovalService.updateStatusCode(confirmNumber);
                dto.setStatusCode("ST_30"); 
            }
            model.addAttribute("termList", dto.getTermAmounts()); 
            model.addAttribute("confirmDTO", confirmDTO);
            model.addAttribute("userDTO", userDTO);
            return "admin/admincompdetail";
            
    	} catch(Exception e) {
    		ra.addFlashAttribute("error", "상세 조회 중 오류 발생: " + e.getMessage());
    		return "redirect:/admin/list";
    	}
    }
    
	 // 육아휴직 등록 수정
	 @PostMapping("/admin/judge/update")
	 @ResponseBody
	 public ResponseEntity<Map<String, Object>> updateConfirm(
	             @RequestBody ConfirmApplyDTO dto,
	             HttpServletRequest request) {
	
	     Map<String, Object> response = new HashMap<>();
	     UserDTO userDTO = currentUserOrNull();
	
	     // 1. 인증 및 권한 확인 (기존 로직 유지)
	     if (userDTO == null || userDTO.getId() == null) {
	         response.put("success", false);
	         response.put("message", "로그인 해주세요.");
	         response.put("redirectUrl", request.getContextPath() + "/login");
	         return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
	     }
	
	     Long confirmNumber = dto.getConfirmNumber();
	     
	     try {
	         // 2. 서비스 호출 전 유효성/권한 검증을 위한 원본 조회
	         // * 서비스 호출 전에 원본 DTO를 조회하여 userId를 설정하고 신청서 존재 여부를 확인합니다.
	         ConfirmApplyDTO original = companyApplyService.findByConfirmNumber(confirmNumber);
	         
	         if (original == null) {
	             response.put("success", false);
	             response.put("message", "확인서를 찾을 수 없습니다.");
	             return ResponseEntity.ok(response);
	         }
	
	         // 3. DTO에 필수 정보 설정 (처리자 ID, 신청자 ID)
	         dto.setProcessorId(userDTO.getId()); // 관리자 ID 설정
	         dto.setUserId(original.getUserId()); // 신청자 ID 설정 (옵션: 보안 강화를 위해)
	
	         // 4. 서비스 호출 및 성공 여부 확인
	         // * DTO에 monthlyCompanyPay가 포함되어 서비스로 전달됩니다.
	         boolean updateSuccess = adminApprovalService.saveConfirmEdits(dto); 
	         
	         if (!updateSuccess) {
	             // 서비스에서 false를 반환하면 업데이트 실패로 간주합니다.
	             throw new IllegalStateException("확인서 업데이트에 실패했습니다. (DB 오류 또는 업데이트 대상 없음)");
	         }
	         
	         // 5. 업데이트된 최신 DTO 조회
	         // * 수정이 완료된 confirmNumber로 다시 조회하여 최신 데이터를 클라이언트에 전달합니다.
	         ConfirmApplyDTO updatedDto = companyApplyService.findByConfirmNumber(confirmNumber);
	         
	         // 6. 성공 응답
	         response.put("success", true);
	         response.put("message", "확인서 수정 및 단위기간 재등록이 완료되었습니다.");
	         response.put("data", updatedDto);
	
	     } catch (IllegalStateException e) {
	         // DB 저장 실패 또는 서비스 계층에서 던진 비즈니스 로직 오류
	         log.error("확인서 수정 실패: {}", e.getMessage());
	         response.put("success", false);
	         response.put("message", "수정 실패: " + e.getMessage());
	     } catch (Exception e) {
	         // 기타 예상치 못한 오류
	         log.error("확인서 수정 중 오류 발생", e);
	         response.put("success", false);
	         response.put("message", "예상치 못한 오류가 발생했습니다.");
	     }
	
	     return ResponseEntity.ok(response);
	 	}
}