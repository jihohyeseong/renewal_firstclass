package com.example.renewal_firstclass.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.renewal_firstclass.domain.AdminListDTO;
import com.example.renewal_firstclass.domain.ApplicationSearchDTO;

@Mapper
public interface AdminConfirmListDAO {
    //검색(이름, 상태) 조회
    List<AdminListDTO> selectConfirmList(ApplicationSearchDTO search);

    //전체 조회
    int selectTotalCount(@Param("keyword") String keyword, @Param("status") String status, @Param("date") String date);

    //처리 상태별 조회
    int selectStatusCount(@Param("statusCode") String statusCode);
    
    //대기중 합산
    int selectStatusCountIn(@Param("codes") List<String> codes);
}