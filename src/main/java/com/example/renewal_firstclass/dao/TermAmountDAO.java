package com.example.renewal_firstclass.dao;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.renewal_firstclass.domain.TermAmountDTO;

@Mapper
public interface TermAmountDAO {
    int insertTermAmount(List<TermAmountDTO> list);
    
    List<TermAmountDTO> selectByConfirmId(@Param("confirmNumber") long confirmNumber);
    int deleteTermsByConfirmId(@Param("confirmNumber") long confirmNumber);

	int countTotalTermsByConfirmNumbers(List<Long> previousConfirmNumbers);
	List<TermAmountDTO> selectTermsByConfirmNumbers(@Param("list") List<Long> confirmNumbers);

}

