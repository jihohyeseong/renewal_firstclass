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
    :root {
        --primary-color: #3f58d4;
        --primary-color-dark: #324ca8; 
        --primary-color-light: #f0f3fd; 
        
        --status-approved: #3f58d4; 
        --status-pending: #f59e0b;  
        --status-rejected: #ef4444; 
        
        --text-color: #333;
        --text-color-light: #555;
        --border-color: #e0e0e0;
        --bg-color-soft: #f9fafb; 
        --white: #ffffff;
    }

    body {
        font-family: 'Noto Sans KR', sans-serif;
        background-color: var(--bg-color-soft); 
        color: var(--text-color);
        line-height: 1.6;
        display: flex;
        flex-direction: column;
        min-height: 100vh; 
        margin: 0; 
    }

    .main-container {
        max-width: 1100px;
        margin: 20px auto;
        padding: 0 20px;
        flex-grow: 1;
    }

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

    .header-actions {
        display: flex;
        align-items: center;
        gap: 10px; 
    }


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
    
    .btn-outline-primary {
        background-color: var(--white);
        color: var(--primary-color);
        border-color: var(--primary-color);
    }
    .btn-outline-primary:hover:not(:disabled) {
        background-color: var(--primary-color-light);
    }

    .tooltip-wrapper {
        position: relative;
        display: inline-block;
    }

    .custom-tooltip {
        visibility: hidden;
        opacity: 0;
        
        position: absolute;
        bottom: 125%; 
        left: 50%;
        transform: translateX(-50%);
        
        background-color: #333;
        color: var(--white);
        text-align: center;
        padding: 8px 12px;
        border-radius: 6px;
        font-size: 13px;
        font-weight: 500;
        white-space: nowrap;
        
        z-index: 10;
        transition: opacity 0.2s ease, visibility 0.2s ease;
    }

    .custom-tooltip::after {
        content: "";
        position: absolute;
        top: 100%;
        left: 50%;
        margin-left: -5px;
        border-width: 5px;
        border-style: solid;
        border-color: #333 transparent transparent transparent; 
    }

    .tooltip-wrapper:hover .custom-tooltip {
        visibility: visible;
        opacity: 1;
    }

    .notice-box { background-color: var(--primary-color-light); border: 1px solid var(--primary-color); border-left-width: 5px; border-radius: 8px; padding: 20px; }
    .notice-box .title { display: flex; align-items: center; font-size: 18px; font-weight: 700; color: var(--primary-color-dark); margin-bottom: 12px; }
    .notice-box .title .fa-solid { margin-right: 10px; font-size: 20px; }
    .notice-box ul { margin: 0; padding-left: 20px; color: var(--text-color-light); font-size: 14px; }
    .notice-box li { margin-bottom: 6px; }
    .notice-box li:last-child { margin-bottom: 0; }

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
    
    .empty-state-box { text-align: center; padding: 60px 40px; background-color: #fcfcfc; border-radius: 10px; border: 1px dashed var(--border-color); }
    .empty-state-box::before { font-family: "Font Awesome 6 Free"; font-weight: 900; content: "\f115"; font-size: 40px; color: var(--primary-color); display: block; margin-bottom: 20px; opacity: 0.6; }
    .empty-state-box h3 { font-size: 22px; color: var(--text-color); margin-top: 0; margin-bottom: 12px; }
    .empty-state-box p { font-size: 16px; color: var(--text-color-light); margin: 0; }
    
        @media (max-width: 768px) {
            .main-container {
                margin: 10px auto;
                padding: 0 10px;
            }

            .content-wrapper {
                padding: 20px 15px;
            }

            .content-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
                padding-bottom: 20px;
            }

            .content-header h2 {
                font-size: 22px;
            }

            .header-actions {
                flex-direction: row; 
                flex-wrap: wrap; 
                justify-content: flex-end;
                width: 100%; 
                gap: 8px; 
            }
            
            .header-actions .tooltip-wrapper,
            .header-actions form {
                display: inline-block;
            }
            
            .header-actions .btn {
                 width: auto;
                 padding: 8px 14px; 
                 font-size: 14px; 
            }
            
            .header-actions form {
                display: inline-block;
            }

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

            .list-table {
                table-layout: fixed;
                width: 100%;
                word-break: break-all;
            }

            .list-table thead th,
            .list-table tbody td {
                white-space: normal;
                font-size: 14px;
                padding: 12px 8px;
                vertical-align: middle;
            }
            
            .list-table th:nth-child(1) { width: 25% !important; } /* 신청번호 */
            .list-table th:nth-child(2) { width: 25% !important; } /* 신청일 */
            .list-table th:nth-child(3) { width: 15% !important; } /* 이름 */
            .list-table th:nth-child(4) { width: 15% !important; } /* 상태 */
            .list-table th:nth-child(5) { width: 20% !important; } /* 작업 */

            .list-table td.actions {
                text-align: center;
            }
            
            .list-table td.actions .btn {
                 width: 100%;
                 max-width: 100px;
                 padding: 6px 8px;
                 font-size: 12px;
            }
            
            .custom-tooltip {
                white-space: normal; 
                max-width: 80vw;
                font-size: 12px;
            }
            
            .empty-state-box {
                padding: 40px 20px;
            }
            .empty-state-box h3 {
                font-size: 20px;
            }
            .empty-state-box p {
                font-size: 15px;
            }
        }
        
        @media (max-width: 480px) {
            .content-wrapper {
                padding: 15px;
            }
            .content-header h2 {
                font-size: 20px;
            }
            
            .header-actions .btn {
                font-size: 13px;
                padding: 8px 10px;
            }

            .list-table thead th,
            .list-table tbody td {
                font-size: 12px;
                padding: 10px 5px;
            }
            
            .status-badge {
                font-size: 11px;
                padding: 4px 8px;
            }
            
            .list-table td.actions .btn {
                 font-size: 11px;
                 padding: 5px;
            }

            .empty-state-box h3 {
                font-size: 18px;
            }
            .empty-state-box p {
                font-size: 14px;
            }
        }
        .footer {
       text-align: center;
       padding: 20px 0;
       font-size: 14px;
       color: var(--gray-color);
   }

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
            <h2>나의 신청 내역</h2>
            
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
   
                                <td class="actions" style="text-align: center;">
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

        function updateButtonUI(status, token) {
            token = token || null;
            
            if (!pushButton || !tooltip) return;
            
            pushButton.classList.remove('btn-primary', 'btn-secondary', 'btn-outline-primary');
            pushButton.disabled = false;
            pushButton.dataset.status = status;
            pushButton.dataset.token = token;

            switch (status) {
                case 'denied':
                    pushButton.textContent = '🔔 알림 차단됨';
                    pushButton.classList.add('btn-secondary');
                    pushButton.disabled = true;
                    tooltip.textContent = '브라우저 상단 주소창 왼쪽의 ⓘ 버튼을 클릭해 알림 권한을 허용해주세요';
                    break;
                case 'subscribed':
                    pushButton.textContent = '🔔 푸시 알림ON';
                    pushButton.classList.add('btn-primary');
                    tooltip.textContent = '심사 완료 시 알림을 받습니다.';
                    break;
                case 'unsubscribed':
                    pushButton.textContent = '🔔 푸시 알림OFF';
                    pushButton.classList.add('btn-outline-primary');
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
                default:
                    pushButton.textContent = '🔔 푸시 알림받기';
                    pushButton.classList.add('btn-outline-primary');
                    tooltip.textContent = '클릭하여 알림 허용하기';
                    break;
            }
        }
        
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

        function checkTokenOnServer() {
            return getFirebaseToken().then(function(token) {
                
                return $.ajax({
                    url: CHECK_URL,
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({ fcmToken: token })
                }).then(function(response) {
                    return { isSubscribed: response === true, token: token };
                });

            }).catch(function(err) {
                console.error('서버 토큰 확인 프로세스 실패:', err);
                return { isSubscribed: false, token: null }; 
            });
        }
        
        function sendTokenToServer(action, token) {
            var url = (action === 'save') ? SAVE_URL : DELETE_URL;
            
            return $.ajax({
                url: url,
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ fcmToken: token })
            });
        }

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
        
        function initializePushState() {
            if (!("Notification" in window) || !("serviceWorker" in navigator)) {
                updateButtonUI('unsupported');
                return;
            }

            const permission = Notification.permission;

            if (permission === 'denied') {
                updateButtonUI('denied');
            } else if (permission === 'default') {
                updateButtonUI('default');
            } else { 
                updateButtonUI('loading');

                checkTokenOnServer()
                    .then(function(result) {
                        if (result.isSubscribed) {
                            updateButtonUI('subscribed', result.token);
                        } else {
                            updateButtonUI('unsubscribed', result.token);
                        }
                    })
                    .catch(function(err) {
                        console.error('초기화 중 오류:', err);
                        updateButtonUI('unsubscribed', null);
                    });
            }
        }
        
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
        
    });
    </script>
</html>