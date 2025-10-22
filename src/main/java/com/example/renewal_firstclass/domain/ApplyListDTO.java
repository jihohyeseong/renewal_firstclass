package com.example.renewal_firstclass.domain;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ApplyListDTO {

	private long applicationNumber;
	private Date submittedDt;
	private String statusCode;
	private String name;
	private String statusName;
}
