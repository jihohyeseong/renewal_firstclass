<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<!-- 센터 찾기 모달 -->
<div id="center-modal" class="modal-overlay" style="display:none;">
  <div class="modal-content">
    <div class="modal-header">
      <h2>고용센터 검색</h2>
      <button type="button" class="close-modal-btn" aria-label="close">&times;</button>
    </div>
    <div class="modal-body">
      <table class="center-table">
        <thead>
          <tr>
            <th>센터명</th>
            <th>주소</th>
            <th>전화번호</th>
            <th>선택</th>
          </tr>
        </thead>
        <tbody id="center-list-body">

        </tbody>
      </table>
    </div>
  </div>
</div>
</body>
</html>