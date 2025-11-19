<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>육아휴직 급여 신청서 상세 보기</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/global.css">

<style>
:root{
    --primary-color:#3f58d4;
	--primary-light-color:#f0f2ff;
	--white-color:#ffffff;
	--light-gray-color:#f8f9fa;
	--gray-color:#868e96;
	--dark-gray-color:#343a40;
	--border-color:#dee2e6;
	--success-color:#28a745;
	--warning-bg-color:#fff3cd;
	--warning-border-color:#ffeeba;
	--warning-text-color:#856404;
	--shadow-sm:0 1px 3px rgba(0,0,0,0.05);
	--shadow-md:0 4px 8px rgba(0,0,0,0.07);
}

/* 기본 스타일 */
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

/* 섹션 타이틀 */
.section-title{
	font-size:20px;font-weight:700;color:var(--dark-gray-color);
	margin-bottom:15px;border-left:4px solid var(--primary-color);padding-left:10px;
}

/* 테이블 */
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


/* 버튼 */
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

/* 하단 버튼 컨테이너 */
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

/* 모달 스타일 */
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
/* [추가] 하이라이팅을 위한 CSS 클래스 */
.highlight-warning {
    background-color: #f8d7da; /* 부드러운 빨간색 배경 */
    color: var(--danger-color); /* 진한 빨간색 텍스트 */
    font-weight: 700;
    padding: 2px 6px;
    border-radius: 4px;
}

/* ===== 진행 상태 카드 (Step Progress Bar) - Blue Theme (5단계) ===== */
.progress-card {
  background: #fff;
  border: 1px solid var(--border-color);
  border-radius: 14px;
  padding: 20px;
  margin-bottom: 24px;
}
.stepper-wrapper {
  display: flex;
  justify-content: space-between;
  align-items: center;
  position: relative;
  padding: 0 6%;
  margin: 6px 0 2px;
}
.stepper-wrapper::before {
  content: '';
  position: absolute;
  top: 50%;
  left: 6%;
  right: 6%;
  height: 8px;
  border-radius: 8px;
  background-color: #dbe4ff; /* 연파랑 */
  z-index: 1;
  transform: translateY(-50%);
}
.stepper-item { position: relative; z-index: 2; text-align: center; flex: 1; }
.step-counter {
  width: 36px; height: 36px; border-radius: 50%;
  background-color: #b6ccff; color: #fff; font-weight: 700;
  margin: 18px auto 6px; display:flex; align-items:center; justify-content:center;
  transition: background-color .25s ease, box-shadow .25s ease;
}
.step-name { font-size: 13px; color: #334155; }
.stepper-item.completed .step-counter {
  background-color: #5c7cfa; box-shadow: inset 0 0 0 5px rgba(92,124,250,.22);
}
.stepper-item.current .step-counter {
  background-color: var(--primary-color); /* #3f58d4 */
  box-shadow: 0 0 0 4px rgba(63,88,212,.18);
}
.stepper-wrapper .progress-line {
  position: absolute;
  top: 50%;
  left: 6%;
  height: 8px;
  border-radius: 8px;
  background-color: var(--primary-color);
  z-index: 1;
  transform: translateY(-50%);
  width: 0%;
  max-width: 88%;
  transition: width .35s ease;
}


#rejectForm { display: none; }

.judge-wrap {
  display: flex;
  align-items: center;
  gap: 16px;             /* 라디오들 사이 간격 */
  margin: 12px 0 16px;   /* 위/아래 마진 */
}
.judge-wrap input[type="radio"] {
  margin-right: 6px;     /* 아이콘과 텍스트 사이 */
}

/* ==== [추가] 버튼 리뉴얼 ==== */
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

/* ==== [수정] 하단 버튼 바 ==== */
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
  background: #e9ecef;          /* 연회색 배경 */
  color: #343a40;                /* 진회색 텍스트 */
  box-shadow: inset 0 1px 3px rgba(0,0,0,0.15);
}


/* ==== [추가] 반려/부지급 사유 영역 ==== */

/* === RejectForm 레이아웃 컴팩트 (라벨 옆 공백 제거) === */
/* === 반려 폼: 라벨-인풋 간 공백 최소화 & 정렬 안정화 === */
#rejectForm{
  display:block;
  margin-top:10px; padding:10px 12px;
  border:1px solid #d1d9ff; background:#f0f2ff; border-radius:10px;
}

/* 공통 행: 라벨 110px + 인풋 1fr */
#rejectForm .form-row{
  display:grid !important;
  grid-template-columns: 110px 1fr;
  column-gap: 10px;
  row-gap: 0;
  align-items:center;
  margin:8px 0 !important;
}

