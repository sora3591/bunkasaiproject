<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>ログイン</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css" />
</head>
<body>
<div class="top-bar">
  <div class="nav-left">
    <a href="<%= request.getContextPath() %>/scoremanager/main/index.jsp">
      <img src="https://cdn-icons-png.flaticon.com/512/1946/1946436.png" class="icon-home" alt="home">
    </a>
    <div class="system-title">文化祭システム</div>
  </div>
  <div class="nav-right">ようこそ</div>
</div>
<div class="wrap">
  <div class="title">ログイン</div>
  <div class="card">
    <!-- Servletにフォーム送信 -->
    <form method="post" action="<%= request.getContextPath() %>/scoremanager/main/login">
      <div class="row">
        <div>
          <label class="label">ユーザーID</label>
          <input class="input" type="text" name="id" required>
        </div>
      </div>
      <div class="row">
        <div>
          <label class="label">パスワード</label>
          <input class="input" type="password" name="password" required>
        </div>
      </div>
      <div style="margin-top:12px;">
        <button class="btn btn-primary" type="submit">ログイン</button>
        <a class="btn btn-ghost" href="<%= request.getContextPath() %>/scoremanager/main/register.jsp">新規登録</a>
      </div>
    </form>
    <% if (request.getAttribute("error") != null) { %>
      <div class="err"><%= request.getAttribute("error") %></div>
    <% } %>
  </div>
</div>
</body>
</html>