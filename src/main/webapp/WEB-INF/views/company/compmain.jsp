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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/comp.css">
<style>
    /* --- 테마 색상 및 기본 스타일 --- */
    :root {
        --primary-color: #24A960;
        --primary-color-dark: #1e8a4e;
        --primary-color-light: #f0fdf6; /* 아주 연한 녹색 */
        
        --status-approved: #24A960; /* 승인 (메인 녹색) */
        --status-pending: #f59e0b;  /* 대기 (황색) */
        --status-rejected: #ef4444; /* 반려 (적색) */
        
        --text-color: #333;
        --text-color-light: #555;
        --border-color: #e0e0e0;
        --bg-color-soft: #f9fafb; /* 연한 회색 배경 */
        --white: #ffffff;
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
    .content-header-right {
 	 display:flex; align-items:center; gap:8px; /* 필터와 버튼 간격 */
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
    table-layout: fixed;          /* 고정 레이아웃 유지 */
    font-size: 15px;
	}
	
	.list-table th, .list-table td {
	    padding: 14px 16px;           /* 헤더/바디 패딩 동일 */
	    box-sizing: border-box;       /* 패딩 포함해서 폭 계산 -> 오차 방지 */
	    vertical-align: middle;
	}
	
	.list-table thead th {
	    font-weight: 600;
	    background-color: var(--primary-color);
	    color: var(--white);
	    text-align: left;
	    border-bottom: 2px solid var(--primary-color-dark);
	}
	
	/* 정렬만 다르게 */
	.list-table thead th:nth-child(4),
	.list-table td:nth-child(4) {     /* 상태 */
	    text-align: center;
	}
	.list-table thead th:nth-child(5),
	.list-table td:nth-child(5) {     /* 작업 */
	    text-align: right;
	    white-space: nowrap;
	}
    .list-table tbody tr:hover { 
        background: var(--primary-color-light); /* 연한 녹색 호버 */
    }

    /* --- 상태 배지 --- */
    .status-badge {
        display: inline-flex;
        align-items:center;
  		justify-content:center;
  		box-sizing:border-box;
        font-size: 12px;
        font-weight: 600;
        padding:6px 12px;
        border-radius: 999px;
        line-height: 1;
        text-align: center;
        width: 8.5em; 
    }
    
	.status-badge.status-ST_10{
	    background-color: #f3f4f6;
	    color: #4b5563;
	}

	.status-badge.status-ST_20 {
	    background-color: #c6c6cc;
	    color: #4b5563;
	}
	.status-badge.status-ST_30 { /* 심사중 */
	    background-color: #fcf5d8 !important; 
	    color: #b45309 !important;
	}
	.status-badge.status-ST_50 { /* 승인완료 */
	    background-color: #d2f8de !important;
	    color: var(--primary-color-dark) !important;
	}
	.status-badge.status-ST_60 { /* 반려 */
	    background-color: #ffebeb !important; 
	    color: #b91c1c !important;
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
    
    /* 페이징처리용 */ 
.pagination-wrap{
  display:flex;
  justify-content:center;   /* 가운데로 */
  align-items:center;
  margin-top:18px;
}
.pagination{ list-style:none; display:flex; gap:6px; padding:0; margin:0; }
.page-item .page-link{
  display:inline-flex; align-items:center; justify-content:center;
  min-width:38px; height:36px; padding:0 10px; border-radius:8px;
  border:1px solid var(--border-color); text-decoration:none;
  font-size:14px; color:#374151; background:#fff;
  transition:.15s ease;
}
.page-item .page-link:hover{ filter:brightness(0.98); }
.page-item.active .page-link{
  background:var(--primary-color); color:#fff; border-color:var(--primary-color);
}
.page-item.disabled .page-link{
  pointer-events:none; opacity:.5;
}
.pagination-meta{ display:flex; align-items:center; gap:12px; font-size:13px; color:#6b7280; }
.page-size-form{ display:inline-flex; align-items:center; gap:6px; }
.page-size-form select{ height:32px; border:1px solid var(--border-color); border-radius:8px; padding:0 8px; }

.status-select{
  height: 40px;
  padding: 0 14px;
  font-size: 15px;
  line-height: 40px;
  min-width: 200px;
  border: 1.5px solid var(--border-color);
  border-radius: 10px;
  background: #fff;
  outline: none;
}

/* --- 검색 필터 (추가/수정) --- */
/* --- 검색 필터 (수정) --- */
    .filters-row {
        display: flex;
		justify-content: center; /* ★ 중앙 정렬 ★ */
        align-items: center;
        margin-top: 0; /* 헤더와 이미 분리됨. 0 또는 16px */
        margin-bottom: 24px;
        padding: 20px; /* ★ 시각적 그룹화를 위한 패딩 */
        border-radius: 10px; /* ★ 둥근 모서리 */
    }

    /* 폼 자체의 불필요한 마진 제거 */
    .filters-row .status-form,
    .filters-row .keyword-form {
        margin: 0;
    }

    .keyword-form {
        display: flex;
        align-items: center;
        gap: 16px;
    }

.keyword-form .form-group {
  display: flex;
  align-items: center;
  gap: 8px; /* 라벨과 인풋 사이의 간격 */
}

.keyword-form .form-group label {
  font-size: 15px;
  font-weight: 500;
  color: var(--text-color-light);
  white-space: nowrap; /* '주민번호' 줄바꿈 방지 */
}

/* 기존 .input-text 스타일 오버라이드 (깔끔하게) */
.keyword-form .input-text {
  height: 40px;
  padding: 0 14px;
  font-size: 15px;
  border-radius: 10px;
  border: 1.5px solid var(--border-color);
  background-color: #fff;
  transition: border-color 0.2s, box-shadow 0.2s;
}
.keyword-form .input-text:focus {
  border-color: var(--primary-color);
  box-shadow: 0 0 0 2px var(--primary-color-light);
  outline: none;
}

/* 인풋박스 너비 고정 (필요에 따라 조절) */
.keyword-form #nameKeywordInput { width: 140px; }
.keyword-form #regNoDisplay { width: 160px; }

/* 검색 버튼 높이 맞춤 */
.keyword-form .btn {
  height: 40px;
}
</style>
</head>
<body>

<%@ include file="compheader.jsp" %>

<main class="main-container"> 

    <div class="notice-box"> <div class="title">
            <i class="fa-solid fa-volume-high"></i>
            <span>안내</span>
        </div>
        <ul>
            <li><strong>육아휴직급여:</strong> [모의계산하기]버튼을 클릭하면 예상 지급액을 확인할 수 있습니다.</li>
            <li><strong>신청기간:</strong> 휴직개시일 1개월 이후부터 휴직종료일 이후 1년 이내 신청 가능합니다.</li>
            <li><strong>승인기간:</strong> 신청서 제출완료 후 평균적으로 1-2일 이내에 접수됩니다. </li>
        </ul>
    </div>

	<div class="content-wrapper">
<div class="content-header">
  <h2>${userDTO.name}님의신청 내역</h2>

  <div class="content-header-right">
    <!-- 상태 전용 폼: 상태 변경 시 즉시 제출 -->
    <form id="statusForm" class="status-form" method="post"
          action="${pageContext.request.contextPath}/comp/searchStatus">
      <label for="status" class="sr-only">상태 선택</label>
      <select id="status" name="status" onchange="this.form.submit()" class="status-select">
        <option value="ALL" ${status=='ALL'  ? 'selected' : ''}>전체</option>
        <option value="ST_10" ${status=='ST_10' ? 'selected' : ''}>등록(임시저장)</option>
        <option value="ST_20" ${status=='ST_20' ? 'selected' : ''}>제출</option>
        <option value="ST_30" ${status=='ST_30' ? 'selected' : ''}>심사중</option>
        <option value="ST_50" ${status=='ST_50' ? 'selected' : ''}>승인완료</option>
        <option value="ST_60" ${status=='ST_60' ? 'selected' : ''}>반려처리</option>
      </select>
      <input type="hidden" name="page" value="1" />
      <input type="hidden" name="size" value="${size}" />
    </form>

    <a href="${pageContext.request.contextPath}/comp/apply" class="btn btn-primary">새로 신청하기</a>
  </div>
</div>

		<c:choose>
			<c:when test="${empty confirmList}">
				<div class="empty-state-box">
					<h3>아직 신청 내역이 없으시네요.</h3>
					<p>소중한 자녀를 위한 첫걸음, 지금 바로 시작해보세요.</p>
				</div>
			</c:when>
			<c:otherwise>
				<table class="list-table">
					<colgroup>
						<col style="width: 18%;">
						<col style="width: 20%;">
						<col style="width: 20%;">
						<col style="width: 18%;">
						<col style="width: 24%;">
					</colgroup>
					<thead>
						<tr>
							<th>신청번호</th>
							<th>신청일</th>
							<th>신청자 이름</th>
							<th>상태</th>
							<th>상세보기</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="app" items="${confirmList}">
							<tr>
								<td>${app.confirmNumber}</td>
								<td>${not empty app.applyDt ? app.applyDt : '-'}</td>
								<td>${app.name}</td>

								<td class="status-cell"><c:set var="stCode"
										value="${app.statusCode}" /> <%-- 화면에 보여줄 텍스트 결정 --%> <c:set
										var="stName">
										<c:choose>
											<c:when test="${stCode == 'ST_10'}">등록(임시저장)</c:when>
											<c:when test="${stCode == 'ST_20'}">제출</c:when>
											<c:when test="${stCode == 'ST_30'}">심사중</c:when>
											<c:when test="${stCode == 'ST_50'}">승인완료</c:when>
											<c:when test="${stCode == 'ST_60'}">반려처리</c:when>
										</c:choose>
									</c:set> <span class="status-badge status-${stCode}">${stName}</span></td>

								<td class="actions"><a
									href="${pageContext.request.contextPath}/comp/detail?confirmNumber=${app.confirmNumber}"
									class="btn btn-secondary"> 상세보기</a></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>

				<c:url var="pageUrl" value="/comp/main" />

				<!-- 페이지 네비게이션 -->
				<c:if test="${totalPages > 1}">
					<nav class="pagination-wrap" aria-label="pagination">
						<ul class="pagination">

							<!-- 처음/이전 -->
							<li class="page-item ${page == 1 ? 'disabled' : ''}"><a
								class="page-link" href="${pageUrl}?page=1&size=${size}">«</a></li>
							<li class="page-item ${page == 1 ? 'disabled' : ''}"><a
								class="page-link" href="${pageUrl}?page=${page-1}&size=${size}">‹
									이전</a></li>

							<!-- 번호 -->
							<c:forEach var="p" begin="1" end="${totalPages}">
								<li class="page-item ${p == page ? 'active' : ''}"><a
									class="page-link" href="${pageUrl}?page=${p}&size=${size}">${p}</a>
								</li>
							</c:forEach>

							<!-- 다음/마지막 -->
							<li class="page-item ${page == totalPages ? 'disabled' : ''}">
								<a class="page-link"
								href="${pageUrl}?page=${page+1}&size=${size}">다음 ›</a>
							</li>
							<li class="page-item ${page == totalPages ? 'disabled' : ''}">
								<a class="page-link"
								href="${pageUrl}?page=${totalPages}&size=${size}">»</a>
							</li>

						</ul>
					</nav>
				</c:if>

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

<script>
(function () {
	  const raw  = document.getElementById('regNoRaw');      // hidden (name="regNoKeyword")
	  const disp = document.getElementById('regNoDisplay');  // 표시용
	  const form = document.getElementById('statusForm');
	  if (!raw || !disp || !form) return;

	  // ★ 이름 입력
	  const nameInput = form.querySelector('input[name="nameKeyword"]');

	  const onlyDigits = s => String(s||'').replace(/\D/g,'').slice(0,13);
	  const fmt = d => d.length<=6 ? d : d.slice(0,6)+'-'+d.slice(6);

	  disp.value = raw.value ? fmt(onlyDigits(raw.value)) : '';

	  disp.addEventListener('input', () => {
	    const d = onlyDigits(disp.value);
	    disp.value = fmt(d);
	    raw.value  = d;
	  });

	  disp.addEventListener('paste', e => {
	    e.preventDefault();
	    const d = onlyDigits((e.clipboardData||window.clipboardData).getData('text')||'');
	    disp.value = fmt(d); raw.value = d;
	  });

	  form.addEventListener('submit', () => {
	    // 주민등록번호 hidden
	    const d = onlyDigits(disp.value);
	    if (d.length === 0) {
	      raw.disabled = true;     // 전송 제외
	    } else {
	      raw.disabled = false;
	      raw.value = d;
	    }

	    // ★ 이름 입력 비어있으면 전송 제외
	    if (nameInput && !nameInput.value.trim()) {
	      nameInput.disabled = true;
	    }
	  });
	})();



</script>

</body>
</html>