<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>육아휴직 확인서 상세</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/global.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/comp.css">

<style>
/* 베이스 */
*{margin:0;padding:0;box-sizing:border-box}
html{height:100%}
body{
  display:flex;flex-direction:column;min-height:100vh;
  font-family:'Noto Sans KR',sans-serif;background-color:var(--light-gray-color);
  color:var(--dark-gray-color);
}
a{text-decoration:none;color:inherit}

/* 컨테이너 */
.main-container{
	flex-grow:1;width:100%;max-width:1060px;
	margin:40px auto !important;
	padding:40px !important;
	background-color:var(--white-color);border-radius:12px;box-shadow:var(--shadow-md);
}
h1{text-align:center;margin-bottom:30px;font-size:28px}
h2{
  color:var(--primary-color);border-bottom:2px solid var(--primary-light-color);
  padding-bottom:10px;margin-bottom:25px;font-size:20px;
}
.section-title{
  font-size:20px;font-weight:700;color:var(--dark-gray-color);
  margin-bottom:15px;border-left:4px solid var(--primary-color);padding-left:10px;
}

/* 테이블 공통 */
.info-table-container{margin-bottom:40px}
.info-table{
  width:100%;border-collapse:collapse;border-top:2px solid var(--dark-gray-color);
}
.info-table th,.info-table td{
  padding:12px 15px;border:1px solid var(--border-color);
  text-align:left;font-size:15px;vertical-align:middle;
}
.info-table th{
  background-color:var(--light-gray-color);font-weight:500;width:150px;color:var(--dark-gray-color);
}
.info-table td{background-color:var(--white-color);color:#333}

/* 월별 내역 스크롤 래퍼 */
.data-grid-container{
  overflow-x:auto;-webkit-overflow-scrolling:touch;
  border:1px solid var(--border-color);border-radius:8px;margin-top:-15px;margin-bottom:25px;
}
.data-grid-container .info-table{border-top:none;margin-bottom:0}
.data-grid-container .info-table th,.data-grid-container .info-table td{
  white-space:nowrap;text-align:center;
}

/* 버튼 */
.btn{
  display:inline-block;padding:10px 20px;font-size:15px;font-weight:500;
  border-radius:8px;border:1px solid var(--border-color);cursor:pointer;
  transition:all .2s ease-in-out;text-align:center;
}
.btn:disabled,.btn.disabled{cursor:not-allowed;opacity:.65}
.btn-primary{background-color:var(--primary-color);color:#fff;border-color:var(--primary-color)}
.btn-primary:hover{background-color:#364ab1;box-shadow:var(--shadow-md);transform:translateY(-2px)}
.btn-secondary{background-color:var(--white-color);color:var(--gray-color);border-color:var(--border-color)}
.btn-secondary:hover{background-color:var(--light-gray-color);color:var(--dark-gray-color);border-color:#ccc}
.btn-danger{background-color:var(--danger-color);color:#fff;border-color:var(--danger-color)}
.btn-danger:hover{background-color:#c82333;border-color:#bd2130;transform:translateY(-2px);box-shadow:var(--shadow-md)}

.button-container{
  display:flex;justify-content:center;align-items:center;gap:15px;margin-top:50px;
}
.bottom-btn{padding:12px 30px;font-size:1.1em}
.detail-btn{
  border:1px solid var(--primary-color);color:var(--primary-color);
  background-color:var(--white-color);padding:3px 8px;font-size:14px;margin-left:10px;border-radius:4px;cursor:pointer;transition:background-color .1s;
}
.detail-btn:hover{background-color:var(--primary-light-color)}
.highlight-warning{background:#fff3cd;color:#856404;font-weight:700;padding:2px 6px;border-radius:4px}

.footer{ text-align:center; padding:20px 0; font-size:14px; color:var(--gray-color); }
</style>
</head>
<body>

<%@ include file="compheader.jsp" %>

<main class="main-container">
  <h1>육아휴직 확인서 상세</h1>

  <c:if test="${empty confirmDTO}">
    <p style="text-align:center; font-size:18px; color:var(--gray-color);">확인서 정보를 불러올 수 없습니다.</p>
  </c:if>

  <c:if test="${not empty confirmDTO}">
    <!-- 접수 정보 -->
    <div class="info-table-container">
      <h2 class="section-title">접수 정보</h2>
      <table class="info-table">
        <tbody>
          <tr>
            <th>확인서 번호</th><td>${confirmDTO.confirmNumber}</td>
            <th>처리 상태</th><td>${confirmDTO.statusName}</td>
          </tr>
          <tr>
            <th>제출일</th>
            <td colspan="3"><fmt:formatDate value="${confirmDTO.applyDt}" pattern="yyyy-MM-dd"/></td>
          </tr>

          <c:if test="${confirmDTO.statusCode == 'ST_60'}">
            <tr>
              <th>반려 사유</th>
              <td colspan="3">
                <div style="font-weight:600; font-size:1.05em; margin-bottom:6px;">
                  <c:out value="${confirmDTO.rejectReasonName}"/>
                </div>
                <c:if test="${not empty confirmDTO.rejectComment}">
                  <div style="color:#444;">상세사유: <c:out value="${confirmDTO.rejectComment}"/></div>
                </c:if>
              </td>
            </tr>
          </c:if>
        </tbody>
      </table>
    </div>

    <!-- 근로자 정보 -->
    <div class="info-table-container">
      <h2 class="section-title">근로자 정보</h2>
      <table class="info-table">
        <tbody>
          <tr>
            <th>성명</th><td>${confirmDTO.name}</td>
            <th>주민등록번호</th>
            <td>
              <c:if test="${not empty confirmDTO.registrationNumber}">
                <c:set var="rrnCleaned" value="${fn:replace(fn:replace(fn:trim(confirmDTO.registrationNumber), '-', ''), ' ', '')}" />
                ${fn:substring(rrnCleaned,0,6)}-${fn:substring(rrnCleaned,6,13)}
              </c:if>
            </td>
          </tr>
          <tr>
            <th>육아휴직 기간</th>
            <td colspan="3">
              <fmt:formatDate value="${confirmDTO.startDate}" pattern="yyyy.MM.dd"/>
              ~
              <fmt:formatDate value="${confirmDTO.endDate}" pattern="yyyy.MM.dd"/>
              <span id="leave-days" style="margin-left:8px; color:#555;"></span>
            </td>
          </tr>
          <tr>
            <th>주당 소정근로시간</th><td>${confirmDTO.weeklyHours} 시간</td>
            <th>통상임금(월)</th>
            <td>₩ <fmt:formatNumber value="${confirmDTO.regularWage}" pattern="#,##0"/></td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- 자녀 정보 -->
    <div class="info-table-container">
      <h2 class="section-title">대상 자녀 정보</h2>
      <table class="info-table">
        <tbody>
          <c:choose>
            <c:when test="${not empty confirmDTO.childName}">
              <tr>
                <th>자녀 이름</th><td>${confirmDTO.childName}</td>
                <th>출생일</th><td><fmt:formatDate value="${confirmDTO.childBirthDate}" pattern="yyyy.MM.dd"/></td>
              </tr>
              <tr>
                <th>주민등록번호</th>
                <td colspan="3">
                  <c:if test="${not empty confirmDTO.childResiRegiNumber}">
                    <c:set var="crrnClean" value="${fn:replace(fn:replace(fn:trim(confirmDTO.childResiRegiNumber), '-', ''), ' ', '')}" />
                    ${fn:substring(crrnClean,0,6)}-${fn:substring(crrnClean,6,13)}
                  </c:if>
                </td>
              </tr>
            </c:when>
            <c:otherwise>
              <tr><th>자녀 정보</th><td colspan="3">출산 예정</td></tr>
              <tr><th>출산 예정일</th><td colspan="3"><fmt:formatDate value="${confirmDTO.childBirthDate}" pattern="yyyy.MM.dd"/></td></tr>
            </c:otherwise>
          </c:choose>
        </tbody>
      </table>
    </div>

    <!-- 월별 지급 내역 -->
    <div class="info-table-container">
      <h2 class="section-title">월별 지급 내역</h2>
        <table class="info-table">
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
                <td>${st.count}개월차</td>
                <td>
                  <fmt:formatDate value="${term.startMonthDate}" pattern="yyyy.MM.dd"/>
                  ~
                  <fmt:formatDate value="${term.endMonthDate}" pattern="yyyy.MM.dd"/>
                </td>
                <td>₩ <fmt:formatNumber value="${term.companyPayment}" pattern="#,##0"/></td>
                <td>₩ <fmt:formatNumber value="${term.govPayment}" pattern="#,##0"/></td>
              </tr>
            </c:forEach>
            <c:if test="${empty termList}">
              <tr><td colspan="4" style="text-align:center; color:var(--gray-color);">입력된 지급 내역이 없습니다.</td></tr>
            </c:if>
          </tbody>
        </table>
    </div>

    <!-- 접수 처리 센터 -->
    <div class="info-table-container">
      <h2 class="section-title">접수 처리 센터 정보</h2>
      <table class="info-table">
        <tbody>
          <c:choose>
            <c:when test="${not empty confirmDTO.centerName or not empty confirmDTO.centerAddressBase or not empty confirmDTO.centerPhoneNumber}">
              <tr>
                <th>관할센터</th>
                <td>
                  <c:out value="${confirmDTO.centerName}"/>
                  <c:if test="${not empty confirmDTO.centerURL}">
                    <a href="${fn:escapeXml(confirmDTO.centerURL)}" target="_blank" rel="noopener" class="detail-btn">자세히 보기</a>
                  </c:if>
                </td>
                <th>대표전화</th>
                <td><c:out value="${confirmDTO.centerPhoneNumber}"/></td>
              </tr>
              <tr>
                <th>주소</th>
                <td colspan="3"><c:out value="${confirmDTO.centerAddressBase}"/></td>
              </tr>
            </c:when>
            <c:otherwise>
              <tr>
                <td colspan="4" style="text-align:center; color:var(--gray-color);">센터 정보가 없습니다.</td>
              </tr>
            </c:otherwise>
          </c:choose>
        </tbody>
      </table>
    </div>

    <!-- 첨부파일 -->
    <div class="info-table-container">
      <h2 class="section-title">첨부파일</h2>
      <c:choose>
        <c:when test="${not empty files}">
            <table class="info-table">

              <tbody>
                <c:forEach var="f" items="${files}">
                  <%-- 표시용 파일명 추출 --%>
                  <c:set var="parts1" value="${fn:split(f.fileUrl, '/')}"/>
                  <c:choose>
                    <c:when test="${fn:length(parts1) > 1}">
                      <c:set var="displayName" value="${parts1[fn:length(parts1)-1]}"/>
                    </c:when>
                    <c:otherwise>
                      <c:set var="parts2" value="${fn:split(f.fileUrl, '&#92;')}"/>
                      <c:set var="displayName" value="${parts2[fn:length(parts2)-1]}"/>
                    </c:otherwise>
                  </c:choose>

                  <%-- 파일 타입 4개 라벨 --%>
                  <c:set var="typeLabel">
                    <c:choose>
                      <c:when test="${f.fileType == 'WAGE_PROOF'}">통상임금을 확인할 수 있는 증명자료</c:when>
                      <c:when test="${f.fileType == 'PAYMENT_FROM_EMPLOYER'}">사업주로부터 금품을 지급받은 자료</c:when>
                      <c:when test="${f.fileType == 'ELIGIBILITY_PROOF'}">배우자/한부모/장애아동 확인 자료</c:when>
                      <c:when test="${f.fileType == 'OTHER'}">기타 자료</c:when>
                      <c:otherwise>기타 자료</c:otherwise>
                    </c:choose>
                  </c:set>

                  <tr>
                    <th>
                      <span style="display:inline-block;padding:2px 10px;border-radius:999px;background:var(--light-gray-color);">
                        <c:out value="${typeLabel}"/>
                      </span>
                    </th>
                    <td>
                      <a href="<c:url value='/file/download'><c:param name='fileId' value='${f.fileId}'/><c:param name='seq' value='${f.sequence}'/></c:url>"
                         style="text-decoration:none; color:var(--primary-color); word-break:break-all;">
                        <c:out value="${displayName}"/>
                      </a>
                    </td>
                    <td>
                      <a class="btn btn-secondary"
                         href="<c:url value='/file/download'><c:param name='fileId' value='${f.fileId}'/><c:param name='seq' value='${f.sequence}'/></c:url>">다운로드</a>
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
        </c:when>
        <c:otherwise>
          <div style="text-align:center; color:var(--gray-color); padding:14px;">등록된 첨부파일이 없습니다.</div>
        </c:otherwise>
      </c:choose>
    </div>

    <!-- 하단 버튼 -->
    <div class="button-container">
      <a href="${pageContext.request.contextPath}/comp/main" class="btn bottom-btn btn-secondary">목록</a>

      <c:if test="${confirmDTO.statusCode == 'ST_10'}">
        <a href="${pageContext.request.contextPath}/comp/update?confirmNumber=${confirmDTO.confirmNumber}" class="btn bottom-btn btn-secondary">내용 수정</a>

        <form method="post" action="${pageContext.request.contextPath}/comp/submit" style="display:contents;">
          <sec:csrfInput/>
          <input type="hidden" name="confirmNumber" value="${confirmDTO.confirmNumber}" />
          <button type="submit" class="btn bottom-btn btn-primary"
                  onclick="return confirm('제출 후 처리가 완료되면 수정이 불가합니다. 제출할까요?');">최종 제출</button>
        </form>
      </c:if>

      <c:if test="${confirmDTO.statusCode == 'ST_20' or confirmDTO.statusCode == 'ST_30'}">
        <form method="post" action="${pageContext.request.contextPath}/comp/recall" style="display:contents;">
          <sec:csrfInput/>
          <input type="hidden" name="confirmNumber" value="${confirmDTO.confirmNumber}" />
          <button type="submit" class="btn bottom-btn btn-secondary"
                  onclick="return confirm('신청을 회수하시겠습니까?');">신청 취소</button>
        </form>
      </c:if>

      <c:if test="${confirmDTO.statusCode != 'ST_50' and confirmDTO.statusCode != 'ST_60'}">
        <form method="post" action="${pageContext.request.contextPath}/comp/delete" style="display:contents;">
          <sec:csrfInput/>
          <input type="hidden" name="confirmNumber" value="${confirmDTO.confirmNumber}" />
          <button type="submit" class="btn bottom-btn btn-secondary"
                  onclick="return confirm('이 확인서를 삭제하시겠습니까?\n삭제한 신청서는 되돌릴 수 없습니다.');">삭제</button>
        </form>
      </c:if>
    </div>
  </c:if>
</main>

<footer class="footer">
  <p>&copy; 2025 육아휴직 서비스. All Rights Reserved.</p>
</footer>

<script>
(function(){
  var s = '<fmt:formatDate value="${confirmDTO.startDate}" pattern="yyyy-MM-dd"/>';
  var e = '<fmt:formatDate value="${confirmDTO.endDate}"   pattern="yyyy-MM-dd"/>';

  if (!s || !e) return;
  var start = new Date(s + 'T00:00:00');
  var end   = new Date(e + 'T00:00:00');
  if (isNaN(start) || isNaN(end)) return;

  // 계산: 끝 - 시작 + 1
  var msPerDay = 24*60*60*1000;
  var days = Math.floor((end - start) / msPerDay) + 1;
  if (days < 0) return;

  var el = document.getElementById('leave-days');
  if (el) {
    el.textContent = '(' + days + '일)';
  }
})();
</script>

</body>
</html>
