package com.example.renewal_firstclass.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.renewal_firstclass.domain.AdminChildListDTO;
import com.example.renewal_firstclass.domain.CompSearchDTO;
import com.example.renewal_firstclass.domain.TermAmountDTO;

@Mapper
public interface AdminChildSearchDAO {
	
    List<AdminChildListDTO> selectChildSearch(CompSearchDTO searchDTO);
    
    int countChildSearch(CompSearchDTO searchDTO);
    
    /*List<TermAmountDTO> selectOriginalTermAmounts(@Param("confirmNumber") Long confirmNumber);
    
    // 수정된(update_at='Y') 단위기간 조회
    List<TermAmountDTO> selectUpdatedTermAmounts(@Param("confirmNumber") Long confirmNumber);*/
}