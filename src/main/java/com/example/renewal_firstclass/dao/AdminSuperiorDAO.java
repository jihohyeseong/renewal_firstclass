package com.example.renewal_firstclass.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.example.renewal_firstclass.domain.AdminAddAmountDTO;
import com.example.renewal_firstclass.domain.AdminUserApprovalDTO;
import com.example.renewal_firstclass.domain.ApplicationSearchDTO;

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
    int selectTotalCount(@Param("nameKeyword") String nameKeyword, @Param("appNoKeyword") Long appNoKeyword,
    		@Param("status") String status, @Param("date") String date);

    //처리 상태별 조회
    int selectStatusCount(@Param("statusCode") String statusCode, @Param("paymentResult") String paymentResult);
    
    //대기중 합산
    int selectStatusCountIn(@Param("codes") List<String> codes);
    
    //상위관리자 신청 상세페이지
    AdminUserApprovalDTO selectAppDetailByAppNo(@Param("applicationNumber") long applicationNumber);

    //관리자 상세 진입 시 심사중상태로
    int whenOpenChangeState(@Param("applicationNumber") long applicationNumber);

    // 최종 지급 확정
    int approveApplicationLevel2(@Param("applicationNumber") long applicationNumber,
                                 @Param("superiorId") long superiorId);

    // 최종 부지급 확정
    int rejectApplication(@Param("applicationNumber") long applicationNumber,
                          @Param("rejectionReasonCode") String rejectionReasonCode,
                          @Param("rejectComment") String rejectComment,
                          @Param("superiorId") long superiorId);
    
    //추가지급 관련
    // 상위관리자 추가 지급 신청서 목록 조회 
    List<AdminUserApprovalDTO> selectAddAmountList(ApplicationSearchDTO search);

    // 추가 지급 테이블의 상태별 개수 조회
    @Select("SELECT COUNT(*) FROM TB_ADD_AMOUNT WHERE status_code = #{statusCode}")
    int selectAddAmountStatusCount(@Param("statusCode") String statusCode);

    //추가 지급 테이블의 특정 상태 목록 개수 조회
    @Select("SELECT COUNT(*) FROM TB_ADD_AMOUNT WHERE status_code IN ('ST_40', 'ST_50', 'ST_60')")
    int selectAddAmountTotalCount();
    

    // 추가지급 상세페이지 
    AdminUserApprovalDTO selectAddAmountDetailByAppNo(@Param("applicationNumber") long applicationNumber);

    // 추가지급 상태 업데이트 (지급/부지급)
    int updateAddAmountStatus(
            @Param("applicationNumber") long applicationNumber,
            @Param("statusCode") String statusCode
    );
    
    // 특정 신청서의 추가지급 내역 목록 조회
    List<AdminAddAmountDTO> selectAddAmountListByAppNo(@Param("applicationNumber") long applicationNumber);
}
