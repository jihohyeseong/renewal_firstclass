<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>육아휴직 확인서 상세 보기</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
<%-- 공통 CSS 파일 경로를 실제 프로젝트에 맞게 수정해주세요. --%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/comp.css">

</head>
<body>
    <%-- 헤더 JSP 경로를 실제 프로젝트에 맞게 수정해주세요 --%>
    <%@ include file="../header.jsp" %>

    <main class="main-container">
        <h1>육아휴직 확인서 상세 정보</h1>

        <div class="info-table-container">
            <h2 class="section-title">접수 정보</h2>
            <table class="info-table">
                <tbody>
                    <tr>
                        <th>확인서 번호</th>
                        <td><c:out value="${confirmDTO.confirmNumber}" /></td>
                    </tr>
                    <tr>
                        <th>제출일</th>
                        <td><fmt:formatDate value="${confirmDTO.applyDt}" pattern="yyyy-MM-dd" /></td>
                    </tr>
                    <tr>
                        <th>처리 상태</th>
                        <td>
                             <c:choose>
                                <c:when test="${confirmDTO.statusCode == 'PENDING'}"><span class="status-badge status-pending">검토중</span></c:when>
                                <c:when test="${confirmDTO.statusCode == 'APPROVED'}"><span class="status-badge status-approved">승인</span></c:when>
                                <c:when test="${confirmDTO.statusCode == 'REJECTED'}"><span class="status-badge status-rejected">반려</span></c:when>
                                <c:otherwise><c:out value="${confirmDTO.statusCode}" /></c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="info-table-container">
            <h2 class="section-title">기업 정보</h2>
            <table class="info-table">
                <tbody>
                    <tr>
                        <th>사업장 이름</th>
                        <td><c:out value="${companyDTO.businessName}" /></td>
                    </tr>
                    <tr>
                        <th>사업자 등록번호</th>
                        <td>
                            <c:set var="bizDigits" value="${fn:replace(companyDTO.businessRegiNumber, '-', '')}" />
                            ${fn:substring(bizDigits,0,3)}-${fn:substring(bizDigits,3,5)}-${fn:substring(bizDigits,5,10)}
                        </td>
                    </tr>
                     <tr>
                        <th>사업장 주소</th>
                        <td><c:out value="(${companyDTO.businessZipNumber}) ${companyDTO.businessAddrBase} ${companyDTO.businessAddrDetail}" /></td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="info-table-container">
            <h2 class="section-title">근로자 정보</h2>
            <table class="info-table">
                <tbody>
                    <tr>
                        <th>성명</th>
                        <td><c:out value="${confirmDTO.name}" /></td>
                    </tr>
                    <tr>
                        <th>주민등록번호</th>
                        <td>
                            <c:set var="rrnDigits" value="${fn:replace(confirmDTO.registrationNumber, '-', '')}" />
                            ${fn:substring(rrnDigits,0,6)}-${fn:substring(rrnDigits,6,7)}******
                        </td>
                    </tr>
                    <tr>
                        <th>육아휴직 기간</th>
                        <td>
                            <fmt:formatDate value="${confirmDTO.startDate}" pattern="yyyy.MM.dd" /> ~ 
                            <fmt:formatDate value="${confirmDTO.endDate}" pattern="yyyy.MM.dd" />
                        </td>
                    </tr>
                    <tr>
                        <th>주당 소정근로시간</th>
                        <td><c:out value="${confirmDTO.weeklyHours}" /> 시간</td>
                    </tr>
                    <tr>
                        <th>통상임금 (월)</th>
                        <td><fmt:formatNumber value="${confirmDTO.regularWage}" type="currency" currencySymbol="₩ " /></td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="info-table-container">
            <h2 class="section-title">대상 자녀 정보</h2>
            <table class="info-table">
                 <c:choose>
                    <c:when test="${not empty confirmDTO.childName}">
                        <%-- 출생한 경우 --%>
                        <tbody>
                            <tr>
                                <th>자녀 이름</th>
                                <td><c:out value="${confirmDTO.childName}" /></td>
                            </tr>
                            <tr>
                                <th>자녀 주민등록번호</th>
                                <td>
                                    <c:set var="childRrn" value="${confirmDTO.childResiRegiNumber}" />
                                    ${fn:substring(childRrn, 0, 6)}-${fn:substring(childRrn, 6, 7)}******
                                </td>
                            </tr>
                            <tr>
                                <th>출생일</th>
                                <td><fmt:formatDate value="${confirmDTO.childBirthDate}" pattern="yyyy.MM.dd" /></td>
                            </tr>
                        </tbody>
                    </c:when>
                    <c:otherwise>
                        <%-- 출산 예정인 경우 --%>
                        <tbody>
                             <tr>
                                <th>자녀 정보</th>
                                <td>출산 예정</td>
                            </tr>
                            <tr>
                                <th>출산 예정일</th>
                                <td><fmt:formatDate value="${confirmDTO.childBirthDate}" pattern="yyyy.MM.dd" /></td>
                            </tr>
                        </tbody>
                    </c:otherwise>
                </c:choose>
            </table>
        </div>

        <div class="info-table-container">
            <h2 class="section-title">월별 지급 내역</h2>
            <table class="info-table">
                <thead>
                    <tr style="background-color: var(--light-gray-color);">
                        <th style="width: 80px; text-align:center;">회차</th>
                        <th style="width: auto; text-align:center;">기간</th>
                        <th style="width: 180px; text-align:center;">사업장 지급액</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="term" items="${termList}" varStatus="status">
                        <tr>
                            <td style="text-align:center;"><c:out value="${status.count}" />개월차</td>
                            <td style="text-align:center;">
                                <fmt:formatDate value="${term.startMonthDate}" pattern="yyyy.MM.dd" /> ~ 
                                <fmt:formatDate value="${term.endMonthDate}" pattern="yyyy.MM.dd" />
                            </td>
                            <td style="text-align:right; padding-right: 20px;">
                                <fmt:formatNumber value="${term.companyPayment}" type="currency" currencySymbol="₩ " />
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty termList}">
                        <tr>
                            <td colspan="3" style="text-align:center; color: var(--gray-color);">입력된 지급 내역이 없습니다.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <div class="info-table-container">
            <h2 class="section-title">확인서 작성자 정보</h2>
            <table class="info-table">
                <tbody>
                    <tr>
                        <th>담당자 이름</th>
                        <td><c:out value="${confirmDTO.responseName}" /></td>
                    </tr>
                    <tr>
                        <th>담당자 연락처</th>
                        <td><c:out value="${confirmDTO.responsePhoneNumber}" /></td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="button-container">
        <a href="${pageContext.request.contextPath}/comp/main" class="btn btn-secondary">목록으로</a>

        <c:if test="${confirmDTO.statusCode == 'ST_10'}">
            <!-- 내용 수정 -->
            <a href="${pageContext.request.contextPath}/comp/apply?confirmNumber=${confirmDTO.confirmNumber}"
               class="btn btn-primary" style="margin-left: 10px;">내용 수정하기</a>

            <!-- 최종 제출 (POST /comp/submit) -->
            <form method="post"
                  action="${pageContext.request.contextPath}/comp/submit"
                  style="display:inline-block; margin-left:10px;">
                <input type="hidden" name="confirmNumber" value="${confirmDTO.confirmNumber}" />
                <button type="submit"
                        class="btn btn-primary"
                        onclick="return confirm('제출 후에는 수정이 제한될 수 있습니다. 최종 제출하시겠습니까?');">
                    최종 제출
                </button>
            </form>
        </c:if>
    </div>
    </main>
    
    <footer class="footer">
        <p>&copy; 2025 육아휴직 서비스. All Rights Reserved.</p>
    </footer>

</body>
</html>
