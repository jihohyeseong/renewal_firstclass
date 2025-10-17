<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

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
    .input-field input[type="text"],
    .input-field input[type="date"],
    .input-field input[type="number"],
    .input-field input[type="password"],
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
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/comp.css">
	
<header class="header">
	<a href="${pageContext.request.contextPath}/main" class="logo"><img
		src="${pageContext.request.contextPath}/resources/images/logo_comp.png"
		alt="Logo" width="auto" height="80"></a>
	<nav>
		<ul class="header-nav">
			<li><a
				class="nav-link ${fn:contains(currentURI, '/main') ? 'active' : ''}"
				href="${pageContext.request.contextPath}/main">신청내역</a></li>
			<li><a
				class="nav-link ${fn:contains(currentURI, '/calc') ? 'active' : ''}"
				href="${pageContext.request.contextPath}/calc">모의 계산하기</a></li>
			<li><a
				class="nav-link ${fn:contains(currentURI, '/mypage') ? 'active' : ''}"
				href="${pageContext.request.contextPath}/mypage">마이페이지</a></li>
		</ul>
		<sec:authorize access="isAnonymous()">
			<a href="${pageContext.request.contextPath}/login"
				class="btn btn-primary">로그인</a>
		</sec:authorize>
		<sec:authorize access="isAuthenticated()">
			<span class="welcome-msg"> <sec:authentication
					property="principal.username" />님, 환영합니다.
			</span>
			<form id="logout-form"
				action="${pageContext.request.contextPath}/logout" method="post"
				style="display: none;">
				<sec:csrfInput />
			</form>
			<a href="#"
				onclick="document.getElementById('logout-form').submit(); return false;"
				class="btn btn-logout">로그아웃</a>
		</sec:authorize>
	</nav>
</header>
<main class="main-container">
<div class="content-wrapper">
	<div class="content-header">
		<h2>육아휴직 확인서 제출</h2>
	</div>

	<form action="${pageContext.request.contextPath}/confirmation/submit"
		method="post">
		<sec:csrfInput />

		<%-- =======================
                 1. 근로자 정보
            ======================== --%>
		<div class="form-section">
			<h3>1. 근로자 정보</h3>
			<div class="form-group">
				<label class="field-title" for="employee-name">근로자 성명</label>
				<div class="input-field">
					<input type="text" id="employee-name" name="name"
						placeholder="육아휴직 대상 근로자 성명" required>
				</div>
			</div>
			<div class="form-group">
				<label class="field-title" for="employee-rrn-a">근로자 주민등록번호</label>
				<div class="input-field"
					style="display: flex; align-items: center; gap: 10px;">
					<input type="text" id="employee-rrn-a" maxlength="6"
						placeholder="앞 6자리" style="flex: 1;" required> <span>-</span>
					<input type="password" id="employee-rrn-b" maxlength="7"
						placeholder="뒤 7자리" style="flex: 1;" required> <input
						type="hidden" name="registrationNumber" id="employee-rrn-hidden">
				</div>
			</div>
		</div>

		<%-- =======================
                 2. 육아휴직 및 지급액 정보
            ======================== --%>
		<div class="form-section">
			<h3>2. 육아휴직 및 지급액 정보</h3>
			<div class="form-group">
				<label class="field-title" for="start-date">육아휴직 기간</label>
				<div class="input-field"
					style="display: flex; align-items: center; gap: 10px;">
					<input type="date" id="start-date" name="startDate" required
						style="flex: 1;"> <span>~</span> <input type="date"
						id="end-date" name="endDate" required style="flex: 1;">
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
						placeholder="예: 40" required>
				</div>
			</div>
			<div class="form-group">
				<label class="field-title" for="regularWage">통상임금 (월)</label>
				<div class="input-field">
					<input type="text" id="regularWage" name="regularWage"
						placeholder="숫자만 입력" autocomplete="off" required>
				</div>
			</div>
		</div>

		<%-- =======================
                 3. 대상 자녀 정보
            ======================== --%>
		<div class="form-section">
			<h3>3. 대상 자녀 정보</h3>
			<input type="hidden" name="childBirthDate" id="childBirthDateHidden">
			<div class="form-group">
				<label class="field-title">자녀 출생여부</label>
				<div class="input-field">
					<input type="radio" name="birthType" value="born" id="bt-born"
						required><label for="bt-born" style="margin-right: 20px;">출생</label>
					<input type="radio" name="birthType" value="expected"
						id="bt-expected"><label for="bt-expected">출산예정</label>
				</div>
			</div>
			<div id="born-fields" style="display: none;">
				<div class="form-group">
					<label class="field-title" for="child-name">자녀 이름</label>
					<div class="input-field">
						<input type="text" id="child-name" name="childName"
							placeholder="자녀의 이름을 입력하세요">
					</div>
				</div>
				<div class="form-group">
					<label class="field-title" for="birth-date">출생일</label>
					<div class="input-field">
						<input type="date" id="birth-date">
					</div>
				</div>
				<div class="form-group">
					<label class="field-title" for="child-rrn-a">자녀 주민등록번호</label>
					<div class="input-field"
						style="display: flex; align-items: center; gap: 10px;">
						<input type="text" id="child-rrn-a" maxlength="6"
							placeholder="생년월일 6자리"><span>-</span> <input
							type="password" id="child-rrn-b" maxlength="7"
							placeholder="뒤 7자리"> <input type="hidden"
							name="childResiRegiNumber" id="child-rrn-hidden">
					</div>
				</div>
			</div>
			<div id="expected-fields" style="display: none;">
				<div class="form-group">
					<label class="field-title" for="expected-date">출산예정일</label>
					<div class="input-field">
						<input type="date" id="expected-date"> <small
							style="color: #666; display: block; margin-top: 8px;">※
							오늘 이후 날짜만 선택 가능</small>
					</div>
				</div>
			</div>
		</div>

		<%-- =======================
                 4. 확인서 작성자 정보
            ======================== --%>
		<div class="form-section">
			<h3>4. 확인서 작성자 정보</h3>
			<div class="form-group">
				<label class="field-title" for="response-name">담당자 이름</label>
				<div class="input-field">
					<input type="text" id="response-name" name="responseName"
						placeholder="확인서 작성 담당자 이름" required>
				</div>
			</div>
			<div class="form-group">
				<label class="field-title" for="response-phone">담당자 전화번호</label>
				<div class="input-field">
					<input type="text" id="response-phone" name="responsePhoneNumber"
						placeholder="'-' 없이 숫자만 입력" required>
				</div>
			</div>
		</div>

		<div class="submit-button-container">
			<button type="submit" class="btn btn-primary">확인서 제출하기</button>
		</div>
	</form>
