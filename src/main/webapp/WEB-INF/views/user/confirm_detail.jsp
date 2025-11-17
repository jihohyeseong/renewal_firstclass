<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>육아휴직 확인서 상세</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/global.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/comp.css">

<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

<style>
:root {
  --primary-color: #3f58d4;
}
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
  color:var(--primary-color);border-bottom:2px solid #f0f2ff;
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

/* PDF 생성 시 숨길 요소 */
.pdf-hide {
    display: none !important;
}

/* [추가] 첫 번째 파일의 파일 링크 스타일 */
.file-download-link {
    color: var(--primary-color);
    font-weight: 500;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 8px;
}
.file-download-link:hover {
    text-decoration: underline;
}
</style>
</head>
<body>

<%@ include file="header.jsp" %>

<main class="main-container">

  <div id="pdf-content-area">
    <h1>육아휴직 확인서 상세</h1>

    <c:if test="${empty confirmDTO}">
      <p style="text-align:center; font-size:18px; color:var(--gray-color);">확인서 정보를 불러올 수 없습니다.</p>
    </c:if>

    <c:if test="${not empty confirmDTO}">
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
                <fmt:formatDate value="${confirmDTO.endDate}" pattern="yyyy.MM.dd"/><span id="leave-days" style="margin-left:8px; color:#555;"></span>
              </td>
            </tr>
            <tr>
              <th>주당 소정근로시간</th><td>${confirmDTO.weeklyHours} 시간</td>
              <th>통상임금(월)</th>
              <td><fmt:formatNumber value="${confirmDTO.regularWage}" pattern="#,##0"/>원</td>
            </tr>
          </tbody>
        </table>
      </div>

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
                  <td><fmt:formatNumber value="${term.companyPayment}" pattern="#,##0"/>원</td>
                  <td><fmt:formatNumber value="${term.govPayment}" pattern="#,##0"/>원</td>
                </tr>
              </c:forEach>
              <c:if test="${empty termList}">
                <tr><td colspan="4" style="text-align:center; color:var(--gray-color);">입력된 지급 내역이 없습니다.</td></tr>
              </c:if>
            </tbody>
          </table>
      </div>

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
                      <a href="${fn:escapeXml(confirmDTO.centerURL)}" target="_blank" rel="noopener" class="detail-btn pdf-hide-target">자세히 보기</a>
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
    </c:if>
  </div>
  
  <c:if test="${not empty confirmDTO}">
    <div class="info-table-container">
      <h2 class="section-title">첨부파일</h2>
      
      <table class="info-table">
        <colgroup>
          <col style="width:15%"><col style="width:85%">
        </colgroup>
        <tbody>

          <c:if test="${empty files}">
            <tr>
              <th style="text-align:center;">파일 목록</th>
              <td style="color:var(--gray-color);">
                등록된 첨부파일이 없습니다.
              </td>
            </tr>
          </c:if>

          <c:if test="${not empty files}">
            <c:forEach var="f" items="${files}" varStatus="st">

              <%-- 표시용 파일명 추출 --%>
              <c:set var="parts1" value="${fn:split(f.fileUrl, '/')}" />
              <c:choose>
                <c:when test="${fn:length(parts1) > 1}">
                  <c:set var="displayName" value="${parts1[fn:length(parts1)-1]}" />
                </c:when>
                <c:otherwise>
                  <c:set var="parts2" value="${fn:split(f.fileUrl, '\\\\')}" />
                  <c:set var="displayName" value="${parts2[fn:length(parts2)-1]}" />
                </c:otherwise>
              </c:choose>

              <%-- 파일 타입 라벨 (기존 파일의 라벨 유지) --%>
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
                <c:if test="${st.first}">
                  <th rowspan="${fn:length(files)}" style="text-align:center; vertical-align: middle;">
		                    파일 목록
                  </th>
                </c:if>

                <td>
                  <a href="<c:url value='/file/download'>
                              <c:param name='fileId' value='${f.fileId}'/>
                              <c:param name='seq'   value='${f.sequence}'/>
                           </c:url>"
                     class="file-download-link">
                    <span>(<c:out value='${typeLabel}'/>)</span>
                    <c:out value="${displayName}" />
                  </a>
                </td>
              </tr>
            </c:forEach>
          </c:if>

        </tbody>
      </table>
    </div>

    <div class="button-container">
      <a href="${pageContext.request.contextPath}/user/confirm/check" class="btn bottom-btn btn-secondary">목록</a>
      <button type"button" id="btn-pdf-download" class="btn bottom-btn btn-primary">PDF 다운로드</button>
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

<script>
document.getElementById('btn-pdf-download').addEventListener('click', function() {
    
    // 0. PDF 생성 전 준비
    const downloadBtn = this;
    const originalBtnText = downloadBtn.textContent;
    downloadBtn.textContent = 'PDF 생성 중...';
    downloadBtn.disabled = true;

    document.querySelectorAll('.pdf-hide-target').forEach(function(el) {
        el.classList.add('pdf-hide');
    });

    // 1. 캡처할 영역 지정
    const element = document.getElementById('pdf-content-area');
    const filename = '육아휴직확인서_${confirmDTO.confirmNumber}.pdf';

    // 2. html2canvas로 영역 캡처
    html2canvas(element, {
        scale: 2, // 해상도는 유지
        useCORS: true,
        logging: false
    }).then(function(canvas) {
        
        // 3. 캡처된 이미지를 jsPDF로 PDF에 추가
        try {
            // ✨ [수정] 이미지를 고압축 JPEG로 변환 (용량 감소의 핵심)
            // 0.75 = 75% 품질. (0.1 ~ 1.0 사이로 조절 가능)
            const imgData = canvas.toDataURL('image/jpeg', 0.9); 
            
            const { jsPDF } = window.jspdf;
            const doc = new jsPDF('p', 'mm', 'a4');
            
            const pdfWidth = 210; 
            const pdfHeight = 297; 
            const margin = 10; 
            
            const availableWidth = pdfWidth - (margin * 2); 
            const availableHeight = pdfHeight - (margin * 2); 
            
            const canvasWidth = canvas.width;
            const canvasHeight = canvas.height;
            
            const widthRatio = availableWidth / canvasWidth;
            const heightRatio = availableHeight / canvasHeight;
            const scale = Math.min(widthRatio, heightRatio);
            
            const scaledWidth = canvasWidth * scale;
            const scaledHeight = canvasHeight * scale;
            
            const posX = margin + (availableWidth - scaledWidth) / 2;
            const posY = margin;

            // 4. 이미지를 PDF에 추가 (이미지 포맷을 'JPEG'로 명시)
            doc.addImage(imgData, 'JPEG', posX, posY, scaledWidth, scaledHeight);

            // 5. 파일 저장
            doc.save(filename);
            
        } catch (error) {
            console.error("PDF 생성 중 오류 발생:", error);
            alert("PDF를 생성하는 중 오류가 발생했습니다.");
        } finally {
            // 6. PDF 생성 후 정리
            downloadBtn.textContent = originalBtnText;
            downloadBtn.disabled = false;
            document.querySelectorAll('.pdf-hide-target').forEach(function(el) {
                el.classList.remove('pdf-hide');
            });
        }
    });
});
</script>

</body>
</html>