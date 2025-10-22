package com.example.renewal_firstclass.domain;


import java.sql.Date;
import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ApplicationDTO {

	private Long confirmNumber;
	private String name;
	private String registrationNumber;
	private String zipNumber;
	private String addressBase;
	private String addressDetail;
	private String phoneNumber;
	private String companyName;
	private String buisinessRegiNumber;
	private String companyZipNumber;
	private String companyAddressBase;
	private String companyAddressDetail;
	private Date startDate;
	private Date endDate;
	private List<TermAmountDTO> list;
	private Long regularWage;
	private Long weeklyHours;
	private String childName;
	private Date childBirthDate;
	private String childResiRegiNumber;
	private String bankCode;
	private String accountNumber;
	private Long centerId;
	private String govInfoAgree;
}