/* 라벨은 딱 맞게, 줄바꿈 금지 */
#rejectForm label{
  margin:0 !important;
  white-space:nowrap !important;
  font-weight:700; color:#334155;
}

/* 컨트롤 기본 사이즈 */
#rejectForm .form-control{
  width:100%;
  padding:10px 12px !important;
  font-size:14px !important;
  border-radius:10px;
}

/* 셀렉트가 폭을 벌리는 문제 제거 */
#rejectForm select{ min-width:0 !important; }

/* === 상세사유만 라벨 위 / textarea 아래 (스택) === */
#rejectForm .form-row.row-detail{ align-items: start; }
#rejectForm .form-row.row-detail label{ margin:0 !important; }
#rejectForm .form-row.row-detail .form-control{ grid-column: 2; }
#rejectForm .form-row.row-detail textarea.form-control{
  min-height:140px;    /* 필요하면 160~200px로 늘리면 됨 */
  line-height:1.5;
  resize:vertical;
}
#rejectForm .form-row:first-of-type .form-control{
  flex: 0 0 auto !important;
  width: clamp(160px, 26vw, 240px) !important; /* 160~240px 사이로 */
  max-width: 240px !important;
  justify-self: start; /* 왼쪽 정렬 */
}

/* ===== 관리자 수정폼 테이블 공통 스타일 ===== */
.info-table.edit-table th {
  background: #b0baec;           /* 자녀정보(수정)에서 쓰던 파랑톤 */
}

/* 수정폼 테이블은 행 높이를 살짝 컴팩트하게 */
.info-table.edit-table th,
.info-table.edit-table td {
  padding: 8px 10px;             /* 위쪽 보기용 테이블보다 살짝만 줄임 */
}

/* 수정폼 안 인풋 크기 줄이기 */
.info-table.edit-table .form-control {
  padding: 6px 8px !important;
  font-size: 14px;
  height: 32px;
  box-sizing: border-box;
  border: none;
  outline: none;
  background-color: transparent;
}
.file-download-link {
    color: var(--primary-color); /* 테마 색상 적용 */
    font-weight: 500;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 8px; /* 아이콘과 텍스트 간격 */
}
.file-download-link:hover {
    text-decoration: underline;
}
.info-table.reject-table th {
  background: #f1c0c4;; 
}
</style>
</head>
<body>

<jsp:include page="adminheader.jsp" />

<main class="main-container">
<%-- 상태 코드/결과 기반으로 서버에서 단계/진행폭 계산 --%>
<c:set var="status" value="${appDTO.statusCode}" />
<c:set var="payRes" value="${appDTO.paymentResult}" />

<%-- 단계: 1 제출, 2 심사중(1차), 3 승인/반려, 4 심사중(2차), 5 최종지급결정 --%>
<c:set var="currentStep" value="2" />
<c:choose>
  <c:when test="${status == 'ST_20'}"><c:set var="currentStep" value="1"/></c:when>
  <c:when test="${status == 'ST_30'}"><c:set var="currentStep" value="2"/></c:when>
  <c:when test="${status == 'ST_40'}"><c:set var="currentStep" value="4"/></c:when>
  <c:when test="${status == 'ST_60'}"><c:set var="currentStep" value="3"/></c:when>
</c:choose>
<c:if test="${status == 'ST_50'}"><c:set var="currentStep" value="5"/></c:if>

<%-- 진행선 폭 계산 --%>
<c:set var="progressWidth" value="0"/>
<c:choose>
  <c:when test="${currentStep == 1}"><c:set var="progressWidth" value="0"/></c:when>
  <c:when test="${currentStep == 2}"><c:set var="progressWidth" value="25"/></c:when>
  <c:when test="${currentStep == 3}"><c:set var="progressWidth" value="50"/></c:when>
  <c:when test="${currentStep == 4}"><c:set var="progressWidth" value="75"/></c:when>
  <c:when test="${currentStep == 5}"><c:set var="progressWidth" value="100"/></c:when>
</c:choose>

<!-- 진행 상태 카드 (5단계) -->
<div class="progress-card">
  <div class="stepper-wrapper">
    <div class="progress-line" style="width:${progressWidth}%;"></div>

    <div class="stepper-item ${currentStep > 1 ? 'completed' : (currentStep == 1 ? 'current' : '')}">
      <div class="step-counter">1</div><div class="step-name">제출</div>
    </div>
    <div class="stepper-item ${currentStep > 2 ? 'completed' : (currentStep == 2 ? 'current' : '')}">
      <div class="step-counter">2</div><div class="step-name">심사중(1차)</div>
    </div>
    <div class="stepper-item ${currentStep > 3 ? 'completed' : (currentStep == 3 ? 'current' : '')}">
      <div class="step-counter">3</div>
      <div class="step-name">
        <c:choose>
          <c:when test="${status == 'ST_50'}">승인</c:when>
          <c:when test="${status == 'ST_60'}">반려</c:when>
          <c:otherwise>승인/반려</c:otherwise>
        </c:choose>
      </div>
    </div>
    <div class="stepper-item ${currentStep > 4 ? 'completed' : (currentStep == 4 ? 'current' : '')}">
      <div class="step-counter">4</div><div class="step-name">심사중(2차)</div>
    </div>
    <div class="stepper-item ${currentStep > 5 ? 'completed' : (currentStep == 5 ? 'current' : '')}">
      <div class="step-counter">5</div><div class="step-name">최종지급결정</div>
    </div>
  </div>
