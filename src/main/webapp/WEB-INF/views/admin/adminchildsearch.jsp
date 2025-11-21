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
        .status-form select { 
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

      /* 테이블 */
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

    <form id="statusForm" class="status-form">
		<input type="hidden" name="page" id="pageInput" value="${pageDTO.pageNum}">
        <input type="hidden" name="size" value="${pageDTO.listSize}">
        
		<div class="filter-left">
		<div class="filter-group">
			<span class="filter-label">자녀이름  </span>
			<input type="text" name="nameKeyword" placeholder="자녀 이름 입력" value="${nameKeyword}" maxlength="50"/>
	  	</div>
	
		<div class="filter-group">
			<span class="filter-label">자녀주민등록번호</span>
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
	    <col style="width:14%;">
	    <col style="width:14%;">
	    <col style="width:18%;">
	    <col style="width:18%;">
	    <col style="width:12%;">
	    <col style="width:24%;">
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
        <tbody id="searchResultBody">
		    <tr>
		        <td colspan="6">검색 조건을 입력하고 조회 버튼을 눌러주세요.</td>
		    </tr>
		</tbody>
    </table>
    
</div>

<div class="pagination" id="paginationArea">
    </div>
</main>
</div>
<script>
$(document).ready(function() {
    loadData(1);
    
    $('#statusForm').on('submit', function(e) {
        e.preventDefault(); 
        $('#pageInput').val(1); 
        loadData(1); 
    });

    $(document).on('click', '.js-page-link', function(e) {
        e.preventDefault();
        const page = $(this).data('page');
        loadData(page); 
    });

    function loadData(page) {
        const formData = {
            page: page,
            size: 10,
            status: $('#status').val(),
            nameKeyword: $('input[name="nameKeyword"]').val(),
            regNoKeyword: $('input[name="regNoKeyword"]').val()
        };

        $.ajax({
            url: '${pageContext.request.contextPath}/admin/childsearch',
            type: 'POST',
            data: formData,
            dataType: 'json', 
            success: function(response) {
                renderTable(response.childList);
                renderPagination(response.pageDTO);
            },
            error: function(xhr, status, error) {
                console.error(error);
                alert('데이터 조회 중 오류가 발생했습니다.');
            }
        });
    }

    function renderTable(list) {
        const $tbody = $('#searchResultBody');
        $tbody.empty(); 

        if (!list || list.length === 0) {
            $tbody.html('<tr><td colspan="6">조회된 신청서가 없습니다.</td></tr>');
            return;
        }

        let html = '';
        $.each(list, function(index, item) {
        	const childName = item.childName || '';
            const childResiRegiNumber = item.childResiRegiNumber || '';
            // 날짜 포맷팅 
            const startDate = formatDate(item.startDate);
            const endDate = formatDate(item.endDate);

            html += '<tr>';
            html += '<td>' + item.confirmNumber + '</td>';
            html += '<td>' + childName + '</td>';
            html += '<td>' + childResiRegiNumber + '</td>'; // 복호화된 주민번호
            html += '<td>' + item.name + '</td>';
            html += '<td>' + item.statusName + '</td>';
            html += '<td>' + startDate + ' ~ ' + endDate + '</td>';
            html += '</tr>';
        });
        $tbody.html(html);
    }

    function renderPagination(pageDTO) {
        const $area = $('#paginationArea');
        $area.empty();

        let html = '';

        html += '<a class="js-page-link prev" data-page="' + (pageDTO.pageNum - 1) + '" style="cursor: pointer;">&laquo;</a>';

        for (let p = pageDTO.paginationStart; p <= pageDTO.paginationEnd; p++) {
            if (p === pageDTO.pageNum) {
                html += '<span class="active">' + p + '</span>';
            } else {
                html += '<a class="js-page-link" data-page="' + p + '" style="cursor: pointer;">' + p + '</a>';
            }
        }

        html += '<a class="js-page-link next" data-page="' + (pageDTO.pageNum + 1) + '" style="cursor: pointer;">&raquo;</a>';

        $area.html(html);
    }

    // 날짜 변환 헬퍼 함수
    function formatDate(timestamp) {
        if(!timestamp) return "";
        const date = new Date(timestamp);
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return year + "-" + month + "-" + day;
    }
});
</script>
</body>
</html>