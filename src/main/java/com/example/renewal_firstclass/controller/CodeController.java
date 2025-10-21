package com.example.renewal_firstclass.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.renewal_firstclass.domain.CodeDTO;
import com.example.renewal_firstclass.service.CodeService;

import lombok.RequiredArgsConstructor;


@Controller
@RequiredArgsConstructor
public class CodeController {

	private final CodeService codeService;
	
	@GetMapping("/code/reject")
	@ResponseBody
	public ResponseEntity<List<CodeDTO>> getRejectCode() {
		
		List<CodeDTO> list = codeService.getRejectCodeList();
		
		return ResponseEntity.status(HttpStatus.OK).body(list);
	}
	
	@GetMapping("/code/bank")
	@ResponseBody
	public ResponseEntity<List<CodeDTO>> getBankCode(){
		
		List<CodeDTO> list = codeService.getBankCodeList();
		
		return ResponseEntity.status(HttpStatus.OK).body(list);
	}
}
