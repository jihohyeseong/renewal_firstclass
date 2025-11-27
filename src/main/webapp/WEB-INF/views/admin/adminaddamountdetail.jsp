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
	
	*{margin:0;padding:0;box-sizing:border-box}
	html{height:100%}
	body{
		display:flex;flex-direction:column;min-height:100vh;
		font-family:'Noto Sans KR',sans-serif;background-color:var(--light-gray-color);
		color:var(--dark-gray-color);
	}
	a{text-decoration:none;color:inherit}
	
	.header,.footer{
		background-color:var(--white-color);padding:15px 40px;border-bottom:1px solid var(--border-color);box-shadow:var(--shadow-sm);
	}
	.footer{border-top:1px solid var(--border-color);border-bottom:none;text-align:center;padding:20px 0;margin-top:auto}
	.header{display:flex;justify-content:space-between;align-items:center;position:sticky;top:0;z-index:10}
	.header nav{display:flex;align-items:center;gap:15px}
	.header .welcome-msg{font-size:16px}
	
	.main-container{
		flex-grow:1;width:100%;max-width:1200px;margin:40px auto;padding:40px;
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
		width:100%;border-collapse:collapse;
		border-top:2px solid var(--border-color);
		border-left:none;border-right:none;
	}
	.info-table th,.info-table td{
		padding:12px 15px;border:1px solid var(--border-color);
		text-align:left;font-size:15px;
	}
	.info-table th{
		background-color:var(--light-gray-color);
		font-weight:500;width:150px;color:var(--dark-gray-color);
	}
	.info-table td{background-color:var(--white-color);color:#333}
	.info-table.table-4col th{width:120px;background-color:var(--light-gray-color)}
	.info-table.table-4col td{width:auto}
	.info-table.table-4col th,.info-table.table-4col td{border-top:none}
	.info-table tr:first-child th,.info-table tr:first-child td{border-top:1px solid var(--border-color)}
	.info-table thead th {
        text-align: center !important;
    }

    .text-right { text-align: right !important; }
    .text-center { text-align: center !important; }
    
    .info-table td.text-right {
        padding-right: 20px;
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
		background-color: #f8d7da; /* 부드러운 빨간색 배경 */
		color: var(--danger-color); /* 진한 빨간색 텍스트 */
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
		background-color: #dbe4ff; 
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
		position: absolute; top: 50%; left: 6%;
		height: 8px; border-radius: 8px; background-color: var(--primary-color);
		z-index: 1; transform: translateY(-50%);
		width: 0%; max-width: 88%; transition: width .35s ease;
	}
	
	  .button-container {
	    text-align: center;
	    margin-top: 20px;
	    padding-bottom: 20px;
	  }
	
	  .judge-actions { 
		text-align: right; 
		margin-top: 20px; 
		padding-bottom: 20px;
	}
	  
	  .btn-primary, .btn-secondary {
	    padding: 6px 14px; 
	    font-size: 14px;
	  }
	  
	.btn-danger {
		padding: 6px 14px;
		font-size: 14px;
		background-color: #f44336;
		border-color: #f44336;
		color: white;
		cursor: pointer;
		border-radius: 4px;
		transition: background-color 0.2s;
	}
	.btn-danger:hover {
		background-color: #d32f2f;
		border-color: #d32f2f;
	}
	
	.reason-item {
		position: relative;
		box-sizing: border-box;
		flex: 0 0 calc(50% - 12px); 
		max-width: 220px;         
	}
	
	.reason-item input[type="radio"] {
		position: absolute;
		opacity: 0;
		pointer-events: none;
	}
	
	.reason-item label {
		display: flex;
		align-items: center;
		padding: 12px 10px;
		background: linear-gradient(135deg, #ffffff 0%, #f9fafb 100%);
		border: 2px solid transparent;
		border-radius: 10px;
		cursor: pointer;
		transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
		font-size: 14px;
		font-weight: 500;
		color: #4b5563;
		box-shadow: 0 1px 3px rgba(0,0,0,0.06);
		position: relative;
	}
	
	.reason-item label::after {
		content: '';
		position: absolute;
		right: 18px;
		top: 50%;
		transform: translateY(-50%) scale(0);
		width: 20px;
		height: 20px;
		background: #ef4444;
		border-radius: 50%;
		transition: transform 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55);
	}
	
	.reason-item label::before {
		content: '✓';
		position: absolute;
		right: 24px;
		top: 50%;
		transform: translateY(-50%) scale(0);
		color: white;
		font-size: 12px;
		font-weight: bold;
		z-index: 1;
		transition: transform 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55) 0.05s;
	}
	
	.reason-item label:hover {
		transform: translateY(-3px);
		box-shadow: 0 8px 20px rgba(0,0,0,0.12);
		border-color: #e5e7eb;
	}
	
	.reason-item label:has(input[type="radio"]:checked) {
		border-color: #f9fafb;
		color: #991b1b;
		font-weight: 600;
		box-shadow: 0 8px 24px rgba(239, 68, 68, 0.2);
		padding-right: 55px;
	}
	
	.reason-item label:has(input[type="radio"]:checked)::after {
		transform: translateY(-50%) scale(1);
	}
	
	.reason-item label:has(input[type="radio"]:checked)::before {
		transform: translateY(-50%) scale(1);
	}
	
	.comment-wrapper {
		margin-top: 24px;
	}
	
	.comment-label {
		display: block;
		font-weight: 600;
		color: #333;
		margin-bottom: 8px;
		font-size: 15px;
		text-align: left;
	}
	
	#rejectComment {
		width: 100%;
		padding: 12px;
		border: 2px solid #e0e0e0;
		border-radius: 8px;
		font-size: 14px;
		resize: vertical;
		min-height: 80px;
		font-family: inherit;
		transition: all 0.3s ease;
		text-align: left;
		display: block;
		margin: 0;
	}
	
	#rejectComment:focus {
		outline: none;
		border-color: #f44336;
		box-shadow: 0 0 0 3px rgba(244, 67, 54, 0.1);
	}
	
	@keyframes fadeInDown {
		from { opacity: 0; transform: translateY(-10px); }
		to { opacity: 1; transform: translateY(0); }
	}
