package com.example.renewal_firstclass.controller;

import java.util.HashMap;
import java.util.Map;

import javax.validation.Valid;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.renewal_firstclass.domain.JoinDTO;
import com.example.renewal_firstclass.domain.UsernameCheckDTO;
import com.example.renewal_firstclass.service.JoinService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@Validated
public class CompanyApplyController {
	@GetMapping("/comp/main")
	public String compMain() {
		
		return "company/compmain";
	}
	
	@GetMapping("/comp/apply")
	public String compApply() {
		
		return "company/compapply";
	}

}
