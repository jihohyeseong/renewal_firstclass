package com.example.renewal_firstclass.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.renewal_firstclass.domain.ApplicationDTO;
import com.example.renewal_firstclass.domain.SimpleConfirmVO;
import com.example.renewal_firstclass.domain.SimpleUserInfoVO;
import com.example.renewal_firstclass.service.UserApplyService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class UserApplyController {
	
	private final UserApplyService userApplyService;
	
	@GetMapping("/user/main")
	public String userMain(Principal principal, Model model) {
		
		String username = principal.getName();
		SimpleUserInfoVO simpleUserInfoVO = userApplyService.getUserInfo(username);
		model.addAttribute("simpleUserInfoVO", simpleUserInfoVO);
		
		return "user/main";
	}
	
	@PostMapping("/user/confirms")
	public String companyConfirmsPage(@RequestParam String name, @RequestParam String registrationNumber, Model model) {
		
		List<SimpleConfirmVO> simpleConfirmList = userApplyService.selectSimpleConfirmList(name, registrationNumber);
		model.addAttribute("simpleConfirmList", simpleConfirmList);
		
		return "user/confirm_list";
	}
	
	@GetMapping("/user/application/{confirmNumber}")
	public String applicationPage(@PathVariable Long confirmNumber, Model model) {
		
		ApplicationDTO applicationDTO = userApplyService.getApplicationDTO(confirmNumber);
		model.addAttribute("applicationDTO", applicationDTO);
		model.addAttribute("confirmNumber", confirmNumber);
		
		return "user/application";
	}
	
	@PostMapping("/user/apply")
	public String applyUserApplication(ApplicationDTO applicationDTO, Model model) {
		
		userApplyService.insertApply(applicationDTO);
		model.addAttribute("applicationDTO", applicationDTO);
		
		return "user/complete";
	}

}
