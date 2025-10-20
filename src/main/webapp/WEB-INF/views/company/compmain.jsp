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
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/comp.css">
<style>
/* 표 전반: 패딩/행간 줄이기 */
.list-table {
  width: 100%;
  border-collapse: collapse;
  table-layout: fixed;            /* 셀 폭 균등 배분 */
}
.list-table thead th {
  padding: 10px 12px;             /* ↓ 기존보다 작게 */
  font-weight: 700;
}
.list-table tbody td {
  padding: 8px 12px;              /* ↓ 행 높이 줄임 */
  line-height: 1.2;               /* ↓ 텍스트 행간 */
  vertical-align: middle;
  border-bottom: 1px solid #eee;
}

/* 상태 배지: 컴팩트 */
.status-badge {
  display: inline-block;
  font-size: 12px;
  padding: 2px 8px;               /* ↓ */
  border-radius: 999px;
  line-height: 1;                 /* ↓ */
}

/* 테이블 내부 버튼을 초소형으로 오버라이드 */
.list-table .btn {
  display: inline-flex;           /* 인라인 배치 */
  align-items: center;
  justify-content: center;
  padding: 4px 10px;              /* ↓ 버튼 키움 ↓ 줄임 */
  font-size: 13px;                /* ↓ */
  line-height: 1;                 /* ↓ */
  border-radius: 10px;            /* 살짝 둥글게 */
  margin: 0;                      /* ★ 전역 .btn margin 제거 */
  height: 28px;                   /* 균일 높이 */
}

/* “작업” 셀 오른쪽 정렬 + 버튼 단일행 유지 */
.list-table td.actions {
  text-align: right;
  white-space: nowrap;            /* 버튼 줄바꿈 방지 */
}

/* 행 hover 색 살짝만 */
.list-table tbody tr:hover { background: #fafbff; }

/* 여백 전반 축소 */
.content-header { margin-bottom: 10px; } /* 섹션 헤더 아래 여백 줄임 */
.content-wrapper { padding-top: 8px; }   /* 필요시 */


</style>
</head>
<body>

<%@ include file="compheader.jsp" %>

<main class="main-container"> 

  <div class="notice-box content-wrapper">
    <div class="title">
      <i class="fa-solid fa-volume-high"></i>
      <span>안내</span>
    </div>
    <ul>
      <li><strong>육아휴직급여:</strong> [모의계산하기]버튼을 클릭하면 예상 지급액을 확인할 수 있습니다.</li>
      <li><strong>신청기간:</strong> 휴직개시일 1개월 이후부터 휴직종료일 이후 1년 이내 신청 가능합니다.</li>
      <li><strong>승인기간:</strong> 신청서 제출완료 후 심시완료까지는 평균적으로 2-5일 소요됩니다. </li>
    </ul>
  </div>

  <div class="content-wrapper">
    <div class="content-header">
      <h2><sec:authentication property="principal.username" /> 님의 신청 내역</h2>
      <a href="${pageContext.request.contextPath}/comp/apply" class="btn btn-primary">새로 신청하기</a>
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
          <thead>
            <tr>
              <th style="width: 18%;">신청번호</th>
              <th style="width: 20%;">신청일</th>
              <th style="width: 20%;">신청자 이름</th>
              <th style="width: 18%;">상태</th>
              <th style="width: 140px;">작업</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="app" items="${confirmList}">
              <tr>
                <td>${app.confirmNumber}</td>
                <td>${not empty app.applyDt ? app.applyDt : '-'}</td>
                <td>${app.name}</td>
                <td>
                  <!-- 상태 배지 -->
                  <c:set var="st" value="${app.statusName}" />
                  <span class="status-badge status-${st}">${st}</span>
                </td>
	
                <td class="actions">
                  <a href="${pageContext.request.contextPath}/comp/detail?confirmNumber=${app.confirmNumber}" class="btn btn-secondary">
                   	 상세보기</a>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
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
</body>
</html>
