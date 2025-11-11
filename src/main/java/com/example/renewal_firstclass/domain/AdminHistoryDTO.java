package com.example.renewal_firstclass.domain;

import lombok.*;
import java.util.Date;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AdminHistoryDTO {
    // [공통 필드]
    private String formType;       // 신청서, 확인서 구분
    private String actionType;
    private Date actionTime;
    private String userName;       // 사용자 이름 (복호화된 값)
    private String userRegiNumber; // 사용자 주민번호 (복호화된 값)

    // --- [신청서(App) 전용 필드] ---
    private Long historyId_App; // 컬럼명 중복을 피하기 위해 접미사 추가
    private Long applicationNumber;
    private String bankCode;
    private String accountNumber;
    private String statusCode_App; 
    private String paymentResult;
    private String rejectionReasonCode_App; 
    private String rejectComment_App; 
    private Long payment;
    private Date submittedDt;
    private Date examineDt;
    private String deltAt_App;
    private Long confirmNumber_App;
    private Long userId_App; 
    private String govInfoAgree;
    private Long centerId_App;
    private String updBankCode;
    private String updAccountNumber;
    private Long fileId_App; 

    // --- [확인서(Cnf) 전용 필드] ---
    private Long historyId_Cnf; 
    private Long confirmNumber_Cnf; 
    private Date applyDt;
    private Date startDate;
    private Date endDate;
    private Integer weeklyHours;
    private Integer regularWage;
    private String childName;
    private String childResiRegiNumber;
    private Date childBirthDate;
    private String name_Cnf; // userName과 겹칠 수 있으므로
    private String registrationNumber_Cnf; // userRegiNumber와 겹칠 수 있으므로
    private String deltAt;
    private String responseName;
    private String responsePhoneNumber;
    private String statusCode_Cnf; // 중복 방지
    private String rejectionReasonCode_Cnf; // 중복 방지
    private String rejectComment_Cnf; // 중복 방지
    private Long processorId;
    private Long centerId;
    private Long userId_Cnf; // 중복 방지
    private Long fileId_Cnf; // 중복 방지
    // --- [확인서(Cnf) 수정 전용 필드] --
    private Integer updWeeklyHours;
    private Integer updRegularWage;
    private String updChildName;
    private String updChildResiRegiNumber; // (복호화)
    private Date updEndDate;
    private Date updStartDate;
    private Date updChildBirthDate;
    private String updRegistrationNumber; // (복호화)
    private String updName;
}