<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>기업회원 가입 (1/4) - 사업자 확인</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #24A960;
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
            min-height: 300px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .content-box h2 {
            font-size: 24px;
            color: var(--dark-gray-color);
            margin-bottom: 20px;
            animation: fadeInUp 0.5s ease-out forwards;
            opacity: 0;
        }

        .auth-description {
            font-size: 16px;
            color: var(--gray-color);
            text-align: center;
            margin-bottom: 40px;
            line-height: 1.6;
            animation: fadeInUp 0.5s ease-out forwards;
            opacity: 0;
            animation-delay: 0.1s;
        }
        
        .auth-consent {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-top: 20px;
            padding: 25px 30px;
            background-color: #f9f9fb;
            border-radius: 8px;
            border: 1px solid var(--border-color);
            opacity: 0;
            animation: fadeInUp 0.5s ease-out forwards;
            animation-delay: 0.2s;
            width: 100%;
            max-width: 500px;
        }

        .auth-consent input[type="checkbox"] {
            width: 20px;
            height: 20px;
            margin-right: 12px;
            cursor: pointer;
            accent-color: var(--primary-color); /* ✨ This line was added */
        }

        .auth-consent label {
            font-size: 16px;
            font-weight: 500;
            color: var(--dark-gray-color);
            cursor: pointer;
            margin: 0;
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
        .btn-primary:hover { background-color: #1f8f50; }
        
        .btn-cancel { background-color: var(--white-color); color: var(--gray-color); }
        .btn-cancel:hover { background-color: var(--light-gray-color); }

        .btn-primary:disabled { background-color: #a0a0a0; border-color: #a0a0a0; cursor: not-allowed; }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        /* ---------------------------------- */
        /* 📱 반응형 스타일 (Mobile) */
        /* ---------------------------------- */
        @media (max-width: 768px) {
            .page-wrapper {
                padding: 20px 10px; /* 페이지 전체 여백 축소 */
            }

            .signup-container {
                padding: 40px 20px; /* 컨테이너 내부 여백 축소 */
            }

            .main-title {
                font-size: 26px; /* 메인 타이틀 폰트 크기 축소 */
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

            .content-box {
                padding: 20px 0;
            }
            
            .content-box h2 {
                font-size: 22px; /* 서브 타이틀 폰트 크기 축소 */
            }

            .auth-description {
                font-size: 15px;
                margin-bottom: 30px;
            }

            .auth-consent {
                padding: 20px; /* 동의 박스 여백 축소 */
                /* 체크박스와 라벨을 세로로 쌓음 */
                flex-direction: column; 
                text-align: center;
            }

            .auth-consent input[type="checkbox"] {
                width: 18px;
                height: 18px;
                margin-right: 0; /* 오른쪽 여백 제거 */
                margin-bottom: 12px; /* 아래쪽 여백 추가 */
            }

            .auth-consent label {
                font-size: 15px;
            }

            .action-buttons {
                /* 버튼을 세로로 쌓기 */
                flex-direction: column; 
                gap: 10px;
                margin-top: 40px;
            }

            .btn {
                width: 100%; /* 버튼 너비를 100%로 설정 */
                padding-top: 16px; /* 터치하기 쉽도록 버튼 패딩 증가 */
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

            .auth-consent label {
                font-size: 14px;
            }
        }
    </style>
</head>
<body>
    <div class="page-wrapper">
        <div class="signup-container">
            <h1 class="main-title">기업회원 가입</h1>

            <div class="progress-stepper">
                <div class="step active">01. 사업자 확인</div>
                <div class="step">02. 약관 동의</div>
                <div class="step">03. 정보 입력</div>
                <div class="step">04. 가입 완료</div>
            </div>

            <div class="content-box">
                <h2>사업자 확인</h2>
                <p class="auth-description">
                    정확한 기업 정보 확인을 위해 사업자 확인이 필요합니다.<br>
                    본 프로젝트에서는 인증 절차를 생략하고, 아래 확인 동의로 대체합니다.
                </p>
                <div class="auth-consent">
                    <input type="checkbox" id="businessAuthCheck" name="businessAuthCheck">
                    <label for="businessAuthCheck">사업자 정보를 확인하였으며, 회원가입에 동의합니다.</label>
                </div>
            </div>

            <div class="action-buttons">
			    <button type="button" class="btn btn-cancel" onclick="location.href='${pageContext.request.contextPath}/login'">취소</button>
			    <button type="button" class="btn btn-primary btn-next" onclick="location.href='${pageContext.request.contextPath}/join/corp/2'" disabled>다음</button>
			</div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const businessAuthCheckbox = document.getElementById('businessAuthCheck');
            const nextButton = document.querySelector('.btn-next');

            businessAuthCheckbox.addEventListener('change', function() {
                nextButton.disabled = !this.checked;
            });
        });
    </script>
</body>
</html>