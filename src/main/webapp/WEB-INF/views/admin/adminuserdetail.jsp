<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>육아휴직 급여 신청서 상세 보기</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/global.css">

<style>
:root{
	--primary-color:#3f58d4;
	--primary-light-color:#f0f2ff;
	--white-color:#ffffff;
	--light-gray-color:#f8f9fa;
	--gray-color:#868e96;
	--dark-gray-color:#343a40;
	--border-color:#dee2e6;
	--success-color:#28a745;
	--warning-bg-color:#fff3cd;
	--warning-border-color:#ffeeba;
	--warning-text-color:#856404;
	--shadow-sm:0 1px 3px rgba(0,0,0,0.05);
	--shadow-md:0 4px 8px rgba(0,0,0,0.07);
}

/* 기본 스타일 */
*{margin:0;padding:0;box-sizing:border-box}
html{height:100%}
body{
	display:flex;flex-direction:column;min-height:100vh;
	font-family:'Noto Sans KR',sans-serif;background-color:var(--light-gray-color);
	color:var(--dark-gray-color);
}
a{text-decoration:none;color:inherit}

.header,.footer{
	background-color:var(--white-color);padding:15px 40px;border-bottom:1px solid var(--border-color);box-shadow:var(--shadow-sm);
}
.footer{border-top:1px solid var(--border-color);border-bottom:none;text-align:center;padding:20px 0;margin-top:auto}
.header{display:flex;justify-content:space-between;align-items:center;position:sticky;top:0;z-index:10}
.header nav{display:flex;align-items:center;gap:15px}
.header .welcome-msg{font-size:16px}

.main-container{
	flex-grow:1;width:100%;max-width:850px;margin:40px auto;padding:40px;
	background-color:var(--white-color);border-radius:12px;box-shadow:var(--shadow-md);
}

h1{text-align:center;margin-bottom:10px;font-size:28px}
h2{
	color:var(--primary-color);border-bottom:2px solid var(--primary-light-color);
	padding-bottom:10px;margin-bottom:25px;font-size:20px;
}

/* 섹션 타이틀 */
.section-title{
	font-size:20px;font-weight:700;color:var(--dark-gray-color);
	margin-bottom:15px;border-left:4px solid var(--primary-color);padding-left:10px;
}

