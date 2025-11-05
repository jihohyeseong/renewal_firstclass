package com.example.renewal_firstclass.dao;


import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.renewal_firstclass.domain.AttachedFileDTO;

import lombok.RequiredArgsConstructor;

@Mapper
public interface AttachedFileDAO {

		int insertFile(AttachedFileDTO dto);
		
		Long selectNextFileId();
		
	    Integer selectNextSequence(@Param("fileId") Long fileId);

}