</div>
<h1>육아휴직 급여 신청서 상세 보기</h1>

<!-- 반려시 -->
<c:if test="${appDTO.statusCode == 'ST_60'}">
  <div class="info-table-container">
    <table class="info-table table-4col reject-table">
      <colgroup>
        <col style="width:15%"><col style="width:85%">
      </colgroup>
      <tbody>
        <tr>
          <th>반려 사유</th>
          <td>
            <c:choose>
              <c:when test="${not empty appDTO.rejectionReasonName}">
                <c:out value="${appDTO.rejectionReasonName}" />
              </c:when>
              <c:otherwise>
                <span class="highlight-warning">미입력</span>
              </c:otherwise>
            </c:choose>
          </td>
        </tr>
        <tr>
          <th>상세 사유</th>
          <td>
            <c:choose>
              <c:when test="${not empty appDTO.rejectComment}">
                <c:out value="${appDTO.rejectComment}" />
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


<!-- 접수정보 -->
<div class="info-table-container">
  <h2 class="section-title">접수정보</h2>
  <table class="info-table table-4col">
    <colgroup>
    <col style="width:15%"><col style="width:35%">
    <col style="width:15%"><col style="width:35%">
  </colgroup>
    <tbody>
      <tr>
        <th class="data-title">접수번호</th>
        <td><c:out value="${appDTO.applicationNumber}" /></td>
        <th class="data-title">민원내용</th>
        <td>육아휴직 급여 신청</td>
      </tr>
      <tr>
        <th class="data-title">신청일</th>
        <td>
          <c:choose>
            <c:when test="${not empty appDTO.submittedDt}">
              <fmt:formatDate value="${appDTO.submittedDt}" pattern="yyyy-MM-dd" />
            </c:when>
            <c:otherwise>미신청</c:otherwise>
          </c:choose>
        </td>
        <th class="data-title">신청인</th>
        <!-- 관리자 전용: applicantName 표시 -->
        <td><c:out value="${appDTO.applicantName}" /></td>
      </tr>
    </tbody>
  </table>
</div>



<!-- 신청인 정보 -->
<div class="info-table-container">
  <h2 class="section-title">신청인 정보 (육아휴직자)</h2>
  <table class="info-table table-4col">
    <colgroup>
    <col style="width:15%"><col style="width:35%">
    <col style="width:15%"><col style="width:35%">
  </colgroup>
    <tbody>
      <tr>
        <th>이름</th>
        <td><c:out value="${appDTO.applicantName}" /></td>
        <th>주민등록번호</th>
        <td>
          <c:if test="${not empty appDTO.applicantResiRegiNumber}">
            ${fn:substring(appDTO.applicantResiRegiNumber,0,6)}-${fn:substring(appDTO.applicantResiRegiNumber,6,13)}
          </c:if>
          <c:if test="${empty appDTO.applicantResiRegiNumber}">
            <span class="highlight-warning">미입력</span>
          </c:if>
        </td>
      </tr>
      <tr>
        <th>휴대전화번호</th>
        <td>
          <c:if test="${not empty appDTO.applicantPhoneNumber}">
            <c:out value="${appDTO.applicantPhoneNumber}" />
          </c:if>
          <c:if test="${empty appDTO.applicantPhoneNumber}">
            <span class="highlight-warning">미입력</span>
          </c:if>
        </td>
        <th>주소</th>
        <td>
          <c:choose>
            <c:when test="${empty appDTO.applicantZipNumber and empty appDTO.applicantAddrBase}">
              <span class="highlight-warning">미입력</span>
            </c:when>
            <c:otherwise>
              <c:if test="${not empty appDTO.applicantZipNumber}">(${appDTO.applicantZipNumber})&nbsp;</c:if>
              <c:out value="${appDTO.applicantAddrBase}" />
              <c:if test="${not empty appDTO.applicantAddrDetail}">&nbsp;<c:out value="${appDTO.applicantAddrDetail}" /></c:if>
            </c:otherwise>
          </c:choose>
        </td>
      </tr>
    </tbody>
  </table>
</div>

