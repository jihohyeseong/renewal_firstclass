package com.example.renewal_firstclass.dao;

import org.apache.ibatis.annotations.Mapper;

import com.example.renewal_firstclass.domain.UserDTO;

@Mapper
public interface MyPageDAO {
	//사용자 정보 조회
	UserDTO findByUserName(String username);
	//주소 정보 수정
	int updateAddress(UserDTO userDTO);
	//전화번호 수정

}
