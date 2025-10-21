package com.example.renewal_firstclass.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.renewal_firstclass.dao.CodeDAO;
import com.example.renewal_firstclass.domain.CodeDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CodeService {

	private final CodeDAO codeDAO;

	public List<CodeDTO> getRejectCodeList() {
		
		return codeDAO.findAllRejectCode();
	}

	public List<CodeDTO> getBankCodeList() {
		
		return codeDAO.findAllBankCode();
	}
}
