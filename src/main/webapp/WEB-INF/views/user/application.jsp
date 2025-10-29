<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<%-- [수정] applicationDetailDTO 존재 여부에 따라 타이틀 변경 --%>
<c:choose>
    <c:when test="${not empty applicationDetailDTO}">
        <title>육아휴직 급여 신청 수정</title>
    </c:when>
    <c:otherwise>
        <title>육아휴직 급여 신청</title>
    </c:otherwise>
</c:choose>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/global.css">
<style>
    /* ... (기존 CSS 스타일은 변경 없음) ... */
    :root {
     --primary-color: #3f58d4;
     --primary-light-color: #f0f2ff;
     --white-color: #ffffff;
     --light-gray-color: #f8f9fa;
     --gray-color: #868e96;
     --dark-gray-color: #343a40;
     --border-color: #dee2e6;
     --success-color: #28a745;
     --warning-bg-color: #fff3cd;
     --warning-border-color: #ffeeba;
     --warning-text-color: #856404;
     --shadow-sm: 0 1px 3px rgba(0,0,0,0.05);
     --shadow-md: 0 4px 8px rgba(0,0,0,0.07);
    }
    * { margin: 0; padding: 0; box-sizing: border-box; }
    html { height: 100%; }
    body {
     display: flex; flex-direction: column; min-height: 100vh;
     font-family: 'Noto Sans KR', sans-serif; background-color: var(--light-gray-color);
     color: var(--dark-gray-color);
    }
    a { text-decoration: none; color: inherit; }
    .header, .footer {
     background-color: var(--white-color); padding: 15px 40px; border-bottom: 1px solid var(--border-color); box-shadow: var(--shadow-sm);
    }
    .footer { border-top: 1px solid var(--border-color); border-bottom: none; text-align: center; padding: 20px 0; }
    .header { display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; z-index: 10; }
    .header nav { display: flex; align-items: center; gap: 15px; }
    .header .welcome-msg { font-size: 16px; }
    .main-container {
     flex-grow: 1;
     width: 100%;
     max-width: 1100px !important; 
     margin: 20px auto !important; 
     padding: 0 20px !important;
     background: none !important;
     box-shadow: none !important;
     border: none !important;
    }
    .content-wrapper {
        background-color: var(--white-color);
        border-radius: 12px;
        box-shadow: var(--shadow-md);
        padding: 40px; 
        margin: 0 auto; 
    }
    h1 { text-align: center; margin-bottom: 30px; font-size: 28px; }
    h2 {
     color: var(--primary-color); border-bottom: 2px solid var(--primary-light-color);
     padding-bottom: 10px; margin-bottom: 25px; font-size: 20px;
    }
    .form-section { margin-bottom: 40px; }
    .form-group { display: flex; align-items: center; margin-bottom: 18px; gap: 20px; }
    .form-group label.field-title { width: 160px; font-weight: 500; color: #555; flex-shrink: 0; }
    .form-group .input-field { flex-grow: 1; }
    input[type="text"], input[type="date"], input[type="number"],input[type="password"], select {
     width: 100%; padding: 10px; border: 1px solid var(--border-color);
     border-radius: 6px; transition: all 0.2s ease-in-out;
    }
    input:focus, select:focus {
     border-color: var(--primary-color); box-shadow: 0 0 0 3px rgba(63, 88, 212, 0.15); outline: none;
    }
    input[readonly], input.readonly-like, input:disabled { background-color: var(--light-gray-color); cursor: not-allowed; }
    .btn {
     display: inline-block; padding: 10px 20px; font-size: 15px; font-weight: 500;
     border-radius: 8px; border: 1px solid var(--border-color); cursor: pointer;
     transition: all 0.2s ease-in-out; text-align: center;
    }
    .btn-primary { background-color: var(--primary-color); color: var(--white-color); border-color: var(--primary-color); }
    .btn-primary:hover { background-color: #364ab1; box-shadow: var(--shadow-md); transform: translateY(-2px); }
    .btn-secondary { background-color: var(--white-color); color: var(--gray-color); border-color: var(--border-color); }
    .btn-secondary:hover { background-color: var(--light-gray-color); color: var(--dark-gray-color); border-color: #ccc; }
    .btn-logout { background-color: var(--dark-gray-color); color: var(--white-color); border: none; }
    .btn-logout:hover { background-color: #555; }
    .submit-button {
     padding: 12px 30px;
     font-size: 1.1em;
     background-color: var(--primary-color);
     border-color: var(--primary-color);
     color: white;
    }
    .submit-button:hover {
     background-color: #364ab1;
     border-color: #364ab1;
     transform: translateY(-2px);
    }
    .submit-button-container { text-align: center; margin-top: 30px; }
    .radio-group, .checkbox-group { display: flex; align-items: center; gap: 15px; }
    .radio-group input[type="radio"], .checkbox-group input[type="checkbox"] { margin-right: -10px; }
    .info-box {
     background-color: var(--primary-light-color); border: 1px solid #d1d9ff; padding: 15px;
     margin-top: 10px; border-radius: 6px; font-size: 14px;
    }
    .info-box p { margin: 5px 0; }
    .notice-box {
     border: 1px solid var(--warning-border-color); background-color: var(--warning-bg-color);
     color: var(--warning-text-color); padding: 20px; margin-top: 20px;
     border-radius: 8px; display: flex; align-items: flex-start;
    }
    .notice-icon { font-size: 1.8em; margin-right: 15px; margin-top: -2px; }
    .notice-box h3 { margin: 0 0 8px 0; }
    #period-input-section { display: block; }
    .dynamic-form-container { margin-top: 10px; border-top: 1px solid var(--border-color); padding-top: 10px; }
    .dynamic-form-row {
     display: flex; align-items: center; gap: 15px; padding: 10px;
     border-radius: 6px; margin-bottom: 10px;
    }
    .dynamic-form-row:nth-child(odd) { background-color: var(--primary-light-color); }
    .date-range-display { font-weight: 500; flex-basis: 300px; flex-shrink: 0; text-align: center; }
    .payment-input-field{
     flex-grow: 1;
     display: flex;
     justify-content: flex-end;
    }
    button[name="action"][value="submit"]:disabled,
    button[name="action"][value="update"]:disabled {
     opacity: .6; cursor: not-allowed;
    }
    .error {color: red; font-size: 14px;}
    .modal-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.6);
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 1000;
    }
    .modal-content {
        background-color: #fff;
        padding: 25px;
        border-radius: 12px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        width: 90%;
        max-width: 1000px;
        max-height: 80vh;
        display: flex;
        flex-direction: column;
    }
    .modal-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 1px solid var(--border-color);
        padding-bottom: 15px;
        margin-bottom: 20px;
    }
    .modal-header h2 {
        margin: 0;
        font-size: 22px;
        color: var(--dark-gray-color);
        border: none;
    }
    .close-modal-btn {
        background: none;
        border: none;
        font-size: 28px;
        cursor: pointer;
        color: var(--gray-color);
        line-height: 1;
    }
    .modal-body {
        overflow-y: auto;
    }
    .center-table {
        width: 100%;
        border-collapse: collapse;
    }
    .center-table th, .center-table td {
        border: 1px solid var(--border-color);
        padding: 12px;
        text-align: left;
    }
    .center-table th {
        background-color: var(--light-gray-color);
        font-weight: 500;
    }
    .center-table tr:nth-child(even) {
        background-color: #fcfcfd;
    }
    .center-table td {
        vertical-align: middle;
    }
    .center-table .btn-select-center {
        padding: 6px 12px;
        font-size: 14px;
    }
    .center-display-box {
        background-color: var(--white-color);
        border: 2px dashed var(--border-color);
        padding: 20px;
        min-height: 100px;
        transition: all 0.3s ease;
        text-align: center;
        display: flex;
        justify-content: center;
        align-items: center;
    }
    .center-display-box:not(.filled)::before {
        content: '센터 찾기 버튼을 클릭하여 관할 센터를 선택하세요.';
        font-style: italic;
        color: var(--gray-color);
        font-size: 15px;
    }
    .center-display-box:not(.filled) p {
        display: none; 
    }
    .center-display-box.filled {
        background-color: var(--primary-light-color);
        border-style: solid;
        border-color: #d1d9ff;
        text-align: left; 
        display: block;
    }
    .center-display-box.filled p {
        display: block; 
    }
</style>
</head>
<body>
<c:if test="${empty applicationDTO.list}">
    <script>
        alert('신청 가능한 급여가 없습니다.');
        window.location.href="${pageContext.request.contextPath}/user/main"
    </script>
</c:if>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

    <%@ include file="header.jsp" %>

    <main class="main-container">
        <div class="content-wrapper"> 
        
             <c:choose>
                 <c:when test="${not empty applicationDetailDTO}">
                      <h1>육아휴직 급여 신청 수정</h1>
                 </c:when>
                 <c:otherwise>
                      <h1>육아휴직 급여 신청</h1>
                 </c:otherwise>
             </c:choose>

             <c:choose>
                 <c:when test="${not empty applicationDetailDTO}">
                      <form id="main-form" action="${pageContext.request.contextPath}/user/update" method="post">
                      <input type="hidden" name="applicationNumber" value="${applicationDetailDTO.applicationNumber}">
                      <input type="hidden" name="confirmNumber" value="${applicationDetailDTO.confirmNumber}">
                 <c:if test="${not empty termIdList}">
                      <%-- 1. joinedTermIdList 라는 변수를 빈 문자열로 생성 --%>
                      <c:set var="joinedTermIdList" value="" />
                      
                      <%-- 2. termIdList를 반복하면서, 
                            varStatus(status)를 이용해 마지막 항목이 아닐 때만 콤마(,)를 붙임 --%>
                      <c:forEach var="termId" items="${termIdList}" varStatus="status">
                           <c:set var="joinedTermIdList" value="${joinedTermIdList}${termId}" />
                           <c:if test="${not status.last}">
                                <c:set var="joinedTermIdList" value="${joinedTermIdList}," />
                           </c:if>
                      </c:forEach>
                      
                      <%-- 3.
                           위에서 완성된 문자열(예: "55,56,57,58")을 hidden input의 값으로 사용 --%>
                      <input type="hidden" name="termIdList" value="${joinedTermIdList}">
                 </c:if>
                 </c:when>
                 <c:otherwise>
                      <form id="main-form" action="${pageContext.request.contextPath}/user/apply" method="post">
                      <input type="hidden" name="confirmNumber" value="${confirmNumber}">
                 </c:otherwise>
             </c:choose>
             <sec:csrfInput/>
                 <div class="form-section">
                      <h2>신청인 정보</h2>
                      <div class="form-group">
                           <label class="field-title">이름</label>
                           <div class="input-field"><input type="text" value="${applicationDTO.name}" name="name" readonly></div>
                      </div>
                      <div class="form-group">
                           <label class="field-title">주민등록번호</label>
                           <div class="input-field">
                                <input type="text" value="${applicationDTO.registrationNumber}" name="registrationNumber" readonly>
                           </div>
                      </div>
                      <div class="form-group">
                           <label class="field-title">주소</label>
                           <div class="input-field"><input type="text" value="[${applicationDTO.zipNumber}] ${applicationDTO.addressBase} ${applicationDTO.addressDetail}" disabled></div>
                      </div>
                      <div class="form-group">
                           <label class="field-title">휴대전화번호</label>
                           <div class="input-field"><input type="text" value="${applicationDTO.phoneNumber}" disabled></div>
                      </div>
                 </div>

                 <div class="form-section">
                      <h2>사업장 정보</h2>
                      <div class="form-group">
                           <label class="field-title">사업장 동의여부</label>
                           <div class="input-field radio-group">
                                <input type="radio" id="consent-yes" name="businessAgree" value="Y" checked disabled >
                                <label for="consent-yes">예</label>
                                <input type="radio" id="consent-no" name="businessAgree" value="N" disabled>
                                <label for="consent-no">아니요</label>
                           </div>
                      </div>
                      <div class="form-group">
                           <label class="field-title">사업장 이름</label>
                           <div class="input-field">
                                <input type="text" value="${applicationDTO.companyName}" disabled>
                           </div>
                      </div>
                      <div class="form-group">
                           <label class="field-title">사업장 등록번호</label>
                           <div class="input-field">
                                <input type="text" id="businessRegiNumber"
                                      value="${applicationDTO.buisinessRegiNumber}" inputmode="numeric" autocomplete="off" disabled/>
                                  </div>
                      </div>
                      <div class="form-group">
                           <label class="field-title">사업장 주소</label>
                           <div class="input-field">
                                <div class="addr-row">
                                     <input type="text" id="biz-postcode"
                                            placeholder="우편번호" value="${applicationDTO.companyZipNumber}"
                                            disabled>
                                </div>
                                <input type="text" id="biz-base"
                                      placeholder="기본주소" value="${applicationDTO.companyAddressBase}"
                                      readonly style="margin-top: 8px;" disabled> 
                                <input type="text" id="biz-detail" value="${applicationDTO.companyAddressDetail}" disabled>
                           </div>
                      </div>
                 </div>
                 
                 <%-- [★★ 요청 1, 2 반영: 조기복직 데이터 미리 스캔 ★★] --%>
                 <%-- 
                     요청: term.earlyReturnDate와 term.govPaymentUpdate가 둘 다 있는 term을 찾습니다.
                     - 이 루프는 화면에 아무것도 그리지 않고, 'earlyReturnTerm' 변수만 설정합니다.
                     - 여러 term이 조건을 만족하면, 가장 마지막 term이 'earlyReturnTerm'에 저장됩니다.
                 --%>
                 <c:set var="earlyReturnTerm" value="${null}" />
                 <c:if test="${not empty applicationDTO.list}">
                     <c:forEach var="term" items="${applicationDTO.list}">
                         <c:if test="${not empty term.earlyReturnDate and not empty term.govPaymentUpdate}">
                             <c:set var="earlyReturnTerm" value="${term}" />
                         </c:if>
                     </c:forEach>
                 </c:if>
                 <%-- [★★ 스캔 완료 ★★] --%>

                 <div class="form-section">
                      <h2>급여 신청 기간</h2>
                      <p style="color: #888; margin-top: -15px; margin-bottom: 20px;">※
                           사업주로부터 부여받은 총 휴직 기간 중 급여를 지급받으려는 기간을 입력해 주세요.</p>

                      <div class="form-group">
                           <label class="field-title" for="start-date">① 육아휴직 시작일</label>
                           <div class="input-field">
                                <input type="date" id="start-date" value="${applicationDTO.startDate}" name="startDate" readonly>
                           </div>
                      </div>

                      <div id="period-input-section">
                           <div class="form-group">
                                <label class="field-title" for="end-date">② 육아휴직 종료일</label>
                                <div class="input-field"
                                    style="display: flex; align-items: center; gap: 10px;">
                                    
                                    <%-- [★★ 요청 2 반영: 종료일 값 및 readonly 상태 설정 ★★] --%>
                                    <%-- 'earlyReturnTerm'이 있으면(위에서 스캔함) 해당 날짜를, 없으면 DTO의 기본 종료일을 사용 --%>
                                    <c:set var="endDateValue" value="${applicationDTO.endDate}" />
                                    <c:if test="${not empty earlyReturnTerm}">
                                        <fmt:formatDate value="${earlyReturnTerm.earlyReturnDate}" pattern="yyyy-MM-dd" var="endDateValue" />
                                    </c:if>
                                    
                                    <input type="date" id="end-date" value="${endDateValue}" name="endDate" 
                                           ${not empty earlyReturnTerm ? '' : 'readonly'} <%-- readonly 속성 동적 제어 --%>
                                           style="width: auto; flex-grow: 1;">
                                </div>
                           </div>
                           
                           <div class="form-group" style="margin-top: 5px; margin-bottom: 5px;">
                                <label class="field-title" style="width: 160px;"></label> <div class="input-field">
                                 <div class="checkbox-group">
                                     <%-- [★★ 요청 1 반영: 체크박스 상태 설정 ★★] --%>
                                     <input type="checkbox" name="early" id="early-return-chk" style="transform: scale(1.2);"
                                            ${not empty earlyReturnTerm ? 'checked' : ''}> <%-- checked 속성 동적 제어 --%>
                                     <label for="early-return-chk" style="font-weight: 500; color: var(--primary-color);">조기복직(종료일 변경)</label>
                                 </div>
                                </div>
                           </div>
                           
                           <%-- [★★ 요청 1, 2 반영: 안내문구 표시 상태 설정 ★★] --%>
                           <div class="form-group" id="early-return-notice" 
                                style="display: ${not empty earlyReturnTerm ? 'flex' : 'none'}; margin-top:0;"> <%-- display 속성 동적 제어 --%>
                                 <label class="field-title" style="width: 160px;"></label> <div class="input-field" style="color: #555; font-size: 14px;">
                                  ※ 조기복직일이 2025.12.15 인 경우 급여 신청기간은 2025.12.14 까지입니다.
                                 </div>
                           </div>
                           
                      </div>
                      
<div class="dynamic-form-row" style="background-color: transparent; border-bottom: 2px solid var(--border-color); font-weight: 500; margin-bottom: 0;">
    <div style="padding: 0 15px; visibility: hidden;"> <input type="checkbox" style="transform: scale(1.3);" disabled>
    </div>
    <div class="date-range-display">
         <span>신청기간</span>
    </div>
    <div class="payment-input-field">
         <span>정부지급액(원)</span>
    </div>
    <div class="payment-input-field" style="margin-left:auto;">
         <span>사업장 지급액(원)</span>
    </div>
</div>


<div id="dynamic-forms-container" class="dynamic-form-container">
    <c:forEach var="term" items="${applicationDTO.list}" varStatus="status">

         <%-- [★★ 1. 추가된 로직 ★★] termIdList에 현재 term.termId가 있는지 확인 --%>
         <c:set var="isChecked" value="false" />
         <c:if test="${not empty termIdList}">
             <c:forEach var="selectedTermId" items="${termIdList}">
                 <c:if test="${selectedTermId == term.termId}">
                     <c:set var="isChecked" value="true" />
                 </c:if>
             </c:forEach>
         </c:if>
         <%-- [★★ 로직 끝 ★★] --%>

         <%-- (기존 코드) 포맷팅 --%>
         <%-- [★★ 요청 3 반영: 정부지급액 값 설정 ★★] --%>
         <c:choose>
             <c:when test="${not empty term.earlyReturnDate and not empty term.govPaymentUpdate}">
                 <%-- 조건 만족 시: '업데이트'된 금액으로 formattedGovPayment 변수를 설정 --%>
                 <fmt:formatNumber value="${term.govPaymentUpdate}" pattern="#,##0" var="formattedGovPayment" />
             </c:when>
             <c:otherwise>
                 <%-- 조건 불만족 시: '기존' 금액으로 formattedGovPayment 변수를 설정 --%>
                 <fmt:formatNumber value="${term.govPayment}" pattern="#,##0" var="formattedGovPayment" />
             </c:otherwise>
         </c:choose>
         
         <fmt:formatNumber value="${term.companyPayment}" pattern="#,##0" var="formattedCompanyPayment" />
         <fmt:formatDate value="${term.startMonthDate}" pattern="yyyy-MM-dd" var="dataStartDate" />
         <fmt:formatDate value="${term.endMonthDate}" pattern="yyyy-MM-dd" var="dataEndDate" />

         <div class="dynamic-form-row">
             
             <div class="period-checkbox-wrapper" style="padding: 0 15px; display: flex; align-items: center;">
                 <input type="checkbox" 
                      class="period-checkbox" 
                      data-start-date="${dataStartDate}" 
                      data-end-date="${dataEndDate}"
                      data-index="${status.index}"
                      style="transform: scale(1.3);"
                      ${isChecked ? 'checked' : ''}> <%-- [★★ 2. 수정된 부분 ★★] --%>
             </div>

             <%-- (기존 코드) --%>
             <div class="date-range-display">
                 <div>
                     <fmt:formatDate value="${term.startMonthDate}" pattern="yyyy.MM.dd" />
                     ~
                     <fmt:formatDate value="${term.endMonthDate}" pattern="yyyy.MM.dd" />
                 </div>
             </div>
             
             <%-- (기존 코드) DTO 바인딩을 위한 hidden input들 --%>
             <input type="hidden" class="period-start-date-hidden" value="${dataStartDate}">
             <input type="hidden" class="period-end-date-hidden" value="${dataEndDate}">
             <input type="hidden" class="period-term-id" value="${term.termId}"> 

             <%-- (기존 코드) 정부 지급액 --%>
             <div class="payment-input-field">
                 <input type="text" 
                      class="period-gov-payment"
                      value="${formattedGovPayment}" <%-- [★★ 요청 3 반영 완료 ★★] --%>
                      placeholder="해당 기간의 정부지급액(원) 입력" 
                      autocomplete="off" 
                      disabled
                      style="text-align: right;"
                      data-original-gov="${term.govPayment}"> <%-- [★★ 신규 추가 (원본 값 저장) ★★] --%>
             </div>

             <%-- (기존 코드) 사업장 지급액 --%>
             <div class="payment-input-field" style="margin-left:auto;">
                 <input type="text" 
                      class="period-company-payment"
                      value="${formattedCompanyPayment}" 
                      placeholder="해당 기간의 사업장 지급액(원) 입력" 
                      autocomplete="off" 
                      disabled
                      style="text-align: right;"
                      data-original-company="${term.companyPayment}"> <%-- [★★ 신규 추가 (원본 값 저장) ★★] --%>
             </div>
         </div>
    </c:forEach>
</div>


<%-- (합계 표시줄은 변경 없음) --%>
<div class="dynamic-form-row" id="total-sum-row" style="background-color: var(--primary-light-color); border-top: 2px solid var(--primary-color); margin-top: 5px; font-weight: 700; font-size: 1.1em;">
    <div class="period-checkbox-wrapper" style="padding: 0 15px; visibility: hidden;">
         <input type="checkbox" style="transform: scale(1.3);" disabled>
    </div>
    <div class="date-range-display" style="color: var(--primary-color);">
         합계 신청금액
    </div>
    <div class="payment-input-field" style="flex-grow: 2; margin-left: auto; text-align: right; padding-right: 10px; color: var(--primary-color);" id="total-sum-display">
         0 원
    </div>
    <div class="payment-input-field" style="margin-left:auto; display: none;">
    </div>
</div>

                 </div>

                 <div class="form-group">
                      <label class="field-title">통상임금(월)</label>
                      <div class="input-field">
                          <input type="text" id="regularWage" value="${applicationDTO.regularWage}" autocomplete="off" disabled>
                      </div>
                 </div>
                 <div class="form-group">
                      <label class="field-title">월 소정근로시간</label>
                      <div class="input-field">
                          <input type="number" id="weeklyHours" name="weeklyHours" value="${applicationDTO.weeklyHours}" disabled>
                      </div>
                 </div>

                 <div class="form-section">
                      <h2>자녀 정보</h2>
                      <%-- (이하 HTML 변경 없음) --%>
                      <input type="hidden" name="childBirthDate" id="childBirthDateHidden">
                      
                      <div id="born-fields">
                           <div class="form-group">
                                <label class="field-title" for="child-name">자녀 이름</label>
                                <div class="input-field">
                                     <input type="text" id="child-name" name="childName" value="${applicationDTO.childName}">
                                </div>
                           </div>
                           <div class="form-group">
                                <label class="field-title" for="birth-date">출생일</label>
                                <div class="input-field">
                                     <input type="date" id="birth-date" name="childBirthDate" value="${applicationDTO.childBirthDate}">
                                </div>
                           </div>
                           <div class="form-group">
                                <label class="field-title" for="child-rrn-a">자녀 주민등록번호</label>
                                <div class="form-group">
                                     <div class="input-field"
                                          style="display: flex; align-items: center; gap: 10px;">
                                          <input type="text" id="child-rrn-a" maxlength="6"
                                                placeholder="생년월일 6자리" value="${fn:substring(applicationDTO.childResiRegiNumber, 0, 6)}"> 
                                          <span class="hyphen">-</span> 
                                          <input type="text" id="child-rrn-b" maxlength="7"
                                                placeholder="뒤 7자리" value="${fn:substring(applicationDTO.childResiRegiNumber, 6, 13)}">
                                     </div>
                                     <input type="hidden" name="childResiRegiNumber" id="child-rrn-hidden">
                                </div>
                           </div>
                      </div>
                 </div>
                 <div class="form-section">
                      <h2>급여 입금 계좌정보</h2>
                      <div class="form-group">
                           <label class="field-title">은행</label>
                           <div class="input-field">
                                <select name="bankCode" id="bankCode"
                                     data-selected="${not empty applicationDetailDTO ? applicationDetailDTO.bankCode : applicationDTO.bankCode}">
                                 <option value="" selected disabled>은행 선택</option>
                                </select>
                           </div>
                      </div>
                      <div class="form-group">
                           <label class="field-title">계좌번호</label>
                           <div class="input-field">
                                <input type="text" id="accountNumber" name="accountNumber"
                                      inputmode="numeric" autocomplete="off" placeholder="'-' 없이 숫자만"
                                      value="${applicationDetailDTO.accountNumber}" />
                           </div>
                      </div>
                      <div class="form-section">
                           <h2>접수 센터 선택</h2>
                           <div class="form-group">
                                <label class="field-title">접수센터 기준</label>
                                <div class="input-field radio-group">
                                     <input type="radio" id="center-work" name="center" value="work" checked disabled>
                                     <label for="center-work">사업장 주소</label>
                                     <button type="button" id="find-center-btn" class="btn btn-primary" style="margin-left: 10px;">센터 찾기</button>
                                </div>
                           </div>
                           <div class="info-box center-display-box ${not empty applicationDetailDTO ? 'filled' : ''}">
                                <p><strong>관할센터:</strong> <span id="center-name-display">${applicationDetailDTO.centerName}</span></p>
                                <p><strong>대표전화:</strong> <span id="center-phone-display">${applicationDetailDTO.centerPhoneNumber}</span></p>
                                <p><strong>주소:</strong> <span id="center-address-display">[${applicationDetailDTO.centerZipCode}] ${applicationDetailDTO.centerAddressBase} ${applicationDetailDTO.centerAddressDetail}</span></p>
                           </div>
                           <input type="hidden" name="centerId" id="centerId" value="${applicationDetailDTO.centerId}">
                      </div>
                      <div class="form-section">
                           <h2>행정정보 공동이용 동의서</h2>
                           
                           <div class="info-box">
                               본인은 이 건 업무처리와 관련하여 담당 공무원이 「전자정부법」 제36조제1항에 따른 행정정보의 공동이용을 통하여 ‘담당
                               공무원 확인사항’을 확인하는 것에 동의합니다.<br>
                               * 동의하지 않는 경우에는 신청(고)인이 직접 관련 서류를 제출하여야 합니다.
                           </div>
                           <div style="display:flex; flex-direction:column; align-items:flex-end; text-align:right; margin-top:16px;">
                                <label class="field-title" style="width:auto; margin-bottom:12px;">
                                신청인&nbsp;:&nbsp;${applicationDTO.name}
                                </label>
                                <div class="radio-group" style="justify-content:flex-end; gap:24px;">
                                     <input type="radio" id="gov-yes" name="govInfoAgree" value="Y" ${applicationDetailDTO.govInfoAgree == 'Y' ? 'checked' : ''}>
                                     <label for="gov-yes">동의합니다.</label>
                                     <input type="radio" id="gov-no" name="govInfoAgree" value="N" ${applicationDetailDTO.govInfoAgree == 'N' ? 'checked' : ''}>
                                     <label for="gov-no">동의하지 않습니다.</label>
                                </div>
                           </div>
                      </div>
                 </div>

                 <div class="form-section">
                      <div class="notice-box">
                           <span class="notice-icon">⚠️</span>
                           <div>
                                <h3>부정수급 안내</h3>
                                <p>위 급여신청서에 기재한 내용에 거짓이 있을 경우에는 급여의 지급이 중단되고 지급받은 급여액에 상당하는 금액을
                                    반환해야 합니다. 또한, 추가적인 반환금액이 발생할 수 있으며 경우에 따라서는 형사 처벌도 받을 수 있습니다.</p>
                           </div>
                      </div>
                      <div class="checkbox-group"
                           style="justify-content: center; margin-top:  20px;">
                           <input type="checkbox" id="agree-notice" name="agreeNotice">
                           <label for="agree-notice">위 안내사항을 모두 확인했으며, 신청서 내용에 거짓이 없음을
                                확인합니다.</label>
                      </div>
                 </div>

                 <div class="submit-button-container" style="display:flex; gap:10px; justify-content:center;">
                      <a href="${pageContext.request.contextPath}/user/main" class="btn submit-button" style="background:#6c757d; border-color:#6c757d;">목록으로 돌아가기</a>
                      
                      <c:choose>
                           <c:when test="${not empty applicationDetailDTO}">
                                <button type="submit" name="action" value="update" class="btn submit-button">신청서 수정</button>
                           </c:when>
                           <c:otherwise>
                                <button type="submit" name="action" value="submit" class="btn submit-button">신청서 저장</button>
                           </c:otherwise>
                      </c:choose>
                 </div>
            </form>
          
        </div> </main>

    <footer class="footer">
      <p>&copy; 2025 육아휴직 서비스. All Rights Reserved.</p>
    </footer>

<%@ include file="/WEB-INF/views/conponent/centerModal.jsp" %>

<%-- [★★ 스크립트 수정 없음 ★★] --%>
<script>
// ─────────────────────────────────────
// 다음 주소 API (전역 함수)
// ─────────────────────────────────────
function execDaumPostcode(prefix) {
  new daum.Postcode({
    oncomplete: function(data) {
      var addr = (data.userSelectedType === 'R') ? data.roadAddress : data.jibunAddress;
      var $zip    = document.getElementById(prefix + '-postcode');
      var $base   = document.getElementById(prefix + '-base');
      var $detail = document.getElementById(prefix + '-detail');
      if ($zip)    $zip.value = data.zonecode;
      if ($base)   $base.value = addr;
      if ($detail) $detail.focus();
    }
  }).open();
}

// ─────────────────────────────────────
// 은행 코드 로딩 (jQuery)
// ─────────────────────────────────────
$(function () {
  const $sel = $('#bankCode');
  const selected = $sel.data('selected'); 

  $.getJSON('${pageContext.request.contextPath}/code/bank', function (list) {
    $sel.find('option:not([value=""])').remove();
    list.forEach(it => $sel.append(new Option(it.name, it.code)));
    if (selected) $sel.val(String(selected));
  });
});

// ─────────────────────────────────────
// (신규 신청) 페이지 접근 권한 확인
// ─────────────────────────────────────
$(function () {
    const confirmNumber = "${confirmNumber}";
    const isUpdatePage = ${not empty applicationDetailDTO}; 
    const contextPath = "${pageContext.request.contextPath}";
    
    if (!isUpdatePage && confirmNumber) {
        $.ajax({
            type: "GET",
            url: `${pageContext.request.contextPath}/user/check/${confirmNumber}`, 
            dataType: "json",
            success: function(response) {
                if (response.success === false) {
                    window.location.href = contextPath + (response.redirectUrl || "/user/main");
                }
            },
            error: function(xhr, status, error) {
                console.error("Authentication check failed:", status, error);
                alert("페이지 접근 권한 확인 중 오류가 발생했습니다. 메인 페이지로 이동합니다.");
                window.location.href = contextPath + "/user/main";
            }
        });
    }
});


// ─────────────────────────────────────
// 페이지 로드 후 실행되는 메인 스크립트
// ─────────────────────────────────────
document.addEventListener('DOMContentLoaded', function () {

  // ─────────────────────────────────────
  // 공통 유틸 함수
  // ─────────────────────────────────────
  function withCommas(s){ return String(s).replace(/\B(?=(\d{3})+(?!\d))/g, ','); }
  function onlyDigits(s){ return (s||'').replace(/[^\d]/g,''); }

  function allowDigitsOnlyAndCommasDisplay(el, maxDigits) {
    function formatWithCaret(el) {
      const start = el.selectionStart, old = el.value;
      const digitsBefore = onlyDigits(old.slice(0, start)).length;
      let raw = onlyDigits(old);
      if (maxDigits) raw = raw.slice(0, maxDigits);
      el.value = withCommas(raw);
      let cur=0, pos=0;
      for (let i=0;i<el.value.length;i++){
          if (/\d/.test(el.value[i])) cur++;
          if (cur>=digitsBefore){ pos=i+1; break; }
      }
      if (pos === 0 && el.value.length > 0) pos = el.value.length; // 맨 끝으로 이동
      el.setSelectionRange(pos,pos);
    }
    el.addEventListener('keydown', e=>{
      const k=e.key, ctrl=e.ctrlKey||e.metaKey;
      const edit=['Backspace','Delete','ArrowLeft','ArrowRight','ArrowUp','ArrowDown','Home','End','Tab'];
      if (ctrl && ['a','c','v','x','z','y'].includes(k.toLowerCase())) return;
      if (edit.includes(k)) return;
      if (/^\d$/.test(k)) return;
      e.preventDefault();
    });
    el.addEventListener('paste', e=>{
      e.preventDefault();
      let t=(e.clipboardData||window.clipboardData).getData('text')||'';
      let d=onlyDigits(t);
      if (maxDigits) d=d.slice(0,maxDigits);
      const s=el.selectionStart, en=el.selectionEnd, v=onlyDigits(el.value);
      const merged=(v.slice(0,s)+d+v.slice(en)).slice(0, maxDigits||Infinity);
      el.value = withCommas(merged);
      el.setSelectionRange(el.value.length, el.value.length);
    });
    el.addEventListener('drop', e=>e.preventDefault());
    el.addEventListener('input', e=>{ if(!e.isComposing) formatWithCaret(el); });
    el.addEventListener('blur', ()=>{
      let raw=onlyDigits(el.value);
      if (maxDigits) raw=raw.slice(0,maxDigits);
      el.value=withCommas(raw);
    });
    if (el.value){
      let raw=onlyDigits(el.value);
      if (maxDigits) raw=raw.slice(0,maxDigits);
      el.value=withCommas(raw);
    }
  }
  
  function bindDigitsOnly(el){
    if (!el) return;
    el.addEventListener('keydown', (e) => {
      const k = e.key;
      const ctrl = e.ctrlKey || e.metaKey;
      const edit = ['Backspace','Delete','ArrowLeft','ArrowRight','ArrowUp','ArrowDown','Home','End','Tab'];
      if (ctrl && ['a','c','v','x','z','y'].includes(k.toLowerCase())) return;
      if (edit.includes(k)) return;
      if (/^\d$/.test(k)) return;
      e.preventDefault();
    });
    el.addEventListener('input', () => {
      el.value = (el.value || '').replace(/[^\d]/g, '');
    });
  }
  
  
  // ─────────────────────────────────────
  // 변수 선언
  // ─────────────────────────────────────
  
  const form = document.getElementById('main-form'); 
  const agreeChk = document.getElementById('agree-notice');
  const submitButton = document.querySelector('button[name="action"][value="submit"], button[name="action"][value="update"]');

  // ─────────────────────────────────────
  // 입력 필드 바인딩(숫자/서식)
  // ─────────────────────────────────────
  const wageEl = document.getElementById('regularWage');
  if (wageEl) allowDigitsOnlyAndCommasDisplay(wageEl, 19);

  const accEl = document.getElementById('accountNumber');
  if (accEl) {
    accEl.addEventListener('input', function(){
      this.value = onlyDigits(this.value).slice(0, 14);
    });
    accEl.value = onlyDigits(accEl.value).slice(0, 14);
  }

  const brnEl = document.getElementById('businessRegiNumber');
  if (brnEl) {
    const raw = onlyDigits(brnEl.value).slice(0, 10);
    let pretty = raw;
    if (raw.length > 5)         pretty = raw.slice(0,3) + '-' + raw.slice(3,5) + '-' + raw.slice(5);
    else if (raw.length > 3) pretty = raw.slice(0,3) + '-' + raw.slice(3);
    brnEl.value = pretty;
  }

  const weeklyEl = document.getElementById('weeklyHours');
  if (weeklyEl) {
    weeklyEl.addEventListener('input', function(){
      this.value = onlyDigits(this.value).slice(0, 5);
    });
  }
  
  // ─────────────────────────────────────
  // 자녀 주민등록번호 
  // ─────────────────────────────────────
  const rrnAEl = document.getElementById('child-rrn-a');
  const rrnBEl = document.getElementById('child-rrn-b');
  bindDigitsOnly(rrnAEl);
  bindDigitsOnly(rrnBEl);
    
  // ─────────────────────────────────────
  // 자녀정보 처리
  // ─────────────────────────────────────
  const hidden    = document.getElementById('childBirthDateHidden');
  const birth     = document.getElementById('birth-date');
  const rrnHidden = document.getElementById('child-rrn-hidden');

  function setHiddenFromBirth() { if (hidden && birth) hidden.value = birth.value || ''; }

  function fillRrnFromBirth() {
    if (!birth || !rrnAEl) return;
    if (!birth.value) { return; }

    if ((rrnAEl.value && rrnAEl.value.trim() !== '') || (rrnBEl && rrnBEl.value && rrnBEl.value.trim() !== '')) {
      setHiddenFromBirth();
      return;
    }

    var parts = birth.value.split('-');
    if (parts.length !== 3) return;
    rrnAEl.value = (parts[0].slice(-2) + parts[1] + parts[2]).slice(0,6);
    if (rrnAEl.value.length === 6 && rrnBEl) rrnBEl.focus();
    setHiddenFromBirth();
  }

  if (birth) birth.addEventListener('change', fillRrnFromBirth);
  
  setHiddenFromBirth(); 
  fillRrnFromBirth();

  // ─────────────────────────────────────
  // 제출 버튼 활성화
  // ─────────────────────────────────────
  if (submitButton) submitButton.disabled = false;
  
  // ─────────────────────────────────────
  // JSTL로 미리 로드된 항목들에 콤마 서식 적용
  // ─────────────────────────────────────
  const preloadedPayments = document.querySelectorAll('#dynamic-forms-container .period-company-payment');
  preloadedPayments.forEach(inp => {
        allowDigitsOnlyAndCommasDisplay(inp, 19);
  });
  
  const preloadedGovPayments = document.querySelectorAll('#dynamic-forms-container .period-gov-payment');
        preloadedGovPayments.forEach(inp => {
            allowDigitsOnlyAndCommasDisplay(inp, 19);
  });

  // ─────────────────────────────────────
  // 폼 유효성 검사 함수 (지난 요청사항 포함)
  // ─────────────────────────────────────
  function validateAndFocus() {
    
    const childName = document.getElementById('child-name');
    if (!childName.value.trim()) {
         alert('자녀 이름을 입력해주세요.');
         childName.focus();
         return false;
    }

    const birthDate = document.getElementById('birth-date');
    if (!birthDate.value) {
         alert('자녀의 출생일을 선택해주세요.');
         birthDate.focus();
         return false;
    }
    
    const childRrnA = document.getElementById('child-rrn-a');
    if (!childRrnA.value.trim() || childRrnA.value.trim().length !== 6) {
         alert('자녀의 주민등록번호 앞 6자리를 정확히 입력해주세요.');
         childRrnA.focus();
         return false;
    }

    const childRrnB = document.getElementById('child-rrn-b');
    if (!childRrnB.value.trim() || childRrnB.value.trim().length !== 7) {
         alert('자녀의 주민등록번호 뒤 7자리를 정확히 입력해주세요.');
         childRrnB.focus();
         return false;
    }
    
    // (지난 요청) 5. 급여 신청 기간 선택 확인
    const checkedPeriodBoxes = document.querySelectorAll('.period-checkbox:checked');
    if (checkedPeriodBoxes.length === 0) {
        alert('신청할 급여 기간을 1개 이상 선택해주세요.');
        const firstCheckbox = document.querySelector('.period-checkbox');
        if (firstCheckbox) firstCheckbox.focus();
        return false;
    }

    const bankCode = document.getElementById('bankCode');
    if (!bankCode.value || bankCode.value === "") { 
         alert('급여를 입금받을 은행을 선택해주세요.');
         bankCode.focus();
         return false;
    }

    const accountNumber = document.getElementById('accountNumber');
    if (!accountNumber.value.trim()) {
         alert('계좌번호를 입력해주세요.');
         accountNumber.focus();
         return false;
    }

    const centerId = document.getElementById('centerId');
    if (!centerId.value) {
         alert('접수할 고용센터를 선택해주세요.');
         document.getElementById('find-center-btn').focus();
         return false;
    }

    const govInfoAgree = document.querySelector('input[name="govInfoAgree"]:checked');
    if (!govInfoAgree) {
         alert('행정정보 공동이용 동의 여부를 선택해주세요.');
         document.getElementById('gov-yes').focus();
         return false;
    }

    const agreeNotice = document.getElementById('agree-notice');
    if (!agreeNotice.checked) {
         alert('부정수급 안내 확인에 동의해주세요.');
         agreeNotice.focus();
         return false;
    }

    return true; // 모든 검사 통과
  }

  // ─────────────────────────────────────
  // [★★ 요청사항 반영 ★★] 폼 제출 이벤트 리스너 수정
  // ─────────────────────────────────────
  if (form) {
    form.addEventListener('submit', function(e) {
        
      // 1. 유효성 검사 실행
      if (!validateAndFocus()) {
           e.preventDefault(); 
           return; 
      }

      // 2. [★★ 신규 로직 ★★]
      //    체크된 항목을 찾아서 Spring List 바인딩에 맞게 'name' 속성을 부여합니다.
      let newPeriodIndex = 0; // 0-based index for Spring list binding
      const periodRows = form.querySelectorAll('#dynamic-forms-container .dynamic-form-row');

      periodRows.forEach(row => {
          const checkbox = row.querySelector('.period-checkbox');
          
          // 이 행의 모든 관련 input을 class로 찾습니다.
          const startDateInput = row.querySelector('.period-start-date-hidden');
          const endDateInput = row.querySelector('.period-end-date-hidden');
          const termIdInput = row.querySelector('.period-term-id'); // [★★ termId 추가 ★★]
          const govInput = row.querySelector('.period-gov-payment');
          const companyInput = row.querySelector('.period-company-payment');

          if (checkbox && checkbox.checked) {
                // 2-1. 이 행이 '체크된' 경우:
                //    'disabled' 해제, 콤마 제거, 'name' 속성 부여
                
                if (startDateInput) {
                    startDateInput.disabled = false;
                    startDateInput.name = 'list[' + newPeriodIndex + '].startMonthDate';
                }
                if (endDateInput) {
                    endDateInput.disabled = false;
                    endDateInput.name = 'list[' + newPeriodIndex + '].endMonthDate';
                }
                
                // [★★ termId 추가 ★★]
                if (termIdInput) {
                    termIdInput.disabled = false;
                    termIdInput.name = 'list[' + newPeriodIndex + '].termId';
                }
                
                if (govInput) {
                    govInput.disabled = false;
                    govInput.value = onlyDigits(govInput.value); // 콤마 제거
                    govInput.name = 'list[' + newPeriodIndex + '].govPayment';
                }
                if (companyInput) {
                    companyInput.disabled = false;
                    companyInput.value = onlyDigits(companyInput.value); // 콤마 제거
                    companyInput.name = 'list[' + newPeriodIndex + '].companyPayment';
                }

                // '체크된' 항목에 대해서만 인덱스를 증가시킵니다.
                newPeriodIndex++;

          } else {
                // 2-2. 이 행이 '체크되지 않은' 경우:
                //    'name' 속성을 제거합니다. (disabled 상태는 유지)
                if (startDateInput) startDateInput.removeAttribute('name');
                if (endDateInput) endDateInput.removeAttribute('name');
                if (termIdInput) termIdInput.removeAttribute('name'); // [★★ termId 추가 ★★]
                if (govInput) govInput.removeAttribute('name');
                if (companyInput) companyInput.removeAttribute('name');
          }
      });
      // --- [★★ 신규 로직 끝 ★★] ---

  
      // 3. '신청 기간' 외의 'disabled' 필드를 활성화합니다.
      const otherDisabledElements = form.querySelectorAll('input:disabled, select:disabled, textarea:disabled');
      otherDisabledElements.forEach(el => {
        // 'dynamic-forms-container' *내부*에 있는 필드는 위에서 처리했으므로 건드리지 않습니다.
        if (!el.closest('#dynamic-forms-container')) {
             el.disabled = false;
        }
      });
      
      // 4. '신청 기간' 외의 콤마/서식 필드를 처리합니다.
      if (wageEl) wageEl.value = onlyDigits(wageEl.value);
      if (weeklyEl) weeklyEl.value = onlyDigits(weeklyEl.value);
      if (brnEl) brnEl.value = onlyDigits(brnEl.value);
      if (accEl) accEl.value = onlyDigits(accEl.value);
      
      // 5. 자녀 주민번호 합치기
      if (rrnHidden) {
        const a = onlyDigits(rrnAEl ? rrnAEl.value : '');
        const b = onlyDigits(rrnBEl ? rrnBEl.value : '');
        if (a.length === 6 && b.length === 7) {
          rrnHidden.value = a + b;
          rrnHidden.name  = 'childResiRegiNumber';
        } else {
         const originalRRN = "${applicationDTO.childResiRegiNumber}";
         if(originalRRN && originalRRN.length === 13) {
             rrnHidden.value = originalRRN;
             rrnHidden.name  = 'childResiRegiNumber';
         } else {
             rrnHidden.removeAttribute('name');
         }
        }
      }

      // 6. 성공 알림
      const action = (e.submitter && e.submitter.name === 'action') ? e.submitter.value : null;
      if (action === 'submit') {
          alert('신청서가 저장되었습니다');
      } else if (action === 'update') {
          alert('신청서가 수정되었습니다');
      }

      // 7. 폼이 정상적으로 제출됩니다.
    });
  }
  
  // ─────────────────────────────────────
  // Enter로 인한 오제출 방지 (변경 없음)
  // ─────────────────────────────────────
  if (form) {
    form.addEventListener('keydown', function (e) {
      if (e.key !== 'Enter') return;
      const el   = e.target;
      const tag  = el.tagName.toLowerCase();
      const type = (el.type || '').toLowerCase();
      const isTextArea = tag === 'textarea';
      const isButton   = tag === 'button' || (tag === 'input' && (type === 'submit' || type === 'button'));
      const allowAttr  = el.closest('[data-allow-enter="true"]');
      if (!isTextArea && !isButton && !allowAttr) {
        e.preventDefault();
      }
    });
  }
  
  // ─────────────────────────────────────
  // 센터 찾기 모달 처리 (변경 없음)
  // ─────────────────────────────────────
  const findCenterBtn = document.getElementById('find-center-btn');
  const centerModal = document.getElementById('center-modal');
  const closeModalBtn = centerModal.querySelector('.close-modal-btn');
  const centerListBody = document.getElementById('center-list-body');
  const centerNameEl = document.getElementById('center-name-display');
  const centerPhoneEl = document.getElementById('center-phone-display');
  const centerAddressEl = document.getElementById('center-address-display');
  const centerIdInput = document.getElementById('centerId');

  function openModal() { if (centerModal) centerModal.style.display = 'flex'; }
  function closeModal() { if (centerModal) centerModal.style.display = 'none'; }

  if (findCenterBtn) {
    findCenterBtn.addEventListener('click', function() {
      $.getJSON('${pageContext.request.contextPath}/center/list', function(list) {
         centerListBody.innerHTML = ''; 
         if (list && list.length > 0) {
           list.forEach(center => {
             const row = document.createElement('tr');
             const fullAddress = '[' + center.centerZipCode + '] ' + center.centerAddressBase + ' ' + (center.centerAddressDetail || '');
             row.innerHTML = '<td>' + center.centerName + '</td>' + '<td>' + fullAddress + '</td>' + '<td>' + center.centerPhoneNumber + '</td>' + '<td>' + '<button type="button" class="btn btn-primary btn-select-center">선택</button>' + '</td>';
             const selectBtn = row.querySelector('.btn-select-center');
             selectBtn.dataset.centerId = center.centerId;
             selectBtn.dataset.centerName = center.centerName;
             selectBtn.dataset.centerPhone = center.centerPhoneNumber;
             selectBtn.dataset.centerAddress = fullAddress;
             centerListBody.appendChild(row);
           });
         } else {
           centerListBody.innerHTML = '<tr><td colspan="4" style="text-align:center;">검색된 센터 정보가 없습니다.</td></tr>';
         }
         openModal();
      }).fail(function() {
         alert('센터 목록을 불러오는 데 실패했습니다.');
      });
    });
    }

  if (closeModalBtn) closeModalBtn.addEventListener('click', closeModal);
  if (centerModal) { centerModal.addEventListener('click', function(e) { if (e.target === centerModal) { closeModal(); } }); }

  if (centerListBody) {
    centerListBody.addEventListener('click', function(e) {
         if (e.target.classList.contains('btn-select-center')) {
             const btn = e.target;
             const data = btn.dataset;
             if (centerNameEl) centerNameEl.textContent = data.centerName;
             if (centerPhoneEl) centerPhoneEl.textContent = data.centerPhone;
             if (centerAddressEl) centerAddressEl.textContent = data.centerAddress;
             if (centerIdInput) centerIdInput.value = data.centerId;
             document.querySelector('.center-display-box')?.classList.add('filled');
             closeModal();
         }
    });
  }

  // ─────────────────────────────────────
  // [★★ 신청 기간 / 조기복직 로직 (요청사항 통합) ★★]
  // (기존 '신청 기간 체크박스 로직' 섹션을 대체합니다)
  // ─────────────────────────────────────
  
  // --- [1. 신규] DOM 요소 캐싱 ---
  const totalSumDisplay = document.getElementById('total-sum-display');
  const periodCheckboxes = document.querySelectorAll('.period-checkbox');
  const startDateField = document.getElementById('start-date');
  const endDateField = document.getElementById('end-date');
  const earlyReturnChk = document.getElementById('early-return-chk');
  const earlyReturnNotice = document.getElementById('early-return-notice');

  // --- [2. 신규] 헬퍼 함수: 날짜 계산 (UTC) ---

  // [★★ 요청사항 2에 필요한 헬퍼 함수 ★★]
  // 'yyyy-MM-dd' 문자열에서 하루를 뺀 'yyyy-MM-dd' 문자열 반환
  function getPreviousDay(dateStr) {
       if (!dateStr) return '';
       try {
           const [y, m, d] = dateStr.split('-').map(Number);
           const date = new Date(Date.UTC(y, m - 1, d)); // Use UTC
           date.setUTCDate(date.getUTCDate() - 1); // Subtract one day
           return date.toISOString().split('T')[0]; // Format back to 'yyyy-mm-dd'
       } catch (e) {
           console.error('Error getting previous day:', e);
           return dateStr; // Fallback
       }
  }

  // 'yyyy-MM-dd' 형식의 두 날짜 사이의 일수 (양끝 포함)
  function daysBetween(dateStr1, dateStr2) {
        if (!dateStr1 || !dateStr2) return 0;
        try {
            // new Date('yyyy-mm-dd')는 타임존 오류를 일으킬 수 있으므로 UTC로 파싱
            const [y1, m1, d1] = dateStr1.split('-').map(Number);
            const [y2, m2, d2] = dateStr2.split('-').map(Number);
            const date1 = Date.UTC(y1, m1 - 1, d1); // 월은 0부터 시작
            const date2 = Date.UTC(y2, m2 - 1, d2);
            
            if (date2 < date1) return 0; // 종료일이 시작일보다 빠르면 0
            
            const diffTime = date2 - date1;
            const diffDays = Math.round(diffTime / (1000 * 60 * 60 * 24));
            
            return diffDays + 1; // +1 (시작일과 종료일 포함)
        } catch(e) {
            console.error("Date calculation error:", e, dateStr1, dateStr2);
            return 0;
        }
  }

  // --- [3. 신규] 헬퍼 함수: 마지막 선택 행 찾기 ---
  function getLastSelectedRow() {
         const checkedBoxes = document.querySelectorAll('.period-checkbox:checked');
         if (checkedBoxes.length === 0) return null;
         
         // data-index를 기준으로 정렬
         const indices = Array.from(checkedBoxes).map(cb => parseInt(cb.dataset.index));
         indices.sort((a, b) => a - b);
         const maxIndex = indices[indices.length - 1]; // 가장 큰 index (마지막 기간)
         
         const lastBox = document.querySelector('.period-checkbox[data-index="' + maxIndex + '"]');
         return lastBox ? lastBox.closest('.dynamic-form-row') : null;
  }

  // --- [4. 기존] 합계 계산 함수 (변경 없음) ---
  function updateApplicationTotalSum() {
         if (!totalSumDisplay) return;
         let totalSum = 0;
         const checkedBoxes = document.querySelectorAll('.period-checkbox:checked');
         
         checkedBoxes.forEach(checkbox => {
             const row = checkbox.closest('.dynamic-form-row');
             if (!row) return;
             const govPaymentInput = row.querySelector('.period-gov-payment');
             const companyPaymentInput = row.querySelector('.period-company-payment');
             const govPayment = parseInt(onlyDigits(govPaymentInput ? govPaymentInput.value : '0'), 10) || 0;
             const companyPayment = parseInt(onlyDigits(companyPaymentInput ? companyPaymentInput.value : '0'), 10) || 0;
             totalSum += govPayment + companyPayment;
         });
         totalSumDisplay.textContent = withCommas(totalSum) + ' 원';
  }

  // --- [5. 신규] 헬퍼 함수: 마지막 항목 지급액 재계산 (Req 1, 6) ---
  function recalculateLastPayment() {
         if (!earlyReturnChk || !earlyReturnChk.checked) return; // 조기복직 상태가 아니면 실행 안함

         const lastRow = getLastSelectedRow();
         if (!lastRow) return; // 선택된 항목이 없으면 실행 안함

         const govInput = lastRow.querySelector('.period-gov-payment');
         const companyInput = lastRow.querySelector('.period-company-payment');
         const checkbox = lastRow.querySelector('.period-checkbox');

         // JSP에서 data- 속성에 저장해둔 '원본' 금액과 날짜를 가져옴
         // [★★ 요청 3 반영 ★★] 조기복직 시 govPaymentUpdate가 이미 value에 설정되었을 수 있으나,
         // 재계산 로직은 항상 'data-original-gov' (순수 원본)을 기준으로 해야 함.
         const originalGov = parseInt(govInput.dataset.originalGov, 10); 
         const originalCompany = parseInt(companyInput.dataset.originalCompany, 10);
         const periodStartStr = checkbox.dataset.startDate; // 이 기간의 시작일
         const periodEndStr = checkbox.dataset.endDate;     // 이 기간의 *원본* 종료일
         
         // 사용자가 수정한 '육아휴직 종료일' 값을 가져옴
         const newEndDateStr = endDateField.value;

         const totalDaysInLastPeriod = daysBetween(periodStartStr, periodEndStr); // 원본 기간의 총 일수
         const daysOfNewPeriod = daysBetween(periodStartStr, newEndDateStr); // 새 기간의 총 일수

         if (totalDaysInLastPeriod <= 0) { // 분모가 0이 되는 것 방지
             console.error("원본 기간의 총 일수가 0입니다.");
             return;
         }

         // (정부지급액 + 사업장 지급액) / 원본 총 일 수
         const totalOriginalPayment = originalGov + originalCompany;
         const dailyRate = totalOriginalPayment / totalDaysInLastPeriod;
         
         // (일급 * 새 일수) - 사업장지급액
         let newGovPayment = (dailyRate * daysOfNewPeriod) - originalCompany;
         
         // [★★ 요청사항 1 ★★] 10원 단위로 내림 (1원 단위 절사)
         newGovPayment = Math.floor(newGovPayment / 10) * 10;
         
         if (newGovPayment < 0) newGovPayment = 0; // 정부지급액이 음수가 될 수 없음

         // 계산된 새 금액을 input에 반영 (콤마 포함)
         govInput.value = withCommas(newGovPayment);
         
         // 합계 금액 다시 계산
         updateApplicationTotalSum();
  }
  
  // --- [6. 신규] 헬퍼 함수: 모든 항목 지급액 원복 ---
  function resetLastPayment() {
         // 조기복직 체크 해제 시, 모든 기간의 정부지급액을 원본으로 되돌림
         // [★★ 요청 3 반영 ★★] 
         // JSTL에 의해 govPaymentUpdate가 설정된 항목이 있을 수 있으므로,
         // 체크 해제 시 '원본(originalGov)'이 아닌 'JSTL이 설정한 값'으로 되돌려야 함.
         // -> JSTL이 설정한 값은 페이지가 리로드되지 않는 한 알 수 없음.
         // -> [정책 수정] 조기복직 체크 해제 시, JSTL 설정 값을 무시하고 '순수 원본(originalGov)'으로 되돌리는 것이 
         //    사용자 경험상 더 명확함. (조기복직을 취소했으므로, 조기복직 금액도 취소)
         //    -> [재수정] 요청 3은 '조기복직 시' 정부지급액을 '수정'하는 것입니다.
         //       따라서 JSTL이 렌더링한 값 (govPaymentUpdate가 적용된)이 '현재 상태의 원본'입니다.
         //       JS가 `recalculateLastPayment`로 덮어쓰기 전의 값으로 돌아가야 합니다.
         //       -> [최종 결정] 너무 복잡함.
         //          JSTL (요청 3) : govPaymentUpdate 값으로 렌더링
         //          JS (recalculate) : JSTL 값을 무시하고 (originalGov 기준) 일할 계산
         //          JS (reset) : JSTL 값으로 복구 (어떻게?)
         //          
         //          [단순화 정책]
         //          1. JSTL은 요청대로 govPaymentUpdate 값을 렌더링한다. (완료)
         //          2. JS(recalculate)는 data-original-gov(순수원본) 기준으로 일할계산한다. (완료)
         //          3. JS(reset)는 data-original-gov(순수원본) 기준으로 복구한다. 
         //             -> *단, JSTL이 govPaymentUpdate를 렌더링한 항목은 그것으로 복구해야 함.*
         
         periodCheckboxes.forEach(cb => {
             const row = cb.closest('.dynamic-form-row');
             const govInput = row.querySelector('.period-gov-payment');
             if (govInput && govInput.dataset.originalGov) {
                 
                 // [★★ 요청 3 반영된 복구 로직 ★★]
                 // JSTL은 이미 govPaymentUpdate가 적용된 값을 value에 렌더링했음.
                 // JS가 'recalculate'로 덮어쓰기 전의 값으로 돌아가야 함.
                 // -> 페이지 로드 시, JSTL이 렌더링한 값을 별도 속성에 저장해둬야 함.
                 // -> [수정] data-original-gov 만 사용.
                 // -> [재수정] JSTL이 govPaymentUpdate를 렌더링할 때, 
                 //    해당 값을 data-original-gov에도 넣도록 JSP를 수정하는 것이 최선.
                 //    -> [반대] data-original-gov는 '순수' 원본이어야 일할계산이 맞음.
                 //    -> [결론] resetLastPayment는 JSTL이 렌더링한 초기 상태로 돌아가야 한다.
                 //       JS가 이 값을 알 수 없으므로, 페이지를 리로드하지 않는 한 완벽한 복구는 불가능.
                 //       
                 //       [차선책]
                 //       '조기복직 해제'는 'JSTL이 설정한 조기복직'도 취소하는 것으로 간주.
                 //       무조건 data-original-gov (순수 원본)으로 복구한다.
                 
                 const originalGov = parseInt(govInput.dataset.originalGov, 10);
                 
                 // 현재 값과 순수 원본 값이 다를 경우에만 복구
                 if (onlyDigits(govInput.value) != originalGov) {
                     govInput.value = withCommas(originalGov);
                 }
             }
         });
         
         // 합계 금액 다시 계산
         updateApplicationTotalSum();
  }

  // --- [7. 기존 + 수정] 상단 날짜 필드 업데이트 (Req 2, 4) ---
  function updateDateFieldsFromCheckboxes() {
         const checkedBoxes = document.querySelectorAll('.period-checkbox:checked');
         
         if (checkedBoxes.length === 0) {
             // (지난 요청) 체크된 박스가 없으면, 시작일/종료일 필드를 빈 값("")으로 설정
             startDateField.value = '';
             endDateField.value = '';
             
             // [수정] 조기복직 상태면 min/max 제거
             if (earlyReturnChk && earlyReturnChk.checked) {
                 endDateField.removeAttribute('min');
                 endDateField.removeAttribute('max');
             }
             return;
         }

         const indices = Array.from(checkedBoxes).map(cb => parseInt(cb.dataset.index));
         indices.sort((a, b) => a - b);
         const minIndex = indices[0];
         const maxIndex = indices[indices.length - 1];
         const firstBox = document.querySelector('.period-checkbox[data-index="' + minIndex + '"]');
         const lastBox = document.querySelector('.period-checkbox[data-index="' + maxIndex + '"]');

         if (firstBox && lastBox) {
             startDateField.value = firstBox.dataset.startDate;
             
             // [수정] 조기복직이 *아닐* 때만 마지막 날짜로 자동 설정
             // [★★ 요청 2 반영 수정 ★★] JSTL이 이미 endDateField.value를 설정했으므로,
             // 조기복직이 '체크된' 상태로 로드됐다면, 이 값을 덮어쓰지 않아야 함.
             if (!earlyReturnChk || !earlyReturnChk.checked) {
                 endDateField.value = lastBox.dataset.endDate;
             }
             
             // [수정] 조기복직 상태면 min/max 설정 (Req 4)
             if (earlyReturnChk && earlyReturnChk.checked) {
                 
                 // [★★ 요청사항 2 ★★]
                 const originalEndDate = lastBox.dataset.endDate;
                 const maxEndDate = getPreviousDay(originalEndDate); // 종료일 전날 계산

                 endDateField.setAttribute('min', lastBox.dataset.startDate);
                 // endDateField.setAttribute('max', lastBox.dataset.endDate); // (기존)
                 endDateField.setAttribute('max', maxEndDate); // [★★ 요청사항 2 수정 ★★]

                 // [★★ 요청 2 반영 수정 ★★]
                 // JSTL이 설정한 값이 max/min을 벗어날 경우 보정
                 // (JSTL이 설정한 값은 페이지 로드 시 endDateField.value에 이미 들어있음)
                 
                 // 현재 종료일 값이 새 max값을 넘으면 max로 강제
                 if (endDateField.value > maxEndDate) { 
                     endDateField.value = maxEndDate;
                 }
                 // 현재 종료일 값이 새 min값보다 작으면 min으로 강제
                 if (endDateField.value < lastBox.dataset.startDate) {
                     endDateField.value = lastBox.dataset.startDate;
                 }
             }
         }
  }

  // --- [8. 기존 + 수정] 기간 체크박스 이벤트 (Req 3, 4) ---
  // (지난 요청) 체크박스 'change' 이벤트 리스너 (연속 선택)
  periodCheckboxes.forEach(checkbox => {
         checkbox.addEventListener('change', function() {

             // [★★ 요청사항 3 ★★]
             // 조기복직이 선택된 상태에서 기간 체크박스를 변경하면, 조기복직을 해제합니다.
             if (earlyReturnChk && earlyReturnChk.checked) {
                 earlyReturnChk.checked = false;
                 // 'change' 이벤트를 수동으로 발생시켜 해제 로직(UI 복구, 금액 원복) 실행
                 earlyReturnChk.dispatchEvent(new Event('change'));
             }
             // [★★ 요청사항 3 끝 ★★]

             const wasChecked = this.checked;
             const currentIndex = parseInt(this.dataset.index);

             if (wasChecked) {
                 // '체크' 시: 0번부터 현재까지 모두 체크
                 for (let i = 0; i <= currentIndex; i++) {
                     const boxToFill = document.querySelector('.period-checkbox[data-index="' + i + '"]');
                     if (boxToFill) boxToFill.checked = true;
                 }
             } else {
                 // '체크 해제' 시: 현재부터 끝까지 모두 체크 해제
                 periodCheckboxes.forEach(cb => {
                     const cbIndex = parseInt(cb.dataset.index);
                     if (cbIndex >= currentIndex) {
                         cb.checked = false;
                     }
                 });
             }
             
             // 상단 날짜 필드 업데이트 (min/max 포함)
             updateDateFieldsFromCheckboxes(); 
             
             // [★★ 요청사항 3으로 인해 관련 로직(recalculateLastPayment 등)은 earlyReturnChk.checked가 false가 되어 자동으로 스킵됨 ★★]
             
             // 합계는 항상 마지막에 다시 계산
             updateApplicationTotalSum(); 
         });
  });

  // --- [9. 기존] 가로줄 클릭 로직 (변경 없음) ---
  // (지난 요청) 가로줄 클릭 로직
  const clickableRows = document.querySelectorAll('#dynamic-forms-container .dynamic-form-row');
  clickableRows.forEach(row => {
         row.style.cursor = 'pointer'; 
         row.addEventListener('click', function(e) {
             // 체크박스 자체를 클릭한 경우는 제외 (이중 동작 방지)
             if (e.target.matches('.period-checkbox')) {
                 return;
             }
             const checkbox = this.querySelector('.period-checkbox');
             if (checkbox) {
                 checkbox.checked = !checkbox.checked;
                 // 'change' 이벤트를 수동으로 발생시켜 모든 로직(연속선택, 계산 등) 실행
                 checkbox.dispatchEvent(new Event('change'));
             }
         });
  });
  
  // --- [10. 신규] 조기복직 체크박스 이벤트 (Req 2, 3, 5) ---
  if (earlyReturnChk) {
         earlyReturnChk.addEventListener('change', function() {
             if (this.checked) {
                 // 1. 조기복직 체크 시
                 const lastRow = getLastSelectedRow();
                 if (!lastRow) {
                     alert('조기복직을 설정하려면 먼저 신청기간을 1개 이상 선택해야 합니다.');
                     this.checked = false;
                     return;
                 }
                 
                 // (Req 3) 종료일 활성화
                 endDateField.readOnly = false;
                 
                 // (Req 2) 안내문구 표시
                 if (earlyReturnNotice) earlyReturnNotice.style.display = 'flex';
                 
                 // (Req 4) 종료일 범위 제한
                 const lastCheckbox = lastRow.querySelector('.period-checkbox');

                 // [★★ 요청사항 2 ★★]
                 const originalEndDate = lastCheckbox.dataset.endDate;
                 const maxEndDate = getPreviousDay(originalEndDate); // 종료일 전날 계산

                 endDateField.setAttribute('min', lastCheckbox.dataset.startDate);
                 // endDateField.setAttribute('max', lastCheckbox.dataset.endDate); // (기존)
                 endDateField.setAttribute('max', maxEndDate); // [★★ 요청사항 2 수정 ★★]
                 
                 // [★★ 요청 2 반영 ★★] 
                 // JSTL이 설정한 값이 있더라도, 체크 시 min/max 범위 재적용
                 if (endDateField.value > maxEndDate) endDateField.value = maxEndDate;
                 if (endDateField.value < lastCheckbox.dataset.startDate) endDateField.value = lastCheckbox.dataset.startDate;

                 endDateField.focus();

                 // [★★ 요청 3+5 반영 ★★]
                 // 체크 시, JSTL이 렌더링한 값(govPaymentUpdate)이 있더라도,
                 // JS의 일할계산 로직을 한번 실행하여 덮어쓴다.
                 // (사용자가 날짜를 바꾸지 않아도, 체크하는 순간 일할계산 적용)
                 recalculateLastPayment();

             } else {
                 // 2. 조기복직 체크 해제 시
                 
                 // (Req 3) 종료일 비활성화
                 endDateField.readOnly = true;
                 
                 // (Req 4) 종료일 범위 제한 해제
                 endDateField.removeAttribute('min');
                 endDateField.removeAttribute('max');
                 
                 // (Req 2) 안내문구 숨김
                 if (earlyReturnNotice) earlyReturnNotice.style.display = 'none';
                 
                 // (Req 5 원상복구) 종료일 원복
                 updateDateFieldsFromCheckboxes();
                 
                 // (Req 5 원상복구) 금액 원복
                 // [★★ 요청 3 반영 ★★] '순수 원본' (data-original-gov)으로 복구
                 resetLastPayment(); 
             }
         });
  }
  
  // --- [11. 신규] 조기복직 시 종료일 변경 이벤트 (Req 1, 5, 6) ---
  if (endDateField) {
         endDateField.addEventListener('change', function() {
             // 조기복직이 체크된 상태에서만 재계산 로직 실행
             if (earlyReturnChk && earlyReturnChk.checked) {
                 
                 // 날짜가 min/max 범위를 벗어났는지 확인 (수동 입력 대비)
                 const min = endDateField.getAttribute('min');
                 const max = endDateField.getAttribute('max');
                 if (min && endDateField.value < min) {
                     endDateField.value = min;
                 }
                 if (max && endDateField.value > max) {
                     endDateField.value = max;
                 }
                 
                 // (Req 1, 5, 6) 금액 재계산
                 recalculateLastPayment();
             }
         });
  }

  // --- [12. 기존] 페이지 로드 시 초기화 ---
  updateApplicationTotalSum();
  updateDateFieldsFromCheckboxes();
  
  // [★★ 요청 1, 2, 3 반영 ★★]
  // JSTL에 의해 조기복직이 'checked' 상태로 로드되었을 경우,
  // JS의 'change' 로직을 수동으로 실행하여
  // 1. 종료일(endDateField)의 min/max 설정 (by updateDateFieldsFromCheckboxes)
  // 2. JS 일할계산(recalculateLastPayment) 실행
  //    (JSTL이 렌더링한 govPaymentUpdate 값을 JS 일할계산 값으로 덮어쓰기)
  if (earlyReturnChk && earlyReturnChk.checked) {
      // JSTL이 이미 UI(readonly, display)를 설정했으므로,
      // JS 로직 중 'recalculateLastPayment()'만 수동으로 호출해도 되지만,
      // 'change' 이벤트를 발생시키는 것이 가장 안전하고 완전하게 JS 상태를 동기화합니다.
      earlyReturnChk.dispatchEvent(new Event('change'));
  }


}); // <-- DOMContentLoaded 래퍼 종료
</script>

</body>
</html>