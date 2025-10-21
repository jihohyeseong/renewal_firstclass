package com.example.renewal_firstclass.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.renewal_firstclass.dao.CenterDAO;
import com.example.renewal_firstclass.domain.CenterDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CenterService {

	private final CenterDAO centerDAO;

	public List<CenterDTO> getCenterList() {
		
		return centerDAO.getCenterList();
	}
}
