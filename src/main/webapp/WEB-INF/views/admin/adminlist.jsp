<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>관리자 신청/확인서 목록</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
  <style>
  		.header-nav {
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            list-style: none;
            margin: 0;
            padding: 0;
		}
	
		.header-nav .nav-link {
            display: block;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            font-weight: 500;
            color: #495057;
            transition: all 0.3s ease-in-out;
		}
		.header-nav .nav-link:hover {
            color: #3f58d4;
            transform: translateY(-3px);
            box-shadow: 0 4px 10px rgba(63, 88, 212, 0.3);
		}
    /* ==== 기존 스타일 그대로 (필요한 부분만 축약) ==== */
    :root{--primary-color:#3f58d4;--primary-light-color:#f0f2ff;--white-color:#fff;--border-color:#dee2e6;--success-color:#28a745;--danger-color:#dc3545;}
    body{font-family:'Noto Sans KR',sans-serif;background:#f8f9fa;color:#343a40;}
    .main-content{max-width:1200px;margin:0 auto;padding:2rem;}
    .table-wrapper{background:#fff;border:1px solid #e9ecef;border-radius:.75rem;padding:1.5rem}
    .table-filters{display:flex;gap:.75rem;margin-bottom:1rem}
    .table-filters input,.table-filters select{padding:.5rem .75rem;border:1px solid #ced4da;border-radius:.375rem}
    .search-box{position:relative;width:360px}
    .search-box .bi-search{position:absolute;right:10px;top:50%;transform:translateY(-50%);color:#6c757d}
    table{width:100%;border-collapse:collapse}
    th,td{padding:1rem;border-bottom:1px solid #dee2e6}
    thead th{background:#f8f9fa;font-weight:700}
    .badge{display:inline-block;padding:.35em .65em;border-radius:999px;color:#fff;font-size:.8rem}
    .badge-wait{background:var(--primary-color)}
    .badge-approved{background:var(--success-color)}
    .badge-rejected{background:#6c757d}
    .doc-chip{display:inline-flex;align-items:center;gap:.4rem;padding:.25rem .55rem;border-radius:999px;border:1px solid var(--border-color);font-size:.75rem;background:#fff}
    .doc-chip i{font-size:1rem}
    .pagination{display:flex;justify-content:center;gap:.5rem;margin-top:1.25rem}
    .pagination a,.pagination span{display:flex;align-items:center;justify-content:center;width:38px;height:38px;border:1px solid var(--border-color);border-radius:8px;background:#fff}
    .pagination .active{background:var(--primary-color);border-color:var(--primary-color);color:#fff}
    .btn-refresh{border:none;background:none;font-size:1.2rem;cursor:pointer}
    /* ==== 요약 카드 ==== */
.stat-cards .stat-card{
  background:#fff;border:1px solid #e9ecef;border-radius:.75rem;padding:1.25rem 1.25rem 1rem;
  transition:transform .15s ease, box-shadow .2s ease; cursor:pointer;
}
.stat-cards .stat-card:hover{ transform:translateY(-4px); box-shadow:0 6px 18px rgba(0,0,0,.06); }
.stat-cards .stat-card.active{ outline:2px solid var(--primary-color); }
.stat-cards .stat-head{ display:flex; align-items:center; justify-content:space-between; }
.stat-cards .stat-title{ font-size:.9rem; font-weight:700; color:#6c757d; }
.stat-cards .bi{ font-size:1.4rem; color:#adb5bd; }
.stat-cards .stat-num{ font-size:2.2rem; font-weight:800; color:var(--primary-color); line-height:1.2; margin:.35rem 0 .15rem; }
.stat-cards .stat-desc{ font-size:.85rem; color:#6c757d; }
@media (max-width: 900px){
  .stat-cards{ grid-template-columns:repeat(2,1fr); }
}
  </style>
</head>
<body>
<div class="content-container">
  <%@ include file="adminheader.jsp" %>

  <main class="main-content">
    <h2 class="page-title">관리자 신청/확인서 목록</h2>
    
    <!-- [붙여넣기 위치] <div class="table-wrapper"> 위쪽, page-title 아래 -->
<div class="stat-cards" id="statCards" style="margin-bottom:22px; display:grid; grid-template-columns:repeat(6,1fr); gap:12px;">
  <div class="stat-card" data-status="" data-doc="">
    <div class="stat-head">
      <span class="stat-title">총 문서 수</span>
      <i class="bi bi-collection"></i>
    </div>
    <div class="stat-num" id="statTotal">-</div>
    <div class="stat-desc">신청서 + 확인서 전체</div>
  </div>

  <div class="stat-card" data-status="제출" data-doc="">
    <div class="stat-head">
      <span class="stat-title">제출</span>
      <i class="bi bi-clock-history"></i>
    </div>
    <div class="stat-num" id="statSubmit">-</div>
    <div class="stat-desc">현재 검토가 필요한 문서</div>
  </div>
  
    <div class="stat-card" data-status="심사중" data-doc="">
    <div class="stat-head">
      <span class="stat-title">심사중</span>
      <i class="bi bi-clock-history"></i>
    </div>
    <div class="stat-num" id="statReview1">-</div>
    <div class="stat-desc">현재 심사중인 문서</div>
  </div>
  
    <div class="stat-card" data-status="2차 심사중" data-doc="">
    <div class="stat-head">
      <span class="stat-title">2차 심사중</span>
      <i class="bi bi-clock-history"></i>
    </div>
    <div class="stat-num" id="statReview2">-</div>
    <div class="stat-desc">상위 관리자 승인이 필요한 문서</div>
  </div>

  <div class="stat-card" data-status="승인" data-doc="">
    <div class="stat-head">
      <span class="stat-title">승인됨</span>
      <i class="bi bi-check-circle"></i>
    </div>
    <div class="stat-num" id="statApproved">-</div>
    <div class="stat-desc">승인 완료 문서</div>
  </div>

  <div class="stat-card" data-status="반려" data-doc="">
    <div class="stat-head">
      <span class="stat-title">반려됨</span>
      <i class="bi bi-x-circle"></i>
    </div>
    <div class="stat-num" id="statRejected">-</div>
    <div class="stat-desc">반려된 문서</div>
  </div>
</div>
    

    <div class="table-wrapper">
      <div class="table-header" style="display:flex;justify-content:space-between;align-items:center;margin-bottom:1rem">
        <h4 style="margin:0">목록</h4>
        <button class="btn-refresh" id="btnReset" title="초기화"><i class="bi bi-arrow-clockwise"></i></button>
      </div>

      <!-- 필터 영역 -->
      <form id="filterForm" class="table-filters" onsubmit="return false;">
        <input type="hidden" name="centerId" id="centerId" value="${centerId}">
        <div class="search-box">
          <input type="text" name="keyword" id="keyword" placeholder="신청자 이름 / 신청서번호 / 확인서번호 검색">
          <i class="bi bi-search"></i>
        </div>

        <select name="docType" id="docType">
          <option value="">전체 문서</option>
          <option value="APPLICATION">신청서</option>
          <option value="CONFIRM">확인서</option>
        </select>

        <!-- 상태는 코드명 그대로(코드테이블 name) -->
        <select name="statusName" id="statusName">
          <option value="">전체 상태</option>
          <option value="제출">제출</option>
          <option value="심사중">심사중</option>
          <option value="2차 심사중">2차 심사중</option>
          <option value="승인">승인</option>
          <option value="반려">반려</option>
        </select>


        <!-- 날짜는 flatpickr 버튼식 -->
        <button type="button" id="btnDate" title="날짜 선택"><i class="bi bi-calendar-week"></i></button>
        <input type="hidden" name="date" id="date">
        <button type="button" id="btnSearch" class="table-btn">조회</button>
      </form>

      <!-- 데이터 테이블 -->
      <table class="data-table">
        <thead>
        <tr>
          <th>구분</th>
          <th>신청서번호</th>
          <th>신청자</th>
          <th>신청일</th>
          <th>상태</th>
          <th>검토</th>
        </tr>
        </thead>
        <tbody id="listBody">
        <tr><td colspan="6" style="text-align:center;color:#6c757d">데이터를 불러오는 중…</td></tr>
        </tbody>
      </table>

      <!-- 페이징 -->
      <div class="pagination" id="pagination"></div>
    </div>
  </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script>
  // ====== 설정 ======
  var PAGE_SIZE = 10;
  var CXT = '<c:out value="${pageContext.request.contextPath}"/>';
  var ENDPOINT = CXT + '/admin/list/fetch';
  console.log('[adminlist] ENDPOINT=', ENDPOINT);

  // ====== 상태 ======
  var state = { page: 1, total: 0 };

  // ====== 유틸 ======
  function qs(id){ return document.getElementById(id); }
  function toParams(obj){
    var p = new URLSearchParams();
    Object.keys(obj).forEach(function(k){
      if (obj[k] !== undefined && obj[k] !== null && obj[k] !== '') p.append(k, obj[k]);
    });
    return p.toString();
  }
  function formatDate(val){
    if (!val) return '';
    if (typeof val === 'number') {
      var d = new Date(val); return isNaN(d) ? '' : d.toISOString().slice(0,10);
    }
    if (typeof val === 'string') return val.length >= 10 ? val.slice(0,10) : val;
    try { return new Date(val).toISOString().slice(0,10); } catch(e){ return ''; }
  }
  function statusBadge(name){
    if (name === '승인') return '<span class="badge badge-approved">승인</span>';
    if (name === '반려') return '<span class="badge badge-rejected">반려</span>';
    return '<span class="badge badge-wait">' + (name || '') + '</span>';
  }
  function docChip(type){
    if (type === 'APPLICATION') return '<span class="doc-chip"><i class="bi bi-file-earmark-text"></i> 신청서</span>';
    if (type === 'CONFIRM')     return '<span class="doc-chip"><i class="bi bi-patch-check"></i> 확인서</span>';
    return '';
  }

  // ====== 서버 통신 ======
  async function fetchList(params){
    var url = ENDPOINT + '?' + toParams(params);
    console.log('[adminlist] request ->', url);
    var res = await fetch(url, { headers:{'Accept':'application/json'}, credentials:'same-origin' });
    if (!res.ok) {
      var text = ''; try { text = await res.text(); } catch(e){}
      throw new Error('HTTP ' + res.status + ': ' + text);
    }
    var data = await res.json();
    console.log('[adminlist] response <-', data);
    return data; // { list, totalCount }
  }

  function gatherParams(){
    var keyword    = qs('keyword').value.trim();
    var docType    = qs('docType').value || '';
    var statusName = qs('statusName').value || '';
    var date       = qs('date').value || '';
    var startList  = (state.page - 1) * PAGE_SIZE;
    return { keyword, docType, statusName, date, startList, listSize: PAGE_SIZE };
  }

  // ====== 렌더링 ======
  function renderRows(list){
    var tbody = qs('listBody');
    if (!list || list.length === 0){
      tbody.innerHTML = '<tr><td colspan="6" style="text-align:center;color:#6c757d">조회된 내역이 없습니다.</td></tr>';
      return;
    }
    tbody.innerHTML = list.map(function(row){
      var idVal = (row.docType === 'CONFIRM')
      ? (row.confirmNumber != null ? row.confirmNumber : '-')
      : (row.applicationNumber != null ? row.applicationNumber : '-');
      var nm    = row.name || '';
      var dt    = formatDate(row.applyDate);
      var st    = statusBadge(row.statusName);
      var chip  = docChip(row.docType);
      var detailHref = (row.docType === 'APPLICATION')
        ? (CXT + '/admin/user/detail/?appNo=' + row.applicationNumber)
        : (CXT + '/admin/judge/detail/' + row.confirmNumber);

      return '<tr>'
        + '<td>' + chip + '</td>'
        + '<td>' + idVal + '</td>'
        + '<td>' + nm   + '</td>'
        + '<td>' + dt   + '</td>'
        + '<td>' + st   + '</td>'
        + '<td><a href="' + detailHref + '" class="table-btn">상세보기</a></td>'
        + '</tr>';
    }).join('');
  }

  function renderPagination(total, page, size){
    var wrap = qs('pagination');
    var totalPages = Math.max(1, Math.ceil(total / size));
    var html = '';
    function btn(p, label, active, disabled){
      return '<a href="#" data-p="' + p + '"'
        + (active ? ' class="active"' : '')
        + (disabled ? ' style="pointer-events:none;opacity:.5"' : '')
        + '>' + label + '</a>';
    }
    html += btn(Math.max(1, page-1), '«', false, page===1);
    var span = 2, start = Math.max(1, page-span), end = Math.min(totalPages, page+span);
    for (var i=start; i<=end; i++){ html += btn(i, String(i), i===page, false); }
    html += btn(Math.min(totalPages, page+1), '»', false, page===totalPages);
    wrap.innerHTML = html;

    wrap.querySelectorAll('a[data-p]').forEach(function(a){
      a.addEventListener('click', function(e){
        e.preventDefault();
        var p = parseInt(this.getAttribute('data-p'), 10);
        if (!isNaN(p) && p !== state.page){ state.page = p; load().then(loadCardCounts); }
      });
    });
  }

  async function load(){
    var params = gatherParams();
    try{
      var data = await fetchList(params);
      renderRows(data.list || []);
      state.total = data.totalCount || 0;
      renderPagination(state.total, state.page, PAGE_SIZE);
    }catch(e){
      console.error(e);
      qs('listBody').innerHTML = '<tr><td colspan="6" style="text-align:center;color:#dc3545">목록을 불러오지 못했습니다.</td></tr>';
      qs('pagination').innerHTML = '';
    }
  }

  // ====== 카드 숫자 (요약 API 없이 /fetch 재활용) ======
  async function fetchCountWithStatus(baseParams, statusName){
    const p = Object.assign({}, baseParams, { startList: 0, listSize: 1 });
    p.statusName = statusName || ''; // 전체는 빈 문자열
    const data = await fetchList(p);
    return data.totalCount || 0;
  }

  async function loadCardCounts(){
    const base = gatherParams();
    delete base.startList; delete base.listSize;

    try{
      const [ total, submit, review1, review2, approved, rejected ] = await Promise.all([
        fetchCountWithStatus(base, ''),            // 총 문서
        fetchCountWithStatus(base, '제출'),        // 제출
        fetchCountWithStatus(base, '심사중'),      // 심사중
        fetchCountWithStatus(base, '2차 심사중'),  // 2차 심사중
        fetchCountWithStatus(base, '승인'),        // 승인
        fetchCountWithStatus(base, '반려')         // 반려
      ]);

      qs('statTotal').textContent    = total;
      qs('statSubmit').textContent   = submit;
      qs('statReview1').textContent  = review1;
      qs('statReview2').textContent  = review2;
      qs('statApproved').textContent = approved;
      qs('statRejected').textContent = rejected;
    }catch(e){
      console.error('[card-counts]', e);
      ['statTotal','statSubmit','statReview1','statReview2','statApproved','statRejected']
        .forEach(id => qs(id).textContent = '-');
    }
  }

  // ====== 바인딩 ======
  document.addEventListener('DOMContentLoaded', function(){
    var fp = flatpickr(qs('btnDate'), {
      dateFormat: 'Y-m-d',
      defaultDate: null,
      onChange: function(selected, dateStr){
        qs('date').value = dateStr || '';
        state.page = 1;
        load().then(loadCardCounts);
      }
    });

    qs('btnSearch').addEventListener('click', function(){
      state.page = 1; load().then(loadCardCounts);
    });
    qs('docType').addEventListener('change', function(){
      state.page = 1; load().then(loadCardCounts);
    });
    qs('statusName').addEventListener('change', function(){
      state.page = 1; load().then(loadCardCounts);
    });
    qs('keyword').addEventListener('keydown', function(e){
      if (e.key === 'Enter'){ e.preventDefault(); state.page = 1; load().then(loadCardCounts); }
    });
    qs('btnReset').addEventListener('click', function(){
      qs('keyword').value = '';
      qs('docType').value = '';
      qs('statusName').value = '';
      qs('date').value = '';
      fp.clear();
      state.page = 1;
      load().then(loadCardCounts);
    });

    // 카드 클릭 → 필터 반영 후 재조회
    (function wireSummaryCardClicks(){
      var cards = document.querySelectorAll('#statCards .stat-card');
      cards.forEach(function(card){
        card.addEventListener('click', function(){
          cards.forEach(function(c){ c.classList.remove('active'); });
          this.classList.add('active');

          var status = this.getAttribute('data-status'); // '', '제출', '심사중', '2차 심사중', '승인', '반려'
          var doc    = this.getAttribute('data-doc');    // '', 'APPLICATION', 'CONFIRM'(확장용)

          qs('statusName').value = status || '';
          if (qs('docType')) qs('docType').value = doc || '';

          state.page = 1;
          load().then(loadCardCounts);
        });
      });
    })();

    // 초기 로드
    load().then(loadCardCounts);
  });
</script>

</body>
</html>
