package com.example.renewal_firstclass.domain;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class TermAmountDTO {
	
	private Long termId;
	private Long companyPayment;
	private Long govPayment;
	private Date paymentDate;
	private Date startMonthDate;
	private Date endMonthDate;
	private Long confirmNumber;
	private String updateAt;
	private String deltAt;
	private Date earlyReturnDate;
	private Long govPaymentUpdate;
	private String initAt;
}
