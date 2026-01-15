<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ page import="java.util.List" %>
<%@ page import="bean.User" %>
<%@ page import="dao.UserDao" %>
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

  // ユーザー一覧を取得
  List<User> users = new java.util.ArrayList<>();
  String errorMsg = null;
  try {
    UserDao dao = new UserDao();
    users = dao.getAll();
    System.out.println("=== Users Retrieved: " + users.size() + " ===");
    for (User u : users) {
      System.out.println("User: " + u.getId() + ", " + u.getName());
    }
  } catch (Exception e) {
    errorMsg = "ユーザー一覧の取得に失敗しました: " + e.getMessage();
    e.printStackTrace();
  }
%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/common/header.jsp"></c:import>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>ユーザー一覧</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link rel="stylesheet" href="styles.css" />
</head>
<body>

<div class="wrap">
  <div class="title">ユーザー一覧</div>

  <% if (errorMsg != null) { %>
    <div class="err"><%= errorMsg %></div>
  <% } %>

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
        <% if (users.isEmpty()) { %>
          <tr>
            <td colspan="6" style="text-align:center; padding:20px;">ユーザーが登録されていません</td>
          </tr>
        <% } else { %>
          <% for (User u : users) { %>
            <tr>
              <td><%= u.getId() %></td>
              <td><%= u.getName() %></td>
              <td><%= u.getRole() %></td>
              <td><%= u.getClassNum() != null ? u.getClassNum() : "" %></td>
              <td><%= u.getEmail() != null ? u.getEmail() : "" %></td>
              <td>
                <a class="btn btn-ghost" href="<%= request.getContextPath() %>/scoremanager/main/edit_user?id=<%= java.net.URLEncoder.encode(u.getId(), "UTF-8") %>">編集</a>
                <a class="btn btn-danger" href="<%= request.getContextPath() %>/scoremanager/main/delete_user.jsp?id=<%= java.net.URLEncoder.encode(u.getId(), "UTF-8") %>">削除</a>
              </td>
            </tr>
          <% } %>
        <% } %>
      </tbody>
    </table>
  </div>
  <div style="margin-top:12px;">
    <a class="btn btn-primary" href="<%= request.getContextPath() %>/scoremanager/main/user_add">ユーザー追加</a>
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