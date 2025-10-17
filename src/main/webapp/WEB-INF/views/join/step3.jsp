<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- ▼▼▼ JSTL 사용을 위한 태그 라이브러리 추가 ▼▼▼ --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>개인회원 가입 (3/4) - 정보 입력</title>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    
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
            --success-color: #28a745;
            --error-color: #dc3545;
        }
        /* (스타일 코드는 이전과 동일) */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body, html { height: 100%; font-family: 'Noto Sans KR', sans-serif; background-color: var(--light-gray-color); }
        .page-wrapper { padding: 50px 20px; }
        .signup-container { width: 100%; max-width: 1200px; margin: 0 auto; background-color: var(--white-color); padding: 60px 70px; border: 1px solid var(--border-color); border-radius: 8px; }
        .main-title { font-size: 32px; font-weight: 700; color: var(--dark-gray-color); text-align: center; margin-bottom: 50px; }
        .progress-stepper { display: flex; justify-content: center; list-style: none; padding: 0; margin-bottom: 60px; }
        .step { flex: 1; padding: 12px; text-align: center; background-color: var(--light-gray-color); color: var(--gray-color); font-weight: 500; font-size: 16px; position: relative; transition: all 0.3s ease; }
        .step:not(:last-child)::after { content: ''; position: absolute; right: -12px; top: 50%; transform: translateY(-50%); width: 0; height: 0; border-top: 22px solid transparent; border-bottom: 22px solid transparent; border-left: 12px solid var(--light-gray-color); z-index: 2; transition: all 0.3s ease; }
        .step.active { background-color: var(--primary-color); color: var(--white-color); }
        .step.active::after { border-left-color: var(--primary-color); }
        .content-box { padding: 40px 0; display: flex; flex-direction: column; align-items: center; }
        .content-box h2 { font-size: 24px; color: var(--dark-gray-color); margin-bottom: 40px; }
        .info-form { width: 100%; max-width: 550px; }
        .form-group { margin-bottom: 25px; }
        .form-group label { display: block; font-size: 16px; font-weight: 500; color: var(--dark-gray-color); margin-bottom: 8px; }
        .form-group input { width: 100%; padding: 12px 14px; font-size: 16px; border: 1px solid var(--border-color); border-radius: 6px; }
        .form-group input:focus { outline: none; border-color: var(--primary-color); box-shadow: 0 0 0 2px rgba(63, 88, 212, 0.15); }
        .input-group { display: flex; gap: 10px; }
        .input-group input { flex: 1; }
        .input-group .btn-sm { padding: 0 20px; font-size: 14px; background-color: var(--dark-gray-color); color: var(--white-color); border: none; border-radius: 6px; cursor: pointer; }
        .rrn-inputs { display: flex; align-items: center; gap: 10px; }
        .rrn-inputs .hyphen { font-size: 16px; color: var(--gray-color); }
        .message { font-size: 13px; margin-top: 8px; }
        .message.success { color: var(--success-color); }
        .message.error { color: var(--error-color); }
        .action-buttons { display: flex; justify-content: center; gap: 15px; margin-top: 40px; }
        .btn { padding: 14px 35px; font-size: 16px; font-weight: 500; border-radius: 8px; border: 1px solid var(--border-color); cursor: pointer; transition: all 0.3s ease; }
        .btn-primary { background-color: var(--primary-color); color: var(--white-color); border-color: var(--primary-color); }
        .btn-primary:hover { background-color: #364ab1; }
        .btn-cancel { background-color: var(--white-color); color: var(--gray-color); }
        .btn-cancel:hover { background-color: var(--light-gray-color); }
        .btn-primary:disabled { background-color: #a0a0a0; border-color: #a0a0a0; cursor: not-allowed; }
    </style>
</head>
<body>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

    <div class="page-wrapper">
        <div class="signup-container">
            <h1 class="main-title">개인회원 가입</h1>

            <div class="progress-stepper">
                <div class="step">01. 본인 확인</div>
                <div class="step">02. 약관 동의</div>
                <div class="step active">03. 정보 입력</div>
                <div class="step">04. 가입 완료</div>
            </div>

            <div class="content-box">
                <h2>정보 입력</h2>
                <form class="info-form" action="${pageContext.request.contextPath}/joinProc" method="post">
                    <div class="form-group">
                        <label for="name">이름</label>
                        <input type="text" id="name" name="name" value="${joinDTO.name}" required>
                        <c:if test="${not empty errors.name}">
                            <p class="message error">${errors.name}</p>
                        </c:if>
                    </div>

                    <div class="form-group">
                        <label for="rrn1">주민등록번호</label>
                        <div class="rrn-inputs">
                            <input type="text" id="rrn1" maxlength="6" required>
                            <span class="hyphen">-</span>
                            <input type="password" id="rrn2" maxlength="7" required>
                        </div>
                        <c:if test="${not empty errors.registrationNumber}">
                            <p class="message error">${errors.registrationNumber}</p>
                        </c:if>
                    </div>

                    <div class="form-group">
                        <label for="userId">아이디</label>
                        <div class="input-group">
                            <input type="text" id="userId" name="username" value="${joinDTO.username}" required>
                            <button type="button" class="btn-sm" id="idCheckBtn">중복 확인</button>
                        </div>
                        <c:if test="${not empty errors.username}">
                            <p class="message error">${errors.username}</p>
                        </c:if>
                        <c:if test="${not empty idDuplicate}">
                            <p class="message error">${idDuplicate}</p>
                        </c:if>
                        <p class="message" id="idCheckMessage"></p>
                    </div>
                    <div class="form-group">
                        <label for="password">비밀번호</label>
                        <input type="password" id="password" name="password" value="${joinDTO.password}" required>
                        <c:if test="${not empty errors.password}">
                            <p class="message error">${errors.password}</p>
                        </c:if>
                    </div>

                    <div class="form-group">
                        <label for="passwordCheck">비밀번호 확인</label>
                        <input type="password" id="passwordCheck" required>
                        <p class="message" id="passwordMessage"></p>
                    </div>

                    <div class="form-group">
                        <label for="phone1">휴대폰 번호</label>
                        <div class="rrn-inputs">
                            <input type="text" id="phone1" maxlength="3" required>
                            <span class="hyphen">-</span>
                            <input type="text" id="phone2" maxlength="4" required>
                            <span class="hyphen">-</span>
                            <input type="text" id="phone3" maxlength="4" required>
                        </div>
                        <c:if test="${not empty errors.phoneNumber}">
                            <p class="message error">${errors.phoneNumber}</p>
                        </c:if>
                    </div>

                    <div class="form-group">
                        <label for="postcode">주소</label>
                        <div class="input-group" style="margin-bottom: 8px;">
                            <input type="text" id="postcode" name="zipNumber" placeholder="우편번호" value="${joinDTO.zipNumber}" readonly>
                            <button type="button" class="btn-sm" onclick="execDaumPostcode()">주소 검색</button>
                        </div>
                        <c:if test="${not empty errors.zipNumber}">
                            <p class="message error">${errors.zipNumber}</p>
                        </c:if>

                        <input type="text" id="baseAddress" name="addressBase" placeholder="기본주소" value="${joinDTO.addressBase}" readonly style="margin-bottom: 8px;">
                        <c:if test="${not empty errors.addressBase}">
                            <p class="message error">${errors.addressBase}</p>
                        </c:if>

                        <input type="text" id="detailAddress" name="addressDetail" placeholder="상세주소" value="${joinDTO.addressDetail}">
                        <c:if test="${not empty errors.addressDetail}">
                            <p class="message error">${errors.addressDetail}</p>
                        </c:if>
                    </div>

                    <input type="hidden" id="registrationNumber" name="registrationNumber">
                    <input type="hidden" id="phoneNumber" name="phoneNumber"> <div class="action-buttons">
                        <button type="button" class="btn btn-cancel" onclick="location.href='${pageContext.request.contextPath}/login'">취소</button>
                        <button type="button" id="submitBtn" class="btn btn-primary" disabled>가입 완료</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // jQuery의 ready 함수: 문서가 완전히 로드된 후 스크립트가 실행되도록 보장합니다.
        $(document).ready(function() {
            // --- 기존 비밀번호 확인 로직 ---
            const $passwordInput = $('#password');
            const $passwordCheckInput = $('#passwordCheck');
            const $passwordMessage = $('#passwordMessage');
            const $submitButton = $('#submitBtn');

            function checkPasswords() {
                const password = $passwordInput.val();
                const passwordCheck = $passwordCheckInput.val();

                if (password && passwordCheck) {
                    if (password === passwordCheck) {
                        $passwordMessage.text('비밀번호가 일치합니다.').removeClass('error').addClass('success');
                        $submitButton.prop('disabled', false);
                    } else {
                        $passwordMessage.text('비밀번호가 일치하지 않습니다.').removeClass('success').addClass('error');
                        $submitButton.prop('disabled', true);
                    }
                } else {
                    $passwordMessage.text('');
                    $submitButton.prop('disabled', true);
                }
            }

            $passwordInput.on('keyup', checkPasswords);
            $passwordCheckInput.on('keyup', checkPasswords);

            // --- submit 버튼 로직 (휴대폰 번호 조합 로직 추가) ---
            $submitButton.on('click', function() {
                // 주민등록번호 조합
                const rrn1 = $('#rrn1').val();
                const rrn2 = $('#rrn2').val();
                $('#registrationNumber').val(rrn1 + rrn2);
                
                // NEW: 휴대폰 번호 조합
                const phone1 = $('#phone1').val();
                const phone2 = $('#phone2').val();
                const phone3 = $('#phone3').val();
                // 모든 필드가 채워졌을 경우에만 조합하여 hidden input에 값을 설정합니다.
                if (phone1 && phone2 && phone3) {
                    $('#phoneNumber').val(phone1 + '-' + phone2 + '-' + phone3);
                }

                // 폼 전송
                $('.info-form').submit();
            });
            
            $('.rrn-inputs input').on('keyup', function() {
                // 현재 input의 값 길이가 maxlength와 같으면
                if (this.value.length === this.maxLength) {
                    // 현재 input 바로 다음에 오는 input을 찾아 포커스를 이동시킵니다.
                    $(this).nextAll('input').first().focus();
                }
            });
            
            $('#rrn1').on('keyup', function() {
                // 입력된 값의 길이가 maxlength(6)와 같으면
                if (this.value.length === this.maxLength) {
                    // id가 'rrn2'인 input으로 포커스를 이동시킵니다.
                    $('#rrn2').focus();
                }
            });

            // --- 아이디 중복 확인 (jQuery.ajax) ---
            $('#idCheckBtn').on('click', function() {
                const $idCheckMessage = $('#idCheckMessage');
                const username = $('#userId').val().trim(); // 공백 제거

                if (!username) {
                    $idCheckMessage.text('아이디를 입력해주세요.').removeClass('success').addClass('error');
                    return;
                }

                $.ajax({
                    url: '${pageContext.request.contextPath}/join/id/check',
                    type: 'GET',
                    data: {
                        username: username
                    },
                    // 요청 성공 (HTTP 상태 코드 2xx)
                    success: function(responseMessage) {
                        $idCheckMessage.text(responseMessage).removeClass('error').addClass('success');
                    },
                    // 요청 실패 (HTTP 상태 코드 4xx, 5xx)
                    error: function(jqXHR) {
                        $idCheckMessage.text(jqXHR.responseText).removeClass('success').addClass('error');
                    }
                });
            });
        });

        // --- 기존 다음 주소 API 로직 (수정 없음) ---
        function execDaumPostcode() {
            new daum.Postcode({
                oncomplete: function(data) {
                    let addr = '';
                    if (data.userSelectedType === 'R') {
                        addr = data.roadAddress;
                    } else {
                        addr = data.jibunAddress;
                    }
                    document.getElementById('postcode').value = data.zonecode;
                    document.getElementById("baseAddress").value = addr;
                    document.getElementById("detailAddress").focus();
                }
            }).open();
        }
    </script>
</body>
</html>