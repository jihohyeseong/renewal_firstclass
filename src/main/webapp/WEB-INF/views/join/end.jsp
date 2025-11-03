<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>개인회원 가입 (4/4) - 가입 완료</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #3f58d4; /* 파란색 계열 유지 */
            --white-color: #ffffff;
            --light-gray-color: #f0f2f5;
            --gray-color: #888;
            --dark-gray-color: #333;
            --border-color: #e0e0e0;
            --success-color-blue: #5cb85c; /* 완료 아이콘 색상을 파란 계열에 맞춰서 변경 */
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        body, html { height: 100%; font-family: 'Noto Sans KR', sans-serif; background-color: var(--light-gray-color); }
        .page-wrapper { padding: 50px 20px; }

        .signup-container {
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
            background-color: var(--white-color);
            padding: 60px 70px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
        }

        .main-title { font-size: 32px; font-weight: 700; color: var(--dark-gray-color); text-align: center; margin-bottom: 50px; }
        
        .progress-stepper { display: flex; justify-content: center; list-style: none; padding: 0; margin-bottom: 60px; }
        .step { flex: 1; padding: 12px; text-align: center; background-color: var(--light-gray-color); color: var(--gray-color); font-weight: 500; font-size: 16px; position: relative; transition: all 0.3s ease; }
        .step:not(:last-child)::after { content: ''; position: absolute; right: -12px; top: 50%; transform: translateY(-50%); width: 0; height: 0; border-top: 22px solid transparent; border-bottom: 22px solid transparent; border-left: 12px solid var(--light-gray-color); z-index: 2; transition: all 0.3s ease; }
        .step.active { background-color: var(--primary-color); color: var(--white-color); }
        .step.active::after { border-left-color: var(--primary-color); }

        .content-box {
            padding: 80px 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
        }

        /* 완료 아이콘 스타일 */
        .completion-icon {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background-color: var(--primary-color); /* Primary color와 일관되게 파란색으로 변경 */
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 30px;
            animation: pop-in 0.5s ease-out forwards;
        }
        .completion-icon::after {
            content: '';
            width: 20px;
            height: 40px;
            border: solid var(--white-color);
            border-width: 0 8px 8px 0;
            transform: rotate(45deg);
        }

        .content-box h2 { font-size: 28px; color: var(--dark-gray-color); margin-bottom: 15px; }
        .content-box p { font-size: 16px; color: var(--gray-color); margin-bottom: 40px; }
        
        .action-buttons { display: flex; justify-content: center; gap: 15px; margin-top: 20px; }
        .btn { padding: 14px 35px; font-size: 16px; font-weight: 500; border-radius: 8px; border: 1px solid var(--border-color); cursor: pointer; transition: all 0.3s ease; text-decoration: none; }
        .btn-primary { background-color: var(--primary-color); color: var(--white-color); border-color: var(--primary-color); }
        .btn-primary:hover { background-color: #364ab1; } /* 호버 색상 변경 */
        .btn-secondary { background-color: var(--white-color); color: var(--dark-gray-color); border-color: var(--dark-gray-color); }
        .btn-secondary:hover { background-color: var(--dark-gray-color); color: var(--white-color); }
        
        @keyframes pop-in {
            0% { transform: scale(0); opacity: 0; }
            80% { transform: scale(1.1); opacity: 1; }
            100% { transform: scale(1); opacity: 1; }
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

            /* [수정] 스텝 텍스트가 2줄이 될 수 있도록 수정된 버전 */
            .step {
                font-size: 13px;
                padding: 10px 5px;      /* 상하 여백 */
                height: auto;           /* 고정 높이 제거 */
                min-height: 40px;     /* 최소 높이 보장 */
                line-height: 1.3;     /* 줄간격 */
                word-break: break-word; /* 자연스러운 줄바꿈 허용 */
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
            
            /* 스텝 화살표와 스텝의 최소 높이를 맞춤 */
            .step:not(:last-child)::before {
                 border-top-width: 20px;
                 border-bottom-width: 20px;
            }

            .content-box {
                padding: 40px 0; /* 상하 여백 축소 */
            }

            .completion-icon {
                width: 70px; /* 아이콘 크기 축소 */
                height: 70px;
            }
            /* 아이콘 내부 체크마크 크기 조절 */
            .completion-icon::after {
                width: 18px;
                height: 36px;
                border-width: 0 7px 7px 0;
            }
            
            .content-box h2 {
                font-size: 22px; /* 완료 타이틀 폰트 축소 */
            }

            .content-box p {
                font-size: 15px; /* 완료 메시지 폰트 축소 */
                margin-bottom: 30px;
            }

            .action-buttons {
                flex-direction: column; /* 버튼 세로로 쌓기 */
                gap: 10px;
                margin-top: 20px;
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
            
            .step {
                font-size: 12px; /* 스텝 폰트 더 축소 */
            }

            .content-box h2 {
                font-size: 20px;
            }
            
            .content-box p {
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
                <div class="step">02. 약관 동의</div>
                <div class="step">03. 정보 입력</div>
                <div class="step active">04. 가입 완료</div>
            </div>

            <div class="content-box">
                <div class="completion-icon"></div>
                <h2>회원가입이 완료되었습니다!</h2>
                <p>가입을 축하합니다. 지금 바로 로그인하여 모든 서비스를 이용해 보세요.</p>
                
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">로그인</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>