<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>육아휴직 급여 신청 완료</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/comp.css">
<style>
/* 2) 표 컨테이너/섹션 타이틀 (공통에 없으니 페이지 전용 유지) */
.info-table-container{
  width:100%;
  text-align:left;
  margin:0 auto 50px;
}

h2.section-title{
  font-size:20px;
  font-weight:700;
  color:var(--dark-gray-color);
  margin:25px 0 15px;
  padding-bottom:5px;
  border-bottom:2px solid var(--border-color);
  width:fit-content;
}

/* 3) 표 스타일 (공통에 없으니 페이지 전용 유지) */
.info-table{
  width:100%;
  border-collapse:collapse;
  table-layout:fixed;
  border-top:2px solid var(--dark-gray-color);
  border-bottom:1px solid var(--border-color);
}
.info-table th,
.info-table td{
  padding:12px 15px;
  border-bottom:1px solid var(--border-color);
  font-size:15px;
}
.info-table th{
  background-color:var(--light-gray-color);
  width:120px;
  font-weight:500;
  color:var(--gray-color);
  text-align:left;
}
.info-table td{
  color:var(--dark-gray-color);
  font-weight:400;
  word-break:break-all;
}
.info-table .data-title{
  width:150px;
  background-color:var(--light-gray-color);
  color:var(--gray-color);
  font-weight:500;
}

/* 4) 2열 테이블 보조 */
.table-2col th{width:120px}
.table-2col .data-title{width:120px}

/* 5) “자세히 보기” 버튼 (페이지 전용 UI) */
.detail-btn{
  display:inline-block;
  padding:3px 8px;
  font-size:13px;
  font-weight:500;
  margin-left:10px;
  color:var(--primary-color);
  border:1px solid var(--primary-color);
  background-color:var(--primary-light-color);
  border-radius:4px;
  cursor:pointer;
  transition:all .2s;
}
.detail-btn:hover{
  background-color:var(--primary-color);
  color:var(--white-color);
}

/* 6) 완료 아이콘 (페이지 전용) */
.completion-icon {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  background-color: var(--success-color);
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 30px;
  animation: pop-in 0.5s ease-out forwards;
}
.completion-icon::after {
  content: '';
  width: 20px;
  height: 40px;
  border: solid var(--white-color);
  border-width: 0 8px 8px 0;
  transform: rotate(45deg);
}

/* 7) 팝인 애니메이션 */
@keyframes pop-in {
  0%   { transform: scale(0);   opacity: 0; }
  80%  { transform: scale(1.1); opacity: 1; }
  100% { transform: scale(1);   opacity: 1; }
}

/* 8) 버튼 컨테이너 (공통 .btn은 위 CSS를 사용하므로 여기선 배치만) */
.button-container{
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 16px;
  width: 100%;
  margin-top: 50px;
  flex-wrap: wrap;
}

/* (선택) 이 페이지 버튼 조금 크게 */
.button-container .btn{
  padding: 12px 30px;
  font-size: 1.1em;
}

.complete-message {
  text-align: center;
}

</style>
</head>
<body>
<%@ include file="compheader.jsp" %>

   
	<main class="main-container">
    <div class="content-wrapper complete-card">              
	<div class="completion-icon"></div>
	       
	<div class="complete-message">신청이 정상적으로 완료되었습니다. </div>

	<div class="info-table-container">
		<h2 class="section-title">접수정보</h2>
		<table class="info-table">
			<tbody>
				<tr>
					<th class="data-title">접수번호</th>
					<td>${confirmDTO.confirmNumber}</td>
					<th class="data-title">민원내용</th>
					<td>육아휴직 급여 신청</td>
				</tr>
				<tr>
					<th class="data-title">신청일</th>
					<td><fmt:formatDate value="${confirmDTO.applyDt}"
							pattern="yyyy-MM-dd" /></td>
					<th class="data-title">신청인</th>
					<td>${confirmDTO.name}</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="info-table-container">
		<h2 class="section-title">센터정보</h2>
		<table class="info-table table-2col">
			<tbody>
				<tr>
					<th class="data-title">센터명</th>
						<td colspan="3">${confirmDTO.centerName}
						<a href="${confirmDTO.centerURL}" class="detail-btn" target="_blank"
							rel="noopener"> 자세히 보기 </a>
						</td>
					</tr>
				<tr>
					<th class="data-title">주소</th>
					<td colspan="3">[${confirmDTO.centerZipCode}] ${confirmDTO.centerAddressBase}${confirmDTO.centerAddressDetail}</td>
				</tr>
				<tr>
					<th class="data-title">대표전화</th>
					<td>${confirmDTO.centerPhoneNumber}</td>
				</tr>
			</tbody>
		</table>
	</div>
	                   
	<div class="button-container">
		<a href="/renewal_firstclass/comp/main" class="btn btn-primary">목록으로 이동</a> 
		<a href="${pageContext.request.contextPath}/comp/detail?confirmNumber=${confirmDTO.confirmNumber}"
			class="btn btn-secondary">신청 내용 상세 보기</a>
	</div>
	</div>
	    </main>

	   
	<footer class="footer">
		<p>&copy; 2025 육아휴직 서비스. All Rights Reserved.</p>
	</footer>
</body>
</html>