</style>
</head>
<body>

<jsp:include page="adminheader.jsp" />

<main class="main-container">
<c:set var="status" value="${appDTO.statusCode}" />
<c:set var="payRes" value="${appDTO.paymentResult}" />

<c:set var="currentStep" value="2" />
<c:choose>
	<c:when test="${status == 'ST_20'}"><c:set var="currentStep" value="1"/></c:when>
	<c:when test="${status == 'ST_30'}"><c:set var="currentStep" value="2"/></c:when>
	<c:when test="${status == 'ST_40'}"><c:set var="currentStep" value="4"/></c:when>
	<c:when test="${status == 'ST_60'}"><c:set var="currentStep" value="3"/></c:when>
</c:choose>
<c:if test="${status == 'ST_50'}"><c:set var="currentStep" value="5"/></c:if>

<c:set var="progressWidth" value="0"/>
<c:choose>
	<c:when test="${currentStep == 1}"><c:set var="progressWidth" value="0"/></c:when>
	<c:when test="${currentStep == 2}"><c:set var="progressWidth" value="25"/></c:when>
	<c:when test="${currentStep == 3}"><c:set var="progressWidth" value="50"/></c:when>
	<c:when test="${currentStep == 4}"><c:set var="progressWidth" value="75"/></c:when>
	<c:when test="${currentStep == 5}"><c:set var="progressWidth" value="100"/></c:when>
</c:choose>

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
<h1>육아휴직 급여 추가지급</h1>

<div class="info-table-container">
	<h2 class="section-title">접수정보</h2>
	<table class="info-table table-4col">
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
				<td><c:out value="${appDTO.applicantName}" /></td>
			</tr>
		</tbody>
	</table>
</div>

