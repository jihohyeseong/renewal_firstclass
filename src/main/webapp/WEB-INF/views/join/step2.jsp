<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>개인회원 가입 (2/4) - 약관 동의</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #3f58d4;
            --white-color: #ffffff;
            --light-gray-color: #f0f2f5;
            --gray-color: #888;
            --dark-gray-color: #333;
            --border-color: #e0e0e0;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body, html {
            height: 100%;
            font-family: 'Noto Sans KR', sans-serif;
            background-color: var(--light-gray-color);
        }
        
        .page-wrapper {
            padding: 50px 20px;
        }

        .signup-container {
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
            background-color: var(--white-color);
            padding: 60px 70px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            animation: fadeIn 0.6s ease-in-out;
        }

        .main-title {
            font-size: 32px;
            font-weight: 700;
            color: var(--dark-gray-color);
            text-align: center;
            margin-bottom: 50px;
        }
        
        .progress-stepper {
            display: flex;
            justify-content: center;
            list-style: none;
            padding: 0;
            margin-bottom: 60px;
        }

        .step {
            flex: 1;
            padding: 12px;
            text-align: center;
            background-color: var(--light-gray-color);
            color: var(--gray-color);
            font-weight: 500;
            font-size: 16px;
            position: relative;
            transition: all 0.3s ease;
        }

        .step:not(:last-child)::after {
            content: '';
            position: absolute;
            right: -12px;
            top: 50%;
            transform: translateY(-50%);
            width: 0;
            height: 0;
            border-top: 22px solid transparent;
            border-bottom: 22px solid transparent;
            border-left: 12px solid var(--light-gray-color);
            z-index: 2;
            transition: all 0.3s ease;
        }

        .step.active {
            background-color: var(--primary-color);
            color: var(--white-color);
        }

        .step.active::after {
            border-left-color: var(--primary-color);
        }

        .content-box {
            padding: 40px 0;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .content-box h2 {
            font-size: 24px;
            color: var(--dark-gray-color);
            margin-bottom: 40px;
        }

        /* [추가] 약관 동의 전체 컨테이너 */
        .terms-container {
            width: 100%;
            max-width: 800px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 30px;
        }

        /* [추가] 전체 동의 영역 */
        .agree-all-box {
            display: flex;
            align-items: center;
            padding-bottom: 20px;
            border-bottom: 1px solid var(--border-color);
        }

        .agree-all-box input[type="checkbox"] {
            width: 22px;
            height: 22px;
            margin-right: 12px;
        }

        .agree-all-box label {
            font-size: 18px;
            font-weight: 700;
            color: var(--dark-gray-color);
        }

        /* [추가] 개별 약관 그룹 */
        .terms-group {
            margin-top: 20px;
        }
        
        .terms-header {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }

        .terms-header input[type="checkbox"] {
            width: 18px;
            height: 18px;
            margin-right: 10px;
        }

        .terms-header label {
            font-size: 16px;
            font-weight: 500;
        }

        .terms-header label .required { color: var(--primary-color); }
        .terms-header label .optional { color: var(--gray-color); }

        /* [추가] 약관 내용 스크롤 박스 */
        .term-content {
            height: 120px;
            overflow-y: scroll;
            border: 1px solid #eee;
            background-color: #fcfcfc;
            padding: 15px;
            font-size: 14px;
            color: #666;
            line-height: 1.6;
        }
        
        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 60px;
        }

        .btn {
            padding: 14px 35px;
            font-size: 16px;
            font-weight: 500;
            border-radius: 8px;
            border: 1px solid var(--border-color);
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .btn-primary { background-color: var(--primary-color); color: var(--white-color); border-color: var(--primary-color); }
        .btn-primary:hover { background-color: #364ab1; }
        
        .btn-cancel { background-color: var(--white-color); color: var(--gray-color); }
        .btn-cancel:hover { background-color: var(--light-gray-color); }

        .btn-primary:disabled { background-color: #a0a0a0; border-color: #a0a0a0; cursor: not-allowed; }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        /* ---------------------------------- */
        /* 📱 반응형 스타일 (Tablet & Mobile) */
        /* ---------------------------------- */
        @media (max-width: 768px) {
            .page-wrapper {
                padding: 20px 10px; /* 페이지 전체 여백 축소 */
            }

            .signup-container {
                padding: 40px 20px; /* 컨테이너 내부 여백 축소 */
            }

            .main-title {
                font-size: 26px; /* 메인 타이틀 폰트 축소 */
                margin-bottom: 30px;
            }

            .progress-stepper {
                margin-bottom: 40px;
            }

            /* 768px 미디어 쿼리 내의 .step 규칙을 이걸로 교체하세요 */
            .step {
                font-size: 13px;
                padding: 10px 5px;      /* [수정] 상하 여백을 주어 텍스트를 중앙 정렬 */
                height: auto;           /* [수정] 고정 높이 제거 */
                min-height: 40px;     /* [추가] 화살표 높이(40px)만큼 최소 높이 보장 */
                line-height: 1.3;     /* [추가] 줄바꿈 시를 대비한 줄간격 */
                word-break: break-word; /* [수정] 'keep-all' 대신 자연스러운 줄바꿈 허용 */
                
                /* [추가] 텍스트를 세로/가로 중앙에 배치하기 위해 flex 사용 */
                display: flex;
                align-items: center;
                justify-content: center;
            }

            /* 스텝 화살표 크기 및 위치 조정 */
            .step:not(:last-child)::after {
                border-top-width: 20px;
                border-bottom-width: 20px;
                border-left-width: 10px;
                right: -10px;
            }

            .content-box h2 {
                font-size: 22px; /* 서브 타이틀 폰트 축소 */
                margin-bottom: 30px;
            }

            /* 약관 동의 컨테이너 */
            .terms-container {
                padding: 20px; /* 내부 여백 축소 */
            }

            .agree-all-box label {
                font-size: 17px;
            }

            .terms-header {
                 /* 좁은 화면에서 라벨이 2줄이 될 경우, 
                    체크박스가 첫 번째 줄에 정렬되도록 함 */
                align-items: flex-start;
            }

            .terms-header label {
                font-size: 15px;
                line-height: 1.4; /* 줄바꿈 시 줄간격 확보 */
            }
            
            .term-content {
                font-size: 13px; /* 약관 내용 폰트 축소 */
            }

            /* 하단 버튼 */
            .action-buttons {
                flex-direction: column; /* 버튼 세로로 쌓기 */
                gap: 10px;
                margin-top: 40px;
            }

            .btn {
                width: 100%; /* 버튼 너비를 100%로 설정 */
                padding-top: 16px;
                padding-bottom: 16px;
            }
        }

        /* ---------------------------------- */
        /* 📱 더 작은 화면 (e.g., iPhone SE) */
        /* ---------------------------------- */
        @media (max-width: 375px) {
            .signup-container {
                padding: 30px 15px;
            }

            .main-title {
                font-size: 24px;
            }

            .content-box h2 {
                font-size: 20px;
            }

            .step {
                font-size: 12px; /* 스텝 폰트 더 축소 */
            }

            .terms-container {
                padding: 15px; /* 약관 박스 여백 더 축소 */
            }

            .agree-all-box label {
                font-size: 16px;
            }

            .terms-header label {
                font-size: 14px;
            }
        }
    </style>
</head>
<body>
    <div class="page-wrapper">
        <div class="signup-container">
            <h1 class="main-title">개인회원 가입</h1>

            <div class="progress-stepper">
                <div class="step">01. 본인 확인</div>
                <div class="step active">02. 약관 동의</div>
                <div class="step">03. 정보 입력</div>
                <div class="step">04. 가입 완료</div>
            </div>

            <div class="content-box">
                <h2>약관 동의</h2>
                
                <div class="terms-container">
                    <div class="agree-all-box">
                        <input type="checkbox" id="agreeAll">
                        <label for="agreeAll">모든 약관에 동의합니다.</label>
                    </div>

                    <div class="terms-group">
                        <div class="terms-header">
                            <input type="checkbox" id="termsService" class="required-term">
                            <label for="termsService">육아휴직 정보 서비스 이용약관 <span class="required">(필수)</span></label>
                        </div>
                        <div class="term-content">
                            제1조 (목적) 이 약관은 회원이 제공하는 육아휴직 관련 정보 서비스를 이용함에 있어 회사와 회원의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.<br><br>
                            제2조 (정의) '서비스'란 회사가 회원에게 온라인으로 제공하는 육아휴직 급여 계산기, 관련 정책 정보, 커뮤니티 기능 등을 의미합니다. '회원'이란 회사에 개인정보를 제공하여 회원등록을 한 자로서, 회사의 정보를 지속적으로 제공받으며, 회사가 제공하는 서비스를 계속적으로 이용할 수 있는 자를 말합니다.<br><br>
                            제3조 (약관의 명시와 개정) 회사는 이 약관의 내용을 회원이 쉽게 알 수 있도록 서비스 초기 화면에 게시합니다. 회사는 '약관의 규제에 관한 법률' 등 관련 법을 위배하지 않는 범위에서 이 약관을 개정할 수 있습니다.
                        </div>
                    </div>

                    <div class="terms-group">
                        <div class="terms-header">
                            <input type="checkbox" id="termsMarketing" class="optional-term">
                            <label for="termsMarketing">마케팅 정보 수신 동의 <span class="optional">(선택)</span></label>
                        </div>
                        <div class="term-content">
                            제1조 (목적) 본 약관은 회원이 제공하는 육아휴직 관련 서비스의 마케팅 정보를 수신하는 데 동의하는 경우, 정보의 종류와 수신 방법에 대해 규정하는 것을 목적으로 합니다.<br><br>
                            제2조 (정보의 종류) 회사는 이메일, SMS, 앱 푸시 알림 등을 통해 신규 서비스 안내, 이벤트 정보, 제휴사 혜택 등 유용한 정보를 발송할 수 있습니다. 수신을 원치 않으실 경우 언제든지 '마이페이지'에서 수신 거부로 변경할 수 있습니다.<br><br>
                            제3조 (동의 철회) 회원은 언제든지 마케팅 정보 수신 동의를 철회할 수 있으며, 동의를 철회하더라도 기본 서비스 이용에는 아무런 제한이 없습니다.
                        </div>
                    </div>
                </div>
            </div>

            <div class="action-buttons">
                <button type="button" class="btn btn-cancel" onclick="location.href='${pageContext.request.contextPath}/login'">취소</button>
                <button type="button" class="btn btn-primary btn-next" onclick="location.href='${pageContext.request.contextPath}/join/individual/3'" disabled>다음</button>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const agreeAllCheckbox = document.getElementById('agreeAll');
            const requiredCheckboxes = document.querySelectorAll('.required-term');
            const allTermCheckboxes = document.querySelectorAll('.terms-group input[type="checkbox"]');
            const nextButton = document.querySelector('.btn-next');

            // '다음' 버튼 상태를 업데이트하는 함수
            function updateNextButtonState() {
                let allRequiredChecked = true;
                requiredCheckboxes.forEach(function(checkbox) {
                    if (!checkbox.checked) {
                        allRequiredChecked = false;
                    }
                });
                nextButton.disabled = !allRequiredChecked;
            }

            // '전체 동의' 체크박스 클릭 이벤트
            agreeAllCheckbox.addEventListener('change', function() {
                allTermCheckboxes.forEach(function(checkbox) {
                    checkbox.checked = agreeAllCheckbox.checked;
                });
                updateNextButtonState();
            });

            // 개별 약관 체크박스 클릭 이벤트
            allTermCheckboxes.forEach(function(checkbox) {
                checkbox.addEventListener('change', function() {
                    let allChecked = true;
                    allTermCheckboxes.forEach(function(cb) {
                        if (!cb.checked) {
                            allChecked = false;
                        }
                    });
                    agreeAllCheckbox.checked = allChecked;
                    updateNextButtonState();
                });
            });

            // 페이지 로드 시 초기 버튼 상태 설정
            updateNextButtonState();
        });
    </script>
</body>
</html>