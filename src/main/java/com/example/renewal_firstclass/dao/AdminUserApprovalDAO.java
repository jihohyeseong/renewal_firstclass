package com.example.renewal_firstclass.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.renewal_firstclass.domain.AdminUserApprovalDTO;
import com.example.renewal_firstclass.domain.ApplicationSearchDTO;
import com.example.renewal_firstclass.domain.TermAmountDTO;

@Mapper
public interface AdminUserApprovalDAO {
    //검색(이름, 상태) 조회
    List<AdminUserApprovalDTO> selectApplicationList(ApplicationSearchDTO search);
    //전체 조회
    int selectTotalCount(@Param("keyword") String keyword, @Param("status") String status, @Param("date") String date);
    //처리 상태별 조회
    int selectStatusCount(@Param("statusCode") String statusCode, @Param("paymentResult") String paymentResult);
    //대기중 합산
    int selectStatusCountIn(@Param("codes") List<String> codes);
    
    //상세페이지
    AdminUserApprovalDTO selectAppDetailByAppNo(@Param("applicationNumber") long applicationNumber);
    List<TermAmountDTO> selectByConfirmId(@Param("confirmNumber") long confirmNumber);


    /** 관리자 상세 진입 시 심사중상태로*/
    int whenOpenChangeState(@Param("applicationNumber") long applicationNumber);

    /** 지급 확정(2차 심사로)*/
    int approveApplicationLevel1(@Param("applicationNumber") long applicationNumber,
                                 @Param("processorId") Long processorId);

    /** 부지급 확정*/
    int rejectApplication(@Param("applicationNumber") long applicationNumber,
                          @Param("rejectionReasonCode") String rejectionReasonCode,
                          @Param("rejectComment") String rejectComment,
                          @Param("processorId") Long processorId);

}