<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/comp.css">
</head>
<body>

<header class="header">
	<a href="${pageContext.request.contextPath}/comp/main" class="logo"><img
		src="${pageContext.request.contextPath}/resources/images/logo_comp.png"
		alt="Logo" width="auto" height="80"></a>
	<nav>
		<ul class="header-nav">
			<li><a
                class="nav-link ${fn:contains(pageContext.request.requestURI, '/compmain') ? 'active' : ''}"
                href="${pageContext.request.contextPath}/comp/main">신청내역</a></li>
            <li><a
                class="nav-link ${fn:contains(pageContext.request.requestURI, '/calc') ? 'active' : ''}"
                href="${pageContext.request.contextPath}/calc/corp">모의 계산하기</a></li>
            <li><a
                class="nav-link ${fn:contains(pageContext.request.requestURI, '/mypage') ? 'active' : ''}"
                href="${pageContext.request.contextPath}/mypage">마이페이지</a></li>
		</ul>
		<sec:authorize access="isAnonymous()">
			<a href="${pageContext.request.contextPath}/login"
				class="btn btn-primary">로그인</a>
		</sec:authorize>
		<sec:authorize access="isAuthenticated()">
<%-- 			<span class="welcome-msg"> <sec:authentication
					property="principal.username" />님, 환영합니다.
			</span> --%>
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
</body>
</html>