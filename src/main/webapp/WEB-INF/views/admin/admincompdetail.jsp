<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.google.gson.Gson" %>
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
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/global.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<style>
        :root {
	    --primary-color: #24A960; 
	    --white-color: #ffffff;
	    --light-gray-color: #f9fafb;
	    --gray-color: #6b7280;
	    --dark-gray-color: #1f2937;
	    --border-color: #e5e7eb;
	    --shadow-lg: 0 10px 30px rgba(0, 0, 0, 0.1);
	    --shadow-sm: 0 2px 6px rgba(0,0,0,0.06);
	    --shadow-md: 0 6px 18px rgba(0,0,0,0.10);
	    --primary-light-color: rgba(36, 169, 96, 0.08);
	    --success-color: #24A960;
		}

*{margin:0;padding:0;box-sizing:border-box}
html{height:100%}
body{
	display:flex;flex-direction:column;min-height:100vh;
	font-family:'Noto Sans KR',sans-serif;background-color:var(--light-gray-color);
	color:var(--dark-gray-color);
}
a{text-decoration:none;color:inherit}

.footer {
       text-align: center;
       padding: 20px 0;
       font-size: 14px;
       color: var(--gray-color);
       margin-top: auto;
   }



.main-container{
	flex-grow:1;width:100%;max-width:1200px;margin:2rem auto;padding:40px;
	background-color:var(--white-color);border-radius:12px;box-shadow:var(--shadow-md);
}

h1{text-align:center;margin-bottom:10px;font-size:28px}
h2{
	color:var(--primary-color);border-bottom:2px solid var(--primary-light-color);
	padding-bottom:10px;margin-bottom:25px;font-size:20px;
}

.section-title{
	font-size:20px;font-weight:700;color:var(--dark-gray-color);
	margin-bottom:15px;border-left:4px solid var(--primary-color);padding-left:10px;
}

.info-table-container{margin-bottom:30px}
.info-table{
  width:100%;
  border-collapse:collapse;
  border-top:2px solid var(--border-color);
  border-left:none;
  border-right:none;
  table-layout:fixed;
}
.info-table th,
.info-table td{
  padding:12px 15px;
  border:1px solid var(--border-color);
  text-align:left;
  font-size:15px;
  word-break:keep-all;
}
.info-table th{
  background-color:var(--light-gray-color);
  font-weight:500;
  color:var(--dark-gray-color);
  text-align:center;
}
.info-table td{
  background-color:var(--white-color);
  color:#333;
}

.info-table.table-4col th,
.info-table.table-4col td{
}

.info-table tr:first-child th,
.info-table tr:first-child td{
  border-top:1px solid var(--border-color);
}


