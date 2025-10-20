package com.example.renewal_firstclass.domain;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AdminJudgeDTO {

	private Long confirmNumber;
	private Long processorId;
	private String rejectionReasonCode;
	private String rejectComment;
	private String resultStatus; //APPROVE, REJECT
}
