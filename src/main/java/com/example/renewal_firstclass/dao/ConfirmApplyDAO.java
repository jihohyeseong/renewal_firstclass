package com.example.renewal_firstclass.dao;

import java.util.List;
import java.util.Map;

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
    
    List<ConfirmListDTO> selectConfirmListSearch(@Param("userId") Long userId,@Param("statusCode") String statusCode,
    	    @Param("nameKeyword") String nameKeyword,
    	    @Param("regNoKeyword") String regNoKeyword,
    		@Param("offset") int offset,
            @Param("size") int size);
    
    int countConfirmListSearch(@Param("userId") Long userId,@Param("statusCode") String statusCode,
    	    @Param("nameKeyword") String nameKeyword,
    	    @Param("regNoKeyword") String regNoKeyword);
    
    List<ConfirmListDTO> selectConfirmList(@Param("userId") Long userId,
    		@Param("offset") int offset,
            @Param("size") int size);
    
    int countConfirmList(@Param("userId") Long userId);
    
    Map<String, Object> findLatestPeriodByPerson(@Param("name") String name,
            @Param("registrationNumber") String registrationNumber, 
            @Param("nowConfirmNumber") Long nowConfirmNumber);
    
    int deleteConfirm(@Param("confirmNumber") Long confirmNumber, @Param("userId") Long userId);
}
