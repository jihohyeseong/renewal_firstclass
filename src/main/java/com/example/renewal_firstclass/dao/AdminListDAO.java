package com.example.renewal_firstclass.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.renewal_firstclass.domain.AdminListDTO;

@Mapper
public interface AdminListDAO {
    List<AdminListDTO> selectApplyAndConfirm(Map<String, Object> params);

    int countApplyAndConfirm(Map<String, Object> params);
}