<div class="info-table-container">
	<h2 class="section-title">신청인 정보 (육아휴직자)</h2>
	<table class="info-table table-4col">
		<tbody>
			<tr>
				<th>이름</th>
				<td colspan="3"><c:out value="${appDTO.applicantName}" /></td>
			</tr>
			<tr>
				<th>주민등록번호</th>
				<td colspan="3">
					<c:if test="${not empty appDTO.applicantResiRegiNumber}">
						<c:set var="rrnRaw" value="${appDTO.applicantResiRegiNumber}" />
						<c:set var="rrnDigits" value="${fn:replace(fn:replace(fn:trim(rrnRaw), '-', ''), ' ', '')}" />
						${fn:substring(rrnDigits,0,6)}-${fn:substring(rrnDigits,6,12)}
					</c:if>
					<c:if test="${empty appDTO.applicantResiRegiNumber}">
						<span class="highlight-warning">미입력</span>
					</c:if>
				</td>
			</tr>
			<tr>
				<th>휴대전화번호</th>
				<td colspan="3">
					<c:if test="${not empty appDTO.applicantPhoneNumber}">
						<c:out value="${appDTO.applicantPhoneNumber}" />
					</c:if>
					<c:if test="${empty appDTO.applicantPhoneNumber}">
						<span class="highlight-warning">미입력</span>
					</c:if>
				</td>
			</tr>
			<tr>
				<th>주소</th>
				<td colspan="3">
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

<div class="info-table-container">
	<h2 class="section-title">사업장 정보 (회사)</h2>
	<table class="info-table table-4col">
		<tbody>
			<tr>
				<th>사업장 이름</th>
				<td colspan="3">
					<c:if test="${empty appDTO.businessName}">
						<span class="highlight-warning">미입력</span>
					</c:if>
					<c:if test="${not empty appDTO.businessName}">${appDTO.businessName}</c:if>
				</td>
			</tr>
			<tr>
				<th>사업장 <br>등록번호</th>
				<td>
					<c:choose>
						<c:when test="${empty appDTO.businessRegiNumber}">
							<span class="highlight-warning">미입력</span>
						</c:when>
						<c:otherwise>
							<c:set var="bizRaw" value="${appDTO.businessRegiNumber}" />
							<c:set var="bizDigits" value="${fn:replace(fn:replace(fn:replace(fn:trim(bizRaw), '-', ''), ' ', ''), ',', '')}" />
							<c:choose>
								<c:when test="${fn:length(bizDigits) == 10}">
									${fn:substring(bizDigits,0,3)}-${fn:substring(bizDigits,3,5)}-${fn:substring(bizDigits,5,10)}
								</c:when>
								<c:otherwise>
									<span class="highlight-warning"><c:out value="${bizRaw}" /></span>
								</c:otherwise>
							</c:choose>
						</c:otherwise>
					</c:choose>
				</td>
				<th>인사담당자 <br>연락처</th>
				<td>02-9876-5432</td>
			</tr>
			<tr>
				<th>사업장 주소</th>
				<td colspan="3">
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

