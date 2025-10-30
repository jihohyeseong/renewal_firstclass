<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>육아휴직 확인서 상세 보기</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/global.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/comp.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<style>
	  /* ===== 진행 상태 카드 (Step Progress Bar) ===== */
	  .progress-card {
	    background: #fff;
	    border: 1px solid var(--border-color);
	    border-radius: 14px;
	    padding: 20px;
	    margin-bottom: 24px;
	    box-shadow: var(--shadow-lg);
	  }
	
	  /* ===== 진행 상태 바 개선 ===== */
	.stepper-wrapper {
	  display: flex;
	  justify-content: space-between;
	  align-items: center;
	  position: relative;
	  padding: 0 8%;
	  margin: 10px 0;
	}
	
	.stepper-wrapper::before {
	  content: '';
	  position: absolute;
	  top: 50%; /* 원 중심선과 맞춤 */
	  left: 8%;
	  right: 8%;
	  height: 10px;
	  border-radius: 10px;
	  background-color: #dcdcdc;
	  z-index: 1;
	  transform: translateY(-50%);
	}
	
	.stepper-item {
	  position: relative;
	  z-index: 2;
	  text-align: center;
	  flex: 1;
	  justify-content: center;
	}
	
	.step-counter {
	  width: 38px;
	  height: 38px;
	  border-radius: 50%;
	  background-color: #dcdcdc;
	  color: white;
	  font-weight: bold;
	  margin: 10px auto;
	  margin-top: 25px;
	  display: flex;
	  justify-content: center;
	  align-items: center;
	  transition: background-color 0.3s ease, box-shadow 0.3s ease;
	}
	
	/* 단계 텍스트(결과대기 포함) 정렬 수정 */
	.step-name {
	  font-size: 14px;
	  color: #333;
	  margin-top: 6px;
	  display: block;
	}
	
	/* 완료된 단계 */
	.stepper-item.completed .step-counter {
	  background-color: #81c784; /* 연한 초록색 */
	  box-shadow: inset 0 0 0 5px rgba(46,125,50,0.25); /* 채워진 원 느낌 */
	}
	
	/* 현재 진행 단계 */
	.stepper-item.current .step-counter {
	  background-color: #2e7d32; /* 진한 초록색 */
	  box-shadow: 0 0 0 4px rgba(46, 125, 50, 0.2);
	}
	
	/* 결과대기(아직 미완료) 상태 기본 */
	.stepper-item.waiting .step-counter {
	  background-color: #dcdcdc;
	  color: #999;
	}
	
	/* 완료 구간 연결선 */
	.stepper-wrapper .progress-line {
	  position: absolute;
	  top: 50%; /* 원 중심과 맞춤 */
	  left: 8%;
	  height: 10px;
	  border-radius: 10px;
	  background-color: #4caf50;
	  z-index: 1;
	  transform: translateY(-50%);
	  transition: width 0.4s ease;
	}
	
	/* ===== 반려 사유 카드 개선 ===== */
	.reject-result {
	    background: #fff;
	    border: 1px solid #e9ecef;
	    border-radius: 12px;
	    padding: 24px;
	    margin-bottom: 24px;
	    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
	}
	
	.reject-result .title-section {
	    display: flex;
	    align-items: center;
	    gap: 12px;
	    margin-bottom: 20px;
	    padding-bottom: 16px;
	    border-bottom: 2px solid #f8f9fa;
	}
	
	.reject-result .title-section i {
	    font-size: 24px;
	    color: #ff6b6b;
	}
	
	.reject-result .title-section h3 {
	    margin: 0;
	    font-size: 18px;
	    font-weight: 700;
	    color: #333;
	}
	.reject-result .title-section .reason-inline {
	    display: inline-block;
	    padding: 6px 16px;
	    background: linear-gradient(135deg, #ff6b6b 0%, #ee5a52 100%);
	    color: #fff;
	    border-radius: 20px;
	    font-weight: 700;
	    font-size: 14px;
	    margin-left: 25px;
	}
	
	.reject-result .info-grid {
	    display: grid;
	    gap: 16px;
	}
	
	.reject-result .info-item {
	    display: flex;
	    gap: 12px;
	}
	
	.reject-result .info-item .label {
	    min-width: 100px;
	    font-weight: 600;
	    color: #666;
	    font-size: 14px;
	}
	
	.reject-result .info-item .value {
	    flex: 1;
	    color: #333;
	    font-size: 14px;
	}

    
	  /* ===== 표 전용(초록 테마와 조화) ===== */
	  .page-title { font-size: 22px; font-weight: 800; margin: 0 0 18px; }
	
	  .sheet-table {
	    width: 100%;
	    border-collapse: collapse;
	    background: #fff;
	    border: 1px solid var(--border-color);
	    overflow: hidden;          /* radius 유지 */
	  }
	  .sheet-table th, .sheet-table td {
	    border: 1px solid #dee2e6;
	    padding: 12px 14px;
	    font-size: 14px;
	    vertical-align: middle;
	  }
	  
	  .sheet-table th {
	  	background: var(--light-gray-color);
	  }
	  .sheet-table td {
    	color: #495057;
  	  }	
	  .sheet-head {
	    background: var(--light-gray-color, #ffffff);
	    color: var(--dark-gray-color, #2c3e50);
	    font-weight: 700;
	    text-align: left;
	    padding: 16px;
	    font-size: 16px;
	    position: relative;
	    padding-left: 24px;
	    margin-top: 20px;     /* 위쪽 간격 */
  		margin-bottom: 12px;  /* 아래쪽 간격 */
	  }
	
	  .sheet-head::before {
	    content: '';
	    position: absolute;
	    left: 0;
	    top: 0;
	    bottom: 0;
	    width: 5px;
	    background: linear-gradient(180deg, #4caf50 0%, #66bb6a 100%);
	  }
	  
	  .w160 { width: 160px; }
	  .center { text-align: center; }
	  .num { text-align: right; padding-right: 16px; }
	
	  /* “월별 지급 내역” 안쪽 표 */
	  .month-table { width: 100%; border-collapse: collapse; }
	  .month-table th, .month-table td {
	    border: 1px solid var(--border-color);
	    padding: 10px 12px;
	    font-size: 14px;
	  }
	  .month-table thead th {
	    background: var(--light-gray-color);
	    font-weight: 700;
	    text-align: center;
	  }
	
	   /* ===== 버튼 영역 수정 ===== */
	  .button-container {
	    text-align: center;
	    margin-top: 20px;
	    padding-bottom: 20px;
	  }
	
	  .judge-actions .btn {
	    justify-content: center;
	    gap: 12px;
	    margin-bottom: 25px; /* 목록 버튼과 간격 증가 */
	    padding: 6px 14px;
	  }
	  
	  .btn-primary, .btn-secondary {
	    padding: 6px 14px; /* 패딩 축소 */
	    font-size: 14px;
	  }
	
	  /* ===== 부지급 사유 영역 ===== */
	  #rejectForm {
	    display: none;
	    margin-top: 20px;
	    margin-bottom: 20px;
	    border: 1px solid #ccc;
	    padding: 12px;
	    border-radius: 8px;
	    text-align: left;
	  }
	
	  #rejectForm h3 {
	    margin-bottom: 10px;
	  }
	
	  #rejectForm div:first-of-type {
	    display: grid;
	    grid-template-columns: repeat(2, 1fr); /* 2열 배치 */
	    gap: 6px 18px; /* 상하6px, 좌우18px 간격 */
	  }
	
	  #rejectForm label {
	    font-size: 14px;
	  }
	
	  #rejectComment {
	    margin-top: 8px;
	    width: 80%;
	  }
	  
	  /* 동적 폼 스타일 */
	.dynamic-form-container {
	    display: flex;
	    flex-direction: column;
	    gap: 0;
	}
	
	.dynamic-form-row {
	    display: flex;
	    align-items: center;
	    padding: 12px 16px;
	    border-bottom: 1px solid #e0e0e0;
	    background: #fff;
	}
	
	.dynamic-form-row:hover {
	    background: #f8f9fa;
	}
	
	.date-range-display {
	    flex: 1;
	    display: flex;
	    align-items: center;
	    font-size: 14px;
	    color: #333;
	}
	
	.payment-input-field {
	    flex: 1;
	    display: flex;
	    align-items: center;
	    justify-content: flex-end;
	}
	
	.payment-input-field .input-field {
	    margin: 0;
	}
	
	.payment-input-field input {
	    text-align: right;
	    padding-right: 8px;
	}
	  
