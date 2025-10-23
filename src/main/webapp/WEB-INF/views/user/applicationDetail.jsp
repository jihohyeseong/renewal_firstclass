<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
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

.header,.footer{
	background-color:var(--white-color);padding:15px 40px;border-bottom:1px solid var(--border-color);box-shadow:var(--shadow-sm);
}
.footer{border-top:1px solid var(--border-color);border-bottom:none;text-align:center;padding:20px 0;margin-top:auto}
.header{display:flex;justify-content:space-between;align-items:center;position:sticky;top:0;z-index:10}
.header nav{display:flex;align-items:center;gap:15px}
.header .welcome-msg{font-size:16px}

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
.btn-danger { background-color: var(--danger-color); color: #fff; border-color: var(--danger-color); }
.btn-danger:hover { background-color: #c82333; border-color: #bd2130; transform:translateY(-2px); box-shadow:var(--shadow-md); }


/* [수정] 하단 버튼 컨테이너 스타일 */
.button-container{
	display: flex;
    justify-content: center; /* 기본은 중앙 정렬 */
    align-items: center;
    gap: 15px;
    margin-top:50px;
}
/* [추가] 버튼들을 양쪽으로 배치할 때 사용하는 클래스 */
.button-container.spread-out {
    justify-content: space-between;
    gap: 0; /* space-between 사용 시에는 gap 불필요 */
}
/* [추가] 왼쪽 버튼들을 그룹화 하기 위한 클래스 */
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

/* 하이라이팅을 위한 CSS 클래스 */
.highlight-warning {
    background-color: #fff3cd; 
    color: #856404;
    font-weight: 700;
    padding: 2px 6px;
    border-radius: 4px;
}
</style>
</head>
<body>
<jsp:include page="header.jsp" />
	<main class="main-container">
	<h1>육아휴직 급여 신청서 상세 보기</h1>
	
	<!-- DTO가 비어있는 경우 처리 -->
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
						<td colspan="3">
							<c:if test="${not empty dto.registrationNumber}">
						        <c:set var="rrnCleaned" value="${fn:replace(fn:replace(fn:trim(dto.registrationNumber), '-', ''), ' ', '')}" />
						        ${fn:substring(rrnCleaned, 0, 6)}-${fn:substring(rrnCleaned, 6, 13)}
						    </c:if>
						</td>
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
	
		<div class="info-table-container">
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
			<table class="info-table">
				<thead>
					<tr>
						<th style="text-align:center;">회차</th>
						<th style="text-align:center;">기간</th>
						<th style="text-align:center;">사업장 지급액</th>
						<th style="text-align:center;">정부 지급액</th>
						<th style="text-align:center;">신청가능일</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="item" items="${dto.list}" varStatus="status">
						<tr>
							<td style="text-align:center;">${status.count}개월차</td>
							<td style="text-align:center;"><fmt:formatDate value="${item.startMonthDate}" pattern="yyyy.MM.dd"/> ~ <fmt:formatDate value="${item.endMonthDate}" pattern="yyyy.MM.dd"/></td>
							<td style="text-align:right;"><fmt:formatNumber value="${item.companyPayment}" type="currency" currencySymbol="₩ " /></td>
							<td style="text-align:right;"><fmt:formatNumber value="${item.govPayment}" type="currency" currencySymbol="₩ " /></td>
							<td style="text-align:center;"><fmt:formatDate value="${item.paymentDate}" pattern="yyyy.MM.dd"/></td>
						</tr>
					</c:forEach>
	
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
							<td colspan="3">
								<c:if test="${not empty dto.childResiRegiNumber}">
							        <c:set var="rrnCleaned" value="${fn:replace(fn:replace(fn:trim(dto.childResiRegiNumber), '-', ''), ' ', '')}" />
							        ${fn:substring(rrnCleaned, 0, 6)}-${fn:substring(rrnCleaned, 6, 13)}
							    </c:if>
							</td>
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
	
		<!-- [수정] 버튼 컨테이너 구조 변경 -->
		<c:choose>
			<c:when test="${dto.statusCode == 'ST_10'}">
				<div class="button-container spread-out">
					<div class="button-group-left">
						<a href="${pageContext.request.contextPath}/user/main" class="btn bottom-btn btn-secondary">목록으로 돌아가기</a>
						<a href="${pageContext.request.contextPath}/user/application/update/${dto.applicationNumber}"
						   class="btn bottom-btn btn-primary">신청 내용 수정</a>
						<form id="submitForm" action="${pageContext.request.contextPath}/user/submit/${dto.applicationNumber}" method="post" style="display: inline;">
							<sec:csrfInput/>
							<button type="button" onclick="confirmAction('submitForm', '최종 제출 후에는 수정할 수 없습니다. 제출하시겠습니까?')" class="btn bottom-btn btn-primary">최종 제출</button>
						</form>
					</div>
					<form id="deleteForm" action="${pageContext.request.contextPath}/user/delete/${dto.applicationNumber}" method="post" style="display: inline;">
						<sec:csrfInput/>
						<button type="button" onclick="confirmAction('deleteForm', '정말로 삭제하시겠습니까?')" class="btn bottom-btn btn-danger">삭제</button>
					</form>
				</div>
			</c:when>
	
			<c:when test="${dto.statusCode == 'ST_20' or dto.statusCode == 'ST_30' or dto.statusCode == 'ST_40'}">
				<div class="button-container spread-out">
					<a href="${pageContext.request.contextPath}/user/main" class="btn bottom-btn btn-secondary">목록으로 돌아가기</a>
					<form id="cancelForm" action="${pageContext.request.contextPath}/user/cancel/${dto.applicationNumber}" method="post" style="display: inline;">
						<sec:csrfInput/>
						<button type="button" onclick="confirmAction('cancelForm', '신청을 취소하시겠습니까?')" class="btn bottom-btn btn-danger">신청 취소</button>
					</form>
				</div>
			</c:when>
	
			<c:otherwise>
				<%-- ST_50, ST_60 and any other cases --%>
				<div class="button-container">
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

// $(document).ready(function() {
	
	// JSTL을 사용해 dto 객체가 비어있지 않은 경우에만(즉, 유효한 applicationNumber가 있을 때만)
	// 권한 확인 AJAX 요청을 실행합니다.
	<c:if test="${not empty dto}">
	
		const applicationNumber = "${dto.applicationNumber}";
		const contextPath = "${pageContext.request.contextPath}";
		
		// 페이지 내의 Spring Security <sec:csrfInput/> 태그가 생성한
		// CSRF 토큰 input의 value를 찾습니다.
		// (페이지에 'submitForm' 또는 'deleteForm' 등이 이미 존재하므로 토큰을 찾을 수 있습니다.)
		const csrfToken = $("input[name='_csrf']").val();

		$.ajax({
			type: "GET",
			url: contextPath + "/user/check/detail/" + applicationNumber,
			headers: {
				'X-CSRF-TOKEN': csrfToken  // GET 요청이라도 Spring Security 설정에 따라 필요할 수 있으므로 전송
			},
			dataType: "json",
			success: function(response) {
				// 컨트롤러에서 success: false 를 반환한 경우 (권한 없음)
				if (!response.success) {
					alert(response.message);
					window.location.href = contextPath + response.redirectUrl;
				}
				// success: true 인 경우 (권한 있음)
				// 아무 동작도 하지 않고 페이지를 그대로 보여줍니다.
			},
			error: function(xhr, status, error) {
				// 500 에러 등 AJAX 호출 자체에 실패한 경우
				console.error("AJAX Error:", status, error);
				alert("페이지 권한 확인 중 오류가 발생했습니다. 메인 페이지로 이동합니다.");
				// 에러 발생 시 안전하게 메인 페이지로 리다이렉트
				window.location.href = contextPath + "/user/main";
			}
		});
		
	</c:if>
});
</script>
</body>
</html>

