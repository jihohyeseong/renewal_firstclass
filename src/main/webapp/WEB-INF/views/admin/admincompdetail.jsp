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
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/global.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/comp.css">
<style>
	  /* ===== 진행 상태 카드 (Step Progress Bar) ===== */
	  .progress-card {
	    background: #fff;
	    border: 1px solid var(--border-color);
	    border-radius: 14px;
	    padding: 20px;
	    margin-bottom: 24px;
	  }
	
	  /* ===== 진행 상태 바 개선 ===== */
	.stepper-wrapper {
	  display: flex;
	  justify-content: space-between;
	  align-items: center;
	  position: relative;
	  padding: 0 8%;
	  margin: 10px 0;
	}
	
	.stepper-wrapper::before {
	  content: '';
	  position: absolute;
	  top: 50%; /* 원 중심선과 맞춤 */
	  left: 8%;
	  right: 8%;
	  height: 10px;
	  border-radius: 10px;
	  background-color: #dcdcdc;
	  z-index: 1;
	  transform: translateY(-50%);
	}
	
	.stepper-item {
	  position: relative;
	  z-index: 2;
	  text-align: center;
	  flex: 1;
	  justify-content: center;
	}
	
	.step-counter {
	  width: 38px;
	  height: 38px;
	  border-radius: 50%;
	  background-color: #dcdcdc;
	  color: white;
	  font-weight: bold;
	  margin: 10px auto;
	  margin-top: 25px;
	  display: flex;
	  justify-content: center;
	  align-items: center;
	  transition: background-color 0.3s ease, box-shadow 0.3s ease;
	}
	
	/* 단계 텍스트(결과대기 포함) 정렬 수정 */
	.step-name {
	  font-size: 14px;
	  color: #333;
	  margin-top: 6px;
	  display: block;
	}
	
	/* 완료된 단계 */
	.stepper-item.completed .step-counter {
	  background-color: #81c784; /* 연한 초록색 */
	  box-shadow: inset 0 0 0 5px rgba(46,125,50,0.25); /* 채워진 원 느낌 */
	}
	
	/* 현재 진행 단계 */
	.stepper-item.current .step-counter {
	  background-color: #2e7d32; /* 진한 초록색 */
	  box-shadow: 0 0 0 4px rgba(46, 125, 50, 0.2);
	}
	
	/* 결과대기(아직 미완료) 상태 기본 */
	.stepper-item.waiting .step-counter {
	  background-color: #dcdcdc;
	  color: #999;
	}
	
	/* 완료 구간 연결선 */
	.stepper-wrapper .progress-line {
	  position: absolute;
	  top: 50%; /* 원 중심과 맞춤 */
	  left: 8%;
	  height: 10px;
	  border-radius: 10px;
	  background-color: #4caf50;
	  z-index: 1;
	  transform: translateY(-50%);
	  transition: width 0.4s ease;
	}
  
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
	
	   /* ===== 버튼 영역 수정 ===== */
	  .button-container {
	    text-align: center;
	    margin-top: 30px;
	    padding-bottom: 20px;
	  }
	
	  .judge-actions {
	    display: flex;
	    justify-content: center;
	    gap: 12px;
	    margin-bottom: 25px; /* 목록 버튼과 간격 증가 */
	  }
	
	  .btn-primary, .btn-secondary {
	    padding: 6px 14px; /* 패딩 축소 */
	    font-size: 14px;
	  }
	
	  .btn-secondary {
	    margin-top: 14px; /* 목록 버튼 위쪽 여백 */
	  }

	
	  /* ===== 부지급 사유 영역 ===== */
	  #rejectForm {
	    display: none;
	    margin-top: 20px;
	    border: 1px solid #ccc;
	    padding: 12px;
	    border-radius: 8px;
	    text-align: left;
	  }
	
	  #rejectForm h3 {
	    margin-bottom: 10px;
	  }
	
	  #rejectForm div:first-of-type {
	    display: grid;
	    grid-template-columns: repeat(2, 1fr); /* 2열 배치 */
	    gap: 6px 18px; /* 상하6px, 좌우18px 간격 */
	  }
	
	  #rejectForm label {
	    font-size: 14px;
	  }
	
	  #rejectComment {
	    margin-top: 8px;
	    width: 80%;
	  }
	  
