package com.example.renewal_firstclass.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.renewal_firstclass.domain.ConfirmApplyDTO;

@Mapper
public interface AdminApprovalDAO {
	// 확인서 조회
	ConfirmApplyDTO selectByConfirmNumber(@Param("confirmNumber") Long confirmNumber);
	// 관리자 지급/부지급
    int updateAdminJudge(ConfirmApplyDTO confirmApplyDTO);
    // 처리 여부
    int isProcessed(@Param("confirmNumber") Long confirmNumber);
    
}
