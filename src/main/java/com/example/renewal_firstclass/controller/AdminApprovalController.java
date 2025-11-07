package com.example.renewal_firstclass.controller;

import java.io.IOException;
import java.sql.Date;
import java.text.SimpleDateFormat;
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
import com.example.renewal_firstclass.service.UserService;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.TypeAdapter;
import com.google.gson.stream.JsonReader;
import com.google.gson.stream.JsonWriter;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
public class AdminApprovalController {
	private final UserService userService;
	private final AdminApprovalService adminApprovalService;
	
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
    
    // 날짜 포맷팅
    private static final TypeAdapter<Date> SQL_DATE_ADAPTER = new TypeAdapter<Date>() {
        private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        @Override
        public void write(JsonWriter out, Date value) throws IOException {
            if (value == null) {
                out.nullValue();
            } else {
                out.value(dateFormat.format(value));
            }
        }
        @Override
        public Date read(JsonReader in) throws IOException {
            return null;
        }
    };

    // Gson 객체 생성
    private final Gson gson = new GsonBuilder()
            .registerTypeAdapter(Date.class, SQL_DATE_ADAPTER)
            .create();
    
    //상세페이지 조회 
    @GetMapping("admin/judge/detail/{confirmNumber}")
    public String adminCompDetailView(@PathVariable("confirmNumber") Long confirmNumber, Model model,
    		RedirectAttributes ra) {
    	try {

            ConfirmApplyDTO confirmDTO = adminApprovalService.getConfirmForEditing(confirmNumber);
            
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
            /*if ("ST_20".equals(confirmDTO.getStatusCode())) {
                adminApprovalService.updateStatusCode(confirmNumber);
                confirmDTO.setStatusCode("ST_30");
            }*/

            model.addAttribute("gson", gson);
            model.addAttribute("confirmDTO", confirmDTO);
            model.addAttribute("userDTO", userDTO);
            
            return "admin/admincompdetail";
            
        } catch (Exception e) {
            log.error("관리자 상세 조회 중 오류 발생", e);
            ra.addFlashAttribute("error", "상세 조회 중 오류 발생: " + e.getMessage());
            return "redirect:/admin/list";
        }
    }
    
	 // 확인서 수정 저장
	 @PostMapping("/admin/judge/update")
	 @ResponseBody
	 public ResponseEntity<Map<String, Object>> updateConfirm(
	             @RequestBody ConfirmApplyDTO dto,
	             HttpServletRequest request) {
	
	     Map<String, Object> response = new HashMap<>();
	     UserDTO userDTO = currentUserOrNull();
	
	     if (userDTO == null || userDTO.getId() == null) {
	         response.put("success", false);
	         response.put("message", "로그인 해주세요.");
	         response.put("redirectUrl", request.getContextPath() + "/login");
	         return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
	     }
	     
	     try {
	         dto.setProcessorId(userDTO.getId());
	         
	         // 수정사항 저장
	         boolean updateSuccess = adminApprovalService.saveConfirmEdits(dto);
	         if (!updateSuccess) {
	             throw new IllegalStateException("확인서 정보 업데이트에 실패했습니다.");
	         }
	         
	         // 저장 후, 모든 최신 데이터를 다시 조회하여 클라이언트에 전달
	         ConfirmApplyDTO updatedFullDto = adminApprovalService.getConfirmForEditing(dto.getConfirmNumber());
	         
	         response.put("success", true);
	         response.put("message", "확인서 수정 및 단위기간 재등록이 완료되었습니다.");
	         response.put("data", updatedFullDto);

	     } catch (Exception e) {
	         log.error("확인서 수정 중 오류 발생", e);
	         response.put("success", false);
	         response.put("message", "수정 실패: " + e.getMessage());
	     }
	     
	     return ResponseEntity.ok(response);
	 	}
}