<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html><html lang="ja"><head>
<meta charset="UTF-8"><title>文化祭システム - ホーム</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body>
<div class="top-bar">
  <div class="nav-left">
    <a href="index.jsp"><img src="https://cdn-icons-png.flaticon.com/512/1946/1946436.png" class="icon-home" alt="home"></a>
    <div class="system-title">文化祭システム</div>
  <div class="nav-center" id="navCenter"></div>

  </div>
  <div class="nav-right">ようこそ</div>
</div>
<div class="main-container">
  <img src="images/main.jpg" class="main-image" alt="main">
  <div class="event-grid">
    <img src="images/event1.jpg" class="event-img" alt="e1">
    <img src="images/event2.jpg" class="event-img" alt="e2">
  </div>
  <div class="sns-container">
    <img src="https://cdn-icons-png.flaticon.com/512/124/124034.png" class="sns-icon">
    <img src="https://cdn-icons-png.flaticon.com/512/733/733547.png" class="sns-icon">
    <img src="https://cdn-icons-png.flaticon.com/512/733/733635.png" class="sns-icon">
    <img src="https://cdn-icons-png.flaticon.com/512/1384/1384060.png" class="sns-icon">
  </div>
  <div class="footer">〒101-8551 東京都千代田区神田三崎町2-4-1</div>
</div>
<div class="modal-bg" id="logoutModal">
  <div class="modal">
    <div>ログアウトしますか？</div>
    <div class="modal-actions">
      <button class="btn btn-primary" onclick="confirmLogout()">はい</button>
      <button class="btn btn-ghost" onclick="closeLogout()">いいえ</button>
    </div>
  </div>
</div>



<script src="app.js"></script>
<script>requireAuth(); fillWelcome(); renderNav(); renderNav();</script>
</body></html>