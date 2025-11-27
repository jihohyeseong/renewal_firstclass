package com.example.renewal_firstclass.dao;


import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.renewal_firstclass.domain.AttachedFileDTO;

@Mapper
public interface AttachedFileDAO {

		int insertFile(AttachedFileDTO dto);
		
		Long selectNextFileId();
		
	    Integer selectNextSequence(@Param("fileId") Long fileId);
	    
	    AttachedFileDTO selectOneByFileIdAndSeq(@Param("fileId") Long fileId,
                @Param("sequence") Integer sequence);

		Long findOwnerUserIdByFileId(@Param("fileId") Long fileId);
	    
	    List<AttachedFileDTO> selectFilesByFileId(@Param("fileId") Long fileId);
	    
	    int deleteByFileId(Long fileId);
	    
	    int deleteOne(@Param("fileId") Long fileId, @Param("sequence") Integer sequence);
	    
	    int existsOwnedFile(@Param("fileId") Long fileId,
                @Param("userId") Long userId);
	    

}
