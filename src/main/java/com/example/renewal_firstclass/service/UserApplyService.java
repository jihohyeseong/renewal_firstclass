package com.example.renewal_firstclass.service;

import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.transaction.Transactional;

import org.springframework.stereotype.Service;

import com.example.renewal_firstclass.dao.UserApplyDAO;
import com.example.renewal_firstclass.dao.UserDAO;
import com.example.renewal_firstclass.domain.ApplicationDTO;
import com.example.renewal_firstclass.domain.ApplicationDetailDTO;
import com.example.renewal_firstclass.domain.ApplyListDTO;
import com.example.renewal_firstclass.domain.SimpleConfirmVO;
import com.example.renewal_firstclass.domain.SimpleUserInfoVO;
import com.example.renewal_firstclass.domain.TermAmountDTO;
import com.example.renewal_firstclass.domain.UserApplyCompleteVO;
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
		if(applicationDTO == null) {
			return null;
		}
		try {
			applicationDTO.setRegistrationNumber(aes256Util.decrypt(applicationDTO.getRegistrationNumber()));
			if(applicationDTO.getChildResiRegiNumber() != null)
				applicationDTO.setChildResiRegiNumber(aes256Util.decrypt(applicationDTO.getChildResiRegiNumber()));
		} catch (Exception e) {
			e.printStackTrace();
		}
		String regiNum = applicationDTO.getRegistrationNumber();
		applicationDTO.setRegistrationNumber(regiNum.substring(0,6) + "-" + regiNum.substring(6));
		List<TermAmountDTO> list = applicationDTO.getList();
		System.out.println(list);
		if (list != null && !list.isEmpty()) {
			boolean hasUpdateY = list.stream().anyMatch(term -> "Y".equals(term.getUpdateAt()));
			if (hasUpdateY) {
		        list = list.stream()
		                   .filter(term -> "Y".equals(term.getUpdateAt()))
		                   .collect(Collectors.toList());
		    }
			List<TermAmountDTO> orderedList = list.stream()
					  							  .sorted((term1, term2) -> (int)term1.getPaymentDate().getTime() - (int)term2.getPaymentDate().getTime())
					  							  .collect(Collectors.toList());
			System.out.println(orderedList);
			applicationDTO.setList(orderedList);
		}
		
		return applicationDTO;
	}
	
	public ApplicationDTO getApplicationDTO2(Long confirmNumber, List<Long> termIdList) {
		
		ApplicationDTO applicationDTO = userApplyDAO.getApplicationDTO2(confirmNumber, termIdList);
		if(applicationDTO == null) {
			return null;
		}
		try {
			applicationDTO.setRegistrationNumber(aes256Util.decrypt(applicationDTO.getRegistrationNumber()));
			applicationDTO.setChildResiRegiNumber(aes256Util.decrypt(applicationDTO.getChildResiRegiNumber()));
		} catch (Exception e) {
			e.printStackTrace();
		}
		String regiNum = applicationDTO.getRegistrationNumber();
		applicationDTO.setRegistrationNumber(regiNum.substring(0,6) + "-" + regiNum.substring(6));
		List<TermAmountDTO> list = applicationDTO.getList();
		if (list != null && !list.isEmpty()) {
			boolean hasUpdateY = list.stream().anyMatch(term -> "Y".equals(term.getUpdateAt()));
			if (hasUpdateY) {
		        List<TermAmountDTO> filteredList = list.stream()
		                                               .filter(term -> "Y".equals(term.getUpdateAt()))
		                                               .collect(Collectors.toList());
		        
		        applicationDTO.setList(filteredList);
		    }
		}
		
		return applicationDTO;
	}

	@Transactional
	public void insertApply(ApplicationDTO applicationDTO) {
		
		String regiNum = applicationDTO.getRegistrationNumber();
		applicationDTO.setRegistrationNumber(regiNum.substring(0,6) + regiNum.substring(7));
		try {
			applicationDTO.setRegistrationNumber(aes256Util.encrypt(applicationDTO.getRegistrationNumber()));
			applicationDTO.setChildResiRegiNumber(aes256Util.encrypt(applicationDTO.getChildResiRegiNumber()));
		} catch (Exception e) {
			e.printStackTrace();
		}
		Long userId = userDAO.findByRegistrationNumber(applicationDTO.getRegistrationNumber());
		List<Long> ids = new ArrayList<>();
		for(TermAmountDTO dto : applicationDTO.getList()) {
			ids.add(dto.getTermId());
		}
		
		userApplyDAO.updateConfirmApply(applicationDTO);
		userApplyDAO.insertApply(userId, applicationDTO);
		userApplyDAO.updateTermApply(ids, applicationDTO.getApplicationNumber());
	}

	public List<ApplyListDTO> getApplyList(String username) {
		
		return userApplyDAO.findApplyByUsername(username);
	}

	public ApplicationDetailDTO getApplicationDetail(Long applicationNumber) {
		
		
		ApplicationDetailDTO dto = userApplyDAO.findApplicationDetailByApplicationNumber(applicationNumber);
		
		if(dto != null) {
			try {
				dto.setRegistrationNumber(aes256Util.decrypt(dto.getRegistrationNumber()));
				dto.setChildResiRegiNumber(aes256Util.decrypt(dto.getChildResiRegiNumber()));
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return dto;
	}

	public UserApplyCompleteVO submitApply(Long applicationNumber) {
		
		userApplyDAO.updateApplication(applicationNumber);
		ApplicationDetailDTO dto = userApplyDAO.findApplicationDetailByApplicationNumber(applicationNumber);
		UserApplyCompleteVO vo = userApplyDAO.findApplyAndCenter(dto.getApplicationNumber(), dto.getCenterId());
		vo.setName(dto.getName());
		
		return vo;
	}

	@Transactional
	public void deleteApply(Long applicationNumber, List<Long> termIdList) {
		
		userApplyDAO.updateTermEarlyAndGov(applicationNumber);
		userApplyDAO.updateTermApplyBefore(termIdList);
		userApplyDAO.deleteApplication(applicationNumber);
	}

	public void cancelApply(Long applicationNumber) {
		
		userApplyDAO.cancelApplication(applicationNumber);
	}

	@Transactional
	public void updateApplication(ApplicationDTO applicationDTO, List<Long> termIdList, boolean early) {
		
		try {
			applicationDTO.setChildResiRegiNumber(aes256Util.encrypt(applicationDTO.getChildResiRegiNumber()));
		} catch (Exception e) {
			e.printStackTrace();
		}
		List<Long> ids = new ArrayList<>();
		for(TermAmountDTO dto : applicationDTO.getList()) {
			ids.add(dto.getTermId());
		}
		userApplyDAO.updateConfirmApply(applicationDTO);
		userApplyDAO.updateApplicationDetail(applicationDTO);
		userApplyDAO.updateTermEarlyAndGov(applicationDTO.getApplicationNumber());
		userApplyDAO.updateTermApplyBefore(termIdList);
		userApplyDAO.updateTermApply(ids, applicationDTO.getApplicationNumber());
		applyEarlyTerm(applicationDTO.getEndDate(), applicationDTO.getList().get(applicationDTO.getList().size() - 1));
	}

	public boolean userCheck(Long confirmNumber, String name) {
		
		String username = userApplyDAO.selectUsernameByConfirmNumber(confirmNumber);
		if(username == null)
			return false;
		
		return username.equals(name) ? true : false;
	}

	public boolean userDetailCheck(Long applicationNumber, String name) {
		
		String username = userApplyDAO.selectUsernameByApplicationNumber(applicationNumber);
		if(username == null)
			return false;
		
		return username.equals(name) ? true : false;
	}

	@Transactional
	public void applyEarlyTerm(Date endDate, TermAmountDTO termAmountDTO) {
		
		termAmountDTO.setEndMonthDate(endDate);
		userApplyDAO.updateTermEarly(termAmountDTO);
		userApplyDAO.updateTermDelt(termAmountDTO);
	}

	public Long confirmCheck(Long confirmNumber) {
		
		return userApplyDAO.countByConfirmNumber(confirmNumber);
	}

	public boolean completeCheck(Long confirmNumber) {
		
		int num = userApplyDAO.completeCheckByConfirmNumber(confirmNumber);
		
		return num > 0 ? true : false;
	}

	public List<SimpleConfirmVO> mySimpleConfirmList(String username) {
		
		return userApplyDAO.getMySimpleConfirmList(username);
	}

}