.btn{
	display:inline-block;padding:10px 20px;font-size:15px;font-weight:500;
	border-radius:8px;border:1px solid var(--border-color);cursor:pointer;
	transition:all .2s ease-in-out;text-align:center;
}
.btn-primary{background-color:var(--primary-color);color:#fff;border-color:var(--primary-color)}
.btn-primary:hover{background-color:#364ab1;box-shadow:var(--shadow-md);transform:translateY(-2px)}
.btn-secondary{background-color:var(--white-color);color:var(--gray-color);border-color:var(--border-color)}
.btn-secondary:hover{background-color:var(--light-gray-color);color:var(--dark-gray-color);border-color:#ccc}
.btn-logout{background-color:var(--dark-gray-color);color:#fff;border:none}
.btn-logout:hover{background-color:#555}

.button-container{text-align:center;margin-top:50px}
.bottom-btn{padding:12px 30px;font-size:1.1em}
#edit-btn{background-color:var(--primary-color);color:#fff;border-color:var(--primary-color)}
#edit-btn:hover{background-color:#364ab1;border-color:#364ab1;transform:translateY(-2px)}

.data-title{font-weight:500}
.detail-btn{
	border:1px solid var(--primary-color);color:var(--primary-color);
	background-color:var(--white-color);padding:3px 8px;font-size:14px;
	margin-left:10px;border-radius:4px;cursor:pointer;transition:background-color .1s;
}
.detail-btn:hover{background-color:var(--primary-light-color)}
.success-text{color:var(--success-color);font-weight:500}

.modal-overlay{
    position:fixed;top:0;left:0;width:100%;height:100%;
    background-color:rgba(0,0,0,0.5);display:flex;
    justify-content:center;align-items:center;z-index:1000;
    transition: opacity 0.2s ease-in-out;
}
.modal-content {
    background-color:var(--white-color);padding:30px 40px;
    border-radius:12px;width:100%;max-width:500px;
    box-shadow:var(--shadow-md);
    transform: scale(0.95);
    transition: transform 0.2s ease-in-out;
}
.modal-overlay.visible .modal-content { transform: scale(1); }
.modal-content h2 {
    margin-top:0;text-align:center;color:var(--dark-gray-color);
    border-bottom:none;padding-bottom:0;margin-bottom:25px;
    font-size: 22px;
}
.form-group {margin-bottom:20px}
.form-group label {
    display:block;font-weight:500;margin-bottom:8px;font-size:16px;
}
.form-control {
    width:100%;padding:10px;font-size:15px;
    border:1px solid var(--border-color);border-radius:8px;
    font-family: 'Noto Sans KR', sans-serif;
}
textarea.form-control { resize: vertical; }
.modal-buttons {
    display:flex;justify-content:flex-end;gap:10px;margin-top:30px;
}
.highlight-warning {
    background-color: #f8d7da; 
    color: var(--danger-color);
    font-weight: 700;
    padding: 2px 6px;
    border-radius: 4px;
}

	  .progress-card {
	    background: #fff;
	    border: 1px solid var(--border-color);
	    border-radius: 14px;
	    padding: 20px;
	    margin-bottom: 24px;
	    box-shadow: var(--shadow-lg);
	  }
	
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
	  top: 50%; 
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
	
	.step-name {
	  font-size: 14px;
	  color: #333;
	  margin-top: 6px;
	  display: block;
	}
	
	.stepper-item.completed .step-counter {
	  background-color: #81c784; /* 연한 초록색 */
	  box-shadow: inset 0 0 0 5px rgba(46,125,50,0.25); 
	}
	
	.stepper-item.current .step-counter {
	  background-color: #2e7d32;
	  box-shadow: 0 0 0 4px rgba(46, 125, 50, 0.2);
	}
	
	.stepper-item.waiting .step-counter {
	  background-color: #dcdcdc;
	  color: #999;
	}
	
	.stepper-wrapper .progress-line {
	  position: absolute;
	  top: 50%; 
	  left: 8%;
	  height: 10px;
	  border-radius: 10px;
	  background-color: #4caf50;
	  z-index: 1;
	  transform: translateY(-50%);
	  transition: width 0.4s ease;
	  max-width: 84%;
	}
    

#rejectForm { display: none; }

.judge-wrap {
  display: flex;
  align-items: center;
  gap: 16px;             
  margin: 12px 0 16px;   
}
.judge-wrap input[type="radio"] {
  margin-right: 6px;     
}

.btn{
  display:inline-flex; align-items:center; justify-content:center;
  gap:8px; padding:12px 18px; font-size:15px; font-weight:600;
  border-radius:12px; border:1px solid var(--border-color);
  background: var(--white-color); color: var(--dark-gray-color);
  cursor:pointer; transition: transform .12s ease, box-shadow .12s ease, background .12s ease, color .12s ease, border-color .12s ease;
  box-shadow: var(--shadow-sm);
}
.btn:hover{ transform: translateY(-1px); box-shadow: var(--shadow-md); }
.btn:active{ transform: translateY(0); }
.btn-primary{ background: var(--primary-color); color:#fff; border-color: var(--primary-color); }
.btn-primary:hover{ filter: brightness(0.95); }
.btn-outline{ background:#fff; color: var(--primary-color); border-color: var(--primary-color); }
.btn-outline:hover{ background: var(--primary-light-color); }
.btn-ghost{ background: transparent; color: var(--gray-color); border-color: transparent; }
.btn-ghost:hover{ background: var(--light-gray-color); color: var(--dark-gray-color); }
.btn-lg{ padding:14px 24px; font-size:16px; border-radius:14px; }

.action-bar{
  margin-top:40px;
  text-align: center;
}
.action-bar .list-button-slot {
}

.action-bar .button-row{
  display:flex !important;
  align-items:center !important;
  flex-wrap:nowrap !important;
  gap:12px;
  margin-top:20px;
}

.action-bar .right-buttons{
  display:flex !important;
  gap:10px;
  margin-left:auto !important;
}

.action-bar .button-row .btn{
  display:inline-flex !important;
}

.segments{
  display:inline-flex; border:1px solid var(--border-color); border-radius:12px; overflow:hidden; background:#fff; box-shadow: var(--shadow-sm);
}
.segment-btn{
  padding:10px 25px; font-weight:700; border:none; background:#fff; color:#334155; cursor:pointer;
}
.segment-btn + .segment-btn{ border-left:1px solid var(--border-color); }
.segment-btn[aria-pressed="true"]{
  background: #e9ecef;          
  color: #343a40;                
  box-shadow: inset 0 1px 3px rgba(0,0,0,0.15);
}



#rejectForm{
  display:block;
  margin-top:10px; padding:10px 12px;
  border:1px solid #d6ecde; background:#d6ecde; border-radius:10px;
}

#rejectForm .form-row{
  display:grid !important;
  grid-template-columns: 110px 1fr;
  column-gap: 10px;
  row-gap: 0;
  align-items:center;
  margin:8px 0 !important;
}

#rejectForm label{
  margin:0 !important;
  white-space:nowrap !important;
  font-weight:700; color:#334155;
}

#rejectForm .form-control{
  width:100%;
  padding:10px 12px !important;
  font-size:14px !important;
  border-radius:10px;
}

#rejectForm select{ min-width:0 !important; }

#rejectForm .form-row.row-detail{ align-items: start; }
#rejectForm .form-row.row-detail label{ margin:0 !important; }
#rejectForm .form-row.row-detail .form-control{ grid-column: 2; }
#rejectForm .form-row.row-detail textarea.form-control{
  min-height:140px;    
  line-height:1.5;
  resize:vertical;
}
#rejectForm .form-row:first-of-type .form-control{
  flex: 0 0 auto !important;
  width: clamp(160px, 26vw, 240px) !important; 
  max-width: 240px !important;
  justify-self: start; /* 왼쪽 정렬 */
}

.info-table.edit-table th {
  background: #d6ecde;
}

.info-table.edit-table th,
.info-table.edit-table td {
  padding: 10px 10px;
}

.info-table.edit-table .form-control {
  padding: 4px 8px !important;
  font-size: 14px;
  box-sizing: border-box;
  border: none;
  outline: none;
  background-color: transparent;
}


.file-download-link {
    color: var(--primary-color);
    font-weight: 500;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 8px;
}
.file-download-link:hover {
    text-decoration: underline;
}

.term-edit-header{
  display:flex;
  align-items:center;
  justify-content:space-between;
  gap:12px;
  margin-bottom:10px;
}
.term-edit-header .section-title{
  margin-bottom:0; 
}



#edit-dynamic-header-row{
  display:none;
  font-weight:600;
  margin-bottom:8px;
}

