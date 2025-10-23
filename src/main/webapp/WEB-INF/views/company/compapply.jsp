<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>

<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/comp.css">
<style>
.form-section {
	margin-bottom: 50px;
	padding-bottom: 30px;
	border-bottom: 1px solid var(--border-color);
}

.form-section:last-child {
	border-bottom: none;
	margin-bottom: 0;
	padding-bottom: 0;
}

.form-group {
	display: grid;
	grid-template-columns: 200px 1fr;
	align-items: flex-start;
	gap: 20px;
	margin-bottom: 20px;
}

.field-title {
	font-weight: 500;
	padding-top: 10px;
	color: var(--dark-gray-color);
}

.input-field input[type="text"], .input-field input[type="date"],
	.input-field input[type="number"], .input-field input[type="password"],
	.input-field select {
	width: 100%;
	padding: 10px 14px;
	border: 1px solid var(--border-color);
	border-radius: 8px;
	transition: border-color .2s ease;
}

.input-field input:focus, .input-field select:focus {
	outline: none;
	border-color: var(--primary-color);
}

.submit-button-container {
	display: flex;
	justify-content: center;
	padding-top: 40px;
}
/* 단위기간 동적 생성 관련 스타일 */
.dynamic-form-container {
	margin-top: 20px;
	display: flex;
	flex-direction: column;
	gap: 15px;
}

.dynamic-form-row {
	display: flex;
	align-items: center;
	gap: 20px;
	padding: 10px;
	border-radius: 8px;
	background-color: var(--light-gray-color);
}

.date-range-display {
	font-weight: 500;
	flex-basis: 250px; /* 고정 너비 */
	text-align: center;
}

.payment-input-field {
	flex-grow: 1;
}

.payment-input-field input.readonly-like {
	background-color: #e9ecef;
	color: #888;
}
</style>
  <title>육아휴직 확인서 제출</title>
</head>
<body>

<%@ include file="compheader.jsp"%>

<c:if test="${not empty error}">
	<div class="alert alert-danger">${error}</div>
</c:if>
<c:if test="${not empty errors}">
	<div class="alert alert-warning">
		<ul>
			<c:forEach var="e" items="${errors}">
				<li>${e.key}: ${e.value}</li>
			</c:forEach>
		</ul>
	</div>
</c:if>
<c:if test="${not empty message}">
	<div class="alert alert-success">${message}</div>
</c:if>

