package com.example.renewal_firstclass.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;


import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class UserApplyController {
	
	@GetMapping("/user/main")
	public String userMain() {
		
		return "user/main";
	}

}