<!-- 사업장 정보 -->
<div class="info-table-container">
  <h2 class="section-title">사업장 정보 (회사)</h2>
  <table class="info-table table-4col">
      <colgroup>
    <col style="width:15%"><col style="width:35%">
    <col style="width:15%"><col style="width:35%">
  </colgroup>
    <tbody>

      <tr>
        <th>사업장 이름</th>
        <td>
          <c:if test="${empty appDTO.businessName}">
            <span class="highlight-warning">미입력</span>
          </c:if>
          <c:if test="${not empty appDTO.businessName}">
            <c:out value="${appDTO.businessName}"/>
          </c:if>
        </td>

        <th>인사담당자 연락처</th>
        <td style="white-space:nowrap;">
              <c:out value="${appDTO.responsePhoneNumber}"/>
        </td>
      </tr>

      <tr>
        <th>사업장 등록번호</th>
        <td>
          <c:choose>
            <c:when test="${empty appDTO.businessRegiNumber}">
              <span class="highlight-warning">미입력</span>
            </c:when>
            <c:otherwise>
                  ${appDTO.businessRegiNumber}
            </c:otherwise>
          </c:choose>
        </td>


        <th>사업장 주소</th>
        <td>
          <c:choose>
            <c:when test="${empty appDTO.businessZipNumber and empty appDTO.businessAddrBase}">
              <span class="highlight-warning">미입력</span>
            </c:when>
            <c:otherwise>
              <c:if test="${not empty appDTO.businessZipNumber}">(${appDTO.businessZipNumber})&nbsp;</c:if>
              <c:out value="${appDTO.businessAddrBase}" />
              <c:if test="${not empty appDTO.businessAddrDetail}">&nbsp;<c:out value="${appDTO.businessAddrDetail}" /></c:if>
            </c:otherwise>
          </c:choose>
        </td>
      </tr>
    </tbody>
  </table>
</div>

        <!-- 확인서 담당자 정보 -->
    <div class="info-table-container">
        <h2 class="section-title">확인서 작성자 정보</h2>
		  <table class="info-table table-4col">
		    <colgroup>
		      <col style="width:15%"><col style="width:35%">
		      <col style="width:15%"><col style="width:35%">
		    </colgroup>
		    <tbody>
          <tr>
            <th>성명</th><td>${appDTO.responseName}</td>
            <th>전화번호</th>
            <td>${appDTO.responsePhoneNumber}</td>
          </tr>
        </tbody>
      </table>
    </div>


<!-- [블록 1] 급여 신청 기간 -->
<div class="info-table-container">
  <h2 class="section-title">급여 신청 정보</h2>
  <table class="info-table table-4col">
    <colgroup>
    <col style="width:15%"><col style="width:35%">
    <col style="width:15%"><col style="width:35%">
  </colgroup>
    <tbody>
      <tr>
        <th>급여 신청 기간</th>
        <td colspan="3">
          <fmt:formatDate value="${dto.list[0].startMonthDate}" pattern="yyyy.MM.dd" />
          ~
          <c:choose>
            <c:when test="${not empty dto.list[fn:length(dto.list) - 1].earlyReturnDate}">
              <fmt:formatDate value="${dto.list[fn:length(dto.list) - 1].earlyReturnDate}" pattern="yyyy.MM.dd" />
            </c:when>
            <c:otherwise>
              <fmt:formatDate value="${dto.list[fn:length(dto.list) - 1].endMonthDate}" pattern="yyyy.MM.dd" />
            </c:otherwise>
          </c:choose>
          (<c:out value="${totalDate}" />일)
        </td>
        
      </tr>

      <tr>
        <th>월 소정근로시간</th>
        <td >
          ${appDTO.weeklyHours} 시간
        </td>
        <th>통상임금</th>
        <td>
          <fmt:formatNumber value="${appDTO.regularWage}" pattern="#,###" /> 원
        </td>
      </tr>

    </tbody>
  </table>
</div>





