<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ page import="bean.User" %>
<%@ page import="bean.Map" %>
<%@ page import="dao.MapDao" %>
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
  Map targetMap = null;
  String errorMsg = null;
  boolean deleted = false;

  if ("GET".equals(method)) {
    // 削除対象ユーザーを取得
    String mapId = request.getParameter("id");
    if (mapId == null || mapId.isEmpty()) {
      response.sendRedirect(request.getContextPath() + "/scoremanager/main/map_list.jsp");
      return;
    }

    try {
      MapDao dao = new MapDao();
      targetMap = dao.get(mapId);
      if (targetMap == null) {
        errorMsg = "校内図が見つかりません";
      }
    } catch (Exception e) {
      errorMsg = "校内図取得に失敗しました: " + e.getMessage();
      e.printStackTrace();
    }
  } else if ("POST".equals(method)) {
    // 削除処理実行
    String mapId = request.getParameter("id");
    String confirm = request.getParameter("confirm");

    if (mapId == null || mapId.isEmpty()) {
      errorMsg = "校内図が指定されていません";
    } else if (!"yes".equals(confirm)) {
      errorMsg = "削除がキャンセルされました";
    } else {
      try {
        MapDao dao = new MapDao();
        boolean result = dao.delete(mapId);
        if (result) {
          deleted = true;

        } else {
          errorMsg = "校内図が見つかりません";
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
<title>校内図削除</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link rel="stylesheet" href="styles.css" />
</head>
<body>

<div class="wrap">
  <% if (deleted) { %>
    <!-- 削除完了画面 -->
    <div class="title">校内図削除完了</div>
    <div style="padding:20px; text-align:center;">
      <p style="font-size:16px; margin-bottom:20px;">校内図を削除しました。</p>
      <a class="btn btn-primary" href="<%= request.getContextPath() %>/scoremanager/main/map_list.jsp">校内図一覧に戻る</a>
    </div>

  <% } else if (targetMap != null) { %>
    <!-- 削除確認画面 -->
    <div class="title">校内図削除確認</div>

    <% if (errorMsg != null) { %>
      <div class="err"><%= errorMsg %></div>
    <% } %>



    <div style="padding:20px; background-color:#fff3cd; border:1px solid #ffc107; border-radius:4px; margin-bottom:20px;">
      <p style="margin:0; color:#856404;"><strong>⚠ 警告:</strong> この校内図を削除します。この操作は取り消せません。本当に削除してよろしいですか？</p>
    </div>

    <div style="display:flex; gap:10px;">
      <form method="POST" style="display:inline;">
        <input type="hidden" name="id" value="<%= targetMap.getId() %>">
        <input type="hidden" name="confirm" value="yes">
        <button type="submit" class="btn btn-danger">削除する</button>
      </form>
      <a class="btn btn-ghost" href="<%= request.getContextPath() %>/scoremanager/main/map_list.jsp">キャンセル</a>
    </div>

  <% } else { %>
    <!-- エラー画面 -->
    <div class="title">エラー</div>
    <% if (errorMsg != null) { %>
      <div class="err"><%= errorMsg %></div>
    <% } %>
    <div style="margin-top:20px;">
      <a class="btn btn-primary" href="<%= request.getContextPath() %>/scoremanager/main/map_list.jsp">校内図一覧に戻る</a>
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