<div class="info-table-container">
	<h2 class="section-title">급여 신청 기간 및 월별 내역</h2>
	<table class="info-table table-4col">
		<tbody>
			<tr>
				<th>육아휴직 <br>시작일</th>
				<td>
					<c:if test="${empty appDTO.startDate}"><span class="highlight-warning">미입력</span></c:if>
					<c:if test="${not empty appDTO.startDate}">${appDTO.startDate}</c:if>
				</td>
				<th>총 휴직 기간</th>
				<td id="total-leave-period">(${empty appDTO.startDate ? '미입력' : appDTO.startDate}
					~ ${empty appDTO.endDate ? '미입력' : appDTO.endDate})</td>
			</tr>
			<tr>
				<th>월별 분할 <br>신청 여부</th>
				<td colspan="3">아니오 (일괄 신청)</td>
			</tr>
		</tbody>
	</table>

	<h3 class="section-title" style="font-size: 16px; margin-top: 25px;">월별 지급 내역</h3>
	<table class="info-table table-5col">
		<thead>
			<tr>
				<th>시작일</th>
				<th>종료일</th>
				<th>사업장 지급액</th>
				<th>정부 지급액</th>
			</tr>
		</thead>
		<tbody>
			<c:set var="totalAmount" value="${0}" />
			
			<c:forEach var="item" items="${dto.list}" varStatus="status">
								<tr>
									<td class="text-center">
										<fmt:formatDate value="${item.startMonthDate}" pattern="yyyy.MM.dd"/>
									</td>
							
									<td class="text-center">
										<c:choose>
											<c:when test="${not empty item.earlyReturnDate}">
												<fmt:formatDate value="${item.earlyReturnDate}" pattern="yyyy.MM.dd"/>
											</c:when>
											<c:otherwise>
												<fmt:formatDate value="${item.endMonthDate}" pattern="yyyy.MM.dd"/>
											</c:otherwise>
										</c:choose>
									</td>
							
									<td class="text-right">
										<fmt:formatNumber value="${item.companyPayment}" type="number" pattern="#,###" />원
									</td>
							
									<td class="text-right">
										<c:choose>
											<c:when test="${not empty item.govPaymentUpdate}">
												<fmt:formatNumber value="${item.govPaymentUpdate}" type="number" pattern="#,###" />원
											</c:when>
											<c:otherwise>
												<fmt:formatNumber value="${item.govPayment}" type="number" pattern="#,###" />원
											</c:otherwise>
										</c:choose>
									</td>
							
									<%-- <td class="text-right">
										<fmt:formatNumber
											value="${(not empty item.govPaymentUpdate ? item.govPaymentUpdate : item.govPayment)}"
											type="number"
											pattern="#,###" />원
									</td> --%>
								</tr>
							
								<c:set var="totalAmount"
									value="${totalAmount + (not empty item.govPaymentUpdate ? item.govPaymentUpdate : item.govPayment)}" />
							</c:forEach>

			<c:if test="${not empty dto.list}">
								<tr style="background-color: var(--light-gray-color);">
									<%-- <td colspan="2">
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
									</td> --%>
							
									<td colspan="3" style="text-align: center; font-weight: 700; color: var(--dark-gray-color);">
										합계 신청금액
									</td>
							
									<td style="text-align: right; font-weight: 700; font-size: 1.05em; color: var(--primary-color);">
										<fmt:formatNumber value="${totalAmount}" type="number" pattern="#,###" />원
									</td>
								</tr>
			</c:if>
		
			<c:if test="${empty dto.list}">
								<tr>
									<td colspan="5" style="text-align: center; color: #888;">단위기간 내역이 없습니다.</td>
								</tr>
			</c:if>
		</tbody>
	</table>
</div>

<div class="info-table-container">
	<h2 class="section-title">자녀 정보 (육아 대상)</h2>
	<table class="info-table table-4col">
		<tbody>
			<c:choose>
				<c:when test="${empty appDTO.childName and empty appDTO.childResiRegiNumber}">
					<tr>
						<th>출산예정일</th>
						<td colspan="3">
							<c:choose>
								<c:when test="${empty appDTO.childBirthDate}">
									<span class="highlight-warning">미입력</span>
								</c:when>
								<c:otherwise>
									<fmt:formatDate value="${appDTO.childBirthDate}" pattern="yyyy.MM.dd" />
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
				</c:when>
				<c:otherwise>
					<tr>
						<th>자녀 이름</th>
						<td>
							<c:if test="${empty appDTO.childName}"><span class="highlight-warning">미입력</span></c:if>
							<c:if test="${not empty appDTO.childName}"><c:out value="${appDTO.childName}" /></c:if>
						</td>
						<th>출산일</th>
						<td>
							<c:if test="${empty appDTO.childBirthDate}"><span class="highlight-warning">미입력</span></c:if>
							<c:if test="${not empty appDTO.childBirthDate}">
								<fmt:formatDate value="${appDTO.childBirthDate}" pattern="yyyy.MM.dd" />
							</c:if>
						</td>
					</tr>
					<tr>
						<th>주민등록번호</th>
						<td colspan="3">
							<c:if test="${empty appDTO.childResiRegiNumber}">
								<span class="highlight-warning">미입력</span>
							</c:if>
							<c:if test="${not empty appDTO.childResiRegiNumber}">
								<c:out value="${fn:substring(appDTO.childResiRegiNumber, 0, 6)}-${fn:substring(appDTO.childResiRegiNumber, 6, 12)}" />
							</c:if>
						</td>
					</tr>
				</c:otherwise>
			</c:choose>
		</tbody>
		
	</table>
</div>

<div class="info-table-container">
	<h2 class="section-title">급여 입금 계좌정보</h2>
	<table class="info-table table-4col">
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

<div class="info-table-container">
	<h2 class="section-title">접수 처리 센터 정보</h2>
	<table class="info-table table-4col">
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