<!-- [블록 2] 급여 신청 내역 -->
<div class="info-table-container">
  <h2 class="section-title">급여 신청 내역</h2>
  <table class="info-table table-4col">
    <thead>
      <tr>
        <th style="text-align:center;">시작일</th>
        <th style="text-align:center;">종료일</th>
        <th style="text-align:center;">사업장 지급액</th>
        <th style="text-align:center;">정부 지급액</th>
        <th style="text-align:center;">총 지급액</th>
      </tr>
    </thead>
    <tbody>
      <c:set var="totalAmount" value="${0}" />

      <c:forEach var="item" items="${dto.list}" varStatus="status">
        <tr>
          <td style="text-align:center;">
            <fmt:formatDate value="${item.startMonthDate}" pattern="yyyy.MM.dd"/>
          </td>

          <td style="text-align:center;">
            <c:choose>
              <c:when test="${not empty item.earlyReturnDate}">
                <fmt:formatDate value="${item.earlyReturnDate}" pattern="yyyy.MM.dd"/>
              </c:when>
              <c:otherwise>
                <fmt:formatDate value="${item.endMonthDate}" pattern="yyyy.MM.dd"/>
              </c:otherwise>
            </c:choose>
          </td>

          <td style="text-align:center;">
            <fmt:formatNumber value="${item.companyPayment}" type="number" pattern="#,###" />원
          </td>

          <td style="text-align:center;">
            <c:choose>
              <c:when test="${not empty item.govPaymentUpdate}">
                <fmt:formatNumber value="${item.govPaymentUpdate}" type="number" pattern="#,###" />원
              </c:when>
              <c:otherwise>
                <fmt:formatNumber value="${item.govPayment}" type="number" pattern="#,###" />원
              </c:otherwise>
            </c:choose>
          </td>

          <td style="text-align:center;">
            <fmt:formatNumber
              value="${item.companyPayment + (not empty item.govPaymentUpdate ? item.govPaymentUpdate : item.govPayment)}"
              type="number" pattern="#,###" />원
          </td>
        </tr>

        <c:set var="totalAmount"
               value="${totalAmount + item.companyPayment + (not empty item.govPaymentUpdate ? item.govPaymentUpdate : item.govPayment)}" />
      </c:forEach>

      <c:if test="${not empty dto.list}">
        <tr style="background-color: var(--light-gray-color);">
          <td colspan="2" style="text-align:center;">
            <fmt:formatDate value="${dto.list[0].startMonthDate}" pattern="yyyy.MM.dd" />
            -
            <c:choose>
              <c:when test="${not empty dto.list[fn:length(dto.list) - 1].earlyReturnDate}">
                <fmt:formatDate value="${dto.list[fn:length(dto.list) - 1].earlyReturnDate}" pattern="yyyy.MM.dd" />
              </c:when>
              <c:otherwise>
                <fmt:formatDate value="${dto.list[fn:length(dto.list) - 1].endMonthDate}" pattern="yyyy.MM.dd" />
              </c:otherwise>
            </c:choose>
            (<c:out value="${totalDate}" />일)
          </td>

          <td colspan="2" style="text-align: center; font-weight: 700; color: var(--dark-gray-color);">
            합계 신청금액
          </td>

          <td style="text-align: center; font-weight: 700; font-size: 1.05em; color: var(--primary-color);">
            <fmt:formatNumber value="${totalAmount}" type="number" pattern="#,###" />원
          </td>
        </tr>
      </c:if>

      <%-- 내역 없음 --%>
      <c:if test="${empty dto.list}">
        <tr>
          <td colspan="5" style="text-align: center; color: #888;">단위기간 내역이 없습니다.</td>
        </tr>
      </c:if>
    </tbody>
  </table>
</div>
<!-- 자녀 정보 -->
<div class="info-table-container">
  <h2 class="section-title">자녀 정보 (육아 대상)</h2>

  <!-- 원본 데이터 표시 테이블 -->
  <table class="info-table table-4col">
    <colgroup>
    <col style="width:15%"><col style="width:35%">
    <col style="width:15%"><col style="width:35%">
  </colgroup>
    <tbody>
      <tr>
        <th>자녀 이름</th>
        <td><c:out value="${appDTO.childName}" /></td>
        <th>출산(예정)일</th>
        <td>
          <fmt:formatDate value="${appDTO.childBirthDate}" pattern="yyyy.MM.dd" />
        </td>
      </tr>
      <tr>
        <th>주민등록번호</th>
        <td colspan="3">
          <c:if test="${not empty appDTO.childResiRegiNumber}">
            ${fn:substring(appDTO.childResiRegiNumber, 0, 6)}-${fn:substring(appDTO.childResiRegiNumber, 6,13)}
          </c:if>
        </td>
      </tr>
    </tbody>
  </table>
  </div>

<br>
<!-- 계좌정보 -->
<div class="info-table-container">
  <h2 class="section-title">급여 입금 계좌정보</h2>
  <table class="info-table table-4col">
    <colgroup>
    <col style="width:15%"><col style="width:35%">
    <col style="width:15%"><col style="width:35%">
  </colgroup>
    <tbody>
      <tr>
        <th>은행</th>
        <td>
          <c:if test="${empty appDTO.bankName}">
            <span class="highlight-warning">미입력</span>
          </c:if>
          <c:if test="${not empty appDTO.bankName}">
            <c:out value="${appDTO.bankName}" />
          </c:if>
        </td>
        <th>계좌번호</th>
        <td>
          <c:if test="${empty appDTO.accountNumber}">
            <span class="highlight-warning">미입력</span>
          </c:if>
          <c:if test="${not empty appDTO.accountNumber}">
            <c:out value="${appDTO.accountNumber}" />
          </c:if>
        </td>
      </tr>
      <tr>
        <th>예금주 이름</th>
        <td colspan="3"><c:out value="${appDTO.applicantName}" /></td>
      </tr>
    </tbody>
  </table>
