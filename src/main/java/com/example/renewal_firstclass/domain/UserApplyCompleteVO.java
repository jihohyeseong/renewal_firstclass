package com.example.renewal_firstclass.domain;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserApplyCompleteVO {

	private Long applicationNumber;
	private String submittedDt;
	private String name;
	private String centerName;
	private String centerUrl;
	private String centerZipCode;
	private String centerAddressBase;
	private String centerAddressDetail;
	private String centerPhoneNumber;
}