.term-edit-notice{
  display:block;
  margin-top:8px;
  color:#155724;   
  font-size:13px;
  line-height:1.5;
}
.info-table.reject-table th {
  background: #f1c0c4;; 
}
</style>
</head>
<body>

<jsp:include page="adminheader.jsp" />

<main class="main-container">
<c:set var="status" value="${confirmDTO.statusCode}" />
<c:set var="currentStep" value="1" />
<c:choose>
  <c:when test="${status == 'ST_20' || status == 'ST_30'}">
    <c:set var="currentStep" value="2"/>
  </c:when>
  <c:when test="${status == 'ST_50' || status == 'ST_60'}">
    <c:set var="currentStep" value="3"/>
  </c:when>
</c:choose>

<c:set var="progressWidth" value="0" />
<c:choose>
  <c:when test="${currentStep == 1}"><c:set var="progressWidth" value="0"/></c:when>
  <c:when test="${currentStep == 2}"><c:set var="progressWidth" value="50"/></c:when>
  <c:when test="${currentStep == 3}"><c:set var="progressWidth" value="100"/></c:when>
</c:choose>

<div class="progress-card">
  <div class="stepper-wrapper">
    <div class="progress-line" style="width:${progressWidth}%;"></div>

    <div class="stepper-item ${currentStep > 1 ? 'completed' : (currentStep == 1 ? 'current' : '')}">
      <div class="step-counter">1</div>
      <div class="step-name">제출</div>
    </div>
    <div class="stepper-item ${currentStep > 2 ? 'completed' : (currentStep == 2 ? 'current' : '')}">
      <div class="step-counter">2</div>
      <div class="step-name">심사중</div>
    </div>
    <div class="stepper-item ${currentStep > 3 ? 'completed' : (currentStep == 3 ? 'current' : '')}">
      <div class="step-counter">3</div>
      <div class="step-name">
        <c:choose>
          <c:when test="${status == 'ST_50'}">승인</c:when>
          <c:when test="${status == 'ST_60'}">반려</c:when>
          <c:otherwise>결과대기</c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>
</div>

<h1>육아휴직 확인서 상세 보기</h1>

<c:if test="${confirmDTO.statusCode == 'ST_60'}">
  <div class="info-table-container">
    <table class="info-table table-4col reject-table">
      <colgroup>
        <col style="width:15%"><col style="width:85%">
      </colgroup>
      <tbody>
        <tr>
          <th>반려 사유</th>
          <td>
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
	          <c:otherwise>기타</c:otherwise>
	        </c:choose>
	      </span>
          </td>
        </tr>
        <tr>
          <th>상세 사유</th>
          <td>
            <c:choose>
              <c:when test="${not empty confirmDTO.rejectComment}">
                <c:out value="${confirmDTO.rejectComment}" />
              </c:when>
              <c:otherwise>
                <span class="highlight-warning">상세 사유 미입력</span>
              </c:otherwise>
            </c:choose>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</c:if>



<div class="info-table-container">
  <h2 class="section-title">접수 정보</h2>
  <table class="info-table table-4col">
    <colgroup>
      <col style="width:15%"><col style="width:35%">
      <col style="width:15%"><col style="width:35%">
    </colgroup>
    <tbody>
      <tr>
        <th>확인서 번호</th>
        <td><c:out value="${confirmDTO.confirmNumber}" /></td>
        <th>처리 상태</th>
        <td>
          <c:choose>
            <c:when test="${confirmDTO.statusCode == 'ST_20'}">
              <span class="status-badge status-pending">제출</span>
            </c:when>
            <c:when test="${confirmDTO.statusCode == 'ST_30'}">
              <span class="status-badge status-pending">심사중</span>
            </c:when>
            <c:when test="${confirmDTO.statusCode == 'ST_50'}">
              <span class="status-badge status-approved">승인</span>
            </c:when>
            <c:when test="${confirmDTO.statusCode == 'ST_60'}">
              <span class="status-badge status-rejected">반려</span>
            </c:when>
            <c:otherwise><c:out value="${confirmDTO.statusCode}" /></c:otherwise>
          </c:choose>
        </td>
      </tr>
      <tr>
        <th>제출일</th>
        <td><fmt:formatDate value="${confirmDTO.applyDt}" pattern="yyyy-MM-dd" /></td>
        <th>기업명</th>
        <td><c:out value="${userDTO.name}" /></td>
      </tr>
      <tr>
        <th>주소</th>
        <td><c:out value="${userDTO.addressBase}" /> <c:out value="${userDTO.addressDetail}" /></td>
        <th>전화번호</th>
        <td><c:out value="${userDTO.phoneNumber}" /></td>
      </tr>
    </tbody>
  </table>
</div>

