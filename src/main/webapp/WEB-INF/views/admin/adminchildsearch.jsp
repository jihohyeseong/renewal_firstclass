<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>동일 영아 조회</title>
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

    /* ==== 페이지네이션 (디자인 개선) ==== */
	.pagination {
	  display: flex;
	  justify-content: center;
	  gap: .5rem;
	  margin-top: 2rem;
	}
	.pagination a,
	.pagination span {
	  display: flex;
	  align-items: center;
	  justify-content: center;
	  width: 38px;
	  height: 38px;
	  border: 1px solid var(--border-color);
	  border-radius: 999px; /* 원형 버튼 */
	  background: var(--white-color);
	  color: var(--text-muted);
	  text-decoration: none;
	  font-size: .9rem;
	  font-weight: 500;
	  transition: all .15s ease;
	}
	.pagination a:hover {
	  background: var(--primary-light-color);
	  border-color: var(--primary-light-color);
	  color: var(--primary-color);
	}
	.pagination .active {
	  background: var(--primary-color);
	  border-color: var(--primary-color);
	  color: var(--white-color);
	  font-weight: 600;
	  cursor: default;
	}
	.pagination .active:hover {
	  background: var(--primary-color);
	  border-color: var(--primary-color);
	  color: var(--white-color);
	}
	.pagination .disabled {
	  background: var(--bg-light);
	  color: #ced4da;
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
		<input type="hidden" name="page" id="pageInput" value="${pageDTO.pageNum}">
        <input type="hidden" name="size" value="${pageDTO.listSize}">
		
		<input type="text" name="nameKeyword" placeholder="자녀 이름" value="${nameKeyword}" maxlength="50"/>
	  	
		<input type="text" name="regNoKeyword" placeholder="주민등록번호(숫자13자리)" value="${regNoKeyword}" maxlength="13"/>
		
		<label for="status" class="sr-only">상태 선택</label>
		<select id="status" name="status" class="status-select">
			<option value="ALL" ${status=='ALL' ? 'selected' : ''}>전체</option>
			<option value="ST_20" ${status=='ST_20' ? 'selected' : ''}>제출</option>
			<option value="ST_30" ${status=='ST_30' ? 'selected' : ''}>심사중</option>
			<option value="ST_50" ${status=='ST_50' ? 'selected' : ''}>승인</option> 
		</select> 
        	
		<button type="submit" class="btn btn-primary btn-sm">검색</button> 
	</form>
</div>

<div class="table-wrapper">
    <table class="result-table">
        <thead>
            <tr>
                <th>확인서번호</th>
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
                            <td>${child.confirmNumber}</td>
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
	    <!-- 이전 버튼 (항상 활성화) -->
    				<a class="js-page-link prev" data-page="${pageDTO.pageNum - 1}" style="cursor: pointer;">&laquo;</a>
				
				    <c:forEach begin="${pageDTO.paginationStart}" end="${pageDTO.paginationEnd}" var="p">
				        <c:choose>
				            <c:when test="${p == pageDTO.pageNum}">
				                <span class="active">${p}</span> </c:when>
				            <c:otherwise>
				                <a class="js-page-link" data-page="${p}" style="cursor: pointer;">${p}</a>
				            </c:otherwise>
				        </c:choose>
				    </c:forEach>
				
				    <!-- 다음 버튼 (항상 활성화) -->
    				<a class="js-page-link next" data-page="${pageDTO.pageNum + 1}" style="cursor: pointer;">&raquo;</a>
	</div>

<script>
$(document).ready(function() {
    
    // 페이지 링크가 클릭되었는지 확인하기 위한 플래그
    let pageLinkClicked = false;

    /**
     * 1. "페이지 링크"(.js-page-link) 클릭 시
     */
    $('.js-page-link').on('click', function(e) {
        e.preventDefault(); // a 태그의 기본 동작(링크 이동)을 막습니다.

        // 클릭한 링크의 data-page 값을 가져옵니다.
        const newPage = $(this).data('page');

        // 폼 내부의 hidden input (pageNum) 값을 새 페이지로 변경합니다.
        $('#pageInput').val(newPage);
        
        // [중요] 페이지 링크가 클릭되었다고 플래그를 설정합니다.
        pageLinkClicked = true;
        
        // 폼을 수동으로 전송합니다.
        $('#statusForm').submit();
    });
    
    /**
     * 2. "폼이 전송될 때" (검색 버튼을 누르거나, 페이지 링크로 submit()이 호출될 때)
     */
    $('#statusForm').on('submit', function() {
        
        // 페이지 링크로 인해 전송된 것이라면, 플래그가 true입니다.
        if (pageLinkClicked) {
            // 플래그를 리셋하고, pageNum을 1로 덮어쓰지 않고 그대로 전송합니다.
            pageLinkClicked = false;
        } else {
            // 페이지 링크가 아닌 '검색' 버튼으로 전송된 것이므로, pageNum을 1로 리셋합니다.
            $('#pageInput').val(1);
        }
        
        // 폼 전송을 계속 진행합니다.
    });

});
</script>
</body>
</html>