</style>
</head>
<body>
<%@ include file="adminheader.jsp" %>

<main class="main-container">
  <!-- 진행 상태 카드 -->
	<div class="progress-card">
	  <div class="stepper-wrapper">
		  <div class="progress-line"></div>
		
		  <!-- Step 1: 제출 -->
		  <div class="stepper-item 
		       <c:if test='${confirmDTO.statusCode == "ST_20" or confirmDTO.statusCode == "ST_30" or confirmDTO.statusCode == "ST_50" or confirmDTO.statusCode == "ST_60"}'>completed</c:if>
		       <c:if test='${confirmDTO.statusCode == "ST_10"}'>current</c:if>">
		    <div class="step-counter">1</div>
		    <div class="step-name">제출</div>
		  </div>
		
		  <!-- Step 2: 심사중 -->
		  <div class="stepper-item 
		       <c:if test='${confirmDTO.statusCode == "ST_50" or confirmDTO.statusCode == "ST_60"}'>completed</c:if>
		       <c:if test='${confirmDTO.statusCode == "ST_20" or confirmDTO.statusCode == "ST_30"}'>current</c:if>">
		    <div class="step-counter">2</div>
		    <div class="step-name">심사중</div>
		  </div>
		
		  <!-- Step 3: 승인 / 반려 / 결과대기 -->
		  <div class="stepper-item 
		       <c:choose>
		          <c:when test='${confirmDTO.statusCode == "ST_50" or confirmDTO.statusCode == "ST_60"}'>completed</c:when>
		          <c:otherwise>waiting</c:otherwise>
		       </c:choose>">
		    <div class="step-counter">3</div>
		    <div class="step-name">
		      <c:choose>
		        <c:when test='${confirmDTO.statusCode == "ST_50"}'>승인</c:when>
		        <c:when test='${confirmDTO.statusCode == "ST_60"}'>반려</c:when>
		        <c:otherwise>결과대기</c:otherwise>
		      </c:choose>
		    </div>
		  </div>
		</div>
	</div>
	
	<!-- 반려 사유 안내 박스 -->
