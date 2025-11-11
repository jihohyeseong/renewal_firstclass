package com.example.renewal_firstclass.domain;

import lombok.Data;
import java.util.Date;

@Data
public class AdminAppHistoryDTO {
    private Long historyId;
    private Long applicationNumber;
    private String bankCode;
    private String accountNumber;
    private String statusCode;
    private String paymentResult;
    private String rejectionReasonCode;
    private String rejectComment;
    private Long payment;
    private Date submittedDt;
    private Date examineDt;
    private String deltAt;
    private Long confirmNumber;
    private Long userId;
    private String govInfoAgree;
    private Long centerId;
    private String updBankCode;
    private String updAccountNumber;
    private Long fileId;
    private String actionType;
    private Date actionTime;
    private String userName;        // JOIN tb_user.name
    private String userRegiNumber;  // JOIN tb_user.registration_number
}
