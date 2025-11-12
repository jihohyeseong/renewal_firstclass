package com.example.renewal_firstclass.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.renewal_firstclass.domain.AdminAddAmountDTO;
import com.example.renewal_firstclass.domain.AdminUserApprovalDTO;
import com.example.renewal_firstclass.domain.ApplicationSearchDTO;

@Mapper
public interface AdminAddAmountDAO {
    
    //검색(이름, 상태) 조회
    List<AdminUserApprovalDTO> selectApplicationList(ApplicationSearchDTO search);

    //전체 조회
    int selectTotalCount(@Param("nameKeyword") String nameKeyword, @Param("appNoKeyword") Long appNoKeyword,
    		@Param("status") String status, @Param("date") String date);

    //처리 상태별 조회
    int selectStatusCount(@Param("statusCode") String statusCode, @Param("paymentResult") String paymentResult);
    
    // 처리 여부
    int isProcessed(@Param("applicationNumber") Long applicationNumber);
    
    //추가지급 신청 상세페이지
    AdminUserApprovalDTO selectAppDetailByAppNo(@Param("applicationNumber") long applicationNumber);
    
    // 저장된 추가지급 내역 조회
    List<AdminAddAmountDTO> selectAddAmountDetails(@Param("applicationNumber") long applicationNumber);
    
    //추가지급 신청(새로운 추가지급 테이블 생성)
    int applyAddAmount(@Param("add") List<AdminAddAmountDTO> add);
    
    // 추가지급 사유 코드 목록 조회
    List<Map<String, Object>> selectAddAmountReasonCodes();
}