<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>육아휴직 급여 신청</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/global.css">
<style>
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

    /* 기본 스타일 */
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
      background: none !important; /* 강제로 배경 제거 */
      box-shadow: none !important; /* 강제로 그림자 제거 */
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
    
    button[name="action"][value="submit"]:disabled {
      opacity: .6; cursor: not-allowed;
    }
    
    .error {color: red; font-size: 14px;}

    /* Modal Styles */
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
        max-width: 1000px; /* [수정] 모달 너비 확장 */
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

    /* [추가] 센터 선택 영역 강조 스타일 */
    .center-display-box {
        background-color: var(--white-color);
        border: 2px dashed var(--border-color); /* 선택 전: 점선 */
        padding: 20px;
        min-height: 100px;
        transition: all 0.3s ease;
        text-align: center;
        display: flex;
        justify-content: center;
        align-items: center;
    }
    
    /* 선택 전: 플레이스홀더 텍스트 */
    .center-display-box:not(.filled)::before {
        content: '센터 찾기 버튼을 클릭하여 관할 센터를 선택하세요.';
        font-style: italic;
        color: var(--gray-color);
        font-size: 15px;
    }
    
    /* 선택 전: 내부 p 태그 숨김 */
    .center-display-box:not(.filled) p {
        display: none;
    }
    
    /* 선택 후: 스타일 변경 */
    .center-display-box.filled {
        background-color: var(--primary-light-color); /* 선택 후: 파란 배경 */
        border-style: solid;
        border-color: #d1d9ff;
        text-align: left; 
        display: block; /* Flex 속성 해제 */
    }

    /* 선택 후: 내부 p 태그 보임 */
    .center-display-box.filled p {
        display: block; 
    }
</style>
</head>
<body>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

    <%@ include file="header.jsp" %>

    <main class="main-container">
        <div class="content-wrapper"> 
        
            <h1>육아휴직 급여 신청</h1>

            <form action="${pageContext.request.contextPath}/user/apply" method="post">
            <input type="hidden" name="confirmNumber" value="${confirmNumber}">
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

                <div class="form-section">
                    <h2>급여 신청 기간</h2>
                    <p style="color: #888; margin-top: -15px; margin-bottom: 20px;">※
                        사업주로부터 부여받은 총 휴직 기간 중 급여를 지급받으려는 기간을 입력해 주세요.</p>

                    <div class="form-group">
                        <label class="field-title" for="start-date">① 육아휴직 시작일</label>
                        <div class="input-field">
                            <input type="date" id="start-date" value="${applicationDTO.startDate}" disabled>
                        </div>
                    </div>

                    <div id="period-input-section">
                        <div class="form-group">
                            <label class="field-title" for="end-date">② 육아휴직 종료일</label>
                            <div class="input-field"
                                 style="display: flex; align-items: center; gap: 10px;">
                                <input type="date" id="end-date" value="${applicationDTO.endDate}" disabled
                                       style="width: auto; flex-grow: 1;">
                            </div>
                        </div>
                    </div>
                    
<div class="dynamic-form-row" style="background-color: transparent; border-bottom: 2px solid var(--border-color); font-weight: 500; margin-bottom: 0;">
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
    
        <fmt:formatNumber value="${term.govPayment}" pattern="#,##0" var="formattedGovPayment" />
        <fmt:formatNumber value="${term.companyPayment}" pattern="#,##0" var="formattedCompanyPayment" />

        <div class="dynamic-form-row">
            <div class="date-range-display">
                <div>
                    <fmt:formatDate value="${term.startMonthDate}" pattern="yyyy.MM.dd" />
                    ~
                    <fmt:formatDate value="${term.endMonthDate}" pattern="yyyy.MM.dd" />
                </div>
            </div>

            <div class="payment-input-field">
                <input type="text" 
                       name="gov_payment_${status.count}" 
                       value="${formattedGovPayment}" 
                       placeholder="해당 기간의 정부지급액(원) 입력" 
                       autocomplete="off" 
                       disabled
                       style="text-align: right;"> </div>

            <div class="payment-input-field" style="margin-left:auto;">
                <input type="text" 
                       name="monthly_payment_${status.count}" 
                       value="${formattedCompanyPayment}" 
                       placeholder="해당 기간의 사업장 지급액(원) 입력" 
                       autocomplete="off" 
                       disabled
                       style="text-align: right;"> </div>
        </div>
    </c:forEach>
