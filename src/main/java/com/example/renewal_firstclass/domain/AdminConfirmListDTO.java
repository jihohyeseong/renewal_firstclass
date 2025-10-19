package com.example.renewal_firstclass.domain;

import lombok.Data;

@Data
public class AdminConfirmListDTO {
    private Long confirmNumber;
    private Long userId;
    private String name;
    private String statusCode;
    private String applyDate;
    private String statusName;
    private String rejectionReasonCode;
}
