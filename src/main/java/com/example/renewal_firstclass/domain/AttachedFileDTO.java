package com.example.renewal_firstclass.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class AttachedFileDTO {
	
	Long fileId;
	String fileType;
	String fileUrl;
	int sequence;

}
