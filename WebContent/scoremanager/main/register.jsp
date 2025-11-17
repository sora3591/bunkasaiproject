<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>新規登録</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link rel="stylesheet" href="styles.css" />
</head>
<body>
<div class="top-bar">
  <div class="nav-left">
    <a href="<%= request.getContextPath() %>/index.jsp">
      <img src="https://cdn-icons-png.flaticon.com/512/1946/1946436.png" class="icon-home" alt="home">
    </a>
    <div class="system-title">文化祭システム</div>
  </div>
  <div class="nav-right">ようこそ</div>
</div>

<div class="wrap">
  <div class="title">新規登録</div>
  <div class="card">
    <form method="post" action="<%= request.getContextPath() %>/scoremanager/main/register">
      <div class="row">
        <div>
          <label class="label">ユーザーID</label>
          <input class="input" name="id" required>
        </div>
        <div>
          <label class="label">氏名</label>
          <input class="input" name="name" required>
        </div>
      </div>
      <div class="row">
        <div>
          <label class="label">学年・クラス</label>
          <input class="input" name="classNum" placeholder="例）3-1">
        </div>
        <div>
          <label class="label">メール</label>
          <input class="input" name="email">
        </div>
      </div>
      <div class="row">
        <div>
          <label class="label">ロール</label>
          <select name="role" class="select">
            <option value="student">学生</option>
            <option value="admin">管理者</option>
          </select>
        </div>
        <div></div>
      </div>
      <div style="margin-top:12px;">
        <button class="btn btn-primary" type="submit">登録</button>
        <a class="btn btn-ghost" href="<%= request.getContextPath() %>/scoremanager/main/login.jsp"">戻る</a>
      </div>
    </form>

    <% if (request.getAttribute("error") != null) { %>
      <div class="err"><%= request.getAttribute("error") %></div>
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
  fillWelcome();
  renderNav();
</script>
</body>
</html>