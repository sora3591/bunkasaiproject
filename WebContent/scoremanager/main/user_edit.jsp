<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ page import="bean.User" %>
<%
  // セッションチェック
  Object userObj = session.getAttribute("user");
  if (userObj == null) {
    response.sendRedirect(request.getContextPath() + "/scoremanager/main/login.jsp");
    return;
  }

  User currentUser = (User) userObj;
  if (!"admin".equals(currentUser.getRole())) {
    response.sendRedirect(request.getContextPath() + "/scoremanager/main/index.jsp");
    return;
  }

  User editUser = (User) request.getAttribute("user");
  if (editUser == null) {
    editUser = new User();
  }
%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>ユーザー編集</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link rel="stylesheet" href="styles.css" />
</head>
<body>
<div class="top-bar">
  <div class="nav-left">
    <a href="<%= request.getContextPath() %>/scoremanager/main/index.jsp">
      <img src="https://cdn-icons-png.flaticon.com/512/1946/1946436.png" class="icon-home" alt="home">
    </a>
    <div class="system-title">文化祭システム</div>
    <div class="nav-center" id="navCenter"></div>
  </div>
  <div class="nav-right">
    <span id="welcome">ようこそ</span>
    <a href="javascript:void(0)" onclick="openLogout()" style="color:#1d8cf8; cursor:pointer; text-decoration:none;">ログアウト</a>
  </div>
</div>

<div class="wrap">
  <div class="title">ユーザー編集</div>
  <div class="card">
    <form method="post" action="<%= request.getContextPath() %>/scoremanager/main/edit_user">
      <div class="row">
        <div>
          <label class="label">ユーザーID</label>
          <input class="input" type="text" name="id" value="<%= editUser.getId() != null ? editUser.getId() : "" %>" readonly>
        </div>
      </div>
      <div class="row">
        <div>
          <label class="label">氏名 *</label>
          <input class="input" type="text" name="name" value="<%= editUser.getName() != null ? editUser.getName() : "" %>" required>
        </div>
        <div>
          <label class="label">ロール</label>
          <select name="role" class="select">
            <option value="student" <%= "student".equals(editUser.getRole()) ? "selected" : "" %>>学生</option>
            <option value="admin" <%= "admin".equals(editUser.getRole()) ? "selected" : "" %>>管理者</option>
          </select>
        </div>
      </div>
      <div class="row">
        <div>
          <label class="label">学年・クラス</label>
          <input class="input" type="text" name="classNum" value="<%= editUser.getClassNum() != null ? editUser.getClassNum() : "" %>" placeholder="例）3-1">
        </div>
        <div>
          <label class="label">メール</label>
          <input class="input" type="email" name="email" value="<%= editUser.getEmail() != null ? editUser.getEmail() : "" %>">
        </div>
      </div>
      <div class="row">
        <div>
          <label class="label">パスワード（変更する場合のみ入力）</label>
          <input class="input" type="password" name="password">
        </div>
      </div>
      <div style="margin-top:12px;">
        <button class="btn btn-primary" type="submit">更新</button>
        <a class="btn btn-ghost" href="<%= request.getContextPath() %>/scoremanager/main/users_list">戻る</a>
      </div>
    </form>
    <% if (request.getAttribute("error") != null) { %>
      <div class="err"><%= request.getAttribute("error") %></div>
    <% } %>
    <% if (request.getAttribute("success") != null) { %>
      <div class="success"><%= request.getAttribute("success") %></div>
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