<c:if test="${confirmDTO.statusCode == 'ST_60'}">
    <div class="reject-result">
        <div class="title-section">
            <i class="fa-solid fa-circle-xmark"></i>
            <h3>반려</h3>
            <span class="reason-inline">
                <c:choose>
                    <c:when test="${confirmDTO.rejectionReasonCode == 'RJ_10'}">계좌정보 불일치</c:when>
                    <c:when test="${confirmDTO.rejectionReasonCode == 'RJ_20'}">필요 서류 미제출</c:when>
                    <c:when test="${confirmDTO.rejectionReasonCode == 'RJ_30'}">신청시기 미도래</c:when>
                    <c:when test="${confirmDTO.rejectionReasonCode == 'RJ_40'}">근속기간 미충족</c:when>
                    <c:when test="${confirmDTO.rejectionReasonCode == 'RJ_50'}">자녀 연령 기준 초과</c:when>
                    <c:when test="${confirmDTO.rejectionReasonCode == 'RJ_60'}">휴직 가능 기간 초과</c:when>
                    <c:when test="${confirmDTO.rejectionReasonCode == 'RJ_70'}">제출서류 정보 불일치</c:when>
                    <c:when test="${confirmDTO.rejectionReasonCode == 'RJ_80'}">신청서 작성 내용 미비</c:when>
                    <c:when test="${confirmDTO.rejectionReasonCode == 'RJ_99'}">기타</c:when>
                </c:choose>
            </span>
        </div>
        <div class="info-grid">
            <div class="info-item">
                <div class="label">상세 사유</div>
                <div class="value">${confirmDTO.rejectComment}</div>
            </div>
        </div>
    </div>
