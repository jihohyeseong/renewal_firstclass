<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>마이페이지</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
<!-- [추가] 아이콘을 위한 Font Awesome CDN -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/global.css">
<style>
    /* --- 테마 유지 --- */
    :root {
        --primary-color: #3f58d4;
        --primary-color-dark: #324ca8; 
        --primary-color-light: #f0f3fd; 
        
        --text-color: #333;
        --text-color-light: #555;
        --border-color: #e0e0e0;
        --bg-color-soft: #f9fafb; /* 연한 회색 배경 */
        --white-color: #ffffff;
        
        --gray-color: #868e96;
        --dark-gray-color: #343a40;
        --light-gray-color: #f8f9fa;
        --shadow-md: 0 4px 12px rgba(0,0,0,0.05);
    }

    * { margin: 0; padding: 0; box-sizing: border-box; }
    html { height: 100%; }
    body {
        display: flex; flex-direction: column; min-height: 100vh;
        font-family: 'Noto Sans KR', sans-serif;
        background-color: var(--bg-color-soft); /* [수정] 통일된 배경색 */
        color: var(--dark-gray-color);
    }
    a { text-decoration: none; color: inherit; }

    /* --- 레이아웃 구조  --- */
    .main-container {
        flex-grow: 1;
        width: 100%;
        max-width: 1100px;
        margin: 20px auto;
        padding: 0 20px;
    }

    .content-wrapper {
        background-color: var(--white-color);
        border-radius: 12px;
        padding: 24px 30px;
        box-shadow: var(--shadow-md);
        margin-bottom: 20px;
    }
    
    /* --- 카드 내부 헤더 --- */
    .content-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 30px; /* 폼과의 간격 */
        border-bottom: 1px solid var(--border-color);
        padding-bottom: 20px;
    }
    .content-header h2 {
        margin: 0;
        color: #111;
        font-size: 24px;
        font-weight: 700;
        display: flex;
        align-items: center;
        gap: 10px;
    }
     .content-header h2 .fa-solid {
         color: var(--primary-color);
     }

    /* 폼 섹션 제목 스타일 */
    .content-wrapper h3 {
        font-size: 18px;
        font-weight: 600;
        color: var(--primary-color);
        margin-top: 10px; 
        margin-bottom: 20px;
        padding-bottom: 10px;
        border-bottom: 1px solid var(--primary-color-light);
        display: flex;
        align-items: center;
        gap: 8px;
    }
    .content-wrapper h3:first-of-type {
        margin-top: 0; 
    }
    .content-wrapper h3 .fa-solid {
        font-size: 16px;
    }


    /* 2열 배치 */
    .form-row {
        display: flex;
        gap: 25px; /* 좌우 입력창 간격 */
    }
    .form-row .form-group {
        flex: 1; /* 양쪽이 동일한 너비를 갖도록 */
    }

    .form-group {
        margin-bottom: 25px;
    }
    
    label {
        display: block;
        font-weight: 500;
        margin-bottom: 8px;
        font-size: 16px;
        position: relative; 
        padding-left: 12px; /* 바가 들어갈 공간 확보 */
    }
    /* 라벨 왼쪽 파란색 바 */
    label::before {
        content: '';
        position: absolute;
        left: 0;
        top: 50%;
        transform: translateY(-50%);
        width: 4px;
        height: 16px; 
        background-color: var(--primary-color);
        border-radius: 2px;
    }
    
    input[type="text"] {
        width: 100%;
        padding: 12px 15px;
        border: 1px solid var(--border-color);
        border-radius: 8px;
        transition: all 0.2s ease-in-out;
        font-size: 16px;
    }
    input:focus {
        border-color: var(--primary-color);
        box-shadow: 0 0 0 3px var(--primary-color-light);
        outline: none;
    }
    
    /* readonly 필드 스타일 */
    input[readonly] {
        background-color: var(--light-gray-color);
        cursor: default;
        color: var(--text-color-light);
    }
    
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
    .btn-primary:hover { background-color: var(--primary-color-dark); }
    
    .btn-secondary {
        background-color: #e9ecef;
        color: #495057;
        border-color: #dee2e6;
    }
    .btn-secondary:hover {
        background-color: #d1d5db;
    }
    
    /*  아웃라인 버튼 스타일 */
    .btn-outline-primary {
        background-color: var(--white-color);
        color: var(--primary-color);
        border: 1px solid var(--primary-color);
        font-weight: 500;
    }
    .btn-outline-primary:hover {
        background-color: var(--primary-color-light);
    }
    
    /* 우편번호 검색 영역 스타일 */
    .zip-search-wrapper {
        display: flex;
        gap: 10px;
        align-items: center;
    }
    .zip-search-wrapper input {
        flex: 1;
    }

    /* 주소검색 버튼  */
    .btn-search {
        padding: 12px 20px;
    }

    hr {
        margin: 40px 0 35px;
        border: none;
        border-top: 1px solid var(--border-color);
    }

    /* 하단 버튼 영역 */
    .submit-button-container {
        display: flex;
        justify-content: center;
        gap: 15px;
        margin-top: 40px;
        padding-top: 30px;
        border-top: 1px solid var(--border-color); 
    }
    .submit-button-container .btn {
        padding: 12px 40px;
        font-size: 16px;
    }
    
    .footer {
        text-align: center;
        padding: 20px 0;
        font-size: 14px;
        color: var(--gray-color);
    }

	/* 반응형 스타일 */
    /* 992px 이하 (태블릿) */
    @media (max-width: 992px) {
        /* [수정] 2열 레이아웃을 1열로 변경 */
        .form-row {
            flex-direction: column;
            gap: 0; /* form-group의 margin-bottom으로 간격 제어 */
        }
    }

    /* 768px 이하 (모바일) */
    @media (max-width: 768px) {
        .main-container {
            margin: 10px auto; /* 상하 여백 축소 */
            padding: 0 10px; /* 좌우 여백 축소 */
        }
    
        /* 카드 내부 패딩 */
        .content-wrapper {
            padding: 20px 15px;
        }

        .content-header {
            font-size: 22px;
            margin-bottom: 30px;
            padding-bottom: 15px;
        }
         .content-header h2 {
             font-size: 22px;
         }
        
        .form-group {
            margin-bottom: 20px;
        }

        /* 우편번호/주소검색 버튼 쌓기 */
        .zip-search-wrapper {
            flex-direction: column;
            align-items: stretch;
            gap: 10px; /* 입력창과 버튼 사이 간격 */
        }
        
        .zip-search-wrapper input {
            flex: none; 
            width: 100%;
        }
        
        .zip-search-wrapper button {
            width: 100%;
        }

        .submit-button-container .btn {
            flex: 1;
        }
        
        /* 모바일에서 iOS 자동 줌인 방지 */
        input[type="text"] {
            font-size: 16px;
        }
    }
