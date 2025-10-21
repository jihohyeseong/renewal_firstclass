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
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/comp.css">
</head>
<body>
    <%@ include file="adminheader.jsp" %>

    <main class="main-container">
    	<div class="info-table-container">
            <h2 class="section-title">처리상태(상태바)</h2>
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
                                <c:when test="${confirmDTO.statusCode == 'ST_20'}"><span class="status-badge status-pending">검토중</span></c:when>
                                <c:when test="${confirmDTO.statusCode == 'ST_50'}"><span class="status-badge status-approved">승인</span></c:when>
                                <c:when test="${confirmDTO.statusCode == 'ST_60'}"><span class="status-badge status-rejected">반려</span></c:when>
                                <c:otherwise><c:out value="${confirmDTO.statusCode}" /></c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
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
                                <c:when test="${confirmDTO.statusCode == 'ST_20'}"><span class="status-badge status-pending">검토중</span></c:when>
                                <c:when test="${confirmDTO.statusCode == 'ST_50'}"><span class="status-badge status-approved">승인</span></c:when>
                                <c:when test="${confirmDTO.statusCode == 'ST_60'}"><span class="status-badge status-rejected">반려</span></c:when>
                                <c:otherwise><c:out value="${confirmDTO.statusCode}" /></c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr>
					    <th>기업명</th>
					    <td>${userDTO.name}</td>
					</tr>
					<tr>
					    <th>주소</th>
					    <td>${userDTO.addressBase} ${userDTO.addressDetail}</td>
					</tr>
					<tr>
					    <th>전화번호</th>
					    <td>${userDTO.phoneNumber}</td>
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
                            ${fn:substring(rrnDigits,0,6)}-${fn:substring(rrnDigits,6,12)}
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
                        <tbody>
                            <tr>
                                <th>자녀 이름</th>
                                <td><c:out value="${confirmDTO.childName}" /></td>
                            </tr>
                            <tr>
                                <th>자녀 주민등록번호</th>
                                <td>
                                    <c:set var="childRrn" value="${confirmDTO.childResiRegiNumber}" />
                                    ${fn:substring(childRrn, 0, 6)}-${fn:substring(childRrn, 6, 12)}
                                </td>
                            </tr>
                            <tr>
                                <th>출생일</th>
                                <td><fmt:formatDate value="${confirmDTO.childBirthDate}" pattern="yyyy.MM.dd" /></td>
                            </tr>
                        </tbody>
                    </c:when>
                    <c:otherwise>
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

        <div class="button-container" style="text-align:center; margin-top:30px;">
        	<c:choose>

		        <c:when test="${confirmDTO.statusCode == 'ST_50' or confirmDTO.statusCode == 'ST_60'}">
		            <a href="${pageContext.request.contextPath}/admin/confirm" class="btn btn-secondary">목록으로</a>
		        </c:when>

		        <c:otherwise>
		            <div style="margin-bottom:15px;">
		                <label><input type="radio" name="judgeOption" value="approve">지급</label>
		                <label style="margin-left:15px;"><input type="radio" name="judgeOption" value="reject">부지급</label>
		            </div>
		            <button type="button" id="confirmBtn" class="btn btn-success">확인</button>
		            <button type="button" id="cancelBtn" class="btn btn-secondary" style="margin-top:10px;">취소</button>
		            <a href="${pageContext.request.contextPath}/admin/confirm" class="btn btn-secondary">목록으로</a>
		        </c:otherwise>
    		</c:choose>
		</div>
		
		<div id="rejectForm" style="display:none; margin-top:20px; border:1px solid #ccc; padding:15px; border-radius:8px;">
		    <h3>부지급 사유 선택</h3>
		    <div>
		        <label><input type="radio" name="reasonCode" value="RJ_10"> 계좌정보 불일치</label><br>
		        <label><input type="radio" name="reasonCode" value="RJ_20"> 관련서류 미제출</label><br>
		        <label><input type="radio" name="reasonCode" value="RJ_30"> 신청시기 미도래</label><br>
		        <label><input type="radio" name="reasonCode" value="RJ_40"> 근속기간 미충족</label><br>
		        <label><input type="radio" name="reasonCode" value="RJ_50"> 자녀 연령 기준 초과</label><br>
		        <label><input type="radio" name="reasonCode" value="RJ_60"> 휴직 가능 기간 초과</label><br>
		        <label><input type="radio" name="reasonCode" value="RJ_70"> 제출서류 정보 불일치</label><br>
		        <label><input type="radio" name="reasonCode" value="RJ_80"> 신청서 작성 내용 미비</label><br>
		        <label><input type="radio" name="reasonCode" value="RJ_99"> 기타</label>
		    </div>
		
		    <div style="margin-top:10px;">
		        <label>상세 사유:</label><br>
		        <input type="text" id="rejectComment" class="form-control" placeholder="상세 사유를 입력하세요" style="width:80%;">
		    </div>
		
		</div>
		
		<input type="hidden" id="confirmNumber" value="${confirmDTO.confirmNumber}" />
    </main>

