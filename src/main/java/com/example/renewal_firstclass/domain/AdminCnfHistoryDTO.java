package com.example.renewal_firstclass.domain;

import lombok.Data;
import java.util.Date;

@Data
public class AdminCnfHistoryDTO {
    private Long historyId;
    private Long confirmNumber;
    private Date applyDt;
    private Date startDate;
    private Date endDate;
    private Long weeklyHours;
    private Long regularWage;
    private String childName;
    private String childResiRegiNumber;
    private Date childBirthDate;
    private String registrationNumber;
    private String name;
    private String deltAt;
    private String responseName;
    private String responsePhoneNumber;
    private Long updWeeklyHours;
    private Long updRegularWage;
    private String updChildName;
    private String updChildResiRegiNumber;
    private String rejectionReasonCode;
    private String rejectComment;
    private String statusCode;
    private Long processorId;
    private Long centerId;
    private Long userId;
    private Date updEndDate;
    private Date updStartDate;
    private Date updChildBirthDate;
    private String updRegistrationNumber;
    private String updName;
    private Long fileId;
    private String actionType;
    private Date actionTime;
}
