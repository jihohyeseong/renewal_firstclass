package com.example.renewal_firstclass.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.renewal_firstclass.domain.ConfirmApplyDTO;

@Mapper
public interface ConfirmApplyDAO {
    int insertConfirmApplication(ConfirmApplyDTO dto);
    int updateDraft(ConfirmApplyDTO dto);
    int submitConfirm(@Param("confirmNumber") Long confirmNumber,
                      @Param("userId") Long userId);
    ConfirmApplyDTO selectByConfirmNumber(@Param("confirmNumber") Long confirmNumber);
    
}