<script>
	document.addEventListener("DOMContentLoaded", function() {
	
	    const confirmBtn = document.getElementById("confirmBtn");
	    const rejectForm = document.getElementById("rejectForm");
	    const cancelBtn = document.getElementById("cancelBtn");
	    const confirmNumber = document.getElementById("confirmNumber").value;
	    const rejectComment = document.getElementById("rejectComment");

	    console.log("✅ 페이지 로드 완료");
	    console.log("confirmNumber:", confirmNumber);
	    
	    // 지급 / 부지급 선택 시 즉시 반응
	    document.querySelectorAll('input[name="judgeOption"]').forEach(radio => {
	        radio.addEventListener('change', function() {
	            if (this.value === 'reject') {
	                // 부지급 선택 시 폼 표시
	                rejectForm.style.display = "block";
	                window.scrollTo({ top: document.body.scrollHeight, behavior: 'smooth' });
	            } else {
	                // 지급 선택 시 폼 숨김
	                rejectForm.style.display = "none";
	            }
	        });
	    });

	    // 확인 버튼 클릭 이벤트
	    confirmBtn.addEventListener("click", function() {
	        const selectedOption = document.querySelector('input[name="judgeOption"]:checked');

	        if (!selectedOption) {
	            alert("지급 또는 부지급을 선택해주세요.");
	            return;
	        }

	        const optionValue = selectedOption.value;

	        // 지급 처리
	        if (optionValue === "approve") {
	            if (!confirm("지급 확정하시겠습니까?")) return;

	            fetch("${pageContext.request.contextPath}/admin/judge/approve", {
	                method: "POST",
	                headers: { "Content-Type": "application/json" },
	                body: JSON.stringify({ confirmNumber: confirmNumber })
	            })
	            .then(res => res.json())
	            .then(data => {
	                alert(data.message);
	                if (data.success) location.href = data.redirectUrl;
	            })
	            .catch(err => {
	                console.error(err);
	                alert("지급 처리 중 오류가 발생했습니다.");
	            });
	        }

	        // 부지급 처리
	        else if (optionValue === "reject") {
	            const selectedReason = document.querySelector('input[name="reasonCode"]:checked');
	            const comment = rejectComment.value.trim();

	            if (!selectedReason) {
	                alert("부지급 사유를 선택해주세요.");
	                return;
	            }

	            if (selectedReason.value === "RJ_99" && comment === "") {
	                alert("기타를 선택한 경우 상세 사유를 입력해야 합니다.");
	                return;
	            }

	            if (!confirm("부지급 처리하시겠습니까?")) return;

	            const requestData = {
	                confirmNumber: confirmNumber,
	                rejectionReasonCode: selectedReason.value,
	                rejectComment: comment
	            };

	            fetch("${pageContext.request.contextPath}/admin/judge/reject", {
	                method: "POST",
	                headers: { "Content-Type": "application/json" },
	                body: JSON.stringify(requestData)
	            })
	            .then(res => res.json())
	            .then(data => {
	                alert(data.message);
	                if (data.success) location.href = data.redirectUrl;
	            })
	            .catch(err => {
	                console.error(err);
	                alert("부지급 처리 중 오류가 발생했습니다.");
	            });
	        }
	    });
	});
</script>

    <footer class="footer">
        <p>&copy; 2025 육아휴직 서비스. All Rights Reserved.</p>
    </footer>

</body>
</html>