<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // ユーザーがログインしているか確認
    bean.User user = (bean.User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>企画一覧</title>
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
  <div class="nav-right">ようこそ <%= user.getName() %> さん</div>
</div>

<div class="wrap">
  <div class="title">企画一覧</div>

  <% if (request.getAttribute("error") != null) { %>
    <div class="err"><%= request.getAttribute("error") %></div>
  <% } %>

  <div class="table-wrap">
    <table>
      <thead>
        <tr>
          <th style="width:90px;">アイコン</th>
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
            <td><img class="thumb" src="<%= request.getContextPath() %>/images/${kikaku.id}.jpg" onerror="this.src='<%= request.getContextPath() %>/images/main.jpg'" style="width:80px; height:60px; object-fit:cover;"></td>
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
    <a class="btn btn-primary" href="<%= request.getContextPath() %>/scoremanager/main/kikaku_add.jsp">企画の新規提出</a>
    <form method="post" action="<%= request.getContextPath() %>/logout" style="display:inline;">
      <button class="btn btn-ghost" type="submit">ログアウト</button>
    </form>
  </div>
</div>

</body>
</html>