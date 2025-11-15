<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>육아휴직 급여 신청서</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<%-- PDF 생성을 위한 라이브러리 (html2canvas, jspdf) --%>
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

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
    --danger-color: #dc3545;
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

.main-container{
	flex-grow:1;width:100%;max-width:1060px;margin:40px auto;padding:40px;
	background-color:var(--white-color);border-radius:12px;box-shadow:var(--shadow-md);
}

h1{text-align:center;margin-bottom:30px;font-size:28px}
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


/* 월별 내역 테이블(데이터 그리드) 스크롤 컨테이너 */
.data-grid-container {
	overflow-x: auto;
	-webkit-overflow-scrolling: touch;
	border: 1px solid var(--border-color);
	border-radius: 8px;
	margin-top: -15px;
	margin-bottom: 25px;
}
.data-grid-container .info-table {
	border-top: none;
	margin-bottom: 0;
}
.data-grid-container .info-table th,
.data-grid-container .info-table td {
	white-space: nowrap;
	text-align: center;
}


/* 버튼 */
.btn{
	display:inline-block;padding:10px 20px;font-size:15px;font-weight:500;
	border-radius:8px;border:1px solid var(--border-color);cursor:pointer;
	transition:all .2s ease-in-out;text-align:center;
}
.btn:disabled, .btn.disabled {
    cursor: not-allowed;
    opacity: 0.65;
}

