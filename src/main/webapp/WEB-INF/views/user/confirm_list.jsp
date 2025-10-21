<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>육아휴직 서비스 - 신청할 휴직 선택</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/comp.css">
<style>
    :root {
        --primary-color: #3f58d4;
        --primary-color-dark: #324ca8;
        --primary-color-light: #f0f3fd;
        --status-approved: #3f58d4;
        --status-pending: #f59e0b;
        --status-rejected: #ef4444;
        --text-color: #333;
        --text-color-light: #555;
        --border-color: #e0e0e0;
        --bg-color-soft: #f9fafb;
        --white: #ffffff;
    }
    body {
        font-family: 'Noto Sans KR', sans-serif;
        background-color: var(--bg-color-soft);
        color: var(--text-color);
        line-height: 1.6;
    }
    .main-container {
        max-width: 1100px;
        margin: 20px auto;
        padding: 0 20px;
    }
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
    
    .submit-area {
        text-align: right;
        margin-top: 20px;
    }

    .card-list-container {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
        gap: 20px;
        margin-top: 16px;
    }
    
    .selectable-card {
        display: flex;
        flex-direction: column;
        background-color: var(--white);
        border: 2px solid var(--border-color);
        border-radius: 10px;
        padding: 20px;
        cursor: pointer;
        transition: all 0.2s ease-in-out;
        position: relative;
        box-shadow: 0 2px 4px rgba(0,0,0,0.03);
    }
    
    .selectable-card:hover {
        border-color: #b0bec5;
        transform: translateY(-4px);
        box-shadow: 0 6px 12px rgba(0,0,0,0.07);
    }
    
    .selectable-card.active {
        border-color: var(--primary-color);
        background-color: var(--white);
        box-shadow: 0 6px 16px rgba(63, 88, 212, 0.2);
        transform: translateY(-4px);
    }
    
    .card-selection-indicator {
        position: absolute;
        top: 15px;
        right: 15px;
        font-size: 26px;
        color: var(--primary-color);
        opacity: 0;
        transform: scale(0.5);
        transition: all 0.2s ease-in-out;
    }

    .selectable-card.active .card-selection-indicator {
        opacity: 1;
        transform: scale(1);
    }
    
    .selectable-card .card-header {
        display: flex;
        align-items: center;
        margin-bottom: 15px;
    }
    
    .selectable-card .card-icon {
        flex-shrink: 0;
        width: 50px;
        height: 50px;
        border-radius: 50%;
        background-color: var(--primary-color-light);
        color: var(--primary-color);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 22px;
        margin-right: 15px;
        transition: all 0.2s ease;
    }
    
    .selectable-card.active .card-icon {
        background-color: var(--primary-color);
        color: var(--white);
    }
    
    .selectable-card .card-title-group {
        display: flex;
        flex-direction: column;
    }

    .selectable-card .card-company-name {
        font-size: 18px;
        font-weight: 700;
        color: var(--text-color);
        line-height: 1.3;
    }
    
    .selectable-card .card-confirm-number {
        font-size: 13px;
        color: var(--text-color-light);
    }

    .selectable-card .card-body {
        border-top: 1px solid var(--border-color);
        padding-top: 15px;
        display: grid;
        grid-template-columns: 1fr;
        gap: 12px;
    }
    
    .selectable-card .card-info-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-size: 14px;
    }
    
    .selectable-card .info-label {
        font-weight: 500;
        color: #6b7280;
        display: flex;
        align-items: center;
        flex-shrink: 0;
        margin-right: 10px;
    }
    
    .selectable-card .info-label .fa-solid {
        margin-right: 8px;
        width: 1.25em;
        text-align: center;
    }
    
    .selectable-card .info-value {
        font-weight: 600;
        color: var(--text-color);
        text-align: right;
        word-break: break-word;
    }
    
    .selectable-card .info-value-start,
    .selectable-card .info-value-end {
        color: var(--status-rejected);
        font-weight: 700;
    }

</style>
</head>
<body>

<%@ include file="header.jsp" %>