<!-- 근로자 정보 -->
<div class="info-table-container">
  <h2 class="section-title">근로자 정보</h2>
  <table class="info-table table-4col">
    <colgroup>
      <col style="width:15%"><col style="width:35%">
      <col style="width:15%"><col style="width:35%">
    </colgroup>
    <tbody>
      <tr>
        <th>성명</th>
        <td><c:out value="${confirmDTO.name}" /></td>
        <th>주민등록번호</th>
        <td>
          <c:set var="rrnDigits" value="${fn:replace(confirmDTO.registrationNumber, '-', '')}" />
          ${fn:substring(rrnDigits,0,6)}-${fn:substring(rrnDigits,6,13)}
        </td>
      </tr>
      <tr>
        <th>육아휴직 기간</th>
        <td colspan="3">
          <fmt:formatDate value="${confirmDTO.startDate}" pattern="yyyy.MM.dd" />
          ~
          <fmt:formatDate value="${confirmDTO.endDate}" pattern="yyyy.MM.dd" />
        </td>
      </tr>
      <tr>
        <th>월 소정근로시간</th>
        <td>${confirmDTO.weeklyHours} 시간</td>
        <th>통상임금 (월)</th>
        <td>
          <fmt:formatNumber value="${confirmDTO.regularWage}" type="number" pattern="#,###" /> 원
        </td>
      </tr>
    </tbody>
  </table>
</div>

<!-- 자녀 정보 -->
<div class="info-table-container">
  <h2 class="section-title">대상 자녀 정보</h2>
  <table class="info-table table-4col">
    <colgroup>
      <col style="width:15%"><col style="width:35%">
      <col style="width:15%"><col style="width:35%">
    </colgroup>
    <tbody>
      <c:choose>
        <c:when test="${not empty confirmDTO.childName}">
          <tr>
            <th>자녀 이름</th>
            <td><c:out value="${confirmDTO.childName}" /></td>
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
          <tr>
            <th>자녀 정보</th>
            <td colspan="3">출산 예정</td>
          </tr>
          <tr>
            <th>출산 예정일</th>
            <td colspan="3">
              <fmt:formatDate value="${confirmDTO.childBirthDate}" pattern="yyyy.MM.dd" />
            </td>
          </tr>
        </c:otherwise>
      </c:choose>
    </tbody>
  </table>
</div>

<!-- 월별 지급 내역 -->
<div class="info-table-container">
  <h2 class="section-title">월별 지급 내역</h2>
  <table class="info-table">
    <thead>
      <tr>
        <th style="text-align:center;">회차</th>
        <th style="text-align:center;">기간</th>
        <th style="text-align:center;">사업장 지급액</th>
        <th style="text-align:center;">정부 지급액</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="term" items="${confirmDTO.termAmounts}" varStatus="status">
        <tr>
          <td style="text-align:center;">${status.count}개월차</td>
          <td style="text-align:center;">
            <fmt:formatDate value="${term.startMonthDate}" pattern="yyyy.MM.dd" />
            ~
            <fmt:formatDate value="${term.endMonthDate}" pattern="yyyy.MM.dd" />
          </td>
          <td style="text-align:center;">
            <fmt:formatNumber value="${term.companyPayment}" type="number" pattern="#,###" />원
          </td>
          <td style="text-align:center;">
            <fmt:formatNumber value="${term.govPayment}" type="number" pattern="#,###" />원
          </td>
        </tr>
      </c:forEach>
      <c:if test="${empty confirmDTO.termAmounts}">
        <tr>
          <td colspan="4" style="text-align:center;color:var(--gray-color);">
            입력된 지급 내역이 없습니다.
          </td>
        </tr>
      </c:if>
    </tbody>
  </table>
</div>

<!-- 담당자 정보 -->
<div class="info-table-container">
  <h2 class="section-title">확인서 담당자 정보</h2>
  <table class="info-table table-4col">
    <colgroup>
      <col style="width:15%"><col style="width:35%">
      <col style="width:15%"><col style="width:35%">
    </colgroup>
    <tbody>
      <tr>
        <th>담당자 이름</th>
        <td><c:out value="${confirmDTO.responseName}" /></td>
        <th>담당자 연락처</th>
        <td><c:out value="${confirmDTO.responsePhoneNumber}" /></td>
      </tr>
    </tbody>
  </table>
</div>

<div class="info-table-container">
  <h2 class="section-title">첨부파일</h2>
  <table class="info-table table-4col">
    <colgroup>
      <col style="width:15%">
      <col>
    </colgroup>
    <tbody>
      <c:if test="${empty files}">
        <tr>
          <th style="width:150px;text-align:center;">파일 목록</th>
          <td>첨부된 파일이 없습니다.</td>
        </tr>
      </c:if>

      <c:if test="${not empty files}">
        <c:forEach var="file" items="${files}" varStatus="status">
          <tr>
            <c:if test="${status.first}">
              <th rowspan="${fn:length(files)}" style="width:150px;text-align:center;">
                파일 목록
              </th>
            </c:if>
            <td>
              <a href="${pageContext.request.contextPath}/file/download?fileId=${file.fileId}&seq=${file.sequence}"
                 class="file-download-link">
                <span>
                  <c:choose>
                    <c:when test="${file.fileType == 'WAGE_PROOF'}">(통상임금 증명자료)</c:when>
                    <c:when test="${file.fileType == 'PAYMENT_FROM_EMPLOYER'}">(사업주로부터 금품을 지급받은 자료)</c:when>
                    <c:when test="${file.fileType == 'OTHER'}">(기타 자료)</c:when>
                    <c:when test="${file.fileType == 'ELIGIBILITY_PROOF'}">(배우자/한부모/장애아동 확인 자료)</c:when>
                    <c:otherwise>(기타 자료)</c:otherwise>
                  </c:choose>
                </span>
                <c:set var="parts" value="${fn:split(file.fileUrl, '\\\\')}" />
                ${parts[fn:length(parts) - 1]}
              </a>
            </td>
          </tr>
        </c:forEach>
      </c:if>
    </tbody>
  </table>