</div>
                </div>

                <div class="form-group">
                    <label class="field-title">통상임금(월)</label>
                    <div class="input-field">
                        <input type="text" id="regularWage" value="${applicationDTO.regularWage}" autocomplete="off" disabled>
                    </div>
                </div>
                <div class="form-group">
                    <label class="field-title">주당 소정근로시간</label>
                    <div class="input-field">
                        <input type="number" id="weeklyHours" name="weeklyHours" value="${applicationDTO.weeklyHours}" disabled>
                    </div>
                </div>

                <div class="form-section">
                    <h2>자녀 정보</h2>

                    <input type="hidden" name="childBirthDate" id="childBirthDateHidden">
                    
                    <div id="born-fields">
                        <div class="form-group">
                            <label class="field-title" for="child-name">자녀 이름</label>
                            <div class="input-field">
                                <input type="text" id="child-name" name="childName" value="${applicationDTO.childName}" disabled>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="field-title" for="birth-date">출생일</label>
                            <div class="input-field">
                                <input type="date" id="birth-date" value="${applicationDTO.childBirthDate}" disabled>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="field-title" for="child-rrn-a">자녀 주민등록번호</label>
                            <div class="form-group">
                                <div class="input-field"
                                     style="display: flex; align-items: center; gap: 10px;">
                                    <input type="text" id="child-rrn-a" maxlength="6"
                                           placeholder="생년월일 6자리" value="${fn:substring(applicationDTO.childResiRegiNumber, 0, 6)}" disabled> 
                                    <span class="hyphen">-</span> 
                                    <input type="text" id="child-rrn-b" maxlength="7"
                                           placeholder="뒤 7자리" value="${fn:substring(applicationDTO.childResiRegiNumber, 6, 13)}" disabled>
                                </div>
                                <input type="hidden" name="childResiRegiNumber"
                                       id="child-rrn-hidden">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="form-section">
                    <h2>급여 입금 계좌정보</h2>
                    <div class="form-group">
                        <label class="field-title">은행</label>
                        <div class="input-field">
                            <select name="bankCode" id="bankCode" data-selected="${applicationDTO.bankCode}">
                                <option value="" selected disabled>은행 선택</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="field-title">계좌번호</label>
                        <div class="input-field">
                            <input type="text" id="accountNumber" name="accountNumber"
                                   inputmode="numeric" autocomplete="off" placeholder="'-' 없이 숫자만" />
                        </div>
                    </div>
                    <div class="form-section">
                        <h2>접수 센터 선택</h2>
                        <div class="form-group">
                            <label class="field-title">접수센터 기준</label>
                            <div class="input-field radio-group">
                                <input type="radio" id="center-work" name="center" value="work" checked disabled>
                                <label for="center-work">사업장 주소</label>
                                <!-- [수정] 버튼 강조 -->
                                <button type="button" id="find-center-btn" class="btn btn-primary" style="margin-left: 10px;">센터 찾기</button>
                            </div>
                        </div>
                        <!-- [수정] 클래스 추가 및 구조 변경 -->
                        <div class="info-box center-display-box">
                            <p><strong>관할센터:</strong> <span id="center-name-display"></span></p>
                            <p><strong>대표전화:</strong> <span id="center-phone-display"></span></p>
                            <p><strong>주소:</strong> <span id="center-address-display"></span></p>
                        </div>
                        <input type="hidden" name="centerId" id="centerId">
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
                            <input type="radio" id="gov-yes" name="govInfoAgree" value="Y">
                            <label for="gov-yes">동의합니다.</label>
                            <input type="radio" id="gov-no" name="govInfoAgree" value="N">
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
                    <button type="submit" name="action" value="submit"    class="btn submit-button">신청서 저장</button>
                </div>
            </form>
            
        </div> </main>

    <footer class="footer">
      <p>&copy; 2025 육아휴직 서비스. All Rights Reserved.</p>
    </footer>

    <div id="center-modal" class="modal-overlay" style="display:none;">
        <div class="modal-content">
            <div class="modal-header">
                <h2>고용센터 검색</h2>
                <button type="button" class="close-modal-btn">&times;</button>
            </div>
            <div class="modal-body">
                <table class="center-table">
                    <thead>
                        <tr>
                            <th>센터명</th>
                            <th>주소</th>
                            <th>전화번호</th>
                            <th>선택</th>
                        </tr>
                    </thead>
                    <tbody id="center-list-body">
                    </tbody>
                </table>
            </div>
        </div>
    </div>

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
  // 모든 변수 선언을 이 안에서 한 번만 합니다.
  // ─────────────────────────────────────
  
  const form = document.querySelector('form[action$="/apply"]');
  const submitBtn = document.querySelector('button[name="action"][value="submit"]');
  const agreeChk = document.getElementById('agree-notice');

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
  }

  const brnEl = document.getElementById('businessRegiNumber');
  if (brnEl) {
    // Readonly지만, 혹시 모를 값 포맷팅을 위해 로직은 남겨둡니다.
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
  // 단위기간/회사지급 
  // ─────────────────────────────────────
    var startDateInput = document.getElementById('start-date');
    var endDateInput = document.getElementById('end-date');
    var periodInputSection = document.getElementById('period-input-section');
    var generateBtn = document.getElementById('generate-forms-btn');
    var formsContainer = document.getElementById('dynamic-forms-container');
    var noPaymentChk = document.getElementById('no-payment');
    var noPaymentWrapper = document.getElementById('no-payment-wrapper');

    function formatDate(date) {
      var y = date.getFullYear();
      var m = String(date.getMonth() + 1).padStart(2, '0');
      var d = String(date.getDate()).padStart(2, '0');
      return y + '.' + m + '.' + d;
    }
    
    function getPeriodEndDate(originalStart, periodNumber) {
        let nextPeriodStart = new Date(
            originalStart.getFullYear(),
            originalStart.getMonth() + periodNumber,
            originalStart.getDate()
        );
        if (nextPeriodStart.getDate() !== originalStart.getDate()) {
            nextPeriodStart = new Date(
                originalStart.getFullYear(),
                originalStart.getMonth() + periodNumber + 1,
                1
            );
        }
        nextPeriodStart.setDate(nextPeriodStart.getDate() - 1);
        return nextPeriodStart;
    }

    if (generateBtn) {
        generateBtn.addEventListener('click', function() {
          if (!startDateInput.value || !endDateInput.value) {
              alert('육아휴직 시작일과 종료일을 모두 선택해주세요.');
              return;
          }
    
          const originalStartDate = new Date(startDateInput.value + 'T00:00:00');
          const finalEndDate = new Date(endDateInput.value + 'T00:00:00');
    
          if (originalStartDate > finalEndDate) {
              alert('종료일은 시작일보다 빠를 수 없습니다.');
              return;
          }
    
          const firstPeriodEndDate = getPeriodEndDate(originalStartDate, 1);
          if (finalEndDate < firstPeriodEndDate) {
              alert('신청 기간은 최소 1개월 이상이어야 합니다.');
              return;
          }
    
          const units = countUnits(startDateInput.value, endDateInput.value);
          if (units > 12) {
              alert('최대 12개월까지만 신청 가능합니다. 종료일을 조정해주세요.');
              return;
          }
    
          formsContainer.innerHTML = '';
          if (noPaymentWrapper) noPaymentWrapper.style.display = 'none';
    
          let currentPeriodStart = new Date(originalStartDate);
          let monthIdx = 1;
    
          while (currentPeriodStart <= finalEndDate && monthIdx <= 12) {
              const theoreticalEndDate = getPeriodEndDate(originalStartDate, monthIdx);
              let actualPeriodEnd = new Date(theoreticalEndDate);
              if (actualPeriodEnd > finalEndDate) {
                  actualPeriodEnd = new Date(finalEndDate);
              }
              
              if (currentPeriodStart > actualPeriodEnd) break;
    
              const rangeText = formatDate(currentPeriodStart) + ' ~ ' + formatDate(actualPeriodEnd);
              var row = document.createElement('div');
              row.className = 'dynamic-form-row';
              row.innerHTML =
                '<div class="date-range-display"><div>' + rangeText + '</div></div>' +
                '<div class="payment-input-field" style="margin-left:auto;">' +
                '<input type="text" name="monthly_payment_' + monthIdx + '" ' +
                'placeholder="해당 기간의 사업장 지급액(원) 입력" autocomplete="off">' +
                '</div>';
              formsContainer.appendChild(row);
              
              // 새로 생성된 입력 필드에 콤마 서식 적용
              allowDigitsOnlyAndCommasDisplay(row.querySelector('input[name^="monthly_payment_"]'), 19);
    
              currentPeriodStart = new Date(actualPeriodEnd);
              currentPeriodStart.setDate(currentPeriodStart.getDate() + 1);
              monthIdx++;
          }
    
          if (noPaymentWrapper) {
              noPaymentWrapper.style.display = 'flex';
              applyNoPaymentState();
          }
        });
    }
    
    function applyNoPaymentState() {
      const inputs = formsContainer.querySelectorAll('input[name^="monthly_payment_"]');
      inputs.forEach(function(inp){
        if (noPaymentChk && noPaymentChk.checked) {
            inp.value = 0;
            inp.readOnly = true;
            inp.classList.add('readonly-like');
        } else {
            inp.readOnly = false;
            inp.classList.remove('readonly-like');
            if (inp.value === '0') inp.value = '';
        }
      });
    }
    
    if (startDateInput) {
        startDateInput.addEventListener('change', function() {
          if (startDateInput.value) {
              endDateInput.min = startDateInput.value;
              formsContainer.innerHTML = '';
              if (noPaymentWrapper) noPaymentWrapper.style.display = 'none';
          } else {
              endDateInput.min = '';
          }
        });
    }
    if (endDateInput) {
        endDateInput.addEventListener('change', function () {
          formsContainer.innerHTML = '';
          if (noPaymentWrapper) noPaymentWrapper.style.display = 'none';
        });
    }
    if (noPaymentChk) noPaymentChk.addEventListener('change', applyNoPaymentState);

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
  
  // 초기 로드 시 실행
  setHiddenFromBirth(); 
  fillRrnFromBirth();

  // ─────────────────────────────────────
  // 제출 버튼 활성화
  // ─────────────────────────────────────
  if (submitBtn) submitBtn.disabled = false;
  
  // ─────────────────────────────────────
  // JSTL로 미리 로드된 항목들에 콤마 서식 적용
  // ─────────────────────────────────────
  const preloadedPayments = document.querySelectorAll('#dynamic-forms-container input[name^="monthly_payment_"]');
  preloadedPayments.forEach(inp => {
      allowDigitsOnlyAndCommasDisplay(inp, 19);
  });
  
  // ─────────────────────────────────────
  // [추가] 폼 유효성 검사 함수
  // ─────────────────────────────────────
  function validateAndFocus() {
    // 1. 은행 선택 확인
    const bankCode = document.getElementById('bankCode');
    if (!bankCode.value) {
        alert('급여를 입금받을 은행을 선택해주세요.');
        bankCode.focus();
        return false;
    }

    // 2. 계좌번호 입력 확인
    const accountNumber = document.getElementById('accountNumber');
    if (!accountNumber.value.trim()) {
        alert('계좌번호를 입력해주세요.');
        accountNumber.focus();
        return false;
    }

    // 3. 접수 센터 선택 확인
    const centerId = document.getElementById('centerId');
    if (!centerId.value) {
        alert('접수할 고용센터를 선택해주세요.');
        document.getElementById('find-center-btn').focus();
        return false;
    }

    // 4. 행정정보 공동이용 동의 확인
    const govInfoAgree = document.querySelector('input[name="govInfoAgree"]:checked');
    if (!govInfoAgree) {
        alert('행정정보 공동이용 동의 여부를 선택해주세요.');
        document.getElementById('gov-yes').focus();
        return false;
    }

    // 5. 부정수급 안내 확인
    const agreeNotice = document.getElementById('agree-notice');
    if (!agreeNotice.checked) {
        alert('부정수급 안내 확인에 동의해주세요.');
        agreeNotice.focus();
        return false;
    }

    return true; // 모든 검사 통과
  }

  // ─────────────────────────────────────
  // 폼 제출 시 최종 처리
  // ─────────────────────────────────────
  if (form) {
    form.addEventListener('submit', function(e) {
      const action = (e.submitter && e.submitter.name === 'action') ? e.submitter.value : null;

      // [수정] 유효성 검사 로직을 가장 먼저 실행
      if (action === 'submit') {
          if (!validateAndFocus()) {
              e.preventDefault(); // 유효성 검사 실패 시 폼 제출 중단
              return;
          }
      }

      // 자녀 주민번호 합치기
      if (rrnHidden) {
        const a = onlyDigits(rrnAEl ? rrnAEl.value : '');
        const b = onlyDigits(rrnBEl ? rrnBEl.value : '');
        if (a.length === 6 && b.length === 7) {
          rrnHidden.value = a + b;
          rrnHidden.name  = 'childResiRegiNumber';
        } else if (typeof ORIGINAL_RRN !== 'undefined' && ORIGINAL_RRN) {
          rrnHidden.value = ORIGINAL_RRN;
          rrnHidden.name  = 'childResiRegiNumber';
        } else {
          rrnHidden.removeAttribute('name');
        }
      }
      
      // 전송 직전 콤마 제거 및 disabled 해제
      if (wageEl) {
        wageEl.disabled = false; // 전송을 위해 disabled 해제
        wageEl.value = onlyDigits(wageEl.value);
      }
      if (weeklyEl) {
          weeklyEl.disabled = false; // 전송을 위해 disabled 해제
          weeklyEl.value = onlyDigits(weeklyEl.value).slice(0,5);
      }
      
      if (brnEl) brnEl.value = onlyDigits(brnEl.value).slice(0,10);
      if (accEl) accEl.value = onlyDigits(accEl.value).slice(0,14);
      
      const payInputs = form.querySelectorAll('input[name^="monthly_payment_"]');
      payInputs.forEach(inp => { inp.value = onlyDigits(inp.value); });
    });
  }
  
  // ─────────────────────────────────────
  // Enter로 인한 오제출 방지
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
  // 센터 찾기 모달 처리
  // ─────────────────────────────────────
  const findCenterBtn = document.getElementById('find-center-btn');
  const centerModal = document.getElementById('center-modal');
  const closeModalBtn = centerModal.querySelector('.close-modal-btn');
  const centerListBody = document.getElementById('center-list-body');

  const centerNameEl = document.getElementById('center-name-display');
  const centerPhoneEl = document.getElementById('center-phone-display');
  const centerAddressEl = document.getElementById('center-address-display');
  const centerIdInput = document.getElementById('centerId');

  function openModal() {
    if (centerModal) centerModal.style.display = 'flex';
  }
  function closeModal() {
    if (centerModal) centerModal.style.display = 'none';
  }

  if (findCenterBtn) {
    findCenterBtn.addEventListener('click', function() {
      $.getJSON('${pageContext.request.contextPath}/center/list', function(list) {
        centerListBody.innerHTML = ''; // 기존 목록 초기화

        if (list && list.length > 0) {
          list.forEach(center => {
            const row = document.createElement('tr');
            const fullAddress = '[' + center.centerZipCode + '] ' + center.centerAddressBase + ' ' + (center.centerAddressDetail || '');

            row.innerHTML = '<td>' + center.centerName + '</td>' +
              '<td>' + fullAddress + '</td>' +
              '<td>' + center.centerPhoneNumber + '</td>' +
              '<td>' +
              '<button type="button" class="btn btn-primary btn-select-center">선택</button>' +
              '</td>';

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
  if (centerModal) {
    centerModal.addEventListener('click', function(e) {
        if (e.target === centerModal) {
            closeModal();
        }
    });
  }

  if (centerListBody) {
    centerListBody.addEventListener('click', function(e) {
        if (e.target.classList.contains('btn-select-center')) {
            const btn = e.target;
            const data = btn.dataset;

            if (centerNameEl) centerNameEl.textContent = data.centerName;
            if (centerPhoneEl) centerPhoneEl.textContent = data.centerPhone;
            if (centerAddressEl) centerAddressEl.textContent = data.centerAddress;
            if (centerIdInput) centerIdInput.value = data.centerId;
            
            // [수정] 선택 시 .filled 클래스를 추가하여 CSS 스타일을 변경
            document.querySelector('.center-display-box')?.classList.add('filled');
            
            closeModal();
        }
    });
  }

}); // <-- DOMContentLoaded 래퍼 종료
</script>

</body>
</html>
