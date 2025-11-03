<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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

        /* ▼▼▼ [추가된 코드] 툴팁 스타일 ▼▼▼ */
        .tooltip-wrapper {
            position: relative; /* 툴팁의 absolute 포지셔닝 기준점 */
        }
        .custom-tooltip {
            visibility: hidden; /* 기본 숨김 */
            opacity: 0;
            
            position: absolute;
            bottom: 125%; /* input 위에 위치 */
            left: 50%;
            transform: translateX(-50%); /* 중앙 정렬 */
            
            background-color: #333; /* 어두운 배경 */
            color: var(--white-color); 
            text-align: center;
            padding: 8px 12px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 500;
            white-space: nowrap; /* 툴팁 텍스트가 줄바꿈되지 않도록 */
            
            z-index: 10;
            transition: opacity 0.2s ease, visibility 0.2s ease;
        }
        /* 툴팁 꼬리 (화살표) */
        .custom-tooltip::after {
            content: "";
            position: absolute;
            top: 100%; /* 툴팁 하단 중앙 */
            left: 50%;
            margin-left: -5px;
            border-width: 5px;
            border-style: solid;
            border-color: #333 transparent transparent transparent; /* 위쪽을 가리키는 삼각형 */
        }
        /* hover 뿐만 아니라 focus 시에도 툴팁이 보이도록 개선 */
        .tooltip-wrapper:hover .custom-tooltip,
        .tooltip-wrapper input:focus + .custom-tooltip {
            visibility: visible;
            opacity: 1;
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

            .content-box {
                padding: 20px 0; /* 컨텐츠 박스 여백 축소 */
            }
            
            .content-box h2 {
                font-size: 22px; /* 서브 타이틀 폰트 축소 */
                margin-bottom: 30px;
            }
            
            .info-form {
                max-width: 100%; /* 폼 최대 너비 제한 해제 */
            }

            .form-group label {
                font-size: 15px; /* 라벨 폰트 축소 */
            }

            .form-group input {
                font-size: 15px; /* 입력 폰트 축소 */
            }

            /* 사업자번호/휴대폰 입력칸들이 공간을 균등하게 나누도록 설정 */
            .hyphen-inputs input {
                flex: 1;
                min-width: 0; /* flex item이 줄어들 수 있도록 허용 */
                text-align: center;
            }

            /* 툴팁이 화면 밖으로 나가지 않도록 수정 */
            .custom-tooltip {
                white-space: normal; /* 텍스트 줄바꿈 허용 */
                max-width: 80vw; /* 툴팁 최대 너비를 뷰포트의 80%로 제한 */
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
            
            .form-group label {
                font-size: 14px;
            }

            .form-group input {
                font-size: 14px;
            }

            /* 아이디 중복확인, 주소 검색 버튼 그룹 */
            .input-group {
                flex-direction: column; /* 인풋과 버튼을 세로로 쌓기 */
                gap: 8px;
            }

            .input-group .btn-sm {
                width: 100%;
                padding: 12px; /* 버튼을 크게 만들어 터치하기 쉽게 */
                font-size: 14px;
            }
        }
        /* ▲▲▲ [추가된 코드] 툴팁 스타일 ▲▲▲ */
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
                        	<c:set var="buisinessParts" value="${fn:split(joinDTO.buisinessRegiNumber, '-')}" />
                            <input type="text" id="brn1" maxlength="3" value="${not empty buisinessParts[0] ? buisinessParts[0] : ''}" required>
                            <span class="hyphen">-</span>
                            <input type="text" id="brn2" maxlength="2" value="${not empty buisinessParts[1] ? buisinessParts[1] : ''}" required>
                            <span class="hyphen">-</span>
                            <input type="text" id="brn3" maxlength="5" value="${not empty buisinessParts[2] ? buisinessParts[2] : ''}" required>
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
                        <div class="tooltip-wrapper">
                            <input type="password" id="password" name="password" value="${joinDTO.password}" required>
                            <div class="custom-tooltip">
                                비밀번호는 최소 8자 이상이어야 하며, 특수문자 하나 이상을 포함해야 합니다.
                            </div>
                        </div>
                        <c:if test="${not empty errors.password}">
                            <p class="message error">${errors.password}</p>
                        </c:if>
                    </div>
                    <div class="form-group">
                        <label for="passwordCheck">비밀번호 확인</label>
                        <input type="password" id="passwordCheck" value="${joinDTO.password}" required>
                        <p class="message" id="passwordMessage"></p>
                    </div>

                    <div class="form-group">
                        <label for="phone1">담당자 휴대폰 번호</label>
                        <div class="hyphen-inputs">
                          <c:set var="phoneParts" value="${fn:split(joinDTO.phoneNumber, '-')}" />
						
						  <input type="text" id="phone1" maxlength="3" required
						         value="${not empty phoneParts[0] ? phoneParts[0] : ''}">
						  <span class="hyphen">-</span>
						
						  <input type="text" id="phone2" maxlength="4" required
						         value="${not empty phoneParts[1] ? phoneParts[1] : ''}">
						  <span class="hyphen">-</span>
						
						  <input type="text" id="phone3" maxlength="4" required
						         value="${not empty phoneParts[2] ? phoneParts[2] : ''}">
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