</style>
</head>
<body>

<c:set var="role" value="${user.role}" />
<c:choose>
    <c:when test="${role == 'ROLE_CORP'}">
        <jsp:include page="../company/compheader.jsp"/>
        <style>
            :root{
                --primary-color:#24A960;
                --primary-color-dark: #1F8A4D;
                --primary-color-light:rgba(36,169,96,.08);
                --success-color:#24A960;
            }
             .btn-primary:hover { background-color: #1F8A4D; }
             .content-header h2 .fa-solid { color: var(--primary-color); }
             
             /* 기업회원용 라벨 바 */
             label::before {
                 background-color: var(--primary-color);
             }
             
             /* 기업회원용 섹션 제목 */
             .content-wrapper h3 {
                color: var(--primary-color);
                border-bottom-color: var(--primary-color-light);
             }
             input:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 3px var(--primary-color-light);
            }
             /* 기업회원용 아웃라인 버튼 */
             .btn-outline-primary {
                color: var(--primary-color);
                border-color: var(--primary-color);
             }
             .btn-outline-primary:hover {
                 background-color: var(--primary-color-light);
             }
        </style>
    </c:when>
    <c:otherwise>
        <jsp:include page="header.jsp"/>
    </c:otherwise>
</c:choose>

    
    <main class="main-container">
        <div class="content-wrapper">
    
            <!-- 카드 헤더 -->
            <div class="content-header">
                <h2><i class="fa-solid fa-user-circle"></i> 마이페이지</h2>
            </div>
    
            <form action="${pageContext.request.contextPath}/mypage/updateAddress" method="post" onsubmit="return confirm('수정하시겠습니까?');">
                
                <input type="hidden" name="id" value="${user.id}" />
                
                <!-- 섹션 제목 -->
                <h3><i class="fa-solid fa-user"></i> 기본 정보</h3>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>이름</label>
                        <input type="text" name="name" value="${user.name}" readonly />
                    </div>
                    <div class="form-group">
                        <label>전화번호</label>
                        <input type="text" name="phoneNumber" value="${user.phoneNumber}" readonly/>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>주민등록번호</label>
                        <c:set var="rrnRaw" value="${user.registrationNumber}" />
                        <c:set var="rrnDigits" value="${fn:replace(rrnRaw, '-', '')}" />
                        <input type="text" value="${fn:substring(rrnDigits,0,6)}-${fn:substring(rrnDigits,6,13)}" readonly>
                    </div>
                    <div class="form-group">
                        <label>아이디</label>
                        <input type="text" name="username" value="${user.username}" readonly />
                    </div>
                </div>
                
                <hr> 

                <h3><i class="fa-solid fa-map-location-dot"></i> 주소 정보</h3>

                <div class="form-group">
                    <label>우편번호</label>
                    <div class="zip-search-wrapper">
                        <input type="text" id="zipNumber" name="zipNumber" value="${user.zipNumber}" readonly>
                        <!-- [수정] class 변경 -->
                        <button type="button" class="btn btn-search btn-outline-primary" onclick="execDaumPostcode()">주소검색</button>
                    </div>
                </div>

                <div class="form-group">
                    <label>기본주소</label>
                    <input type="text" id="addressBase" name="addressBase" value="${user.addressBase}" readonly />
                </div>

                <div class="form-group">
                    <label>상세주소</label>
                    <input type="text" id="addressDetail" name="addressDetail" value="${user.addressDetail}" />
                </div>

                <div class="submit-button-container">
                    <button type="submit" class="btn btn-primary">정보 수정</button>
                    <a href="${pageContext.request.contextPath}/user/main" class="btn bottom-btn btn-outline-primary">목록으로</a>
                </div>
                    
            </form>
            
        </div> <!-- .content-wrapper 끝 -->
    </main>

    <footer class="footer">
        <p>© 2025 육아휴직서비스. All rights reserved.</p>
    </footer>

    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script>
        function execDaumPostcode() {
            new daum.Postcode({
                oncomplete: function(data) {
                    document.getElementById("zipNumber").value = data.zonecode;
                    document.getElementById("addressBase").value = data.address;
                    document.getElementById("addressDetail").focus();
                }
            }).open();
        }
    </script>
</body>
</html>