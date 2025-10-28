package com.example.renewal_firstclass.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.renewal_firstclass.domain.ApplicationDTO;
import com.example.renewal_firstclass.domain.ConfirmApplyDTO;

@Mapper
public interface AdminApprovalDAO {
	// 확인서 조회
	ConfirmApplyDTO selectByConfirmNumber(@Param("confirmNumber") Long confirmNumber);
	// 관리자 지급/부지급
    int updateAdminJudge(ConfirmApplyDTO confirmApplyDTO);
    // 처리 여부
    int isProcessed(@Param("confirmNumber") Long confirmNumber);
    // 심사중으로 업데이트
    void updateStatusCode(Long confirmNumber);
    // UPD 컬럼 업데이트
    int updateConfirmEdit(ConfirmApplyDTO confirmApplyDTO);
    // 수정된 값 포함하여 조회
    ConfirmApplyDTO selectByConfirmNumberWithUpdates(@Param("confirmNumber") Long confirmNumber);
    // upd 컬럼 null 체크
    int checkUpdColumnsExist(@Param("confirmNumber") Long confirmNumber);
}
