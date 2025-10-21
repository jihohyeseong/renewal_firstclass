package com.example.renewal_firstclass.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.renewal_firstclass.domain.CenterDTO;


@Mapper
public interface CenterDAO {

	List<CenterDTO> getCenterList();

}
