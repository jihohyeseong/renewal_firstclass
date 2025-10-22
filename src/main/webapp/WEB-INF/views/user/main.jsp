<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>육아휴직 서비스 - 나의 신청내역</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/comp.css">
<style>
    /* --- 테마 색상 및 기본 스타일 (파란색 테마) --- */
    :root {
        --primary-color: #3f58d4;
        --primary-color-dark: #324ca8; /* 더 어두운 파란색 */
        --primary-color-light: #f0f3fd; /* 아주 연한 파란색 */
        
        --status-approved: #3f58d4; /* 승인 (메인 파란색) */
        --status-pending: #f59e0b;  /* 대기 (황색) */
        --status-rejected: #ef4444; /* 반려 (적색) */
        
        --text-color: #333;
        --text-color-light: #555;
        --border-color: #e0e0e0;
        --bg-color-soft: #f9fafb; /* 연한 회색 배경 */
        --white: #ffffff;
    }

    body {
        font-family: 'Noto Sans KR', sans-serif;
        background-color: var(--bg-color-soft); /* 전체 페이지 배경색 */
        color: var(--text-color);
        line-height: 1.6;
    }

    .main-container {
        max-width: 1100px;
        margin: 20px auto;
        padding: 0 20px;
    }

    /* --- 콘텐츠 래퍼 (카드 디자인) --- */
    .content-wrapper {
        background-color: var(--white);
        border-radius: 12px;
        padding: 24px 30px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        margin-bottom: 20px;
    }

    .content-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
        border-bottom: 1px solid var(--border-color);
        padding-bottom: 16px;
    }
    .content-header h2 {
        margin: 0;
        color: #111;
        font-size: 24px;
        font-weight: 700;
    }

    /* --- 버튼 (comp.css 오버라이드) --- */
    .btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 10px 18px;
        font-size: 15px;
        font-weight: 500;
        line-height: 1.5;
        border: 1px solid transparent;
        border-radius: 8px;
        text-decoration: none;
        cursor: pointer;
        transition: all 0.2s ease;
        white-space: nowrap;
    }
    .btn-primary {
        background-color: var(--primary-color);
        color: var(--white);
    }
    .btn-primary:hover {
        background-color: var(--primary-color-dark);
    }
    .btn-secondary {
        background-color: #e9ecef;
        color: #495057;
        border-color: #dee2e6;
    }
    .btn-secondary:hover {
        background-color: #d1d5db;
    }

    /* --- 안내 상자 --- */
    .notice-box {
        background-color: var(--primary-color-light);
        border: 1px solid var(--primary-color);
        border-left-width: 5px;
        border-radius: 8px;
        padding: 20px;
    }
    .notice-box .title {
        display: flex;
        align-items: center;
        font-size: 18px;
        font-weight: 700;
        color: var(--primary-color-dark);
        margin-bottom: 12px;
    }
    .notice-box .title .fa-solid {
        margin-right: 10px;
        font-size: 20px;
    }
    .notice-box ul {
        margin: 0;
        padding-left: 20px;
        color: var(--text-color-light);
        font-size: 14px;
    }
    .notice-box li {
        margin-bottom: 6px;
    }
    .notice-box li:last-child { margin-bottom: 0; }

    /* --- 리스트 테이블 --- */
    .list-table {
        width: 100%;
        border-collapse: collapse;
        table-layout: fixed;
        font-size: 15px;
    }
    .list-table thead th {
        padding: 14px 16px;
        font-weight: 600;
        background-color: var(--primary-color); /* 메인 색상 헤더 */
        color: var(--white);
        text-align: left;
        border-bottom: 2px solid var(--primary-color-dark);
    }
    .list-table thead th:nth-child(4), /* 상태 */
    .list-table thead th:nth-child(5) { /* 작업 */
        text-align: center;
    }
    
    .list-table tbody td {
        padding: 14px 16px; /* 행 높이 확보 */
        line-height: 1.5;
        vertical-align: middle;
        border-bottom: 1px solid var(--border-color);
        color: var(--text-color-light);
    }
    /* 신청번호 강조 */
    .list-table tbody td:first-child {
        color: var(--text-color);
        font-weight: 500;
    }
    .list-table tbody tr:hover { 
        background: var(--primary-color-light); /* 연한 파란색 호버 */
    }

    /* --- 상태 배지 --- */
    .status-badge {
        display: inline-block;
        font-size: 12px;
        font-weight: 600;
        padding: 5px 12px;
        border-radius: 999px;
        line-height: 1;
        text-align: center;
        /* 기본 상태 (알 수 없는 값일 경우) */
        background-color: #f3f4f6; 
        color: #4b5563;
    }
    
    /* ※ statusCode 매핑 이름(한글) 기준으로 클래스명 변경 */
    .status-badge.status-등록,  /* ST_10 (임시저장) */
    .status-badge.status-제출,  /* ST_20 */
    .status-badge.status-대기 {  /* otherwise */
        background-color: #f3f4f6; /* 기본 회색 */
        color: #4b5563;
    }
    .status-badge.status-심사중 { /* ST_30 */
        background-color: #fffbeb; /* 연한 황색 */
        color: #b45309;
    }
    .status-badge.status-심사완료 { /* ST_50 */
        background-color: var(--primary-color-light);
        color: var(--primary-color-dark);
    }
    .status-badge.status-반려 { /* (반려 코드 추가 시) */
        background-color: #ffebeb; /* 연한 적색 */
        color: #b91c1c;
    }

    /* 상태 셀 중앙 정렬 */
    .list-table td.status-cell {
        text-align: center;
    }

    /* --- 테이블 내부 버튼 (기존 오버라이드 유지 및 수정) --- */
    .list-table .btn {
        padding: 6px 12px;
        font-size: 13px;
        font-weight: 500;
        line-height: 1;
        border-radius: 6px;
        margin: 0 2px;
    }
    .list-table td.actions {
        text-align: right;
        white-space: nowrap;
    }

    /* --- 빈 상태 박스 --- */
    .empty-state-box {
        text-align: center;
        padding: 60px 40px;
        background-color: #fcfcfc;
        border-radius: 10px;
        border: 1px dashed var(--border-color);
    }
    /* Font Awesome 아이콘 추가 */
    .empty-state-box::before {
        font-family: "Font Awesome 6 Free";
        font-weight: 900;
        content: "\f115"; /* fa-folder-open */
        font-size: 40px;
        color: var(--primary-color);
        display: block;
        margin-bottom: 20px;
        opacity: 0.6;
    }
    .empty-state-box h3 {
        font-size: 22px;
        color: var(--text-color);
        margin-top: 0;
        margin-bottom: 12px;
    }
    .empty-state-box p {
        font-size: 16px;
        color: var(--text-color-light);
        margin: 0;
    }

