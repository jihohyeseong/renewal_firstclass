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
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/global.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/comp.css">
<style>
/* 타이틀 */
h1 {
	text-align: center;
	margin-bottom: 30px;
	font-size: 28px;
}

h2 {
	color: var(--primary-color);
	border-bottom: 2px solid var(--primary-light-color, #f0f2ff);
	padding-bottom: 10px;
	margin-bottom: 25px;
	font-size: 20px;
}

/* 섹션 */
.form-section {
	margin-bottom: 40px;
}

.form-section+.form-section {
	border-top: 1px solid var(--border-color, #dee2e6);
	padding-top: 30px;
}

.form-group {
	display: grid !important;
	grid-template-columns: 200px minmax(0, 1fr) !important;
	align-items: flex-start !important;
	gap: 20px !important;
	margin-bottom: 20px !important;
}

.form-group .field-title {
	width: auto !important;
	padding-top: 10px !important;
}

.form-group .input-field {
	min-width: 0 !important;
}

.input-field input[type="text"], .input-field input[type="date"],
	.input-field input[type="number"], .input-field input[type="password"],
	.input-field select {
	width: 100%;
	padding: 10px;
	border: 1px solid var(--border-color, #dee2e6);
	border-radius: 6px;
	transition: .2s;
}

.input-field input:focus, .input-field select:focus {
	border-color: var(--primary-color);
	box-shadow: 0 0 0 3px rgba(63, 88, 212, .15);
	outline: none;
}

.readonly-like, .input-field input[readonly], .input-field input:disabled
	{
	background: var(--light-gray-color, #f8f9fa);
	cursor: not-allowed;
}

/* 버튼 */
.btn {
	display: inline-block;
	padding: 10px 20px;
	font-size: 15px;
	font-weight: 500;
	border-radius: 8px;
	border: 1px solid var(--border-color, #dee2e6);
	cursor: pointer;
	transition: .2s;
	text-align: center;
}

.btn-primary {
	background: var(--primary-color);
	color: #fff;
	border-color: var(--primary-color);
}

.btn-primary:hover {
	filter: brightness(.95);
	transform: translateY(-2px);
	box-shadow: var(--shadow-md, 0 4px 8px rgba(0, 0, 0, .07));
}

.btn-secondary {
	background: #fff;
	color: var(--gray-color, #868e96);
}

.btn-secondary:hover {
	background: var(--light-gray-color, #f8f9fa);
	color: var(--dark-gray-color, #343a40);
}

.submit-button-container {
	text-align: center;
	margin-top: 30px;
	display: flex;
	gap: 10px;
	justify-content: center;
}

.submit-button {
	padding: 12px 30px;
	font-size: 1.1em;
}

/* 라디오/체크 그룹 */
.radio-group, .checkbox-group {
	display: flex;
	align-items: center;
	gap: 15px;
}

/* 안내박스  */
.info-box {
	background: var(--primary-light-color, #f0f2ff);
	border: 1px solid #d1d9ff;
	padding: 15px;
	margin-top: 10px;
	border-radius: 6px;
	font-size: 14px;
}

.center-display-box {
	background: #fff;
	border: 2px dashed var(--border-color, #dee2e6);
	padding: 20px;
	min-height: 100px;
	transition: .3s;
	text-align: center;
	display: flex;
	justify-content: center;
	align-items: center;
}

.center-display-box:not (.filled )::before {
	content: '센터 찾기 버튼을 클릭하여 관할 센터를 선택하세요.';
	font-style: italic;
	color: var(--gray-color, #868e96);
	font-size: 15px;
}

.center-display-box:not (.filled ) p {
	display: none;
}

.center-display-box.filled {
	background: var(--primary-light-color, #f0f2ff);
	border-style: solid;
	border-color: #d1d9ff;
	text-align: left;
	display: block;
}

.center-display-box.filled p {
	display: block;
}

/* 월별 단위기간 생성 */
.dynamic-form-container {
	margin-top: 10px;
	border-top: 1px solid var(--border-color, #dee2e6);
	padding-top: 10px;
}

.dynamic-form-row {
	display: flex;
	align-items: center;
	gap: 15px;
	padding: 10px;
	border-radius: 6px;
	margin-bottom: 10px;
}

.dynamic-form-row:nth-child(odd) {
	background: var(--primary-light-color, #f0f2ff);
}

.date-range-display {
	font-weight: 500;
	flex-basis: 300px;
	flex-shrink: 0;
	text-align: center;
}

.payment-input-field {
	flex: 1;
	display: flex;
	justify-content: flex-end;
}

input[type="checkbox"] {
	-webkit-appearance: none;
	-moz-appearance: none;
	appearance: none;
	width: 20px;
	height: 20px;
	border: 2px solid var(--border-color, #dee2e6);
	border-radius: 4px;
	background-color: #fff;
	cursor: pointer;
	transition: .2s;
	vertical-align: middle;
	position: relative;
	top: -2px;
	display: inline-grid;
	place-content: center;
}

input[type="checkbox"]::before {
	content: '';
	width: 11px;
	height: 11px;
	background-image:
		url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3e%3cpath fill='none' stroke='%23fff' stroke-linecap='round' stroke-linejoin='round' stroke-width='3' d='M2 8l4 4 8-8'/%3e%3c/svg%3e");
	background-size: contain;
	background-repeat: no-repeat;
	transform: scale(0);
	transition: .1s transform ease-in-out;
}

input[type="checkbox"]:checked {
	background-color: var(--primary-color, #3f58d4);
	border-color: var(--primary-color, #3f58d4);
}

input[type="checkbox"]:checked::before {
	transform: scale(1);
}

input[type="checkbox"]:focus {
	border-color: var(--primary-color);
	box-shadow: 0 0 0 3px rgba(63, 88, 212, .15);
	outline: none;
}

.form-section input[type="file"]::file-selector-button {
	display: inline-block;
	padding: 8px 15px;
	font-size: 14px;
	font-weight: 500;
	border-radius: 6px;
	border: 1px solid var(--border-color, #dee2e6);
	cursor: pointer;
	transition: .2s;
	background: #fff;
	color: var(--gray-color, #868e96);
	margin-right: 15px;
}

.form-section input[type="file"]::file-selector-button:hover {
	background: var(--light-gray-color, #f8f9fa);
	color: var(--dark-gray-color, #343a40);
}

.form-section input[type="file"] {
	font-size: 14px;
	color: transparent;
}

.form-section .info-box[id^="list_"] {
	background-color: #fff;
	border: 1px solid var(--border-color, #dee2e6);
	min-height: 50px;
	padding: 10px;
	display: flex;
	flex-wrap: wrap;
	gap: 8px;
}

.form-section .info-box[id^="list_"]:not (:has(div) ) {
	color: var(- -gray-color, #868e96);
	font-style: italic;
	align-items: center;
}

.form-section .info-box[id^="list_"] div {
	display: inline-block;
	padding: 6px 12px;
	background: var(--primary-light-color, #f0f2ff);
	border: 1px solid #d1d9ff;
	color: var(--primary-color, #3f58d4);
	border-radius: 20px; /
	font-size: 14px;
	font-weight: 500;
	margin-bottom: 0 !important;
}

.checkbox-group span {
	font-size: 15px;
	color: #333;
	line-height: 1.5;
}

.checkbox-group[style*="flex-start"] input[type="checkbox"] {
	margin-top: 4px;
	top: 0;
}

.checkbox-group[style*="align-items:center"] input[type="checkbox"] {
	top: 0;
}

.form-group-vertical {
	display: block !important;
	margin-bottom: 25px !important;
}

.form-group-vertical .field-title {
	width: 100% !important;
	font-weight: 500;
	font-size: 16px;
	color: #333;
	line-height: 1.6;
	margin-bottom: 12px;
	background: white;
	border-left: 4px solid var(--primary-color, #3f58d4);
	padding: 12px 15px;
	border-radius: 4px;
}

.form-group-vertical .input-field {
	width: 100% !important;
}

.form-section .info-box[id^="list_"] {
	background-color: #fff;
	border: 1px solid var(--border-color, #dee2e6);
	min-height: 50px;
	padding: 10px;
	display: flex;
	flex-wrap: wrap;
	gap: 8px;
}

.form-section .info-box[id^="list_"]:not (:has (.file-pill )) {
	color: var(--gray-color, #868e96);
	font-style: italic;
	align-items: center;
}

.form-section .info-box[id^="list_"] .file-pill {
	display: inline-flex;
	align-items: center;
	padding: 6px 8px 6px 12px;
	background: var(--primary-light-color, #f0f2ff);
	border: 1px solid #d1d9ff;
	color: var(--primary-color, #3f58d4);
	border-radius: 20px;
	font-size: 14px;
	font-weight: 500;
	margin-bottom: 0 !important;
}

.file-remove-btn {
	display: inline-flex;
	align-items: center;
	justify-content: center;
	width: 18px;
	height: 18px;
	border-radius: 50%;
	border: none;
	background: rgba(0, 0, 0, 0.1);
	color: var(--primary-color, #3f58d4);
	font-size: 16px;
	font-weight: bold;
	line-height: 1;
	margin-left: 8px;
	cursor: pointer;
	transition: .2s;
	padding: 0;
}

.file-remove-btn:hover {
	background: rgba(0, 0, 0, 0.2);
	color: #000;
}

.btn-primary:hover {
	background-color: #1e7c43 !important;
	border-color: #1e7c43 !important;
	box-shadow: var(--shadow-md);
	transform: translateY(-2px);
}	

.footer {
	text-align: center;
	padding: 20px 0;
	font-size: 14px;
	color: var(--gray-color);
}

.btn-soft {
	background-color: #e2e5e8;
	color: var(--dark-gray-color);
	border: 1px solid #d0d4da;
}

.btn-soft:hover {
	background-color: #c0c4ca;
	border-color: #c0c4ca;
	box-shadow: var(--shadow-md);
	transform: translateY(-2px);
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
</style>

<title>육아휴직 확인서 제출</title>
</head>
<body>

	<%@ include file="compheader.jsp"%>

	<main class="main-container">
	<div class="content-wrapper">
		<h1>육아휴직 확인서 제출</h1>


		<form id="confirm-form"
			action="${pageContext.request.contextPath}/comp/apply/save"
			method="post" enctype="multipart/form-data">
			<sec:csrfInput />

			<!-- 근로자 정보 -->
			<div class="form-section">
				<h2>근로자 정보</h2>
				<div class="form-group">
					<label class="field-title" for="employee-name">근로자 성명</label>
					<div class="input-field">
						<input type="text" id="employee-name" name="name"
							placeholder="버튼을 누르면 자동으로 채워집니다." readonly>
					</div>
				</div>
				<div class="form-group">
					<label class="field-title" for="employee-rrn-a">근로자 주민등록번호</label>
					<div class="input-field"
						style="display: flex; align-items: center; gap: 10px;">
						<input type="text" id="employee-rrn-a" maxlength="6"
							placeholder="앞 6자리" style="flex: 1;"> <span
							class="hyphen">-</span> <input type="password"
							id="employee-rrn-b" maxlength="7" placeholder="뒤 7자리"
							style="flex: 1;"> <input type="hidden"
							name="registrationNumber" id="employee-rrn-hidden">
						<button type="button" id="find-employee-btn"
							class="btn btn-secondary" style="white-space: nowrap;">
							이름 검색</button>
						    <button type="button" id="reset-employee-btn"
						        class="btn btn-soft"
						        style="white-space: nowrap; display:none;">
						        지우기
						    </button>
					</div>
				</div>
			</div>


			<!-- 대상 자녀 정보 -->
			<div class="form-section">
				<h2>대상 자녀 정보</h2>
				<input type="hidden" name="childBirthDate" id="childBirthDateHidden">
				<div class="form-group">
					<label class="field-title" for="child-date">출산(예정)일</label>
					<div class="input-field">
						<input type="date" id="child-date" min="1900-01-01"
							max="2200-12-31"> <small
							style="color: #666; display: block; margin-top: 8px;">※
							출산 전일시 출산(예정)일만 입력해주세요.</small>
					</div>
				</div>

				<div id="born-fields">
					<div class="form-group">
						<label class="field-title" for="child-name">자녀 이름 </label>
						<div class="input-field">
							<input type="text" id="child-name" name="childName"
								maxlength="50">
						</div>
					</div>
					<div class="form-group">
						<label class="field-title" for="child-rrn-a"> 자녀 주민등록번호 </label>

						<div class="input-field"
							style="display: flex; align-items: center; gap: 12px; flex-wrap: nowrap; width: 100%;">
							<input type="text" id="child-rrn-a" maxlength="6"
								placeholder="앞 6자리" style="flex: 1 1 0;"> <span
								class="hyphen" style="flex: 0 0 auto;">-</span> <input
								type="password" id="child-rrn-b" maxlength="7"
								placeholder="뒤 7자리" style="flex: 1 1 0;"> <input
								type="hidden" name="childResiRegiNumber" id="child-rrn-hidden">
							<label class="checkbox-group"
								style="margin-left: auto; display: flex; align-items: center; gap: 8px; white-space: nowrap;">
								<input type="checkbox" id="pregnant-leave" name="pregnantLeave">
								<span>임신 중 육아휴직</span>
							</label>
						</div>

					</div>
					<div class="form-group">
						<div class="field-title"></div>
						<div class="input-field">
							<label class="checkbox-group"
								style="display: flex; align-items: flex-start; gap: 8px;">
								<input type="checkbox" id="no-rrn-foreign"
								name="childRrnUnverified"> <span>해외자녀 등 영아
									주민등록번호가 미발급되어 확인되지 않는 경우에만 체크합니다</span>
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
					<div class="input-field"
						style="display: flex; align-items: center; gap: 10px;">
						<input type="date" id="start-date" name="startDate"
							style="flex: 1;" min="1900-01-01" max="2200-12-31"> <span>~</span>
						<input type="date" id="end-date" name="endDate" style="flex: 1;"
							min="1900-01-01" max="2200-12-31">
					</div>
				</div>

				<div class="form-group">
					<label class="field-title">단위기간별 지급액</label>
					<div class="input-field">
						<div style="display: flex; align-items: center; gap: 10px;">
							<button type="button" id="generate-forms-btn"
								class="btn btn-secondary">기간 나누기</button>
							<label id="no-payment-wrapper"
								style="display: none; align-items: center; gap: 6px; margin-left: 8px;">
								<input type="checkbox" id="no-payment" name="noPayment">
								사업장 지급액 없음
							</label>
						</div>
						<small style="color: #666; display: block; margin-top: 8px;">※
							기간 입력 후 '기간 나누기'를 클릭하여 월별 지급액을 입력하세요.</small>
					</div>
				</div>

				<div id="dynamic-header-row" class="dynamic-form-row"
					style="display: none; background: transparent; border-bottom: 2px solid var(- -border-color); font-weight: 500; margin-bottom: 0;">
					<div class="date-range-display">
						<span>신청기간</span>
					</div>
					<div class="payment-input-field" style="padding-right: 150px;">
						<span>사업장 지급액(원)</span>
					</div>
				</div>

				<div id="dynamic-forms-container" class="dynamic-form-container"></div>

				<div class="form-group">
					<label class="field-title" for="weeklyHours">월 소정근로시간</label>
					<div class="input-field">
						<input type="number" id="weeklyHours" name="weeklyHours"
							placeholder="예: 209">
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


			<!-- 센터 선택 -->
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

			<!-- 작성자 -->
			<div class="form-section">
				<h2>확인서 작성자 정보</h2>
				<div class="form-group">
					<label class="field-title" for="response-name">담당자 이름</label>
					<div class="input-field">
						<input type="text" id="response-name" name="responseName"
							maxlength="50">
					</div>
				</div>
				<div class="form-group">
					<label class="field-title" for="response-phone">담당자 전화번호</label>
					<div class="input-field">
						<input type="text" id="response-phone" name="responsePhoneNumber"
							value="${userDTO.phoneNumber}" readonly>
					</div>
				</div>
			</div>

			<!-- 첨부파일 -->
			<div class="form-section">
				<h2>첨부파일</h2>
				<div class="form-group form-group-vertical">
					<label class="field-title">통상임금을 확인할 수 있는 증명자료(임금대장, 근로계약서
						등)</label>
					<div class="input-field">
						<input type="hidden" name="fileTypes" value="WAGE_PROOF">
						<br> <input type="file" name="files" id="files_WAGE_PROOF"
							multiple
							accept=".pdf,.jpg,.jpeg,.png,.heic,.gif,.bmp,.tif,.tiff,.hwp,.hwpx,.doc,.docx,.xls,.xlsx">
						<div id="list_WAGE_PROOF" class="info-box"
							style="margin-top: 8px; min-height: 40px;">선택된 파일 없음</div>
					</div>
				</div>
				<div class="form-group form-group-vertical">
					<label class="field-title">육아휴직 기간 동안 사업주로부터 금품을 지급받은경우 이를
						확인할 수 있는 자료</label>
					<div class="input-field">
						<input type="hidden" name="fileTypes"
							value="PAYMENT_FROM_EMPLOYER"> <br> <input
							type="file" name="files" id="files_PAYMENT_FROM_EMPLOYER"
							multiple
							accept=".pdf,.jpg,.jpeg,.png,.heic,.gif,.bmp,.tif,.tiff,.hwp,.hwpx,.doc,.docx,.xls,.xlsx">
						<div id="list_PAYMENT_FROM_EMPLOYER" class="info-box"
							style="margin-top: 8px; min-height: 40px;">선택된 파일 없음</div>
					</div>
				</div>
				<div class="form-group form-group-vertical">
					<label class="field-title">기타 자료</label>
					<div class="input-field">
						<input type="hidden" name="fileTypes" value="OTHER"> <br>
						<input type="file" name="files" id="files_OTHER" multiple
							accept=".pdf,.jpg,.jpeg,.png,.heic,.gif,.bmp,.tif,.tiff,.hwp,.hwpx,.doc,.docx,.xls,.xlsx">
						<div id="list_OTHER" class="info-box"
							style="margin-top: 8px; min-height: 40px;">선택된 파일 없음</div>
					</div>
				</div>
				<div class="form-group form-group-vertical">
					<label class="field-title">배우자가 3개월 이상 육아휴직을 사용, 한부모,
						중증장애아동의 부모 중 어느 하나에 해당함을 확인할 수 있는 증명자료사본</label>
					<div class="input-field">
						<input type="hidden" name="fileTypes" value="ELIGIBILITY_PROOF">
						<br> <input type="file" name="files"
							id="files_ELIGIBILITY_PROOF" multiple
							accept=".pdf,.jpg,.jpeg,.png,.heic,.gif,.bmp,.tif,.tiff,.hwp,.hwpx,.doc,.docx,.xls,.xlsx">
						<div id="list_ELIGIBILITY_PROOF" class="info-box"
							style="margin-top: 8px; min-height: 40px;">선택된 파일 없음</div>
					</div>
				</div>
			</div>

			<div class="submit-button-container">
				<a href="${pageContext.request.contextPath}/comp/main"
					class="btn btn-soft"
					style="background: #6c757d; border-color: #6c757d; color: #fff;">목록으로</a>
				<button type="submit" class="btn btn-primary submit-button">저장하기</button>
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
    // 공통 유틸 및 입력 필드 바인딩
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
    
    const weeklyEl = document.getElementById('weeklyHours');
    if (weeklyEl) {
      weeklyEl.addEventListener('input', () => {
        weeklyEl.value = (weeklyEl.value || '').replace(/[^\d]/g, '').slice(0, 3); 
      });
    }
    
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
    	normalizeDate(document.getElementById('child-date'));
    	normalizeDate(document.getElementById('start-date'));
    	normalizeDate(document.getElementById('end-date'));
    	
    	function bindYMDMask(el){
    		  if (!el) return;
    		  el.addEventListener('input', () => {
    		    // 숫자만 추출하고 최대 8자리로 제한
    		    const digits = (el.value || '').replace(/[^\d]/g, '').slice(0, 8);
    		    const y = digits.slice(0, 4);
    		    const m = digits.slice(4, 6);
    		    const d = digits.slice(6, 8);
    		    // 입력 중에도 즉시 yyyy-mm-dd 형태로 보이게
    		    el.value = [y, m, d].filter(Boolean).join('-');
    		  });
    		}

    		bindYMDMask(document.getElementById('child-date'));
    		bindYMDMask(document.getElementById('start-date'));
    		bindYMDMask(document.getElementById('end-date'));




    allowDigitsAndCommas(document.getElementById('regularWage'), 19);
    bindDigitsOnly(document.getElementById('weeklyHours'));
    bindDigitsOnly(document.getElementById('response-phone'));
    bindDigitsOnly(document.getElementById('employee-rrn-a'));
    bindDigitsOnly(document.getElementById('employee-rrn-b'));
    bindDigitsOnly(document.getElementById('child-rrn-a'));
    bindDigitsOnly(document.getElementById('child-rrn-b'));
    bindDigitsOnly(document.getElementById('weeklyHours'));

function guardBeforeGenerate() {
  const chkPregnant = document.getElementById('pregnant-leave');
  const chkNoRRN    = document.getElementById('no-rrn-foreign');

  const childDateEl = document.getElementById('child-date');
  const childNameEl = document.getElementById('child-name');
  const rrnA        = document.getElementById('child-rrn-a');
  const rrnB        = document.getElementById('child-rrn-b');

  const parseDate = s => s ? new Date(s + 'T00:00:00') : null;

  const isPregnant = !!chkPregnant?.checked;
  const noRRN      = !!chkNoRRN?.checked;

  const childDate  = parseDate(childDateEl?.value);
  const startDate  = parseDate(startDateInput?.value);
  const endDate    = parseDate(endDateInput?.value);

  if (!startDate || !endDate) { 
    alert('육아휴직 시작일과 종료일을 먼저 선택해 주세요.'); 
    return false; 
  }
  if (!childDate) { 
    alert('출산(예정)일을 먼저 입력해 주세요.'); 
    return false; 
  }

  if (isPregnant) {
    // 임신 중
    if (endDate >= childDate) { 
      alert('임신 중 육아휴직은 출산(예정)일 전날까지만 가능합니다.'); 
      return false; 
    }
    if (startDate >= childDate) { 
      alert('임신 중 육아휴직은 출산(예정)일 이전에만 시작할 수 있습니다.'); 
      return false; 
    }
  } else {
    // 출산 후
    const nameVal = (childNameEl?.value || '').trim();
    const a = (rrnA?.value || '').replace(/[^\d]/g,'');
    const b = (rrnB?.value || '').replace(/[^\d]/g,'');

    if (!nameVal) { 
      alert('출산 후 신청 시 자녀 이름을 입력해야 합니다.'); 
      childNameEl?.focus(); 
      return false; 
    }

    if (!noRRN) {
      if (!(a.length === 6 && b.length === 7)) {
        alert('출산 후 신청 시 자녀 주민등록번호(앞 6자리/뒤 7자리)를 반드시 입력해야 합니다.');
        (a.length !== 6 ? rrnA : rrnB)?.focus();
        return false;
      }
    }

    if (startDate < childDate) { 
      alert('출산 후 육아휴직은 출산(예정)일 이후로만 시작할 수 있습니다.'); 
      return false; 
    }
  }

  return true;
}


    
    // 단위기간 생성 로직 
   var startDateInput = document.getElementById('start-date');
   var endDateInput = document.getElementById('end-date');
   var generateBtn = document.getElementById('generate-forms-btn');
   var formsContainer = document.getElementById('dynamic-forms-container');
   var noPaymentChk = document.getElementById('no-payment');
   var noPaymentWrapper = document.getElementById('no-payment-wrapper');
   var headerRow = document.getElementById('dynamic-header-row');


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

   generateBtn.addEventListener('click',  async function() {
	   // UI 초기화
	   function resetUI() {
	     formsContainer.innerHTML = '';
	     if (noPaymentWrapper) noPaymentWrapper.style.display = 'none';
	     if (headerRow) headerRow.style.display = 'none';
	   }

	   // 임신/출산 제약 + 자녀이름/주민번호 조건
	   if (!guardBeforeGenerate()) {
	     resetUI();
	     return;
	   }

	   // 기본 날짜 존재/역전 체크
	   if (!startDateInput.value || !endDateInput.value) {
	     alert('육아휴직 시작일과 종료일을 모두 선택해주세요.');
	     resetUI();
	     return;
	   }
	   const originalStartDate = new Date(startDateInput.value + 'T00:00:00');
	   const finalEndDate = new Date(endDateInput.value + 'T00:00:00');
	   if (originalStartDate > finalEndDate) {
	     alert('종료일은 시작일보다 빠를 수 없습니다.');
	     resetUI();
	     return;
	   }

	   // 이전 확인서 기간 겹침 조회 
	   const okPrev = await showPrevPeriodAlert();
	   if (!okPrev) {
	     resetUI();
	     return;
	   }

	   // 최소 1개월 / 최대 12개월
	   const firstPeriodEndDate = getPeriodEndDate(originalStartDate, 1);
	   if (finalEndDate < firstPeriodEndDate) {
	     alert('신청 기간은 최소 1개월 이상이어야 합니다.');
	     resetUI();
	     return;
	   }
	   let monthCount = (finalEndDate.getFullYear() - originalStartDate.getFullYear()) * 12;
	   monthCount -= originalStartDate.getMonth();
	   monthCount += finalEndDate.getMonth();
	   if (finalEndDate.getDate() >= originalStartDate.getDate()) monthCount++;
	   if (monthCount > 12) {
	     alert('최대 12개월까지만 신청 가능합니다. 종료일을 조정해주세요.');
	     resetUI();
	     return;
	   }

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

   startDateInput.addEventListener('change', function () {
	   if (startDateInput.value) {
	     endDateInput.min = startDateInput.value;
	   } else {
	     endDateInput.removeAttribute('min');
	   }
	   formsContainer.innerHTML = '';
	   if (noPaymentWrapper) noPaymentWrapper.style.display = 'none';
	   if (headerRow) headerRow.style.display = 'none';
	 });

	 endDateInput.addEventListener('change', function () {
	   formsContainer.innerHTML = '';
	   if (noPaymentWrapper) noPaymentWrapper.style.display = 'none';
	   if (headerRow) headerRow.style.display = 'none';
	 });
	 
	// 임신/출산체크 + 출산(예정)일 + 시작/종료일 유효성 검사
	 function validatePeriodRules() {
	   const chkPregnant = document.getElementById('pregnant-leave');
	   const childDateEl = document.getElementById('child-date');
	   const startDateEl = document.getElementById('start-date');
	   const endDateEl   = document.getElementById('end-date');

	   const parseDate = (s) => s ? new Date(s + 'T00:00:00') : null;

	   const isPregnant = !!chkPregnant?.checked;
	   const childDate  = parseDate(childDateEl?.value);
	   const startDate  = parseDate(startDateEl?.value);
	   const endDate    = parseDate(endDateEl?.value);

	   // 기본 입력 누락
	   if (!startDate || !endDate)  return { ok:false, msg:'육아휴직 시작일과 종료일을 먼저 선택해 주세요.' };
	   if (!childDate)              return { ok:false, msg:'출산(예정)일을 먼저 입력해 주세요.' };

	   if (isPregnant) {
	     // 임신 중: 시작일 < 출산일, 종료일 ≤ 출산일-1
	     if (endDate >= childDate)  return { ok:false, msg:'임신 중 육아휴직은 출산(예정)일 전날까지만 가능합니다.' };
	     if (startDate >= childDate)return { ok:false, msg:'임신 중 육아휴직은 출산(예정)일 이전에만 시작할 수 있습니다.' };
	   } else {
	     // 출산 후: 시작일 ≥ 출산일
	     if (startDate < childDate) return { ok:false, msg:'출산 후 육아휴직은 출산(예정)일 이후로만 시작할 수 있습니다.' };
	   }

	   return { ok:true, msg:'' };
	 }

	// 임신중/출산후 규칙 (입력 중에는 알림/리셋 없음)
	(function applyPregnancyRules() {
	  const chkPregnant = document.getElementById('pregnant-leave');
	  const chkNoRRN    = document.getElementById('no-rrn-foreign');

	  const childDateEl = document.getElementById('child-date');
	  const childNameEl = document.getElementById('child-name');
	  const rrnA        = document.getElementById('child-rrn-a');
	  const rrnB        = document.getElementById('child-rrn-b');

	  const startDateInput = document.getElementById('start-date');
	  const endDateInput   = document.getElementById('end-date');

	  const parseDate = (s) => s ? new Date(s + 'T00:00:00') : null;
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
	    const noRRN = !!chkNoRRN.checked;
	    toggleDisabled(rrnA, noRRN);
	    toggleDisabled(rrnB, noRRN);
	  });

	  onAnyChangeSoft();
	})();


       //출생일 입력 시 
   (function syncChildDateHidden(){
	   const dateEl = document.getElementById('child-date');
	   const hidden = document.getElementById('childBirthDateHidden');
	   function sync(){ if (hidden) hidden.value = dateEl?.value || ''; }
	   if (dateEl){
	     dateEl.addEventListener('change', sync);
	     sync();
	   }
	 })();

   //저장 버튼 클릭 시  누락 최종 검사

(function wireSubmitValidation(){
  const form = document.getElementById('confirm-form');
  if (!form) return;

  const onlyDigits = s => (s || '').replace(/[^\d]/g, '');

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
        if (!v){
          missing.push(label);
          if (!firstBadEl) firstBadEl = el;
        }
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

      if (!centerId || !centerId.value.trim()) {
        missing.push('처리 센터 선택');
      }

      // 근로자 주민번호(6+7자리)
      if (!empA || onlyDigits(empA.value).length !== 6) {
        missing.push('근로자 주민등록번호(앞 6자리)');
        if (!firstBadEl) firstBadEl = empA;
      }
      if (!empB || onlyDigits(empB.value).length !== 7) {
        missing.push('근로자 주민등록번호(뒤 7자리)');
        if (!firstBadEl) firstBadEl = empB;
      }

      // 출산 후일 경우 자녀 이름 , 주민번호  미발급 확인
      const isPregnant = !!document.getElementById('pregnant-leave')?.checked;
      if (!isPregnant) {
        const nameEl = document.getElementById('child-name');
        const rrnA   = document.getElementById('child-rrn-a');
        const rrnB   = document.getElementById('child-rrn-b');
        const noRRN  = !!document.getElementById('no-rrn-foreign')?.checked;

        const nameVal = (nameEl?.value || '').trim();
        const a = onlyDigits(rrnA?.value);
        const b = onlyDigits(rrnB?.value);

        if (!nameVal) {
          missing.push('자녀 이름');
          if (!firstBadEl) firstBadEl = nameEl;
        }
        if (!noRRN && !(a.length === 6 && b.length === 7)) {
          missing.push('자녀 주민등록번호');
          if (!firstBadEl) firstBadEl = rrnA || rrnB;
        }
      }

      if (missing.length){
        const uniq = [...new Set(missing)];
        alert('모든 필수 항목을 입력해야 저장할 수 있습니다.\n\n누락 항목:\n- ' + uniq.join('\n- '));
        if (firstBadEl && typeof firstBadEl.focus === 'function') {
          firstBadEl.scrollIntoView({behavior:'smooth', block:'center'});
          setTimeout(()=> firstBadEl.focus(), 200);
        }
        submitting = false;
        return;
      }

      const ok = await showPrevPeriodAlert();
      if (!ok) {
        submitting = false;
        return;
      }
      doFinalNormalizeBeforeSubmit();
      
      const up = await uploadAllFilesBeforeSubmit();

      if (!up.ok) {
        alert('파일 업로드 중 오류가 발생했습니다.');
        submitting = false;
        return;
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
        if (hidden) hidden.remove();
      }

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
//최종 제출 직전 데이터 정리
function doFinalNormalizeBeforeSubmit() {
// 금액 필드에서 콤마 제거
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

// 자녀 주민번호 합치기 
const childRrnHidden = document.getElementById('child-rrn-hidden');
if (childRrnHidden) {
 const a = (document.getElementById('child-rrn-a').value || '').replace(/[^\d]/g,'');
 const b = (document.getElementById('child-rrn-b').value || '').replace(/[^\d]/g,'');
 childRrnHidden.value = (a.length === 6 && b.length === 7) ? (a + b) : '';
}

// 출생(예정)일 
const hidden = document.getElementById('childBirthDateHidden');
if (hidden && !hidden.value) hidden.removeAttribute('name');
}

    // 엔터 막기
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

      if (!isTextArea && !isButton && !allowAttr) {
        e.preventDefault();
      }
    });
  }
}
    // 센터 찾기 모달 처리
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

//직원 주민번호로 이름 자동 채우기
// 주민번호로 이름 자동 채우기 + 같은 버튼으로 '근로자 확인' ↔ '지우기' 토글 + 기간 초기화
(function wireFindName(){
  const btn    = document.getElementById('find-employee-btn');
  const aEl    = document.getElementById('employee-rrn-a');
  const bEl    = document.getElementById('employee-rrn-b');
  const nameEl = document.getElementById('employee-name');
  const hidEl  = document.getElementById('employee-rrn-hidden');

  if (!btn || !aEl || !bEl || !nameEl) return;

  function onlyDigits(s){ return (s || '').replace(/[^\d]/g, ''); }

  const ctx = '${pageContext.request.contextPath}';
  const url = ctx + '/comp/apply/find-name';

  let mode = 'find';    // 'find' = 근로자 확인 모드, 'reset' = 지우기 모드
  let loading = false;  // 중복 클릭 방지

  // 🔸 기간/단위기간 관련 필드 초기화
  function resetPeriodFields() {
    const startDate        = document.getElementById('start-date');
    const endDate          = document.getElementById('end-date');
    const formsContainer   = document.getElementById('dynamic-forms-container');
    const headerRow        = document.getElementById('dynamic-header-row');
    const noPaymentWrapper = document.getElementById('no-payment-wrapper');
    const noPaymentChk     = document.getElementById('no-payment');

    if (startDate) startDate.value = '';
    if (endDate)   endDate.value = '';

    if (formsContainer)   formsContainer.innerHTML = '';
    if (headerRow)        headerRow.style.display = 'none';
    if (noPaymentWrapper) noPaymentWrapper.style.display = 'none';
    if (noPaymentChk)     noPaymentChk.checked = false;

    // 이전 기간 정보도 리셋(겹침 체크용)
    window.prevPeriod = { start: null, end: null, overlap: false };
  }

  // 🔸 버튼/필드 상태 바꾸는 공통 함수
  function setMode(newMode){
    mode = newMode;

    if (mode === 'find') {
      // ✅ 다시 조회할 수 있게: 버튼 텍스트/스타일 + 주민번호 입력 가능
      btn.textContent = '이름 검색';
      btn.classList.remove('btn-soft');
      btn.classList.add('btn-secondary');

      [aEl, bEl].forEach(el => {
        el.readOnly = false;
        el.classList.remove('readonly-like');
      });

    } else { // 'reset'
      // ✅ 이름 조회된 상태: 주민번호 잠그고 버튼을 "지우기"
      btn.textContent = '지우기';
      btn.classList.remove('btn-secondary');
      btn.classList.add('btn-soft');

      [aEl, bEl].forEach(el => {
        el.readOnly = true;
        el.classList.add('readonly-like');
      });
    }
  }

  // 초기 상태
  setMode('find');

  btn.addEventListener('click', async function(){
    if (loading) return;

    // 🔹 지우기 모드일 때: 전체 초기화
    if (mode === 'reset') {
      aEl.value = '';
      bEl.value = '';
      nameEl.value = '';
      if (hidEl) hidEl.value = '';

      // 🔸 지우기 눌렀을 때도 기간 초기화
      resetPeriodFields();

      setMode('find');
      aEl.focus();
      return;
    }

    // 🔹 여기부터는 'find' 모드 = 근로자 확인
    const a = onlyDigits(aEl.value);
    const b = onlyDigits(bEl.value);

    if (a.length !== 6 || b.length !== 7) {
      alert('근로자 주민등록번호 앞 6자리와 뒤 7자리를 정확히 입력하세요.');
      (a.length !== 6 ? aEl : bEl).focus();
      return;
    }

    const regNo = a + b;
    if (hidEl) hidEl.value = regNo;

    // 🔸 새로운 이름 조회 시도 → 기존 기간/단위기간 먼저 초기화
    resetPeriodFields();

    const csrfInput = document.querySelector('input[name="_csrf"]');
    const csrfToken = csrfInput ? csrfInput.value : null;

    try {
      loading = true;

      const body = new URLSearchParams({ regNo });
      if (csrfToken) body.append('_csrf', csrfToken);

      const resp = await fetch(url, {
        method: 'POST',
        credentials: 'same-origin',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
          ...(csrfToken ? { 'X-CSRF-TOKEN': csrfToken } : {})
        },
        body
      });

      const ct = (resp.headers.get('content-type') || '').toLowerCase();
      if (!resp.ok) {
        console.error('[find-name] HTTP', resp.status, await resp.text().catch(()=> ''));
        alert('이름 조회 요청에 실패했습니다. (' + resp.status + ')');
        return;
      }
      if (!ct.includes('application/json')) {
        console.error('[find-name] not JSON', ct, await resp.text().catch(()=> ''));
        alert('서버 응답이 JSON이 아닙니다. (로그인 리다이렉트/시큐리티 확인)');
        return;
      }

      const data = await resp.json();
      if (data && data.found && data.name) {
        // ✅ 이름 조회 성공
        nameEl.value = data.name;
        // → 주민번호 잠그고 버튼을 "지우기" 모드로 변경
        setMode('reset');
      } else {
        alert('일치하는 근로자 정보를 찾을 수 없습니다.');
      }
    } catch (e) {
      console.error(e);
      alert('일시적인 오류로 조회에 실패했습니다.');
    } finally {
      loading = false;
    }
  });
})();



//이전 육휴기간(최신 1건) 조회 
function renderClientAlert({ type = 'info', html = '' }) {
  const wrap = document.getElementById('client-alerts');
  if (!wrap) return;

  const prev = wrap.querySelector(`.alert.alert-${type}`);
  if (prev) prev.remove();

  const div = document.createElement('div');
  div.className = `alert alert-${type}`;
  div.style.marginTop = '10px';
  div.innerHTML = html;
  wrap.prepend(div);
  div.scrollIntoView({ behavior: 'smooth', block: 'center' });
}

// 이전 기간 조회 후 유효성검사
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

    const csrfToken = document.querySelector('input[name="_csrf"]')?.value || null;
    const CTX = '${pageContext.request.contextPath}';

    const resp = await fetch(CTX + '/comp/apply/leave-period', {
      method: 'POST',
      credentials: 'same-origin',
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        ...(csrfToken ? { 'X-CSRF-TOKEN': csrfToken } : {})
      },
      body: JSON.stringify({ name, regNo })
    });

    if (resp.status === 204) {
      window.prevPeriod = { start:null, end:null, overlap:false };
      return true;
    }
    const ct = (resp.headers.get('content-type') || '').toLowerCase();
    if (!ct.includes('application/json')) {
      window.prevPeriod = { start:null, end:null, overlap:false };
      return true;
    }

    const text = await resp.text();
    if (!resp.ok || !text) {
      window.prevPeriod = { start:null, end:null, overlap:false };
      return true;
    }
    const data = JSON.parse(text) || {};

    function toDateSafe(v){
      if (v == null) return null;
      if (typeof v === 'number' || /^\d+$/.test(String(v))) {
        let n = Number(v);
        if (String(v).length === 10) n *= 1000;
        const d = new Date(n);
        return isNaN(d) ? null : d;
      }
      let s = String(v).trim();
      if (/^\d{4}-\d{2}-\d{2}$/.test(s)) s += 'T00:00:00';
      if (/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/.test(s)) s = s.replace(' ', 'T');
      const d1 = new Date(s); if (!isNaN(d1)) return d1;
      const d2 = new Date(s.replace(/-/g,'/')); return isNaN(d2) ? null : d2;
    }
    function two(n){ return (n<10?'0':'')+n; }
    function fmt(d){ return d.getFullYear()+'.'+two(d.getMonth()+1)+'.'+two(d.getDate()); }
    function parseInputDate(id){
      const el = document.getElementById(id);
      return (el && el.value) ? new Date(el.value + 'T00:00:00') : null;
    }
    function isOverlap(aStart,aEnd,bStart,bEnd){
      if (!aStart || !aEnd || !bStart || !bEnd) return false;
      return aStart <= bEnd && bStart <= aEnd;
    }

    const startRaw = data.startDate ?? data.STARTDATE ?? data.start_date;
    const endRaw   = data.endDate   ?? data.ENDDATE   ?? data.end_date;

    const prevS = toDateSafe(startRaw);
    const prevE = toDateSafe(endRaw);

    if (!prevS || !prevE) {
      window.prevPeriod = { start:null, end:null, overlap:false };
      return true;
    }

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
    return true;
  }
}


async function uploadAllFilesBeforeSubmit() {
  const fd = new FormData();
  let fileCount = 0;

  const typeOrder = [
    'WAGE_PROOF',
    'PAYMENT_FROM_EMPLOYER',
    'OTHER',
    'ELIGIBILITY_PROOF'
  ];

  typeOrder.forEach(type => {
    const arr = FILE_STORE[type] || [];
    arr.forEach(f => {
      fd.append('files', f);
      fd.append('fileTypes', type);
      fileCount++;
    });
  });

  if (fileCount === 0) {
    return { ok: true, skipped: true, fileId: null };
  }

  const CTX  = '${pageContext.request.contextPath}';
  const csrf = document.querySelector('input[name="_csrf"]')?.value;

  const resp = await fetch(CTX + '/file/upload', {
    method: 'POST',
    body: fd,
    credentials: 'same-origin',
    headers: csrf ? { 'X-CSRF-TOKEN': csrf } : {}
  });

  if (!resp.ok) {
    console.error('[upload] HTTP', resp.status, await resp.text().catch(()=> ''));
    return { ok: false, skipped: false, fileId: null };
  }

  const ct = (resp.headers.get('content-type') || '').toLowerCase();
  if (!ct.includes('application/json')) {
    console.error('[upload] Not JSON', ct, await resp.text().catch(()=> ''));
    return { ok: false, skipped: false, fileId: null };
  }

  const data = await resp.json().catch(()=> null);
  const fileId = data?.fileId ?? null;

  if (!fileId) {
    return { ok: false, skipped: false, fileId: null };
  }
  return { ok: true, skipped: false, fileId };
}

const FILE_STORE = {
  WAGE_PROOF: [],
  PAYMENT_FROM_EMPLOYER: [],
  OTHER: [],
  ELIGIBILITY_PROOF: []
};

(function initFilePills() {
  const groups = [
    { type: 'WAGE_PROOF',            inputId: 'files_WAGE_PROOF',            listId: 'list_WAGE_PROOF' },
    { type: 'PAYMENT_FROM_EMPLOYER', inputId: 'files_PAYMENT_FROM_EMPLOYER', listId: 'list_PAYMENT_FROM_EMPLOYER' },
    { type: 'OTHER',                 inputId: 'files_OTHER',                 listId: 'list_OTHER' },
    { type: 'ELIGIBILITY_PROOF',     inputId: 'files_ELIGIBILITY_PROOF',     listId: 'list_ELIGIBILITY_PROOF' }
  ];

  function renderList(type, listEl) {
    const arr = FILE_STORE[type] || [];

    if (!arr.length) {
      listEl.textContent = '선택된 파일 없음';
      return;
    }

    listEl.innerHTML = '';

    arr.forEach((file, idx) => {
      const pill = document.createElement('div');
      pill.className = 'file-pill';

      const sizeMb = (file.size / 1024 / 1024).toFixed(1);

      const labelSpan = document.createElement('span');
      labelSpan.textContent = file.name + ' (' + sizeMb + 'MB)';

      const btn = document.createElement('button');
      btn.type = 'button';
      btn.className = 'file-remove-btn';
      btn.innerHTML = '&times;';

      btn.addEventListener('click', () => {
        FILE_STORE[type].splice(idx, 1);
        renderList(type, listEl);
      });

      pill.appendChild(labelSpan);
      pill.appendChild(btn);
      listEl.appendChild(pill);
    });
  }

  groups.forEach(g => {
    const inputEl = document.getElementById(g.inputId);
    const listEl  = document.getElementById(g.listId);
    if (!inputEl || !listEl) return;

    renderList(g.type, listEl);

    inputEl.addEventListener('change', () => {
      if (!inputEl.files || !inputEl.files.length) return;

      const storeArr = FILE_STORE[g.type];

      Array.from(inputEl.files).forEach(f => {
        const dup = storeArr.some(x =>
          x.name === f.name &&
          x.size === f.size &&
          x.lastModified === f.lastModified
        );
        if (!dup) {
          storeArr.push(f);
        }
      });

      inputEl.value = '';

      renderList(g.type, listEl);
    });
  });
})();


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
