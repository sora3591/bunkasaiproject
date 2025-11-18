<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // ユーザーがログインしているか確認
    bean.User user = (bean.User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/scoremanager/main/login.jsp");
        return;
    }
%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/common/header.jsp"></c:import>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>企画一覧</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css" />
  <style>
    .header-nav {
      display: flex;
      gap: 24px;
      align-items: center;
      font-weight: 600;
      font-size: 14px;
    }
    .header-nav a {
      color: #222;
      text-decoration: none;
      transition: color 0.2s ease;
      position: relative;
    }
    .header-nav a::after {
      content: '';
      position: absolute;
      left: 0;
      bottom: -4px;
      width: 0;
      height: 2px;
      background: #1d8cf8;
      transition: width 0.22s ease;
    }
    .header-nav a:hover {
      color: #1d8cf8;
    }
    .header-nav a:hover::after {
      width: 100%;
    }
  </style>
</head>
<body>




<div class="wrap">
  <div class="title">企画一覧</div>
  <% if (request.getAttribute("error") != null) { %>
    <div class="err"><%= request.getAttribute("error") %></div>
  <% } %>
  <div class="table-wrap">
    <table>
      <thead>
        <tr>
          <th>タイトル</th>
          <th>日時</th>
          <th>場所</th>
          <th>担任名</th>
          <th>ステータス</th>
          <th style="width:100px;"></th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="kikaku" items="${kikakuList}">
          <tr>
            <td>${kikaku.title}</td>
            <td>${kikaku.datetime}</td>
            <td>${kikaku.place}</td>
            <td>${kikaku.teacher}</td>
            <td>
              <c:choose>
                <c:when test="${kikaku.status == '承認完了'}">
                  <span class="tag tag-green">${kikaku.status}</span>
                </c:when>
                <c:when test="${kikaku.status == '承認中'}">
                  <span class="tag tag-blue">${kikaku.status}</span>
                </c:when>
                <c:otherwise>
                  <span class="tag tag-orange">${kikaku.status}</span>
                </c:otherwise>
              </c:choose>
            </td>
            <td>
              <a class="btn btn-ghost" href="<%= request.getContextPath() %>/scoremanager/main/kikaku_detail.jsp?id=${kikaku.id}">開く</a>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
  <div style="margin-top:12px;">
    <a class="btn btn-primary" href="<%= request.getContextPath() %>/scoremanager/main/kikaku_add">企画の新規提出</a>
  </div>
</div>

<!-- ログアウト確認モーダル -->
<div class="modal-bg" id="logoutModal">
  <div class="modal">
    <div>ログアウトしますか？</div>
    <div class="modal-actions">
      <button class="btn btn-primary" onclick="confirmLogout()">はい</button>
      <button class="btn btn-ghost" onclick="closeLogout()">いいえ</button>
    </div>
  </div>
</div>

<script>

  function openLogoutModal() {
    document.getElementById('logoutModal').style.display = 'flex';
  }

  function closeLogout() {
    document.getElementById('logoutModal').style.display = 'none';
  }

  function confirmLogout() {
    location.href = '<%= request.getContextPath() %>/scoremanager/main/logout';
  }

</script>
</body>
</html>