package com.example.renewal_firstclass.domain;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TermAmountDTO {
	
	private Long termId;
	private Long companyPayment;
	private Long govPayment;
	private Date paymentDate;
	private Date startMonthDate;
	private Date endMonthDate;
	private Long confirmNumber;
}
