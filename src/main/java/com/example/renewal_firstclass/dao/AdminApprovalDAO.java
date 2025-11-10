package com.example.renewal_firstclass.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.renewal_firstclass.domain.ConfirmApplyDTO;
import com.example.renewal_firstclass.domain.TermAmountDTO;

@Mapper
public interface AdminApprovalDAO {
	/*관리자 승인/반려*/
	// 확인서 조회
	ConfirmApplyDTO selectByConfirmNumber(@Param("confirmNumber") Long confirmNumber);
	
	// 관리자 지급/부지급
    int updateAdminJudge(ConfirmApplyDTO confirmApplyDTO);
    
    // 처리 여부
    int isProcessed(@Param("confirmNumber") Long confirmNumber);
    
    // 심사중으로 업데이트
    void updateStatusCode(Long confirmNumber);
    
    /*관리자 수정*/
    // UPD 컬럼 업데이트
    int updateConfirmEdit(ConfirmApplyDTO dto);
    
    // 수정된 값 포함하여 조회
    ConfirmApplyDTO selectByConfirmNumberWithUpdates(@Param("confirmNumber") Long confirmNumber);
    
    // 상세폼: 원본(update_at='N') 단위기간만 조회
    List<TermAmountDTO> selectOriginalTermAmounts(@Param("confirmNumber") Long confirmNumber);
    
    // 수정폼: 수정된(update_at='Y') 단위기간만 조회
    List<TermAmountDTO> selectUpdatedTermAmounts(@Param("confirmNumber") Long confirmNumber);
    
    // upd 컬럼 존재 여부 확인
    int checkUpdColumnsExist(@Param("confirmNumber") Long confirmNumber);
    
    // 수정된 단위기간 삽입
    int insertUpdatedTermAmounts(@Param("terms") List<TermAmountDTO> terms);
    
    // Y인 데이터 삭제
    int deleteUpdatedTerms(Long confirmNumber);
    
    // 원본 데이터 delt_at 'Y'로 변경
    int markOriginalTermsAsDeleted(@Param("confirmNumber") Long confirmNumber);
    
    // update_at이 Y인 컬럼 확인
    int countUpdatedTerms(@Param("confirmNumber") Long confirmNumber);
}
