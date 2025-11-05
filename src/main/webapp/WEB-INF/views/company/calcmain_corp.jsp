<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>육아휴직 서비스 - 급여 모의계산</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <%-- global.css는 comp.css가 이미 포함하고 있다면 생략 가능 --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/global.css"> 
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/comp.css">
    
    <style>
        /* --- [수정] 테마 색상 (녹색 계열) --- */
        :root {
            --primary-color: #24A960; /* [수정] 메인 녹색 */
            --primary-color-dark: #1F8A4D; /* [수정] 더 어두운 녹색 */
            --primary-color-light: #f0f9f3; /* [수정] 아주 연한 녹색 */
            
            --status-approved: #24A960; /* [수정] 승인 (메인 녹색) */
            --status-pending: #f59e0b;  /* 대기 (황색) */
            --status-rejected: #ef4444; /* 반려 (적색) */
            
            --text-color: #333;
            --text-color-light: #555;
            --border-color: #e0e0e0;
            --bg-color-soft: #f9fafb; /* 연한 회색 배경 */
            --white: #ffffff;

            /* comp.css의 변수도 녹색으로 덮어쓰기 */
            --primary-light-color: #f0f9f3; /* [수정] */
            --gray-color: #868e96;
            --dark-gray-color: #343a40;
            --light-gray-color: #f8f9fa;
        }

        /* --- [추가] body 스타일 (첫 번째 JSP와 동일하게) --- */
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: var(--bg-color-soft); /* 전체 페이지 배경색 */
            color: var(--text-color);
            line-height: 1.6;
        }
        
        /* --- [신규] main-container (myList.jsp와 동일하게) --- */
        .main-container {
            max-width: 1100px;
            margin: 20px auto;
            padding: 0 20px;
        }

        /* [수정됨] content-wrapper를 카드 대신 컨테이너로 사용 */
        .content-wrapper {
            background: none;
            border: none;
            box-shadow: none;
            padding: 0;
            margin-top: 0px; /* .notice-box와의 간격 */
        }

        /* --- [신규] 안내 상자 (첫 번째 JSP에서 복사) --- */
        .notice-box { 
            background-color: var(--primary-color-light); 
            border: 1px solid var(--primary-color); 
            border-left-width: 5px; 
            border-radius: 8px; 
            padding: 20px; 
        }
        .notice-box .title { 
            display: flex; 
            align-items: center; 
            font-size: 18px; 
            font-weight: 700; 
            color: var(--primary-color-dark); 
            margin-bottom: 12px; 
        }
        .notice-box .title .fa-solid { 
            margin-right: 10px; 
            font-size: 20px; 
        }
        .notice-box ul { 
            margin: 0; 
            padding-left: 20px; 
            color: var(--text-color-light); 
            font-size: 14px; 
        }
        .notice-box li { margin-bottom: 6px; }
        .notice-box li:last-child { margin-bottom: 0; }


        /* --- [신규] 카드 내부 헤더 (첫 번째 JSP에서 복사) --- */
        .content-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 16px;
        }
        .content-header h2 {
            margin: 0;
            color: #111;
            font-size: 24px;
            font-weight: 700;
        }
        /* 아이콘 색상 강제 지정 (comp.css 오버라이드 대비) */
         .content-header h2 .fa-solid {
             color: var(--primary-color);
         }


        /* [수정됨] 두 개의 카드를 담을 flex 컨테이너 설정 */
        .calculator-container {
            display: flex;
            align-items: flex-start;
            gap: 30px; /* 카드 사이의 간격 */
        }
        
        /* [수정됨] 왼쪽 입력창을 카드로 스타일링 */
        .input-panel {
            flex: 1 1 100%; /* 초기 상태: 너비 100% */
            background-color: var(--white);
            padding: 24px 30px; /* [수정] myList.jsp와 동일한 패딩 */
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            transition: flex-basis 0.6s cubic-bezier(0.4, 0, 0.2, 1); 
        }

        /* [수정됨] 오른쪽 결과 카드의 초기 상태 (완전히 숨겨짐) */
        .result-panel {
            flex-basis: 0; /* 너비 0 */
            opacity: 0;    /* 투명 */
            overflow: hidden;
            padding: 24px 0; /* [수정] 상하 패딩 24px, 좌우 0 */
            margin-left: -30px; 
            
            /* 카드 스타일 적용 */
            background-color: var(--white);
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            
            /* 부드러운 등장 애니메이션 설정 */
            transition: flex-basis 0.6s cubic-bezier(0.4, 0, 0.2, 1),
                        opacity 0.4s 0.2s ease,
                        padding 0.6s cubic-bezier(0.4, 0, 0.2, 1),
                        margin-left 0.6s cubic-bezier(0.4, 0, 0.2, 1);
        }

        /* --- [수정됨] 계산하기 버튼 클릭 후의 상태 --- */
        
        .calculator-container.results-shown .input-panel {
            flex-basis: 48%; /* 왼쪽 카드가 줄어듦 */
        }
        
        .calculator-container.results-shown .result-panel {
            flex-basis: 48%; /* 오른쪽 카드가 나타나며 공간 차지 */
            opacity: 1;
            padding: 24px 30px; /* [수정] myList.jsp와 동일한 패딩 */
            margin-left: 0;  /* 원래 간격으로 복원 */
        }
        
        /* --- 기존 스타일 유지 --- */
        .result-placeholder {
            text-align: center;
            color: var(--gray-color, #868e96);
            padding: 20px 0; 
        }
        .result-placeholder .icon {
            font-size: 48px;
            margin-bottom: 15px;
            color: var(--primary-light-color);
        }
        
        .input-group { margin-bottom: 20px; }
        
        /* [수정] 라벨 스타일 (mypage.jsp와 동일하게) */
        .input-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #495057;
            position: relative; /* ::before 포지셔닝 기준 */
            padding-left: 12px; /* 바가 들어갈 공간 확보 */
        }
        /* [신규] 라벨 왼쪽 파란색 바 */
        .input-group label::before {
            content: '';
            position: absolute;
            left: 0;
            top: 50%;
            transform: translateY(-50%);
            width: 4px;
            height: 16px; 
            background-color: var(--primary-color);
            border-radius: 2px;
        }

        .input-group input[type="date"], .input-group input[type="text"] {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid var(--border-color, #dee2e6);
            border-radius: 8px;
            font-size: 16px;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .input-group input:focus {
            outline: none;
            border-color: var(--primary-color, #3f58d4);
            box-shadow: 0 0 0 3px var(--primary-light-color);
        }
        .button-group {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 10px;
            margin-top: 30px;
        }
        .button-group button {
            padding: 14px 20px;
            border-radius: 8px;
            font-weight: 700;
            font-size: 16px;
        }
        #calculate-btn {
            background-color: var(--primary-color, #3f58d4);
            color: white;
            border: none;
        }
        #reset-btn {
            background-color: transparent;
            color: var(--dark-gray-color, #343a40);
            border: 1px solid var(--border-color, #dee2e6);
        }
        #result-table { width: 100%; border-collapse: collapse; }
        #result-table caption {
            font-size: 1.5rem;
            font-weight: 700;
            text-align: left;
            margin-bottom: 20px;
            color: var(--primary-color, #3f58d4);
        }
        #result-table th, #result-table td {
            border-bottom: 1px solid var(--border-color, #dee2e6);
            padding: 16px;
            text-align: center;
        }
        #result-table thead th {
            background-color: var(--light-gray-color, #f8f9fa);
            font-weight: 500;
            color: var(--gray-color, #868e96);
            font-size: 14px;
        }
        #result-table tbody td:first-child { font-weight: 500; }
        #result-table tfoot td {
            font-weight: 700;
            font-size: 1.1rem;
            color: var(--dark-gray-color, #343a40);
        }
        #result-table tfoot #totalAmount {
            color: var(--primary-color, #3f58d4);
            font-size: 1.25rem;
        }
        .note {
            color: #e63946;
            margin-top: 15px;
            font-size: 0.9rem;
            text-align: left;
            width: 100%;
        }
        .footer {
           text-align: center;
           padding: 20px 0;
           font-size: 14px;
           color: var(--gray-color);
           margin-top: 20px;
        }

        /* ---------------------------------- */
        /* 📱 [수정] 반응형 스타일 */
        /* ---------------------------------- */

        /* 992px 이하 (태블릿 및 모바일 공통) */
        @media (max-width: 992px) {
            .calculator-container {
                flex-direction: column; /* [수정] 세로로 쌓기 */
                gap: 0; /* [수정] 갭은 margin-top으로 개별 제어 */
            }

            /* [수정] 입력 패널은 항상 100% */
            .input-panel,
            .calculator-container.results-shown .input-panel {
                flex-basis: 100%;
                width: 100%;
            }

            /* [수정] 결과 패널의 애니메이션을 'slide-down'으로 변경 */
            .result-panel {
                flex-basis: auto; /* flex-basis: 0 대신 auto로 변경 */
                width: 100%;
                max-height: 0;  /* [추가] 높이 0으로 숨김 */
                opacity: 0;
                overflow: hidden;
                padding: 0 30px; /* [수정] 상하 패딩 0, 좌우는 유지 */
                margin-left: 0;  /* [수정] */
                margin-top: 0;    /* [추가] */
                
                /* [수정] 트랜지션 대상 변경 */
                transition: max-height 0.6s cubic-bezier(0.4, 0, 0.2, 1),
                            opacity 0.4s 0.2s ease,
                            padding 0.6s cubic-bezier(0.4, 0, 0.2, 1),
                            margin-top 0.6s cubic-bezier(0.4, 0, 0.2, 1);
            }

            /* [수정] 결과 패널이 나타날 때 (slide-down) */
            .calculator-container.results-shown .result-panel {
                flex-basis: auto;
                max-height: 2000px; /* [수정] 충분한 높이 부여 */
                opacity: 1;
                padding: 30px;      /* [수정] 패딩 복원 */
                margin-top: 30px; /* [수정] gap 대신 margin으로 간격 부여 */
            }
            
            /* [참고] 모바일 패딩은 768px 블록에서 덮어씁니다. */
        }

        /* 768px 이하 (모바일 화면) */
        @media (max-width: 768px) {
            /* --- [신규] main-container 반응형 (myList.jsp와 동일하게) --- */
            .main-container {
                margin: 10px auto; /* 상하 여백 축소 */
                padding: 0 10px; /* 좌우 여백 축소 */
            }
        
            /* [수정] 카드 내부 패딩 (myList.jsp와 동일하게) */
            .input-panel,
            .calculator-container.results-shown .result-panel {
                padding: 20px 15px;
            }

            /* [수정] 결과 패널(숨김)의 애니메이션 기준 패딩 */
            .result-panel {
                 padding: 0 15px;
            }

            /* [추가] 안내 박스 패딩 축소 */
            .notice-box {
                padding: 15px;
            }
            .notice-box .title {
                font-size: 17px;
            }
            .notice-box ul {
                font-size: 13px;
                padding-left: 18px;
            }

            /* [추가] 카드 내부 제목 */
            .content-header {
                padding-bottom: 16px;
                margin-bottom: 20px;
            }
            .content-header h2 {
                font-size: 22px;
            }

            /* [추가] 버튼을 세로로 쌓기 */
            .button-group {
                grid-template-columns: 1fr; /* 1열로 변경 */
                gap: 15px;
            }

            /* [추가] 테이블 셀 패딩/폰트 축소 */
            #result-table th, 
            #result-table td {
                padding: 12px 8px;
                font-size: 14px;
            }
            #result-table caption { font-size: 1.2rem; }
            #result-table tfoot td { font-size: 1rem; }
            
            /* [추가] 모바일에서 날짜/월급 입력 폰트 크기 강제 (iOS 확대 방지) */
            .input-group input[type="date"], 
            .input-group input[type="text"] {
                font-size: 16px; /* 16px 미만이면 iOS에서 자동 줌인됨 */
            }
        }
        
        /* 480px 이하 */
        @media (max-width: 480px) {
             /* [수정] 카드 내부 패딩 (myList.jsp와 동일하게) */
             .input-panel,
             .calculator-container.results-shown .result-panel {
                padding: 15px;
             }
             .result-panel { /* 숨김 상태 */
                 padding: 0 15px;
             }
             
             .content-header h2 {
                font-size: 20px;
             }
        }

        /* [수정] btn-secondary:hover 색상 변경 (녹색) */
        .btn-secondary:hover {
            /* #24A960의 rgb(36, 169, 96) 버전에 투명도 0.08 적용 */
            background-color: rgba(36, 169, 96, 0.08);
        }
    </style>
</head>
<body>

    <%@ include file="compheader.jsp" %>

    <main class="main-container">
    
        <div class="notice-box"> 
            <div class="title">
                <i class="fa-solid fa-circle-info"></i>
                <span>모의계산 안내</span>
            </div>
            <ul>
                <li>본 계산은 사용자가 입력한 값을 토대로 계산되므로 실제 수급액과 차이가 있을 수 있습니다.</li>
                <li>통상임금은 세전 금액을 기준으로 입력해주세요.</li>
                <li>정확한 내용은 가까운 고용센터로 문의하시기 바랍니다.</li>
            </ul>
        </div>
        
        <div class="content-wrapper">
            
            <div class="calculator-container" id="calculator-container">

                <div class="input-panel">
                
                    <div class="content-header">
                        <h2><i class="fa-solid fa-calculator"></i> 육아휴직 급여 모의계산</h2>
                    </div>
                    
                    <div class="input-group">
                        <label for="startDate">휴직 시작일</label> 
                        <input type="date" id="startDate" required>
                    </div>
                    <div class="input-group">
                        <label for="endDate">휴직 종료일</label> 
                        <input type="date" id="endDate" required>
                    </div>
                    <div class="input-group">
                        <label for="salary">통상임금 (월)</label> 
                        <input type="text" id="salary" inputmode="numeric" required placeholder="예: 3,000,000">
                    </div>
                    <div class="button-group">
                        <button id="reset-btn" class="btn btn-secondary" onclick="resetForm()">초기화</button>
                        <button id="calculate-btn" class="btn btn-primary" onclick="calculateLeaveBenefit()">계산하기</button>
                    </div>
                </div>

                <div class="result-panel" id="result-panel">
                    <div class="result-placeholder" id="result-placeholder">
                        <div class="icon">📊</div>
                        <h4>계산 결과를 기다리고 있어요.</h4>
                        <p>정보를 입력하고 [계산하기] 버튼을 눌러주세요.</p>
                    </div>

                    <div id="result-section" style="display: none; width: 100%;">
                        <table id="result-table">
                            <caption>육아휴직 급여 계산 결과</caption>
                            <thead>
                                <tr>
                                    <th>개월차 및 기간</th>
                                    <th>예상 지급액</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <td>총합</td>
                                    <td id="totalAmount"></td>
                                </tr>
                            </tfoot>
                        </table>
                        <p class="note">(*) 괄호 안 금액은 복직 6개월 후 지급되는 사후지급금액입니다.</p>
                    </div>
                </div>

            </div>
        </div>
    </main>
    
    <footer class="footer">
        <p>&copy; 2025 육아휴직 서비스. All Rights Reserved.</p>
    </footer>

    <script>
        // (JavaScript 코드는 기존과 동일합니다. 수정 없음)
        const calculatorContainer = document.getElementById("calculator-container");
        const startDateInput = document.getElementById("startDate");
        const endDateInput = document.getElementById("endDate");
        const salaryInput = document.getElementById("salary");
        const resultPanel = document.getElementById("result-panel");
        const resultPlaceholder = document.getElementById("result-placeholder");
        const resultSection = document.getElementById("result-section");
        const resultTbody = document.querySelector("#result-table tbody");
        const totalAmount = document.getElementById("totalAmount");
        
        salaryInput.addEventListener('input', function(e) {
            let value = e.target.value.replace(/[^\d]/g, '');
            e.target.value = value ? parseInt(value, 10).toLocaleString('ko-KR') : '';
        });
        
        const formatCurrency = function(number) {
            if (isNaN(number)) return '0';
            const flooredToTen = Math.floor(number / 10) * 10;
            return flooredToTen.toLocaleString('ko-KR');
        };

        const formatDate = function(date) {
            const y = date.getFullYear();
            const m = String(date.getMonth() + 1).padStart(2, '0');
            const d = String(date.getDate()).padStart(2, '0');
            return y + '.' + m + '.' + d;
        };

        function getPeriodEndDate(originalStart, periodNumber) {
            let nextPeriodStart = new Date(
                originalStart.getFullYear(),
                originalStart.getMonth() + periodNumber,
                originalStart.getDate()
            );

            if (nextPeriodStart.getDate() !== originalStart.getDate()) {
                nextPeriodStart = new Date(
                    originalStart.getFullYear(),
                    originalStart.getMonth() + periodNumber + 1,
                    1
                );
            }
            
            nextPeriodStart.setDate(nextPeriodStart.getDate() - 1);
            return nextPeriodStart;
        }

        function splitPeriodsAndCalc(startDateStr, endDateStr, regularWage) {
            const results = [];
            const originalStartDate = new Date(startDateStr);
            let currentPeriodStart = new Date(originalStartDate);
            const finalEndDate = new Date(endDateStr);
            let monthIdx = 1;

            while (currentPeriodStart <= finalEndDate && monthIdx <= 12) {
                const theoreticalEndDate = getPeriodEndDate(originalStartDate, monthIdx);
                let actualPeriodEnd = new Date(theoreticalEndDate);
                if (actualPeriodEnd > finalEndDate) {
                    actualPeriodEnd = new Date(finalEndDate);
                }
                
                if (currentPeriodStart > actualPeriodEnd) {
                    break;
                }

                const govBase = computeGovBase(regularWage, monthIdx);
                const govPayment = calcGovPayment(govBase, currentPeriodStart, actualPeriodEnd, theoreticalEndDate);

                results.push({
                    month: monthIdx,
                    startDate: new Date(currentPeriodStart),
                    endDate: new Date(actualPeriodEnd),
                    govPayment: govPayment
                });

                currentPeriodStart = new Date(actualPeriodEnd);
                currentPeriodStart.setDate(currentPeriodStart.getDate() + 1);
                
                monthIdx++;
            }
            return results;
        }

        function computeGovBase(regularWage, monthIdx) {
            if (monthIdx <= 3) return Math.min(regularWage, 2500000);
            if (monthIdx <= 6) return Math.min(regularWage, 2000000);
            const eighty = Math.round(regularWage * 0.8);
            return Math.min(eighty, 1600000);
        }
        
        function calcGovPayment(base, startDate, endDate, theoreticalFullEndDate) {
            const getDaysBetween = (d1, d2) => Math.round((d2.getTime() - d1.getTime()) / (1000 * 60 * 60 * 24)) + 1;
            
            const daysInTerm = getDaysBetween(startDate, endDate);
            
            let theoreticalFullStartDate = new Date(startDate);
            const daysInFullMonth = getDaysBetween(theoreticalFullStartDate, theoreticalFullEndDate);
        
            if (daysInTerm >= daysInFullMonth) {
                return base;
            }
            
            const ratio = daysInTerm / daysInFullMonth;
            return Math.floor(base * ratio);
        }

        function getRawLeaveMonths(start, end) {
            const startDate = new Date(start);
            const endDate = new Date(end);
            let months = (endDate.getFullYear() - startDate.getFullYear()) * 12 - startDate.getMonth() + endDate.getMonth();
            if (endDate.getDate() >= startDate.getDate()) months++;
            return months;
        }

        function calculateLeaveBenefit() {
            const salary = parseInt(salaryInput.value.replace(/,/g, ''), 10);
            
            if (!startDateInput.value || !endDateInput.value || !salaryInput.value) {
                alert("휴직 시작일, 종료일, 통상임금을 모두 입력해주세요.");
                return;
            }
            if (new Date(startDateInput.value) >= new Date(endDateInput.value)) {
                alert("휴직 종료일은 시작일보다 이후여야 합니다.");
                return;
            }
            if (isNaN(salary) || salary <= 0) {
                alert("통상임금은 유효한 숫자만 입력해주세요.");
                return;
            }
            
            const rawMonths = getRawLeaveMonths(startDateInput.value, endDateInput.value);
            if (rawMonths > 12) {
                alert("휴직 기간은 최대 12개월까지 선택할 수 있습니다.");
                return;
            }

            const terms = splitPeriodsAndCalc(startDateInput.value, endDateInput.value, salary);

            resultTbody.innerHTML = "";
            let total = 0;

            terms.forEach(term => {
                total += term.govPayment;
                const row = resultTbody.insertRow();
                
                const monthCell = row.insertCell();
                monthCell.innerHTML = term.month + '개월차' +
                    '<br><span style="font-size: 0.8em; color: var(--gray-color);">' +
                    formatDate(term.startDate) + ' ~ ' + formatDate(term.endDate) +
                    '</span>';

                const payCell = row.insertCell();
                payCell.innerHTML = formatCurrency(term.govPayment) + '원' + 
                    '<br><span style="font-size: 0.8em; color: var(--gray-color);">(사후지급금: 0원)</span>';
            });

            totalAmount.innerHTML = formatCurrency(total) + '원' +
                '<br><span style="font-size: 0.8em; color: var(--gray-color);">(총 사후지급금: 0원)</span>';
            
            calculatorContainer.classList.add('results-shown');
            resultPlaceholder.style.display = 'none';
            resultSection.style.display = 'block';
        }
        
        function resetForm() {
            startDateInput.value = '';
            endDateInput.value = '';
            salaryInput.value = '';
            
            calculatorContainer.classList.remove('results-shown');
            
            // 애니메이션이 끝난 후 내용을 숨겨서 깜빡임을 방지합니다.
            setTimeout(function() {
                if (!calculatorContainer.classList.contains('results-shown')) {
                    resultSection.style.display = 'none';
                    resultPlaceholder.style.display = 'block';
                    resultTbody.innerHTML = '';
                    totalAmount.textContent = '';
                }
            }, 600);
        }
    </script>
</body>
</html>