</div>
</main>

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
        format(); // 초기 로드 시 포맷팅
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
            '<div class="date-range-display"><div>' + rangeText + '</div></div>' +
            '<div class="payment-input-field" style="margin-left:auto;">' +
            '<input type="text" name="monthly_payment_' + monthIdx + '" ' +
            'placeholder="해당 기간의 사업장 지급액(원) 입력" autocomplete="off">' +
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

   startDateInput.addEventListener('change', function() {
      if (startDateInput.value) {
         periodInputSection.style.display = 'block';
         endDateInput.min = startDateInput.value;
         formsContainer.innerHTML = '';
         if (noPaymentWrapper) noPaymentWrapper.style.display = 'none';
      } else {
         periodInputSection.style.display = 'none';
      }
   });
   endDateInput.addEventListener('change', function () {
      formsContainer.innerHTML = '';
      if (noPaymentWrapper) noPaymentWrapper.style.display = 'none';
   });
   if (noPaymentChk) noPaymentChk.addEventListener('change', applyNoPaymentState);



    // ─────────────────────────────────────
    // 자녀정보(출생/예정) 처리
    // ─────────────────────────────────────
    const hidden = document.getElementById('childBirthDateHidden'), bornWrap = document.getElementById('born-fields'), expWrap = document.getElementById('expected-fields'), birth = document.getElementById('birth-date'), exp = document.getElementById('expected-date');
    if (exp) { const today = new Date(); exp.min = today.toISOString().split("T")[0]; }
    function setHiddenFrom(el) { if(hidden && el) hidden.value = el.value || ''; }
    function updateChildView() {
        const isBorn = document.getElementById('bt-born').checked;
        bornWrap.style.display = isBorn ? '' : 'none';
        expWrap.style.display = isBorn ? 'none' : '';
        document.getElementById('child-name').required = isBorn;
        birth.required = isBorn;
        exp.required = !isBorn;
        setHiddenFrom(isBorn ? birth : exp);
    }
    document.querySelectorAll('input[name="birthType"]').forEach(r => r.addEventListener('change', updateChildView));
    if(birth) birth.addEventListener('change', () => setHiddenFrom(birth));
    if(exp) exp.addEventListener('change', () => setHiddenFrom(exp));
    updateChildView();

    // ─────────────────────────────────────
    // 제출 전 데이터 정리
    // ─────────────────────────────────────
    const form = document.querySelector('form');
    if (form) {
        form.addEventListener('submit', function(e) {
            // 숫자 필드 콤마 제거
            document.querySelectorAll('#regularWage, input[name="companyPayments"]').forEach(el => {
                el.value = onlyDigits(el.value);
            });
            // 주민번호 합치기
            const empRrnHidden = document.getElementById('employee-rrn-hidden');
            empRrnHidden.value = onlyDigits(document.getElementById('employee-rrn-a').value) + onlyDigits(document.getElementById('employee-rrn-b').value);
            
            const childRrnHidden = document.getElementById('child-rrn-hidden');
            const a = onlyDigits(document.getElementById('child-rrn-a').value), b = onlyDigits(document.getElementById('child-rrn-b').value);
            childRrnHidden.value = (a.length === 6 && b.length === 7) ? (a + b) : '';
        });
    }
});
</script>