</div>

<!-- 센터 정보 (고정 예시) -->
<div class="info-table-container">
  <h2 class="section-title">접수 처리 센터 정보</h2>
  <table class="info-table table-4col">
    <colgroup>
    <col style="width:15%"><col style="width:35%">
    <col style="width:15%"><col style="width:35%">
  </colgroup>
    <tbody>
      <tr>
        <th>관할센터</th>
        <td>서울 고용 복지 플러스 센터
          <a href="https://www.work.go.kr/seoul/main.do" class="detail-btn">자세히 보기</a>
        </td>
        <th>대표전화</th>
        <td>02-2004-7301</td>
      </tr>
      <tr>
        <th>주소</th>
        <td colspan="3">서울 중구 삼일대로363 1층 (장교동)</td>
      </tr>
    </tbody>
  </table>
</div>

<!-- 행정정보 공동이용 동의 -->
<div class="info-table-container">
  <h2 class="section-title">행정정보 공동이용 동의</h2>
  <table class="info-table table-4col">
    <colgroup>
    <col style="width:15%"><col style="width:35%">
    <col style="width:15%"><col style="width:35%">
  </colgroup>
    <tbody>
      <tr>
        <th>동의 여부</th>
        <td colspan="3">
          <c:choose>
            <c:when test="${appDTO.govInfoAgree == 'Y'}">예</c:when>
            <c:when test="${appDTO.govInfoAgree == 'N'}"><span class="highlight-warning">아니요</span></c:when>
            <c:otherwise>미선택</c:otherwise>
          </c:choose>
        </td>
      </tr>
    </tbody>
  </table>
</div>

<!-- 첨부파일 -->
<div class="info-table-container">
  <h2 class="section-title">첨부파일</h2>
  <table class="info-table table-4col">
      <colgroup>
    <col style="width:15%">
  </colgroup>
    <tbody>
      <!-- 첨부파일이 없을 때 -->
      <c:if test="${empty files}">
        <tr>
          <th style="width: 150px; text-align:center;">파일 목록</th>
          <td>첨부된 파일이 없습니다.</td>
        </tr>
      </c:if>

      <!-- 첨부파일이 있을 때 -->
      <c:if test="${not empty files}">
        <c:forEach var="file" items="${files}" varStatus="status">
          <tr>
            <c:if test="${status.first}">
              <th rowspan="${fn:length(files)}"
                  style="width: 150px; text-align:center;">파일 목록</th>
            </c:if>

            <td>
              <a href="${pageContext.request.contextPath}/file/download?fileId=${file.fileId}&seq=${file.sequence}"
                 class="file-download-link">
                  <span>
                  <c:choose>
                    <c:when test="${file.fileType == 'WAGE_PROOF'}">
                      (통상임금 증명자료)
                    </c:when>
                    <c:when test="${file.fileType == 'PAYMENT_FROM_EMPLOYER'}">
                      (사업주로부터 금품을 지급받은 자료)
                    </c:when>
                    <c:when test="${file.fileType == 'OTHER'}">
                      (기타 자료)
                    </c:when>
                    <c:when test="${file.fileType == 'ELIGIBILITY_PROOF'}">
                      (배우자/한부모/장애아동 확인 자료)
                    </c:when>
                    <c:otherwise>
                      (기타 자료)
                    </c:otherwise>
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



		<c:set var="ctx" value="${pageContext.request.contextPath}" />

		<!-- 관리자 임시수정 폼 -->
		<form id="adminUpdateForm" method="post"
			action="${ctx}/admin/user/update" style="margin-top: 18px;">

			<!-- 필수: 신청번호 -->
			<input type="hidden" name="applicationNumber"
				value="${appDTO.applicationNumber}" />

			<!-- 계좌정보(업데이트) -->
			<div class="info-table-container">
				<h2 class="section-title">급여 입금 계좌정보 (수정)</h2>
				<table class="info-table table-4col edit-table">
				  <colgroup>
				    <col style="width:15%"><col style="width:35%">
				    <col style="width:15%"><col style="width:35%">
				  </colgroup>
					<tbody>
						<tr>
							<th>은행</th>
							<td>
							<select name="updBankCode" id="updBankCode" class="form-control">
							  <option value="">(없음)</option>
							  <c:forEach var="b" items="${bankCodes}">
							    <option value="${b.code}"
							      <c:if test="${b.code == appDTO.updBankCode}">selected</c:if>>
							      ${b.name}
							    </option>
							  </c:forEach>
							</select>
								</td>
							<th>계좌번호</th>
							<td>
							<input type="text"
								name="updAccountNumber" class="form-control"
								value="${fn:escapeXml(appDTO.updAccountNumber)}"
								placeholder="계좌번호(숫자/하이픈)" />
							</td>
						</tr>
					</tbody>
				</table>
			</div>

			<!-- 자녀 정보(업데이트) -->
			<div class="info-table-container">
				<h2 class="section-title">자녀 정보 (수정)</h2>
				<table class="info-table table-4col edit-table">
				  <colgroup>
				    <col style="width:15%"><col style="width:35%">
				    <col style="width:15%"><col style="width:35%">
				  </colgroup>
					<tbody>
						<tr>
							<th style="background: #b0baec;">자녀 이름</th>
							<td><input type="text" name="updChildName"
								class="form-control"
								value="${fn:escapeXml(appDTO.updChildName)}" placeholder="자녀 이름" />
							</td>
							<th style="background: #b0baec;">출산(예정)일</th>
							<td><fmt:formatDate value="${appDTO.updChildBirthDate}"
									pattern="yyyy-MM-dd" var="updBirthStr" /> <input type="date"
								name="updChildBirthDate" class="form-control"
								value="${updBirthStr}" /></td>
						</tr>
						<tr>
							<th style="background: #b0baec;">주민등록번호</th>
							<td colspan="3"><input type="text"
								name="updChildResiRegiNumber" class="form-control"
								maxlength="13"
								value="${fn:escapeXml(appDTO.updChildResiRegiNumber)}"
								placeholder="숫자만 입력 (예: 0101011234567)" /></td>
						</tr>
					</tbody>
				</table>
			</div>
		</form>


		<!-- 하단 관리자 버튼 -->
