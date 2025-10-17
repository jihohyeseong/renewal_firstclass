package com.example.renewal_firstclass.dao;

import org.apache.ibatis.annotations.Mapper;
import com.example.renewal_firstclass.domain.ConfirmApplyDTO;

@Mapper
public interface ConfirmApplyDAO {
    int insertConfirmApplication(ConfirmApplyDTO dto);
}
