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
        
        /* ==== 레이아웃 ==== */
		.main-content {
		  max-width: 1200px;
		  margin: 0 auto;
		  padding: 2rem;
		}
		
		.page-title {
		  font-size: 1.75rem;
		  font-weight: 700;
		  margin-bottom: 1.5rem;
		}
        
		/* 레이블 + 인풋 묶음 */
		.filter-group {
		  display: inline-flex;
		  align-items: center;
		  gap: .5rem;
		  white-space: nowrap;
		}

		.filter-label {
		  font-size: .9rem;
		  font-weight: 500;
		  color: var(--text-muted);
		}
		
		/* 테이블 */ 
        .status-form { 
              display: flex;
			  flex-wrap: wrap;
			  gap: .75rem;
			  margin-bottom: 1.5rem;
			  justify-content: space-between;
        }
        
        .status-form input[type="text"],
        .status-form select { /* [수정] 입력창/선택창 스타일 */
            padding: .5rem .75rem;
		  border: 1px solid var(--border-color);
		  border-radius: .375rem;
		  background: #fdfdfd;
		  height: 40px;
		  box-sizing: border-box;
		  font-size: .9rem;
		  transition: border-color .15s ease, box-shadow .15s ease;
        }
        
        .status-form input[type="text"]:focus,
		.status-form select:focus {
		  outline: none;
		  border-color: var(--primary-color);
		  box-shadow: 0 0 0 3px var(--primary-light-color);
		}
        
        /* ==== 필터 버튼 (디자인 개선) ==== */
		.status-form button {
		  display: inline-flex;
		  align-items: center;
		  justify-content: center;
		  padding: 0 .75rem;
		  height: 40px;
		  min-width: 40px;
		  border: 1px solid var(--border-color);
		  border-radius: .375rem;
		  background: var(--white-color);
		  color: #555;
		  cursor: pointer;
		  font-size: .9rem;
		  font-weight: 500;
		  transition: background-color .15s ease, border-color .15s ease, color .15s ease;
		}
        .status-form button:hover {
		  background-color: #f8f9fa;
		}
		
		#btnSearch {
		  background: var(--primary-color);
		  border-color: var(--primary-color);
		  color: var(--white-color);
		  padding: 0 1.25rem;
		}
		
		#btnSearch:hover {
		  background: #334abf;
		  border-color: #334abf;
		  color: var(--white-color);
		}
		
    /* ==== 테이블 래퍼 (디자인 개선) ==== */
	.table-wrapper {
	  background: var(--white-color);
	  border: none;
	  border-radius: .75rem;
	  padding: 1.5rem 2rem;
	  box-shadow: var(--shadow-sm);
	}
	
	.table-header {
	  display: flex;
	  justify-content: space-between;
	  align-items: center;
	  margin-bottom: 1.5rem;
	}
	
	.table-header h4 {
	  margin: 0;
	  font-size: 1.25rem;
	  font-weight: 700;
	}

      /* Table */
    table.result-table {
        width: 100%;
        border-collapse: collapse;
        text-align: left;
    }
    table.result-table th, .result-table td {
        padding: .8rem .9rem;
	  border-bottom: 1px solid var(--border-light);
	  vertical-align: middle;
	  font-size: 1rem;
	  text-align: center;
    }
    table.result-table th:last-child,
	table.result-table td:last-child {
	  padding-right: .5rem;
	  padding-left: .5rem;
	}
	
	table.result-table thead th {
	  background: var(--white-color);
	  font-weight: 600;
	  color: #888;
	  font-size: .8rem;
	  text-transform: uppercase;
	  letter-spacing: .5px;
	  border-bottom: 2px solid #e9ecef;
	  border-top: 1px solid #e9ecef;
	}
	
	table.result-table tbody tr:hover {
	  background-color: #fcfdff; /* 매우 연한 호버 효과 */
	}
	
	table.result-table tbody td {
	  color: var(--text-color);
	}

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
	/* 왼쪽 필터 묶음 */
	.filter-left {
	  display: flex;
	  flex-wrap: wrap;
	  align-items: center;
	  gap: .5rem;
	}
	
	/* 오른쪽 필터 묶음 */
	.filter-right {
	  display: flex;
	  flex-wrap: wrap;
	  align-items: center;
	  gap: .5rem;
	}	
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>

<body>
<div class="content-container">
<%@ include file="adminheader.jsp" %>
<main class="main-content">
<h2 class="page-title">동일 영아 조회</h2>

<div class="table-wrapper">

    <form id="statusForm" class="status-form" method="post"
			action="${pageContext.request.contextPath}/admin/childsearch">
		<input type="hidden" name="page" id="pageInput" value="${pageDTO.pageNum}">
        <input type="hidden" name="size" value="${pageDTO.listSize}">
        
		<div class="filter-left">
		<div class="filter-group">
			<span class="filter-label">이름 검색 </span>
			<input type="text" name="nameKeyword" placeholder="자녀 이름 입력" value="${nameKeyword}" maxlength="50"/>
	  	</div>
	
		<div class="filter-group">
			<span class="filter-label">주민등록번호 검색</span>
			<input type="text" name="regNoKeyword" placeholder="자녀 주민등록번호 입력" value="${regNoKeyword}" maxlength="13"/>
		</div>
		</div>
		
		<div class="filter-group">
		<label for="status" class="filter-label">상태 선택</label>
		<select id="status" name="status" class="status-select">
			<option value="ALL" ${status=='ALL' ? 'selected' : ''}>전체</option>
			<option value="ST_20" ${status=='ST_20' ? 'selected' : ''}>제출</option>
			<option value="ST_30" ${status=='ST_30' ? 'selected' : ''}>심사중</option>
			<option value="ST_50" ${status=='ST_50' ? 'selected' : ''}>승인</option> 
		</select> 
        	
		<button type="submit" id="btnSearch" class="table-btn">조회</button> 
		</div>
	</form>

    <table class="result-table">
    <colgroup>
	    <col style="width:16%;">
	    <col style="width:18%;">
	    <col style="width:18%;">
	    <col style="width:18%;">
	    <col style="width:14%;">
	    <col style="width:16%;">
	  </colgroup>
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
</main>
</div>
<script>
$(document).ready(function() {
    
    // 페이지 링크가 클릭되었는지 확인하기 위한 플래그
    let pageLinkClicked = false;

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