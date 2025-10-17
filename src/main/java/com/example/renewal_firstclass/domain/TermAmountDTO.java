package com.example.renewal_firstclass.domain;

import java.sql.Date;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class TermAmountDTO {
	
	private Long termId;
	private Long applicationNumber;
	private Long companyPayment;
	private Long govPayment;
	private Date paymentDate;
	private Date startMonthDate;
	private Date endMonthDate;
	private Long confirmNumber;
}
