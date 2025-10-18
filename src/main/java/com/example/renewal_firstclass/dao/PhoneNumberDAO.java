package com.example.renewal_firstclass.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface PhoneNumberDAO {

	void save(@Param("id")Long id, @Param("phoneNumber")String phoneNumber);

}
