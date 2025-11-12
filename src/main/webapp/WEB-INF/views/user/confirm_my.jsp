<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>육아휴직 서비스 - 나의 육아휴직 확인서</title>
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
    .btn:disabled {
        opacity: 0.7;
        cursor: not-allowed;
    }
    .btn-primary {
        background-color: var(--primary-color);
        color: var(--white);
    }
    .btn-primary:hover:not(:disabled) {
        background-color: var(--primary-color-dark);
    }
    .btn-secondary {
        background-color: #e9ecef;
        color: #495057;
        border-color: #dee2e6;
    }
    .btn-secondary:hover:not(:disabled) {
        background-color: #d1d5db;
    }

    /* --- 안내 상자 --- */
    .notice-box { 
        background-color: var(--primary-color-light); 
        border: 1px solid var(--primary-color); 
        border-left-width: 5px; 
        border-radius: 8px; 
        padding: 20px; 
        margin-bottom: 20px;
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
    .notice-box li { margin-bottom: 6px; }
    .notice-box li:last-child { margin-bottom: 0; }

    /* --- [수정] 리스트 테이블 스타일 (신청내역 페이지 참고) --- */
    
    /* 반응형 테이블을 위한 컨테이너 */
    .table-container {
        width: 100%;
        overflow-x: auto; /* 모바일에서 가로 스크롤 생성 */
        margin-top: 16px;
        /* border: 1px solid var(--border-color); */
        /* border-radius: 8px; */
    }
    
    .list-table { 
        width: 100%; 
        border-collapse: collapse; 
        table-layout: fixed; 
        font-size: 15px; 
        min-width: 700px; /* 가로 스크롤을 위한 최소 너비 */
    }
    .list-table thead th { 
        padding: 14px 16px; 
        font-weight: 600; 
        background-color: var(--primary-color); /* 파란색 헤더 */
        color: var(--white); 
        text-align: left; 
        border-bottom: 2px solid var(--primary-color-dark); 
    }
    .list-table tbody td { 
        padding: 14px 16px; 
        line-height: 1.5; 
        vertical-align: middle; 
        border-bottom: 1px solid var(--border-color); 
        color: var(--text-color-light); 
        white-space: nowrap; /* 줄바꿈 방지 */
    }
    .list-table tbody td:first-child { 
        color: var(--text-color); 
        font-weight: 500; 
    }
    .list-table tbody tr:hover { 
        background: var(--primary-color-light); /* 마우스 오버 시 연한 파란색 */
    }
    
    /* [수정] 테이블 내 버튼 스타일 */
    .list-table .btn { 
        padding: 6px 12px; 
        font-size: 13px; 
        font-weight: 500; 
        line-height: 1; 
        border-radius: 6px; 
        margin: 0 2px; 
    }
    
    /* [신규] 정렬 및 강조 스타일 */
    .list-table .col-center { text-align: center; }
    .list-table .col-left { text-align: left; }
    
    .list-table .col-start-date { 
        color: #3f58d4;
        font-weight: 600;
    }
    .list-table .col-end-date {
        color: #3f58d4;
        font-weight: 600;
    }

    /* --- 빈 상태 박스 --- */
    .empty-state-box { 
        text-align: center; 
        padding: 60px 40px; 
        background-color: #fcfcfc; 
        border-radius: 10px; 
        border: 1px dashed var(--border-color); 
    }
    .empty-state-box::before { 
        font-family: "Font Awesome 6 Free"; 
        font-weight: 900; 
        content: "\f115"; 
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
    
    .footer {
       text-align: center;
       padding: 20px 0;
       font-size: 14px;
       color: #888;
    }

    /* ---------------------------------- */
    /* 📱 반응형 스타일 (Tablet & Mobile) */
    /* ---------------------------------- */
    @media (max-width: 768px) {
        .main-container {
            margin: 10px auto;
            padding: 0 10px;
        }
        .content-wrapper {
            padding: 20px 15px;
        }
        .content-header h2 {
            font-size: 22px;
        }
        .notice-box {
            padding: 15px;
        }
        .notice-box .title {
            font-size: 17px;
        }
        .notice-box ul {
            font-size: 13px;
            padding-left: 18px;
        }
        
        /* [수정] 테이블 반응형 스타일 */
        .list-table {
            font-size: 14px;
        }
        .list-table thead th,
        .list-table tbody td {
            padding: 12px 10px; /* 패딩 축소 */
            font-size: 14px;
            white-space: nowrap; /* 가로 스크롤 유지 */
        }

        .empty-state-box {
            padding: 40px 20px;
        }
        .empty-state-box h3 {
            font-size: 20px;
        }
        .empty-state-box p {
            font-size: 15px;
        }
    }
    
    @media (max-width: 480px) {
        .content-wrapper {
            padding: 15px;
        }
        .content-header h2 {
            font-size: 20px;
        }
        .list-table thead th,
        .list-table tbody td {
            font-size: 12px;
            padding: 10px 8px;
        }
        .list-table .btn {
            font-size: 11px;
            padding: 5px 8px;
        }
    }
    
</style>
</head>
<body>

<%@ include file="header.jsp" %>

<main class="main-container"> 

    <div class="notice-box">
        <div class="title">
            <i class="fa-solid fa-list-check"></i>
            <span>육아휴직 확인서 목록</span>
        </div>
        <ul>
            <li>이 목록은 회사에서 승인한 육아휴직 내역입니다.</li>
            <li>'상세보기' 버튼을 클릭하여 상세 내용을 확인하고 PDF로 저장할 수 있습니다.</li>
        </ul>
    </div>

    <div class="content-wrapper">
        <form id="applyForm">
        
            <div class="content-header">
                <h2>나의 육아휴직 확인서</h2>
            </div>
            
            <input type="hidden" id="selectedConfirmNumber" value="">

            <c:choose>
                <c:when test="${empty simpleConfirmList}">
                    <div class="empty-state-box">
                        <h3>회사에서 승인한 휴직 내역이 없습니다.</h3>
                        <p>회사 담당자에게 휴직 확인 승인을 요청하세요.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    
                    <%-- ✨ [수정] 테이블 컨테이너 및 테이블 클래스 변경 --%>
                    <div class="table-container">
                        <table class="list-table">
                            <thead>
                                <tr>
                                    <th class="col-left" style="width: 20%;">회사명</th>
                                    <th class="col-left" style="width: 25%;">신청번호</th>
                                    <th class="col-center" style="width: 15%;">신청일</th>
                                    <th class="col-center" style="width: 15%;">휴직 시작일</th>
                                    <th class="col-center" style="width: 15%;">휴직 종료일</th>
                                    <th class="col-center" style="width: 10%;">작업</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="confirm" items="${simpleConfirmList}" varStatus="status">
                                    
                                    <c:url var="detailUrl" value="/user/confirm/detail">
                                        <c:param name="confirmNumber" value="${confirm.confirmNumber}" />
                                    </c:url>
                                            
                                    <tr>
                                        <td class="col-left">${confirm.name}</td>
                                        <td class="col-left">${confirm.confirmNumber}</td>
                                        <td class="col-center">${not empty confirm.applyDt ? confirm.applyDt : '-'}</td>
                                        <td class="col-center col-start-date">${confirm.startDate}</td>
                                        <td class="col-center col-end-date">${confirm.endDate}</td>
                                        <td class="col-center">
                                            <%-- ✨ [수정] 상세보기 버튼 스타일 변경 --%>
                                            <a href="${detailUrl}" class="btn btn-secondary">상세보기</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    
                </c:otherwise>
            </c:choose>
            
        </form>
    </div>
</main>

<footer class="footer">
    <p>&copy; 2025 육아휴직 서비스. All Rights Reserved.</p>
</footer>

<%-- ✨ 자바스크립트 (에러 알림만 유지) --%>
<c:if test="${not empty error}">
    <script type="text/javascript">
    window.onload = function() {
        alert('${error}');
    };
    </script>
</c:if>

</body>
</html>