<div class="action-bar">
  <c:choose>
    <%-- 완료된 상태: 목록 버튼만 우측에 표시 --%>
    <c:when test="${appDTO.statusCode == 'ST_40' or appDTO.statusCode == 'ST_50' or appDTO.statusCode == 'ST_60' or appDTO.paymentResult == 'Y'}">
  	<div class="right-slot-completed">
    <a href="${pageContext.request.contextPath}/admin/list"
       class="btn btn-outline btn-lg">목록으로 돌아가기</a>
    <a href="${pageContext.request.contextPath}/admin/judge/detail/${appDTO.confirmNumber}"
         class="btn btn-primary btn-lg"> 확인서 보러가기</a>
  </div>
</c:when>
    
    <%-- 진행중 상태: 2단 레이아웃 (세그먼트 / 버튼) --%>
    <c:otherwise>
      <div class="segments" id="judgeSegments">
        <button type="button" class="segment-btn" data-choice="approve" aria-pressed="true">접수</button>
        <button type="button" class="segment-btn" data-choice="reject"  aria-pressed="false">반려</button>
      </div>

<div id="rejectForm">
  <!-- 1. 첫째 줄: 반려 사유 -->
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
	  <!-- 왼쪽: 목록 버튼 -->
	  <a href="${pageContext.request.contextPath}/admin/list"
       class="btn btn-outline btn-lg">목록으로 돌아가기</a>
       <a href="${pageContext.request.contextPath}/admin/judge/detail/${appDTO.confirmNumber}"
         class="btn btn-primary btn-lg"> 확인서 보러가기</a>
	  
	
	  <!-- 오른쪽: 저장 + 확인 묶음 -->
	  <div class="right-buttons">
	    <button type="button" id="saveBtn" class="btn btn-outline btn-lg">수정사항 저장</button>
	    <button type="button" id="confirmBtn" class="btn btn-primary btn-lg">확인</button>
	  </div>
	</div>
    </c:otherwise>
  </c:choose>
</div>

</main>

<input type="hidden" id="applicationNumber" value="${appDTO.applicationNumber}" />
<input type="hidden" id="targetUserId" value="${dto.userId}" />

	<footer class="footer">
		<p>&copy; 2025 육아휴직 서비스. All Rights Reserved.</p>
	</footer>

