package com.example.renewal_firstclass.domain;

import java.util.Date;

import lombok.Data;

@Data
public class CompSearchDTO {
    private String status;
    private String nameKeyword;
    private String regNoKeyword;
    private String formType;
    private String actionType;
    private Date startDate;
    private Date endDate;
    private PageDTO pageDTO;
}