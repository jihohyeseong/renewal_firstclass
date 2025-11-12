package com.example.renewal_firstclass.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AdminAddAmountController {
	
	@GetMapping("admin/addamount")
	public String showAddAmountList() {
		
		return "admin/adminaddamount";
	}
}
