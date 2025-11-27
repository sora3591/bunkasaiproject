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

  // 削除処理（POSTリクエスト時）
  if ("POST".equals(request.getMethod())) {
    String action = request.getParameter("action");
    System.out.println("=== POST Request: action=" + action + " ===");
    if ("delete".equals(action)) {
      String userId = request.getParameter("delete_id");
      System.out.println("=== Deleting User: " + userId + " ===");
      try {
        UserDao dao = new UserDao();
        boolean result = dao.delete(userId);
        System.out.println("=== Delete Result: " + result + " ===");
        if (result) {
          response.setStatus(HttpServletResponse.SC_OK);
          response.setContentType("application/json;charset=UTF-8");
          response.getWriter().write("{\"success\":true}");
          System.out.println("=== User Successfully Deleted: " + userId + " ===");
          return;
        } else {
          response.setStatus(HttpServletResponse.SC_NOT_FOUND);
          response.setContentType("application/json;charset=UTF-8");
          response.getWriter().write("{\"error\":\"ユーザーが見つかりません\"}");
          System.out.println("=== User Not Found: " + userId + " ===");
          return;
        }
      } catch (Exception e) {
        e.printStackTrace();
        System.out.println("=== Delete Exception: " + e.getMessage() + " ===");
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write("{\"error\":\"削除に失敗しました: " + e.getMessage() + "\"}");
        return;
      }
    }
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
                <button class="btn btn-danger" onclick="delUser('<%= java.net.URLEncoder.encode(u.getId(), "UTF-8") %>')">削除</button>
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
  function delUser(encodedId) {
    if (!confirm('削除しますか？')) return;

    console.log('Deleting user:', encodedId);

    const formData = new FormData();
    formData.append('action', 'delete');
    formData.append('delete_id', encodedId);

    fetch('<%= request.getContextPath() %>/scoremanager/main/users_list.jsp', {
      method: 'POST',
      body: formData
    }).then(response => {
      console.log('Response status:', response.status);
      return response.text().then(text => {
        console.log('Response text:', text);
        return { status: response.status, text: text };
      });
    }).then(data => {
      try {
        const json = JSON.parse(data.text);
        if (data.status === 200 && json.success) {
          console.log('Delete successful');
          location.reload();
        } else {
          console.error('Delete failed:', json.error || 'Unknown error');
          alert('削除に失敗しました: ' + (json.error || 'Unknown error'));
        }
      } catch (e) {
        console.error('JSON parse error:', e);
        alert('削除に失敗しました: ' + e.message);
      }
    }).catch(error => {
      console.error('Fetch error:', error);
      alert('削除に失敗しました: ' + error.message);
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