<main class="main-container">
<div class="content-wrapper">
	<div class="content-header">
		<h2>육아휴직 확인서 제출</h2>
	</div>

	<form id="confirm-form"
		action="${pageContext.request.contextPath}/comp/apply/save"
		method="post">
		<sec:csrfInput />

		<%-- =======================
                 근로자 정보
            ======================== --%>
		<div class="form-section">
			<h3>근로자 정보</h3>
			<div class="form-group">
				<label class="field-title" for="employee-name">근로자 성명</label>
				<div class="input-field">
					<input type="text" id="employee-name" name="name"
						placeholder="육아휴직 대상 근로자 성명">
				</div>
			</div>
			<div class="form-group">
				<label class="field-title" for="employee-rrn-a">근로자 주민등록번호</label>
				<div class="input-field"
					style="display: flex; align-items: center; gap: 10px;">
					<input type="text" id="employee-rrn-a" maxlength="6"
						placeholder="앞 6자리" style="flex: 1;"> <span>-</span> <input
						type="password" id="employee-rrn-b" maxlength="7"
						placeholder="뒤 7자리" style="flex: 1;"> <input
						type="hidden" name="registrationNumber" id="employee-rrn-hidden">
				</div>
			</div>
		</div>

		<%-- =======================
                 육아휴직 및 지급액 정보
            ======================== --%>
		<div class="form-section">
			<h3>육아휴직 및 지급액 정보</h3>
			<div class="form-group">
				<label class="field-title" for="start-date">육아휴직 기간</label>
				<div class="input-field"
					style="display: flex; align-items: center; gap: 10px;">
					<input type="date" id="start-date" name="startDate"
						style="flex: 1;"> <span>~</span> <input type="date"
						id="end-date" name="endDate" style="flex: 1;">
				</div>
			</div>

			<div class="form-group">
				<label class="field-title">단위기간별 사업장 지급액</label>
				<div class="input-field">
					<div style="display: flex; align-items: center; gap: 10px;">
						<button type="button" id="generate-forms-btn"
							class="btn btn-secondary">기간 나누기</button>
						<label id="no-payment-wrapper"
							style="display: none; align-items: center; gap: 6px; margin-left: 8px;">
							<input type="checkbox" id="no-payment" name="noPayment" /> 사업장
							지급액 없음
						</label>
					</div>
					<small style="color: #666; display: block; margin-top: 8px;">※
						육아휴직 기간 입력 후 '기간 나누기'를 클릭하여 월별 지급액을 입력하세요.</small>
				</div>
			</div>
			<div id="dynamic-forms-container" class="dynamic-form-container"></div>


			<div class="form-group">
				<label class="field-title" for="weeklyHours">주당 소정근로시간</label>
				<div class="input-field">
					<input type="number" id="weeklyHours" name="weeklyHours"
						placeholder="예: 40">
				</div>
			</div>
			<div class="form-group">
				<label class="field-title" for="regularWage">통상임금 (월)</label>
				<div class="input-field">
					<input type="text" id="regularWage" name="regularWage"
						placeholder="숫자만 입력" autocomplete="off">
				</div>
			</div>
		</div>

		<%-- =======================
                 대상 자녀 정보
            ======================== --%>
		<div class="form-section">
			<h3>대상 자녀 정보</h3>

			<!-- 서버로 넘길 출산(예정)일 hidden -->
			<input type="hidden" name="childBirthDate" id="childBirthDateHidden">

			<div class="form-group">
				<label class="field-title" for="child-date">출산(예정)일 <span
					style="color: #ef4444;">*</span></label>
				<div class="input-field">
					<input type="date" id="child-date" required> <small
						style="color: #666; display: block; margin-top: 8px;"> ※
						출산 전일시 출산(예정)일만 입력해주세요. </small>
				</div>
			</div>

			<div id="born-fields">
				<div class="form-group">
					<label class="field-title" for="child-name">자녀 이름 <span
						style="color: #888;">(선택)</span></label>
					<div class="input-field">
						<input type="text" id="child-name" name="childName"
							placeholder="미기재 가능">
					</div>
				</div>

				<div class="form-group">
					<label class="field-title" for="child-rrn-a">자녀 주민등록번호 <span
						style="color: #888;">(선택)</span></label>
					<div class="input-field"
						style="display: flex; align-items: center; gap: 10px;">
						<input type="text" id="child-rrn-a" maxlength="6"
							placeholder="앞 6자리"> <span>-</span> <input
							type="password" id="child-rrn-b" maxlength="7"
							placeholder="뒤 7자리"> <input type="hidden"
							name="childResiRegiNumber" id="child-rrn-hidden">
					</div>
				</div>
			</div>
		</div>
		<!-- =======================
    	 센터 선택 
		======================== -->
		<div class="form-section">
			<h3>처리 센터 선택</h3>

			<div class="form-section">
				<h2>접수 센터 선택</h2>
				<div class="form-group">
					<label class="field-title">접수센터 기준</label>
					<div class="input-field radio-group">
						<input type="radio" id="center-work" name="center" value="work"
							checked disabled> <label for="center-work">사업장 주소</label>
						<button type="button" id="find-center-btn" class="btn btn-primary"
							style="margin-left: 10px;">센터 찾기</button>
					</div>
				</div>
				<div class="info-box center-display-box">
					<p>
						<strong>관할센터:</strong> <span id="center-name-display"></span>
					</p>
					<p>
						<strong>대표전화:</strong> <span id="center-phone-display"></span>
					</p>
					<p>
						<strong>주소:</strong> <span id="center-address-display"></span>
					</p>
				</div>
				<input type="hidden" name="centerId" id="centerId" value="">
			</div>
		</div>


		<!-- =======================
                 확인서 작성자 정보
            ======================== -->

		<div class="form-section">
			<h3>확인서 작성자 정보</h3>
			<div class="form-group">
				<label class="field-title" for="response-name">담당자 이름</label>
				<div class="input-field">
					<input type="text" id="response-name" name="responseName"
						placeholder="확인서 작성 담당자 이름">
				</div>
			</div>
			<div class="form-group">
				<label class="field-title" for="response-phone">담당자 전화번호</label>
				<div class="input-field">
					<input type="text" id="response-phone" name="responsePhoneNumber"
						placeholder="'-' 없이 숫자만 입력">
				</div>
			</div>
		</div>

		<div class="submit-button-container">
			<button type="submit" class="btn btn-primary">저장하기</button>
		</div>
	</form>