</c:if>

	
  <div class="content-wrapper">
    <div class="content-header" style="margin-bottom:24px;">
    
        <h2 class="page-title">육아휴직 확인서 상세</h2>
        <div></div>
    </div>
    
		<!-- 하나의 “카드” 안에 들어가는 표 -->
	    <table class="sheet-table">
	      <colgroup>
	        <col class="w160"><col><col class="w160"><col>
	      </colgroup>
	      
			<!-- 접수 정보 -->
            <tr><th class="sheet-head" colspan="4">접수 정보</th></tr>
                    <tr>
                        <th>확인서 번호</th><td><c:out value="${confirmDTO.confirmNumber}" /></td>
                        <th>처리 상태</th>
                        <td>
                             <c:choose>
                                <c:when test="${confirmDTO.statusCode == 'ST_20'}"><span class="status-badge status-pending">심사중</span></c:when>
                                <c:when test="${confirmDTO.statusCode == 'ST_30'}"><span class="status-badge status-pending">심사중</span></c:when>
                                <c:when test="${confirmDTO.statusCode == 'ST_50'}"><span class="status-badge status-approved">승인</span></c:when>
                                <c:when test="${confirmDTO.statusCode == 'ST_60'}"><span class="status-badge status-rejected">반려</span></c:when>
                                <c:otherwise><c:out value="${confirmDTO.statusCode}" /></c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr>
                        <th>제출일</th>
                        <td colspan="3"><fmt:formatDate value="${confirmDTO.applyDt}" pattern="yyyy-MM-dd" /></td>
                    </tr>
                   	 <!-- 회사 정보 -->
                    <tr>
					    <th>기업명</th>
					    <td>${userDTO.name}</td>
					</tr>
					<tr>
					    <th>주소</th>
					    <td>${userDTO.addressBase} ${userDTO.addressDetail}</td>
					</tr>
					<tr>
					    <th>전화번호</th>
					    <td>${userDTO.phoneNumber}</td>
					</tr>

			<!-- 근로자 정보 -->
            <tr><th class="sheet-head" colspan="4">근로자 정보</th></tr>
                    <tr>
                        <th>성명</th><td><c:out value="${confirmDTO.name}" /></td>
                        <th>주민등록번호</th>
                        <td>
                            <c:set var="rrnDigits" value="${fn:replace(confirmDTO.registrationNumber, '-', '')}" />
                            ${fn:substring(rrnDigits,0,6)}-${fn:substring(rrnDigits,6,13)}
                        </td>
                    </tr>
                   
                    <tr>
                        <th>육아휴직 기간</th>
                        <td colspan="3">
                            <fmt:formatDate value="${confirmDTO.startDate}" pattern="yyyy.MM.dd" /> ~ 
                            <fmt:formatDate value="${confirmDTO.endDate}" pattern="yyyy.MM.dd" />
                        </td>
                    </tr>
                    <tr>
                        <th>월 소정근로시간</th><td><c:out value="${confirmDTO.weeklyHours}" /> 시간</td>
                        <th>통상임금 (월)</th>
                        <td><fmt:formatNumber value="${confirmDTO.regularWage}" type="currency" currencySymbol="₩ " /></td>
                    </tr>
    		<!-- 자녀 정보 -->
        	<tr><th class="sheet-head" colspan="4">대상 자녀 정보</th></tr>
                 <c:choose>
                    <c:when test="${not empty confirmDTO.childName}">
                        <tbody>
                            <tr>
                                <th>자녀 이름</th><td><c:out value="${confirmDTO.childName}" /></td>
                                <th>출생일</th>
                                <td><fmt:formatDate value="${confirmDTO.childBirthDate}" pattern="yyyy.MM.dd" /></td>
                            </tr>
                            <tr>
                                <th>자녀 주민등록번호</th>
                                <td colspan="3">
                                    <c:set var="childRrn" value="${confirmDTO.childResiRegiNumber}" />
                                    ${fn:substring(childRrn, 0, 6)}-${fn:substring(childRrn, 6, 13)}
                                </td>
                            </tr>
                    </c:when>
                    <c:otherwise>
                             <tr><th>자녀 정보</th><td colspan="3">출산 예정</td></tr>
                            <tr><th>출산 예정일</th><td colspan="3"><fmt:formatDate value="${confirmDTO.childBirthDate}" pattern="yyyy.MM.dd" /></td></tr>
                    </c:otherwise>
                </c:choose>
 		<!-- 월별 지급 내역 -->
   		<tr><th class="sheet-head" colspan="4">월별 지급 내역</th></tr>
   		<tr>
   			<td colspan="4" style="padding:0;">
          		<table class="month-table">
		            
            	<thead>
	            	<tr>
	                     <th>회차</th>
	                     <th colspan="1">기간</th>
	                     <th colspan="1">사업장 지급액</th>
	                     <th colspan="1">정부 지급액</th>
	                </tr>
        		</thead>
        		<tbody>
                    <c:forEach var="term" items="${termList}" varStatus="status">
                        <tr>
                            <td style="text-align:center;" colspan="1"><c:out value="${status.count}" />개월차</td>
                            <td style="text-align:center;" colspan="1">
                                <fmt:formatDate value="${term.startMonthDate}" pattern="yyyy.MM.dd" /> ~ 
                                <fmt:formatDate value="${term.endMonthDate}" pattern="yyyy.MM.dd" />
                            </td>
                            <td style="text-align:right; padding-right: 20px;" colspan="1">
                                <fmt:formatNumber value="${term.companyPayment}" type="number" pattern="#,###" />원
                            </td>
                            <td style="text-align:right; padding-right: 20px;" colspan="1">
                                <fmt:formatNumber value="${term.govPayment}" type="number" pattern="#,###" />원
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty termList}">
                        <tr>
                            <td colspan="3" style="text-align:center; color: var(--gray-color);">입력된 지급 내역이 없습니다.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
            </td>
          </tr>
          <!-- 담당자 정보 -->
            <tr><th class="sheet-head" colspan="4">확인서 담당자 정보</th></tr>
                    <tr>
                        <th>담당자 이름</th><td><c:out value="${confirmDTO.responseName}" /></td>
                        <th>담당자 연락처</th>
                        <td>
                            <c:out value="${confirmDTO.responsePhoneNumber}" />
                        </td>
                    </tr>
        </table>
		
		<!-- ===== 확인서 수정 카드 ===== -->
		  <div class="card" style="width: 48%; display: inline-block; vertical-align: top; margin-left: 2%;">
    <div class="card-body">
        <h3 style="margin-bottom: 20px;">확인서 수정</h3>

        <form id="updateForm">
            <input type="hidden" name="confirmNumber" value="${confirmDTO.confirmNumber}">

            <input type="hidden" id="initialTermAmounts" 
                   value='${fn:escapeXml(gson.toJson(termList))}' data-initialized="false">

            <table class="sheet-table">
                <colgroup>
                    <col class="w160"><col><col class="w160"><col>
                </colgroup>

                <tr><th class="sheet-head" colspan="4">육아휴직 기간 <i class="fa fa-edit" style="color:#007bff;"></i></th></tr>
                <tr>
                    <th>육아휴직 시작일</th>
                    <td>
                        <input type="date" name="startDate"
                               id="edit-start-date"
                               class="form-control" style="width: 80%;"
                               value="<fmt:formatDate value='${confirmDTO.startDate}' pattern='yyyy-MM-dd' />">
                    </td>
                    <th>육아휴직 종료일</th>
                    <td>
                        <input type="date" name="endDate"
                               id="edit-end-date"
                               class="form-control" style="width: 80%;"
                               value="<fmt:formatDate value='${confirmDTO.endDate}' pattern='yyyy-MM-dd' />">
                    </td>
                </tr>

                <tr><th class="sheet-head" colspan="4">단위기간별 지급액 <i class="fa fa-edit" style="color:#007bff;"></i></th></tr>
                <tr>
                    <td colspan="4" style="padding: 20px;">
                        <div style="margin-bottom: 12px;">
                            <button type="button" id="generate-edit-forms-btn" class="btn btn-secondary">
                                <i class="fa fa-calendar"></i> 기간 나누기 및 재계산
                            </button>
                            <small style="display:block; margin-top:8px; color:#666;">
                                ※ 기간, 근로조건, 통상임금을 수정한 후 '기간 나누기 및 재계산'을 클릭하세요.
                                <br>
                                ※ 이후 월별 사업장 지급액을 수정하고 '수정 저장'을 클릭해야 최종 반영됩니다.
                            </small>
                        </div>

                        <div id="edit-dynamic-header-row" class="dynamic-form-row"
                             style="display: none; background: var(--light-gray-color); border-bottom: 1px solid var(--border-color); font-weight: 500; margin-bottom: 0;">
                            <div class="col-term-no">회차</div>
                            <div class="col-term-period">기간</div>
                            <div class="col-term-company">사업장 지급액(원)</div>
                            <div class="col-term-gov">정부 지급액 (예상)</div>
                        </div>

                        <div id="edit-dynamic-forms-container" class="dynamic-form-container">
                            </div>
                    </td>
                </tr>

                <tr><th class="sheet-head" colspan="4">근로조건 <i class="fa fa-edit" style="color:#007bff;"></i></th></tr>
                <tr>
                    <th>월 소정근로시간</th>
                    <td>
                        <input type="number" name="weeklyHours"
                               id="edit-weekly-hours"
                               class="form-control" style="width: 60%;"
                               value="${confirmDTO.weeklyHours}"> 시간
                    </td>
                    <th>통상임금 (월)</th>
                    <td>
                        <input type="number" name="regularWage"
                               id="edit-regular-wage"
                               class="form-control" style="width: 60%;"
                               value="${confirmDTO.regularWage}"> 원
                    </td>
                </tr>

                <tr><th class="sheet-head" colspan="4">대상 자녀 정보 <i class="fa fa-edit" style="color:#007bff;"></i></th></tr>
                <tr>
                    <th>자녀 이름</th>
                    <td>
                        <input type="text" name="childName"
                               id="edit-child-name"
                               placeholder="출산 후 입력"
                               class="form-control" style="width: 80%;"
                               value="${confirmDTO.childName}">
                    </td>
                    <th>출산(예정)일</th>
                    <td>
                        <input type="date" name="childBirthDate"
                               id="edit-child-birth-date"
                               class="form-control" style="width: 80%;"
                               value="<fmt:formatDate value='${confirmDTO.childBirthDate}' pattern='yyyy-MM-dd' />">
                    </td>
                </tr>
                <tr>
                    <th>자녀 주민등록번호</th>
                    <td colspan="3">
                        <input type="text" name="childResiRegiNumber"
                               id="edit-child-rrn"
                               placeholder="출산 후 입력 (예: 000000-0000000)"
                               class="form-control" style="width: 40%;"
                               value="${confirmDTO.childResiRegiNumber}">
                    </td>
                </tr>
            </table>

            <div class="button-container">
                <button type="button" id="updateBtn" class="btn btn-primary" style="margin-right:10px;">
                    <i class="fa fa-save"></i> 수정 저장
                </button>
                <button type="button" id="updateCancelBtn" class="btn btn-secondary">
                    취소
                </button>
            </div>
        </form>
    </div>
