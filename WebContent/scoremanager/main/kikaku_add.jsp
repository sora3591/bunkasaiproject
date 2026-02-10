<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%
  // セッションチェック
  Object userObj = session.getAttribute("user");
  if (userObj == null) {
    response.sendRedirect(request.getContextPath() + "/scoremanager/main/login.jsp");
    return;
  }

  bean.User currentUser = (bean.User) userObj;
  if (!"student".equals(currentUser.getRole()) && !"admin".equals(currentUser.getRole())) {
    response.sendRedirect(request.getContextPath() + "/scoremanager/main/index.jsp");
    return;
  }
%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/common/header.jsp"></c:import>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>企画新規提出</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link rel="stylesheet" href="styles.css" />
</head>
<body>


<div class="wrap">
  <div class="title">企画新規提出（学生）</div>
  <div class="card">
    <form method="post" action="<%= request.getContextPath() %>/scoremanager/main/kikaku_add">
      <div>
        <label class="label">タイトル *</label>
        <input class="input" type="text" name="title" required>
      </div>

      <div class="row">
        <div>
          <label class="label">日時</label>
          <input class="input" type="datetime-local" name="datetime" placeholder="YYYY-MM-DD HH:mm" required>
        </div>
        <div>
          <label class="label">場所</label>
          <input class="input" type="text" name="place" required>
        </div>
      </div>

      <div>
        <label class="label">担任名</label>
        <input class="input" type="text" name="teacher" placeholder="3年1組 佐藤 など" required>
      </div>

      <div>
        <label class="label">概要</label>
        <textarea class="input" name="description" style="min-height:120px;" required></textarea>
      </div>

      <div style="margin-top:12px;">
        <button class="btn btn-primary" type="submit">提出</button>
        <a class="btn btn-ghost" href="<%= request.getContextPath() %>/scoremanager/main/kikaku_list">戻る</a>
      </div>
    </form>

    <% if (request.getAttribute("error") != null) { %>
      <div class="err" style="margin-top:12px;"><%= request.getAttribute("error") %></div>
    <% } %>
  </div>
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

<script src="<%= request.getContextPath() %>/app.js"></script>
<script>
  function openLogout() {
    document.getElementById('logoutModal').style.display = 'flex';
  }

  function closeLogout() {
    document.getElementById('logoutModal').style.display = 'none';
  }

  function confirmLogout() {
    location.href = '<%= request.getContextPath() %>/scoremanager/main/logout';
  }

  document.addEventListener('DOMContentLoaded', function() {
    if (typeof fillWelcome === 'function') fillWelcome();
    if (typeof renderNav === 'function') renderNav();
  });
</script>
</body>
</html>