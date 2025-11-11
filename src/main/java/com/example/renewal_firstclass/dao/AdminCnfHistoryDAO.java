package com.example.renewal_firstclass.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.renewal_firstclass.domain.AdminCnfHistoryDTO;
import com.example.renewal_firstclass.domain.CompSearchDTO;

@Mapper
public interface AdminCnfHistoryDAO {
    List<AdminCnfHistoryDTO> selectCnfHistoryList(CompSearchDTO searchDTO);
    int selectCnfHistoryCount(CompSearchDTO searchDTO);
}