</div>

<!-- ===== 관리자 수정 폼(확인서용) ===== -->
<form id="updateForm">
  <input type="hidden" name="confirmNumber" value="${confirmDTO.confirmNumber}" />

  <!-- 근로자 정보 (수정) -->
  <div class="info-table-container">
    <h2 class="section-title">근로자 정보 (수정)</h2>
    <table class="info-table table-4col edit-table">
      <colgroup>
        <col style="width:15%"><col style="width:35%">
        <col style="width:15%"><col style="width:35%">
      </colgroup>
      <tbody>
        <tr>
          <th>성명</th>
          <td>
            <input type="text"
                   id="employee-name"
                   name="updName"
                   class="form-control"
                   value="${fn:escapeXml(confirmDTO.updName)}"
                   placeholder="육아휴직 대상 근로자 성명"/>
          </td>
          <th>주민등록번호</th>
          <td>
            <input type="text"
                   name="updRegistrationNumber"
                   id="edit-rrn"
                   placeholder="근로자 주민등록번호 (예: 000000-0000000)"
                   class="form-control"
                   value="${confirmDTO.updRegistrationNumber != null ? fn:escapeXml(confirmDTO.updRegistrationNumber) : ''}">
          </td>
        </tr>
        <tr>
          <th>육아휴직 시작일</th>
          <td>
            <fmt:formatDate value="${confirmDTO.updStartDate}" pattern="yyyy-MM-dd" var="updStartStr"/>
            <input type="date"
                   name="updStartDate"
                   id="edit-start-date"
                   class="form-control"
                   value="${updStartStr}">
          </td>
          <th>육아휴직 종료일</th>
          <td>
            <fmt:formatDate value="${confirmDTO.updEndDate}" pattern="yyyy-MM-dd" var="updEndStr"/>
            <input type="date"
                   name="updEndDate"
                   id="edit-end-date"
                   class="form-control"
                   value="${updEndStr}">
          </td>
        </tr>
        <tr>
          <th>월 소정근로시간</th>
          <td>
            <input type="number"
                   name="updWeeklyHours"
                   id="edit-weekly-hours"
                   class="form-control"
                   placeholder="근로자의 소정근로시간"
                   value="${confirmDTO.updWeeklyHours != null ? confirmDTO.updWeeklyHours : ''}">
          </td>
          <th>통상임금 (월)</th>
          <td>
            <input type="number"
                   name="updRegularWage"
                   id="edit-regular-wage"
                   class="form-control"
                   placeholder="근로자의  월별 통상임금"
                   value="${confirmDTO.updRegularWage != null ? confirmDTO.updRegularWage : ''}">
          </td>
        </tr>
      </tbody>
    </table>
  </div>

<!-- 월별 지급 내역 (수정/재계산) -->
<div class="info-table-container">
  <div class="term-edit-header">
    <h2 class="section-title">월별 지급 내역 (수정)</h2>
    <button type="button" id="generate-edit-forms-btn" class="btn btn-outline">
      <i class="fa fa-calendar"></i>&nbsp;기간 나누기 및 재계산
    </button>
  </div>

  <!-- 안내 문구 (버튼 바로 아래) -->
  <small class="term-edit-notice">
    ※ 기간,통상임금을 수정한 후 '기간 나누기 및 재계산'을 클릭하세요.<br>
    ※ 월별 사업장 지급액은 기본값이 0으로 설정되지만 수정이 가능합니다.<br>
    ※ 이후 '수정사항 저장'을 클릭해야 최종 반영됩니다.
  </small>

  <!-- “기간 나누기” 실행 전에는 통째로 display:none -->
  <div class="term-edit-box" id="term-edit-box" style="display:none;">
    <table class="info-table edit-table" id="edit-term-table">
  <colgroup>
    <col style="width:15%">
    <col style="width:45%">
    <col style="width:25%">
    <col style="width:15%">
  </colgroup>
  <thead>
    <tr>
      <th style="text-align:center;">회차</th>
      <th style="text-align:center;">기간</th>
      <th style="text-align:center;">사업장 지급액</th>
      <th style="text-align:center;">정부 지급액</th>
    </tr>
  </thead>
  <tbody id="edit-dynamic-forms-container">
    <%-- JS에서 <tr> 동적 생성 --%>
  </tbody>
</table>
  </div>
