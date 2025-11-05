package com.example.renewal_firstclass.domain;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AttachedFileDTO {
	
	Long fileId;
	String fileType;
	String fileUrl;
	int sequence;

}