/* 테이블 */
.info-table-container{margin-bottom:30px}
.info-table{
	width:100%;border-collapse:collapse;
	border-top:2px solid var(--border-color);
	border-left:none;border-right:none;
}
.info-table th,.info-table td{
	padding:12px 15px;border:1px solid var(--border-color);
	text-align:left;font-size:15px;
}
.info-table th{
	background-color:var(--light-gray-color);
	font-weight:500;width:150px;color:var(--dark-gray-color);
}
.info-table td{background-color:var(--white-color);color:#333}
.info-table.table-4col th{width:120px;background-color:var(--light-gray-color)}
.info-table.table-4col td{width:auto}
.info-table.table-4col th,.info-table.table-4col td{border-top:none}
.info-table tr:first-child th,.info-table tr:first-child td{border-top:1px solid var(--border-color)}

/* 버튼 */
.btn{
	display:inline-block;padding:10px 20px;font-size:15px;font-weight:500;
	border-radius:8px;border:1px solid var(--border-color);cursor:pointer;
	transition:all .2s ease-in-out;text-align:center;
}
.btn-primary{background-color:var(--primary-color);color:#fff;border-color:var(--primary-color)}
.btn-primary:hover{background-color:#364ab1;box-shadow:var(--shadow-md);transform:translateY(-2px)}
.btn-secondary{background-color:var(--white-color);color:var(--gray-color);border-color:var(--border-color)}
.btn-secondary:hover{background-color:var(--light-gray-color);color:var(--dark-gray-color);border-color:#ccc}
.btn-logout{background-color:var(--dark-gray-color);color:#fff;border:none}
.btn-logout:hover{background-color:#555}

/* 하단 버튼 컨테이너 */
.button-container{text-align:center;margin-top:50px}
.bottom-btn{padding:12px 30px;font-size:1.1em}
#edit-btn{background-color:var(--primary-color);color:#fff;border-color:var(--primary-color)}
#edit-btn:hover{background-color:#364ab1;border-color:#364ab1;transform:translateY(-2px)}

.data-title{font-weight:500}
.detail-btn{
	border:1px solid var(--primary-color);color:var(--primary-color);
	background-color:var(--white-color);padding:3px 8px;font-size:14px;
	margin-left:10px;border-radius:4px;cursor:pointer;transition:background-color .1s;
}
.detail-btn:hover{background-color:var(--primary-light-color)}
.success-text{color:var(--success-color);font-weight:500}

/* 모달 스타일 */
.modal-overlay{
    position:fixed;top:0;left:0;width:100%;height:100%;
    background-color:rgba(0,0,0,0.5);display:flex;
    justify-content:center;align-items:center;z-index:1000;
    transition: opacity 0.2s ease-in-out;
}
.modal-content {
    background-color:var(--white-color);padding:30px 40px;
    border-radius:12px;width:100%;max-width:500px;
    box-shadow:var(--shadow-md);
    transform: scale(0.95);
    transition: transform 0.2s ease-in-out;
}
.modal-overlay.visible .modal-content { transform: scale(1); }
.modal-content h2 {
    margin-top:0;text-align:center;color:var(--dark-gray-color);
    border-bottom:none;padding-bottom:0;margin-bottom:25px;
    font-size: 22px;
}
.form-group {margin-bottom:20px}
.form-group label {
    display:block;font-weight:500;margin-bottom:8px;font-size:16px;
}
.form-control {
    width:100%;padding:10px;font-size:15px;
    border:1px solid var(--border-color);border-radius:8px;
    font-family: 'Noto Sans KR', sans-serif;
}
textarea.form-control { resize: vertical; }
.modal-buttons {
    display:flex;justify-content:flex-end;gap:10px;margin-top:30px;
}
/* [추가] 하이라이팅을 위한 CSS 클래스 */
.highlight-warning {
    background-color: #f8d7da; /* 부드러운 빨간색 배경 */
    color: var(--danger-color); /* 진한 빨간색 텍스트 */
    font-weight: 700;
    padding: 2px 6px;
    border-radius: 4px;
}

/* ===== 진행 상태 카드 (Step Progress Bar) - Blue Theme (5단계) ===== */
.progress-card {
  background: #fff;
  border: 1px solid var(--border-color);
  border-radius: 14px;
  padding: 20px;
  margin-bottom: 24px;
}
.stepper-wrapper {
  display: flex;
  justify-content: space-between;
  align-items: center;
  position: relative;
  padding: 0 6%;
  margin: 6px 0 2px;
}
.stepper-wrapper::before {
  content: '';
  position: absolute;
  top: 50%;
  left: 6%;
  right: 6%;
  height: 8px;
  border-radius: 8px;
  background-color: #dbe4ff; /* 연파랑 */
  z-index: 1;
  transform: translateY(-50%);
}
.stepper-item { position: relative; z-index: 2; text-align: center; flex: 1; }
.step-counter {
  width: 36px; height: 36px; border-radius: 50%;
  background-color: #b6ccff; color: #fff; font-weight: 700;
  margin: 18px auto 6px; display:flex; align-items:center; justify-content:center;
  transition: background-color .25s ease, box-shadow .25s ease;
}
.step-name { font-size: 13px; color: #334155; }
.stepper-item.completed .step-counter {
  background-color: #5c7cfa; box-shadow: inset 0 0 0 5px rgba(92,124,250,.22);
}
.stepper-item.current .step-counter {
  background-color: var(--primary-color); /* #3f58d4 */
  box-shadow: 0 0 0 4px rgba(63,88,212,.18);
}
.stepper-wrapper .progress-line {
  position: absolute; top: 50%; left: 6%;
  height: 8px; border-radius: 8px; background-color: var(--primary-color);
  z-index: 1; transform: translateY(-50%);
  width: 0%; max-width: 88%; transition: width .35s ease;
}

#rejectForm { display: none; }

</style>
</head>
<body>

<jsp:include page="adminheader.jsp" />

<main class="main-container">
<%-- 상태 코드/결과 기반으로 서버에서 단계/진행폭 계산 --%>
<c:set var="status" value="${appDTO.statusCode}" />
<c:set var="payRes" value="${appDTO.paymentResult}" />

<%-- 단계: 1 제출, 2 심사중(1차), 3 승인/반려, 4 심사중(2차), 5 최종지급결정 --%>
<c:set var="currentStep" value="2" />
<c:choose>
  <c:when test="${status == 'ST_20'}"><c:set var="currentStep" value="1"/></c:when>
  <c:when test="${status == 'ST_30'}"><c:set var="currentStep" value="2"/></c:when>
  <c:when test="${status == 'ST_40'}"><c:set var="currentStep" value="4"/></c:when>
  <c:when test="${status == 'ST_60'}"><c:set var="currentStep" value="3"/></c:when>
</c:choose>
<c:if test="${status == 'ST_50'}"><c:set var="currentStep" value="5"/></c:if>

<%-- 진행선 폭 계산 --%>
<c:set var="progressWidth" value="0"/>
<c:choose>
  <c:when test="${currentStep == 1}"><c:set var="progressWidth" value="0"/></c:when>
  <c:when test="${currentStep == 2}"><c:set var="progressWidth" value="25"/></c:when>
  <c:when test="${currentStep == 3}"><c:set var="progressWidth" value="50"/></c:when>
  <c:when test="${currentStep == 4}"><c:set var="progressWidth" value="75"/></c:when>
  <c:when test="${currentStep == 5}"><c:set var="progressWidth" value="100"/></c:when>
</c:choose>

<!-- 진행 상태 카드 (5단계) -->
<div class="progress-card">
  <div class="stepper-wrapper">
    <div class="progress-line" style="width:${progressWidth}%;"></div>

    <div class="stepper-item ${currentStep > 1 ? 'completed' : (currentStep == 1 ? 'current' : '')}">
      <div class="step-counter">1</div><div class="step-name">제출</div>
    </div>
    <div class="stepper-item ${currentStep > 2 ? 'completed' : (currentStep == 2 ? 'current' : '')}">
      <div class="step-counter">2</div><div class="step-name">심사중(1차)</div>
    </div>
    <div class="stepper-item ${currentStep > 3 ? 'completed' : (currentStep == 3 ? 'current' : '')}">
      <div class="step-counter">3</div>
      <div class="step-name">
        <c:choose>
          <c:when test="${status == 'ST_50'}">승인</c:when>
          <c:when test="${status == 'ST_60'}">반려</c:when>
          <c:otherwise>승인/반려</c:otherwise>
        </c:choose>
      </div>
    </div>
    <div class="stepper-item ${currentStep > 4 ? 'completed' : (currentStep == 4 ? 'current' : '')}">
      <div class="step-counter">4</div><div class="step-name">심사중(2차)</div>
    </div>
    <div class="stepper-item ${currentStep > 5 ? 'completed' : (currentStep == 5 ? 'current' : '')}">
      <div class="step-counter">5</div><div class="step-name">최종지급결정</div>
    </div>
  </div>
</div>
<h1>육아휴직 급여 신청서 상세 보기</h1>

<!-- 접수정보 -->
<div class="info-table-container">
  <h2 class="section-title">접수정보</h2>
  <table class="info-table table-4col">
    <tbody>
      <tr>
        <th class="data-title">접수번호</th>
        <td><c:out value="${appDTO.applicationNumber}" /></td>
        <th class="data-title">민원내용</th>
        <td>육아휴직 급여 신청</td>
      </tr>
      <tr>
        <th class="data-title">신청일</th>
        <td>
          <c:choose>
            <c:when test="${not empty appDTO.submittedDt}">
              <fmt:formatDate value="${appDTO.submittedDt}" pattern="yyyy-MM-dd" />
            </c:when>
            <c:otherwise>미신청</c:otherwise>
          </c:choose>
        </td>
        <th class="data-title">신청인</th>
        <!-- 관리자 전용: applicantName 표시 -->
        <td><c:out value="${appDTO.applicantName}" /></td>
      </tr>
    </tbody>
  </table>
</div>

<!-- 신청인 정보 -->
<div class="info-table-container">
  <h2 class="section-title">신청인 정보 (육아휴직자)</h2>
  <table class="info-table table-4col">
    <tbody>
      <tr>
        <th>이름</th>
        <td colspan="3"><c:out value="${appDTO.applicantName}" /></td>
      </tr>
      <!-- 아래 항목들은 userDTO 의존. 필요 시 서버에서 채워주거나 컬럼 추가 필요 -->
      <tr>
        <th>주민등록번호</th>
        <td colspan="3">
          <c:if test="${not empty userDTO.registrationNumber}">
            <c:set var="rrnRaw" value="${userDTO.registrationNumber}" />
            <c:set var="rrnDigits" value="${fn:replace(fn:replace(fn:trim(rrnRaw), '-', ''), ' ', '')}" />
            ${fn:substring(rrnDigits,0,6)}-${fn:substring(rrnDigits,6,7)}******
          </c:if>
          <c:if test="${empty userDTO.registrationNumber}">
            <span class="highlight-warning">미입력</span>
          </c:if>
        </td>
      </tr>
      <tr>
        <th>휴대전화번호</th>
        <td colspan="3">
          <c:if test="${not empty userDTO.phoneNumber}">
            <c:out value="${userDTO.phoneNumber}" />
          </c:if>
          <c:if test="${empty userDTO.phoneNumber}">
            <span class="highlight-warning">미입력</span>
          </c:if>
        </td>
      </tr>
      <tr>
        <th>주소</th>
        <td colspan="3">
          <c:choose>
            <c:when test="${empty userDTO.zipNumber and empty userDTO.addressBase}">
              <span class="highlight-warning">미입력</span>
            </c:when>
            <c:otherwise>
              <c:if test="${not empty userDTO.zipNumber}">(${userDTO.zipNumber})&nbsp;</c:if>
              <c:out value="${userDTO.addressBase}" />
              <c:if test="${not empty userDTO.addressDetail}">&nbsp;<c:out value="${userDTO.addressDetail}" /></c:if>
            </c:otherwise>
          </c:choose>
        </td>
      </tr>
    </tbody>
  </table>
</div>

<!-- 사업장 정보 -->
<div class="info-table-container">
  <h2 class="section-title">사업장 정보 (회사)</h2>
  <table class="info-table table-4col">
    <tbody>
      <tr>
        <th>사업장 이름</th>
        <td>
          <c:if test="${empty appDTO.businessName}">
            <span class="highlight-warning">미입력</span>
          </c:if>
          <c:if test="${not empty appDTO.businessName}">${appDTO.businessName}</c:if>
        </td>
      </tr>
      <tr>
        <th>사업장 <br>등록번호</th>
        <td>
          <c:choose>
            <c:when test="${empty appDTO.businessRegiNumber}">
              <span class="highlight-warning">미입력</span>
            </c:when>
            <c:otherwise>
              <c:set var="bizRaw" value="${appDTO.businessRegiNumber}" />
              <c:set var="bizDigits" value="${fn:replace(fn:replace(fn:replace(fn:trim(bizRaw), '-', ''), ' ', ''), ',', '')}" />
              <c:choose>
                <c:when test="${fn:length(bizDigits) == 10}">
                  ${fn:substring(bizDigits,0,3)}-${fn:substring(bizDigits,3,5)}-${fn:substring(bizDigits,5,10)}
                </c:when>
                <c:otherwise>
                  <span class="highlight-warning"><c:out value="${bizRaw}" /></span>
                </c:otherwise>
              </c:choose>
            </c:otherwise>
          </c:choose>
        </td>
        <th>인사담당자 <br>연락처</th>
        <td>02-9876-5432</td>
      </tr>
      <tr>
        <th>사업장 주소</th>
        <td colspan="3">
          <c:choose>
            <c:when test="${empty appDTO.businessZipNumber and empty appDTO.businessAddrBase}">
              <span class="highlight-warning">미입력</span>
            </c:when>
            <c:otherwise>
              <c:if test="${not empty appDTO.businessZipNumber}">(${appDTO.businessZipNumber})&nbsp;</c:if>
              <c:out value="${appDTO.businessAddrBase}" />
              <c:if test="${not empty appDTO.businessAddrDetail}">&nbsp;<c:out value="${appDTO.businessAddrDetail}" /></c:if>
            </c:otherwise>
          </c:choose>
        </td>
      </tr>
    </tbody>
  </table>
</div>

<!-- 급여 신청 기간 및 월별 내역 -->
<div class="info-table-container">
  <h2 class="section-title">급여 신청 기간 및 월별 내역</h2>
  <table class="info-table table-4col">
    <tbody>
      <tr>
        <th>육아휴직 <br>시작일</th>
        <td>
          <c:if test="${empty appDTO.startDate}"><span class="highlight-warning">미입력</span></c:if>
          <c:if test="${not empty appDTO.startDate}">${appDTO.startDate}</c:if>
        </td>
        <th>총 휴직 기간</th>
        <td id="total-leave-period">(${empty appDTO.startDate ? '미입력' : appDTO.startDate}
          ~ ${empty appDTO.endDate ? '미입력' : appDTO.endDate})</td>
      </tr>
      <tr>
        <th>월별 분할 <br>신청 여부</th>
        <td colspan="3">아니오 (일괄 신청)</td>
      </tr>
    </tbody>
  </table>

  <h3 class="section-title" style="font-size: 16px; margin-top: 25px;">월별 지급 내역</h3>
  <table class="info-table table-4col">
    <thead>
      <tr>
        <th>회차</th>
        <th>기간</th>
        <th>사업장 지급액</th>
        <th>정부 지급액</th>
        <th>지급예정일</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="t" items="${terms}" varStatus="st">
        <tr>
          <td><c:out value="${st.index + 1}" />개월차</td>
          <td><c:out value="${t.startMonthDate}" /> ~ <c:out value="${t.endMonthDate}" /></td>
          <td><fmt:formatNumber value="${t.companyPayment}" type="number" /></td>
          <td><fmt:formatNumber value="${t.govPayment}" type="number" /></td>
          <td><c:out value="${t.paymentDate}" /></td>
        </tr>
      </c:forEach>

      <c:if test="${empty terms}">
        <tr>
          <td colspan="5" style="text-align: center; color: #888;">단위기간 내역이 없습니다.</td>
        </tr>
      </c:if>
    </tbody>
  </table>
</div>

<!-- 자녀 정보 -->
<div class="info-table-container">
  <h2 class="section-title">자녀 정보 (육아 대상)</h2>

  <!-- 원본 데이터 표시 테이블 -->
  <table class="info-table table-4col">
    <tbody>
      <tr>
        <th>자녀 이름</th>
        <td><c:out value="${appDTO.childName}" /></td>
        <th>출산(예정)일</th>
        <td>
          <fmt:formatDate value="${appDTO.childBirthDate}" pattern="yyyy.MM.dd" />
        </td>
      </tr>
      <tr>
        <th>주민등록번호</th>
        <td colspan="3">
          <c:if test="${not empty appDTO.childResiRegiNumber}">
            ${fn:substring(appDTO.childResiRegiNumber, 0, 6)}-${fn:substring(appDTO.childResiRegiNumber, 6, 7)}******
          </c:if>
        </td>
      </tr>
    </tbody>
  </table>

  <!-- ↓ 수정용 테이블 (upd_ 컬럼용 인풋칸) -->
  <table class="info-table table-4col" style="margin-top:10px;">
  <tbody>
    <tr>
      <th style="background-color:#b0baec !important;">자녀 이름</th>
      <td >
        <input type="text" name="upd_child_name" class="form-control" placeholder="자녀 이름 수정" />
      </td>
      <th style="background-color:#b0baec !important;">출산(예정)일</th>
      <td >
        <input type="date" name="upd_child_birth_date" class="form-control" />
      </td>
    </tr>
    <tr>
      <th style="background-color:#b0baec !important;">주민등록번호</th>
      <td colspan="3">
        <input type="text" name="upd_child_resi_regi_number" class="form-control" maxlength="13" placeholder="숫자만 입력 (예: 0101011234567)" />
      </td>
    </tr>
  </tbody>
</table>
</div>

<!-- 계좌정보 -->
<div class="info-table-container">
  <h2 class="section-title">급여 입금 계좌정보</h2>
  <table class="info-table table-4col">
    <tbody>
      <tr>
        <th>은행</th>
        <td>
          <c:if test="${empty appDTO.bankName}">
            <span class="highlight-warning">미입력</span>
          </c:if>
          <c:if test="${not empty appDTO.bankName}">
            <c:out value="${appDTO.bankName}" />
          </c:if>
        </td>
        <th>계좌번호</th>
        <td>
          <c:if test="${empty appDTO.accountNumber}">
            <span class="highlight-warning">미입력</span>
          </c:if>
          <c:if test="${not empty appDTO.accountNumber}">
            <c:out value="${appDTO.accountNumber}" />
          </c:if>
        </td>
      </tr>
      <tr>
        <th>예금주 이름</th>
        <td colspan="3"><c:out value="${appDTO.applicantName}" /></td>
      </tr>
    </tbody>
  </table>
</div>

<!-- 센터 정보 (고정 예시) -->
<div class="info-table-container">
  <h2 class="section-title">접수 처리 센터 정보</h2>
  <table class="info-table table-4col">
    <tbody>
      <tr>
        <th>관할센터</th>
        <td>서울 고용 복지 플러스 센터
          <a href="https://www.work.go.kr/seoul/main.do" class="detail-btn">자세히 보기</a>
        </td>
        <th>대표전화</th>
        <td>02-2004-7301</td>
      </tr>
      <tr>
        <th>주소</th>
        <td colspan="3">서울 중구 삼일대로363 1층 (장교동)</td>
      </tr>
    </tbody>
  </table>
</div>

<!-- 행정정보 공동이용 동의 -->
<div class="info-table-container">
  <h2 class="section-title">행정정보 공동이용 동의</h2>
  <table class="info-table table-4col">
    <tbody>
      <tr>
        <th>동의 여부</th>
        <td colspan="3">
          <c:choose>
            <c:when test="${appDTO.govInfoAgree == 'Y'}">예</c:when>
            <c:when test="${appDTO.govInfoAgree == 'N'}"><span class="highlight-warning">아니요</span></c:when>
            <c:otherwise>미선택</c:otherwise>
          </c:choose>
        </td>
      </tr>
    </tbody>
  </table>
</div>

<c:if test="${not empty appDTO.submittedDt}">
  <div class="info-table-container">
    <h2 class="section-title">최종 동의 및 확인</h2>
    <table class="info-table table-4col">
      <tbody>
        <tr>
          <th>부정수급 <br />안내 확인</th>
          <td colspan="3">
            <span class="success-text">확인 및 동의 완료</span>
            (<fmt:formatDate value="${appDTO.submittedDt}" pattern="yyyy.MM.dd" />)
          </td>
        </tr>
        <tr>
          <th>심사 상태</th>
          <td colspan="3">
            <c:choose>
              <c:when test="${appDTO.paymentResult == 'Y'}">
                <span class="success-text">지급결정</span>
                <c:if test="${not empty appDTO.examineDt}">
                  (<fmt:formatDate value="${appDTO.examineDt}" pattern="yyyy.MM.dd" />)
                </c:if>
              </c:when>
              <c:when test="${appDTO.paymentResult == 'N'}">
                <span style="color: #dc3545; font-weight: 500;">부지급결정</span>
                <c:if test="${not empty appDTO.examineDt}">
                  (<fmt:formatDate value="${appDTO.examineDt}" pattern="yyyy.MM.dd" />)
                </c:if>
                <c:if test="${not empty appDTO.rejectionReasonCode or not empty appDTO.rejectComment or not empty appDTO.rejectionReasonName}">
                  <br />
                  <span style="display: block; margin-top: 10px; padding: 12px; border: 1px solid #d1d9ff; background: #f0f2ff; border-radius: 6px;">
                    <strong>부지급 사유</strong> :
                    <c:choose>
                      <c:when test="${not empty appDTO.rejectionReasonName}">${appDTO.rejectionReasonName}</c:when>
                      <c:when test="${not empty rejectCodeMap and not empty appDTO.rejectionReasonCode}">${rejectCodeMap[appDTO.rejectionReasonCode]}</c:when>
                      <c:otherwise><c:out value="${appDTO.rejectionReasonCode}" /></c:otherwise>
                    </c:choose>
                    <c:if test="${not empty appDTO.rejectComment}">
                      <br /><strong>상세 사유</strong> : <c:out value="${appDTO.rejectComment}" />
                    </c:if>
                  </span>
                </c:if>
              </c:when>
              <c:otherwise>심사중</c:otherwise>
            </c:choose>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</c:if>

<!-- 하단 관리자 버튼 -->
<div class="button-container">
  <c:choose>
    <c:when test="${appDTO.statusCode == 'ST_50' or appDTO.statusCode == 'ST_60' or appDTO.paymentResult == 'Y'}">
      <a href="${pageContext.request.contextPath}/admin/confirm" class="btn btn-secondary">목록으로</a>
    </c:when>
    <c:otherwise>
      <div class="judge-wrap">
        <label><input type="radio" name="judgeOption" value="approve"> 지급</label>
        <label><input type="radio" name="judgeOption" value="reject"> 부지급</label>
      </div>

      <div id="rejectForm">
        <h3>부지급 사유 선택</h3>
        <div class="reasons" id="rejectReasons"><!-- /codes/reject 로딩 --></div>
        <div style="margin-top:10px;">
          <label>상세 사유</label><br>
          <input type="text" id="rejectComment" class="form-control" placeholder="상세 사유를 입력하세요 (선택)">
        </div>
      </div>

      <div class="judge-actions">
        <button type="button" id="confirmBtn" class="btn btn-primary">확인</button>
        <a href="${pageContext.request.contextPath}/admin/confirm" class="btn btn-secondary">취소</a>
      </div>
    </c:otherwise>
  </c:choose>
</div>

<input type="hidden" id="applicationNumber" value="${appDTO.applicationNumber}" />


<footer class="footer">
  <p>&copy; 2025 육아휴직 서비스. All Rights Reserved.</p>
</footer>

<!-- 관리자 전용: 항상 실행 -->
<script>
document.addEventListener("DOMContentLoaded", function () {
	  const ctx = '${pageContext.request.contextPath}';

	  const confirmBtn        = document.getElementById("confirmBtn");
	  const rejectForm        = document.getElementById("rejectForm");
	  const rejectReasonsEl   = document.getElementById("rejectReasons"); // ← 꼭 필요
	  const rejectCommentEl   = document.getElementById("rejectComment");
	  const applicationNumber = document.getElementById("applicationNumber")?.value;

	  // 지급/부지급 라디오 선택 시 사유 로딩
	  document.querySelectorAll('input[name="judgeOption"]').forEach(radio => {
	    radio.addEventListener('change', function() {
	      if (this.value === 'reject') {
	        rejectForm.style.display = "block";

	        if (!rejectReasonsEl.dataset.loaded) {
	          fetch(ctx + '/code/reject', {
	            method: 'GET',
	            headers: { 'Accept': 'application/json' }
	          })
	          .then(res => res.json())
	          .then(list => {
	            if (!Array.isArray(list) || list.length === 0) {
	              rejectReasonsEl.innerHTML =
	                '<em style="color:#64748b;">사유 코드가 없습니다.</em>';
	            } else {
	            	rejectReasonsEl.innerHTML = list
	            	  .map(({code, name}) =>
	            	    '<label><input type="radio" name="reasonCode" value="' + code + '"> ' + (name ?? code) + '</label>'
	            	  )
	            	  .join('');
	            }
	            rejectReasonsEl.dataset.loaded = '1';
	          })
	          .catch(() => {
	            // 네트워크 실패 시라도 선택 가능하도록 기본 옵션 제공
	            rejectReasonsEl.innerHTML =
	              '<label><input type="radio" name="reasonCode" value="RJ_99"> 기타(네트워크 오류)</label>';
	            rejectReasonsEl.dataset.loaded = '1';
	          });
	        }
	      } else {
	        rejectForm.style.display = "none";
	      }
	    });
	  });

	  // 확인(지급/부지급) — 토큰 없이
	  if (confirmBtn) {
	    confirmBtn.addEventListener('click', function() {
	      const selected = document.querySelector('input[name="judgeOption"]:checked');
	      if (!selected) { alert('지급 또는 부지급을 선택해주세요.'); return; }

	      // ★ 컨트롤러 경로와 반드시 통일 (예: admin/judge/**)
	      const approveUrl = ctx + '/admin/user/approve';
	      const rejectUrl  = ctx + '/admin/user/reject';

	      if (selected.value === 'approve') {
	        if (!confirm('지급 확정하시겠습니까?')) return;

	        fetch(approveUrl, {
	          method: 'POST',
	          headers: { 'Content-Type': 'application/json' },
	          body: JSON.stringify({ applicationNumber: Number(applicationNumber) })
	        })
	        .then(res => res.json())
	        .then(data => {
	          alert(data.message || '처리가 완료되었습니다.');
	          if (data.redirectUrl) location.href = data.redirectUrl.startsWith('/') ? (ctx + data.redirectUrl) : data.redirectUrl;
	        })
	        .catch(() => alert('지급 처리 중 오류가 발생했습니다.'));
	      } else {
	        const reason  = document.querySelector('input[name="reasonCode"]:checked');
	        const comment = (rejectCommentEl?.value || '').trim();
	        if (!reason) { alert('부지급 사유를 선택해주세요.'); return; }
	        if (reason.value === 'RJ_99' && !comment) { alert('기타 선택 시 상세 사유를 입력하세요.'); return; }
	        if (!confirm('부지급 처리하시겠습니까?')) return;

	        fetch(rejectUrl, {
	          method: 'POST',
	          headers: { 'Content-Type': 'application/json' },
	          body: JSON.stringify({
	            applicationNumber: Number(applicationNumber),
	            rejectionReasonCode: reason.value,
	            rejectComment: comment
	          })
	        })
	        .then(res => res.json())
	        .then(data => {
	          alert(data.message || '부지급 처리가 완료되었습니다.');
	          if (data.redirectUrl) location.href = data.redirectUrl.startsWith('/') ? (ctx + data.redirectUrl) : data.redirectUrl;
	        })
	        .catch(() => alert('부지급 처리 중 오류가 발생했습니다.'));
	      }
	    });
	  }
	});

</script>


<div id="flash-error" style="display:none;"><c:out value="${error}"/></div>
<script>
 (function () {
   var err = document.getElementById('flash-error')?.textContent.trim();
   if (err) alert(err);
 })();
</script>
</body>
</html>
