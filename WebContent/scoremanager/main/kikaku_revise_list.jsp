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
<c:import url="/common/header.jsp"></c:import>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>企画修正一覧</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css" />
</head>
<body>
<div class="wrap">
  <div class="title">企画修正一覧</div>
  <% if (request.getAttribute("error") != null) { %>
    <div class="err"><%= request.getAttribute("error") %></div>
  <% } %>

  <%
    java.util.List<bean.Kikaku> kikakuList = (java.util.List<bean.Kikaku>) request.getAttribute("kikakuList");
    System.out.println("=== kikaku_revise_list.jsp DEBUG ===");
    if (kikakuList != null) {
      System.out.println("Total kikaku list size: " + kikakuList.size());
      for (bean.Kikaku k : kikakuList) {
        System.out.println("Kikaku - ID: " + k.getId() + ", Title: " + k.getTitle() + ", Status: '" + k.getStatus() + "'");
      }
    } else {
      System.out.println("kikakuList is null");
    }
  %>

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
          <c:if test="${kikaku.status == '修正依頼' || kikaku.status == '却下'}">
            <tr>
              <td>${kikaku.title}</td>
              <td>${kikaku.datetime}</td>
              <td>${kikaku.place}</td>
              <td>${kikaku.teacher}</td>
              <td>
                <c:choose>
                  <c:when test="${kikaku.status == '修正依頼'}">
                    <span class="tag tag-orange">${kikaku.status}</span>
                  </c:when>
                  <c:when test="${kikaku.status == '却下'}">
                    <span class="tag tag-red">${kikaku.status}</span>
                  </c:when>
                </c:choose>
              </td>
              <td>
                <a class="btn btn-primary" href="<%= request.getContextPath() %>/scoremanager/main/kikaku_edit?id=${kikaku.id}">修正</a>
              </td>
            </tr>
          </c:if>
        </c:forEach>
      </tbody>
    </table>
  </div>

  <c:set var="hasData" value="false" />
  <c:forEach var="kikaku" items="${kikakuList}">
    <c:if test="${kikaku.status == '修正依頼' || kikaku.status == '却下'}">
      <c:set var="hasData" value="true" />
    </c:if>
  </c:forEach>

  <c:if test="${!hasData}">
    <div style="text-align: center; margin-top: 20px; color: #666;">
      修正・却下された企画はありません
    </div>
  </c:if>

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