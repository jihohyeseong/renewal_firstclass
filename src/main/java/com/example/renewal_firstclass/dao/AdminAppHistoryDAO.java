package com.example.renewal_firstclass.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.renewal_firstclass.domain.AdminAppHistoryDTO;
import com.example.renewal_firstclass.domain.CompSearchDTO;

@Mapper
public interface AdminAppHistoryDAO {
    List<AdminAppHistoryDTO> selectAppHistoryList(CompSearchDTO searchDTO);
    int selectAppHistoryCount(CompSearchDTO searchDTO);
}