<main class="main-container"> 

    <div class="notice-box">
        <div class="title">
            <i class="fa-solid fa-check-circle"></i>
            <span>육아휴직 급여 신청 안내</span>
        </div>
        <ul>
            <li>이 목록은 회사에서 승인한 육아휴직 내역입니다.</li>
            <li>급여를 신청할 항목을 하나 선택한 후, 하단의 '신청하기' 버튼을 클릭하세요.</li>
        </ul>
    </div>

    <div class="content-wrapper">
        <form id="applyForm" action="${pageContext.request.contextPath}/user/application">
        
            <div class="content-header">
                <h2>신청할 휴직 내역 선택</h2>
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
                    
                    <div class="card-list-container">
                        <c:forEach var="confirm" items="${simpleConfirmList}" varStatus="status">
                            <div class="selectable-card" 
                                 data-value="${confirm.confirmNumber}" 
                                 id="item_${status.index}">
                                
                                <div class="card-selection-indicator">
                                    <i class="fa-solid fa-circle-check"></i>
                                </div>
                                
                                <div class="card-header">
                                    <div class="card-icon">
                                        <i class="fa-solid fa-building"></i>
                                    </div>
                                    <div class="card-title-group">
                                        <span class="card-company-name">${confirm.name}</span>
                                        <span class="card-confirm-number">신청번호: ${confirm.confirmNumber}</span>
                                    </div>
                                </div>
                                
                                <div class="card-body">
                                    <div class="card-info-item">
                                        <span class="info-label">
                                            <i class="fa-solid fa-calendar-day"></i> 신청일
                                        </span>
                                        <span class="info-value">${not empty confirm.applyDt ? confirm.applyDt : '-'}</span>
                                    </div>
                                    <div class="card-info-item">
                                        <span class="info-label">
                                            <i class="fa-solid fa-calendar-plus"></i> 휴직 시작일
                                        </span>
                                        <span class="info-value info-value-start">${confirm.startDate}</span>
                                    </div>
                                    <div class="card-info-item">
                                        <span class="info-label">
                                            <i class="fa-solid fa-calendar-check"></i> 휴직 종료일
                                        </span>
                                        <span class="info-value info-value-end">${confirm.endDate}</span>
                                    </div>
                                    <div class="card-info-item">
                                        <span class="info-label">
                                            <i class="fa-solid fa-phone"></i> 담당자 번호
                                        </span>
                                        <span class="info-value">${not empty confirm.phoneNumber ? confirm.phoneNumber : '-'}</span>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <div class="submit-area">
                        <button type="submit" class="btn btn-primary">
                            <i class="fa-solid fa-pen-to-square" style="margin-right: 8px;"></i>
                            신청하기
                        </button>
                    </div>
                    
                </c:otherwise>
            </c:choose>
            
        </form>
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

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<script type="text/javascript">
$(document).ready(function() {
    
    $('.card-list-container').on('click', '.selectable-card', function() {
        var $clickedCard = $(this);
        var selectedValue = $clickedCard.data('value');
        
        if ($clickedCard.hasClass('active')) {
            $clickedCard.removeClass('active');
            $('#selectedConfirmNumber').val('');
        } else {
            $('.selectable-card').removeClass('active');
            $clickedCard.addClass('active');
            $('#selectedConfirmNumber').val(selectedValue);
        }
    });

    // [수정 3] 폼 제출 이벤트를 가로채서 PathVariable URL로 직접 이동시킵니다.
    $("#applyForm").submit(function(e) {
        // 1. 폼의 기본 제출 동작(파라미터 전송)을 무조건 막습니다.
        e.preventDefault(); 
        
        // 2. 숨겨진 input에서 선택된 값을 가져옵니다.
        var selectedValue = $('#selectedConfirmNumber').val();

        // 3. 유효성 검사
        if (selectedValue === '' || selectedValue == null) {
            alert('신청할 항목을 하나 선택해주세요.');
        } else {
            // 4. 유효성 검사 통과: PathVariable을 포함한 새 URL을 만듭니다.
            // <form>의 'action' 속성에 지정된 기본 URL을 가져옵니다.
            var baseUrl = $(this).attr('action'); 
            // 기본 URL 뒤에 선택된 값을 붙여서 새 URL을 만듭니다.
            var newUrl = baseUrl + "/" + selectedValue;
            
            // 5. 브라우저를 새 URL로 이동시킵니다 (이것이 GET 요청입니다).
            window.location.href = newUrl;
        }
    });
});
</script>

</body>
</html>