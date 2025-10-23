package com.example.renewal_firstclass.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.renewal_firstclass.domain.ConfirmApplyDTO;
import com.example.renewal_firstclass.domain.ConfirmListDTO;

@Mapper
public interface ConfirmApplyDAO {
    int insertConfirmApplication(ConfirmApplyDTO dto);
    int updateConfirm(ConfirmApplyDTO dto);
    int submitConfirm(@Param("confirmNumber") Long confirmNumber,
                      @Param("userId") Long userId);
    ConfirmApplyDTO selectByConfirmNumber(@Param("confirmNumber") Long confirmNumber);
   
    List<ConfirmListDTO> selectByUserId(@Param("userId") Long userId,
            @Param("offset") int offset,
            @Param("size") int size);

    int countByUser(Long userId);
    
    int recallConfirm(@Param("confirmNumber") Long confirmNumber,
            @Param("userId") Long userId);
}