<div class="info-table-container">
	<h2 class="section-title">행정정보 공동이용 동의</h2>
	<table class="info-table table-4col">
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

<c:if test="${not empty appDTO.submittedDt}">
	<div class="info-table-container">
		<h2 class="section-title">최종 동의 및 확인</h2>
		<table class="info-table table-4col">
			<tbody>
				<tr>
					<th>부정수급 <br />안내 확인</th>
					<td colspan="3">
						<span class="success-text">확인 및 동의 완료</span>
						(<fmt:formatDate value="${appDTO.submittedDt}" pattern="yyyy.MM.dd" />)
					</td>
				</tr>
				<tr>
					<th>심사 상태</th>
					<td colspan="3">
						<c:choose>
							<c:when test="${appDTO.paymentResult == 'Y'}">
								<span class="success-text">지급결정</span>
								<c:if test="${not empty appDTO.examineDt}">
									(<fmt:formatDate value="${appDTO.examineDt}" pattern="yyyy.MM.dd" />)
								</c:if>
							</c:when>
							<c:when test="${appDTO.paymentResult == 'N'}">
								<span style="color: #dc3545; font-weight: 500;">부지급결정</span>
								<c:if test="${not empty appDTO.examineDt}">
									(<fmt:formatDate value="${appDTO.examineDt}" pattern="yyyy.MM.dd" />)
								</c:if>
								<c:if test="${not empty appDTO.rejectionReasonCode or not empty appDTO.rejectComment or not empty appDTO.rejectionReasonName}">
									<br />
									<span style="display: block; margin-top: 10px; padding: 12px; border: 1px solid #d1d9ff; background: #f0f2ff; border-radius: 6px;">
										<strong>부지급 사유</strong> :
										<c:choose>
											<c:when test="${not empty appDTO.rejectionReasonName}">${appDTO.rejectionReasonName}</c:when>
											<c:when test="${not empty rejectCodeMap and not empty appDTO.rejectionReasonCode}">${rejectCodeMap[appDTO.rejectionReasonCode]}</c:when>
											<c:otherwise><c:out value="${appDTO.rejectionReasonCode}" /></c:otherwise>
										</c:choose>
										<c:if test="${not empty appDTO.rejectComment}">
											<br /><strong>상세 사유</strong> : <c:out value="${appDTO.rejectComment}" />
										</c:if>
									</span>
								</c:if>
							</c:when>
							<c:otherwise>심사중</c:otherwise>
						</c:choose>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</c:if>

