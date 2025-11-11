<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>근로자 조회 - 육아휴직 서비스</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">

  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

  <!-- 공통 CSS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/global.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/comp.css">

  <style>
    :root {
      --primary-color: #24A960;
      --primary-color-dark: #1e8a4e;
      --primary-color-light: #f0fdf6;
      --text-color:#111;
      --text-color-light:#6b7280;
      --border-color:#e0e0e0;
      --white:#ffffff;
    }
    body{ font-family:'Noto Sans KR',sans-serif; background:#f7f7f9; }

    .main-container { max-width:1100px; margin:20px auto; padding:0 20px; }
    .content-wrapper { background:#fff; border-radius:12px; padding:24px 30px; box-shadow:0 4px 12px rgba(0,0,0,.05); margin-bottom:20px; }

    /* 안내 박스 */
    .notice-box { background:var(--primary-color-light); border:1px solid var(--primary-color); border-left-width:5px; border-radius:8px; padding:20px; }
    .notice-box .title { display:flex; align-items:center; font-size:18px; font-weight:700; color:var(--primary-color-dark); margin-bottom:12px; }
    .notice-box .title .fa-solid{ margin-right:10px; font-size:20px; }
    .notice-box ul{ margin:0; padding-left:20px; color:var(--text-color-light); font-size:14px; }
    .notice-box li{ margin-bottom:6px; }
    .notice-box li:last-child{ margin-bottom:0; }

    /* 검색 필터 */
    .filters-row{
      display:flex; justify-content:center; align-items:center; gap:16px;
      margin:0; padding:12px 0 0; border-radius:10px;
    }
    .filters-row .form-group{ display:flex; align-items:center; gap:8px; }
    .filters-row label{ font-size:15px; font-weight:500; color:var(--text-color-light); white-space:nowrap; }
    .input-text, .select{
      height:40px; padding:0 14px; font-size:15px; border-radius:10px;
      border:1.5px solid var(--border-color); background:#fff; outline:none; transition:border-color .2s, box-shadow .2s;
    }
    .input-text:focus, .select:focus{ border-color:var(--primary-color); box-shadow:0 0 0 2px var(--primary-color-light); }
    #nameKeyword{ width:160px; }
    #regNoDisplay{ width:170px; }

    .btn{ display:inline-flex; align-items:center; justify-content:center; padding:10px 18px; font-size:15px; font-weight:500; line-height:1.5; border:1px solid transparent; border-radius:8px; text-decoration:none; cursor:pointer; transition:.2s; white-space:nowrap; }
    .btn-primary{ background:var(--primary-color); color:#fff; }
    .btn-primary:hover{ background:var(--primary-color-dark); }
    .btn-secondary{ background:#e9ecef; color:#495057; border-color:#dee2e6; }
    .btn-secondary:hover{ background:#d1d5db; }
    .btn-ghost{ background:#fff; color:#374151; border:1px solid var(--border-color); }
    .btn-ghost:hover{ background:#fafafa; }

    /* 리스트 테이블 */
    .list-table{ width:100%; border-collapse:collapse; table-layout:fixed; font-size:15px; }
    .list-table th, .list-table td{ padding:14px 16px; box-sizing:border-box; vertical-align:middle; }
    .list-table thead th{
      font-weight:600; background:var(--primary-color); color:#fff; text-align:left; border-bottom:2px solid var(--primary-color-dark);
    }
    .list-table thead th:nth-child(4), .list-table td:nth-child(4){ text-align:center; } /* 상태 */
    .list-table thead th:nth-child(5), .list-table td:nth-child(5){ text-align:right; white-space:nowrap; } /* 작업 */
    .list-table tbody tr:hover{ background:var(--primary-color-light); }

    /* 상태 배지 */
    .status-badge{ display:inline-flex; align-items:center; justify-content:center; box-sizing:border-box; font-size:12px; font-weight:600; padding:6px 12px; border-radius:999px; line-height:1; text-align:center; width:8.5em; }
    .status-badge.status-ST_10{ background:#f3f4f6; color:#4b5563; }
    .status-badge.status-ST_20{ background:#c6c6cc; color:#4b5563; }
    .status-badge.status-ST_30{ background:#fcf5d8!important; color:#b45309!important; }
    .status-badge.status-ST_50{ background:#d2f8de!important; color:var(--primary-color-dark)!important; }
    .status-badge.status-ST_60{ background:#ffebeb!important; color:#b91c1c!important; }

    /* 빈 상태 */
    .empty-state-box{ text-align:center; padding:60px 40px; background:#fcfcfc; border-radius:10px; border:1px dashed var(--border-color); }
    .empty-state-box::before{
      font-family:"Font Awesome 6 Free"; font-weight:900; content:"\f115"; font-size:40px; color:var(--primary-color);
      display:block; margin-bottom:20px; opacity:.6;
    }
    .empty-state-box h3{ font-size:22px; color:#111; margin:0 0 12px; }
    .empty-state-box p{ font-size:16px; color:var(--text-color-light); margin:0; }

    /* 페이징 */
/* 페이징처리용 */ 
.pagination-wrap{
  display:flex;
  justify-content:center;   /* 가운데로 */
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
  </style>
</head>
<body>

<%@ include file="compheader.jsp" %>

<main class="main-container">

  <!-- 안내 -->
  <div class="notice-box" style="margin-bottom:14px;">
    <div class="title">
      <i class="fa-solid fa-volume-high"></i><span>안내</span>
    </div>
    <ul>
      <li><strong>육아휴직급여:</strong> [모의계산하기] 버튼으로 예상액 확인 가능</li>
      <li><strong>신청기간:</strong> 휴직개시 1개월 이후 ~ 휴직종료 1년 이내 신청</li>
      <li><strong>승인기간:</strong> 제출 완료 후 평균 2–5일 내 심사</li>
    </ul>
  </div>

  <!-- 검색 카드 (제목/목록 버튼/구분선 제거) -->
  <div class="content-wrapper" style="padding-top:18px;">
    <form id="searchForm" method="post" action="${pageContext.request.contextPath}/comp/search">
      <input type="hidden" name="page" value="${empty page ? 1 : page}">
      <input type="hidden" name="size" value="${empty size ? 10 : size}">

      <div class="filters-row">
        <!-- 상태 -->
        <div class="form-group">
          <label for="status">상태</label>
          <select id="status" name="status" class="select">
            <option value="ALL"  ${status=='ALL'  ? 'selected' : ''}>전체</option>
            <option value="ST_10" ${status=='ST_10' ? 'selected' : ''}>등록(임시저장)</option>
            <option value="ST_20" ${status=='ST_20' ? 'selected' : ''}>제출</option>
            <option value="ST_30" ${status=='ST_30' ? 'selected' : ''}>심사중</option>
            <option value="ST_50" ${status=='ST_50' ? 'selected' : ''}>승인완료</option>
            <option value="ST_60" ${status=='ST_60' ? 'selected' : ''}>반려처리</option>
          </select>
        </div>

        <!-- 이름 -->
        <div class="form-group">
          <label for="nameKeyword">이름</label>
          <input type="text" id="nameKeyword" name="nameKeyword" value="${empty nameKeyword ? '' : nameKeyword}" maxlength="50" class="input-text" />
        </div>

        <!-- 주민등록번호 -->
        <div class="form-group">
          <label for="regNoDisplay">주민등록번호</label>
          <c:set var="regNoRaw" value="${empty regNoKeyword ? '' : regNoKeyword}" />
          <input type="hidden" name="regNoKeyword" id="regNoRaw" value="${regNoRaw}" />
          <input type="text" id="regNoDisplay" class="input-text" maxlength="14" />
        </div>

        <!-- 버튼 -->
        <div class="form-group" style="gap:6px;">
          <button type="button" id="btnClear" class="btn btn-ghost">초기화</button>
          <a href="${pageContext.request.contextPath}/comp/main" class="btn btn-secondary">취소</a>
          <button type="submit" class="btn btn-primary">검색</button>
        </div>
      </div>
    </form>
  </div>

  <!-- 결과 카드: 검색했을 때(searched=true)만 노출 -->
  <c:set var="searchedSafe" value="${empty searched ? false : searched}" />
  <c:if test="${searchedSafe}">
    <div class="content-wrapper">
      <c:choose>
        <c:when test="${empty confirmList}">
          <div class="empty-state-box">
            <h3>검색 결과가 없습니다.</h3>
            <p>조건을 넓히거나 다른 키워드로 다시 시도해 보세요.</p>
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
                  <td style="text-align:center;">
                    <c:set var="stCode" value="${app.statusCode}" />
                    <c:set var="stName">
                      <c:choose>
                        <c:when test="${stCode == 'ST_10'}">등록(임시저장)</c:when>
                        <c:when test="${stCode == 'ST_20'}">제출</c:when>
                        <c:when test="${stCode == 'ST_30'}">심사중</c:when>
                        <c:when test="${stCode == 'ST_50'}">승인완료</c:when>
                        <c:when test="${stCode == 'ST_60'}">반려처리</c:when>
                      </c:choose>
                    </c:set>
                    <span class="status-badge status-${stCode}">${stName}</span>
                  </td>
                  <td style="text-align:right;">
                    <a href="${pageContext.request.contextPath}/comp/detail?confirmNumber=${app.confirmNumber}" class="btn btn-secondary">상세보기</a>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>

          <!-- 페이징 -->
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
  </c:if>

</main>

<footer class="footer">
  <p>&copy; 2025 육아휴직 서비스. All Rights Reserved.</p>
</footer>

<script>
  function goPage(p){
    const f = document.getElementById('searchForm');
    f.querySelector('input[name="page"]').value = p;
    f.submit();
    return false;
  }

  // 주민번호 포맷 & 전송 값 관리
  (function(){
    const raw  = document.getElementById('regNoRaw');      // hidden (name="regNoKeyword")
    const disp = document.getElementById('regNoDisplay');  // 표시용
    const form = document.getElementById('searchForm');

    const onlyDigits = s => String(s||'').replace(/\D/g,'').slice(0,13);
    const fmt = d => d.length<=6 ? d : d.slice(0,6)+'-'+d.slice(6);

    if (disp) disp.value = raw && raw.value ? fmt(onlyDigits(raw.value)) : '';

    disp && disp.addEventListener('input', () => {
      const d = onlyDigits(disp.value);
      disp.value = fmt(d);
      if(raw) raw.value  = d;
    });

    disp && disp.addEventListener('paste', e => {
      e.preventDefault();
      const text = (e.clipboardData||window.clipboardData).getData('text') || '';
      const d = onlyDigits(text);
      disp.value = fmt(d);
      if(raw) raw.value  = d;
    });

    form && form.addEventListener('submit', () => {
      const d = onlyDigits(disp.value);
      if (raw) {
        if (d.length === 0) { raw.disabled = true; }
        else { raw.disabled = false; raw.value = d; }
      }

      const nameInput = document.getElementById('nameKeyword');
      if (nameInput && !nameInput.value.trim()) { nameInput.disabled = true; }

      form.querySelector('input[name="page"]').value = 1;
    });

    const clearBtn = document.getElementById('btnClear');
    clearBtn && clearBtn.addEventListener('click', () => {
      document.getElementById('status').value = 'ALL';
      const name = document.getElementById('nameKeyword');
      if(name) name.value = '';
      if(disp) disp.value = '';
      if(raw){ raw.value = ''; raw.disabled = true; }
    });
  })();
</script>

</body>
</html>