</div>
</main>

<%@ include file="/WEB-INF/views/conponent/centerModal.jsp"%>

<footer class="footer">
	<p>&copy; 2025 육아휴직 서비스. All Rights Reserved.</p>
</footer>

<script>
document.addEventListener('DOMContentLoaded', function () {

    // ─────────────────────────────────────
    // 공통 유틸 및 입력 필드 바인딩
    // ─────────────────────────────────────
    function withCommas(s){ return String(s).replace(/\B(?=(\d{3})+(?!\d))/g, ','); }
    function onlyDigits(s){ return (s||'').replace(/[^\d]/g,''); }
    function bindDigitsOnly(el){ if(el) el.addEventListener('input', () => { el.value = (el.value || '').replace(/[^\d]/g, ''); }); }
    function allowDigitsAndCommas(el, maxDigits) {
        function format() {
            const originalValue = onlyDigits(el.value).substring(0, maxDigits);
            el.value = withCommas(originalValue);
        }
        el.addEventListener('input', format);
        format();
    }

    allowDigitsAndCommas(document.getElementById('regularWage'), 19);
    bindDigitsOnly(document.getElementById('weeklyHours'));
    bindDigitsOnly(document.getElementById('response-phone'));
    bindDigitsOnly(document.getElementById('employee-rrn-a'));
    bindDigitsOnly(document.getElementById('employee-rrn-b'));
    bindDigitsOnly(document.getElementById('child-rrn-a'));
    bindDigitsOnly(document.getElementById('child-rrn-b'));

    // ─────────────────────────────────────
    // 단위기간 생성 로직 (복원)
    // ─────────────────────────────────────
   var startDateInput = document.getElementById('start-date');
   var endDateInput = document.getElementById('end-date');
   //var periodInputSection = document.getElementById('period-input-section');
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

      // [추가] 최소 1개월 이상이어야 하는 조건 추가
      const firstPeriodEndDate = getPeriodEndDate(originalStartDate, 1);
      if (finalEndDate < firstPeriodEndDate) {
         alert('신청 기간은 최소 1개월 이상이어야 합니다.');
         return;
      }

      let monthCount = (finalEndDate.getFullYear() - originalStartDate.getFullYear()) * 12;
      monthCount -= originalStartDate.getMonth();
      monthCount += finalEndDate.getMonth();
      if (finalEndDate.getDate() >= originalStartDate.getDate()) {
         monthCount++;
      }
      if (monthCount > 12) {
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
        	 row.innerHTML =
        		  '<div class="date-range-display"><div>' + rangeText + '</div></div>' +
        		  '<div class="payment-input-field" style="margin-left:auto;">' +
        		  '<input type="text" name="monthlyCompanyPay" placeholder="사업장 지급액(원)" autocomplete="off">' +
        		  '</div>';
         formsContainer.appendChild(row);

         currentPeriodStart = new Date(actualPeriodEnd);
         currentPeriodStart.setDate(currentPeriodStart.getDate() + 1);
         monthIdx++;
      }

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

   startDateInput.addEventListener('change', function () {
	    if (startDateInput.value) {
	      endDateInput.min = startDateInput.value;
	      formsContainer.innerHTML = '';
	      if (noPaymentWrapper) noPaymentWrapper.style.display = 'none';
	    } else {
	      endDateInput.removeAttribute('min');
	      formsContainer.innerHTML = '';
	      if (noPaymentWrapper) noPaymentWrapper.style.display = 'none';
	    }
	  });
   endDateInput.addEventListener('change', function () {
      formsContainer.innerHTML = '';
      if (noPaymentWrapper) noPaymentWrapper.style.display = 'none';
   });
   if (noPaymentChk) noPaymentChk.addEventListener('change', applyNoPaymentState);


    /* ================================
       출생일 입력 시 
    ================================== */
   (function syncChildDateHidden(){
	   const dateEl = document.getElementById('child-date');
	   const hidden = document.getElementById('childBirthDateHidden');
	   function sync(){ if (hidden) hidden.value = dateEl?.value || ''; }
	   if (dateEl){
	     dateEl.addEventListener('change', sync);
	     sync(); // 초기 1회
	   }
	 })();
    /* ================================
    저장 버튼 클릭 시 유효성 검사 + 누락 항목 모아 alert
 ================================== */
 (function wireSubmitValidation(){
   const form        = document.getElementById('confirm-form');
   if (!form) return;

   const startDateEl = document.getElementById('start-date');
   const endDateEl   = document.getElementById('end-date');
   const wageEl      = document.getElementById('regularWage');
   const weeklyEl    = document.getElementById('weeklyHours');

   const empName     = document.getElementById('employee-name');
   const empA        = document.getElementById('employee-rrn-a');
   const empB        = document.getElementById('employee-rrn-b');
   
   const childDate   = document.getElementById('child-date');

   const noPayChk    = document.getElementById('no-payment');
   const formsBox    = document.getElementById('dynamic-forms-container');

   function onlyDigits(s){ return (s||'').replace(/[^\d]/g,''); }

   // 단위기간(월) 개수 계산 (윤달/말일 보정 포함)
   function countUnits(startStr, endStr) {
     if (!startStr || !endStr) return 0;
     const start = new Date(startStr + 'T00:00:00');
     const end   = new Date(endStr   + 'T00:00:00');
     if (isNaN(start) || isNaN(end) || start > end) return 0;

     function plusMonthsClamp(date, months) {
       const y = date.getFullYear(), m = date.getMonth(), d = date.getDate();
       const targetM = m + months, targetY = y + Math.floor(targetM / 12);
       const normM = ((targetM % 12) + 12) % 12;
       const last = new Date(targetY, normM + 1, 0).getDate();
       const day = Math.min(d, last);
       return new Date(targetY, normM, day);
     }
     function endOfUnit(start) {
       const originalDay = start.getDate();
       const nextSame = plusMonthsClamp(start, 1);
       const lastOfNext = new Date(nextSame.getFullYear(), nextSame.getMonth()+1, 0).getDate();
       const clamped = originalDay > lastOfNext;
       const e = new Date(nextSame.getTime());
       if (!clamped) e.setDate(e.getDate()-1);
       return e;
     }

     let cnt = 0, cur = start;
     while (cur <= end) {
       let e = endOfUnit(cur);
       if (e > end) e = end;
       cnt++;
       cur = new Date(e.getTime()); cur.setDate(cur.getDate()+1);
       if (cnt > 13) break;
     }
     return cnt;
   }

   form.addEventListener('submit', function(e){
     const missing = [];
     const invalid = [];
     let firstBadEl = null;

     function need(el, label){
       if (!el) return;
       const v = (el.value||'').trim();
       if (!v){
         missing.push(label);
         if (!firstBadEl) firstBadEl = el;
       }
     }
     function needRadio(radios, label){
       const checked = radios.some(r=>r.checked);
       if (!checked){
         missing.push(label);
         if (!firstBadEl && radios[0]) firstBadEl = radios[0];
       }
       return checked;
     }
     function markInvalid(el, label){
       invalid.push(label);
       if (!firstBadEl && el) firstBadEl = el;
     }

     // 기본 필수
     need(empName, '근로자 성명');
     need(startDateEl, '육아휴직 시작일');
     need(endDateEl,   '육아휴직 종료일');
     need(weeklyEl,    '주당 소정근로시간');
     need(wageEl,      '통상임금(월)');
     
     const centerIdVal = document.getElementById('centerId')?.value?.trim();
     if (!centerIdVal) missing.push('처리 센터 선택');

     // 근로자 주민번호
     if (!empA || onlyDigits(empA.value).length !== 6){
       missing.push('근로자 주민등록번호(앞 6자리)');
       if (!firstBadEl && empA) firstBadEl = empA;
     }
     if (!empB || onlyDigits(empB.value).length !== 7){
       missing.push('근로자 주민등록번호(뒤 7자리)');
       if (!firstBadEl && empB) firstBadEl = empB;
     }

     // 기간 규칙: 1~12개월
     const unitCount = countUnits(startDateEl?.value, endDateEl?.value);
     if (unitCount === 0){
       if (startDateEl?.value && endDateEl?.value) markInvalid(startDateEl, '육아휴직 기간(시작/종료일 확인)');
     } else if (unitCount > 12){
       markInvalid(endDateEl, '육아휴직 기간(최대 12개월)');
     }

     // 숫자 규칙
     const wage   = Number(onlyDigits(wageEl?.value));
     const weekly = Number(onlyDigits(weeklyEl?.value));
     if (wageEl && !(wage > 0))   markInvalid(wageEl, '통상임금(월) 1원 이상');
     if (weeklyEl && !(weekly > 0)) markInvalid(weeklyEl, '주당 소정근로시간 1시간 이상');

     // 자녀(출생/예정)
     need(childDate, '출산(예정)일');
     // 단위기간별 지급액 
     if (unitCount > 0 && (!noPayChk || !noPayChk.checked)){
       const pays = Array.from(formsBox.querySelectorAll('input[name="monthlyCompanyPay"]'));
       if (pays.length !== unitCount){
         invalid.push('단위기간 나누기(버튼 클릭으로 월별 칸 생성)');
         if (!firstBadEl && document.getElementById('generate-forms-btn')) {
           firstBadEl = document.getElementById('generate-forms-btn');
         }
       } else {
         for (const inp of pays){
           const v = onlyDigits(inp.value);
           if (!v.length){ missing.push('월별 사업장 지급액'); if (!firstBadEl) firstBadEl = inp; break; }
           if (Number(v) < 0){ markInvalid(inp, '월별 사업장 지급액(0 이상)'); break; }
         }
       }
     }

     // 결과 처리
     if (missing.length || invalid.length){
       e.preventDefault();

       let msg = '모든 값을 입력해야 저장할 수 있습니다.';
       if (missing.length){
         const uniqMissing = [...new Set(missing)];
         msg += '\n\n누락 항목: ' + uniqMissing.join(', ');
       }
       if (invalid.length){
         const uniqInvalid = [...new Set(invalid)];
         msg += '\n\n다음 항목을 다시 확인해 주세요: ' + uniqInvalid.join(', ');
       }
       alert(msg);

       // 첫 오류 위치로 스크롤 + 포커스
       if (firstBadEl && typeof firstBadEl.focus === 'function'){
         firstBadEl.scrollIntoView({behavior:'smooth', block:'center'});
         setTimeout(()=> firstBadEl.focus(), 200);
       }
       return;
     }
   });
 })();

    
    // ─────────────────────────────────────
    // 제출 전 데이터 정리
    // ─────────────────────────────────────
    const form = document.getElementById('confirm-form');
    if (form) {
        form.addEventListener('submit', function(e) {
          document.querySelectorAll('#regularWage, input[name^="monthlyCompanyPay"]').forEach(el => {
            el.value = (el.value || '').replace(/[^\d]/g, '');
          });

          // 주민번호 합치기
          const empRrnHidden = document.getElementById('employee-rrn-hidden');
          empRrnHidden.value =
            (document.getElementById('employee-rrn-a').value || '').replace(/[^\d]/g,'') +
            (document.getElementById('employee-rrn-b').value || '').replace(/[^\d]/g,'');

          const childRrnHidden = document.getElementById('child-rrn-hidden');
          const a = (document.getElementById('child-rrn-a').value || '').replace(/[^\d]/g,'');
          const b = (document.getElementById('child-rrn-b').value || '').replace(/[^\d]/g,'');
          childRrnHidden.value = (a.length === 6 && b.length === 7) ? (a + b) : '';

          const hidden = document.getElementById('childBirthDateHidden');
          if (hidden && !hidden.value) hidden.removeAttribute('name');
        });
      }
    // ─────────────────────────────────────
    // 엔터 막기
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
          centerListBody.innerHTML = '';

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
              
              document.querySelector('.center-display-box')?.classList.add('filled');
              
              closeModal();
          }
      });
    }
    
});
</script>

</body>
</html>
