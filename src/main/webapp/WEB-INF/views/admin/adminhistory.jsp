<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>활동 이력 조회</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/global.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/comp.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

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

	/* ==== 기본 레이아웃 ==== */
	* { margin: 0; padding: 0; box-sizing: border-box; }
	html { height: 100%; }
	body {
		display: flex;
		flex-direction: column;
		min-height: 100vh;
		font-family: 'Noto Sans KR', sans-serif;
		background: var(--bg-light);
		color: var(--text-color);
	}
	a { text-decoration: none; color: inherit; }

	/* ==== 메인 컨텐츠 영역 ==== */
	.container-fluid.p-4 {
		padding: 0 !important; /* Bootstrap P-4 리셋 */
	}
	
	.container.mt-4 {
		max-width: 1200px;
		margin: 2rem auto; /* mt-4 리셋하고 중앙 정렬 */
		padding: 0;
	}

	h2 {
		font-size: 1.75rem;
		font-weight: 700;
		margin-bottom: 1.5rem;
	}
	hr {
		border: 0;
		border-top: 1px solid var(--border-color);
		margin-bottom: 1.5rem;
	}
	
	/* ==== 검색 폼  ==== */
	.search-form {
		background: var(--white-color);
		border: none;
		border-radius: .75rem;
		padding: 1.5rem 2rem;
		box-shadow: var(--shadow-sm);
		margin-bottom: 1.5rem;
	}

	/* 폼 내부 레이아웃  */
	#searchForm .row {
		display: flex;
		flex-wrap: wrap;
		gap: 1.5rem 1rem;
		margin: 0; /* g-3, mt-2 리셋 */
	}
	#searchForm .row:not(:first-child) {
		margin-top: 1rem;
	}
	
	#searchForm [class*="col-"] {
		flex: 1 1 250px; /* 유연한 너비 */
		padding: 0; /* g-3 리셋 */
	}
	
	#searchForm .d-flex {
		display: flex;
		align-items: flex-end; /* align-items-end */
		justify-content: flex-end; /* justify-content-end */
		gap: 0.5rem;
	}

	/* 폼 요소  */
	.search-form .form-label {
		font-size: .9rem;
		font-weight: 500;
		color: var(--text-color);
		margin-bottom: .35rem;
		display: block;
	}

	.search-form input[type="text"],
	.search-form input[type="date"],
	.search-form select {
		width: 100%;
		padding: .5rem .75rem;
		border: 1px solid var(--border-color);
		border-radius: .375rem;
		background: #fdfdfd;
		height: 40px;
		box-sizing: border-box;
		font-size: .9rem;
		font-family: 'Noto Sans KR', sans-serif;
		transition: border-color .15s ease, box-shadow .15s ease;
	}

	.search-form input[type="text"]:focus,
	.search-form input[type="date"]:focus,
	.search-form select:focus {
		outline: none;
		border-color: var(--primary-color);
		box-shadow: 0 0 0 3px var(--primary-light-color);
	}

	/* 폼 버튼  */
	.search-form button {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		padding: 0 1.25rem;
		height: 40px;
		min-width: 80px;
		border: 1px solid var(--border-color);
		border-radius: .375rem;
		background: var(--white-color);
		color: #555;
		cursor: pointer;
		font-size: .9rem;
		font-weight: 500;
		transition: all .15s ease;
		margin: 0; /* me-2 리셋 */
	}

	.search-form button:hover {
		background-color: #f8f9fa;
	}
	
	/* 검색 버튼  */
	.search-form button[type="submit"] {
		background: var(--primary-color);
		border-color: var(--primary-color);
		color: var(--white-color);
	}

	.search-form button[type="submit"]:hover {
		background: #334abf;
		border-color: #334abf;
		color: var(--white-color);
	}
	
	/* ==== 탭 메뉴  ==== */
	#actionTypeTabs {
		display: flex;
		list-style: none;
		padding: 0;
		margin: 0 0 1.5rem 0;
		border-bottom: 2px solid var(--border-color);
	}
	#actionTypeTabs .nav-item {
		margin: 0;
	}
	#actionTypeTabs .nav-link {
		display: block;
		padding: .75rem 1.25rem;
		margin-bottom: -2px; /* 하단 보더와 겹치게 */
		border: none;
		border-bottom: 2px solid transparent;
		background: none;
		color: var(--text-muted);
		font-weight: 500;
		text-decoration: none;
		transition: color .15s ease, border-color .15s ease;
		cursor: pointer;
	}
	#actionTypeTabs .nav-link:hover {
		color: var(--text-color);
	}
	#actionTypeTabs .nav-link.active {
		color: var(--primary-color);
		border-bottom-color: var(--primary-color);
		font-weight: 700;
	}

	/* ==== 테이블 ==== */
	.table-responsive-wrapper {
		background: var(--white-color);
		border: none;
		border-radius: .75rem;
		padding: 1.5rem 2rem;
		box-shadow: var(--shadow-sm);
		overflow-x: auto;
	}

	table.table {
		width: 100%;
		border-collapse: collapse;
		border-spacing: 0;
		margin-bottom: 0;
		text-align: left; /* .text-center 오버라이드 */
	}

	table.table th,
	table.table td {
		padding: .9rem 1rem;
		border-bottom: 1px solid var(--border-light); 
		vertical-align: middle;
		font-size: .9rem;
		white-space: nowrap;
		text-align: left; /* .text-center 오버라이드 */
	}
	
	/* 테이블 헤더 */
	table.table thead th {
		background: var(--white-color);
		font-weight: 600;
		color: #888;
		font-size: .8rem;
		text-transform: uppercase;
		letter-spacing: .5px;
		border-bottom: 2px solid #e9ecef;
		border-top: 1px solid #e9ecef;
		position: sticky; 
		top: 0; 
		z-index: 10; 
	}

	table.table tbody tr:hover {
		background-color: #fcfdff; 
	}

	table.table tbody td {
		color: var(--text-color);
	}
	
	.badge {
		display: inline-block;
		padding: .35em .65em;
		border-radius: 999px;
		color: var(--white-color);
		font-size: .8rem;
		font-weight: 600;
	}
	.bg-primary {
		background-color: var(--primary-color) !important;
	}
	.bg-success {
		background-color: var(--success-color) !important;
	}
	
	.doc-chip {
	  display: inline-flex;
	  align-items: center;
	  gap: .4rem;
	  padding: .25rem .55rem;
	  border-radius: 999px;
	  border: 1px solid var(--border-color);
	  font-size: .75rem;
	  font-weight: 500;
	  background: var(--white-color);
	  color: #555; /* 기본 텍스트 색상 (글자) */
	}
	
	.doc-chip i {
	  font-size: 1rem;
	  color: #555; /* 기본 회색 */
	}
	
	.doc-chip.chip-primary i {
	  color: var(--primary-color);
	}
	
	.doc-chip.chip-success i {
	  color: var(--success-color);
	}

	table.table tbody td[colspan] {
		text-align: center;
		color: var(--text-muted);
		padding: 3rem 1rem;
		font-size: .95rem;
	}
	
	/* 총 건수 표시 */
	.d-flex.justify-content-between.mb-2 {
		display: flex;
		justify-content: space-between;
		margin-bottom: 0.5rem;
		font-size: 0.9rem;
		color: var(--text-muted);
	}

	.pagination {
		display: flex;
		justify-content: center;
		gap: .5rem;
		margin-top: 2rem;
		padding: 0; /* list-style 리셋 */
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
		border-color: var(--border-color);
	}
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> 
</head>