<!-- 추가지급 --> 
<c:choose>
    <c:when test="${empty addAmountData}">
	<form id="addAmountForm" action="${pageContext.request.contextPath}/admin/addamount/apply" method="POST">
		
	    <input type="hidden" name="applicationNumber" value="${appDTO.applicationNumber}" />
	<div class="info-table-container">
		<h2 class="section-title">급여 신청 기간 및 월별 내역(추가지급)</h2>
		<table class="info-table table-4col">
			<tbody>
				<tr>
					<th>육아휴직 <br>시작일</th>
					<td>
						<c:if test="${empty appDTO.startDate}"><span class="highlight-warning">미입력</span></c:if>
						<c:if test="${not empty appDTO.startDate}">${appDTO.startDate}</c:if>
					</td>
					<th>총 휴직 기간</th>
					<td id="total-leave-period">(${empty appDTO.startDate ? '미입력' : appDTO.startDate}
						~ ${empty appDTO.endDate ? '미입력' : appDTO.endDate})</td>
				</tr>
				<tr>
					<th>월별 분할 <br>신청 여부</th>
					<td colspan="3">아니오 (일괄 신청)</td>
				</tr>
			</tbody>
		</table>
	
		<h3 class="section-title" style="font-size: 16px; margin-top: 25px;">월별 지급 내역</h3>
		<table class="info-table table-5col">
			<thead>
				<tr>
					<th>시작일</th>
					<th>종료일</th>
					<th>사업장 지급액</th>
					<th>정부 지급액</th>
					<th>추가지급액</th>
				</tr>
			</thead>
			<tbody>
				<c:set var="totalAmount" value="${0}" />
				
				<c:forEach var="item" items="${dto.list}" varStatus="status">
									<tr>
										<td class="text-center">
											<fmt:formatDate value="${item.startMonthDate}" pattern="yyyy.MM.dd"/>
										</td>
								
										<td class="text-center">
											<c:choose>
												<c:when test="${not empty item.earlyReturnDate}">
													<fmt:formatDate value="${item.earlyReturnDate}" pattern="yyyy.MM.dd"/>
												</c:when>
												<c:otherwise>
													<fmt:formatDate value="${item.endMonthDate}" pattern="yyyy.MM.dd"/>
												</c:otherwise>
											</c:choose>
										</td>
								
										<td class="text-right">
											<fmt:formatNumber value="${item.companyPayment}" type="number" pattern="#,###" />원
										</td>
								
										<td class="text-right">
											<c:choose>
												<c:when test="${not empty item.govPaymentUpdate}">
													<fmt:formatNumber value="${item.govPaymentUpdate}" type="number" pattern="#,###" />원
												</c:when>
												<c:otherwise>
													<fmt:formatNumber value="${item.govPayment}" type="number" pattern="#,###" />원
												</c:otherwise>
											</c:choose>
										</td>
								
										<td style="padding: 5px;">
	                                            <input type="hidden" name="termId" value="${item.termId}">
	                                            <input type="number" name="amount" class="form-control amount-input" 
	                                                   placeholder="금액 입력" min="0" step="1" 
	                                                   style="width: 120px; text-align: right; margin: auto; font-size: 14px;">
										</td>
									</tr>
								
									<c:set var="totalAmount"
										value="${totalAmount + item.companyPayment + (not empty item.govPaymentUpdate ? item.govPaymentUpdate : item.govPayment)}" />
								</c:forEach>
	
				<c:if test="${not empty dto.list}">
									<tr style="background-color: var(--light-gray-color);">
										<td colspan="2">
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
										</td>
								
										<td colspan="2" style="text-align: center; font-weight: 700; color: var(--dark-gray-color);">
											합계 신청금액
										</td>
								
										<td style="text-align: center; font-weight: 700; font-size: 1.05em; color: var(--primary-color);">
											<fmt:formatNumber value="${totalAmount}" type="number" pattern="#,###" />원
										</td>
									</tr>
				</c:if>
			
				<c:if test="${empty dto.list}">
									<tr>
										<td colspan="5" style="text-align: center; color: #888;">단위기간 내역이 없습니다.</td>
									</tr>
				</c:if>
			</tbody>
		</table>
	</div>
	
	<div class="info-table-container">
		<h2 class="section-title">추가지급 급여 입금 계좌정보</h2>
		<table class="info-table table-4col">
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
	
	<div class="info-table-container">
		<h2 class="section-title">추가지급 사유</h2>
		<table class="info-table table-4col">
			<tbody>
				<tr>
					<th>사유</th>
					<td>
						<select name="codeId" id="codeId" class="form-control" required 
	                                style="width: 300px;">
	                            <option value="">-- 사유를 선택하세요 --</option>
	                            <c:forEach var="code" items="${addReasonCodes}">
	                                <option value="${code.codeId}" data-code-str="${code.code}">${code.name}</option>
	                            </c:forEach>
	                    </select>
					</td>
				</tr>
				<tr>
					<th>상세 사유</th>
					<td colspan="3">
	                        <textarea name="addReason" id="addReason" class="form-control" rows="3" 
	                                  placeholder="사유가 '기타'인 경우 상세 사유를 입력하세요."></textarea>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	
	<div class="button-container" style="display: flex; justify-content: space-between; align-items: center; margin-top: 40px;">
	        <a href="${pageContext.request.contextPath}/admin/addamount" class="btn btn-secondary">
	            <i class="fa fa-list"></i> 목록으로
	        </a>
	        <button type="submit" id="applyAddAmountBtn" class="btn btn-primary">
	            <i class="fa fa-check"></i> 추가지급 신청
	        </button>
	</div>

<input type="hidden" id="applicationNumber" value="${appDTO.applicationNumber}" />
<input type="hidden" id="userId" value="${appDTO.userId}" />

	</form>
