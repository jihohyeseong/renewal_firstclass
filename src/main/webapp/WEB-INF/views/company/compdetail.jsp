<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>육아휴직 확인서 상세</title>

<!-- 네 전역(global) / 공통(초록 테마, 레이아웃, 버튼) CSS가 이미 들어가 있다고 가정 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/global.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/comp.css">

<style>
  /* ===== 표 전용(초록 테마와 조화) ===== */
  .page-title { font-size: 22px; font-weight: 800; margin: 0 0 18px; }

  .sheet-table {
    width: 100%;
    border-collapse: collapse;
    background: #fff;
    border: 1px solid var(--border-color);
    border-radius: 14px;
    overflow: hidden;          /* radius 유지 */
  }
  .sheet-table th, .sheet-table td {
    border: 1px solid var(--border-color);
    padding: 12px 14px;
    font-size: 14px;
    vertical-align: middle;
  }
  .sheet-head {
    background: var(--light-gray-color);
    color: var(--dark-gray-color);
    font-weight: 700;
    text-align: left;
  }
  .w160 { width: 160px; }
  .center { text-align: center; }
  .num { text-align: right; padding-right: 16px; }

  /* “월별 지급 내역” 안쪽 표 */
  .month-table { width: 100%; border-collapse: collapse; }
  .month-table th, .month-table td {
    border: 1px solid var(--border-color);
    padding: 10px 12px;
    font-size: 14px;
  }
  .month-table thead th {
    background: var(--light-gray-color);
    font-weight: 700;
    text-align: center;
  }

  /* 하단 버튼 영역 */
  .detail-actions { margin-top: 20px; display: flex; gap: 10px; justify-content: flex-end; }
</style>
</head>
<body>

<%@ include file="compheader.jsp" %>

<main class="main-container">
  <div class="content-wrapper">
    <div class="content-header" style="margin-bottom:24px;">
      <h2 class="page-title">육아휴직 확인서 상세</h2>
      <div></div>
    </div>

    <!-- 하나의 “카드” 안에 들어가는 표 -->
    <table class="sheet-table">
      <colgroup>
        <col class="w160"><col><col class="w160"><col>
      </colgroup>

      <!-- 접수 정보 -->
      <tr><th class="sheet-head" colspan="4">접수 정보</th></tr>
      <tr>
        <th>확인서 번호</th><td>${confirmDTO.confirmNumber}</td>
        <th>처리 상태</th><td>${confirmDTO.statusCode}</td>
      </tr>
      <tr>
        <th>제출일</th>
        <td colspan="3"><fmt:formatDate value="${confirmDTO.applyDt}" pattern="yyyy-MM-dd"/></td>
      </tr>

      <!-- 근로자 정보 -->
      <tr><th class="sheet-head" colspan="4">근로자 정보</th></tr>
      <tr>
        <th>성명</th><td>${confirmDTO.name}</td>
        <th>주민등록번호</th>
        <td>
          <c:set var="rrn" value="${fn:replace(confirmDTO.registrationNumber,'-','')}"/>
          ${fn:substring(rrn,0,6)}-${fn:substring(rrn,6,7)}******
        </td>
      </tr>
      <tr>
        <th>육아휴직 기간</th>
        <td colspan="3">
          <fmt:formatDate value="${confirmDTO.startDate}" pattern="yyyy.MM.dd"/> ~
          <fmt:formatDate value="${confirmDTO.endDate}" pattern="yyyy.MM.dd"/>
        </td>
      </tr>
      <tr>
        <th>주당 소정근로시간</th><td>${confirmDTO.weeklyHours} 시간</td>
        <th>통상임금(월)</th><td>₩ <fmt:formatNumber value="${confirmDTO.regularWage}" pattern="#,##0"/></td>
      </tr>

      <!-- 자녀 정보 -->
      <tr><th class="sheet-head" colspan="4">대상 자녀 정보</th></tr>
      <c:choose>
        <c:when test="${not empty confirmDTO.childName}">
          <tr>
            <th>자녀 이름</th><td>${confirmDTO.childName}</td>
            <th>출생일</th><td><fmt:formatDate value="${confirmDTO.childBirthDate}" pattern="yyyy.MM.dd"/></td>
          </tr>
          <tr>
            <th>주민등록번호</th>
            <td colspan="3">
              <c:set var="crrn" value="${confirmDTO.childResiRegiNumber}"/>
              ${fn:substring(crrn,0,6)}-${fn:substring(crrn,6,7)}******
            </td>
          </tr>
        </c:when>
        <c:otherwise>
          <tr><th>자녀 정보</th><td colspan="3">출산 예정</td></tr>
          <tr><th>출산 예정일</th><td colspan="3"><fmt:formatDate value="${confirmDTO.childBirthDate}" pattern="yyyy.MM.dd"/></td></tr>
        </c:otherwise>
      </c:choose>

      <!-- 월별 지급 내역 -->
      <tr><th class="sheet-head" colspan="4">월별 지급 내역</th></tr>
      <tr>
        <td colspan="4" style="padding:0;">
          <table class="month-table">
            <colgroup>
              <col style="width:90px"><col><col style="width:180px"><col style="width:180px">
            </colgroup>
            <thead>
              <tr>
                <th>회차</th>
                <th>기간</th>
                <th>사업장 지급액</th>
                <th>정부 지급예정액</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="term" items="${termList}" varStatus="st">
                <tr>
                  <td class="center">${st.count}개월차</td>
                  <td class="center">
                    <fmt:formatDate value="${term.startMonthDate}" pattern="yyyy.MM.dd"/> ~
                    <fmt:formatDate value="${term.endMonthDate}" pattern="yyyy.MM.dd"/>
                  </td>
                  <td class="num">₩ <fmt:formatNumber value="${term.companyPayment}" pattern="#,##0"/></td>
                  <td class="num">₩ <fmt:formatNumber value="${term.govPayment}" pattern="#,##0"/></td>
                </tr>
              </c:forEach>
              <c:if test="${empty termList}">
                <tr><td colspan="4" class="center" style="color:var(--gray-color);">입력된 지급 내역이 없습니다.</td></tr>
              </c:if>
            </tbody>
          </table>
        </td>
      </tr>
    </table>

    <div class="detail-actions">
      <a href="${pageContext.request.contextPath}/comp/main" class="btn btn-secondary">목록</a>
      <c:if test="${confirmDTO.statusCode == 'ST_10'||confirmDTO.statusCode == 'ST_30'}">
        <a href="${pageContext.request.contextPath}/comp/apply?confirmNumber=${confirmDTO.confirmNumber}" class="btn btn-secondary">내용 수정</a>
        <form method="post" action="${pageContext.request.contextPath}/comp/submit" style="display:inline;">
          <input type="hidden" name="confirmNumber" value="${confirmDTO.confirmNumber}" />
          <button type="submit" class="btn btn-primary"
            onclick="return confirm('제출 후에는 수정이 제한될 수 있습니다. 제출할까요?');">최종 제출</button>
        </form>
      </c:if>
    </div>
  </div>
</main>

<footer class="footer">
  <p>&copy; 2025 육아휴직 서비스. All Rights Reserved.</p>
</footer>
</body>
</html>
