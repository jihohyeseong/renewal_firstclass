package com.example.renewal_firstclass.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.renewal_firstclass.domain.CodeDTO;

@Mapper
public interface CodeDAO {

	List<CodeDTO> findAllRejectCode();

	List<CodeDTO> findAllBankCode();
	
}
