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