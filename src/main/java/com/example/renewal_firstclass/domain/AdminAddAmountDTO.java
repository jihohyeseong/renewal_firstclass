package com.example.renewal_firstclass.domain;

import java.util.Date;

import lombok.Data;

@Data
public class AdminAddAmountDTO {
    private Long addAmountId;
    private Long termId;
    private Long codeId;
    private Long amount;
    private String addReason;
    private String statusCode;
    private Long applicationNumber;
    private String addReasonName;
    private String statusName;
}

