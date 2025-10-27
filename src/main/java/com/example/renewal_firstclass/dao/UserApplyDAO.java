package com.example.renewal_firstclass.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.renewal_firstclass.domain.ApplicationDTO;
import com.example.renewal_firstclass.domain.ApplicationDetailDTO;
import com.example.renewal_firstclass.domain.ApplyListDTO;
import com.example.renewal_firstclass.domain.SimpleConfirmVO;
import com.example.renewal_firstclass.domain.SimpleUserInfoVO;
import com.example.renewal_firstclass.domain.UserApplyCompleteVO;

@Mapper
public interface UserApplyDAO {
	
	SimpleUserInfoVO findByUsername(String username);
	
	List<SimpleConfirmVO> selectSimpleConfirmList(Map<String, String> params);

	ApplicationDTO getApplicationDTO(Long confirmNumber);
	
	ApplicationDTO getApplicationDTO2(@Param("confirmNumber")Long confirmNumber, @Param("termIdList")List<Long> termIdList);

	void insertApply(@Param("userId")Long userId, @Param("dto")ApplicationDTO applicationDTO);

	UserApplyCompleteVO findApplyAndCenter(@Param("applicationNumber")Long applicationNumber, @Param("centerId")Long centerId);

	List<ApplyListDTO> findApplyByUsername(String username);
	
	ApplicationDetailDTO findApplicationDetailByApplicationNumber(Long applicationNumber);

	void updateApplication(Long applicationNumber);

	void deleteApplication(Long applicationNumber);

	void cancelApplication(Long applicationNumber);

	void updateApplicationDetail(ApplicationDTO applicationDTO);

	String selectUsernameByConfirmNumber(Long confirmNumber);

	String selectUsernameByApplicationNumber(Long applicationNumber);

	void updateConfirmApply(ApplicationDTO applicationDTO);

	void updateTermApply(@Param("ids")List<Long> ids, @Param("applicationNumber")Long applicationNumber);

	void updateTermApplyBefore(Long confirmNumber);

}