<body>
<%@ include file="adminheader.jsp" %>

<div class="container-fluid p-4">
    <div class="container mt-4">
    <h2>활동 이력 조회</h2>
    <hr>

    <div class="card card-body bg-light mb-4 search-form">
        <form id="searchForm" method="GET" action="${pageContext.request.contextPath}/admin/history">
            <input type="hidden" name="pageNum" value="1"> 
             <input type="hidden" name="listSize" value="${pageDTO.listSize}">
             <input type="hidden" id="actionType" name="actionType" value="${search.actionType}">
    
             <div class="row g-3">
                 <div class="col-md-3">
                     <label for="formType" class="form-label">서식 구분</label>
                     <select id="formType" name="formType" class="form-select">
                         <option value="" ${empty search.formType ? 'selected' : ''}>전체</option>
                         <option value="신청서" ${search.formType eq '신청서' ? 'selected' : ''}>신청서</option>
                         <option value="확인서" ${search.formType eq '확인서' ? 'selected' : ''}>확인서</option>
                     </select>
                 </div>
                 <div class="col-md-3">
                     <label for="nameKeyword" class="form-label">사용자 이름</label>
                     <input type="text" id="nameKeyword" name="nameKeyword" class="form-control" value="${search.nameKeyword}">
                 </div>
                 <div class="col-md-3">
                     <label for="regNoKeyword" class="form-label">주민등록번호</label>
                     <input type="text" id="regNoKeyword" name="regNoKeyword" class="form-control" value="${search.regNoKeyword}" placeholder="13자리">
                 </div>
             </div>
             <div class="row g-3 mt-2">
                 <div class="col-md-3">
                 	<!-- 변경시간 기준 -->
                     <label for="startDate" class="form-label">기간 (시작일)</label>
                     <input type="date" id="startDate" name="startDate" class="form-control" 
                            value="<fmt:formatDate value="${search.startDate}" pattern="yyyy-MM-dd" />">
                 </div>
                 <div class="col-md-3">
                     <label for="endDate" class="form-label">기간 (종료일)</label>
                     <input type="date" id="endDate" name="endDate" class="form-control"
                            value="<fmt:formatDate value="${search.endDate}" pattern="yyyy-MM-dd" />">
                 </div>
                 <div class="col-md-6 d-flex align-items-end justify-content-end">
                     <button type="submit" class="btn btn-primary px-4 me-2">검색</button>
                     <button type="button" class="btn btn-outline-secondary" onclick="location.href='${pageContext.request.contextPath}/admin/history'">초기화</button>
                 </div>
             </div>
        </form>
    </div>

    <ul class="nav nav-tabs mb-3" id="actionTypeTabs">
		<li class="nav-item">
            <a class="nav-link ${empty search.actionType ? 'active' : ''}" href="#" data-action-type="">전체</a>
        </li>
		<li class="nav-item">
            <a class="nav-link ${search.actionType eq 'INSERT' ? 'active' : ''}" href="#" data-action-type="INSERT">등록</a>
        </li>
		<li class="nav-item">
            <a class="nav-link ${search.actionType eq 'UPDATE' ? 'active' : ''}" href="#" data-action-type="UPDATE">수정</a>
        </li>
		<li class="nav-item">
            <a class="nav-link ${search.actionType eq 'DELETE' ? 'active' : ''}" href="#" data-action-type="DELETE">삭제</a>
        </li>
    </ul>


    <div class="d-flex justify-content-between mb-2">
        <span>총 <strong><fmt:formatNumber value="${pageDTO.totalCnt}" pattern="#,###" /></strong>건</span>
        <span>( ${pageDTO.pageNum} / ${pageDTO.endPage} 페이지 )</span>
    </div>

    <div class="table-responsive-wrapper" style="overflow-x: auto; border: 1px solid var(--border-color); border-radius: 8px; box-shadow: var(--shadow-sm); background-color: var(--white-color);">
        <c:set var="formType" value="${search.formType}" />
        <c:choose>
            <%-- Case 1: '신청서' 선택 --%>
            <c:when test="${formType eq '신청서'}">
                <table class="table table-hover text-center" style="min-width: 2000px;">
                    <thead class="table-light">
                        <tr>
                            <!-- 공통 (6) -->
                            <!-- <th scope="col">번호</th> -->
                            <th scope="col">서식 구분</th>
                            <th scope="col">변경 유형</th>
                            <th scope="col">변경 시간</th>
                            <th scope="col">사용자 이름</th>
                            <th scope="col">사용자 주민번호</th>
                            
                            <!-- 신청서 (13) -->
                            <th scope="col">[신청] 접수번호</th>
                            <th scope="col">[신청] 은행코드</th>
                            <th scope="col">[신청] 계좌번호</th>
                            <th scope="col">[신청] 상태코드</th>
                            <th scope="col">[신청] 지급결과</th>
                            <th scope="col">[신청] 반려사유</th>
                            <th scope="col">[신청] 지급액</th>
                            <th scope="col">[신청] 제출일</th>
                            <th scope="col">[신청] 삭제여부</th>
                            <th scope="col">[신청] 행정정보동의</th>
                            <th scope="col">[신청] 센터ID</th>
                            <th scope="col">[신청] 수정(은행)</th>
                            <th scope="col">[신청] 수정(계좌)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty list}">
                                <c:forEach var="item" items="${list}" varStatus="status">
                                    <tr>
                                        <!-- 공통 (6) -->
                                        <%-- <td>${pageDTO.totalCnt - ( (pageDTO.pageNum - 1) * pageDTO.listSize + status.index )}</td> --%>
                                        <td><span class="doc-chip chip-primary"><i class="bi bi-file-earmark-text"></i> ${item.formType}</span></td>
                                        <td>${item.actionType}</td>
                                        <td><fmt:formatDate value="${item.actionTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                                        <td>${item.userName}</td>
                                        <td>${item.userRegiNumber}</td>
                                        
                                        <!-- 신청서 (13) -->
                                        <td>${item.applicationNumber}</td>
                                        <td>${item.bankCode}</td>
                                        <td>${item.accountNumber}</td>
                                        <td>${item.statusCode_App}</td>
                                        <td>${item.paymentResult}</td>
                                        <td>${item.rejectionReasonCode_App}</td>
                                        <td><fmt:formatNumber value="${item.payment}" pattern="#,###" /></td>
                                        <td><fmt:formatDate value="${item.submittedDt}" pattern="yyyy-MM-dd" /></td>
                                        <td>${item.deltAt_App}</td>
                                        <td>${item.govInfoAgree}</td>
                                        <td>${item.centerId_App}</td>
                                        <td>${item.updBankCode}</td>
                                        <td>${item.updAccountNumber}</td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="18" class="py-5">검색 결과가 없습니다.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </c:when>

            <%-- Case 2: '확인서' 선택 --%>
            <c:when test="${formType eq '확인서'}">
                <table class="table table-hover text-center" style="min-width: 3500px;">
                     <thead class="table-light">
                        <tr>
                            <!-- 공통 (5) -->
                            <th scope="col">서식 구분</th>
                            <th scope="col">변경 유형</th>
                            <th scope="col">변경 시간</th>
                            <th scope="col">사용자 이름</th>
                            <th scope="col">사용자 주민번호</th>
                            
                            <!-- 확인서 (23) -->
                            <th scope="col">[확인] 확인서번호</th>
                            <th scope="col">[확인] 신청일</th>
                            <th scope="col">[확인] 시작일</th>
                            <th scope="col">[확인] 종료일</th>
                            <th scope="col">[확인] 주 소정근로</th>
                            <th scope="col">[확인] 통상임금</th>
                            <th scope="col">[확인] 자녀명</th>
                            <th scope="col">[확인] 자녀주민번호</th>
                            <th scope="col">[확인] 자녀생일</th>
                            <th scope="col">[확인] 삭제여부</th>
                            <th scope="col">[확인] 응답자명</th>
                            <th scope="col">[확인] 응답자연락처</th>
                            <th scope="col">[확인] 처리자ID</th>
                            <th scope="col">[확인] 센터ID</th>
                            <th scope="col">[확인] 수정(근로)</th>
                            <th scope="col">[확인] 수정(임금)</th>
                            <th scope="col">[확인] 수정(자녀명)</th>
                            <th scope="col">[확인] 수정(자녀주민)</th>
                            <th scope="col">[확인] 수정(종료일)</th>
                            <th scope="col">[확인] 수정(시작일)</th>
                            <th scope="col">[확인] 수정(자녀생일)</th>
                            <th scope="col">[확인] 수정(주민)</th>
                            <th scope="col">[확인] 수정(이름)</th>
                        </tr>
                    </thead>
                    <tbody>
                         <c:choose>
                            <c:when test="${not empty list}">
                                <c:forEach var="item" items="${list}" varStatus="status">
                                    <tr>
                                        <!-- 공통 (6) -->
                                        <td><span class="doc-chip chip-success"><i class="bi bi-patch-check"></i> ${item.formType}</span></td>
                                        <td>${item.actionType}</td>
                                        <td><fmt:formatDate value="${item.actionTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                                        <td>${item.userName}</td>
                                        <td>${item.userRegiNumber}</td>

                                        <!-- 확인서 (23) -->
                                        <td>${item.confirmNumber_Cnf}</td>
                                        <td><fmt:formatDate value="${item.applyDt}" pattern="yyyy-MM-dd" /></td>
                                        <td><fmt:formatDate value="${item.startDate}" pattern="yyyy-MM-dd" /></td>
                                        <td><fmt:formatDate value="${item.endDate}" pattern="yyyy-MM-dd" /></td>
                                        <td>${item.weeklyHours}</td>
                                        <td><fmt:formatNumber value="${item.regularWage}" pattern="#,###" /></td>
                                        <td>${item.childName}</td>
                                        <td>${item.childResiRegiNumber}</td>
                                        <td><fmt:formatDate value="${item.childBirthDate}" pattern="yyyy-MM-dd" /></td>
                                        <td>${item.deltAt}</td>
                                        <td>${item.responseName}</td>
                                        <td>${item.responsePhoneNumber}</td>
                                        <td>${item.processorId}</td>
                                        <td>${item.centerId}</td>
                                        <td>${item.updWeeklyHours}</td>
                                        <td><fmt:formatNumber value="${item.updRegularWage}" pattern="#,###" /></td>
                                        <td>${item.updChildName}</td>
                                        <td>${item.updChildResiRegiNumber}</td>
                                        <td><fmt:formatDate value="${item.updEndDate}" pattern="yyyy-MM-dd" /></td>
                                        <td><fmt:formatDate value="${item.updStartDate}" pattern="yyyy-MM-dd" /></td>
                                        <td><fmt:formatDate value="${item.updChildBirthDate}" pattern="yyyy-MM-dd" /></td>
                                        <td>${item.updRegistrationNumber}</td>
                                        <td>${item.updName}</td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="28" class="py-5">검색 결과가 없습니다.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </c:when>

            <%-- Case 3: '전체' 선택  --%>
            <c:otherwise>
                 <table class="table table-hover text-center" style="min-width: 1200px;">
                    <thead class="table-light">
                        <tr>
                            <th scope="col">서식 구분</th>
                            <th scope="col">변경 유형</th>
                            <th scope="col">변경 시간</th>
                            <th scope="col">사용자 이름</th>
                            <th scope="col">사용자 주민번호</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty list}">
                                <c:forEach var="item" items="${list}" varStatus="status">
                                    <tr>
                                        <td>
                                            <c:choose>
									            <c:when test="${item.formType eq '신청서'}">
									                <span class="doc-chip chip-primary"><i class="bi bi-file-earmark-text"></i> ${item.formType}</span>
									            </c:when>
									            <c:otherwise>
									                <span class="doc-chip chip-success"><i class="bi bi-patch-check"></i> ${item.formType}</span>
									            </c:otherwise>
									        </c:choose>
                                        </td>
                                        <td>${item.actionType}</td>
                                        <td><fmt:formatDate value="${item.actionTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                                        <td>${item.userName}</td>
                                        <td>${item.userRegiNumber}</td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5" class="py-5">검색 결과가 없습니다.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div> 
 
    <c:url var="searchParams" value="">
        <c:param name="listSize" value="${pageDTO.listSize}" />
        <c:param name="formType" value="${search.formType}" />
        <c:param name="actionType" value="${search.actionType}" />
        <c:param name="nameKeyword" value="${search.nameKeyword}" />
        <c:param name="regNoKeyword" value="${search.regNoKeyword}" />
        <c:if test="${not empty search.startDate}">
            <c:param name="startDate" value="<fmt:formatDate value='${search.startDate}' pattern='yyyy-MM-dd' />" />
        </c:if>
        <c:if test="${not empty search.endDate}">
            <c:param name="endDate" value="<fmt:formatDate value='${search.endDate}' pattern='yyyy-MM-dd' />" />
        </c:if>
    </c:url>

    <div class="pagination">
	    <!-- 이전 버튼 (항상 활성화) -->
    	<a class="js-page-link prev" data-page="${pageDTO.pageNum - 1}" style="cursor: pointer;">&laquo;</a>

	
	    <!-- 페이지 번호 -->
	    <c:forEach begin="${pageDTO.paginationStart}" end="${pageDTO.paginationEnd}" var="p">
	        <c:choose>
	            <c:when test="${p == pageDTO.pageNum}">
	                <span class="active">${p}</span>
	            </c:when>
	            <c:otherwise>
	                <a class="js-page-link" data-page="${p}" style="cursor: pointer;">${p}</a>
	            </c:otherwise>
	        </c:choose>
	    </c:forEach>
	
	    <!-- 다음 버튼 (항상 활성화) -->
    	<a class="js-page-link next" data-page="${pageDTO.pageNum + 1}" style="cursor: pointer;">&raquo;</a>
	</div>

</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
	
    $(document).ready(function() {
        // 탭 클릭 이벤트
        $('#actionTypeTabs .nav-link').on('click', function(e) {
            e.preventDefault();

            const actionType = $(this).data('action-type');

            $('#actionType').val(actionType);
            $('#searchForm').submit();
        });
    });
    
    $('.js-page-link').on('click', function(e) {
        e.preventDefault();

        // 클릭한 링크의 data-page 값을 가져옴
        const newPage = $(this).data('page');

        // 폼 내부의 hidden input (pageNum) 값을 변경
        $('#searchForm input[name="pageNum"]').val(newPage);

        // 폼 전송 (GET 방식)
        $('#searchForm').submit();
    });
</script>
</body>
</html>