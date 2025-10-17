<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>기업회원 가입 (3/4) - 정보 입력</title>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    
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
            --success-color: #28a745;
            --error-color: #dc3545;
        }
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
        .form-group input:focus { outline: none; border-color: var(--primary-color); box-shadow: 0 0 0 2px rgba(36, 169, 96, 0.15); }
        .input-group { display: flex; gap: 10px; }
        .input-group input { flex: 1; }
        .input-group .btn-sm { padding: 0 20px; font-size: 14px; background-color: var(--dark-gray-color); color: var(--white-color); border: none; border-radius: 6px; cursor: pointer; }
        .hyphen-inputs { display: flex; align-items: center; gap: 10px; }
        .hyphen-inputs .hyphen { font-size: 16px; color: var(--gray-color); }
        .message { font-size: 13px; margin-top: 8px; }
        .message.success { color: var(--success-color); }
        .message.error { color: var(--error-color); }
        .action-buttons { display: flex; justify-content: center; gap: 15px; margin-top: 40px; }
        .btn { padding: 14px 35px; font-size: 16px; font-weight: 500; border-radius: 8px; border: 1px solid var(--border-color); cursor: pointer; transition: all 0.3s ease; }
        .btn-primary { background-color: var(--primary-color); color: var(--white-color); border-color: var(--primary-color); }
        .btn-primary:hover { background-color: #1f8f50; }
        .btn-cancel { background-color: var(--white-color); color: var(--gray-color); }
        .btn-cancel:hover { background-color: var(--light-gray-color); }
        .btn-primary:disabled { background-color: #a0a0a0; border-color: #a0a0a0; cursor: not-allowed; }
    </style>
</head>
<body>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

    <div class="page-wrapper">
        <div class="signup-container">
            <h1 class="main-title">기업회원 가입</h1>

            <div class="progress-stepper">
                <div class="step">01. 사업자 확인</div>
                <div class="step">02. 약관 동의</div>
                <div class="step active">03. 정보 입력</div>
                <div class="step">04. 가입 완료</div>
            </div>

            <div class="content-box">
                <h2>정보 입력</h2>
                <form class="info-form" action="${pageContext.request.contextPath}/joinProc/corp" method="post">
                    <div class="form-group">
                        <label for="name">회사명</label>
                        <input type="text" id="name" name="name" value="${joinDTO.name}" required>
                        <c:if test="${not empty errors.name}">
                            <p class="message error">${errors.name}</p>
                        </c:if>
                    </div>

                    <div class="form-group">
                        <label for="postcode">회사 주소</label>
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
                    
                    <div class="form-group">
                        <label for="brn1">사업자 등록번호</label>
                        <div class="hyphen-inputs">
                            <input type="text" id="brn1" maxlength="3" required>
                            <span class="hyphen">-</span>
                            <input type="text" id="brn2" maxlength="2" required>
                            <span class="hyphen">-</span>
                            <input type="text" id="brn3" maxlength="5" required>
                        </div>
                        <c:if test="${not empty errors.buisinessRegiNumber}">
                            <p class="message error">${errors.buisinessRegiNumber}</p>
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
                        <p class="message" id="idCheckMessage"></p>
                    </div>

                    <div class="form-group">
                        <label for="password">비밀번호</label>
                        <input type="password" id="password" name="password" required>
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
                        <label for="phone1">담당자 휴대폰 번호</label>
                        <div class="hyphen-inputs">
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
                    
                    <input type="hidden" id="buisinessRegiNumber" name="buisinessRegiNumber">
                    <input type="hidden" id="phoneNumber" name="phoneNumber">

                    <div class="action-buttons">
                        <button type="button" class="btn btn-cancel" onclick="location.href='${pageContext.request.contextPath}/login'">취소</button>
                        <button type="button" id="submitBtn" class="btn btn-primary" disabled>가입 완료</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        $(document).ready(function() {
            const $passwordInput = $('#password');
            const $passwordCheckInput = $('#passwordCheck');
            const $passwordMessage = $('#passwordMessage');
            const $submitButton = $('#submitBtn');
            let isIdChecked = false;

            function checkAllConditions() {
                const password = $passwordInput.val();
                const passwordCheck = $passwordCheckInput.val();
                
                if (password && passwordCheck && (password === passwordCheck) && isIdChecked) {
                    $submitButton.prop('disabled', false);
                } else {
                    $submitButton.prop('disabled', true);
                }
            }

            function checkPasswords() {
                const password = $passwordInput.val();
                const passwordCheck = $passwordCheckInput.val();

                if (password && passwordCheck) {
                    if (password === passwordCheck) {
                        $passwordMessage.text('비밀번호가 일치합니다.').removeClass('error').addClass('success');
                    } else {
                        $passwordMessage.text('비밀번호가 일치하지 않습니다.').removeClass('success').addClass('error');
                    }
                } else {
                    $passwordMessage.text('');
                }
                checkAllConditions();
            }

            $passwordInput.on('keyup', checkPasswords);
            $passwordCheckInput.on('keyup', checkPasswords);

            $submitButton.on('click', function() {
                const brn1 = $('#brn1').val();
                const brn2 = $('#brn2').val();
                const brn3 = $('#brn3').val();
                if (brn1 && brn2 && brn3) {
                    $('#buisinessRegiNumber').val(brn1 + '-' + brn2 + '-' + brn3);
                }

                const phone1 = $('#phone1').val();
                const phone2 = $('#phone2').val();
                const phone3 = $('#phone3').val();
                if (phone1 && phone2 && phone3) {
                    $('#phoneNumber').val(phone1 + '-' + phone2 + '-' + phone3);
                }

                $('.info-form').submit();
            });

            $('.hyphen-inputs input').on('keyup', function() {
                if (this.value.length === this.maxLength) {
                    $(this).nextAll('input').first().focus();
                }
            });

            $('#idCheckBtn').on('click', function() {
                const $idCheckMessage = $('#idCheckMessage');
                const username = $('#userId').val().trim();

                if (!username) {
                    $idCheckMessage.text('아이디를 입력해주세요.').removeClass('success').addClass('error');
                    isIdChecked = false;
                    checkAllConditions();
                    return;
                }

                $.ajax({
                    url: '${pageContext.request.contextPath}/join/id/check',
                    type: 'GET',
                    data: { username: username },
                    success: function(responseMessage) {
                        $idCheckMessage.text(responseMessage).removeClass('error').addClass('success');
                        isIdChecked = true;
                        checkAllConditions();
                    },
                    error: function(jqXHR) {
                        $idCheckMessage.text(jqXHR.responseText).removeClass('success').addClass('error');
                        isIdChecked = false;
                        checkAllConditions();
                    }
                });
            });

            $('#userId').on('keyup', function() {
                isIdChecked = false;
                $('#idCheckMessage').text('');
                checkAllConditions();
            });
        });

        function execDaumPostcode() {
            new daum.Postcode({
                oncomplete: function(data) {
                    let addr = (data.userSelectedType === 'R') ? data.roadAddress : data.jibunAddress;
                    document.getElementById('postcode').value = data.zonecode;
                    document.getElementById("baseAddress").value = addr;
                    document.getElementById("detailAddress").focus();
                }
            }).open();
        }
    </script>
</body>
</html>