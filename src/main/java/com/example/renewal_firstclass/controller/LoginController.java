package com.example.renewal_firstclass.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class LoginController {

	// 로그인 페이지
	@GetMapping("/login")
	public String loginPage() {
		
		return "logintest";
	}
	
	
	@GetMapping("/admin")
	public String adminTestPage() {
		
		return "admintest";
	}
	
}
