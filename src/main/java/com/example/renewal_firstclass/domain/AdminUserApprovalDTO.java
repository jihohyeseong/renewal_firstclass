package com.example.renewal_firstclass.domain;

import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

import lombok.Data;

@Data
public class AdminUserApprovalDTO {

    private String submittedDate;
    private String statusName;
    
 // TB_PARENTAL_LEAVE_APPLICATION
    private Long applicationNumber;
    private String statusCode;
    private String bankCode;
    private String bankName;           // alias
    private String accountNumber;
    private String paymentResult;
    private BigDecimal payment;
    private Date submittedDt;
    private Date examineDt;
    private String rejectionReasonCode;
    private String rejectionReasonName; // alias
    private String rejectComment;
    private String govInfoAgree;
    private Long userId;
    private Long processorId;
    private Long superiorId;

    // TB_CONFIRM_APPLICATION
    private Date startDate;
    private Date endDate;
    private Integer weeklyHours;
    private BigDecimal regularWage;
    private String childName;
    private String childResiRegiNumber;
    private Date childBirthDate;
    private String responseName;
    private String responsePhoneNumber;

    // USERS
    // 신청자(근로자)
    private String applicantName;
    private String applicantPhoneNumber;
    private String applicantResiRegiNumber;
    private String applicantNameFromCA;

    // 회사(사업장)
    private String businessName;
    private String businessZipNumber;
    private String businessAddrBase;
    private String businessAddrDetail;
    private String businessRegiNumber;

    // id들
    private Long corpUserId;
    private Long centerId;
    private Long confirmNumber;
    
    private List<TermAmountDTO> termAmounts;
}
