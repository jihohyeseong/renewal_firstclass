<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- JSTL 태그 --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 신청 목록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
   <style>
/* ==== 기본 및 변수 ==== */
:root {
  --primary-color: #3f58d4;
  --primary-light-color: #f0f2ff;
  --white-color: #fff;
  --border-color: #dee2e6;
  --success-color: #28a745;
  --danger-color: #dc3545;
  --text-color: #343a40;
  --text-muted: #6c757d;
  --bg-light: #f8f9fa;
  --border-light: #f0f2f5;
  --shadow-sm: 0 4px 12px rgba(0, 0, 0, .05);
  --shadow-md: 0 6px 18px rgba(0, 0, 0, .06);
}

* { margin: 0; padding: 0; box-sizing: border-box; }
html { height: 100%; }
body {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  font-family: 'Noto Sans KR', sans-serif;
  background-color: var(--bg-light);
  color: var(--text-color);
}
a { text-decoration: none; color: inherit; }

/* ==== 레이아웃 ==== */
.content-container {
  margin-left: 0px; /* 사이드바 고려 (현재 0) */
  width: 100%;
}
.main-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
}

/* ==== 페이지 타이틀 ==== */
.page-title {
  font-size: 1.75rem;
  font-weight: 700;
  margin-bottom: 1.5rem;
}

/* ==== 처리상태 카드 (디자인 교체) ==== */
.stat-cards-container {
  display: grid;
  grid-template-columns: repeat(4, 1fr); /* 4개 카드 */
  gap: 1rem;
  margin-bottom: 2rem;
}
.stat-card {
  background: var(--white-color);
  border: 1px solid #e9ecef;
  border-radius: .75rem;
  padding: 1.25rem 1.25rem 1rem;
  transition: transform .15s ease, box-shadow .2s ease;
  cursor: pointer;
}
.stat-card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-md);
}
.stat-card.active {
  outline: 2px solid var(--primary-color);
  box-shadow: var(--shadow-md);
  transform: translateY(-2px);
  border-left: none; /* 기존 스타일 제거 */
}
.stat-card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.stat-card h6 { /* stat-title */
  font-size: .9rem;
  font-weight: 700;
  color: var(--text-muted);
}
.stat-card h1 { /* stat-num */
  font-size: 2.2rem;
  font-weight: 800;
  color: var(--primary-color);
  line-height: 1.2;
  margin: .35rem 0 .15rem;
}
.stat-card small { /* stat-desc */
  font-size: .85rem;
  color: var(--text-muted);
}
.stat-card .bi {
  font-size: 1.4rem;
  color: #adb5bd;
}

