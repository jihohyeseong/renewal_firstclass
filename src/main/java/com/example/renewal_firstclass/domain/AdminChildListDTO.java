package com.example.renewal_firstclass.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class AdminChildListDTO {
    private Long confirmNumber;
    private String childName;
    private Date childBirthDate;
	private String childResiRegiNumber;
    private String name;
    private Date startDate;
	private Date endDate;
    private String statusCode;
    private String statusName;
}

