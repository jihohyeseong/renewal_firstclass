package com.example.renewal_firstclass.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.example.renewal_firstclass.domain.AdminListDTO;
import com.example.renewal_firstclass.domain.ApplicationSearchDTO;

@Mapper
public interface AdminSuperiorDAO {
	 // center_id 조회
    @Select("SELECT center_id FROM TB_USER WHERE username = #{username} AND delt_at = 'N'")
    Long selectCenterIdByUsername(@Param("username") String username);

    // center_position 조회
    @Select("SELECT center_position FROM TB_USER WHERE username = #{username} AND delt_at = 'N'")
    String selectCenterPositionByUsername(@Param("username") String username);
    
    //검색(이름, 상태) 조회
    List<AdminListDTO> selectApplicationList(ApplicationSearchDTO search);

    //전체 조회
    int selectTotalCount(@Param("keyword") String keyword, @Param("status") String status, @Param("date") String date);

    //처리 상태별 조회
    int selectStatusCount(@Param("statusCode") String statusCode, @Param("paymentResult") String paymentResult);
    
    //대기중 합산
    int selectStatusCountIn(@Param("codes") List<String> codes);
}