.btn-primary{background-color:var(--primary-color);color:#fff;border-color:var(--primary-color)}
.btn-primary:hover{background-color:#364ab1;box-shadow:var(--shadow-md);transform:translateY(-2px)}
.btn-secondary{background-color:var(--white-color);color:var(--gray-color);border-color:var(--border-color)}
.btn-secondary:hover{background-color:var(--light-gray-color);color:var(--dark-gray-color);border-color:#ccc}
.btn-danger { background-color: var(--danger-color); color: #fff; border-color: var(--danger-color); }
.btn-danger:hover { background-color: #c82333; border-color: #bd2130; transform:translateY(-2px); box-shadow:var(--shadow-md); }


/* 하단 버튼 컨테이너 스타일 */
.button-container{
	display: flex;
    justify-content: center;
    align-items: center;
    gap: 15px;
    margin-top:50px;
}
.button-container.spread-out {
    justify-content: space-between;
    gap: 0; 
}
.button-group-left {
    display: flex;
    align-items: center;
    gap: 15px;
}

.bottom-btn{padding:12px 30px;font-size:1.1em}

.data-title{font-weight:500}
.detail-btn{
	border:1px solid var(--primary-color);color:var(--primary-color);
	background-color:var(--white-color);padding:3px 8px;font-size:14px;
	margin-left:10px;border-radius:4px;cursor:pointer;transition:background-color .1s;
}
.detail-btn:hover{background-color:var(--primary-light-color)}
.success-text{color:var(--success-color);font-weight:500}

.highlight-warning {
    background-color: #fff3cd; 
    color: #856404;
    font-weight: 700;
    padding: 2px 6px;
    border-radius: 4px;
}
.footer {
       text-align: center;
       padding: 20px 0;
       font-size: 14px;
       color: var(--gray-color);
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


네, '최종승인'과 '반려' 상태의 디자인을 더 눈에 띄고 명확하게 바꿔보겠습니다.

기존의 텍스트와 노란색 경고창 대신, 성공(초록색)과 위험(붉은색)을 나타내는 명확한 '상태 알림 박스' 스타일을 추가하는 것이 좋겠습니다.

아래 2단계를 적용해 주세요.

1단계: CSS 스타일 추가
먼저, <style> 태그 최하단 (미디어 쿼리 @media 시작 전)에 아래의 새로운 CSS 코드를 복사하여 붙여넣으세요.

CSS

/* ... 기존 file-download-link::before ... */
.file-download-link::before {
    content: '📎';
    font-size: 1.1em;
    color: var(--gray-color);
}

/* ================================== */
/* ✅ [추가] 승인/반려 상태 박스 스타일 */
/* ================================== */
.status-notification {
	background-color: var(--white-color); 
	border: 1px solid var(--border-color);
	color: var(--dark-gray-color);
	padding: 25px;
	margin-bottom: 30px;
	border-radius: 8px;
	overflow: hidden; 
}

.status-notification .status-title-area {
	display: flex;
	align-items: center;
	gap: 15px;
	flex-wrap: wrap; 
}

/* 2. 상태 뱃지 (은은한 스타일) */
.status-badge {
	display: inline-block;
	padding: 6px 14px;
	font-size: 16px;
	font-weight: 700;
	border-radius: 20px;
	flex-shrink: 0;
	
	color: #ffffff; /* (기본값, 덮어씌워짐) */
	background-color: #888; /* (기본값, 덮어씌워짐) */
}

/* 3. 메인 텍스트 (중립색) */
.status-main-text {
	font-size: 20px;
	font-weight: 700;
	color: var(--dark-gray-color); 
}

/* 4. 상세 내용 (심플한 구분선) */
.status-detail-content {
	font-size: 15px;
	line-height: 1.6;
	white-space: pre-line;
	word-wrap: break-word;
	
	margin-top: 20px; 
	padding-top: 20px;
	
	background-color: transparent;
	padding: 0;
	padding-top: 20px;
	border: none;
	border-top: 1px solid var(--border-color); 
	
	color: var(--dark-gray-color); 
}
.status-detail-content strong {
	font-weight: 700;
	display: block;
	margin-bottom: 8px;
	color: inherit;
}


/* 5. '최종승인' 스타일 (★ 푸른색 계열로 변경) */
.status-notification.success {
	/* 흰색 배경 유지 */
}
.status-notification.success .status-badge {
	/* [변경] 연한 파랑 배경 + 진한 파랑 텍스트 */
	background-color: var(--primary-light-color); /* #f0f2ff */
	color: var(--primary-color) !important; /* #3f58d4 */
}


/* 6. '반려' 스타일 (★ 기존 붉은색 계열 유지) */
.status-notification.danger {
	/* 흰색 배경 유지 */
}
.status-notification.danger .status-badge {
	/* [유지] 연한 빨강 배경 + 진한 빨강 텍스트 */
	background-color: #fbebee;
	color: #721c24 !important;
}
.status-notification.danger .status-detail-content {
	border-top-color: #f5c6cb; /* 구분선만 연한 붉은색 (유지) */
}
.status-notification.danger .status-detail-content strong {
	color: #721c24; 
}
/* ---------------------------------- */
/* 📱 반응형 스타일 */
/* ---------------------------------- */

@media (max-width: 992px) {
	.main-container {
		max-width: 95%;
		margin: 30px auto;
		padding: 30px;
	}
	h1 { font-size: 26px; }
	h2 { font-size: 19px; }
}

@media (max-width: 768px) {
	.main-container {
		max-width: 100%;
		margin: 0;
		padding: 25px;
		border-radius: 0;
		box-shadow: none;
	}

	h1 { font-size: 24px; margin-bottom: 25px; }
	
	.info-table-container .info-table {
		border-top: none;
	}

	.info-table-container .info-table tbody tr {
		display: flex;
		flex-wrap: wrap; 
		border: none;
	}

	.info-table-container .info-table tbody th,
	.info-table-container .info-table tbody td {
		display: block;
		width: 100% !important;
		text-align: left !important;
		border: none;
		padding-left: 0;
		padding-right: 0;
		vertical-align: top;
	}

	.info-table-container .info-table tbody th {
		background-color: transparent;
		font-weight: 500;
		padding-top: 15px;
		padding-bottom: 5px;
		width: 100% !important;
		color: var(--gray-color);
	}

	.info-table-container .info-table tbody td {
		padding-top: 0;
		padding-bottom: 15px;
		border-bottom: 1px solid var(--border-color);
		color: var(--dark-gray-color);
		font-weight: 500;
	}
	
	.info-table-container .info-table tbody tr:last-child td:last-child {
		border-bottom: none;
	}
	
	.info-table-container {
		 margin-bottom: 30px;
	}

	.data-grid-container .info-table tbody tr {
		display: table-row;
	}
	.data-grid-container .info-table tbody th,
	.data-grid-container .info-table tbody td {
		display: table-cell;
		width: auto !important;
		text-align: center !important;
		border: 1px solid var(--border-color);
		padding: 12px 15px;
	}
	
	
	.button-container {
		flex-direction: column;
		align-items: stretch;
		gap: 12px;
		margin-top: 30px;
	}
	.button-container form {
		margin-left: 0 !important;
		display: block;
		width: 100%;
	}
	.button-group-left {
		display: flex;
		flex-direction: column;
		align-items: stretch;
		width: 100%;
		gap: 12px;
	}
	.button-container .btn,
	.button-container form .btn {
		width: 100%;
		margin: 0 !important;
	}
}

@media (max-width: 480px) {
	.main-container {
		 padding: 20px;
	}
	.info-table th, .info-table td {
		 font-size: 14px;
	}
	.bottom-btn {
		padding: 12px 20px;
		font-size: 1em;
	}
}
</style>
</head>
<body>
<c:set var="role" value="${user.role}" />
<c:choose><c:when test="${role == 'ROLE_CORP'}">
    <jsp:include page="../company/compheader.jsp"/>
    <style>
      :root{
        --primary-color:#24A960;
        --primary-light-color:rgba(36,169,96,.08);
      }
      .btn-primary:hover { background-color: #3ed482; }
	  h2 { color: var(--primary-color); border-left: 4px solid var(--primary-color); }
	  .section-title { border-left: 4px solid var(--primary-color); }
	  .detail-btn { border-color: var(--primary-color); color: var(--primary-color); }
	  .detail-btn:hover { background-color: var(--primary-light-color); }
    </style>
  </c:when><c:otherwise>
<jsp:include page="header.jsp"/>
  </c:otherwise></c:choose>

	<main class="main-container">
	
	<div id="pdf-content-part-1">
	<h1>육아휴직 급여 신청서</h1>	
	<c:if test="${empty dto}">
		<p style="text-align:center; font-size:18px; color:var(--gray-color);">신청서 정보를 불러올 수 없습니다.</p>
	</c:if>
	
	<c:if test="${not empty dto}">
		
			<div class="info-table-container">
				<h2 class="section-title">접수정보</h2>
				<table class="info-table">
				    <colgroup>
					    <col style="width:15%"><col style="width:35%">
					    <col style="width:15%"><col style="width:35%">
					  </colgroup>
					<tbody>
						<tr>
							<th>접수번호</th>
							<td><c:out value="${dto.applicationNumber}" /></td>
							<th>신청인</th>
							<td><c:out value="${dto.name}" /></td>
						</tr>
					</tbody>
				</table>
			</div>
		
			<div class="info-table-container">
				<h2 class="section-title">신청인 정보 (육아휴직자)</h2>
				<table class="info-table">
					<colgroup>
					    <col style="width:15%">
					  </colgroup>
					<tbody>
						<tr>
							<th>이름</th>
							<td colspan="3"><c:out value="${dto.name}" /></td>
						</tr>
						<tr>
							<th>주민등록번호</th>
							<td colspan="3"><c:if test="${not empty dto.registrationNumber}"><c:set var="rrnCleaned" value="${fn:replace(fn:replace(fn:trim(dto.registrationNumber), '-', ''), ' ', '')}" />${fn:substring(rrnCleaned, 0, 6)}-${fn:substring(rrnCleaned, 6, 13)}</c:if></td>
						</tr>
						<tr>
							<th>휴대전화번호</th>
							<td colspan="3"><c:out value="${dto.phoneNumber}" /></td>
						</tr>
						<tr>
							<th>주소</th>
							<td colspan="3">(${dto.zipNumber}) ${dto.addressBase} ${dto.addressDetail}</td>
						</tr>
					</tbody>
				</table>
			</div>
		
			<div class="info-table-container">
				<h2 class="section-title">사업장 정보 (회사)</h2>
				<table class="info-table">
						<colgroup>
					    <col style="width:15%">
					  </colgroup>
					<tbody>
						<tr>
							<th>사업장 이름</th>
							<td><c:out value="${dto.companyName}" /></td>
						</tr>
						<tr>
							<th>사업자 등록번호</th>
							<td><c:out value="${dto.buisinessRegiNumber}" /></td>
						</tr>
						<tr>
							<th>사업장 주소</th>
							<td>(${dto.companyZipNumber}) ${dto.companyAddressBase} ${dto.companyAddressDetail}</td>
						</tr>
					</tbody>
				</table>
			</div>
		
			<div>
				<h2 class="section-title">급여 신청 기간 및 월별 내역</h2>
				<table class="info-table">
						<colgroup>
					    <col style="width:15%">
					  </colgroup>
					<tbody>
						<tr>
							<th>급여 신청 기간</th>
							<td id="total-leave-period">
								<fmt:formatDate value="${dto.startDate}" pattern="yyyy-MM-dd" /> ~ <fmt:formatDate value="${dto.list[fn:length(dto.list) - 1].endMonthDate}" pattern="yyyy.MM.dd" /> (${totalDate}일)
							</td>
						</tr>
					</tbody>
				</table>
		
				<h3 class="section-title" style="font-size: 16px; margin-top: 25px;">월별 지급 내역</h3>
				<br>
				<div class="data-grid-container">
					<table class="info-table">

						<thead>
							<tr>
								<th>시작일</th>
								<th>종료일</th>
								<th>사업장 지급액</th>
								<th>정부 지급액</th>
								<th>총 지급액</th>
							</tr>
						</thead>
						<tbody>
							<c:set var="totalAmount" value="${0}" />
							
							<c:forEach var="item" items="${dto.list}" varStatus="status">
								<tr>
									<td>
										<fmt:formatDate value="${item.startMonthDate}" pattern="yyyy.MM.dd"/>
									</td>
							
									<td>
										<c:choose>
											<c:when test="${not empty item.earlyReturnDate}">
												<fmt:formatDate value="${item.earlyReturnDate}" pattern="yyyy.MM.dd"/>
											</c:when>
											<c:otherwise>
												<fmt:formatDate value="${item.endMonthDate}" pattern="yyyy.MM.dd"/>
											</c:otherwise>
										</c:choose>
									</td>
							
									<td>
										<fmt:formatNumber value="${item.companyPayment}" type="number" pattern="#,###" />원
									</td>
							
									<td>
										<c:choose>
											<c:when test="${not empty item.govPaymentUpdate}">
												<fmt:formatNumber value="${item.govPaymentUpdate}" type="number" pattern="#,###" />원
											</c:when>
											<c:otherwise>
												<fmt:formatNumber value="${item.govPayment}" type="number" pattern="#,###" />원
											</c:otherwise>
										</c:choose>
									</td>
							
									<td>
										<fmt:formatNumber
											value="${item.companyPayment + (not empty item.govPaymentUpdate ? item.govPaymentUpdate : item.govPayment)}"
											type="number"
											pattern="#,###" />원
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
										(${totalDate}일)
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
			</div>
			
		<%-- ✅ 1페이지 캡처 영역 끝 --%>
		</div>


		<%-- ✅ 2페이지 캡처 영역 시작 --%>
		<div id="pdf-content-part-2">
	
			<div class="info-table-container">
				<h2 class="section-title">자녀 정보 (육아 대상)</h2>
				<table class="info-table">
						<colgroup>
					    <col style="width:15%"><col style="width:35%">
					    <col style="width:15%"><col style="width:35%">
					  </colgroup>
					<tbody>
							<tr>
								<th>자녀 이름</th>
								<td>
								    <c:choose>
								        <c:when test="${empty dto.childName}">
								            출산 예정
								        </c:when>
								        <c:otherwise>
								            <c:out value="${dto.childName}" />
								        </c:otherwise>
								    </c:choose>
								</td>
								<th>생년월일</th>
								<td><fmt:formatDate value="${dto.childBirthDate}" pattern="yyyy-MM-dd" /></td>
							</tr>
							<tr>
								<th>주민등록번호</th>
								<td colspan="3">
								    <c:choose>
								        <c:when test="${empty dto.childResiRegiNumber}">
								            출산 예정
								        </c:when>
								        <c:otherwise>
								            <c:set var="rrnCleaned" 
								                   value="${fn:replace(fn:replace(fn:trim(dto.childResiRegiNumber), '-', ''), ' ', '')}" />
								            ${fn:substring(rrnCleaned, 0, 6)}-${fn:substring(rrnCleaned, 6, 13)}
								        </c:otherwise>
								    </c:choose>
								</td>
							</tr>
					</tbody>
				</table>
			</div>
		
			<div class="info-table-container">
				<h2 class="section-title">급여 입금 계좌정보</h2>
				<table class="info-table">
						<colgroup>
					    <col style="width:15%"><col style="width:35%">
					    <col style="width:15%"><col style="width:35%">
					  </colgroup>
					<tbody>
						<tr>
							<th>은행</th>
							<td><c:out value="${dto.bankName}" /></td>
							<th>계좌번호</th>
							<td><c:out value="${dto.accountNumber}" /></td>
						</tr>
						<tr>
							<th>예금주 이름</th>
							<td colspan="3"><c:out value="${dto.name}" /></td>
						</tr>
					</tbody>
				</table>
			</div>
		
			<div class="info-table-container">
                <h2 class="section-title">행정정보 공동이용 동의</h2>
                <table class="info-table">
                	<colgroup>
					    <col style="width:15%"><col style="width:35%">
					    <col style="width:15%"><col style="width:35%">
					  </colgroup>
                    <tbody>
                    <tr>
                    <th>동의 여부</th>
                    <td colspan="3">
                    <c:choose>
                    	<c:when test="${dto.govInfoAgree == 'Y'}">예</c:when>
                    	<c:otherwise><span class="highlight-warning">아니요</span></c:otherwise>
                    </c:choose>
                    </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        
            <div class="info-table-container">
                <h2 class="section-title">첨부파일</h2>
                <table class="info-table">
                	 <colgroup>
					    <col style="width:15%">
					  </colgroup>
                    <tbody>
                        <c:if test="${empty dto.files}">
                            <tr>
                                <th style="width: 150px;">파일 목록</th>
                                <td>첨부된 파일이 없습니다.</td>
                            </tr>
                        </c:if>
                        
                        <c:if test="${not empty dto.files}">
                            <c:forEach var="file" items="${dto.files}" varStatus="status">
                                <tr>
                                    <%-- 파일이 여러 개일 때 첫 번째 행에만 '파일 목록' th를 생성 (rowspan) --%>
                                    <c:if test="${status.first}">
                                        <th rowspan="${fn:length(dto.files)}" style="width: 150px;">파일 목록</th>
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
            <%-- ✅ 2페이지 캡처 영역 끝 --%>
        </div>
		
	
		<%-- 버튼 컨테이너 (캡처 영역 밖) --%>
		<%-- ✅ [오류 수정 2] <c:when>과 <c:otherwise> 사이의 빈 줄(공백) 제거 --%>
		<c:choose>
			<c:when test="${dto.statusCode == 'ST_10'}">
				<div class="button-container" style="display: flex; align-items: center; width: 100%;">
					<div style="display: flex; gap: 8px;">
						<a href="${pageContext.request.contextPath}/user/main" class="btn bottom-btn btn-secondary">목록으로 돌아가기</a>
						<form action="${pageContext.request.contextPath}/user/application/update/${dto.applicationNumber}" 
							  method="post" 
							  style="display: contents;">
							<sec:csrfInput/>
							<c:forEach var="item" items="${dto.list}">
								<input type="hidden" name="termId" value="${item.termId}" />
							</c:forEach>
							<button type="submit" class="btn bottom-btn btn-primary" style="margin: 0;">신청 내용 수정</button>
						</form>
			
						<form id="submitForm" 
							  action="${pageContext.request.contextPath}/user/submit/${dto.applicationNumber}" 
							  method="post" 
							  style="display: contents;">
							<sec:csrfInput/>
							<button type="button" 
									onclick="confirmAction('submitForm', '최종 제출 후에는 수정할 수 없습니다. 제출하시겠습니까?')" 
									class="btn bottom-btn btn-primary"
									style="margin: 0;">최종 제출</button>
						</form>
					</div>
			
					<form id="deleteForm" 
						  action="${pageContext.request.contextPath}/user/delete/${dto.applicationNumber}" 
						  method="post" 
						  style="margin-left: auto;">
						<input type="hidden" name="fileId" value="${dto.files[0].fileId}">
						<sec:csrfInput/>
						<c:forEach var="item" items="${dto.list}">
							<input type="hidden" name="termId" value="${item.termId}" />
						</c:forEach>
						<button type="button" 
								onclick="confirmAction('deleteForm', '정말로 삭제하시겠습니까?')" 
								class="btn bottom-btn btn-danger"
								style="margin: 0; background-color: #dc3545; border-color: #dc3545;"
								onmouseover="this.style.backgroundColor='#dc3545'; this.style.borderColor='#dc3545';"
								onmouseout="this.style.backgroundColor='#dc3545'; this.style.borderColor='#dc3545';">
							삭제
						</button>
					</form>
				</div>
			</c:when><c:when test="${dto.statusCode == 'ST_20' or dto.statusCode == 'ST_30' or dto.statusCode == 'ST_40'}">
				<div class="button-container"> 
					<div class="button-group-left">
						<a href="${pageContext.request.contextPath}/user/main" class="btn bottom-btn btn-secondary">목록으로 돌아가기</a>
						<button type="button" id="btn-pdf-download" class="btn bottom-btn btn-primary">PDF 다운로드</button>
					</div>
					
					<form id="cancelForm" action="${pageContext.request.contextPath}/user/cancel/${dto.applicationNumber}" method="post" style="margin-left: auto;">
						<sec:csrfInput/>
						<button type="button" onclick="confirmAction('cancelForm', '신청을 취소하시겠습니까?')" class="btn bottom-btn btn-danger" 
								style="background-color: #c82333; border-color: #bd2130; transform: translateY(-2px); box-shadow: var(--shadow-md);">신청 취소</button>
					</form>
				</div>
			</c:when>
			<c:when test="${dto.statusCode == 'ST_50'}">
				<%-- [DESIGN UPDATE] 뱃지 스타일 --%>
				<div class="status-notification success">
					<div class="status-title-area">
						<span class="status-badge">최종승인</span>
						<span class="status-main-text">육아휴직 급여 신청이 승인되었습니다.</span>
					</div>
				</div>
				
				<div class="button-container" style="display: flex; justify-content: center;">
					<button type="button" id="btn-pdf-download" class="btn bottom-btn btn-primary">PDF 다운로드</button>&nbsp;
					<a href="${pageContext.request.contextPath}/user/main" class="btn bottom-btn btn-secondary">목록으로 돌아가기</a>
				</div>
			</c:when>
									
			<%-- ST_60: 반려 --%>
			<c:when test="${dto.statusCode == 'ST_60'}">
				
				<%-- [DESIGN UPDATE] 뱃지 스타일 --%>
				<div class="status-notification danger">
					<div class="status-title-area">
						<span class="status-badge">반려</span>
						<%-- 반려 사유 코드를 뱃지 옆 메인 텍스트로 사용 --%>
						<span class="status-main-text">
							<c:choose>
								<c:when test="${dto.rejectionReasonCode == 'RJ_10'}">계좌정보 불일치</c:when>
								<c:when test="${dto.rejectionReasonCode == 'RJ_20'}">관련서류 미제출</c:when>
								<c:when test="${dto.rejectionReasonCode == 'RJ_30'}">신청시기 미도래</c:when>
								<c:when test="${dto.rejectionReasonCode == 'RJ_40'}">근속기간 미충족</c:when>
								<c:when test="${dto.rejectionReasonCode == 'RJ_50'}">자녀 연령 기준 초과</c:when>
								<c:when test="${dto.rejectionReasonCode == 'RJ_60'}">휴직 가능 기간 초과</c:when>
								<c:when test="${dto.rejectionReasonCode == 'RJ_70'}">제출서류 정보 불일치</c:when>
								<c:when test="${dto.rejectionReasonCode == 'RJ_80'}">신청서 작성 내용 미비</c:when>
								<c:otherwise>기타 사유</c:otherwise>
							</c:choose>
						</span>
					</div>
					
					<%-- 상세 반려 사유 (rejectComment) --%>
					<c:if test="${not empty dto.rejectComment}">
						<div class="status-detail-content">
							<strong>상세 내용:</strong>
							<c:out value="${dto.rejectComment}" />
						</div>
					</c:if>
				</div>
				
				<div class="button-container" style="display: flex; justify-content: center;">
					<a href="${pageContext.request.contextPath}/user/main" class="btn bottom-btn btn-secondary">목록으로 돌아가기</a>
				</div>
			</c:when>
			<c:otherwise>
				<div class="button-container" style="display: flex; justify-content: center;">
					<button type="button" id="btn-pdf-download" class="btn bottom-btn btn-primary">PDF 다운로드</button>
					<a href="${pageContext.request.contextPath}/user/main" class="btn bottom-btn btn-secondary">목록으로 돌아가기</a>
				</div>
			</c:otherwise>
		</c:choose>
	</c:if>
	
	</main>
	
	<footer class="footer">
		<p>&copy; 2025 육아휴직 서비스. All Rights Reserved.</p>
	</footer>
<script>
function confirmAction(formId, message) {
    if (confirm(message)) {
        document.getElementById(formId).submit();
    }
}

$(document).ready(function() {
	
	<c:if test="${not empty dto}">
	
		const applicationNumber = "${dto.applicationNumber}";
		const contextPath = "${pageContext.request.contextPath}";
		const csrfToken = $("input[name='_csrf']").val();

		$.ajax({
			type: "GET",
			url: contextPath + "/user/check/detail/" + applicationNumber,
			headers: {
				'X-CSRF-TOKEN': csrfToken 
			},
			dataType: "json",
			success: function(response) {
				if (!response.success) {
					alert(response.message);
					window.location.href = contextPath + response.redirectUrl;
				}
			},
			error: function(xhr, status, error) {
				console.error("AJAX Error:", status, error);
				alert("페이지 권한 확인 중 오류가 발생했습니다. 메인 페이지로 이동합니다.");
				window.location.href = contextPath + "/user/main";
			}
		});
		
		
		// --- PDF 다운로드 버튼 클릭 이벤트 핸들러 (2페이지 분할 로직) ---
		$('#btn-pdf-download').on('click', async function() {
			const btn = $(this);
			const originalText = btn.text();
			btn.prop('disabled', true).text('PDF 생성 중... (1/2)').addClass('disabled');

			const { jsPDF } = window.jspdf;
			const pdf = new jsPDF('p', 'mm', 'a4');
			const margin = 10;
			const pageInnerHeight = 297 - (margin * 2);

			const part1 = document.querySelector('#pdf-content-part-1');
			const part2 = document.querySelector('#pdf-content-part-2');
			const applicationNumber = "${dto.applicationNumber}";
			const filename = `육아휴직_급여신청서_${applicationNumber}.pdf`;

			/**
			 * ✨ [수정] PDF 변환 함수 (JPEG 압축 적용)
			 */
			function addCanvasToPdf(canvas, pdf) {
				// ✨ 1. PNG를 고압축 JPEG로 변경 (0.75 = 75% 품질)
				const imgData = canvas.toDataURL('image/jpeg', 0.75); 
				const imgWidth = canvas.width;
				const imgHeight = canvas.height;
				const pdfWidth = 210 - (margin * 2);
				const pdfImgHeight = (imgHeight * pdfWidth) / imgWidth;

				let heightLeft = pdfImgHeight;
				let page = 0;
				while (heightLeft > 1) {
					page++;
					if (page > 1) {
						pdf.addPage();
					}
					let position = pageInnerHeight * (page - 1);
					
					// ✨ 2. 이미지 포맷을 'JPEG'로 명시
					pdf.addImage(imgData, 'JPEG', margin, margin - position, pdfWidth, pdfImgHeight); 
					heightLeft = pdfImgHeight - (pageInnerHeight * page);
				}
			}

			const getCanvasOptions = (partToHideId) => ({
				scale: 2,
				useCORS: true,
				scrollX: 0,
				scrollY: -window.scrollY,
				windowWidth: document.documentElement.scrollWidth,
				windowHeight: document.documentElement.scrollHeight,
				onclone: (clonedDoc) => {
					if (partToHideId) {
						const partToHide = clonedDoc.querySelector(partToHideId);
						if (partToHide) partToHide.style.display = 'none';
					}
					
					const buttonContainer = clonedDoc.querySelector('.button-container');
					if (buttonContainer) {
						buttonContainer.style.display = 'none';
					}

					let el = clonedDoc.querySelector('.main-container');
					if (el) {
						while (el && el.tagName !== 'BODY' && el.tagName !== 'HTML') {
							el.style.overflow = 'visible';
							el.style.height = 'auto';
							el.style.maxHeight = 'none';
							el = el.parentElement;
						}
					}
					clonedDoc.body.style.overflow = 'visible';
					clonedDoc.body.style.height = 'auto';
					clonedDoc.body.style.maxHeight = 'none';
					clonedDoc.documentElement.style.overflow = 'visible';
					clonedDoc.documentElement.style.height = 'auto';
					clonedDoc.documentElement.style.maxHeight = 'none';
				}
			});

			try {
				const canvas1 = await html2canvas(part1, getCanvasOptions('#pdf-content-part-2'));
				addCanvasToPdf(canvas1, pdf);

				btn.text('PDF 생성 중... (2/2)');
				pdf.addPage();
				
				const canvas2 = await html2canvas(part2, getCanvasOptions('#pdf-content-part-1'));
				addCanvasToPdf(canvas2, pdf);

				pdf.save(filename);
				btn.prop('disabled', false).text(originalText).removeClass('disabled');

			} catch (error) {
				console.error("PDF 생성 오류:", error);
				alert("PDF 생성 중 오류가 발생했습니다.");
				btn.prop('disabled', false).text(originalText).removeClass('disabled');
			}
		});
		
	</c:if>
}); 
</script>
</body>
</html>