<!-- 관리자 전용: 항상 실행 -->
<script>
document.addEventListener("DOMContentLoaded", function () {
  const ctx = '${pageContext.request.contextPath}';

  // ===== 엘리먼트 =====
  const segmentsWrap      = document.getElementById('judgeSegments');
  const segmentBtns       = segmentsWrap ? segmentsWrap.querySelectorAll('.segment-btn') : [];
  const rejectForm        = document.getElementById('rejectForm');
  const reasonSelect      = document.getElementById('reasonSelect');   // select로 사유 선택
  const rejectCommentEl   = document.getElementById('rejectComment');
  const confirmBtn        = document.getElementById('confirmBtn');
  const saveBtn           = document.getElementById('saveBtn');
  const adminUpdateForm   = document.getElementById('adminUpdateForm');

  const applicationNumber = Number(document.getElementById('applicationNumber')?.value);
  const userId            = document.getElementById('targetUserId')?.value;

  // ===== 상태 =====
  let currentChoice = 'approve'; // 기본: 접수
  let reasonsLoaded = false;

  // ===== 세그먼트 토글 핸들러 =====
  function setChoice(choice) {
    currentChoice = choice;
    segmentBtns.forEach(btn => {
      const active = btn.dataset.choice === choice;
      btn.setAttribute('aria-pressed', active ? 'true' : 'false');
    });

    if (choice === 'reject') {
      rejectForm.style.display = 'block';
      // 사유 옵션 1회 로딩
      if (!reasonsLoaded) {
        fetch(ctx + '/codes/reject', { method: 'GET', headers: { 'Accept': 'application/json' } })
          .then(res => res.json())
          .then(list => {
            // 기본 옵션
            reasonSelect.innerHTML = '<option value="">사유를 선택하세요</option>';

            if (Array.isArray(list) && list.length > 0) {
              list.forEach(({ code, name }) => {
                const opt = document.createElement('option');
                opt.value = code;
                opt.textContent = name || code;
                reasonSelect.appendChild(opt);
              });
            } else {
              // 없을 때 기본 '기타'라도 제공
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

  // 초기 상태 동기화 (기본 접수)
  setChoice('approve');

  // 세그먼트 클릭 바인딩
  segmentBtns.forEach(btn => {
    btn.addEventListener('click', () => setChoice(btn.dataset.choice));
  });

  // ===== 확인(접수/반려) 처리 =====
  if (confirmBtn) {
    confirmBtn.addEventListener('click', function () {
      if (!applicationNumber) { alert('신청번호를 확인할 수 없습니다.'); return; }

      const approveUrl = ctx + '/admin/user/approve';
      const rejectUrl  = ctx + '/admin/user/reject';

      if (currentChoice === 'approve') {
        if (!confirm('접수(승인 진행)로 확정하시겠습니까?')) return;

        fetch(approveUrl, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ applicationNumber })
        })
        .then(res => res.json())
        .then(data => {
          alert(data.message || '처리가 완료되었습니다.');
          if (data.redirectUrl) {
            location.href = data.redirectUrl.startsWith('/') ? (ctx + data.redirectUrl) : data.redirectUrl;
          }
        })
        .catch(() => alert('접수 처리 중 오류가 발생했습니다.'));
        return;
      }

      // === 반려 ===
      const code = reasonSelect?.value || '';
      const comment = (rejectCommentEl?.value || '').trim();

      if (!code) { alert('반려 사유를 선택하세요.'); return; }
      if ((code === 'RJ_99' || code === 'ETC') && !comment) {
        alert('기타 선택 시 상세 사유를 입력하세요.');
        return;
      }
      if (!confirm('반려 처리하시겠습니까?')) return;

      fetch(rejectUrl, {
    	  method: 'POST',
    	  headers: { 'Content-Type': 'application/json' },
    	  body: JSON.stringify({
    	    applicationNumber: applicationNumber,
    	    rejectionReasonCode: code,
    	    rejectComment: comment
    	  })
    	})
      .then(res => res.json())
      .then(data => {
        alert(data.message || '반려 처리가 완료되었습니다.');

        // 푸시 (성공/실패 상관없이 메인 흐름 영향 X)
        if (userId) {
          $.ajax({
            url: ctx + '/push/' + userId,
            type: 'GET',
            success: function (pushMsg) { console.log('Push notification result:', pushMsg); },
            error:   function (xhr, status, err) { console.error('Push notification failed:', err, status, xhr); }
          });
        } else {
          console.warn('푸시를 보낼 userId를 찾을 수 없습니다.');
        }

        if (data.redirectUrl) {
          location.href = data.redirectUrl.startsWith('/') ? (ctx + data.redirectUrl) : data.redirectUrl;
        }
      })
      .catch(() => alert('반려 처리 중 오류가 발생했습니다.'));
    });
  }

  // ===== 저장 버튼 → 폼 제출 =====
  if (saveBtn && adminUpdateForm) {
    saveBtn.addEventListener('click', function () {
      adminUpdateForm.submit();
    });
  }
});
</script>


<div id="flash-error" style="display:none;"><c:out value="${error}"/></div>
<script>
 (function () {
   var err = document.getElementById('flash-error')?.textContent.trim();
   if (err) alert(err);
 })();
</script>
</body>
</html>
