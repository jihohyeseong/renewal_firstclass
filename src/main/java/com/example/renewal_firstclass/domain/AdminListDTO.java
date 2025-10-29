package com.example.renewal_firstclass.domain;

import java.util.Date;

import lombok.Data;

@Data
public class AdminListDTO {
    private Long applicationNumber;
    private Long confirmNumber;
    private String docType;
    private String name;
    private String statusCode;
    private Date applyDate;
    private String statusName;
}

