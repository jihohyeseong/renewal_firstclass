package com.example.renewal_firstclass.controller;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.renewal_firstclass.domain.ApplicationDTO;
import com.example.renewal_firstclass.domain.ApplicationDetailDTO;
import com.example.renewal_firstclass.domain.ApplyListDTO;
import com.example.renewal_firstclass.domain.SimpleConfirmVO;
import com.example.renewal_firstclass.domain.SimpleUserInfoVO;
import com.example.renewal_firstclass.domain.UserApplyCompleteVO;
import com.example.renewal_firstclass.service.UserApplyService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class UserApplyController {
	
	private final UserApplyService userApplyService;
	
	// 유저 메인페이지
	@GetMapping("/user/main")
	public String userMain(Principal principal, Model model, HttpSession session) {
		
		String username = principal.getName();
		SimpleUserInfoVO simpleUserInfoVO = userApplyService.getUserInfo(username);
		List<ApplyListDTO> list = userApplyService.getApplyList(username);
		model.addAttribute("simpleUserInfoVO", simpleUserInfoVO);
		model.addAttribute("list", list);
		session.removeAttribute("simpleConfirmList");
		
		return "user/main";
	}
	
	// 회사가 승인한 신청들 요청
	@PostMapping("/user/confirms")
	public String companyConfirmsPage(@RequestParam String name, @RequestParam String registrationNumber, HttpSession session) {
		
		List<SimpleConfirmVO> simpleConfirmList = userApplyService.selectSimpleConfirmList(name, registrationNumber);
		session.setAttribute("simpleConfirmList", simpleConfirmList);
		
		return "redirect:/user/confirms/list";
	}
	
	// 회사가 승인한 신청들 보여주는 페이지
	@GetMapping("/user/confirms/list")
	public String companyConfirmListsPage() {
		
		return "user/confirm_list";
	}
	
	// 육아휴직 급여 신청페이지
	@GetMapping("/user/application/{confirmNumber}")
	public String applicationPage(@PathVariable Long confirmNumber, Model model) {
		
		ApplicationDTO applicationDTO = userApplyService.getApplicationDTO(confirmNumber);
		model.addAttribute("applicationDTO", applicationDTO);
		model.addAttribute("confirmNumber", confirmNumber);
		
		return "user/application";
	}
	
	// 육아휴직 급여 저장
	@PostMapping("/user/apply")
	public String applyUserApplication(ApplicationDTO applicationDTO, boolean early, RedirectAttributes redirectAttributes, Model model) {
		
		if(applicationDTO.getBankCode() == null || applicationDTO.getAccountNumber() == null || applicationDTO.getCenterId() == null || applicationDTO.getGovInfoAgree() == null) {
			model.addAttribute("applicationDTO", applicationDTO);
			return "user/application";
		}
		if(early)
			userApplyService.applyEarlyTerm(applicationDTO.getEndDate(), applicationDTO.getList().get(applicationDTO.getList().size() - 1));
		userApplyService.insertApply(applicationDTO);
		
		return "redirect:/user/detail/" + applicationDTO.getApplicationNumber();
	}
	
	// 육아휴직 급여 제출
	@PostMapping("/user/submit/{applicationNumber}")
	public String submitApplication(@PathVariable Long applicationNumber, RedirectAttributes redirectAttributes) {
		
		UserApplyCompleteVO vo = userApplyService.submitApply(applicationNumber);
		redirectAttributes.addFlashAttribute("vo", vo);
		
		return "redirect:/user/complete";
	}
	
	// 임시저장중 삭제
	@PostMapping("/user/delete/{applicationNumber}")
	public String deleteApplication(@PathVariable Long applicationNumber, 
									@RequestParam(value = "termId", required = false) List<Long> termIdList) {
		
		userApplyService.deleteApply(applicationNumber, termIdList);
		
		return "redirect:/user/main";
	}
	
	// 제출중 신청 취소
	@PostMapping("/user/cancel/{applicationNumber}")
	public String cancelApplication(@PathVariable Long applicationNumber) {
		
		userApplyService.cancelApply(applicationNumber);
		
		return "redirect:/user/detail/" + applicationNumber;
	}
	
	// 육아휴직 등록 수정페이지 이동
	@PostMapping("/user/application/update/{applicationNumber}")
	public String updateApplicationPage(@PathVariable Long applicationNumber,
										@RequestParam(value = "termId", required = false) List<Long> termIdList, 
										Model model) {
		
		ApplicationDetailDTO applicationDetailDTO = userApplyService.getApplicationDetail(applicationNumber);
		Long confirmNumber = applicationDetailDTO.getConfirmNumber();
		ApplicationDTO applicationDTO = userApplyService.getApplicationDTO2(confirmNumber, termIdList);
		model.addAttribute("applicationDTO", applicationDTO);
		model.addAttribute("applicationDetailDTO", applicationDetailDTO);
		model.addAttribute("termIdList", termIdList);
		
		return "user/application";
	}
	
	// 육아휴직 등록 수정
	@PostMapping("/user/update")
	public String updateApplication(ApplicationDTO applicationDTO, 
									@RequestParam(value = "termIdList", required = false) List<Long> termIdList,
									boolean early,
									Model model) {

		if(applicationDTO.getBankCode() == null || applicationDTO.getAccountNumber() == null || applicationDTO.getCenterId() == null || applicationDTO.getGovInfoAgree() == null) {
			model.addAttribute("applicationDTO", applicationDTO);
			return "user/application";
		}
		userApplyService.updateApplication(applicationDTO, termIdList, early);
		
		return "redirect:/user/detail/" + applicationDTO.getApplicationNumber();
	}
	
	// 육아휴직 제출 완료페이지
	@GetMapping("/user/complete")
	public String completePage() {
	    
		return "user/complete";
	}
	
	// 육아휴직 급여 상세페이지
	@GetMapping("/user/detail/{applicationNumber}")
	public String userDetailPage(@PathVariable Long applicationNumber, Model model) {
		
		ApplicationDetailDTO applicationDetailDTO = userApplyService.getApplicationDetail(applicationNumber);
		model.addAttribute("dto", applicationDetailDTO);
		
		return "user/applicationDetail";
	}
	
	// 신청서 AJAX 본인검증
	@GetMapping("/user/check/{confirmNumber}")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> userCheck(@PathVariable Long confirmNumber, Principal principal){
		
		Map<String, Object> response = new HashMap<>();
		boolean hasAuth = userApplyService.userCheck(confirmNumber, principal.getName());
		if (hasAuth) {
			response.put("success", true);
		} 
		else {
			response.put("success", false);
			response.put("message", "권한이 없습니다.");
			response.put("redirectUrl", "/user/main");
		}
    	
		return ResponseEntity.status(HttpStatus.OK).body(response);
		
	}
	
	// 신청서 AJAX 완료검증
	@GetMapping("user/check/{confirmNumber}/complete")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> isCompleteCheck(@PathVariable Long confirmNumber){
		
		Map<String, Object> response = new HashMap<>();
		boolean isComplete = userApplyService.completeCheck(confirmNumber);
		if(isComplete) {
			response.put("success", false);
			response.put("message", "완료된 신청입니다.");
			response.put("redirectUrl", "/user/main");
		}
		else {
			response.put("success", true);
		}
		
		return ResponseEntity.status(HttpStatus.OK).body(response);
	}
	
	// 상세보기 AJAX 본인검증
	@GetMapping("/user/check/detail/{applicationNumber}")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> userDetailCheck(@PathVariable Long applicationNumber, Principal principal){
		
		Map<String, Object> response = new HashMap<>();
		boolean hasAuth = userApplyService.userDetailCheck(applicationNumber, principal.getName());
		if (hasAuth) {
			response.put("success", true);
		} 
		else {
			response.put("success", false);
			response.put("message", "권한이 없습니다.");
			response.put("redirectUrl", "/user/main");
		}
    	
		return ResponseEntity.status(HttpStatus.OK).body(response);
		
	}
	
	
	// 진행중인 신청 있는지 확인 AJAX
	@GetMapping("/user/check/confirm/{confirmNumber}")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> confirmCheck(@PathVariable Long confirmNumber){
		
		Map<String, Object> response = new HashMap<>();
		Long applicationNumber = userApplyService.confirmCheck(confirmNumber);
		if(applicationNumber != null) {
			response.put("success", false);
			response.put("message", "이미 진행중인 신청이 있습니다.");
			response.put("redirectUrl", "/user/detail/" + applicationNumber);
		}
		else
			response.put("success", true);
		
		return ResponseEntity.status(HttpStatus.OK).body(response);
	}

}
