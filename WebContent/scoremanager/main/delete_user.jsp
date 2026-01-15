<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
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

  // リクエストメソッドチェック
  String method = request.getMethod();
  User targetUser = null;
  String errorMsg = null;
  boolean deleted = false;

  if ("GET".equals(method)) {
    // 削除対象ユーザーを取得
    String userId = request.getParameter("id");
    if (userId == null || userId.isEmpty()) {
      response.sendRedirect(request.getContextPath() + "/scoremanager/main/users_list.jsp");
      return;
    }

    try {
      UserDao dao = new UserDao();
      targetUser = dao.get(userId);
      if (targetUser == null) {
        errorMsg = "ユーザーが見つかりません";
      }
    } catch (Exception e) {
      errorMsg = "ユーザー取得に失敗しました: " + e.getMessage();
      e.printStackTrace();
    }
  } else if ("POST".equals(method)) {
    // 削除処理実行
    String userId = request.getParameter("id");
    String confirm = request.getParameter("confirm");

    if (userId == null || userId.isEmpty()) {
      errorMsg = "ユーザーIDが指定されていません";
    } else if (!"yes".equals(confirm)) {
      errorMsg = "削除がキャンセルされました";
    } else {
      try {
        UserDao dao = new UserDao();
        boolean result = dao.delete(userId);
        if (result) {
          deleted = true;
          System.out.println("=== User Deleted: " + userId + " ===");
        } else {
          errorMsg = "ユーザーが見つかりません";
        }
      } catch (Exception e) {
        errorMsg = "削除に失敗しました: " + e.getMessage();
        e.printStackTrace();
      }
    }
  }
%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/common/header.jsp"></c:import>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>ユーザー削除</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link rel="stylesheet" href="styles.css" />
</head>
<body>

<div class="wrap">
  <% if (deleted) { %>
    <!-- 削除完了画面 -->
    <div class="title">ユーザー削除完了</div>
    <div style="padding:20px; text-align:center;">
      <p style="font-size:16px; margin-bottom:20px;">ユーザーを削除しました。</p>
      <a class="btn btn-primary" href="<%= request.getContextPath() %>/scoremanager/main/users_list.jsp">ユーザー一覧に戻る</a>
    </div>

  <% } else if (targetUser != null) { %>
    <!-- 削除確認画面 -->
    <div class="title">ユーザー削除確認</div>

    <% if (errorMsg != null) { %>
      <div class="err"><%= errorMsg %></div>
    <% } %>

    <div style="padding:20px; background-color:#f9f9f9; border-radius:4px; margin-bottom:20px;">
      <p style="margin-bottom:10px;"><strong>削除対象ユーザー</strong></p>
      <table style="width:100%; border-collapse:collapse;">
        <tr>
          <td style="padding:8px; border-bottom:1px solid #ddd; width:150px;">ID</td>
          <td style="padding:8px; border-bottom:1px solid #ddd;"><%= targetUser.getId() %></td>
        </tr>
        <tr>
          <td style="padding:8px; border-bottom:1px solid #ddd;">氏名</td>
          <td style="padding:8px; border-bottom:1px solid #ddd;"><%= targetUser.getName() %></td>
        </tr>
        <tr>
          <td style="padding:8px; border-bottom:1px solid #ddd;">ロール</td>
          <td style="padding:8px; border-bottom:1px solid #ddd;"><%= targetUser.getRole() %></td>
        </tr>
        <tr>
          <td style="padding:8px; border-bottom:1px solid #ddd;">メール</td>
          <td style="padding:8px; border-bottom:1px solid #ddd;"><%= targetUser.getEmail() != null ? targetUser.getEmail() : "" %></td>
        </tr>
      </table>
    </div>

    <div style="padding:20px; background-color:#fff3cd; border:1px solid #ffc107; border-radius:4px; margin-bottom:20px;">
      <p style="margin:0; color:#856404;"><strong>⚠ 警告:</strong> このユーザーを削除します。この操作は取り消せません。本当に削除してよろしいですか？</p>
    </div>

    <div style="display:flex; gap:10px;">
      <form method="POST" style="display:inline;">
        <input type="hidden" name="id" value="<%= targetUser.getId() %>">
        <input type="hidden" name="confirm" value="yes">
        <button type="submit" class="btn btn-danger">削除する</button>
      </form>
      <a class="btn btn-ghost" href="<%= request.getContextPath() %>/scoremanager/main/users_list.jsp">キャンセル</a>
    </div>

  <% } else { %>
    <!-- エラー画面 -->
    <div class="title">エラー</div>
    <% if (errorMsg != null) { %>
      <div class="err"><%= errorMsg %></div>
    <% } %>
    <div style="margin-top:20px;">
      <a class="btn btn-primary" href="<%= request.getContextPath() %>/scoremanager/main/users_list.jsp">ユーザー一覧に戻る</a>
    </div>
  <% } %>
</div>

<script src="<%= request.getContextPath() %>/app.js"></script>
<script>
  document.addEventListener('DOMContentLoaded', function() {
    if (typeof fillWelcome === 'function') fillWelcome();
    if (typeof renderNav === 'function') renderNav();
  });
</script>
</body>
</html>