package com.example.renewal_firstclass.domain;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CenterDTO {

	private Long centerId;
	private String centerName;
	private String centerUrl;
	private String centerZipCode;
	private String centerAddressBase;
	private String centerAddressDetail;
	private String centerPhoneNumber;
}