</div>
		        <div class="button-container">
		        	<c:choose> 
		
				        <c:when test="${confirmDTO.statusCode == 'ST_50' or confirmDTO.statusCode == 'ST_60'}">
				            <a href="${pageContext.request.contextPath}/admin/list" class="btn btn-secondary">목록으로</a>
				        </c:when>
		
				        <c:otherwise>
				            <div style="margin-bottom:15px;">
				                <label><input type="radio" name="judgeOption" value="approve">접수</label>
				                <label style="margin-left:15px;"><input type="radio" name="judgeOption" value="reject">반려</label>
				            </div>
				            
				            <div id="rejectForm">
							    <h3>반려 사유 선택</h3>
							    <div>
							        <label><input type="radio" name="reasonCode" value="RJ_10"> 계좌정보 불일치</label><br>
							        <label><input type="radio" name="reasonCode" value="RJ_20"> 관련서류 미제출</label><br>
							        <label><input type="radio" name="reasonCode" value="RJ_30"> 신청시기 미도래</label><br>
							        <label><input type="radio" name="reasonCode" value="RJ_40"> 근속기간 미충족</label><br>
							        <label><input type="radio" name="reasonCode" value="RJ_50"> 자녀 연령 기준 초과</label><br>
							        <label><input type="radio" name="reasonCode" value="RJ_60"> 휴직 가능 기간 초과</label><br>
							        <label><input type="radio" name="reasonCode" value="RJ_70"> 제출서류 정보 불일치</label><br>
							        <label><input type="radio" name="reasonCode" value="RJ_80"> 신청서 작성 내용 미비</label><br>
							        <label><input type="radio" name="reasonCode" value="RJ_99"> 기타</label>
							    </div> 
							
							    <div>
							        <label>상세 사유:</label><br>
							        <input type="text" id="rejectComment" class="form-control" placeholder="상세 사유를 입력하세요" style="width:80%;">
							    </div>
				
							</div>
							
							<div class="judge-actions">
					            <button type="button" id="confirmBtn" class="btn btn-primary">확인</button>
					            <button type="button" id="cancelBtn" class="btn btn-secondary">취소</button>
				            </div>
				            
				            <a href="${pageContext.request.contextPath}/admin/confirm" class="btn btn-secondary">목록</a>
				        </c:otherwise>
		    		</c:choose>
				</div>
			</div>
		
		<input type="hidden" id="confirmNumber" value="${confirmDTO.confirmNumber}" />
    </main>

