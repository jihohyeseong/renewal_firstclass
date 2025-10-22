package com.example.renewal_firstclass.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.example.renewal_firstclass.dao.UserApplyDAO;
import com.example.renewal_firstclass.dao.UserDAO;
import com.example.renewal_firstclass.domain.ApplicationDTO;
import com.example.renewal_firstclass.domain.SimpleConfirmVO;
import com.example.renewal_firstclass.domain.SimpleUserInfoVO;
import com.example.renewal_firstclass.util.AES256Util;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserApplyService {

	private final UserApplyDAO userApplyDAO;
	private final UserDAO userDAO;
	private final AES256Util aes256Util;

	public List<SimpleConfirmVO> selectSimpleConfirmList(String name, String registrationNumber) {
		
		Map<String, String> params = new HashMap<>();
		params.put("name", name);
		params.put("registrationNumber", registrationNumber);
		
		return userApplyDAO.selectSimpleConfirmList(params);
	}

	public SimpleUserInfoVO getUserInfo(String username) {
		
		return userApplyDAO.findByUsername(username);
	}

	public ApplicationDTO getApplicationDTO(Long confirmNumber) {
		
		ApplicationDTO applicationDTO = userApplyDAO.getApplicationDTO(confirmNumber);
		try {
			applicationDTO.setRegistrationNumber(aes256Util.decrypt(applicationDTO.getRegistrationNumber()));
			applicationDTO.setChildResiRegiNumber(aes256Util.decrypt(applicationDTO.getChildResiRegiNumber()));
		} catch (Exception e) {
			e.printStackTrace();
		}
		String regiNum = applicationDTO.getRegistrationNumber();
		applicationDTO.setRegistrationNumber(regiNum.substring(0,6) + "-" + regiNum.substring(6));
		
		return applicationDTO;
	}

	public void insertApply(ApplicationDTO applicationDTO) {
		
		String regiNum = applicationDTO.getRegistrationNumber();
		applicationDTO.setRegistrationNumber(regiNum.substring(0,6) + regiNum.substring(7));
		try {
			applicationDTO.setRegistrationNumber(aes256Util.encrypt(applicationDTO.getRegistrationNumber()));
		} catch (Exception e) {
			e.printStackTrace();
		}
		Long userId = userDAO.findByRegistrationNumber(applicationDTO.getRegistrationNumber());
		userApplyDAO.insertApply(userId, applicationDTO);
	}
}
