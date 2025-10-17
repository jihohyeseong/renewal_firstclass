<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비밀번호 찾기</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        :root { --primary-color: #3f58d4; --white-color: #ffffff; --light-gray-color: #f0f2f5; --gray-color: #888; --dark-gray-color: #333; --border-color: #e0e0e0; }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body, html { height: 100%; font-family: 'Noto Sans KR', sans-serif; background-color: var(--primary-color); overflow-x: hidden; }

        /* --- Background Animation Styles --- */
        .background-wrapper { position: fixed; top: 0; left: 0; width: 100%; height: 100%; z-index: 1; }
        .animation-bg span { position: absolute; bottom: -100px; background-color: rgba(255, 255, 255, 0.15); border-radius: 50%; animation: floatUp 20s linear infinite; }
        .animation-bg span:nth-child(1) { width: 40px; height: 40px; left: 10%; animation-duration: 25s; }
        .animation-bg span:nth-child(2) { width: 20px; height: 20px; left: 20%; animation-duration: 15s; animation-delay: 2s; }
        .animation-bg span:nth-child(3) { width: 60px; height: 60px; left: 35%; animation-duration: 30s; animation-delay: 7s; }
        .animation-bg span:nth-child(4) { width: 30px; height: 30px; left: 50%; animation-duration: 18s; animation-delay: 5s; }
        .waves { position: absolute; bottom: 0; left: 0; width: 100%; height: 150px; }
        .wave { position: absolute; bottom: 0; left: 0; width: 200%; height: 100%; background-repeat: repeat-x; background-position: 0 bottom; }
        .wave1 { background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="rgba(255,255,255,0.2)" fill-opacity="1" d="M0,224L48,213.3C96,203,192,181,288,176C384,171,480,181,576,192C672,203,768,213,864,202.7C960,192,1056,160,1152,149.3C1248,139,1344,149,1392,154.7L1440,160L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>'); animation: wave-animation 15s linear infinite; }
        .wave2 { background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="rgba(255,255,255,0.3)" fill-opacity="1" d="M0,192L48,197.3C96,203,192,213,288,229.3C384,245,480,267,576,250.7C672,235,768,181,864,176C960,171,1056,213,1152,224C1248,235,1344,213,1392,202.7L1440,192L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>'); animation: wave-animation 10s linear infinite reverse; }

        .find-container { position: relative; z-index: 2; display: flex; flex-direction: column; justify-content: center; align-items: center; min-height: 100vh; padding: 40px 20px; }
        .find-header { text-align: center; margin-bottom: 40px; color: var(--white-color); animation: fadeInUp 0.8s ease-out forwards; opacity: 0; }
        .find-header h1 { font-size: 32px; font-weight: 700; margin-bottom: 10px; }
        .find-header p { font-size: 16px; font-weight: 300; opacity: 0.9; }
        .find-form-card { background-color: var(--white-color); border-radius: 12px; box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1); width: 100%; max-width: 450px; padding: 40px; animation: fadeInUp 1s ease-out 0.2s forwards; opacity: 0; }
        .find-form-card h2 { text-align: center; font-size: 22px; font-weight: 700; margin-bottom: 30px; color: var(--dark-gray-color); }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-size: 14px; font-weight: 500; color: var(--dark-gray-color); margin-bottom: 8px; }
        .form-group input { width: 100%; padding: 12px 15px; border: 1px solid var(--border-color); border-radius: 8px; font-size: 16px; }
        .submit-btn { width: 100%; padding: 14px; border: none; border-radius: 8px; font-size: 16px; font-weight: 700; color: var(--white-color); background-color: var(--primary-color); cursor: pointer; }
        .links-wrapper { margin-top: 30px; text-align: center; animation: fadeInUp 1s ease-out 0.4s forwards; opacity: 0; }
        .links-wrapper a { color: rgba(255, 255, 255, 0.8); text-decoration: none; font-size: 14px; margin: 0 10px; }
        
        /* --- [Added] Phone Input Group Styles --- */
        .phone-input-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .phone-input-group input {
            flex: 1;
            text-align: center;
        }
        .phone-input-group span {
            font-size: 16px;
            color: var(--gray-color);
        }

        /* --- Animation Keyframes --- */
        @keyframes wave-animation { from { background-position-x: 0; } to { background-position-x: -1440px; } }
        @keyframes floatUp { from { transform: translateY(0); opacity: 1; } to { transform: translateY(-110vh); opacity: 0; } }
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>
    <div class="background-wrapper">
        <div class="animation-bg">
            <span></span><span></span><span></span><span></span><span></span>
        </div>
        <div class="waves">
            <div class="wave wave1"></div>
            <div class="wave wave2"></div>
        </div>
    </div>

    <div class="find-container">
        <div class="find-header">
            <h1>비밀번호 찾기</h1>
            <p>가입 시 등록한 아이디와 휴대폰 번호를 입력해주세요.</p>
        </div>
        <div class="find-form-card">
            <h2>본인 정보 입력</h2>
            <form id="findPasswordForm" action="${pageContext.request.contextPath}/find/password" method="post">
                <div class="form-group">
                    <label for="username">아이디</label>
                    <input type="text" id="username" name="username" placeholder="아이디를 입력하세요" required>
                </div>
                <div class="form-group">
                    <label for="phone1">휴대폰 번호</label>
                    <div class="phone-input-group">
                        <input type="tel" id="phone1" maxlength="3" required>
                        <span>-</span>
                        <input type="tel" id="phone2" maxlength="4" required>
                        <span>-</span>
                        <input type="tel" id="phone3" maxlength="4" required>
                    </div>
                    <input type="hidden" id="phoneNumber" name="phoneNumber">
                </div>
                <button type="submit" class="submit-btn">비밀번호 찾기</button>
            </form>
        </div>
        <div class="links-wrapper">
            <a href="${pageContext.request.contextPath}/find/account/id">아이디 찾기</a> | <a href="${pageContext.request.contextPath}/login">로그인</a>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(function() {
            $('.phone-input-group input').on('keyup', function() {
                var currentLength = $(this).val().length;
                var maxLength = $(this).attr('maxlength');

                if (currentLength >= maxLength) {
                    $(this).nextAll('input').first().focus();
                }
            });

            $('#findPasswordForm').on('submit', function(e) {
                e.preventDefault();

                var phone1 = $('#phone1').val();
                var phone2 = $('#phone2').val();
                var phone3 = $('#phone3').val();
                
                if (!phone1 || !phone2 || !phone3) {
                    alert('휴대폰 번호를 모두 입력해주세요.');
                    return;
                }

                var fullPhoneNumber = phone1 + "-" + phone2 + "-" + phone3;
                $('#phoneNumber').val(fullPhoneNumber);

                var formData = $(this).serialize();
                var actionUrl = $(this).attr('action');

                $.ajax({
                    type: 'POST',
                    url: actionUrl,
                    data: formData,
                    dataType: 'json',
                    success: function(response) {
                        if (response.success) {
                            alert('본인 인증이 완료되었습니다. 비밀번호 변경 페이지로 이동합니다.');
                            window.location.href = '${pageContext.request.contextPath}' + response.redirectUrl + '?username=' + response.username;
                        } else {
                            alert(response.message);
                        }
                    },
                    error: function() {
                        alert('오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
                    }
                });
            });
        });
    </script>
</body>
</html>