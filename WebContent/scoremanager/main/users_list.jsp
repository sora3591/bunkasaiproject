<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ page import="java.util.List" %>
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

  @SuppressWarnings("unchecked")
  List<User> users = (List<User>) request.getAttribute("users");
  if (users == null) {
    users = new java.util.ArrayList<>();
  }
%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>ユーザー一覧</title>
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
  <div class="title">ユーザー一覧</div>
  <div class="table-wrap">
    <table>
      <thead>
        <tr>
          <th>ID</th>
          <th>氏名</th>
          <th>ロール</th>
          <th>クラス</th>
          <th>メール</th>
          <th style="width:160px;"></th>
        </tr>
      </thead>
      <tbody id="rows">
        <% for (User u : users) { %>
          <tr>
            <td><%= u.getId() %></td>
            <td><%= u.getName() %></td>
            <td><%= u.getRole() %></td>
            <td><%= u.getClassNum() != null ? u.getClassNum() : "" %></td>
            <td><%= u.getEmail() != null ? u.getEmail() : "" %></td>
            <td>
              <a class="btn btn-ghost" href="<%= request.getContextPath() %>/scoremanager/main/edit_user?id=<%= java.net.URLEncoder.encode(u.getId(), "UTF-8") %>">編集</a>
              <button class="btn btn-danger" onclick="delUser('<%= u.getId() %>','<%= java.net.URLEncoder.encode(u.getId(), "UTF-8") %>')">削除</button>
            </td>
          </tr>
        <% } %>
      </tbody>
    </table>
  </div>
  <div style="margin-top:12px;">
    <a class="btn btn-primary" href="<%= request.getContextPath() %>/scoremanager/main/user_add.jsp">ユーザー追加</a>
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
  function delUser(id, encodedId) {
    if (!confirm('削除しますか？')) return;

    fetch('<%= request.getContextPath() %>/scoremanager/main/delete_user?id=' + encodedId, {
      method: 'POST'
    }).then(response => {
      if (response.ok) {
        // 削除成功時はページをリロード
        location.reload();
      } else {
        alert('削除に失敗しました');
      }
    }).catch(error => {
      console.error('Error:', error);
      alert('削除に失敗しました');
    });
  }

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