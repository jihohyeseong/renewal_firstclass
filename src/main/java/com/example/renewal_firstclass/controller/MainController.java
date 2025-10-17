package com.example.renewal_firstclass.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MainController {

	@GetMapping("/calc/corp")
	public String caculatorMain() {
		
		return "company/calcmain_corp";
	}
}
