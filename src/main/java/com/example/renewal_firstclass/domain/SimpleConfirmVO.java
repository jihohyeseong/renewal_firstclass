package com.example.renewal_firstclass.domain;

import lombok.Getter;

@Getter
public class SimpleConfirmVO {

	private Long confirmNumber;
	private String applyDt;
	private String startDate;
	private String endDate;
	private String name; // 회사이름
	private String phoneNumber; // 담당자 휴대폰번호
}
