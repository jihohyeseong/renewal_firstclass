<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<%-- [추가] 반응형을 위한 뷰포트 메타 태그 --%>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>육아휴직 급여 신청서 상세 보기</title>
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

/* [삭제] 헤더/푸터 스타일 (global.css 또는 comp.css 등 공통 CSS에 이미 존재할 것이므로 제거) */
/* ... .header, .footer 관련 스타일 ... */

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
.info-table-container{margin-bottom:40px}
.info-table{
	width:100%;border-collapse:collapse;
	border-top:2px solid var(--dark-gray-color);
}
.info-table th,.info-table td{
	padding:12px 15px;border:1px solid var(--border-color);
	text-align:left;font-size:15px;
	vertical-align: middle;
}
.info-table th{
	background-color:var(--light-gray-color);
	font-weight:500;width:150px;color:var(--dark-gray-color);
}
.info-table td{background-color:var(--white-color);color:#333}

/* [추가] 월별 내역 테이블(데이터 그리드) 스크롤 컨테이너 */
.data-grid-container {
	overflow-x: auto;
	-webkit-overflow-scrolling: touch; /* 모바일 스크롤 부드럽게 */
	border: 1px solid var(--border-color);
	border-radius: 8px;
	margin-top: -15px; /* h3와 붙이기 */
	margin-bottom: 25px;
}
/* 스크롤 컨테이너 안의 테이블은 약간 다르게 스타일링 */
.data-grid-container .info-table {
	border-top: none;
	margin-bottom: 0;
}
.data-grid-container .info-table th,
.data-grid-container .info-table td {
	white-space: nowrap; /* 내용이 줄바꿈되지 않게 */
	text-align: center; /* [수정] 기존 스타일을 그대로 유지 */
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
    justify-content: center; /* 기본은 중앙 정렬 */
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


/* ---------------------------------- */
/* 📱 [추가] 반응형 스타일 */
/* ---------------------------------- */

/* 992px 이하 (태블릿) */
@media (max-width: 992px) {
	/* 헤더, 푸터는 공통 CSS에서 관리한다고 가정 */

	.main-container {
		max-width: 95%;
		margin: 30px auto;
		padding: 30px;
	}
	h1 { font-size: 26px; }
	h2 { font-size: 19px; }
}

/* 768px 이하 (모바일) */
@media (max-width: 768px) {
	.main-container {
		max-width: 100%;
		margin: 0;
		padding: 25px;
		border-radius: 0;
		box-shadow: none;
	}

	h1 { font-size: 24px; margin-bottom: 25px; }
	
	/* * [수정] 키-값 테이블을 스택 레이아웃으로 변경 
	 * (데이터 그리드 테이블은 .data-grid-container로 감쌌으므로 영향받지 않음)
	 */
	.info-table-container .info-table {
		border-top: none; /* 상단 굵은 선 제거 */
	}

	.info-table-container .info-table tbody tr {
		display: flex;
		flex-wrap: wrap; 
		border: none;
	}

	.info-table-container .info-table tbody th,
	.info-table-container .info-table tbody td {
		display: block;
		width: 100% !important; /* CSS 우선순위 및 인라인 스타일 무시 */
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
		width: 100% !important; /* th 너비 강제 해제 */
		color: var(--gray-color);
	}

	.info-table-container .info-table tbody td {
		padding-top: 0;
		padding-bottom: 15px;
		border-bottom: 1px solid var(--border-color);
		color: var(--dark-gray-color);
		font-weight: 500;
	}
	
	/* 테이블의 마지막 행, 마지막 셀의 하단 보더 제거 */
	.info-table-container .info-table tbody tr:last-child td:last-child {
		border-bottom: none;
	}
	
	/* 섹션간 간격 조정 */
	.info-table-container {
		 margin-bottom: 30px;
	}

	/* [중요] 데이터 그리드 테이블은 스택 레이아웃을 적용하지 않음 (초기화) */
	.data-grid-container .info-table tbody tr {
		display: table-row; /* flex 대신 table-row로 복원 */
	}
	.data-grid-container .info-table tbody th,
	.data-grid-container .info-table tbody td {
		display: table-cell; /* block 대신 table-cell로 복원 */
		width: auto !important; /* 100% 너비 해제 */
		text-align: center !important; /* [수정] 원본 스타일 유지 */
		border: 1px solid var(--border-color); /* [수정] 보더 복원 */
		padding: 12px 15px; /* [수정] 패딩 복원 */
	}
	
	
	/* [수정] 버튼 컨테이너 세로 쌓기 */
	.button-container {
		flex-direction: column;
		align-items: stretch;
		gap: 12px;
		margin-top: 30px;
	}
	.button-container form {
		margin-left: 0 !important; /* '삭제', '취소' 버튼의 margin-left 제거 */
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
		margin: 0 !important; /* 인라인 margin 제거 */
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
<%-- 헤더 include --%>
<c:set var="role" value="${user.role}" />
<c:choose>
  <c:when test="${role == 'ROLE_CORP'}">
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
  </c:when>
  <c:otherwise>
    <jsp:include page="header.jsp"/>
  </c:otherwise>
</c:choose>

	<main class="main-container">
	<h1>육아휴직 급여 신청서 상세 보기</h1>
	
	<c:if test="${empty dto}">
		<p style="text-align:center; font-size:18px; color:var(--gray-color);">신청서 정보를 불러올 수 없습니다.</p>
	</c:if>
	
	<c:if test="${not empty dto}">
		<div class="info-table-container">
			<h2 class="section-title">접수정보</h2>
			<table class="info-table">
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
	
		<%-- [수정] info-table-container 클래스 제거 및 data-grid-container 추가 --%>
		<div>
			<h2 class="section-title">급여 신청 기간 및 월별 내역</h2>
			<table class="info-table">
				<tbody>
					<tr>
						<th>육아휴직 기간</th>
						<td id="total-leave-period">
							<fmt:formatDate value="${dto.startDate}" pattern="yyyy-MM-dd" /> ~ <fmt:formatDate value="${dto.endDate}" pattern="yyyy-MM-dd" />
						</td>
					</tr>
				</tbody>
			</table>
	
			<h3 class="section-title" style="font-size: 16px; margin-top: 25px;">월별 지급 내역</h3>
			
			<%-- [추가] 데이터 그리드 테이블을 감싸는 스크롤 컨테이너 --%>
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
										value="${item.companyPayment + 
												(not empty item.govPaymentUpdate ? item.govPaymentUpdate : item.govPayment)}" 
										type="number" 
										pattern="#,###" />원
								</td>
							</tr>
						
							<c:set var="totalAmount"
								value="${totalAmount + item.companyPayment + 
										(not empty item.govPaymentUpdate ? item.govPaymentUpdate : item.govPayment)}" />
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
		</div>
	
		<div class="info-table-container">
			<h2 class="section-title">자녀 정보 (육아 대상)</h2>
			<table class="info-table">
				<tbody>
						<tr>
							<th>자녀 이름</th>
							<td><c:out value="${dto.childName}" /></td>
							<th>생년월일</th>
							<td><fmt:formatDate value="${dto.childBirthDate}" pattern="yyyy-MM-dd" /></td>
						</tr>
						<tr>
							<th>주민등록번호</th>
							<td colspan="3"><c:if test="${not empty dto.childResiRegiNumber}"><c:set var="rrnCleaned" value="${fn:replace(fn:replace(fn:trim(dto.childResiRegiNumber), '-', ''), ' ', '')}" />${fn:substring(rrnCleaned, 0, 6)}-${fn:substring(rrnCleaned, 6, 13)}</c:if></td>
						</tr>
				</tbody>
			</table>
		</div>
	
		<div class="info-table-container">
			<h2 class="section-title">급여 입금 계좌정보</h2>
			<table class="info-table">
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
			<h2 class="section-title">접수 처리 센터 정보</h2>
			<table class="info-table">
				<tbody>
					<tr>
						<th>관할센터</th>
						<td>
							<c:out value="${dto.centerName}"/>
							<a href="<c:out value='${dto.centerUrl}'/>" target="_blank" class="detail-btn">자세히 보기</a>
						</td>
						<th>대표전화</th>
						<td><c:out value="${dto.centerPhoneNumber}"/></td>
					</tr>
					<tr>
						<th>주소</th>
						<td colspan="3">(${dto.centerZipCode}) ${dto.centerAddressBase} ${dto.centerAddressDetail}</td>
					</tr>
				</tbody>
			</table>
		</div>
	
		<div class="info-table-container">
			<h2 class="section-title">행정정보 공동이용 동의</h2>
			<table class="info-table">
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
	
		<%-- [수정] 버튼 컨테이너 로직은 그대로 유지 (CSS가 반응형으로 처리) --%>
		<c:choose>
			<c:when test="${dto.statusCode == 'ST_10'}">
				<div class="button-container" style="display: flex; align-items: center; width: 100%;">
					<div style="display: flex; gap: 8px;">
						<a href="${pageContext.request.contextPath}/user/main" 
						   class="btn bottom-btn btn-secondary"
						   style="margin: 0;">목록으로 돌아가기</a>
			
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
			</c:when>
	
			<c:when test="${dto.statusCode == 'ST_20' or dto.statusCode == 'ST_30' or dto.statusCode == 'ST_40'}">
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
	
			<c:otherwise>
				<div class="button-container" style="display: flex; justify-content: center;">
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
		
		
		// --- [추가] PDF 다운로드 버튼 클릭 이벤트 핸들러 ---
		$('#btn-pdf-download').on('click', function() {
  const btn = $(this);
  const originalText = btn.text();

  btn.prop('disabled', true).text('PDF 생성 중...').addClass('disabled');

  const target = document.querySelector('.main-container');
  const applicationNumber = "${dto.applicationNumber}"; // 파일명

  html2canvas(target, { 
    scale: 2, 
    useCORS: true,
    scrollX: 0,
    scrollY: -window.scrollY,
    windowWidth: document.documentElement.scrollWidth,
    windowHeight: document.documentElement.scrollHeight,
    onclone: (doc) => {
      // ✅ 버튼 숨기기
      const buttonContainer = doc.querySelector('.button-container');
      if (buttonContainer) {
        buttonContainer.style.visibility = 'hidden';
      }

      // ✅ 모든 스크롤 영역 펼치기 (overflow 문제 해결)
      doc.querySelectorAll('*').forEach(el => {
        const style = getComputedStyle(el);
        if (style.overflowY === 'auto' || style.overflowY === 'scroll') {
          el.style.overflowY = 'visible';
          el.style.height = 'auto';
        }
        if (style.overflowX === 'auto' || style.overflowX === 'scroll') {
          el.style.overflowX = 'visible';
          el.style.width = 'auto';
        }
      });
    }
  }).then((canvas) => {
    const imgData = canvas.toDataURL('image/png');

    const { jsPDF } = window.jspdf;
    const pdf = new jsPDF('p', 'mm', 'a4'); 

    const margin = 10; 
    const pdfWidth = 210 - (margin * 2); 
    const pageHeight = 297; 
    const pageInnerHeight = pageHeight - (margin * 2); 

    const imgWidth = canvas.width;
    const imgHeight = canvas.height;

    // 이미지 비율 유지한 채 PDF에 맞게 리사이즈
    const pdfImgHeight = (imgHeight * pdfWidth) / imgWidth;

    let heightLeft = pdfImgHeight;
    let position = 0;

    // ✅ 첫 페이지 추가
    pdf.addImage(imgData, 'PNG', margin, margin, pdfWidth, pdfImgHeight);
    heightLeft -= pageInnerHeight;

    // ✅ 다음 페이지가 남아있을 경우 자동 분할
    while (heightLeft > 0) {
      position -= pageInnerHeight;
      pdf.addPage();
      pdf.addImage(imgData, 'PNG', margin, position + margin, pdfWidth, pdfImgHeight);
      heightLeft -= pageInnerHeight;
    }

    const filename = `육아휴직_급여신청서_${applicationNumber}.pdf`;
    pdf.save(filename);

    btn.prop('disabled', false).text(originalText).removeClass('disabled');

  }).catch(function(error) {
    console.error("PDF 생성 오류:", error);
    alert("PDF 생성 중 오류가 발생했습니다.");
    btn.prop('disabled', false).text(originalText).removeClass('disabled');
  });
});
		
	</c:if>
}); 
</script>
</body>
</html>