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
public interface AdminSuperiorDAO {
	// 관리자 권한 체크
	// center_id 조회
    @Select("SELECT center_id FROM TB_USER WHERE username = #{username} AND delt_at = 'N'")
    Long selectCenterIdByUsername(@Param("username") String username);

    // center_position 조회
    @Select("SELECT center_position FROM TB_USER WHERE username = #{username} AND delt_at = 'N'")
    String selectCenterPositionByUsername(@Param("username") String username);
    
    //상위관리자 신청서 목록 
    //검색(이름, 상태) 조회
    List<AdminUserApprovalDTO> selectApplicationList(ApplicationSearchDTO search);

    //전체 조회
    int selectTotalCount(@Param("keyword") String keyword, @Param("status") String status, @Param("date") String date);

    //처리 상태별 조회
    int selectStatusCount(@Param("statusCode") String statusCode, @Param("paymentResult") String paymentResult);
    
    //대기중 합산
    int selectStatusCountIn(@Param("codes") List<String> codes);
    
    //상위관리자 신청 상세페이지
    AdminUserApprovalDTO selectAppDetailByAppNo(@Param("applicationNumber") long applicationNumber);

    /** 관리자 상세 진입 시 심사중상태로*/
    //int whenOpenChangeState(@Param("applicationNumber") long applicationNumber);

    /** 최종 지급 확정*/
    int approveApplicationLevel2(@Param("applicationNumber") long applicationNumber,
                                 @Param("superiorId") long superiorId);

    /** 최종 부지급 확정*/
    int rejectApplication(@Param("applicationNumber") long applicationNumber,
                          @Param("rejectionReasonCode") String rejectionReasonCode,
                          @Param("rejectComment") String rejectComment,
                          @Param("superiorId") long superiorId);
}