</c:when> <c:otherwise>
    <div class="info-table-container">
        <h2 class="section-title">급여 신청 기간 및 월별 내역(추가지급)</h2>
        <table class="info-table table-4col">
            <tbody>
                <tr>
                    <th>육아휴직 <br>시작일</th>
                    <td>
                        <c:if test="${empty appDTO.startDate}">
                            <span class="highlight-warning">미입력</span>
                        </c:if>
                        <c:if test="${not empty appDTO.startDate}">
                            ${appDTO.startDate}
                        </c:if>
                    </td>
                    <th>총 휴직 기간</th>
                    <td id="total-leave-period">
                        (${empty appDTO.startDate ? '미입력' : appDTO.startDate}
                        ~ ${empty appDTO.endDate ? '미입력' : appDTO.endDate})
                    </td>
                </tr>
                <tr>
                    <th>월별 분할 <br>신청 여부</th>
                    <td colspan="3">아니오 (일괄 신청)</td>
                </tr>
            </tbody>
        </table>

        <h3 class="section-title" style="font-size: 16px; margin-top: 25px;">월별 지급 내역</h3>
        <table class="info-table table-5col">
            <thead>
                <tr>
                    <th>시작일</th>
                    <th>종료일</th>
                    <th>사업장 지급액</th>
                    <th>정부 지급액</th>
                    <th style="background-color: var(--primary-light-color);">추가지급액</th>
                </tr>
            </thead>
            <tbody>
                <c:set var="totalAddAmount" value="0" />
                <c:set var="totalAmount" value="0" />
                <c:forEach var="item" items="${dto.list}" varStatus="status">
                    <tr>
                        <td class="text-center"><fmt:formatDate value="${item.startMonthDate}" pattern="yyyy.MM.dd" /></td>
                        <td class="text-center">
                            <c:choose>
                                <c:when test="${not empty item.earlyReturnDate}">
                                    <fmt:formatDate value="${item.earlyReturnDate}" pattern="yyyy.MM.dd" />
                                </c:when>
                                <c:otherwise>
                                    <fmt:formatDate value="${item.endMonthDate}" pattern="yyyy.MM.dd" />
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-right"><fmt:formatNumber value="${item.companyPayment}" type="number" pattern="#,###" />원</td>
                        <td class="text-right">
                            <c:choose>
                                <c:when test="${not empty item.govPaymentUpdate}">
                                    <fmt:formatNumber value="${item.govPaymentUpdate}" type="number" pattern="#,###" />원
                                </c:when>
                                <c:otherwise>
                                    <fmt:formatNumber value="${item.govPayment}" type="number" pattern="#,###" />원
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <c:set var="currentTotal" value="${(not empty item.govPaymentUpdate ? item.govPaymentUpdate : item.govPayment)}" />
                        <%-- <td class="text-right"><fmt:formatNumber value="${currentTotal}" type="number" pattern="#,###" />원</td> --%>
                        <c:set var="totalAmount" value="${totalAmount + currentTotal}" />
                        <td style="text-align: right; padding-right: 15px; font-weight: 500;">
                            <c:set var="savedDTO" value="${addAmountMap[item.termId]}" />
                            <c:if test="${not empty savedDTO and savedDTO.amount > 0}">
                                <fmt:formatNumber value="${savedDTO.amount}" type="number" pattern="#,###" />원
                                <c:set var="totalAddAmount" value="${totalAddAmount + savedDTO.amount}" />
                            </c:if>
                            <c:if test="${empty savedDTO or savedDTO.amount == 0}">
                                -
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                <tr style="background-color: var(--light-gray-color);">
                    <td colspan="3" style="text-align: center; font-weight: 700; color: var(--dark-gray-color);">
                        합계 신청금액
                    </td>
                    <td style="text-align: right; font-weight: 700; color: var(--primary-color);">
                        <fmt:formatNumber value="${totalAmount}" type="number" pattern="#,###" />원
                    </td>
                    <td style="text-align: right; padding-right: 15px; font-weight: 700; color: var(--primary-color);">
                        <fmt:formatNumber value="${totalAddAmount}" type="number" pattern="#,###" />원
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

    <div class="info-table-container">
        <h2 class="section-title">추가지급 급여 입금 계좌정보</h2>
        <table class="info-table table-4col">
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

    <div class="info-table-container">
        <h2 class="section-title">추가지급 사유</h2>
        <table class="info-table table-4col">
            <tbody>
                <tr>
                    <th>사유</th>
                    <td>
                        <div class="readonly-data" style="background-color: var(--light-gray-color); border-radius: 8px;">
                            <c:out value="${addAmountData[0].addReasonName}" default="-" />
                        </div>
                    </td>
                </tr>
                <tr>
                    <th>상세 사유</th>
                    <td colspan="3">
                        <div class="readonly-data" style="background-color: var(--light-gray-color); border-radius: 8px;">
                            <c:out value="${addAmountData[0].addReason}" default="-" />
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
        <div class="button-container" style="display: flex; justify-content: space-between; align-items: center; margin-top: 40px;">
	        <a href="${pageContext.request.contextPath}/admin/addamount" class="btn btn-secondary">
	            <i class="fa fa-list"></i> 목록으로
	        </a>
		</div>
    </div>
