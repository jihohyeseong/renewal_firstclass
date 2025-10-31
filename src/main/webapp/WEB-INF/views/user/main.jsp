<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>육아휴직 서비스 - 나의 신청내역</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/comp.css">
<style>
    /* --- 테마 색상 및 기본 스타일 (파란색 테마) --- */
    :root {
        --primary-color: #3f58d4;
        --primary-color-dark: #324ca8; /* 더 어두운 파란색 */
        --primary-color-light: #f0f3fd; /* 아주 연한 파란색 */
        
        --status-approved: #3f58d4; /* 승인 (메인 파란색) */
        --status-pending: #f59e0b;  /* 대기 (황색) */
        --status-rejected: #ef4444; /* 반려 (적색) */
        
        --text-color: #333;
        --text-color-light: #555;
        --border-color: #e0e0e0;
        --bg-color-soft: #f9fafb; /* 연한 회색 배경 */
        --white: #ffffff;
    }

    body {
        font-family: 'Noto Sans KR', sans-serif;
        background-color: var(--bg-color-soft); /* 전체 페이지 배경색 */
        color: var(--text-color);
        line-height: 1.6;
    }

    .main-container {
        max-width: 1100px;
        margin: 20px auto;
        padding: 0 20px;
    }

    /* --- 콘텐츠 래퍼 (카드 디자인) --- */
    .content-wrapper {
        background-color: var(--white);
        border-radius: 12px;
        padding: 24px 30px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        margin-bottom: 20px;
    }

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

    /* --- [수정] 헤더 버튼 영역 --- */
    .header-actions {
        display: flex;
        align-items: center;
        gap: 10px; /* 버튼 사이 간격 */
    }

    /* --- 버튼 (comp.css 오버라이드) --- */
    .btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 10px 18px;
        font-size: 15px;
        font-weight: 500;
        line-height: 1.5;
        border: 1px solid transparent;
        border-radius: 8px;
        text-decoration: none;
        cursor: pointer;
        transition: all 0.2s ease;
        white-space: nowrap;
    }
    .btn:disabled {
        opacity: 0.7;
        cursor: not-allowed;
    }
    .btn-primary {
        background-color: var(--primary-color);
        color: var(--white);
    }
    .btn-primary:hover:not(:disabled) {
        background-color: var(--primary-color-dark);
    }
    .btn-secondary {
        background-color: #e9ecef;
        color: #495057;
        border-color: #dee2e6;
    }
    .btn-secondary:hover:not(:disabled) {
        background-color: #d1d5db;
    }
    
    /* --- [신규] 아웃라인 버튼 스타일 (페이지 테마에 맞춤) --- */
    .btn-outline-primary {
        background-color: var(--white);
        color: var(--primary-color);
        border-color: var(--primary-color);
    }
    .btn-outline-primary:hover:not(:disabled) {
        background-color: var(--primary-color-light);
    }

    /* --- [신규] 커스텀 툴팁 스타일 --- */
    .tooltip-wrapper {
        position: relative; /* 툴팁을 이 요소 기준으로 위치시킴 */
        display: inline-block;
    }

    .custom-tooltip {
        visibility: hidden; /* 기본 숨김 */
        opacity: 0;
        
        position: absolute;
        bottom: 125%; /* 버튼 위에 위치 */
        left: 50%;
        transform: translateX(-50%); /* 중앙 정렬 */
        
        background-color: #333; /* 어두운 배경 */
        color: var(--white);
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

    .tooltip-wrapper:hover .custom-tooltip {
        visibility: visible;
        opacity: 1;
    }


    /* --- 안내 상자 (생략) --- */
    .notice-box { background-color: var(--primary-color-light); border: 1px solid var(--primary-color); border-left-width: 5px; border-radius: 8px; padding: 20px; }
    .notice-box .title { display: flex; align-items: center; font-size: 18px; font-weight: 700; color: var(--primary-color-dark); margin-bottom: 12px; }
    .notice-box .title .fa-solid { margin-right: 10px; font-size: 20px; }
    .notice-box ul { margin: 0; padding-left: 20px; color: var(--text-color-light); font-size: 14px; }
    .notice-box li { margin-bottom: 6px; }
    .notice-box li:last-child { margin-bottom: 0; }

    /* --- 리스트 테이블 (생략) --- */
    .list-table { width: 100%; border-collapse: collapse; table-layout: fixed; font-size: 15px; }
    .list-table thead th { padding: 14px 16px; font-weight: 600; background-color: var(--primary-color); color: var(--white); text-align: left; border-bottom: 2px solid var(--primary-color-dark); }
    .list-table thead th:nth-child(4), .list-table thead th:nth-child(5) { text-align: center; }
    .list-table tbody td { padding: 14px 16px; line-height: 1.5; vertical-align: middle; border-bottom: 1px solid var(--border-color); color: var(--text-color-light); }
    .list-table tbody td:first-child { color: var(--text-color); font-weight: 500; }
    .list-table tbody tr:hover { background: var(--primary-color-light); }
    .status-badge { display: inline-block; font-size: 12px; font-weight: 600; padding: 5px 12px; border-radius: 999px; line-height: 1; text-align: center; background-color: #f3f4f6; color: #4b5563; }
    .status-badge.status-등록, .status-badge.status-제출, .status-badge.status-대기 { background-color: #f3f4f6; color: #4b5563; }
    .status-badge.status-심사중 { background-color: #fffbeb; color: #b45309; }
    .status-badge.status-심사완료, .status-badge.status-승인 { background-color: var(--primary-color-light); color: var(--primary-color-dark); }
    .status-badge.status-반려 { background-color: #ffebeb; color: #b91c1c; }
    .list-table td.status-cell { text-align: center; }
    .list-table .btn { padding: 6px 12px; font-size: 13px; font-weight: 500; line-height: 1; border-radius: 6px; margin: 0 2px; }
    .list-table td.actions { text-align: right; white-space: nowrap; }
    
    /* --- 빈 상태 박스 (생략) --- */
    .empty-state-box { text-align: center; padding: 60px 40px; background-color: #fcfcfc; border-radius: 10px; border: 1px dashed var(--border-color); }
    .empty-state-box::before { font-family: "Font Awesome 6 Free"; font-weight: 900; content: "\f115"; font-size: 40px; color: var(--primary-color); display: block; margin-bottom: 20px; opacity: 0.6; }
    .empty-state-box h3 { font-size: 22px; color: var(--text-color); margin-top: 0; margin-bottom: 12px; }
    .empty-state-box p { font-size: 16px; color: var(--text-color-light); margin: 0; }

</style>
</head>
<body>
<%@ include file="header.jsp" %>

<main class="main-container"> 

    <div class="notice-box"> 
        <div class="title">
            <i class="fa-solid fa-volume-high"></i>
            <span>안내</span>
        </div>
        <ul>
            <li><strong>육아휴직급여:</strong> [모의계산하기]버튼을 클릭하면 예상 지급액을 확인할 수 있습니다.</li>
            <li><strong>신청기간:</strong> 휴직개시일 1개월 이후부터 휴직종료일 이후 1년 이내 신청 가능합니다.</li>
            <li><strong>승인기간:</strong> 신청서 제출완료 후 심시완료까지는 평균적으로 2-5일 소요됩니다. </li>
        </ul>
    </div>

    <div class="content-wrapper">
        <div class="content-header">
            <h2><sec:authentication property="principal.username" /> 님의 신청 내역</h2>
            
            <div class="header-actions">
                
                <div class="tooltip-wrapper">
                    <button type="button" id="allow-push-btn" class="btn" data-status="loading">
                        🔔 ...
                    </button>
                    <span class="custom-tooltip" id="push-btn-tooltip">로딩 중...</span> 
                </div>

                <form action="${pageContext.request.contextPath}/user/confirms" method="POST" style="margin: 0;">
                    <input type="hidden" name="name" value="${simpleUserInfoVO.name}">
                    <input type="hidden" name="registrationNumber" value="${simpleUserInfoVO.registrationNumber}">
                    <button type="submit" class="btn btn-primary">새로 신청하기</button>
                </form>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty list}">
                <div class="empty-state-box">
                    <h3>아직 신청 내역이 없으시네요.</h3>
                    <p>소중한 자녀를 위한 첫걸음, 지금 바로 시작해보세요.</p>
                </div>
            </c:when>
            <c:otherwise>
                <table class="list-table">
                    <thead>
                        <tr>
                            <th style="width: 18%;">신청번호</th>
                            <th style="width: 20%;">신청일</th>
                            <th style="width: 20%;">신청자 이름</th>
                            <th style="width: 18%;">상태</th>
                            <th style="width: 140px;">작업</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="app" items="${list}">
                            <tr>
                                <td>${app.applicationNumber}</td>
                                <td>${not empty app.submittedDt ? app.submittedDt : '-'}</td>
                                <td>${app.name}</td>
                                
                                <td class="status-cell"> 
                                    <c:set var="stCode" value="${app.statusCode}" />
                                    <c:set var="stName">
                                        <c:choose>
                                            <c:when test="${stCode == 'ST_10'}">등록</c:when>
                                            <c:when test="${stCode == 'ST_20'}">제출</c:when>
                                            <c:when test="${stCode == 'ST_30'}">심사중</c:when>
                                            <c:when test="${stCode == 'ST_40'}">심사중</c:when>
                                            <c:when test="${stCode == 'ST_50'}">승인</c:when>
                                            <c:when test="${stCode == 'ST_60'}">반려</c:when>
                                            <c:otherwise>대기</c:otherwise>
                                        </c:choose>
                                    </c:set>
                                    
                                    <span class="status-badge status-${stName}">${stName}</span>
                                </td>
   
                                <td class="actions">
                                    <a href="${pageContext.request.contextPath}/user/detail/${app.applicationNumber}" class="btn btn-secondary">
                                        상세보기</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
    
</main>

<footer class="footer">
    <p>&copy; 2025 육아휴직 서비스. All Rights Reserved.</p>
</footer>

<c:if test="${not empty error}">
    <script type="text/javascript">
    window.onload = function() {
        alert('${error}');
    };
    </script>
</c:if>
</body>
    <script src="https://www.gstatic.com/firebasejs/9.22.1/firebase-app-compat.js"></script>
    <script src="https://www.gstatic.com/firebasejs/9.22.1/firebase-messaging-compat.js"></script>
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script>
    $(document).ready(function() {
        
        // --- 1. 스코프 내 변수 설정 ---
        const VAPID_KEY = "BBc3HyjOmOGy5y6MK6fMzBazOvOIMdx7WJ0VIA7AM-pdzF-dBk6cBbwThsHHnVt1XFRt6J_uqF-EmjxLXEB7BLI";
        const CONTEXT_PATH = "${pageContext.request.contextPath}";
        
        const CHECK_URL = CONTEXT_PATH + "/check-fcm-token";
        const SAVE_URL = CONTEXT_PATH + "/save-fcm-token";
        const DELETE_URL = CONTEXT_PATH + "/delete-fcm-token";

        const firebaseConfig = {
            apiKey: "AIzaSyBb2vaosR63S_Knim9gbnGH5Rk7F87qkC4",
            authDomain: "firstclass-b26aa.firebaseapp.com",
            projectId: "firstclass-b26aa",
            storageBucket: "firstclass-b26aa.firebasestorage.app",
            messagingSenderId: "90572579455",
            appId: "1:90572579455:web:49c5070ba44f968649154a"
        };
        firebase.initializeApp(firebaseConfig);
        
        const pushButton = document.getElementById('allow-push-btn');
        const tooltip = document.getElementById('push-btn-tooltip');
        const messaging = firebase.messaging();

        
        // --- 2. UI 업데이트 함수 ---
        function updateButtonUI(status, token) {
            token = token || null;
            
            if (!pushButton || !tooltip) return;
            
            pushButton.classList.remove('btn-primary', 'btn-secondary', 'btn-outline-primary');
            pushButton.disabled = false;
            pushButton.dataset.status = status;
            pushButton.dataset.token = token;

            switch (status) {
                case 'denied': // (조건 1)
                    pushButton.textContent = '🔔 알림 차단됨';
                    pushButton.classList.add('btn-secondary');
                    pushButton.disabled = true;
                    tooltip.textContent = '브라우저 상단 주소창 왼쪽의 ⓘ 버튼을 클릭해 알림 권한을 허용해주세요';
                    break;
                case 'subscribed': // (조건 2: 켜짐 + true)
                    pushButton.textContent = '🔔 푸시 알림ON';
                    pushButton.classList.add('btn-primary'); // (채움)
                    tooltip.textContent = '심사 완료 시 알림을 받습니다.';
                    break;
                case 'unsubscribed': // (조건 3: 켜짐 + false)
                    pushButton.textContent = '🔔 푸시 알림OFF';
                    pushButton.classList.add('btn-outline-primary'); // (비움)
                    tooltip.textContent = '심사 완료 시 알림을 받지 않습니다.';
                    break;
                case 'unsupported':
                    pushButton.textContent = '🔔 알림 미지원';
                    pushButton.classList.add('btn-secondary');
                    pushButton.disabled = true;
                    tooltip.textContent = '이 브라우저는 푸시 알림을 지원하지 않습니다.';
                    break;
                case 'loading':
                    pushButton.textContent = '🔔 ...';
                    pushButton.classList.add('btn-secondary');
                    pushButton.disabled = true;
                    tooltip.textContent = '상태 확인 중...';
                    break;
                default: // 'default' (기본 상태)
                    pushButton.textContent = '🔔 푸시 알림받기';
                    pushButton.classList.add('btn-outline-primary');
                    tooltip.textContent = '클릭하여 알림 허용하기';
                    break;
            }
        }
        
        // --- 3. Firebase 및 서버 통신 함수 ---

        /**
         * Firebase로부터 현재 기기의 토큰을 가져옵니다.
         * @returns {Promise<string>} FCM 토큰
         */
        function getFirebaseToken() {
            return new Promise(function(resolve, reject) {
                navigator.serviceWorker.register(CONTEXT_PATH + "/firebase-messaging-sw.js")
                    .then(function(registration) {
                        return messaging.getToken({ 
                            vapidKey: VAPID_KEY,
                            serviceWorkerRegistration: registration
                        });
                    })
                    .then(function(currentToken) {
                        if (currentToken) {
                            resolve(currentToken);
                        } else {
                            console.log('토큰을 발급받지 못했습니다.');
                            reject('No token generated');
                        }
                    })
                    .catch(function(err) {
                        console.error('토큰 발급 중 오류:', err);
                        reject(err);
                    });
            });
        }

        /**
         * (AJAX) 현재 기기 토큰을 가져와서 서버에 등록 여부를 확인합니다.
         * @returns {Promise<{isSubscribed: boolean, token: string | null}>} 
         */
        function checkTokenOnServer() {
            // 1. 먼저 Firebase에서 토큰을 가져옵니다.
            return getFirebaseToken().then(function(token) {
                
                // 2. 토큰을 서버로 보내 확인합니다.
                return $.ajax({
                    url: CHECK_URL,
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({ fcmToken: token })
                }).then(function(response) {
                    // 3. 서버 응답(true/false)과 토큰을 함께 반환합니다.
                    return { isSubscribed: response === true, token: token };
                });

            }).catch(function(err) {
                // getFirebaseToken() 실패 또는 ajax 실패
                console.error('서버 토큰 확인 프로세스 실패:', err);
                // 실패 시, 비구독 상태와 null 토큰 반환
                return { isSubscribed: false, token: null }; 
            });
        }
        
        /**
         * (AJAX) 토큰을 서버에 저장(구독)하거나 삭제(구독해지)합니다.
         * @param {'save' | 'delete'} action - 수행할 작업
         * @param {string} token - 대상 FCM 토큰
         * @returns {Promise<void>}
         */
        function sendTokenToServer(action, token) {
            var url = (action === 'save') ? SAVE_URL : DELETE_URL;
            
            return $.ajax({
                url: url,
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ fcmToken: token })
            });
        }

        // --- 4. 메인 로직 (구독/해지) ---

        /**
         * (클릭 시) 구독 처리 (권한 요청 + 토큰 발급 + 서버 전송)
         */
        function subscribeUser() {
            updateButtonUI('loading');
            
            Notification.requestPermission().then(function(permission) {
                if (permission === 'denied') {
                    updateButtonUI('denied');
                    return;
                }
                
                if (permission === 'default') {
                    updateButtonUI('default');
                    return;
                }

                getFirebaseToken()
                    .then(function(token) {
                        return sendTokenToServer('save', token).then(function() {
                            return token; 
                        });
                    })
                    .then(function(token) {
                        console.log('FCM 토큰이 서버에 저장되었습니다.');
                        updateButtonUI('subscribed', token);
                    })
                    .catch(function(err) {
                        console.error('구독 처리 중 오류:', err);
                        updateButtonUI('unsubscribed', null); 
                    });
            });
        }
        
        /**
         * (클릭 시) 구독 해지 (서버 토큰 삭제)
         */
        function unsubscribeUser() {
            const token = pushButton.dataset.token;
            if (!token) {
                console.error('해지할 토큰이 없습니다.');
                return;
            }
            
            updateButtonUI('loading');
            
            sendTokenToServer('delete', token)
                .then(function() {
                    console.log('FCM 토큰이 서버에서 삭제되었습니다.');
                    updateButtonUI('unsubscribed', token);
                })
                .catch(function(err) {
                    console.error('토큰 삭제 실패:', err);
                    updateButtonUI('subscribed', token); 
                });
        }
        
        // --- 5. 페이지 로드 시 초기 상태 설정 ---
        
        function initializePushState() {
            if (!("Notification" in window) || !("serviceWorker" in navigator)) {
                updateButtonUI('unsupported');
                return;
            }

            const permission = Notification.permission;

            if (permission === 'denied') {
                // (조건 1)
                updateButtonUI('denied');
            } else if (permission === 'default') {
                // (기본 상태)
                updateButtonUI('default');
            } else { 
                // (조건 2 또는 3)
                updateButtonUI('loading');
                
                // [수정] checkTokenOnServer가 토큰 가져오기 및 서버 확인을 모두 처리
                checkTokenOnServer()
                    .then(function(result) { // result = { isSubscribed: boolean, token: string }
                        if (result.isSubscribed) {
                            // (조건 2) 켜짐 + true
                            updateButtonUI('subscribed', result.token);
                        } else {
                            // (조건 3) 켜짐 + false
                            updateButtonUI('unsubscribed', result.token);
                        }
                    })
                    .catch(function(err) {
                        // checkTokenOnServer 내부에서 catch되었지만, 만약의 경우
                        console.error('초기화 중 오류:', err);
                        updateButtonUI('unsubscribed', null); // 오류 시 비구독 상태로 간주
                    });
            }
        }
        
        // --- 6. 이벤트 리스너 연결 ---
        
        initializePushState();

        pushButton.addEventListener('click', function() {
            const status = pushButton.dataset.status;
            pushButton.disabled = true;

            if (status === 'subscribed') {
                unsubscribeUser();
            } else {
                subscribeUser();
            }
        });
        
    }); // <-- $(document).ready() 끝
    </script>
</html>