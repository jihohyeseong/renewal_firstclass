package com.example.renewal_firstclass.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
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
	public String userMain(Principal principal, Model model) {
		
		String username = principal.getName();
		SimpleUserInfoVO simpleUserInfoVO = userApplyService.getUserInfo(username);
		List<ApplyListDTO> list = userApplyService.getApplyList(username);
		model.addAttribute("simpleUserInfoVO", simpleUserInfoVO);
		model.addAttribute("list", list);
		
		return "user/main";
	}
	
	// 회사가 승인한 신청들 보여주는 페이지
	@PostMapping("/user/confirms")
	public String companyConfirmsPage(@RequestParam String name, @RequestParam String registrationNumber, Model model) {
		
		List<SimpleConfirmVO> simpleConfirmList = userApplyService.selectSimpleConfirmList(name, registrationNumber);
		model.addAttribute("simpleConfirmList", simpleConfirmList);
		
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
	public String applyUserApplication(ApplicationDTO applicationDTO, RedirectAttributes redirectAttributes) {
		
		userApplyService.insertApply(applicationDTO);
		
		return "redirect:/user/main";
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
	public String deleteApplication(@PathVariable Long applicationNumber) {
		
		userApplyService.deleteApply(applicationNumber);
		
		return "redirect:/user/main";
	}
	
	// 제출중 신청 취소
	@PostMapping("/user/cancel/{applicationNumber}")
	public String cancelApplication(@PathVariable Long applicationNumber) {
		
		userApplyService.cancelApply(applicationNumber);
		
		return "redirect:/user/main";
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

}