<script>
document.addEventListener("DOMContentLoaded", function() {

    // ===== 변수 선언 =====
    const confirmBtn = document.getElementById("confirmBtn");
    const rejectForm = document.getElementById("rejectForm");
    const cancelBtn = document.getElementById("cancelBtn");
    const confirmNumber = document.getElementById("confirmNumber").value;
    const rejectComment = document.getElementById("rejectComment");
    const progressLine = document.querySelector('.progress-line');

    // 수정 폼 관련
    const editStartDateInput = document.getElementById('edit-start-date');
    const editEndDateInput = document.getElementById('edit-end-date');
    const generateEditBtn = document.getElementById('generate-edit-forms-btn');
    const editFormsContainer = document.getElementById('edit-dynamic-forms-container');
    const editHeaderRow = document.getElementById('edit-dynamic-header-row');

    console.log("✅ 페이지 로드 완료, confirmNumber:", confirmNumber);

    // ===== 진행바 초기화 =====
    let progressWidth = 0;
    switch ("${confirmDTO.statusCode}") {
        case "ST_20":
        case "ST_30":
            progressWidth = 43; break;
        case "ST_50":
        case "ST_60":
            progressWidth = 85; break;
        default: progressWidth = 0;
    }
    progressLine.style.width = progressWidth + "%";

    // ===== 유틸 함수 =====
    function withCommas(s) { return String(s).replace(/\B(?=(\d{3})+(?!\d))/g, ','); }
    function onlyDigits(s) { return (s||'').replace(/[^\d]/g,''); }
    function allowDigitsAndCommas(el, maxDigits) {
        function format() {
            const originalValue = onlyDigits(el.value).substring(0,maxDigits);
            el.value = withCommas(originalValue);
        }
        el.addEventListener('input', format);
        format();
    }

    function formatDate(date) {
        const y = date.getFullYear();
        const m = String(date.getMonth()+1).padStart(2,'0');
        const d = String(date.getDate()).padStart(2,'0');
        return y + '.' + m + '.' + d;
    }

    function formatDateForDB(date) {
        const y = date.getFullYear();
        const m = String(date.getMonth()+1).padStart(2,'0');
        const d = String(date.getDate()).padStart(2,'0');
        return y + '-' + m + '-' + d;
    }

    function getPeriodEndDate(originalStart, periodNumber) {
        let nextPeriodStart = new Date(originalStart.getFullYear(), originalStart.getMonth()+periodNumber, originalStart.getDate());
        if (nextPeriodStart.getDate() !== originalStart.getDate()) {
            nextPeriodStart = new Date(originalStart.getFullYear(), originalStart.getMonth()+periodNumber+1, 1);
        }
        nextPeriodStart.setDate(nextPeriodStart.getDate() - 1);
        return nextPeriodStart;
    }

    // ===== 접수/반려 처리 =====
    document.querySelectorAll('input[name="judgeOption"]').forEach(radio => {
        radio.addEventListener('change', function() {
            rejectForm.style.display = (this.value === 'reject') ? "block" : "none";
        });
    });

    confirmBtn?.addEventListener("click", function() {
        const selectedOption = document.querySelector('input[name="judgeOption"]:checked');
        if (!selectedOption) { alert("접수 또는 반려를 선택해주세요."); return; }
        const optionValue = selectedOption.value;

        if (optionValue === "approve") {
            if (!confirm("접수 처리하시겠습니까?")) return;
            fetch("${pageContext.request.contextPath}/admin/judge/approve", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ confirmNumber: confirmNumber })
            })
            .then(res => res.json())
            .then(data => { alert(data.message); if (data.success) location.href=data.redirectUrl; })
            .catch(err => { console.error(err); alert("접수 처리 중 오류"); });
        } else if (optionValue === "reject") {
            const selectedReason = document.querySelector('input[name="reasonCode"]:checked');
            const comment = rejectComment.value.trim();
            if (!selectedReason) { alert("반려 사유 선택"); return; }
            if (selectedReason.value==="RJ_99" && comment==="") { alert("기타 사유 입력"); return; }
            if (!confirm("반려 처리하시겠습니까?")) return;
            const requestData = { confirmNumber, rejectionReasonCode:selectedReason.value, rejectComment:comment };
            fetch("${pageContext.request.contextPath}/admin/judge/reject", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(requestData)
            })
            .then(res=>res.json())
            .then(data=>{ alert(data.message); if(data.success) location.href=data.redirectUrl; })
            .catch(err=>{ console.error(err); alert("반려 처리 오류"); });
        }
    });

 	// ===== 기간 나누기 버튼 (수정된 로직) =====
    generateEditBtn?.addEventListener('click', function() {
        // ... (유효성 검증 로직은 기존과 동일)
        if (!editStartDateInput.value || !editEndDateInput.value) { alert('기간 선택'); return; }
        const originalStart = new Date(editStartDateInput.value+'T00:00:00');
        const finalEnd = new Date(editEndDateInput.value+'T00:00:00');
        if (originalStart > finalEnd) { alert('종료일 체크'); return; }

        editFormsContainer.innerHTML = '';
        editHeaderRow.style.display = 'flex';

        let currentStart = new Date(originalStart);
        let idx = 1;
        while (currentStart <= finalEnd && idx <= 12) {
            let periodEnd = getPeriodEndDate(originalStart, idx);
            if (periodEnd > finalEnd) periodEnd = finalEnd;
            if (currentStart > periodEnd) break;

            const rangeText = formatDate(currentStart)+' ~ '+formatDate(periodEnd);
            const startDB = formatDateForDB(currentStart);
            const endDB = formatDateForDB(periodEnd);

            const row = document.createElement('div');
            row.className = 'dynamic-form-row';
            row.setAttribute('data-start-date', startDB);
            row.setAttribute('data-end-date', endDB);
            
            // 사업장 지급액 입력 필드만 생성 (정부 지급액은 일단 0원/빈칸으로 표시)
            row.innerHTML =
                '<div class="col-term-no">' + idx + '개월차</div>' +
                '<div class="col-term-period">' + rangeText + '</div>' +
                '<div class="payment-input-field col-term-company">' +
                '<input type="text" name="editMonthlyCompanyPay" class="form-control" placeholder="사업장 지급액(원)">' +
                '</div>' +
                // 정부 지급액 필드는 빈 값으로 생성
                '<div class="col-term-gov" style="text-align: right; padding-right: 15px;"><span>-</span></div>'; 

            editFormsContainer.appendChild(row);

            currentStart = new Date(periodEnd);
            currentStart.setDate(currentStart.getDate()+1);
            idx++;
        }

        // 쉼표 허용 유틸리티 다시 바인딩
        editFormsContainer.querySelectorAll('input[name="editMonthlyCompanyPay"]').forEach(inp=>allowDigitsAndCommas(inp,19));
    });
 
    // ===== 수정 저장 버튼 =====
