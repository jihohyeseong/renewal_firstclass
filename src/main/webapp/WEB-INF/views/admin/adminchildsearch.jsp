<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/global.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/comp.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<style>
	/* 공통 스타일 */
	:root {
            --primary-color: #3f58d4;
            --primary-light-color: #f0f2ff;
            --white-color: #ffffff;
            --light-gray-color: #f8f9fa;
            --gray-color: #868e96;
            --dark-gray-color: #343a40;
            --border-color: #dee2e6;
            --success-color: #28a745;
            --danger-color: #dc3545;
            --shadow-sm: 0 1px 3px rgba(0,0,0,0.05);
            --shadow-md: 0 4px 8px rgba(0,0,0,0.07);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        html { height: 100%; }
        body {
            display: flex; flex-direction: column; min-height: 100vh;
            font-family: 'Noto Sans KR', sans-serif;
            background-color: var(--light-gray-color);
            color: var(--dark-gray-color);
        }
        a { text-decoration: none; color: inherit; }
	
        .btn {
            display: inline-block;
            padding: 10px 20px;
            font-size: 15px;
            font-weight: 500;
            border-radius: 8px;
            border: 1px solid var(--border-color);
            cursor: pointer;
            transition: all 0.2s ease-in-out;
            text-align: center;
        }
        .btn-primary { background-color: var(--primary-color); color: var(--white-color); border-color: var(--primary-color); }
        .btn-primary:hover { background-color: #364ab1; box-shadow: var(--shadow-md); transform: translateY(-2px); }
        .btn-logout { background-color: var(--dark-gray-color); color: var(--white-color); border: none; }
        .btn-logout:hover { background-color: #555; }
        .btn-secondary { background-color: var(--white-color); color: var(--gray-color); border-color: var(--border-color); }
        .btn-secondary:hover { background-color: var(--light-gray-color); color: var(--dark-gray-color); border-color: #ccc; }
        
        /* --- [수정] 검색창 스타일 --- */
        h2 {
            text-align: center;
            margin: 1.5rem 0 1rem 0; /* 위아래 여백 */
            font-weight: 700;
        }
        
        .search-wrapper {
            /* 기존 margin-bottom: 20px; */
            /* [수정] 카드 디자인 및 가운데 정렬 */
            max-width: 1200px; /* 테이블과 너비 맞춤 */
            margin: 0 auto 20px auto; /* 가운데 정렬 및 하단 여백 */
            padding: 1.5rem;
            background-color: var(--white-color);
            border-radius: 0.75rem; /* 카드 둥근 모서리 */
            border: 1px solid #e9ecef;
            box-shadow: var(--shadow-sm);
        }

        .status-form { /* [수정] 폼 정렬 */
            display: flex;
            flex-wrap: wrap; /* 작은 화면에서 줄바꿈 */
            justify-content: center; /* 폼 내부 요소 가운데 정렬 */
            align-items: center;
            gap: 0.75rem; /* 요소간 간격 */
        }
        
        .status-form input[type="text"],
        .status-form select { /* [수정] 입력창/선택창 스타일 */
            padding: 10px 12px; /* 크기 키우기 */
            font-size: 15px;
            border: 1px solid var(--border-color);
            border-radius: 8px; /* 둥근 모서리 */
            flex: 1; /* 너비 자동 조절 */
            min-width: 180px; /* 최소 너비 */
        }
        
        .status-form select {
            flex-grow: 0; /* select는 많이 늘어나지 않게 */
            min-width: 150px;
        }

        .status-form .btn-primary { /* 검색 버튼 */
            flex-grow: 0; /* 버튼은 고정 크기 */
            padding: 10px 20px; /* 입력창과 높이 맞춤 */
        }
        
        .status-form input[type="text"] { /* (기존) z-index 문제 해결 */
            position: relative;
            z-index: 10;
            pointer-events: auto !important;
        }
        
    /* Table Wrapper */
        .table-wrapper {
            background-color: #fff;
            padding: 1.5rem;
            border-radius: 0.75rem;
            border: 1px solid #e9ecef;
            box-sizing: border-box;
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
        }
        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }
        .table-header h4 {
            font-weight: 700;
            margin: 0;
        }
        .table-filters {
            display: flex;
            gap: 0.75rem;
            margin-bottom: 1rem;
        }
        .table-filters input, .table-filters select {
            padding: 0.5rem 0.75rem;
            border: 1px solid #ced4da;
            border-radius: 0.375rem;
            font-size: 0.9rem;
        }
        .table-filters input { flex: 2; }
        .table-filters select { flex: 1; }

      /* Table */
    .result-table {
        width: 100%;
        border-collapse: collapse;
        text-align: left;
    }
    .result-table th, .result-table td {
        padding: 1rem;
        vertical-align: middle;
        border-bottom: 1px solid #dee2e6;
    }
    .result-table th {
        background-color: #f8f9fa;
        font-weight: 700;
        color: #495057;
    }
    .result-table tbody tr:hover {
    	background-color: #f1f3f5;
    }
    /*
    .term-list {
        list-style-type: none;
        padding: 0;
        margin: 0;
        text-align: left;
    }
    .term-list li {
        font-size: 0.9em;
        border-bottom: 1px dashed #eee;
        padding: 4px 0;
    }
    .term-list li:last-child {
        border-bottom: none;
    } */

    /* 페이징 네비게이션 스타일 */
	.pagination {
	    display: flex;
	    justify-content: center;
	    align-items: center;
	    margin-top: 2rem;
	    gap: 0.5rem;
	}
	
	.pagination a,
	.pagination span,
	.pagination strong {
	    display: flex;
	    align-items: center;
	    justify-content: center;
	    width: 38px;
	    height: 38px;
	    border: 1px solid var(--border-color);
	    border-radius: 8px;
	    background-color: var(--white-color);
	    color: var(--dark-gray-color);
	    font-weight: 500;
	    transition: all 0.2s ease-in-out;
	}
	
	.pagination a:hover {
	    background-color: var(--primary-light-color);
	    border-color: var(--primary-color);
	    color: var(--primary-color);
	}
	
	.pagination .active {
	    background-color: var(--primary-color);
	    border-color: var(--primary-color);
	    color: var(--white-color);
	    cursor: default;
	}
	
	.pagination .disabled {
	    color: #ced4da;
	    background-color: #f8f9fa;
	    pointer-events: none;
	}
		
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>

<body>
<%@ include file="adminheader.jsp" %>
<h2>동일 영아 조회</h2>

<div class="search-wrapper">
    <form id="statusForm" class="status-form" method="post"
			action="${pageContext.request.contextPath}/admin/childsearch">
		
		<input type="text" name="nameKeyword" placeholder="자녀 이름" value="${nameKeyword}" maxlength="50"/>
	  	
		<input type="text" name="regNoKeyword" placeholder="주민등록번호(숫자13자리)" value="${regNoKeyword}" maxlength="13"/>
		
		<label for="status" class="sr-only">상태 선택</label>
		<select id="status" name="status" class="status-select">
			<option value="ALL" ${status=='ALL' ? 'selected' : ''}>전체</option>
			<option value="ST_20" ${status=='ST_20' ? 'selected' : ''}>제출</option>
			<option value="ST_30" ${status=='ST_30' ? 'selected' : ''}>심사중</option>
			<option value="ST_40" ${status=='ST_40' ? 'selected' : ''}>2차심사중</option> 
			<option value="ST_50" ${status=='ST_50' ? 'selected' : ''}>승인</option> 
		</select> 
		
		<input type="hidden" name="page" id="pageInput" value="${pageDTO.pageNum}">
        <input type="hidden" name="size" value="${pageDTO.listSize}">
        	
		<button type="submit" class="btn btn-primary btn-sm">검색</button> 
	</form>
</div>

<div class="table-wrapper">
    <table class="result-table">
        <thead>
            <tr>
                <th>신청서번호</th>
                <th>자녀이름</th>
                <th>자녀주민번호</th> <th>신청인</th>
                <th>신청상태</th>
                <th>육아휴직 기간</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${empty childList}">
                    <tr>
                        <td colspan="7">조회된 신청서가 없습니다.</td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="child" items="${childList}">
                        <tr>
                            <td>${child.applicationNumber}</td>
                            <td>${child.childName}</td>
                            <td>${child.childResiRegiNumber}</td> <td>${child.name}</td>
                            <td>${child.statusName}</td>
                            <td>
                            	<fmt:formatDate value="${child.startDate}" pattern="yyyy-MM-dd" />
                            ~	<fmt:formatDate value="${child.endDate}" pattern="yyyy-MM-dd" />
                            </td>
                            
                            <%-- <td>
                                <c:if test="${not empty child.list}">
                                    <ul class="term-list">
                                        <c:forEach var="term" items="${child.list}">
                                            <li>
                                                <fmt:formatDate value="${term.startMonthDate}" pattern="yyyy.MM.dd" />
                                                ~
                                                <fmt:formatDate value="${term.endMonthDate}" pattern="yyyy.MM.dd" />
                                                (${term.govPayment+term.companyPayment}원)
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </c:if>
                                <c:if test="${empty child.list}">
                                    (단위 기간 정보 없음)
                                </c:if>
                            </td> --%>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
    
</div>

<div class="pagination">
	    <c:choose>
	        <c:when test="${pageDTO.pageNum > 1}">
	            <a href="#" class="btn btn-primary btn-sm page-link" data-page="${pageDTO.pageNum - 1}">&lt;</a>
	        </c:when>
	        <c:otherwise>
	            <span class="btn btn-secondary btn-sm disabled">&lt;</span>
	        </c:otherwise>
	    </c:choose>
	
	    <c:forEach var="pNum" begin="${pageDTO.paginationStart}" end="${pageDTO.paginationEnd}">
	        <c:choose>
	            <c:when test="${pNum == pageDTO.pageNum}">
	                <strong class="btn btn-primary btn-sm active">${pNum}</strong>
	            </c:when>
	            <c:otherwise>
	                <a href="#" class="btn btn-outline-primary btn-sm page-link" data-page="${pNum}">${pNum}</a>
	            </c:otherwise>
	        </c:choose>
	    </c:forEach>
	
	    <c:choose>
	        <c:when test="${pageDTO.pageNum < pageDTO.endPage}">
	            <a href="#" class="btn btn-primary btn-sm page-link" data-page="${pageDTO.pageNum + 1}">&gt;</a>
	        </c:when>
	        <c:otherwise>
	            <span class="btn btn-secondary btn-sm disabled">&gt;</span>
	        </c:otherwise>
	    </c:choose>
	</div>

<script>
$(document).ready(function() {
    $('#statusForm').on('submit', function() {

        if (!$(this).data('page-clicked')) {
            $('#pageInput').val(1); 
        }
        $(this).removeData('page-clicked'); 
    });

    $('.pagination').on('click', '.page-link', function(e) {
        e.preventDefault(); // <a> 태그의 기본 동작(GET) 방지
        
        var pageNum = $(this).data('page'); // 클릭한 페이지 번호
        
        $('#pageInput').val(pageNum); // hidden input에 페이지 번호 설정
        $('#statusForm').data('page-clicked', true); // 플래그 설정
        $('#statusForm').submit(); // 폼을 (POST로) 전송
    });
});
</script>
</body>
</html>