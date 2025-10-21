package com.example.renewal_firstclass.domain;

import java.sql.Date;

import lombok.Data;

@Data
public class ConfirmListDTO {
	private long confirmNumber;
	private Date applyDt;
	private String statusCode;
	private String name;
	private String statusName;
	
	
	
}