</style>
</head>
<body>

<%@ include file="header.jsp" %>

<main class="main-container"> 

    <div class="notice-box"> <div class="title">
            <i class="fa-solid fa-volume-high"></i>
            <span>안내</span>
        </div>
        <ul>
            <li><strong>육아휴직급여:</strong> [모의계산하기]버튼을 클릭하면 예상 지급액을 확인할 수 있습니다.</li>
            <li><strong>신청기간:</strong> 휴직개시일 1개월 이후부터 휴직종료일 이후 1년 이내 신청 가능합니다.</li>
            <li><strong>승인기간:</strong> 신청서 제출완료 후 심시완료까지는 평균적으로 2-5일 소요됩니다. </li>
        </ul>
    </div>

    <div class="content-wrapper">
        <div class="content-header">
            <h2><sec:authentication property="principal.username" /> 님의 신청 내역</h2>
            
            <form action="${pageContext.request.contextPath}/user/confirms" method="POST" style="margin: 0;">
                <input type="hidden" name="name" value="${simpleUserInfoVO.name}">
                <input type="hidden" name="registrationNumber" value="${simpleUserInfoVO.registrationNumber}">
                
                <button type="submit" class="btn btn-primary">새로 신청하기</button>
            </form>
        </div>

        <c:choose>
            <c:when test="${empty list}">
                <div class="empty-state-box">
                    <h3>아직 신청 내역이 없으시네요.</h3>
                    <p>소중한 자녀를 위한 첫걸음, 지금 바로 시작해보세요.</p>
                </div>
            </c:when>
            <c:otherwise>
                <table class="list-table">
                    <thead>
                        <tr>
                            <th style="width: 18%;">신청번호</th>
                            <th style="width: 20%;">신청일</th>
                            <th style="width: 20%;">신청자 이름</th>
                            <th style="width: 18%;">상태</th>
                            <th style="width: 140px;">작업</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="app" items="${list}">
                            <tr>
                                <td>${app.applicationNumber}</td>
                                <td>${not empty app.submittedDt ? app.submittedDt : '-'}</td>
                                <td>${app.name}</td>
                                
                                <td class="status-cell"> 
                                    <c:set var="stCode" value="${app.statusCode}" />
                                    <c:set var="stName">
                                        <c:choose>
                                            <c:when test="${stCode == 'ST_10'}">등록</c:when>
                                            <c:when test="${stCode == 'ST_20'}">제출</c:when>
                                            <c:when test="${stCode == 'ST_30'}">심사중</c:when>
                                            <c:when test="${stCode == 'ST_50'}">심사완료</c:when>
                                            <c:otherwise>대기</c:otherwise> <%-- 예외 처리 (기본값) --%>
                                        </c:choose>
                                    </c:set>
                                    
                                    <span class="status-badge status-${stName}">${stName}</span>
                                </td>
    
                                <td class="actions">
                                    <a href="${pageContext.request.contextPath}/user/detail/${app.applicationNumber}" class="btn btn-secondary">
                                        상세보기</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<footer class="footer">
    <p>&copy; 2025 육아휴직 서비스. All Rights Reserved.</p>
</footer>

<c:if test="${not empty error}">
    <script type="text/javascript">
    window.onload = function() {
        alert('${error}');
    };
    </script>
</c:if>
</body>
</html>