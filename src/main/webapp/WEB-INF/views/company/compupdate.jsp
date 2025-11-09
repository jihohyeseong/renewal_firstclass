<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/comp.css">

  <!-- 신청서 폼 디자인과 동일한 공통 스타일 -->
  <style>
    /* 타이틀 */
    h1{ text-align:center; margin-bottom:30px; font-size:28px; }
    h2{
      color:var(--primary-color); border-bottom:2px solid var(--primary-light-color,#f0f2ff);
      padding-bottom:10px; margin-bottom:25px; font-size:20px;
    }

    /* 섹션 */
    .form-section{ margin-bottom:40px; }
    .form-section + .form-section{ border-top:1px solid var(--border-color,#dee2e6); padding-top:30px; }

    /* 폼 라인: 신청서와 동일한 그리드 레이아웃 */
    .form-group{
      display: grid !important;
      grid-template-columns: 200px minmax(0,1fr) !important;
      align-items: flex-start !important;
      gap: 20px !important;
      margin-bottom: 20px !important;
    }
    .form-group .field-title{
      width: auto !important;
      padding-top: 10px !important;
    }
    .form-group .input-field{ min-width: 0 !important; }

    /* 인풋 공통 */
    .input-field input[type="text"],
    .input-field input[type="date"],
    .input-field input[type="number"],
    .input-field input[type="password"],
    .input-field select{
      width:100%; padding:10px; border:1px solid var(--border-color,#dee2e6);
      border-radius:6px; transition:.2s;
    }
    .input-field input:focus, .input-field select:focus{
      border-color:var(--primary-color); box-shadow:0 0 0 3px rgba(63,88,212,.15); outline:none;
    }
    .readonly-like, .input-field input[readonly], .input-field input:disabled{
      background:var(--light-gray-color,#f8f9fa); cursor:not-allowed;
    }

    /* 버튼 */
    .btn{
      display:inline-block; padding:10px 20px; font-size:15px; font-weight:500; border-radius:8px;
      border:1px solid var(--border-color,#dee2e6); cursor:pointer; transition:.2s; text-align:center;
    }
    .btn-primary{ background:var(--primary-color); color:#fff; border-color:var(--primary-color); }
    .btn-primary:hover{ filter:brightness(.95); transform:translateY(-2px); box-shadow: var(--shadow-md,0 4px 8px rgba(0,0,0,.07)); }
    .btn-secondary{ background:#fff; color:var(--gray-color,#868e96); }
    .btn-secondary:hover{ background:var(--light-gray-color,#f8f9fa); color:var(--dark-gray-color,#343a40); }

    .submit-button-container{ text-align:center; margin-top:30px; display:flex; gap:10px; justify-content:center; }
    .submit-button{ padding:12px 30px; font-size:1.1em; }

    .radio-group, .checkbox-group{ display:flex; align-items:center; gap:15px; }

    /* 안내박스 & 센터 디스플레이 */
    .info-box{
      background:var(--primary-light-color,#f0f2ff); border:1px solid #d1d9ff; padding:15px; margin-top:10px; border-radius:6px; font-size:14px;
    }
    .center-display-box{
      background:#fff; border:2px dashed var(--border-color,#dee2e6); padding:20px; min-height:100px; transition:.3s; text-align:center;
      display:flex; justify-content:center; align-items:center;
    }
    .center-display-box:not(.filled)::before{
      content:'센터 찾기 버튼을 클릭하여 관할 센터를 선택하세요.'; font-style:italic; color:var(--gray-color,#868e96); font-size:15px;
    }
    .center-display-box:not(.filled) p{ display:none; }
    .center-display-box.filled{
      background:var(--primary-light-color,#f0f2ff); border-style:solid; border-color:#d1d9ff; text-align:left; display:block;
    }
    .center-display-box.filled p{ display:block; }

    /* 동적 월별 행 */
    .dynamic-form-container{ margin-top:10px; border-top:1px solid var(--border-color,#dee2e6); padding-top:10px; }
    .dynamic-form-row{ display:flex; align-items:center; gap:15px; padding:10px; border-radius:6px; margin-bottom:10px; }
    .dynamic-form-row:nth-child(odd){ background:var(--primary-light-color,#f0f2ff); }
    .date-range-display{ font-weight:500; flex-basis:300px; flex-shrink:0; text-align:center; }
    .payment-input-field{ flex:1; display:flex; justify-content:flex-end; }
  </style>

  <title>육아휴직 확인서 제출(수정)</title>
</head>
<body>

<%@ include file="compheader.jsp" %>

<main class="main-container">
  <div class="content-wrapper">
    <h1>육아휴직 확인서 제출</h1>

    <form id="confirm-form"
          action="${pageContext.request.contextPath}/comp/update?confirmNumber=${confirmDTO.confirmNumber}"
          method="post">
      <input type="hidden" id="confirm-number" name="confirmNumber" value="${confirmDTO.confirmNumber}"/>
      <sec:csrfInput />

      <!-- 근로자 정보 -->
      <div class="form-section">
        <h2>근로자 정보</h2>
        <div class="form-group">
          <label class="field-title" for="employee-name">근로자 성명</label>
          <div class="input-field">
            <input type="text" id="employee-name" name="name"
                   value="${confirmDTO.name}" placeholder="이름 검색 버튼을 누르면 자동으로 채워집니다." readonly/>
          </div>
        </div>
        <div class="form-group">
          <label class="field-title" for="employee-rrn-a">근로자 주민등록번호</label>
          <div class="input-field" style="display:flex; align-items:center; gap:10px;">
            <input type="text" id="employee-rrn-a" maxlength="6"
                   value="${fn:substring(confirmDTO.registrationNumber,0,6)}"
                   placeholder="앞 6자리" style="flex:1;">
            <span class="hyphen">-</span>
            <input type="password" id="employee-rrn-b" maxlength="7"
                   value="${fn:substring(confirmDTO.registrationNumber,6,13)}"
                   placeholder="뒤 7자리" style="flex:1;">
            <input type="hidden" name="registrationNumber" id="employee-rrn-hidden">
            <button type="button" id="find-employee-btn" class="btn btn-secondary" style="white-space:nowrap;">
		      	이름 검색
		    </button>
          </div>
        </div>
      </div>

      <!-- 대상 자녀 정보 (신청서와 동일한 레이아웃) -->
      <div class="form-section">
        <h2>대상 자녀 정보</h2>

        <!-- 서버 넘길 실제 필드 -->
        <input type="hidden" name="childBirthDate" id="childBirthDateHidden"
               value="<fmt:formatDate value='${confirmDTO.childBirthDate}' pattern='yyyy-MM-dd'/>"/>

        <div class="form-group">
          <label class="field-title" for="child-date">출산(예정)일</label>
          <div class="input-field">
            <input type="date" id="child-date"
                   value="<fmt:formatDate value='${confirmDTO.childBirthDate}' pattern='yyyy-MM-dd'/>"
                   min="1900-01-01" max="2200-12-31">
            <small style="color:#666; display:block; margin-top:8px;">
              ※ 출산 전일시 출산(예정)일만 입력해주세요.
            </small>
          </div>
        </div>

        <div id="born-fields">
          <div class="form-group">
            <label class="field-title" for="child-name">  자녀 이름 </label>
            <div class="input-field">
              <input type="text" id="child-name" name="childName"
                     value="${confirmDTO.childName}">
            </div>
          </div>

          <div class="form-group">
            <label class="field-title" for="child-rrn-a">  자녀 주민등록번호   </label>
            <div class="input-field"
                 style="display:flex; align-items:center; gap:12px; flex-wrap:nowrap; width:100%;">
              <input type="text" id="child-rrn-a" maxlength="6"
                     value="${fn:substring(confirmDTO.childResiRegiNumber,0,6)}"
                     placeholder="앞 6자리" style="flex:1 1 0;">
              <span class="hyphen" style="flex:0 0 auto;">-</span>
              <input type="password" id="child-rrn-b" maxlength="7"
                     value="${fn:substring(confirmDTO.childResiRegiNumber,6,13)}"
                     placeholder="뒤 7자리" style="flex:1 1 0;">
              <input type="hidden" name="childResiRegiNumber" id="child-rrn-hidden">

              <!-- 오른쪽 정렬 체크 -->
              <label class="checkbox-group"
                     style="margin-left:auto; display:flex; align-items:center; gap:8px; white-space:nowrap;">
                <input type="checkbox" id="pregnant-leave" name="pregnantLeave"
                       <c:if test="${empty confirmDTO.childBirthDate}">checked</c:if> >
                <span>임신 중 육아휴직</span>
              </label>
            </div>
          </div>

          <div class="form-group">
            <div class="field-title"></div>
            <div class="input-field">
              <label class="checkbox-group" style="display:flex; align-items:flex-start; gap:8px;">
                <input type="checkbox" id="no-rrn-foreign" name="childRrnUnverified"
                       <c:if test="${empty confirmDTO.childResiRegiNumber}">checked</c:if> >
                <span>해외자녀 등 영아 주민등록번호가 미발급되어 확인되지 않는 경우에만 체크합니다</span>
              </label>
            </div>
          </div>
        </div>
      </div>

      <!-- 육아휴직 및 지급액 -->
      <div class="form-section">
        <h2>육아휴직 및 지급액 정보</h2>

        <div class="form-group">
          <label class="field-title" for="start-date">육아휴직 기간</label>
          <div class="input-field" style="display:flex; align-items:center; gap:10px;">
            <input type="date" id="start-date" name="startDate" style="flex:1;"
                   value="<fmt:formatDate value='${confirmDTO.startDate}' pattern='yyyy-MM-dd'/>"
                   min="1900-01-01" max="2200-12-31">
            <span>~</span>
            <input type="date" id="end-date" name="endDate" style="flex:1;"
                   value="<fmt:formatDate value='${confirmDTO.endDate}' pattern='yyyy-MM-dd'/>"
                   min="1900-01-01" max="2200-12-31">
          </div>
        </div>

        <div class="form-group">
          <label class="field-title">단위기간별 지급액</label>
          <div class="input-field">
            <div style="display:flex; align-items:center; gap:10px;">
              <button type="button" id="generate-forms-btn" class="btn btn-secondary">기간 나누기</button>
              <label id="no-payment-wrapper"
                     style="display:none; align-items:center; gap:6px; margin-left:8px;">
                <input type="checkbox" id="no-payment" name="noPayment"> 사업장 지급액 없음
              </label>
            </div>
            <small style="color:#666; display:block; margin-top:8px;">
              ※ 기간 입력 후 '기간 나누기'를 클릭하여 월별 지급액을 입력하세요.
            </small>
          </div>
        </div>

        <!-- 헤더 행(신청서 동일 룩) -->
        <div id="dynamic-header-row" class="dynamic-form-row"
             style="display:none; background:transparent; border-bottom:2px solid var(--border-color); font-weight:500; margin-bottom:0;">
          <div class="date-range-display"><span>신청기간</span></div>
          <div class="payment-input-field" style="padding-right:150px;"><span>사업장 지급액(원)</span></div>
        </div>

        <div id="dynamic-forms-container" class="dynamic-form-container">
          <!-- 기존 저장된 단위기간을 신청서와 동일한 마크업으로 복원 -->
          <c:forEach var="t" items="${confirmDTO.termAmounts}">
            <div class="dynamic-form-row">
              <div class="date-range-display">
                <fmt:formatDate value="${t.startMonthDate}" pattern="yyyy.MM.dd"/> ~
                <fmt:formatDate value="${t.endMonthDate}" pattern="yyyy.MM.dd"/>
              </div>
              <div class="payment-input-field">
                <div class="input-field" style="width:70%;">
                  <input type="text" name="monthlyCompanyPay"
                         value="${t.companyPayment}" placeholder="사업장 지급액(원)" autocomplete="off"/>
                </div>
              </div>
            </div>
          </c:forEach>
        </div>

        <div class="form-group">
          <label class="field-title" for="weeklyHours">월 소정근로시간</label>
          <div class="input-field">
            <input type="number" id="weeklyHours" name="weeklyHours"
                   value="${confirmDTO.weeklyHours}" placeholder="예: 209">
          </div>
        </div>

        <div class="form-group">
          <label class="field-title" for="regularWage">통상임금 (월)</label>
          <div class="input-field">
            <input type="text" id="regularWage" name="regularWage"
                   value="${confirmDTO.regularWage}" placeholder="숫자만 입력" autocomplete="off">
          </div>
        </div>
      </div>

      <!-- 접수 센터 선택 -->
      <div class="form-section">
        <h2>접수 센터 선택</h2>
        <div class="form-group">
          <label class="field-title">접수센터 기준</label>
          <div class="input-field radio-group">
            <input type="radio" id="center-work" name="center" value="work" checked disabled>
            <label for="center-work">사업장 주소</label>
            <button type="button" id="find-center-btn" class="btn btn-primary" style="margin-left:10px;">센터 찾기</button>
          </div>
        </div>

        <div class="info-box center-display-box ${not empty confirmDTO.centerId ? 'filled' : ''}">
          <p><strong>관할센터:</strong> <span id="center-name-display">${confirmDTO.centerName}</span></p>
          <p><strong>대표전화:</strong> <span id="center-phone-display">${confirmDTO.centerPhoneNumber}</span></p>
          <p><strong>주소:</strong> <span id="center-address-display">[${confirmDTO.centerZipCode}] ${applicationDetailDTO.centerAddressBase} ${applicationDetailDTO.centerAddressDetail}</span></p>
        </div>
        <input type="hidden" name="centerId" id="centerId" value="${confirmDTO.centerId}">
      </div>

      <!-- 확인서 작성자 -->
      <div class="form-section">
        <h2>확인서 작성자 정보</h2>
        <div class="form-group">
          <label class="field-title" for="response-name">담당자 이름</label>
          <div class="input-field">
            <input type="text" id="response-name" name="responseName"
                   value="${confirmDTO.responseName}">
          </div>
        </div>
        <div class="form-group">
          <label class="field-title" for="response-phone">담당자 전화번호</label>
          <div class="input-field">
            <input type="text" id="response-phone" name="responsePhoneNumber"
                   value="${confirmDTO.responsePhoneNumber}" readonly>
          </div>
        </div>
      </div>
      
<!-- 첨부파일 (신청페이지와 동일 4박스, 각 박스에 기존 파일도 함께 표시) -->
<div class="form-section">
  <h2>첨부파일</h2>
  <input type="hidden" id="fileId" name="fileId" value="${confirmDTO.fileId}" />

  <c:set var="TYPE_WAGE" value="WAGE_PROOF"/>
  <c:set var="TYPE_PAY"  value="PAYMENT_FROM_EMPLOYER"/>
  <c:set var="TYPE_OTHER" value="OTHER"/>
  <c:set var="TYPE_ELIG" value="ELIGIBILITY_PROOF"/>

  <%-- 공통: 파일명 추출 유틸(경로 → 파일명) --%>
  <c:set var="__normTmp" value=""/>

  <%-- 1) 통상임금 증명자료 --%>
  <div class="form-group">
    <label class="field-title">통상임금을 확인할 수 있는 증명자료(임금대장, 근로계약서 등)</label>
    <div class="input-field">
      <input type="hidden" name="fileTypes" value="${TYPE_WAGE}">
      <input type="file" name="files" id="files_${TYPE_WAGE}" multiple
             accept=".pdf,.jpg,.jpeg,.png,.heic,.gif,.bmp,.tif,.tiff,.hwp,.hwpx,.doc,.docx,.xls,.xlsx">

      <div class="info-box" style="margin-top:8px;">
        <!-- 기존 파일 -->
        <div class="existed-list" id="exist_${TYPE_WAGE}" style="margin-bottom:6px;">
          <c:forEach var="f" items="${files}">
            <c:if test="${f.fileType == TYPE_WAGE}">
              <div class="file-chip" data-seq="${f.sequence}" style="display:flex; align-items:center; gap:8px; margin:4px 0;">
                <span class="chip-label" style="flex:1; word-break:break-all;">
                  <c:set var="__norm"  value="${fn:replace(f.fileUrl, '\\\\', '/')}"/>
                  <c:set var="__parts" value="${fn:split(__norm, '/')}"/>
                  ${__parts[fn:length(__parts)-1]}
                </span>
                <button type="button" class="btn btn-secondary btn-sm btn-del-exist" data-type="${TYPE_WAGE}" data-seq="${f.sequence}">
                  삭제
                </button>
              </div>
            </c:if>
          </c:forEach>
        </div>
        <!-- 새로 선택됨 미리보기 -->
        <div class="selected-list" id="sel_${TYPE_WAGE}" style="border-top:1px dashed #d9d9d9; padding-top:6px;">
          <em style="color:#666;">선택된 파일 없음</em>
        </div>
      </div>
    </div>
  </div>

  <%-- 2) 사업주 금품 지급 확인 자료 --%>
  <div class="form-group">
    <label class="field-title">육아휴직 기간 동안 사업주로부터 금품을 지급받은 경우 확인 자료</label>
    <div class="input-field">
      <input type="hidden" name="fileTypes" value="${TYPE_PAY}">
      <input type="file" name="files" id="files_${TYPE_PAY}" multiple
             accept=".pdf,.jpg,.jpeg,.png,.heic,.gif,.bmp,.tif,.tiff,.hwp,.hwpx,.doc,.docx,.xls,.xlsx">
      <div class="info-box" style="margin-top:8px;">
        <div class="existed-list" id="exist_${TYPE_PAY}" style="margin-bottom:6px;">
          <c:forEach var="f" items="${files}">
            <c:if test="${f.fileType == TYPE_PAY}">
              <div class="file-chip" data-seq="${f.sequence}" style="display:flex; align-items:center; gap:8px; margin:4px 0;">
                <span class="chip-label" style="flex:1; word-break:break-all;">
                  <c:set var="__norm"  value="${fn:replace(f.fileUrl, '\\\\', '/')}"/>
                  <c:set var="__parts" value="${fn:split(__norm, '/')}"/>
                  ${__parts[fn:length(__parts)-1]}
                </span>
                <button type="button" class="btn btn-secondary btn-sm btn-del-exist" data-type="${TYPE_PAY}" data-seq="${f.sequence}">
                  삭제
                </button>
              </div>
            </c:if>
          </c:forEach>
        </div>
        <div class="selected-list" id="sel_${TYPE_PAY}" style="border-top:1px dashed #d9d9d9; padding-top:6px;">
          <em style="color:#666;">선택된 파일 없음</em>
        </div>
      </div>
    </div>
  </div>

  <%-- 3) 기타 --%>
  <div class="form-group">
    <label class="field-title">기타 자료</label>
    <div class="input-field">
      <input type="hidden" name="fileTypes" value="${TYPE_OTHER}">
      <input type="file" name="files" id="files_${TYPE_OTHER}" multiple
             accept=".pdf,.jpg,.jpeg,.png,.heic,.gif,.bmp,.tif,.tiff,.hwp,.hwpx,.doc,.docx,.xls,.xlsx">
      <div class="info-box" style="margin-top:8px;">
        <div class="existed-list" id="exist_${TYPE_OTHER}" style="margin-bottom:6px;">
          <c:forEach var="f" items="${files}">
            <c:if test="${f.fileType == TYPE_OTHER}">
              <div class="file-chip" data-seq="${f.sequence}" style="display:flex; align-items:center; gap:8px; margin:4px 0;">
                <span class="chip-label" style="flex:1; word-break:break-all;">
                  <c:set var="__norm"  value="${fn:replace(f.fileUrl, '\\\\', '/')}"/>
                  <c:set var="__parts" value="${fn:split(__norm, '/')}"/>
                  ${__parts[fn:length(__parts)-1]}
                </span>
                <button type="button" class="btn btn-secondary btn-sm btn-del-exist" data-type="${TYPE_OTHER}" data-seq="${f.sequence}">
                  삭제
                </button>
              </div>
            </c:if>
          </c:forEach>
        </div>
        <div class="selected-list" id="sel_${TYPE_OTHER}" style="border-top:1px dashed #d9d9d9; padding-top:6px;">
          <em style="color:#666;">선택된 파일 없음</em>
        </div>
      </div>
    </div>
  </div>

  <%-- 4) 자격 확인 자료 --%>
  <div class="form-group">
    <label class="field-title">자격 확인 자료(배우자 3개월 이상 육휴/한부모/중증장애아동 부모 등)</label>
    <div class="input-field">
      <input type="hidden" name="fileTypes" value="${TYPE_ELIG}">
      <input type="file" name="files" id="files_${TYPE_ELIG}" multiple
             accept=".pdf,.jpg,.jpeg,.png,.heic,.gif,.bmp,.tif,.tiff,.hwp,.hwpx,.doc,.docx,.xls,.xlsx">
      <div class="info-box" style="margin-top:8px;">
        <div class="existed-list" id="exist_${TYPE_ELIG}" style="margin-bottom:6px;">
          <c:forEach var="f" items="${files}">
            <c:if test="${f.fileType == TYPE_ELIG}">
              <div class="file-chip" data-seq="${f.sequence}" style="display:flex; align-items:center; gap:8px; margin:4px 0;">
                <span class="chip-label" style="flex:1; word-break:break-all;">
                  <c:set var="__norm"  value="${fn:replace(f.fileUrl, '\\\\', '/')}"/>
                  <c:set var="__parts" value="${fn:split(__norm, '/')}"/>
                  ${__parts[fn:length(__parts)-1]}
                </span>
                <button type="button" class="btn btn-secondary btn-sm btn-del-exist" data-type="${TYPE_ELIG}" data-seq="${f.sequence}">
                  삭제
                </button>
              </div>
            </c:if>
          </c:forEach>
        </div>
        <div class="selected-list" id="sel_${TYPE_ELIG}" style="border-top:1px dashed #d9d9d9; padding-top:6px;">
          <em style="color:#666;">선택된 파일 없음</em>
        </div>
      </div>
    </div>
  </div>
</div>


      <div class="submit-button-container">
        <a href="${pageContext.request.contextPath}/comp/main"
           class="btn submit-button" style="background:#6c757d; border-color:#6c757d; color:#fff;">목록으로</a>
        <button type="submit" class="btn btn-primary submit-button">저장하기</button>
      </div>
    </form>
  </div>
</main>

<%@ include file="/WEB-INF/views/conponent/centerModal.jsp" %>

<footer class="footer">
  <p>&copy; 2025 육아휴직 서비스. All Rights Reserved.</p>
</footer>

<script type="text/javascript">
document.addEventListener('DOMContentLoaded', function () {

  // ─────────────────────────────────────
  // 공통 유틸 & 입력 바인딩
  // ─────────────────────────────────────
  function withCommas(s){ return String(s).replace(/\B(?=(\d{3})+(?!\d))/g, ','); }
  function onlyDigits(s){ return (s||'').replace(/[^\d]/g,''); }
  function bindDigitsOnly(el){ if(el) el.addEventListener('input', () => { el.value = (el.value || '').replace(/[^\d]/g, ''); }); }

  function allowDigitsAndCommas(el, maxDigits) {
    if (!el) return;
    function format() {
      const originalValue = onlyDigits(el.value).substring(0, maxDigits);
      el.value = withCommas(originalValue);
    }
    el.addEventListener('input', format);
    format();
  }

  // 날짜 입력: 신청페이지와 동일한 마스크/정규화
  function normalizeDate(el){
    if (!el) return;
    el.addEventListener('blur', () => {
      const raw = el.value || '';
      const digits = raw.replace(/[^\d]/g, '');
      if (digits.length >= 8) {
        const y = digits.slice(0,4);
        const m = digits.slice(4,6);
        const d = digits.slice(6,8);
        const next = `${y}-${m}-${d}`;
        if (/^\d{4}-\d{2}-\d{2}$/.test(next)) el.value = next;
      }
    });
  }
  function bindYMDMask(el){
    if (!el) return;
    el.addEventListener('input', () => {
      const digits = (el.value || '').replace(/[^\d]/g, '').slice(0, 8);
      const y = digits.slice(0, 4);
      const m = digits.slice(4, 6);
      const d = digits.slice(6, 8);
      el.value = [y, m, d].filter(Boolean).join('-');
    });
  }

  const weeklyEl = document.getElementById('weeklyHours');
  if (weeklyEl) {
    weeklyEl.addEventListener('input', () => {
      weeklyEl.value = (weeklyEl.value || '').replace(/[^\d]/g, '').slice(0, 3);
    });
  }

  ['child-date','start-date','end-date'].forEach(id => {
    const el = document.getElementById(id);
    normalizeDate(el);
    bindYMDMask(el);
  });

  allowDigitsAndCommas(document.getElementById('regularWage'), 19);
  bindDigitsOnly(document.getElementById('weeklyHours'));
  bindDigitsOnly(document.getElementById('response-phone'));
  bindDigitsOnly(document.getElementById('employee-rrn-a'));
  bindDigitsOnly(document.getElementById('employee-rrn-b'));
  bindDigitsOnly(document.getElementById('child-rrn-a'));
  bindDigitsOnly(document.getElementById('child-rrn-b'));

  // ─────────────────────────────────────
  // 기간 생성 관련 엘리먼트
  // ─────────────────────────────────────
  var startDateInput   = document.getElementById('start-date');
  var endDateInput     = document.getElementById('end-date');
  var generateBtn      = document.getElementById('generate-forms-btn');
  var formsContainer   = document.getElementById('dynamic-forms-container');
  var noPaymentChk     = document.getElementById('no-payment');
  var noPaymentWrapper = document.getElementById('no-payment-wrapper');
  var headerRow        = document.getElementById('dynamic-header-row');

  function parseDate(s){ return s ? new Date(s + 'T00:00:00') : null; }
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
  function resetPeriodUI(){
    formsContainer.innerHTML = '';
    if (noPaymentWrapper) noPaymentWrapper.style.display = 'none';
    if (headerRow) headerRow.style.display = 'none';
  }

  // ─────────────────────────────────────
  // 버튼 클릭 시에만 강력 검증 (신청페이지 로직)
  // ─────────────────────────────────────
  function guardBeforeGenerate() {
    const chkPregnant = document.getElementById('pregnant-leave');
    const chkNoRRN    = document.getElementById('no-rrn-foreign');
    const childDateEl = document.getElementById('child-date');
    const childNameEl = document.getElementById('child-name');
    const rrnA        = document.getElementById('child-rrn-a');
    const rrnB        = document.getElementById('child-rrn-b');

    const isPregnant = !!chkPregnant?.checked;
    const noRRN      = !!chkNoRRN?.checked;

    const childDate  = parseDate(childDateEl?.value);
    const startDate  = parseDate(startDateInput?.value);
    const endDate    = parseDate(endDateInput?.value);

    if (!startDate || !endDate) { alert('육아휴직 시작일과 종료일을 먼저 선택해 주세요.'); return false; }
    if (!childDate) { alert('출산(예정)일을 먼저 입력해 주세요.'); return false; }

    if (isPregnant) {
      if (endDate >= childDate) { alert('임신 중 육아휴직은 출산(예정)일 전날까지만 가능합니다.'); return false; }
      if (startDate >= childDate) { alert('임신 중 육아휴직은 출산(예정)일 이전에만 시작할 수 있습니다.'); return false; }
    } else {
      const nameVal = (childNameEl?.value || '').trim();
      const a = (rrnA?.value || '').replace(/[^\d]/g,'');
      const b = (rrnB?.value || '').replace(/[^\d]/g,'');
      if (!nameVal) { alert('출산 후 신청 시 자녀 이름을 입력해야 합니다.'); childNameEl?.focus(); return false; }
      if (!noRRN && !(a.length === 6 && b.length === 7)) {
        alert('출산 후 신청 시 자녀 주민등록번호(앞 6자리/뒤 7자리)를 반드시 입력해야 합니다.');
        (a.length !== 6 ? rrnA : rrnB)?.focus();
        return false;
      }
      if (startDate < childDate) { alert('출산 후 육아휴직은 출산(예정)일 이후로만 시작할 수 있습니다.'); return false; }
    }
    return true;
  }

  // 입력 중엔 소프트 규칙(힌트만, alert/reset 없음)
  (function applyPregnancyRulesSoft() {
    const chkPregnant = document.getElementById('pregnant-leave');
    const chkNoRRN    = document.getElementById('no-rrn-foreign');
    const childDateEl = document.getElementById('child-date');
    const childNameEl = document.getElementById('child-name');
    const rrnA        = document.getElementById('child-rrn-a');
    const rrnB        = document.getElementById('child-rrn-b');

    const ymd = (d) => {
      const y = d.getFullYear();
      const m = String(d.getMonth() + 1).padStart(2, '0');
      const day = String(d.getDate()).padStart(2, '0');
      return `${y}-${m}-${day}`;
    };
    function toggleDisabled(el, on) {
      if (!el) return;
      el.disabled = !!on;
      el.classList.toggle('readonly-like', !!on);
      if (on) el.value = '';
    }
    function enforceDateBoundsSoft() {
      const isPregnant = !!chkPregnant?.checked;
      const childDate  = parseDate(childDateEl?.value);
      startDateInput?.removeAttribute('min');
      startDateInput?.removeAttribute('max');
      endDateInput?.removeAttribute('min');
      endDateInput?.removeAttribute('max');
      if (!childDate) return;
      if (isPregnant) {
        const last = new Date(childDate); last.setDate(last.getDate() - 1);
        endDateInput && (endDateInput.max = ymd(last));
      } else {
        startDateInput && (startDateInput.min = ymd(childDate));
      }
    }
    function applyFieldLockByMode() {
      const isPregnant = !!chkPregnant?.checked;
      if (isPregnant) {
        toggleDisabled(childNameEl, true);
        toggleDisabled(rrnA, true);
        toggleDisabled(rrnB, true);
        if (chkNoRRN) { chkNoRRN.checked = false; toggleDisabled(chkNoRRN, true); }
      } else {
        toggleDisabled(childNameEl, false);
        toggleDisabled(chkNoRRN, false);
        const noRRN = !!chkNoRRN?.checked;
        toggleDisabled(rrnA, noRRN);
        toggleDisabled(rrnB, noRRN);
      }
    }
    function onAnyChangeSoft() {
      applyFieldLockByMode();
      enforceDateBoundsSoft();
    }
    chkPregnant?.addEventListener('change', onAnyChangeSoft);
    childDateEl?.addEventListener('change', onAnyChangeSoft);
    startDateInput?.addEventListener('change', onAnyChangeSoft);
    endDateInput?.addEventListener('change', onAnyChangeSoft);
    chkNoRRN?.addEventListener('change', function(){
      if (chkPregnant?.checked) return;
      const noRRN = !!chkNoRRN?.checked;
      toggleDisabled(rrnA, noRRN);
      toggleDisabled(rrnB, noRRN);
    });
    onAnyChangeSoft(); // 초기 1회
  })();

  // 시작/종료일 변경 시 UI만 초기화
  startDateInput.addEventListener('change', function () {
    if (startDateInput.value) endDateInput.min = startDateInput.value;
    else endDateInput.removeAttribute('min');
    resetPeriodUI();
  });
  endDateInput.addEventListener('change', function () { resetPeriodUI(); });

  // ─────────────────────────────────────
  // 기간 나누기 버튼
  // ─────────────────────────────────────
  generateBtn.addEventListener('click',  async function() {
    // 0) 이전 확인서 겹침 먼저 체크(이름/주민번호 미입력 시 안내)
    const okPrev = await showPrevPeriodAlert();
    if (!okPrev) { resetPeriodUI(); return; }

    // 1) 임신/출산 강력 검증
    if (!guardBeforeGenerate()) { resetPeriodUI(); return; }

    // 2) 기본 날짜 존재/역전
    if (!startDateInput.value || !endDateInput.value) {
      alert('육아휴직 시작일과 종료일을 모두 선택해주세요.');
      resetPeriodUI(); return;
    }
    const originalStartDate = parseDate(startDateInput.value);
    const finalEndDate      = parseDate(endDateInput.value);
    if (originalStartDate > finalEndDate) {
      alert('종료일은 시작일보다 빠를 수 없습니다.');
      resetPeriodUI(); return;
    }

    // 3) 최소 1개월 / 최대 12개월
    const firstPeriodEndDate = getPeriodEndDate(originalStartDate, 1);
    if (finalEndDate < firstPeriodEndDate) {
      alert('신청 기간은 최소 1개월 이상이어야 합니다.');
      resetPeriodUI(); return;
    }
    let monthCount = (finalEndDate.getFullYear() - originalStartDate.getFullYear()) * 12;
    monthCount -= originalStartDate.getMonth();
    monthCount += finalEndDate.getMonth();
    if (finalEndDate.getDate() >= originalStartDate.getDate()) monthCount++;
    if (monthCount > 12) {
      alert('최대 12개월까지만 신청 가능합니다. 종료일을 조정해주세요.');
      resetPeriodUI(); return;
    }

    // 4) 행 생성
    formsContainer.innerHTML = '';
    if (noPaymentWrapper) noPaymentWrapper.style.display = 'none';
    if (headerRow) headerRow.style.display = 'none';

    let currentPeriodStart = new Date(originalStartDate);
    let monthIdx = 1;

    while (currentPeriodStart <= finalEndDate && monthIdx <= 12) {
      const theoreticalEndDate = getPeriodEndDate(originalStartDate, monthIdx);
      let actualPeriodEnd = new Date(theoreticalEndDate);
      if (actualPeriodEnd > finalEndDate) actualPeriodEnd = new Date(finalEndDate);
      if (currentPeriodStart > actualPeriodEnd) break;

      const rangeText = formatDate(currentPeriodStart) + ' ~ ' + formatDate(actualPeriodEnd);
      const row = document.createElement('div');
      row.className = 'dynamic-form-row';
      row.innerHTML =
        '<div class="date-range-display"><div>' + rangeText + '</div></div>' +
        '<div class="payment-input-field">' +
          '<div class="input-field" style="width:70%;">' +
            '<input type="text" name="monthlyCompanyPay" placeholder="사업장 지급액(원)" autocomplete="off" />' +
          '</div>' +
        '</div>';
      formsContainer.appendChild(row);

      formsContainer
        .querySelectorAll('input[name="monthlyCompanyPay"]')
        .forEach(inp => allowDigitsAndCommas(inp, 19));

      currentPeriodStart = new Date(actualPeriodEnd);
      currentPeriodStart.setDate(currentPeriodStart.getDate() + 1);
      monthIdx++;
    }

    if (headerRow) headerRow.style.display = formsContainer.children.length ? 'flex' : 'none';
    if (noPaymentWrapper) {
      noPaymentWrapper.style.display = 'flex';
      applyNoPaymentState();
    }
  });

  function applyNoPaymentState() {
    const inputs = formsContainer.querySelectorAll('input[name^="monthlyCompanyPay"]');
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
  if (noPaymentChk) noPaymentChk.addEventListener('change', applyNoPaymentState);

  // 출생(예정)일 hidden 동기화
  (function syncChildDateHidden(){
    const dateEl = document.getElementById('child-date');
    const hidden = document.getElementById('childBirthDateHidden');
    function sync(){ if (hidden) hidden.value = dateEl?.value || ''; }
    if (dateEl){ dateEl.addEventListener('change', sync); sync(); }
  })();

  // 저장 전 비동기 검증 + 파일 업로드 + 멀티파트 해제
  (function wireSubmitValidation(){
    const form = document.getElementById('confirm-form');
    if (!form) return;

    let submitting = false;

    form.addEventListener('submit', async function(e){
      e.preventDefault();
      if (submitting) return;
      submitting = true;

      try {
        const missing = [];
        let firstBadEl = null;
        function need(el, label){
          if (!el) return;
          const v = (el.value||'').trim();
          if (!v){ missing.push(label); if (!firstBadEl) firstBadEl = el; }
        }

        const empName   = document.getElementById('employee-name');
        const empA      = document.getElementById('employee-rrn-a');
        const empB      = document.getElementById('employee-rrn-b');
        const startDate = document.getElementById('start-date');
        const endDate   = document.getElementById('end-date');
        const weeklyEl  = document.getElementById('weeklyHours');
        const wageEl    = document.getElementById('regularWage');
        const childDate = document.getElementById('child-date');
        const respName  = document.getElementById('response-name');
        const centerId  = document.getElementById('centerId');

        need(empName,   '근로자 성명');
        need(startDate, '육아휴직 시작일');
        need(endDate,   '육아휴직 종료일');
        need(weeklyEl,  '월 소정근로시간');
        need(wageEl,    '통상임금(월)');
        need(childDate, '출산(예정)일');
        need(respName,  '담당자 이름');
        if (!centerId || !centerId.value.trim()) missing.push('처리 센터 선택');

        if (!empA || onlyDigits(empA.value).length !== 6) { missing.push('근로자 주민등록번호(앞 6자리)'); if (!firstBadEl) firstBadEl = empA; }
        if (!empB || onlyDigits(empB.value).length !== 7) { missing.push('근로자 주민등록번호(뒤 7자리)'); if (!firstBadEl) firstBadEl = empB; }

        const isPregnant = !!document.getElementById('pregnant-leave')?.checked;
        if (!isPregnant) {
          const nameEl = document.getElementById('child-name');
          const rrnA   = document.getElementById('child-rrn-a');
          const rrnB   = document.getElementById('child-rrn-b');
          const noRRN  = !!document.getElementById('no-rrn-foreign')?.checked;
          const nameVal = (nameEl?.value || '').trim();
          const a = onlyDigits(rrnA?.value);
          const b = onlyDigits(rrnB?.value);
          if (!nameVal) { missing.push('자녀 이름'); if (!firstBadEl) firstBadEl = nameEl; }
          if (!noRRN && !(a.length === 6 && b.length === 7)) { missing.push('자녀 주민등록번호'); if (!firstBadEl) firstBadEl = rrnA || rrnB; }
        }

        if (missing.length){
          const uniq = [...new Set(missing)];
          alert('모든 필수 항목을 입력해야 저장할 수 있습니다.\n\n누락 항목:\n- ' + uniq.join('\n- '));
          if (firstBadEl && typeof firstBadEl.focus === 'function') {
            firstBadEl.scrollIntoView({behavior:'smooth', block:'center'});
            setTimeout(()=> firstBadEl.focus(), 200);
          }
          submitting = false; return;
        }

        // 이전 확인서 겹침
        const okPrev = await showPrevPeriodAlert();
        if (!okPrev) { submitting = false; return; }

        // 숫자/주민번호/출생일 hidden 정리
        doFinalNormalizeBeforeSubmit();

        // 파일 업로드(수정: fileId 있으면 append)
        const up = await uploadAllFilesBeforeSubmit();
        if (!up.ok) {
          alert('파일 업로드 중 오류가 발생했습니다.');
          submitting = false; return;
        }
        let hidden = form.querySelector('input[name="fileId"]');
        if (!up.skipped) {
          if (!hidden) {
            hidden = document.createElement('input');
            hidden.type = 'hidden';
            hidden.name = 'fileId';
            form.appendChild(hidden);
          }
          hidden.value = String(up.fileId);
        } else {
          if (hidden && !hidden.value) hidden.remove();
        }

        // 멀티파트 해제 및 파일 input 제거
        stripFileInputsBeforeFinalSubmit(form);

        form.removeEventListener('submit', arguments.callee);
        form.submit();

      } catch (err) {
        console.error(err);
        alert('저장 처리 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
        submitting = false;
      }
    });
  })();

  // 엔터 제출 방지 (텍스트영역/버튼 제외)
  {
    const formEl = document.getElementById('confirm-form');
    if (formEl) {
      formEl.addEventListener('keydown', function (e) {
        if (e.key !== 'Enter') return;
        const el   = e.target;
        const tag  = el.tagName.toLowerCase();
        const type = (el.type || '').toLowerCase();
        const isTextArea = tag === 'textarea';
        const isButton   = tag === 'button' || (tag === 'input' && (type === 'submit' || type === 'button'));
        const allowAttr  = el.closest('[data-allow-enter="true"]');
        if (!isTextArea && !isButton && !allowAttr) e.preventDefault();
      });
    }
  }

  // 센터 찾기 모달 (기존 그대로)
  const findCenterBtn   = document.getElementById('find-center-btn');
  const centerModal     = document.getElementById('center-modal');
  const closeModalBtn   = centerModal?.querySelector('.close-modal-btn');
  const centerListBody  = document.getElementById('center-list-body');
  const centerNameEl    = document.getElementById('center-name-display');
  const centerPhoneEl   = document.getElementById('center-phone-display');
  const centerAddressEl = document.getElementById('center-address-display');
  const centerIdInput   = document.getElementById('centerId');

  function openModal()  { if (centerModal) centerModal.style.display = 'flex'; }
  function closeModal() { if (centerModal) centerModal.style.display = 'none'; }

  if (findCenterBtn) {
    findCenterBtn.addEventListener('click', function() {
      $.getJSON('${pageContext.request.contextPath}/center/list', function(list) {
        centerListBody.innerHTML = '';
        if (list && list.length > 0) {
          list.forEach(center => {
            const row = document.createElement('tr');
            const fullAddress = '[' + center.centerZipCode + '] ' + center.centerAddressBase + ' ' + (center.centerAddressDetail || '');
            row.innerHTML =
              '<td>' + center.centerName + '</td>' +
              '<td>' + fullAddress + '</td>' +
              '<td>' + center.centerPhoneNumber + '</td>' +
              '<td><button type="button" class="btn btn-primary btn-select-center">선택</button></td>';
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
    centerModal.addEventListener('click', function(e){ if (e.target === centerModal) closeModal(); });
  }
  if (centerListBody) {
    centerListBody.addEventListener('click', function(e) {
      if (!e.target.classList.contains('btn-select-center')) return;
      const btn = e.target;
      const data = btn.dataset;
      if (centerNameEl)    centerNameEl.textContent    = data.centerName;
      if (centerPhoneEl)   centerPhoneEl.textContent   = data.centerPhone;
      if (centerAddressEl) centerAddressEl.textContent = data.centerAddress;
      if (centerIdInput)   centerIdInput.value         = data.centerId;
      document.querySelector('.center-display-box')?.classList.add('filled');
      closeModal();
    });
  }

}); // DOMContentLoaded 끝

// ─────────────────────────────────────
// 직원 주민번호로 이름 자동 채우기
// ─────────────────────────────────────
(function wireFindName(){
  const btn   = document.getElementById('find-employee-btn');
  const aEl   = document.getElementById('employee-rrn-a');
  const bEl   = document.getElementById('employee-rrn-b');
  const nameEl= document.getElementById('employee-name');
  const hidEl = document.getElementById('employee-rrn-hidden');

  if (!btn || !aEl || !bEl) return;
  function onlyDigits(s){ return (s||'').replace(/[^\d]/g,''); }

  const ctx = '${pageContext.request.contextPath}';
  const url = ctx + '/comp/apply/find-name';

  btn.addEventListener('click', async function(){
    const a = onlyDigits(aEl.value);
    const b = onlyDigits(bEl.value);
    if (a.length !== 6 || b.length !== 7) {
      alert('근로자 주민등록번호 앞 6자리와 뒤 7자리를 정확히 입력하세요.');
      (a.length !== 6 ? aEl : bEl).focus();
      return;
    }
    const regNo = a + b;
    if (hidEl) hidEl.value = regNo;

    const csrfInput = document.querySelector('input[name="_csrf"]');
    const csrfToken = csrfInput ? csrfInput.value : null;

    try {
      const body = new URLSearchParams({ regNo });
      if (csrfToken) body.append('_csrf', csrfToken);

      const resp = await fetch(url, {
        method: 'POST',
        credentials: 'same-origin',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
          ...(csrfToken ? {'X-CSRF-TOKEN': csrfToken} : {})
        },
        body
      });

      const ct = (resp.headers.get('content-type') || '').toLowerCase();
      if (!resp.ok) { alert('이름 조회 요청에 실패했습니다. (' + resp.status + ')'); return; }
      if (!ct.includes('application/json')) { alert('서버 응답이 JSON이 아닙니다.'); return; }

      const data = await resp.json();
      if (data && data.found && data.name) nameEl.value = data.name;
      else alert('일치하는 근로자 정보를 찾을 수 없습니다.');
    } catch (e) {
      console.error(e);
      alert('일시적인 오류로 조회에 실패했습니다.');
    }
  });
})();

// ─────────────────────────────────────
// 이전 육휴기간(최신 1건) 조회 (수정페이지 전용: nowConfirmNumber 포함)
// ─────────────────────────────────────
async function showPrevPeriodAlert() {
  try {
    const nameEl = document.getElementById('employee-name');
    const aEl    = document.getElementById('employee-rrn-a');
    const bEl    = document.getElementById('employee-rrn-b');

    const name  = (nameEl?.value || '').trim();
    const regNo = ((aEl?.value || '') + (bEl?.value || '')).replace(/[^\d]/g, '');

    if (!name || regNo.length !== 13) {
      alert('근로자 성명과 주민등록번호(6+7)를 먼저 입력하세요.');
      window.prevPeriod = { start:null, end:null, overlap:false };
      return false;
    }

    const ncnStr = document.getElementById('confirm-number')?.value;
    const nowConfirmNumber =
      (ncnStr != null && ncnStr.trim() !== '' && !Number.isNaN(Number(ncnStr)))
        ? Number(ncnStr)
        : null;

    const csrfToken = document.querySelector('input[name="_csrf"]')?.value || null;
    const CTX = '${pageContext.request.contextPath}';

    const payload = { name, regNo };
    if (nowConfirmNumber != null) payload.nowConfirmNumber = nowConfirmNumber;

    const resp = await fetch(CTX + '/comp/apply/leave-period', {
      method: 'POST',
      credentials: 'same-origin',
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        ...(csrfToken ? { 'X-CSRF-TOKEN': csrfToken } : {} )
      },
      body: JSON.stringify(payload)
    });

    if (resp.status === 204) { window.prevPeriod = { start:null, end:null, overlap:false }; return true; }

    const ct = (resp.headers.get('content-type') || '').toLowerCase();
    if (!ct.includes('application/json')) { window.prevPeriod = { start:null, end:null, overlap:false }; return true; }

    const text = await resp.text();
    if (!resp.ok || !text) { window.prevPeriod = { start:null, end:null, overlap:false }; return true; }

    const data = JSON.parse(text) || {};
    function toDateSafe(v){
      if (v == null) return null;
      if (typeof v === 'number' || /^\d+$/.test(String(v))) {
        let n = Number(v); if (String(v).length === 10) n *= 1000;
        const d = new Date(n); return isNaN(d) ? null : d;
      }
      let s = String(v).trim();
      if (/^\d{4}-\d{2}-\d{2}$/.test(s)) s += 'T00:00:00';
      if (/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/.test(s)) s = s.replace(' ', 'T');
      const d1 = new Date(s); if (!isNaN(d1)) return d1;
      const d2 = new Date(s.replace(/-/g,'/')); return isNaN(d2) ? null : d2;
    }
    function two(n){ return (n<10?'0':'')+n; }
    function fmt(d){ return d.getFullYear()+'.'+two(d.getMonth()+1)+'.'+two(d.getDate()); }
    function parseInputDate(id){ const el = document.getElementById(id); return (el && el.value) ? new Date(el.value + 'T00:00:00') : null; }
    function isOverlap(aStart,aEnd,bStart,bEnd){ if (!aStart || !aEnd || !bStart || !bEnd) return false; return aStart <= bEnd && bStart <= aEnd; }

    const startRaw = data.startDate ?? data.STARTDATE ?? data.start_date;
    const endRaw   = data.endDate   ?? data.ENDDATE   ?? data.end_date;

    const prevS = toDateSafe(startRaw);
    const prevE = toDateSafe(endRaw);
    if (!prevS || !prevE) { window.prevPeriod = { start:null, end:null, overlap:false }; return true; }

    const curS = parseInputDate('start-date');
    const curE = parseInputDate('end-date');
    const overlapped = isOverlap(prevS, prevE, curS, curE);

    window.prevPeriod = { start: prevS, end: prevE, overlap: overlapped };

    if (overlapped) {
      alert(
        '해당 근무자는 이미 존재하는 확인서와 육아휴직 기간이 겹칩니다.\n\n' +
        '이전 확인서: ' + fmt(prevS) + ' ~ ' + fmt(prevE) + '\n' +
        '현재 입력하신 기간: ' + (curS ? fmt(curS) : '-') + ' ~ ' + (curE ? fmt(curE) : '-')
      );
      return false;
    }
    return true;

  } catch (e) {
    console.error(e);
    window.prevPeriod = { start:null, end:null, overlap:false };
    return true; // 조회 실패 시 진행 허용(UX)
  }
}

// ─────────────────────────────────────
// 파일 UI: 같은 박스에서 "기존 + 새 선택 파일" 함께 표시
// ─────────────────────────────────────
(function bindUnifiedFileUI(){
  const groups = [
    { id: 'files_WAGE_PROOF',              selList: 'sel_WAGE_PROOF' },
    { id: 'files_PAYMENT_FROM_EMPLOYER',   selList: 'sel_PAYMENT_FROM_EMPLOYER' },
    { id: 'files_OTHER',                   selList: 'sel_OTHER' },
    { id: 'files_ELIGIBILITY_PROOF',       selList: 'sel_ELIGIBILITY_PROOF' }
  ];
  function fileNiceName(f){
    if (f && typeof f.name === 'string' && f.name.trim() !== '') return f.name;
    if (f && typeof f.webkitRelativePath === 'string' && f.webkitRelativePath.trim() !== '') {
      const parts = f.webkitRelativePath.split('/'); return parts[parts.length - 1] || '파일';
    }
    return '파일';
  }
  function fileNiceSizeMB(f){ if (!f || typeof f.size !== 'number' || isNaN(f.size)) return '?'; return (f.size / (1024 * 1024)).toFixed(1); }
  function escapeHtml(s){ return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;').replace(/'/g,'&#39;'); }

  groups.forEach(g => {
    const inp = document.getElementById(g.id);
    const out = document.getElementById(g.selList);
    if(!inp || !out) return;
    inp.addEventListener('change', ()=>{
      const fl = inp.files;
      if (!fl || fl.length === 0) {
        out.innerHTML = '<em style="color:#666;">선택된 파일 없음</em>';
        return;
      }
      const rows = [];
      for (const f of fl) {
        const name = escapeHtml(fileNiceName(f));
        const mb   = fileNiceSizeMB(f);
        const sizeSuffix = (mb !== '?') ? ' (' + mb + 'MB)' : '';
        rows.push(
          '<div class="file-chip" style="display:flex; align-items:center; gap:8px; margin:4px 0;">' +
            '<span class="chip-label" style="flex:1; word-break:break-all;">' + name + sizeSuffix + '</span>' +
            '<span style="font-size:12px; color:#888;">새로 선택됨</span>' +
          '</div>'
        );
      }
      out.innerHTML = rows.join('');
    });
  });
})();

// 기존 파일 inline 삭제
(function bindFileDeleteInline(){
  const CTX  = '${pageContext.request.contextPath}';
  const csrf = document.querySelector('input[name="_csrf"]')?.value || '';
  const fileIdEl = document.getElementById('fileId');

  document.addEventListener('click', async (e)=>{
    if (!e.target.classList.contains('btn-del-exist')) return;
    if (!fileIdEl?.value) return;

    const seq = e.target.dataset.seq;
    if (!seq) return;
    if (!confirm('이 파일을 삭제하시겠습니까?')) return;

    const body = new URLSearchParams();
    body.append('fileId', fileIdEl.value);
    body.append('sequence', String(seq));
    body.append('removePhysical', 'true');
    if (csrf) body.append('_csrf', csrf);

    const resp = await fetch(CTX + '/file/delete-one', {
      method:'POST',
      credentials:'same-origin',
      headers:{ 'Content-Type':'application/x-www-form-urlencoded;charset=UTF-8' },
      body
    });
    if (!resp.ok) { alert('삭제 실패'); return; }
    const row = e.target.closest('.file-chip');
    if (row) row.remove();
  });
})();

// 제출 직전 업로드(수정: fileId 있으면 /file/append, 없으면 /file/upload)
async function uploadAllFilesBeforeSubmit() {
  const map = [
    { id: 'files_WAGE_PROOF',            type: 'WAGE_PROOF' },
    { id: 'files_PAYMENT_FROM_EMPLOYER', type: 'PAYMENT_FROM_EMPLOYER' },
    { id: 'files_OTHER',                 type: 'OTHER' },
    { id: 'files_ELIGIBILITY_PROOF',     type: 'ELIGIBILITY_PROOF' }
  ];

  const fd = new FormData();
  let fileCount = 0;

  for (const g of map) {
    const input = document.getElementById(g.id);
    if (input?.files?.length) {
      for (const f of input.files) {
        fd.append('files', f);
        fd.append('fileTypes', g.type);
        fileCount++;
      }
    }
  }

  if (fileCount === 0) return { ok:true, skipped:true, fileId:null };

  const CTX  = '${pageContext.request.contextPath}';
  const csrf = document.querySelector('input[name="_csrf"]')?.value || '';
  const fileIdEl = document.getElementById('fileId');
  const hasFileId = !!(fileIdEl && fileIdEl.value);

  const url = CTX + (hasFileId ? '/file/append' : '/file/upload');
  if (hasFileId) fd.append('fileId', fileIdEl.value);
  if (csrf) fd.append('_csrf', csrf);

  const resp = await fetch(url, {
    method:'POST',
    body: fd,
    credentials:'same-origin',
    headers: csrf ? { 'X-CSRF-TOKEN': csrf, 'Accept':'application/json' } : { 'Accept':'application/json' }
  });

  if (!resp.ok) {
    console.error('[upload] fail', resp.status, await resp.text().catch(()=> ''));
    return { ok:false, skipped:false, fileId:null };
  }
  if (!hasFileId) {
    const ct = (resp.headers.get('content-type') || '').toLowerCase();
    if (!ct.includes('application/json')) return { ok:false, skipped:false, fileId:null };
    const data = await resp.json().catch(()=> null);
    const newId = data?.fileId ?? null;
    if (!newId) return { ok:false, skipped:false, fileId:null };
    return { ok:true, skipped:false, fileId:newId };
  }
  return { ok:true, skipped:false, fileId:fileIdEl.value };
}

// 최종 제출 직전 데이터 정리
function doFinalNormalizeBeforeSubmit() {
  // 금액 콤마 제거
  document.querySelectorAll('#regularWage, input[name^="monthlyCompanyPay"]').forEach(el => {
    el.value = (el.value || '').replace(/[^\d]/g, '');
  });
  // 근로자 주민번호 합치기
  const empRrnHidden = document.getElementById('employee-rrn-hidden');
  if (empRrnHidden) {
    empRrnHidden.value =
      (document.getElementById('employee-rrn-a').value || '').replace(/[^\d]/g,'') +
      (document.getElementById('employee-rrn-b').value || '').replace(/[^\d]/g,'');
  }
  // 자녀 주민번호(미발급이면 공백)
  const childRrnHidden = document.getElementById('child-rrn-hidden');
  if (childRrnHidden) {
    const a = (document.getElementById('child-rrn-a').value || '').replace(/[^\d]/g,'');
    const b = (document.getElementById('child-rrn-b').value || '').replace(/[^\d]/g,'');
    childRrnHidden.value = (a.length === 6 && b.length === 7) ? (a + b) : '';
  }
  // 출생(예정)일 hidden name 처리
  const hidden = document.getElementById('childBirthDateHidden');
  if (hidden && !hidden.value) hidden.removeAttribute('name');
}

// 멀티파트 해제(폼에서 파일 input/hidden 제거)
function stripFileInputsBeforeFinalSubmit(form) {
  form.querySelectorAll('input[name="files"], input[name="fileTypes"]').forEach(el => {
    el.removeAttribute('name');
    el.disabled = true;
  });
  form.removeAttribute('enctype');
  form.enctype = 'application/x-www-form-urlencoded';
}
</script>

</body>
</html>
