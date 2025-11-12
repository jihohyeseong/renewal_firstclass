package com.example.renewal_firstclass.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.example.renewal_firstclass.domain.AdminListDTO;
import com.example.renewal_firstclass.domain.AdminUserApprovalDTO;
import com.example.renewal_firstclass.domain.ApplicationSearchDTO;
import com.example.renewal_firstclass.domain.TermAmountDTO;

@Mapper
public interface AdminAddAmountDAO {
    
    //검색(이름, 상태) 조회
    List<AdminUserApprovalDTO> selectApplicationList(ApplicationSearchDTO search);

    //전체 조회
    int selectTotalCount(@Param("nameKeyword") String nameKeyword, @Param("appNoKeyword") Long appNoKeyword,
    		@Param("status") String status, @Param("date") String date);

    //처리 상태별 조회
    int selectStatusCount(@Param("statusCode") String statusCode, @Param("paymentResult") String paymentResult);
    
}