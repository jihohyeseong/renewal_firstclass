package com.example.renewal_firstclass.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.renewal_firstclass.domain.ApplicationDTO;
import com.example.renewal_firstclass.domain.SimpleConfirmVO;
import com.example.renewal_firstclass.domain.SimpleUserInfoVO;

@Mapper
public interface UserApplyDAO {
	
	SimpleUserInfoVO findByUsername(String username);
	
	List<SimpleConfirmVO> selectSimpleConfirmList(Map<String, String> params);

	ApplicationDTO getApplicationDTO(Long confirmNumber);

	void insertApply(@Param("userId")Long userId, @Param("dto")ApplicationDTO applicationDTO);
}