document.getElementById("updateBtn")?.addEventListener("click", function() {
    const form = document.getElementById("updateForm");
    const formData = new FormData(form);
    const jsonData = {};

    // 1. 기본 폼 데이터 수집
    for (let [key, value] of formData.entries()) {
        // editMonthlyCompanyPay는 따로 처리해야 하므로 건너뜀
        if (key==='editMonthlyCompanyPay') continue; 
        
        // 값이 있고 공백이 아닌 경우에만 JSON에 추가 
        if (value && value.trim()!=='') jsonData[key] = value.trim(); 
    }
    jsonData.confirmNumber = confirmNumber;

    // 2. 단위기간 데이터 수집 (updatedTermAmounts)
    const termRows = editFormsContainer.querySelectorAll('.dynamic-form-row');
    const monthlyCompanyPayList = [];
    let hasError = false;

    // 기간 나누기 버튼을 눌러 행이 생성된 경우에만 처리
    if (termRows.length > 0) { 
        termRows.forEach((row, index) => {
            const start = row.getAttribute('data-start-date');
            const end = row.getAttribute('data-end-date');
            const companyInput = row.querySelector('input[name="editMonthlyCompanyPay"]');
            
            // 쉼표 제거 후 숫자로 변환
            const companyPay = onlyDigits(companyInput.value); 
            
            // 필수 입력 검증
            if (companyPay === '' || companyPay === null) { 
                alert((index + 1) + '개월차의 월별 사업장 지급액을 입력해주세요.'); 
                companyInput.focus(); 
                hasError=true; 
                return; 
            }
            monthlyCompanyPayList.push(Number(companyPay));
            /* // 서버로 보낼 DTO 구조에 맞게 데이터를 구성
            updatedTermAmounts.push({ 
                startMonthDate: start, 
                endMonthDate: end, 
                // DB 저장을 위해 Number로 변환하여 전송
                companyPayment: Number(companyPay) 
            }); */
        });

        if (hasError) return;
        
        // 서버의 ConfirmApplyDTO의 필드명에 맞게 updatedTermAmounts 배열을 추가
        //jsonData.updatedTermAmounts = updatedTermAmounts;
        jsonData.monthlyCompanyPay = monthlyCompanyPayList;
        
    } else {
        // 기간 나누기 버튼을 누르지 않은 경우 (기존 데이터만 업데이트하는 경우) 처리
        // 만약 기간/금액 수정이 필수라면 이 부분을 수정해야 함
        // 현재는 필수 아닌 것으로 가정하고 진행
    }

    if (!confirm("수정 내용을 저장하시겠습니까? (이 작업은 월별 정부 지원금 재계산을 포함합니다.)")) return;

    // 3. AJAX 요청
    fetch("${pageContext.request.contextPath}/admin/judge/update", {
        method:"POST",
        headers:{ "Content-Type":"application/json" },
        body:JSON.stringify(jsonData)
    })
    .then(res => {
        // HTTP 응답 코드가 200 (OK)이 아니면 에러로 처리
        if (!res.ok) {
            return res.json().then(errorData => {
                throw new Error(errorData.message || "서버 오류 발생");
            });
        }
        return res.json();
    })
    .then(data => {
        alert(data.message);
        if(data.success && data.data && data.data.termAmounts) {
            // 4. 서버에서 최종 계산된 termAmounts를 받아 화면 갱신
            updateTermRows(data.data.termAmounts); 
        } else if (data.success) {
            // 성공했으나 데이터가 없는 경우 (예: 금액 관련 수정이 없었던 경우)
            alert("수정은 완료되었으나 화면 갱신 데이터가 없습니다.");
        }
    })
    .catch(err => { 
        console.error("저장 오류:", err); 
        alert("수정 저장 중 오류 발생: " + err.message); 
    });
});

    // ===== 단위기간 화면 갱신 (수정 폼 영역) =====
