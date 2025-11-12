<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="currentURI" value="${pageContext.request.requestURI}" />

<style>
    /* ========== Header & Navigation Styles ========== */
    .header {
        background-color: var(--white-color);
        padding: 15px 40px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 1px solid var(--border-color);
        box-shadow: var(--shadow-sm);
        position: sticky;
        top: 0;
        z-index: 10;
        position: relative; 
    }
    .header .logo img { vertical-align: middle; }
    
    .header-right-nav { 
        display: flex; 
        align-items: center; 
        gap: 15px; 
    }
    .header .welcome-msg { font-size: 16px; color: var(--dark-gray-color); }

    .header-nav {
        position: absolute;
        left: 50%;
        transform: translateX(-50%);
        display: flex;
        list-style: none;
        margin: 0;
        padding: 0;
    }
    .header-nav .nav-link {
        display: block;
        padding: 0.5rem 1rem;
        border-radius: 0.5rem;
        font-weight: 500;
        color: #495057;
        transition: color 0.3s ease-in-out;
        position: relative;
    }
    .header-nav .nav-link::after {
        content: '';
        position: absolute;
        bottom: -2px;
        left: 50%;
        transform: translateX(-50%);
        width: 0;
        height: 2px;
        background-color: var(--primary-color);
        transition: width 0.3s ease;
    }
    .header-nav .nav-link:hover,
    .header-nav .nav-link.active {
        color: var(--primary-color);
    }
    .header-nav .nav-link:hover::after,
    .header-nav .nav-link.active::after {
        width: 100%;
    }
    
    /* ========== Button Styles (Used in Header) ========== */
    .btn {
        display: inline-block;
        padding: 10px 20px;
        font-size: 15px;
        font-weight: 500;
        border-radius: 8px;
        border: 1px solid var(--border-color);
        cursor: pointer;
        transition: all 0.2s ease-in-out;
        text-align: center;
    }
    .btn-primary { background-color: var(--primary-color); color: var(--white-color); border-color: var(--primary-color); }
    .btn-primary:hover { background-color: #364ab1; box-shadow: var(--shadow-md); transform: translateY(-2px); }
    
    /* [수정] 로그아웃 버튼 스타일 (부드러운 회색 배경) */
    .btn-logout {
        /* 1. 아이콘 + 텍스트 정렬 */
        display: inline-flex !important;
        align-items: center !important;
        justify-content: center !important;
        gap: 8px !important; /* 아이콘과 텍스트 사이 간격 */
        
        /* 2. 디자인 변경 (투명 배경) */
        background-color: transparent !important;
        color: var(--gray-color, #6c757d) !important; /* 기본은 회색 텍스트 */
        border: none !important; /* 테두리 없음 */
        outline: none !important; /* 포커스 테두리도 없음 */
        
        /* 3. 기본 .btn 스타일 적용 (패딩, 폰트 등) */
        padding: 10px 20px !important;
        font-size: 15px !important;
        font-weight: 500 !important;
        border-radius: 8px !important;
        cursor: pointer !important;
        transition: all 0.2s ease-in-out !important;
        text-align: center !important;
    }
    .btn-logout:hover,
    .btn-logout:focus {
        background-color: var(--light-gray-color, #f8f9fa) !important; /* 호버 시 연한 회색 배경 */
        color: var(--dark-gray-color, #343a40) !important; /* 호버 시 진한 텍스트 */
        box-shadow: none !important;
        transform: none !important;
        border: none !important; /* 호버 시에도 테두리 없음 */
        outline: none !important; /* 포커스 테두리 없음 */
    }
    
    /* [추가] 로그아웃 버튼 내부 SVG 아이콘 */
    .btn-logout .btn-icon {
         width: 16px !important;
         height: 16px !important;
         fill: currentColor !important; /* 버튼의 color 값을 따라감 */
         transition: fill 0.2s ease-in-out !important;
    }

    .btn-secondary { background-color: var(--white-color); color: var(--gray-color); border-color: var(--border-color); }
    .btn-secondary:hover { background-color: var(--light-gray-color); color: var(--dark-gray-color); border-color: #ccc; }


    /* ---------------------------------- */
    /* [수정] 햄버거 버튼 (JS 방식) */
    /* ---------------------------------- */
    .nav-toggle {
        display: none; /* 데스크탑에서는 숨김 */
        background: none;
        border: none;
        cursor: pointer;
        padding: 10px;
        z-index: 1001; /* [중요] 메뉴와 오버레이보다 위에 */
    }
    .nav-toggle-icon {
        display: block;
        width: 24px;
        height: 2px;
        background-color: var(--dark-gray-color);
        position: relative;
        transition: background-color 0.3s ease;
    }
    .nav-toggle-icon::before,
    .nav-toggle-icon::after {
        content: '';
        position: absolute;
        width: 100%;
        height: 2px;
        background-color: var(--dark-gray-color);
        left: 0;
        transition: transform 0.3s ease, top 0.3s ease;
    }
    .nav-toggle-icon::before { top: -7px; }
    .nav-toggle-icon::after { top: 7px; }

    /* 햄버거 X 모양 (활성화 시) */
    .nav-toggle.is-active .nav-toggle-icon {
        background-color: transparent;
    }
    .nav-toggle.is-active .nav-toggle-icon::before {
        transform: rotate(45deg);
        top: 0;
    }
    .nav-toggle.is-active .nav-toggle-icon::after {
        transform: rotate(-45deg);
        top: 0;
    }

    /* ---------------------------------- */
    /* [추가] 오프캔버스 오버레이 */
    /* ---------------------------------- */
    .offcanvas-overlay {
        display: none; /* 기본 숨김 */
        position: fixed;
        top: 0;
        left: 0;
        width: 100vw;
        height: 100vh;
        background-color: rgba(0, 0, 0, 0.5);
        z-index: 999; /* 메뉴 패널(1000) 바로 뒤 */
    }
    .offcanvas-overlay.is-active {
        display: block; /* 활성화 시 보임 */
    }


    /* ---------------------------------- */
    /* 📱 반응형 스타일 (Tablet & Mobile) */
    /* ---------------------------------- */
    @media (max-width: 992px) {
        .header {
            padding: 10px 20px;
        }
        .header .logo img {
            height: 60px;
        }

        /* [수정] 햄버거 버튼 보이기 (오른쪽 정렬) */
        .nav-toggle {
            display: block;
            order: 3; /* 로고 | 메뉴(숨김) | 버튼 */
        }
        
        /* [수정] 데스크탑 중앙 내비 숨기기 */
        .header-nav {
            display: none;
        }

        /* [대폭 수정] 오프캔버스 메뉴 패널 */
        .header-right-nav {
            /* 1. 위치 및 크기 */
            position: fixed;
            top: 0;
            right: 0; /* 오른쪽에 붙임 */
            width: 300px; /* 패널 너비 */
            max-width: 80%; /* 화면의 80%는 넘지 않게 */
            height: 100vh; /* 화면 전체 높이 */
            background-color: var(--white-color);
            z-index: 1000; /* 오버레이(999)보다 위 */

            /* 2. 내부 정렬 (세로로) */
            flex-direction: column;
            align-items: center;
            gap: 20px;
            padding: 80px 20px 20px; /* 상단 여백 (버튼 피해서) */
            
            /* 3. 애니메이션 (초기 상태: 숨김) */
            transform: translateX(100%); /* 오른쪽으로 100% 밀어내서 숨김 */
            transition: transform 0.3s ease-in-out;
            
            /* [중요] display:none 대신 flex 유지 (애니메이션을 위해) */
            display: flex; 
        }

        /* [수정] 오프캔버스 활성화 시 */
        .header-right-nav.is-active {
            transform: translateX(0); /* 제자리(0)로 이동 */
            box-shadow: -5px 0 15px rgba(0,0,0,0.1); /* 왼쪽에 그림자 */
        }

        /* [수정] 오프캔버스 내부의 메뉴 링크 (ul) */
        .header-right-nav .header-nav {
            display: flex; /* 숨겼던 .header-nav를 다시 보이게 */
            position: static;
            transform: none;
            flex-direction: column;
            align-items: center;
            width: 100%;
            gap: 10px;
        }
        
        .header-right-nav .header-nav .nav-link {
            font-size: 16px;
        }
        
        /* [수정] 오프캔버스 내부의 버튼 */
        .header-right-nav .btn {
            width: 100%; /* 버튼 너비 100%로 */
            max-width: 250px;
            margin-top: 10px;
        }
        
        .header .welcome-msg {
            display: none;
        }
    }
</style>

<header class="header">
    <a href="${pageContext.request.contextPath}/user/main" class="logo"><img src="${pageContext.request.contextPath}/resources/images/logo.png" alt="Logo" width="auto" height="80"></a>

    <%-- [수정] 메뉴 컨테이너 (오른쪽 오프캔버스 패널이 됩니다) --%>
    <nav class="header-right-nav" id="main-nav-menu">
        <%-- 데스크탑용 중앙 메뉴 (모바일에선 이 안으로 들어옴) --%>
        <ul class="header-nav">
            <li><a class="nav-link ${fn:contains(currentURI, '/main') ? 'active' : ''}" href="${pageContext.request.contextPath}/user/main">신청내역</a></li>
            <li><a class="nav-link ${fn:contains(currentURI, '/confirm') ? 'active' : ''}" href="${pageContext.request.contextPath}/user/confirm/check">확인서 조회</a></li>
            <li><a class="nav-link ${fn:contains(currentURI, '/calc') ? 'active' : ''}" href="${pageContext.request.contextPath}/calc/user">모의 계산하기</a></li>
            <li><a class="nav-link ${fn:contains(currentURI, '/mypage') ? 'active' : ''}" href="${pageContext.request.contextPath}/mypage">마이페이지</a></li>
        </ul>
        
        <%-- 인증 버튼 --%>
        <sec:authorize access="isAnonymous()">
            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">로그인</a>
        </sec:authorize>
        <sec:authorize access="isAuthenticated()">
            <form id="logout-form" action="${pageContext.request.contextPath}/logout" method="post" style="display: none;">
                <sec:csrfInput/>
            </form>
            
            <a href="#" onclick="document.getElementById('logout-form').submit(); return false;" class="btn btn-logout">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="btn-icon" viewBox="0 0 16 16">
                    <path fill-rule="evenodd" d="M10 12.5a.5.5 0 0 1-.5.5h-8a.5.5 0 0 1-.5-.5v-9a.5.5 0 0 1 .5-.5h8a.5.5 0 0 1 .5.5v2.5a.5.5 0 0 0 1 0v-2.5a1.5 1.5 0 0 0-1.5-1.5h-8A1.5 1.5 0 0 0 0 4.5v9A1.5 1.5 0 0 0 1.5 15h8a1.5 1.5 0 0 0 1.5-1.5v-2.5a.5.5 0 0 0-1 0v2.5z"/>
                    <path fill-rule="evenodd" d="M15.854 8.354a.5.5 0 0 0 0-.708l-3-3a.5.5 0 0 0-.708.708L14.293 7.5H5.5a.5.5 0 0 0 0 1h8.793l-2.147 2.146a.5.5 0 0 0 .708.708l3-3z"/>
                </svg>
                로그아웃
            </a>
        </sec:authorize>
    </nav>

    <%-- [추가] 어두운 배경 오버레이 --%>
    <div class="offcanvas-overlay" id="offcanvas-overlay"></div>

    <%-- [수정] 햄버거 버튼 (체크박스 대신 JS 버튼으로 변경) --%>
    <button class="nav-toggle" id="nav-toggle-btn" aria-label="메뉴 열기" aria-expanded="false">
        <span class="nav-toggle-icon"></span>
    </button>
</header>

<%-- [수정] 오프캔버스 제어를 위한 JavaScript (DOM 로드 후 실행) --%>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const toggleBtn = document.getElementById('nav-toggle-btn');
        const navMenu = document.getElementById('main-nav-menu');
        const overlay = document.getElementById('offcanvas-overlay');

        if (toggleBtn && navMenu && overlay) {
            
            // 메뉴 열기 함수
            function openMenu() {
                navMenu.classList.add('is-active');
                toggleBtn.classList.add('is-active');
                overlay.classList.add('is-active');
                toggleBtn.setAttribute('aria-expanded', 'true');
                toggleBtn.setAttribute('aria-label', '메뉴 닫기');
                // [추가] 스크롤 방지
                document.body.style.overflow = 'hidden'; 
            }
            
            // 메뉴 닫기 함수
            function closeMenu() {
                navMenu.classList.remove('is-active');
                toggleBtn.classList.remove('is-active');
                overlay.classList.remove('is-active');
                toggleBtn.setAttribute('aria-expanded', 'false');
                toggleBtn.setAttribute('aria-label', '메뉴 열기');
                // [추가] 스크롤 복구
                document.body.style.overflow = '';
            }

            // 1. 햄버거 버튼 클릭 시
            toggleBtn.addEventListener('click', function() {
                if (navMenu.classList.contains('is-active')) {
                    closeMenu();
                } else {
                    openMenu();
                }
            });
            
            // 2. 오버레이(배경) 클릭 시
            overlay.addEventListener('click', function() {
                closeMenu();
            });
        }
    });
</script>