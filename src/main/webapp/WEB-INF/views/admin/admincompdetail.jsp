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
                            ${fn:substring(rrnDigits,0,6)}-${fn:substring(rrnDigits,6,12)}
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
                        <th>주당 소정근로시간</th><td><c:out value="${confirmDTO.weeklyHours}" /> 시간</td>
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
                                    ${fn:substring(childRrn, 0, 6)}-${fn:substring(childRrn, 6, 12)}
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
	                     <th colspan="2">기간</th>
	                     <th colspan="1">사업장 지급액</th>
	                </tr>
        		</thead>
        		<tbody>
                    <c:forEach var="term" items="${termList}" varStatus="status">
                        <tr>
                            <td style="text-align:center;" colspan="1"><c:out value="${status.count}" />개월차</td>
                            <td style="text-align:center;" colspan="2">
                                <fmt:formatDate value="${term.startMonthDate}" pattern="yyyy.MM.dd" /> ~ 
                                <fmt:formatDate value="${term.endMonthDate}" pattern="yyyy.MM.dd" />
                            </td>
                            <td style="text-align:right; padding-right: 20px;" colspan="1">
                                <fmt:formatNumber value="${term.companyPayment}" type="currency" currencySymbol="₩ " />
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
		
		<!-- ===== 확인서 수정 폼 ===== -->
		<h3 style="margin-top:40px; margin-bottom:15px;">확인서 수정</h3>
		
		<form id="updateForm">
		  <table class="sheet-table">
		    <colgroup>
		      <col class="w160"><col><col class="w160"><col>
		    </colgroup>
		    
		    <!-- 접수 정보 (읽기 전용) -->
		    <tr><th class="sheet-head" colspan="4">접수 정보 (조회)</th></tr>
		    <tr>
		      <th>확인서 번호</th>
		      <td><input type="text" value="${confirmDTO.confirmNumber}" readonly class="form-control" style="width: 80%;"></td>
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
		      <td colspan="3">
		        <input type="text" value="<fmt:formatDate value="${confirmDTO.applyDt}" pattern="yyyy-MM-dd" />" readonly class="form-control" style="width: 40%;">
		      </td>
		    </tr>
		
		    <!-- 회사 정보 (읽기 전용) -->
		    <tr><th class="sheet-head" colspan="4">회사 정보 (조회)</th></tr>
		    <tr>
		      <th>기업명</th>
		      <td colspan="3"><input type="text" value="${userDTO.name}" readonly class="form-control" style="width: 60%;"></td>
		    </tr>
		    <tr>
		      <th>주소</th>
		      <td colspan="3"><input type="text" value="${userDTO.addressBase} ${userDTO.addressDetail}" readonly class="form-control" style="width: 100%;"></td>
		    </tr>
		    <tr>
		      <th>전화번호</th>
		      <td colspan="3"><input type="text" value="${userDTO.phoneNumber}" readonly class="form-control" style="width: 40%;"></td>
		    </tr>
		
		    <!-- 근로자 정보 (일부 읽기 전용, 일부 수정 가능) -->
		    <tr><th class="sheet-head" colspan="4">근로자 정보</th></tr>
		    <tr>
		      <th>성명</th>
		      <td><input type="text" value="${confirmDTO.name}" readonly class="form-control" style="width: 80%;"></td>
		      <th>주민등록번호</th>
		      <td>
		        <c:set var="rrnDigits" value="${fn:replace(confirmDTO.registrationNumber, '-', '')}" />
		        <input type="text" value="${fn:substring(rrnDigits,0,6)}-${fn:substring(rrnDigits,6,12)}" readonly class="form-control" style="width: 80%;">
		      </td>
		    </tr>
		    
		    <!-- 수정 가능: 육아휴직 기간 -->
		    <tr>
		      <th>육아휴직 시작일 <i class="fa fa-edit"></i></th>
		      <td>
		        <input type="date" name="updStartDate" value="<fmt:formatDate value="${confirmDTO.startDate}" pattern="yyyy-MM-dd" />" class="form-control" style="width: 80%;">
		      </td>
		      <th>육아휴직 종료일 <i class="fa fa-edit"></i></th>
		      <td>
		        <input type="date" name="updEndDate" value="<fmt:formatDate value="${confirmDTO.endDate}" pattern="yyyy-MM-dd" />" class="form-control" style="width: 80%;">
		      </td>
		    </tr>
		    
		    <!-- 수정 가능: 주당 소정근로시간, 통상임금 -->
		    <tr>
		      <th>월 소정근로시간 <i class="fa fa-edit"></i></th>
		      <td><input type="number" name="updWeeklyHours" value="${confirmDTO.weeklyHours}" class="form-control" style="width: 60%;"> 시간</td>
		      <th>통상임금 (월) <i class="fa fa-edit"></i></th>
		      <td><input type="number" name="updRegularWage" value="${confirmDTO.regularWage}" class="form-control" style="width: 60%;"> 원</td>
		    </tr>
		
		    <!-- 수정 가능: 자녀 정보 -->
		    <tr><th class="sheet-head" colspan="4">대상 자녀 정보 <i class="fa fa-edit"></i></th></tr>
		    <c:choose>
		      <c:when test="${not empty confirmDTO.childName}">
		        <tr>
		          <th>자녀 이름</th>
		          <td><input type="text" name="updChildName" value="${confirmDTO.childName}" class="form-control" style="width: 80%;"></td>
		          <th>출생일</th>
		          <td><input type="date" name="updChildBirthDate" value="<fmt:formatDate value="${confirmDTO.childBirthDate}" pattern="yyyy-MM-dd" />" class="form-control" style="width: 80%;"></td>
		        </tr>
		        <tr>
		          <th>자녀 주민등록번호</th>
		          <td colspan="3">
		            <c:set var="childRrn" value="${confirmDTO.childResiRegiNumber}" />
		            <input type="text" name="updChildResiRegiNumber" value="${fn:substring(childRrn, 0, 6)}-${fn:substring(childRrn, 6, 12)}" class="form-control" style="width: 40%;">
		          </td>
		        </tr>
		      </c:when>
		      <c:otherwise>
		        <tr>
		          <th>자녀 이름</th>
		          <td><input type="text" name="updChildName" value="" placeholder="출산 후 입력" class="form-control" style="width: 80%;"></td>
		          <th>출산 예정일</th>
		          <td><input type="date" name="updChildBirthDate" value="<fmt:formatDate value="${confirmDTO.childBirthDate}" pattern="yyyy-MM-dd" />" class="form-control" style="width: 80%;"></td>
		        </tr>
		        <tr>
		          <th>자녀 주민등록번호</th>
		          <td colspan="3">
		            <input type="text" name="updChildResiRegiNumber" value="" placeholder="출산 후 입력 (예: 000000-0000000)" class="form-control" style="width: 40%;">
		          </td>
		        </tr>
		      </c:otherwise>
		    </c:choose>
		
		    <!-- 담당자 정보 (읽기 전용) -->
		    <tr><th class="sheet-head" colspan="4">확인서 담당자 정보 (조회)</th></tr>
		    <tr>
		      <th>담당자 이름</th>
		      <td><input type="text" value="${confirmDTO.responseName}" readonly class="form-control" style="width: 80%;"></td>
		      <th>담당자 연락처</th>
		      <td><input type="text" value="${confirmDTO.responsePhoneNumber}" readonly class="form-control" style="width: 80%;"></td>
		    </tr>
		  </table>
		
		  <div class="button-container">
		    <button type="button" id="updateBtn" class="btn btn-primary" style="margin-right:10px;">수정 저장</button>
		  </div>
		
		  <input type="hidden" name="confirmNumber" value="${confirmDTO.confirmNumber}">
		</form>
		
        <div class="button-container">
        	<c:choose> 

		        <c:when test="${confirmDTO.statusCode == 'ST_50' or confirmDTO.statusCode == 'ST_60'}">
		            <a href="${pageContext.request.contextPath}/admin/confirm" class="btn btn-secondary">목록으로</a>
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
		
	    const confirmBtn = document.getElementById("confirmBtn");
	    const rejectForm = document.getElementById("rejectForm");
	    const cancelBtn = document.getElementById("cancelBtn");
	    const confirmNumber = document.getElementById("confirmNumber").value;
	    const rejectComment = document.getElementById("rejectComment");
 
	    console.log("✅ 페이지 로드 완료");
	    console.log("confirmNumber:", confirmNumber);
	    
	 	// 상태 코드에 따른 진행바 길이 조정
	    const progressLine = document.querySelector('.progress-line');
	    let progressWidth = 0;

	    switch ("${confirmDTO.statusCode}") {
	      case "ST_20":
	        progressWidth = 43;
	        break;
	      case "ST_30":
	        progressWidth = 43;
	        break;
	      case "ST_50":
	      case "ST_60":
	        progressWidth = 85;
	        break;
	      default:
	        progressWidth = 0;
	    }

	    progressLine.style.width = progressWidth + "%";
	    
	    // 지급 / 부지급 선택 시 즉시 반응
	    document.querySelectorAll('input[name="judgeOption"]').forEach(radio => {
	        radio.addEventListener('change', function() {
	            if (this.value === 'reject') {
	                // 부지급 선택 시 폼 표시
	                rejectForm.style.display = "block";
	                window.scrollTo({ top: document.body.scrollHeight, behavior: 'smooth' });
	            } else {
	                // 지급 선택 시 폼 숨김
	                rejectForm.style.display = "none";
	            }
	        });
	    });

	    // 확인 버튼 클릭 이벤트
	    confirmBtn.addEventListener("click", function() {
	        const selectedOption = document.querySelector('input[name="judgeOption"]:checked');

	        if (!selectedOption) {
	            alert("접수 또는 반려를 선택해주세요.");
	            return;
	        }

	        const optionValue = selectedOption.value;

	        // 지급 처리
	        if (optionValue === "approve") {
	            if (!confirm("접수 처리하시겠습니까?")) return;

	            fetch("${pageContext.request.contextPath}/admin/judge/approve", {
	                method: "POST",
	                headers: { "Content-Type": "application/json" },
	                body: JSON.stringify({ confirmNumber: confirmNumber })
	            })
	            .then(res => res.json())
	            .then(data => {
	                alert(data.message);
	                if (data.success) location.href = data.redirectUrl;
	            })
	            .catch(err => {
	                console.error(err);
	                alert("접수 처리 중 오류가 발생했습니다.");
	            });
	        }

	        // 부지급 처리
	        else if (optionValue === "reject") {
	            const selectedReason = document.querySelector('input[name="reasonCode"]:checked');
	            const comment = rejectComment.value.trim();

	            if (!selectedReason) {
	                alert("반려 사유를 선택해주세요.");
	                return;
	            }

	            if (selectedReason.value === "RJ_99" && comment === "") {
	                alert("기타를 선택한 경우 상세 사유를 입력해야 합니다.");
	                return;
	            }

	            if (!confirm("반려 처리하시겠습니까?")) return;

	            const requestData = {
	                confirmNumber: confirmNumber,
	                rejectionReasonCode: selectedReason.value,
	                rejectComment: comment
	            };

	            fetch("${pageContext.request.contextPath}/admin/judge/reject", {
	                method: "POST",
	                headers: { "Content-Type": "application/json" },
	                body: JSON.stringify(requestData)
	            })
	            .then(res => res.json())
	            .then(data => {
	                alert(data.message);
	                if (data.success) location.href = data.redirectUrl;
	            })
	            .catch(err => {
	                console.error(err);
	                alert("반려 처리 중 오류가 발생했습니다.");
	            });
	        }
	    });
	});
	
	// 수정 저장 버튼 클릭
	document.getElementById("updateBtn")?.addEventListener("click", function() {
	    const form = document.getElementById("updateForm");
	    const formData = new FormData(form);
	    const jsonData = Object.fromEntries(formData.entries());

	    if (!confirm("수정된 내용을 저장하시겠습니까?")) return;

	    fetch("${pageContext.request.contextPath}/admin/judge/update", {
	        method: "POST",
	        headers: { "Content-Type": "application/json" },
	        body: JSON.stringify(jsonData)
	    })
	    .then(res => res.json())
	    .then(data => {
	        alert(data.message);
	        if (data.success) location.reload();
	    })
	    .catch(err => {
	        console.error(err);
	        alert("수정 중 오류가 발생했습니다.");
	    });
	});

</script>

    <footer class="footer">
        <p>&copy; 2025 육아휴직 서비스. All Rights Reserved.</p>
    </footer>

</body>
</html>