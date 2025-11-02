package com.example.renewal_firstclass.domain;

import lombok.*;
import java.io.Serializable;
import java.sql.Date;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ConfirmApplyDTO {
    private Long confirmNumber;                 // PK 

    // 기본/필수 필드
    private Date applyDt;                   // 제출일자
    private Date startDate;                 // 육아휴직 시작
    private Date endDate;                   // 육아휴직 종료
    private Integer weeklyHours;            // 주당 소정 근로시간
    private Long regularWage;               // 통상임금 
    private String childName;               // 자녀 이름 
    private String childResiRegiNumber;     // 자녀 주민번호 
    private Date childBirthDate;            // 출생(예정)일
    private String registrationNumber;      // 근로자 주민등록번호
    private String name;                    // 근로자 성명

    // 담당자
    private String responseName;            // 담당자 이름
    private String responsePhoneNumber;     // 담당자 전화번호

    // 변경요청
    private Date updStartDate;
    private Date updEndDate;
    private Integer updWeeklyHours;
    private Long updRegularWage;
    private String updChildName;
    private String updChildResiRegiNumber;
    private Date updChildBirthDate;
    private String updName;
    private String updRegistrationNumber;

    // 반려 관련
    private String rejectionReasonCode;     // 반려사유 코드 
    private String rejectComment;           // 상세 반려 사유
    private String rejectReasonName;

    // 상태/참조
    private String statusCode;              // 처리상태
    private String statusName;
    private Long processorId;               // 관리자 유저 id
    private Long centerId;                  // 센터 id
    private Long userId;                    // 신청하는 기업(유저) id
    
    //센터정보
    private String centerName;
    private String centerPhoneNumber;
    private String centerURL;
    private String centerZipCode;
    private String centerAddressBase;
    private String centerAddressDetail;
    
    private List<TermAmountDTO> termAmounts;
    
    //수정용 단위기간 저장 데이터
    private List<TermAmountDTO> updatedTermAmounts;
    private List<Long> monthlyCompanyPay;

}