</c:otherwise>

</c:choose>
<%-- (hidden inputs - applicationNumber는 폼 안으로 이동, userId는 스크립트용으로 남김) --%>
<input type="hidden" id="userId" value="${appDTO.userId}" />
</main>

<footer class="footer">
	<p>&copy; 2025 육아휴직 서비스. All Rights Reserved.</p>
</footer>

<script>
document.addEventListener("DOMContentLoaded", function () {
	const ctx = '${pageContext.request.contextPath}';
	const applicationNumber = document.getElementById("applicationNumber")?.value;
	
	// userId 값 읽기
	const userId = document.getElementById("userId")?.value;

	function sendPushAndFinalize(userId, data, defaultMessage) {
		const successMessage = data.message || defaultMessage;
		
		if (userId) {
			// JQuery AJAX (GET 요청)
			$.ajax({
				url: ctx + '/push/' + userId, // API 엔드포인트
				type: 'GET',
				success: function(pushResponse) {
					console.log('Push notification sent:', pushResponse);
					alert(successMessage);
				},
				error: function(xhr, status, error) {
					console.error('Push notification failed:', error);
					alert(successMessage);
				},
				complete: function() {
					// 푸시 성공/실패 여부와 관계없이 리디렉션 실행
					if (data.redirectUrl) {
						location.href = data.redirectUrl.startsWith('/') ? (ctx + data.redirectUrl) : data.redirectUrl;
					}
				}
			});
		} else {
			// userId가 없는 경우 (푸시 X, 기존 로직만 실행)
			console.warn('userId is not available. Skipping push notification.');
			alert(successMessage);
			if (data.redirectUrl) {
				location.href = data.redirectUrl.startsWith('/') ? (ctx + data.redirectUrl) : data.redirectUrl;
			}
		}
	}

	const form = document.getElementById("addAmountForm");

    if (form) {
        form.addEventListener("submit", function(e) {
            
            const reasonSelect = document.getElementById("codeId");
            if (!reasonSelect.value) {
                alert("추가지급 사유를 선택하세요.");
                reasonSelect.focus();
                e.preventDefault(); 
                return;
            }

            const selectedOption = reasonSelect.options[reasonSelect.selectedIndex];
            const reasonCodeStr = selectedOption.getAttribute("data-code-str"); 
            const reasonText = document.getElementById("addReason").value.trim();
            
            if (reasonCodeStr === 'AR_30' && reasonText === '') {
                alert("'기타' 사유를 선택한 경우, 상세 사유를 반드시 입력해야 합니다.");
                document.getElementById("addReason").focus();
                e.preventDefault();
                return;
            }

            const amountInputs = document.querySelectorAll("input[name='amount']");
            let totalAmountEntered = 0;
            let hasValidInput = false;
            
            amountInputs.forEach(input => {
                const value = parseInt(input.value, 10);
                if (!isNaN(value) && value > 0) {
                    totalAmountEntered += value;
                    hasValidInput = true;
                }
            });

            if (!hasValidInput) {
                alert("추가지급액을 1개 이상 입력하세요 (0원 이상).");
                amountInputs[0].focus();
                e.preventDefault();
                return;
            }

            if (!confirm("총 " + totalAmountEntered.toLocaleString() + "원의 추가지급을 신청하시겠습니까?")) {
                e.preventDefault();
            }
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