</div>





  <!-- 자녀 정보 (수정) -->
  <div class="info-table-container">
    <h2 class="section-title">대상 자녀 정보 (수정)</h2>
    <table class="info-table table-4col edit-table">
      <colgroup>
        <col style="width:15%"><col style="width:35%">
        <col style="width:15%"><col style="width:35%">
      </colgroup>
      <tbody>
        <tr>
          <th>자녀 이름</th>
          <td>
            <input type="text"
                   name="updChildName"
                   id="edit-child-name"
                   class="form-control"
                   placeholder="출산 후 입력"
                   value="${fn:escapeXml(confirmDTO.updChildName)}">
          </td>
          <th>출산(예정)일</th>
          <td>
            <fmt:formatDate value="${confirmDTO.updChildBirthDate}" pattern="yyyy-MM-dd" var="updChildBirthStr"/>
            <input type="date"
                   name="updChildBirthDate"
                   id="edit-child-birth-date"
                   class="form-control"
                   value="${updChildBirthStr}">
          </td>
        </tr>
        <tr>
          <th>자녀 주민등록번호</th>
          <td colspan="3">
            <input type="text"
                   name="updChildResiRegiNumber"
                   id="edit-child-rrn"
                   class="form-control"
                   placeholder="출산 후 입력 (예: 000000-0000000)"
                   value="${fn:escapeXml(confirmDTO.updChildResiRegiNumber)}">
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</form>

<!-- ===== 하단 관리자 버튼/세그먼트 ===== -->
<div class="action-bar">
  <c:choose>
    <c:when test="${confirmDTO.statusCode == 'ST_50' or confirmDTO.statusCode == 'ST_60'}">
      <a href="${pageContext.request.contextPath}/admin/list"
         class="btn btn-outline btn-lg">목록으로 돌아가기</a>
    </c:when>
    <c:otherwise>
      <div class="segments" id="judgeSegments">
	  <button type="button"
	          class="segment-btn"
	          id="approveBtnAction"
	          data-choice="approve"
	          aria-pressed="true">
	    접수
	  </button>
	  <button type="button"
	          class="segment-btn"
	          id="rejectBtnAction"
	          data-choice="reject"
	          aria-pressed="false">
	    반려
	  </button>
	</div>

      <div id="rejectForm">
        <div class="form-row">
          <label><strong>반려 사유</strong></label>
          <select id="reasonSelect" class="form-control">
            <option value="">사유를 선택하세요</option>
          </select>
        </div>

        <div class="form-row row-detail">
          <label>상세 사유</label>
          <textarea id="rejectComment" class="form-control" placeholder="상세사유 입력"></textarea>
        </div>
      </div>

      <div class="button-row">
        <!-- 왼쪽: 목록 -->
        <a href="${pageContext.request.contextPath}/admin/list"
           class="btn btn-outline btn-lg">목록으로 돌아가기</a>
        <!-- 오른쪽: 수정 저장 + 확인 -->
        <div class="right-buttons">
          <button type="button" id="updateBtn" class="btn btn-outline btn-lg">수정사항 저장</button>
          <button type="button" id="confirmBtn" class="btn btn-primary btn-lg">확인</button>
        </div>
      </div>
    </c:otherwise>
  </c:choose>
</div>

</main>

<input type="hidden" id="confirmNumber" value="${confirmDTO.confirmNumber}" />

<footer class="footer">
  <p>&copy; 2025 육아휴직 서비스. All Rights Reserved.</p>
</footer>

