package com.example.renewal_firstclass.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.renewal_firstclass.domain.CenterDTO;
import com.example.renewal_firstclass.service.CenterService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class CenterController {
	
	private final CenterService centerService;

	@GetMapping("/center/list")
	@ResponseBody
	public ResponseEntity<List<CenterDTO>> getCenterList() {
		
		List<CenterDTO> list = centerService.getCenterList();
		
		return ResponseEntity.status(HttpStatus.OK).body(list);
	}
}