/* ==== 테이블 래퍼 (디자인 개선) ==== */
.table-wrapper {
  background: var(--white-color);
  border: none;
  border-radius: .75rem;
  padding: 1.5rem 2rem;
  box-shadow: var(--shadow-sm);
  max-width: 1200px; /* main-content와 동일하게 */
  margin: 0 auto;
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
.btn-refresh {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 38px;
  height: 38px;
  border: 1px solid var(--border-color);
  background: var(--white-color);
  font-size: 1.2rem;
  cursor: pointer;
  border-radius: .375rem;
  color: var(--text-muted);
  transition: all .15s ease;
}
.btn-refresh:hover {
  background-color: var(--bg-light);
  color: var(--primary-color);
}

/* ==== 필터 (디자인 개선) ==== */
.table-filters {
  display: flex;
  flex-wrap: wrap;
  gap: .75rem;
  margin-bottom: 1.5rem;
}
.table-filters input[type="text"],
.table-filters select {
  padding: .5rem .75rem;
  border: 1px solid var(--border-color);
  border-radius: .375rem;
  background: #fdfdfd;
  height: 40px;
  box-sizing: border-box;
  font-size: .9rem;
  transition: border-color .15s ease, box-shadow .15s ease;
}
.table-filters input[type="text"]:focus,
.table-filters select:focus {
  outline: none;
  border-color: var(--primary-color);
  box-shadow: 0 0 0 3px var(--primary-light-color);
}
.table-filters select {
  flex: 1;
}

/* 검색창 */
.search-box {
  position: relative;
  flex: 2; /* 기존 스타일 유지 */
  min-width: 250px;
}
.search-box input {
  width: 100%;
  padding-right: 2.5rem !important; /* 아이콘 버튼 공간 */
}
.search-box button { /* 검색창 내부 버튼 */
  position: absolute;
  right: 10px;
  top: 50%;
  transform: translateY(-50%);
  color: #999;
  background: none;
  border: none;
  cursor: pointer;
  padding: 0;
  font-size: 1.1rem;
}
.search-box .bi-search { /* 혹시 i태그일 경우 대비 */
  position: absolute;
  right: 12px;
  top: 50%;
  transform: translateY(-50%);
  color: #999;
}

/* ==== 테이블 (디자인 개선) ==== */
.data-table {
  width: 100%;
  border-collapse: collapse;
  border-spacing: 0;
  text-align: left; /* 기본 정렬 */
}
.data-table th,
.data-table td {
  padding: .9rem 1rem;
  border-bottom: 1px solid var(--border-light); /* 더 연한 보더 */
  vertical-align: middle;
  font-size: .9rem;
}
.data-table thead th {
  background: var(--white-color);
  font-weight: 600;
  color: #888;
  font-size: .8rem;
  text-transform: uppercase;
  letter-spacing: .5px;
  border-bottom: 2px solid #e9ecef;
  border-top: 1px solid #e9ecef;
}
.data-table tbody tr:hover {
  background-color: #fcfdff; /* 매우 연한 호버 효과 */
}
.data-table tbody td {
  color: var(--text-color);
}

/* 빈 데이터 메시지 */
.data-table tbody td[colspan] {
  text-align: center;
  color: var(--text-muted);
  padding: 3rem 1rem;
  font-size: .95rem;
}

/* 테이블 헤더 내 날짜 버튼 */
.data-table th button {
  border: none;
  background: none;
  cursor: pointer;
  padding: 0;
  vertical-align: middle;
  font-size: 1.1rem;
  color: var(--text-muted);
  transition: color .15s ease;
}
.data-table th button:hover {
  color: var(--primary-color);
  opacity: 1;
  transform: none;
}
.data-table th span {
  font-size: 0.85em;
  color: #666;
  font-weight: 500;
}


/* ==== 재사용 컴포넌트 ==== */
.badge {
  display: inline-block;
  padding: .35em .65em;
  border-radius: 999px;
  color: var(--white-color);
  font-size: .8rem;
  font-weight: 600;
}
.badge-wait { background-color: var(--primary-color); }
.badge-approved { background-color: var(--success-color); }
.badge-rejected { background-color: var(--text-muted); }

/* 상세보기 버튼 (테이블 내부) */
.table-btn {
  display: inline-block;
  padding: .25rem .75rem;
  border-radius: 999px;
  background: var(--primary-light-color);
  color: var(--primary-color);
  text-decoration: none;
  font-size: .8rem;
  font-weight: 600;
  transition: all .15s ease;
  border: 1px solid transparent; /* 크기 유지 */
}
.table-btn:hover {
  background: var(--primary-color);
  color: var(--white-color);
  transform: translateY(-1px);
}
.table-btn.btn-secondary { /* 기존 클래스 호환 */
  background: #f1f3f5;
  color: #555;
  border-color: #f1f3f5;
}
.table-btn.btn-secondary:hover {
  background: #e9ecef;
  color: #333;
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
</style>
</head>
<body>

    <div class="content-container">
    <%@ include file="adminheader.jsp" %>

        <main class="main-content">
            <h2 class="page-title">급여 최종 결재 목록</h2>

            <div class="stat-cards-container">
                <a href="${pageContext.request.contextPath}/admin/superior">
	                <div class="stat-card ${empty status ? 'active' : ''}">
	                    <div class="stat-card-header">
	                        <div>
	                            <h6>총 신청서 수</h6><h1>${counts.total}</h1><small>모든 육아휴직 신청서</small>
	                        </div>
	                        <i class="bi bi-files"></i>
	                    </div>
	                </div>
                </a>

                <a href="${pageContext.request.contextPath}/admin/superior?status=PENDING">
	                <div class="stat-card ${status == 'PENDING' ? 'active' : ''}">
	                    <div class="stat-card-header">
	                        <div>
	                            <h6>대기 중 신청서</h6><h1>${counts.pending}</h1><small>현재 검토가 필요한 신청서</small>
	                        </div>
	                        <i class="bi bi-clock-history"></i>
	                    </div>
	                </div>
	            </a>

                <a href="${pageContext.request.contextPath}/admin/superior?status=APPROVED">
	                <div class="stat-card ${status == 'APPROVED' ? 'active' : ''}">
	                    <div class="stat-card-header">
	                        <div>
	                            <h6>승인된 신청서</h6><h1>${counts.approved}</h1><small>성공적으로 승인된 신청서</small>
	                        </div>
	                        <i class="bi bi-check-circle"></i>
	                    </div>
	                </div>
                </a>
                
                <a href="${pageContext.request.contextPath}/admin/superior?status=REJECTED">
	                <div class="stat-card ${status == 'REJECTED' ? 'active' : ''}">
	                    <div class="stat-card-header">
	                        <div>
	                            <h6>반려된 신청서</h6><h1>${counts.rejected}</h1><small>문제가 있어 반려된 신청서</small>
	                        </div>
	                        <i class="bi bi-x-circle"></i>
	                    </div>
	                </div>
                </a>
            </div>

            <div class="table-wrapper">
                <div class="table-header">
                    <h4>모든 육아휴직 신청서</h4>
                    <!-- <button class="table-btn btn-refresh" id="btnReset"><i class="bi bi-arrow-clockwise"></i></button> -->
                </div>

                <form id="searchForm" action="${pageContext.request.contextPath}/admin/superior" method="get" class="table-filters">
                    
                    <div class="search-box">
                        <input type="text" name="keyword" placeholder="신청자 이름 또는 신청번호로 검색..." value="${keyword}">
                        <button type="submit" style="background:none; border:none; position:absolute; right:10px; top:50%; transform:translateY(-50%); cursor:pointer;">
                            <i class="bi bi-search"></i>
                        </button>
                    </div>
                    <%-- 처리 상태 필터 --%>
                    <select name="status" id="statusSelect" onchange="this.form.submit()">
                        <option value="">모든 상태</option>
                        <option value="PENDING" ${status == 'PENDING' ? 'selected' : ''}>대기</option>
    					<option value="APPROVED" ${status == 'APPROVED' ? 'selected' : ''}>승인</option>
    					<option value="REJECTED" ${status == 'REJECTED' ? 'selected' : ''}>반려</option>
                    </select>
                    <%-- 날짜 필터 - hidden input으로 값 전달 --%>
    				<c:if test="${not empty date}">
        				<input type="hidden" name="date" value="${date}">
    				</c:if>
                    
                </form>

                <table class="data-table">
                    <thead>
                        <tr>
                            <th>신청서 번호</th>
                            <th>신청자 이름</th>
                            <th>신청일
                            	<button type="button" id="selectDate" style="background:none; border:none; cursor:pointer; margin-left:5px;">
                                    <i class="bi bi-calendar-week"></i>
                                </button>
                                <c:if test="${not empty date}">
                                    <span style="font-size:0.85em; color:#666;">(${date})</span>
                                </c:if>
                            </th>
                            <th>상태</th>
                            <th>검토</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty applicationList}">
                                <c:forEach var="app" items="${applicationList}">
                                    <tr>
                                        <td>${app.applicationNumber}</td>
                                        <td>${app.applicantName}</td>
                                        <td>${app.submittedDate}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${app.statusName == '대기'}">
                                                    <span class="badge badge-wait">${app.statusName}</span>
                                                </c:when>
                                                <c:when test="${app.paymentResult == 'Y'}">
                                                    <span class="badge badge-approved">승인</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-rejected">반려</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/admin/superior/detail/?appNo=${app.applicationNumber}" class="table-btn btn-secondary">상세보기</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5" style="text-align: center;">조회된 신청 내역이 없습니다.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
                <div class="pagination">
				    <c:choose><c:when test="${pageDTO.startPage > 1}">
				        <a href="${pageContext.request.contextPath}/admin/superior?page=${pageDTO.startPage - 1}&keyword=${keyword}&status=${status}&date=${date}">&laquo;</a>
				    </c:when><c:otherwise>
				        <span class="disabled">&laquo;</span>
				    </c:otherwise></c:choose>
				
				    <c:forEach begin="${pageDTO.paginationStart}" end="${pageDTO.paginationEnd}" var="p">
				        <a href="${pageContext.request.contextPath}/admin/superior?page=${p}&keyword=${keyword}&status=${status}&date=${date}" 
				           class="${p == pageDTO.pageNum ? 'active' : ''}">
				            ${p}
				        </a>
				    </c:forEach>
				
				    <c:choose><c:when test="${pageDTO.endPage > pageDTO.paginationEnd}">
				        <a href="${pageContext.request.contextPath}/admin/superior?page=${pageDTO.paginationEnd + 1}&keyword=${keyword}&status=${status}&date=${date}">&raquo;</a>
				    </c:when><c:otherwise>
				        <span class="disabled">&raquo;</span>
				    </c:otherwise></c:choose>
				</div>
            </div>
        </main>
    </div> 
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script>
	document.addEventListener("DOMContentLoaded", () => { 
	    const select = document.getElementById("statusSelect");
	    const current = "${status}"; 
	    const dateBtn = document.getElementById('selectDate');
	    const form = document.getElementById("searchForm");
	    
	    if (current) select.value = current; 

	 	// flatpickr 달력 초기화
	    const fp = flatpickr(dateBtn, {
	        dateFormat: "Y-m-d",
	        defaultDate: "${date}" || null, // 선택된 날짜가 있으면 표시
	        position: "below",
	        onChange: function(selectedDates, dateStr) {
	            if (dateStr) {
	                // hidden input이 없으면 생성
	                let hiddenDate = form.querySelector('input[name="date"]');
	                if (!hiddenDate) {
	                    hiddenDate = document.createElement('input');
	                    hiddenDate.type = 'hidden';
	                    hiddenDate.name = 'date';
	                    form.appendChild(hiddenDate);
	                }
	                hiddenDate.value = dateStr;
	                form.submit();
	            }
	        },
	        allowInput: false
	    });
	 // 달력 버튼 클릭 시 달력 열기
	    dateBtn.addEventListener("click", (e) => {
	        e.preventDefault();
	        e.stopPropagation(); 
	        fp.open();
	    });
	    
		document.getElementById('btnReset').addEventListener("click", () => {
			
			// 입력 초기화
		    form.querySelector('input[name="keyword"]').value = '';
		    form.querySelector('select[name="status"]').value = '';
		 	
		    // date hidden input 제거
	        const hiddenDate = form.querySelector('input[name="date"]');
	        if (hiddenDate) {
	            hiddenDate.remove();
	        }
	        
	        // 달력 초기화
	        fp.clear();
	        
		    // 전체 목록으로 다시 요청
		    form.submit();
			
		});
    });
	
</script>

<script src="my_script.js"></script>
</body>
</html>