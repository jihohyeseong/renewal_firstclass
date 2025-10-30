package com.example.renewal_firstclass.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.renewal_firstclass.domain.ConfirmApplyDTO;
import com.example.renewal_firstclass.domain.TermAmountDTO;

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
    int updateConfirmEdit(ConfirmApplyDTO dto);
    // 수정된 값 포함하여 조회
    ConfirmApplyDTO selectByConfirmNumberWithUpdates(@Param("confirmNumber") Long confirmNumber);
    // upd 컬럼 존재 여부 확인
    int checkUpdColumnsExist(@Param("confirmNumber") Long confirmNumber);
    // 수정된 단위기간 삽입
    int insertUpdatedTermAmounts(@Param("terms") List<TermAmountDTO> terms);
    // Y인 데이터 삭제
    int deleteUpdatedTerms(Long confirmNumber);
}