<script>
document.addEventListener("DOMContentLoaded", function() {
    const ctx = '${pageContext.request.contextPath}';
    const confirmNumber = document.getElementById("confirmNumber")?.value;

    const initialData = {
        termAmounts: ${gson.toJson(confirmDTO.updatedTermAmounts)} || [],
        originalTermAmounts: ${gson.toJson(confirmDTO.termAmounts)} || []
    };

    const editStartDateInput   = document.getElementById('edit-start-date');
    const editEndDateInput     = document.getElementById('edit-end-date');
    const generateEditBtn      = document.getElementById('generate-edit-forms-btn');
    const termEditBox          = document.getElementById('term-edit-box');
    const editFormsContainer   = document.getElementById('edit-dynamic-forms-container');
    const updateBtn            = document.getElementById('updateBtn');

    //  숫자/날짜 유틸
    function withCommas(s){return String(s).replace(/\B(?=(\d{3})+(?!\d))/g, ',');}
    function onlyDigits(s){return (s||'').replace(/[^\d]/g,'');}

    function allowDigitsAndCommas(el, maxDigits){
        function format(){
            const originalValue = onlyDigits(el.value).substring(0,maxDigits);
            el.value = withCommas(originalValue);
        }
        el.addEventListener('input', format);
        format();
    }

    function formatDate(date){
        const y = date.getFullYear();
        const m = String(date.getMonth()+1).padStart(2,'0');
        const d = String(date.getDate()).padStart(2,'0');
        return y + '.' + m + '.' + d;
    }
    function formatDateForDB(date){
        const y = date.getFullYear();
        const m = String(date.getMonth()+1).padStart(2,'0');
        const d = String(date.getDate()).padStart(2,'0');
        return y + '-' + m + '-' + d;
    }

    function getPeriodEndDate(originalStart, periodNumber){
        let nextPeriodStart = new Date(
            originalStart.getFullYear(),
            originalStart.getMonth()+periodNumber,
            originalStart.getDate()
        );
        if (nextPeriodStart.getDate() !== originalStart.getDate()) {
            nextPeriodStart = new Date(
                originalStart.getFullYear(),
                originalStart.getMonth()+periodNumber+1,
                1
            );
        }
        nextPeriodStart.setDate(nextPeriodStart.getDate()-1);
        return nextPeriodStart;
    }

    // 단위기간 폼 갱신 (수정 영역)
    function updateTermRows(termAmounts){
        editFormsContainer.innerHTML = '';

        if (!termAmounts || termAmounts.length === 0) {
            if (termEditBox) termEditBox.style.display = 'none';
            return;
        }

        if (termEditBox) termEditBox.style.display = 'block';

        termAmounts.forEach(function(term, index){
            const row = document.createElement('tr');
            row.className = 'dynamic-form-row';
            row.setAttribute('data-start-date', term.startMonthDate);
            row.setAttribute('data-end-date',   term.endMonthDate);

            const govPay = term.govPayment || 0;
            const companyPay = term.companyPayment || 0;
            const rangeText = formatDate(new Date(term.startMonthDate)) +
                              ' ~ ' +
                              formatDate(new Date(term.endMonthDate));

            row.innerHTML =
                '<td style="text-align:center;">' + (index+1) + '개월차</td>' +
                '<td style="text-align:center;">' + rangeText + '</td>' +
                '<td style="text-align:center;">' +
                  '<input type="text" name="editMonthlyCompanyPay" class="form-control" ' +
                  '       value="'+withCommas(companyPay)+'" ' +
                  '       style="text-align:center; max-width:140px;">' + '</td>' +
                  '<td style="text-align:center;">' +
               	// 재계산된 정부 지급액을 표시
  	            '<div class="col-term-gov" style="text-align: right; padding-right: 15px;">' +
  	                '<span>' + withCommas(govPay) + '원</span>' + 
  	            '</div>' + '</td>';

            editFormsContainer.appendChild(row);

            const inp = row.querySelector('input[name="editMonthlyCompanyPay"]');
            allowDigitsAndCommas(inp, 19);
        });
    }


    if (initialData.termAmounts && initialData.termAmounts.length > 0) {
        updateTermRows(initialData.termAmounts);
    }

    // 기간 나누기 버튼
generateEditBtn?.addEventListener('click', function(){
    if (!editStartDateInput.value || !editEndDateInput.value){
        alert('육아휴직 시작일과 종료일을 먼저 입력하세요.');
        return;
    }
    const originalStart = new Date(editStartDateInput.value+'T00:00:00');
    const finalEnd      = new Date(editEndDateInput.value+'T00:00:00');
    if (originalStart > finalEnd){
        alert('종료일이 시작일보다 빠를 수 없습니다.');
        return;
    }

    editFormsContainer.innerHTML = '';
    if (termEditBox) termEditBox.style.display = 'block';

    let currentStart = new Date(originalStart);
    let idx = 1;

    while (currentStart <= finalEnd && idx <= 12){
        let periodEnd = getPeriodEndDate(originalStart, idx);
        if (periodEnd > finalEnd) periodEnd = finalEnd;
        if (currentStart > periodEnd) break;

        const rangeText = formatDate(currentStart)+' ~ '+formatDate(periodEnd);
        const startDB   = formatDateForDB(currentStart);
        const endDB     = formatDateForDB(periodEnd);

        const row = document.createElement('tr');
        row.className = 'dynamic-form-row';
        row.setAttribute('data-start-date', startDB);
        row.setAttribute('data-end-date',   endDB);

        row.innerHTML =
            '<td style="text-align:center;">'+idx+'개월차</td>' +
            '<td style="text-align:center;">'+rangeText+'</td>' +
            '<td style="text-align:center;">' +
              '<input type="text" name="editMonthlyCompanyPay" class="form-control" ' +
              '       placeholder="사업장 지급액(원)" value="0" ' +
              '       style="text-align:center; max-width:140px;">' + '</td>' +
              '<td style="text-align:center;">'+
           	// 정부 지급액 필드는 빈 값으로 생성
            '<div class="col-term-gov" style="text-align: right; padding-right: 15px;"><span>-</span></div>' +
            '</td>';

        editFormsContainer.appendChild(row);

        const inp = row.querySelector('input[name="editMonthlyCompanyPay"]');
        allowDigitsAndCommas(inp, 19);

        currentStart = new Date(periodEnd);
        currentStart.setDate(currentStart.getDate()+1);
        idx++;
    }
});


    // 시작일/종료일 변경 시 동적 폼 리셋
editStartDateInput?.addEventListener('change', function(){
    if (editStartDateInput.value) editEndDateInput.min = editStartDateInput.value;
    else editEndDateInput.removeAttribute('min');

    editFormsContainer.innerHTML = '';
    if (termEditBox) termEditBox.style.display = 'none';
});
editEndDateInput?.addEventListener('change', function(){
    editFormsContainer.innerHTML = '';
    if (termEditBox) termEditBox.style.display = 'none';
});


    updateBtn?.addEventListener("click", function(){
        if (!confirmNumber){
            alert('확인서 번호를 확인할 수 없습니다.');
            return;
        }
        const form = document.getElementById("updateForm");
        const formData = new FormData(form);
        const jsonData = {};

        for (const [key, value] of formData.entries()){
            if (key === 'editMonthlyCompanyPay') continue;
            if (value && value.trim() !== '') jsonData[key] = value.trim();
        }
        jsonData.confirmNumber = confirmNumber;

        const termRows = editFormsContainer.querySelectorAll('.dynamic-form-row');
        const monthlyCompanyPayList = [];
        let hasError = false;

        if (termRows.length > 0){
            termRows.forEach(function(row, index){
                const companyInput = row.querySelector('input[name="editMonthlyCompanyPay"]');
                const companyPay   = onlyDigits(companyInput.value);
                if (!companyPay){
                    alert((index+1)+'개월차의 월별 사업장 지급액을 입력해주세요.');
                    companyInput.focus();
                    hasError = true;
                    return;
                }
                monthlyCompanyPayList.push(Number(companyPay));
            });
            if (hasError) return;
            jsonData.monthlyCompanyPay = monthlyCompanyPayList;
        }

        if (!confirm("수정 내용을 저장하시겠습니까? (월별 정부 지원금 재계산 포함)")) return;

        fetch(ctx + "/admin/judge/update", {
            method:"POST",
            headers:{"Content-Type":"application/json"},
            body:JSON.stringify(jsonData)
        })
        .then(res => res.json())
        .then(data => {
            alert(data.message || '수정이 완료되었습니다.');
            if (data.success){
                if (data.data && data.data.updatedTermAmounts){
                    updateTermRows(data.data.updatedTermAmounts);
                } else {
                    editFormsContainer.innerHTML = '';
                    editHeaderRow.style.display = 'none';
                }
            }
        })
        .catch(err => {
            console.error("저장 오류:", err);
            alert("수정 저장 중 오류 발생: " + err.message);
        });
    });

    const segmentsWrap    = document.getElementById('judgeSegments');
    const segmentBtns     = segmentsWrap ? segmentsWrap.querySelectorAll('.segment-btn') : [];
    const rejectForm      = document.getElementById('rejectForm');
    const reasonSelect    = document.getElementById('reasonSelect');
    const rejectCommentEl = document.getElementById('rejectComment');
    const confirmBtn      = document.getElementById('confirmBtn');

    let currentChoice = 'approve';
    let reasonsLoaded = false;

    function setChoice(choice){
        currentChoice = choice;
        segmentBtns.forEach(function(btn){
            const active = (btn.dataset.choice === choice);
            btn.setAttribute('aria-pressed', active ? 'true' : 'false');
        });

        if (choice === 'reject'){
            rejectForm.style.display = 'block';
            if (!reasonsLoaded){
                fetch(ctx + '/codes/reject', {
                    method:'GET',
                    headers:{'Accept':'application/json'}
                })
                .then(res => res.json())
                .then(list => {
                    reasonSelect.innerHTML =
                        '<option value="">사유를 선택하세요</option>';
                    if (Array.isArray(list) && list.length > 0){
                        list.forEach(function(item){
                            const opt = document.createElement('option');
                            opt.value = item.code;
                            opt.textContent = item.name || item.code;
                            reasonSelect.appendChild(opt);
                        });
                    } else {
                        const opt = document.createElement('option');
                        opt.value = 'RJ_99';
                        opt.textContent = '기타(사유코드 없음)';
                        reasonSelect.appendChild(opt);
                    }
                    reasonsLoaded = true;
                })
                .catch(() => {
                    reasonSelect.innerHTML =
                        '<option value="RJ_99">기타(네트워크 오류)</option>';
                    reasonsLoaded = true;
                });
            }
        } else {
            rejectForm.style.display = 'none';
        }
    }

    if (segmentBtns.length > 0) {
        setChoice('approve');
        segmentBtns.forEach(function(btn){
            btn.addEventListener('click', function(){
                setChoice(btn.dataset.choice);
            });
        });
    }

    confirmBtn?.addEventListener('click', function(){
        if (!confirmNumber){
            alert('확인서 번호를 확인할 수 없습니다.');
            return;
        }
        const approveUrl = ctx + '/admin/judge/approve';
        const rejectUrl  = ctx + '/admin/judge/reject';

        if (currentChoice === 'approve'){
            if (!confirm('접수(승인 진행)로 확정하시겠습니까?')) return;

            fetch(approveUrl, {
                method:'POST',
                headers:{'Content-Type':'application/json'},
                body:JSON.stringify({confirmNumber: confirmNumber})
            })
            .then(res => res.json())
            .then(data => {
                alert(data.message || '처리가 완료되었습니다.');
                if (data.redirectUrl){
                    location.href = data.redirectUrl;
                } else {
                    location.reload();
                }
            })
            .catch(() => alert('접수 처리 중 오류가 발생했습니다.'));
            return;
        }

        // 반려
        const code    = reasonSelect?.value || '';
        const comment = (rejectCommentEl?.value || '').trim();

        if (!code){
            alert('반려 사유를 선택하세요.');
            return;
        }
        if ((code === 'RJ_99' || code === 'ETC') && !comment){
            alert('기타 선택 시 상세 사유를 입력하세요.');
            return;
        }
        if (!confirm('반려 처리하시겠습니까?')) return;

        fetch(rejectUrl, {
            method:'POST',
            headers:{'Content-Type':'application/json'},
            body:JSON.stringify({
                confirmNumber: confirmNumber,
                rejectionReasonCode: code,
                rejectComment: comment
            })
        })
        .then(res => res.json())
        .then(data => {
            alert(data.message || '반려 처리가 완료되었습니다.');
            if (data.redirectUrl){
                location.href = data.redirectUrl;
            } else {
                location.reload();
            }
        })
        .catch(() => alert('반려 처리 중 오류가 발생했습니다.'));
    });
});
</script>


</body>
</html>