</style>
</head>
<body>
<%@ include file="adminheader.jsp" %>

<main class="main-container">
  <!-- 진행 상태 카드 -->
	<div class="progress-card">
	  <div class="stepper-wrapper">
		  <div class="progress-line"></div>
		
		  <!-- Step 1: 제출 -->
		  <div class="stepper-item 
		       <c:if test='${confirmDTO.statusCode == "ST_30" or confirmDTO.statusCode == "ST_50" or confirmDTO.statusCode == "ST_60"}'>completed</c:if>
		       <c:if test='${confirmDTO.statusCode == "ST_20"}'>current</c:if>">
		    <div class="step-counter">1</div>
		    <div class="step-name">제출</div>
		  </div>
		
		  <!-- Step 2: 심사중 -->
		  <div class="stepper-item 
		       <c:if test='${confirmDTO.statusCode == "ST_50" or confirmDTO.statusCode == "ST_60"}'>completed</c:if>
		       <c:if test='${confirmDTO.statusCode == "ST_30"}'>current</c:if>">
		    <div class="step-counter">2</div>
		    <div class="step-name">심사중</div>
		  </div>
		
		  <!-- Step 3: 승인 / 반려 / 결과대기 -->
		  <div class="stepper-item 
		       <c:choose>
		          <c:when test='${confirmDTO.statusCode == "ST_50" or confirmDTO.statusCode == "ST_60"}'>completed</c:when>
		          <c:otherwise>waiting</c:otherwise>
		       </c:choose>">
		    <div class="step-counter">3</div>
		    <div class="step-name">
		      <c:choose>
		        <c:when test='${confirmDTO.statusCode == "ST_50"}'>승인</c:when>
		        <c:when test='${confirmDTO.statusCode == "ST_60"}'>반려</c:when>
		        <c:otherwise>결과대기</c:otherwise>
		      </c:choose>
		    </div>
		  </div>
		</div>
	</div>

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
                        <th>확인서 번호</th><td><c:out value="${confirmDTO.confirmNumber}" /></td>
                        <th>처리 상태</th>
                        <td>
                             <c:choose>
                                <c:when test="${confirmDTO.statusCode == 'ST_20'}"><span class="status-badge status-pending">심사중</span></c:when>
                                <c:when test="${confirmDTO.statusCode == 'ST_30'}"><span class="status-badge status-pending">심사중</span></c:when>
                                <c:when test="${confirmDTO.statusCode == 'ST_50'}"><span class="status-badge status-approved">승인</span></c:when>
                                <c:when test="${confirmDTO.statusCode == 'ST_60'}"><span class="status-badge status-rejected">반려</span></c:when>
                                <c:otherwise><c:out value="${confirmDTO.statusCode}" /></c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr>
                        <th>제출일</th>
                        <td colspan="3"><fmt:formatDate value="${confirmDTO.applyDt}" pattern="yyyy-MM-dd" /></td>
                    </tr>
                   	 <!-- 회사 정보 -->
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

			<!-- 근로자 정보 -->
            <tr><th class="sheet-head" colspan="4">근로자 정보</th></tr>
                    <tr>
                        <th>성명</th><td><c:out value="${confirmDTO.name}" /></td>
                        <th>주민등록번호</th>
                        <td>
                            <c:set var="rrnDigits" value="${fn:replace(confirmDTO.registrationNumber, '-', '')}" />
                            ${fn:substring(rrnDigits,0,6)}-${fn:substring(rrnDigits,6,12)}
                        </td>
                    </tr>
                   
                    <tr>
                        <th>육아휴직 기간</th>
                        <td colspan="3">
                            <fmt:formatDate value="${confirmDTO.startDate}" pattern="yyyy.MM.dd" /> ~ 
                            <fmt:formatDate value="${confirmDTO.endDate}" pattern="yyyy.MM.dd" />
                        </td>
                    </tr>
                    <tr>
                        <th>주당 소정근로시간</th><td><c:out value="${confirmDTO.weeklyHours}" /> 시간</td>
                        <th>통상임금 (월)</th>
                        <td><fmt:formatNumber value="${confirmDTO.regularWage}" type="currency" currencySymbol="₩ " /></td>
                    </tr>
    		<!-- 자녀 정보 -->
        	<tr><th class="sheet-head" colspan="4">대상 자녀 정보</th></tr>
                 <c:choose>
                    <c:when test="${not empty confirmDTO.childName}">
                        <tbody>
                            <tr>
                                <th>자녀 이름</th><td><c:out value="${confirmDTO.childName}" /></td>
                                <th>출생일</th>
                                <td><fmt:formatDate value="${confirmDTO.childBirthDate}" pattern="yyyy.MM.dd" /></td>
                            </tr>
                            <tr>
                                <th>자녀 주민등록번호</th>
                                <td colspan="3">
                                    <c:set var="childRrn" value="${confirmDTO.childResiRegiNumber}" />
                                    ${fn:substring(childRrn, 0, 6)}-${fn:substring(childRrn, 6, 12)}
                                </td>
                            </tr>
                    </c:when>
                    <c:otherwise>
                             <tr><th>자녀 정보</th><td colspan="3">출산 예정</td></tr>
                            <tr><th>출산 예정일</th><td colspan="3"><fmt:formatDate value="${confirmDTO.childBirthDate}" pattern="yyyy.MM.dd" /></td></tr>
                    </c:otherwise>
                </c:choose>
 		<!-- 월별 지급 내역 -->
   		<tr><th class="sheet-head" colspan="4">월별 지급 내역</th></tr>
   		<tr>
   			<td colspan="4" style="padding:0;">
          		<table class="month-table">
		            
            	<thead>
	            	<tr>
	                     <th>회차</th>
	                     <th colspan="2">기간</th>
	                     <th colspan="1">사업장 지급액</th>
	                </tr>
        		</thead>
        		<tbody>
                    <c:forEach var="term" items="${termList}" varStatus="status">
                        <tr>
                            <td style="text-align:center;" colspan="1"><c:out value="${status.count}" />개월차</td>
                            <td style="text-align:center;" colspan="2">
                                <fmt:formatDate value="${term.startMonthDate}" pattern="yyyy.MM.dd" /> ~ 
                                <fmt:formatDate value="${term.endMonthDate}" pattern="yyyy.MM.dd" />
                            </td>
                            <td style="text-align:right; padding-right: 20px;" colspan="1">
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
            </td>
          </tr>
        </table>

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
        	<c:choose> 

		        <c:when test="${confirmDTO.statusCode == 'ST_50' or confirmDTO.statusCode == 'ST_60'}">
		            <a href="${pageContext.request.contextPath}/admin/confirm" class="btn btn-secondary">목록으로</a>
		        </c:when>

		        <c:otherwise>
		            <div style="margin-bottom:15px;">
		                <label><input type="radio" name="judgeOption" value="approve">지급</label>
		                <label style="margin-left:15px;"><input type="radio" name="judgeOption" value="reject">부지급</label>
		            </div>
		            
		            <div id="rejectForm">
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
					
					    <div>
					        <label>상세 사유:</label><br>
					        <input type="text" id="rejectComment" class="form-control" placeholder="상세 사유를 입력하세요" style="width:80%;">
					    </div>
		
					</div>
					
					<div class="judge-actions">
			            <button type="button" id="confirmBtn" class="btn btn-primary">확인</button>
			            <button type="button" id="cancelBtn" class="btn btn-secondary">취소</button>
		            </div>
		            
		            <a href="${pageContext.request.contextPath}/admin/confirm" class="btn btn-secondary">목록</a>
		        </c:otherwise>
    		</c:choose>
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
	    
	 	// 상태 코드에 따른 진행바 길이 조정
	    const progressLine = document.querySelector('.progress-line');
	    let progressWidth = 0;

	    switch ("${confirmDTO.statusCode}") {
	      case "ST_20":
	        progressWidth = 0;
	        break;
	      case "ST_30":
	        progressWidth = 45;
	        break;
	      case "ST_50":
	      case "ST_60":
	        progressWidth = 90;
	        break;
	      default:
	        progressWidth = 0;
	    }

	    progressLine.style.width = progressWidth + "%";

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