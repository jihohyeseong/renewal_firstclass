package com.example.renewal_firstclass.domain;

import lombok.Data;

@Data
public class ApplicationSearchDTO {
    private String keyword;
    private String nameKeyword; 	// 이름 검색용
    private Long appNoKeyword;    // 신청번호 검색용
    private String status;
    private String date;
    private PageDTO pageDTO;
}
