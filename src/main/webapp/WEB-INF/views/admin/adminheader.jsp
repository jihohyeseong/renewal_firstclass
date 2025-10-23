<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<style>
    .header {
        background-color: var(--white-color);
        padding: 15px 40px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 1px solid var(--border-color);
        box-shadow: var(--shadow-sm);
        position: sticky;
        top: 0;
        z-index: 10;
    }
    .header .logo img { 
        vertical-align: middle; 
    }
    .header nav { 
        display: flex; 
        align-items: center; 
        gap: 15px; 
    }
    .header .welcome-msg { 
        font-size: 16px; 
        color: var(--dark-gray-color); 
    }
    
</style>

<header class="header">
    <a href="${pageContext.request.contextPath}/admin/applications" class="logo"><img src="${pageContext.request.contextPath}/resources/images/logo.png" alt="Logo" width="auto" height="80"></a>
    <nav>
    	<ul class="header-nav">
    		<li><a class="nav-link ${fn:contains(currentURI, '/confirm') ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/confirm">확인서 보기</a></li>
    		<li><a class="nav-link ${fn:contains(currentURI, '/apply') ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/user/apply">신청서 보기</a></li>
    		<li>
    			<c:choose>
				    <c:when test="${not empty adminCheck && adminCheck.centerPosition eq 'leader'}">
				        <a class="nav-link" href="${pageContext.request.contextPath}/admin/superior">2차 신청서 보기</a>
				    </c:when>
				    <c:otherwise>
				        <a class="nav-link" href="#" onclick="alert('권한이 없습니다.'); return false;">2차 신청서 보기</a>
				    </c:otherwise>
				</c:choose>

    		</li>
    		<li><a class="nav-link" href="${pageContext.request.contextPath}/main">추가지급</a></li>
    	</ul>
        <sec:authorize access="isAnonymous()">
            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">로그인</a>
        </sec:authorize>
        <sec:authorize access="isAuthenticated()">
            <span class="welcome-msg">
                <sec:authentication property="principal.username"/>님, 환영합니다.
            </span>
            <form id="logout-form" action="${pageContext.request.contextPath}/logout" method="post" style="display: none;">
                <sec:csrfInput/>
            </form>
            <a href="#" onclick="document.getElementById('logout-form').submit(); return false;" class="btn btn-logout">로그아웃</a>
        </sec:authorize>
    </nav>
</header>