function updateTermRows(termAmounts) {
    // 1. 수정 폼 컨테이너 (우측 카드) 갱신
    const editFormsContainer = document.getElementById('edit-dynamic-forms-container');
    editFormsContainer.innerHTML = '';
    
    // 헤더 노출
    document.getElementById('edit-dynamic-header-row').style.display = 'flex'; 

    termAmounts.forEach((term, index) => {
        const row = document.createElement('div');
        row.className = 'dynamic-form-row';
        // startMonthDate와 endMonthDate는 DB 포맷(yyyy-MM-dd)으로 가정
        row.setAttribute('data-start-date', term.startMonthDate); 
        row.setAttribute('data-end-date', term.endMonthDate);
        
        // 값 포맷팅
        const companyPay = term.companyPayment || 0;
        const govPay = term.govPayment || 0;
        const rangeText = formatDate(new Date(term.startMonthDate)) + ' ~ ' + formatDate(new Date(term.endMonthDate));

        // HTML 구성
        row.innerHTML =
            '<div class="col-term-no">' + (index + 1) + '개월차</div>' +
            '<div class="col-term-period">' + rangeText + '</div>' +
            '<div class="payment-input-field col-term-company">' +
                '<input type="text" name="editMonthlyCompanyPay" class="form-control" value="' + withCommas(companyPay) + '">' +
            '</div>' +
            // 재계산된 정부 지급액을 표시
            '<div class="col-term-gov" style="text-align: right; padding-right: 15px;">' +
                '<span>' + withCommas(govPay) + '원</span>' + 
            '</div>';

        editFormsContainer.appendChild(row);
        
        // 쉼표 허용 유틸리티 다시 바인딩 (input에만)
        allowDigitsAndCommas(row.querySelector('input[name="editMonthlyCompanyPay"]'), 19);
    });
    
    // 2. (선택적) 원본 데이터 테이블 (좌측 테이블) 갱신 로직 추가
    // 이 부분은 뷰 구조에 따라 다르므로 필요하다면 직접 구현하거나 별도로 요청해주세요.
    // 예: document.getElementById('original-term-table-body').innerHTML = ...
}

    // ===== 시작일/종료일 변경 시 폼 초기화 =====
    editStartDateInput?.addEventListener('change',function(){
        if(editStartDateInput.value) editEndDateInput.min=editStartDateInput.value;
        else editEndDateInput.removeAttribute('min');
        editFormsContainer.innerHTML=''; editHeaderRow.style.display='none';
    });
    editEndDateInput?.addEventListener('change',function(){
        editFormsContainer.innerHTML=''; editHeaderRow.style.display='none';
    });

    // ===== 수정 취소 =====
    document.getElementById("updateCancelBtn")?.addEventListener("click",function(){
        if(confirm("수정을 취소하시겠습니까?\n입력한 내용이 초기화됩니다.")) location.reload();
    });

});
</script>


    <footer class="footer">
        <p>&copy; 2025 육아휴직 서비스. All Rights Reserved.</p>
    </footer>

</body>
</html>