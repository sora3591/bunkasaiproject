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
  <title>企画修正</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css" />
</head>
<body>
<div class="wrap">
  <div class="title">企画修正：${kikaku.title}</div>

  <% if (request.getAttribute("error") != null) { %>
    <div class="err"><%= request.getAttribute("error") %></div>
  <% } %>

  <% if (request.getAttribute("message") != null) { %>
    <div class="success"><%= request.getAttribute("message") %></div>
  <% } %>

  <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px; margin-bottom: 24px;">
    <!-- 左側：編集フォーム -->
    <div class="card">
      <div class="subtitle">企画情報を修正</div>
      <form method="post" action="<%= request.getContextPath() %>/scoremanager/main/kikaku_edit">
        <input type="hidden" name="id" value="${kikaku.id}">

        <div class="form-group">
          <label for="title">企画タイトル <span class="required">*</span></label>
          <input type="text" id="title" name="title" value="${kikaku.title}" required>
        </div>

        <div class="form-group">
          <label for="datetime">開催日時 <span class="required">*</span></label>
          <input type="datetime-local" id="datetime" name="datetime" value="${kikaku.datetime}" required>
        </div>

        <div class="form-group">
          <label for="place">開催場所 <span class="required">*</span></label>
          <input type="text" id="place" name="place" value="${kikaku.place}" required>
        </div>

        <div class="form-group">
          <label for="description">説明</label>
          <textarea id="description" name="description" rows="5">${kikaku.description}</textarea>
        </div>

        <div class="form-actions">
          <button type="submit" class="btn btn-primary">更新して再提出</button>
          <a href="<%= request.getContextPath() %>/scoremanager/main/kikaku_revise_list" class="btn btn-ghost">キャンセル</a>
        </div>
      </form>
    </div>

    <!-- 右側：詳細情報 -->
    <div class="card">
      <div class="subtitle">現在の情報</div>

      <div style="margin-bottom: 16px;">
        <div class="subtitle" style="margin-bottom: 6px;">ステータス</div>
        <c:choose>
          <c:when test="${kikaku.status == '修正依頼'}">
            <span class="tag tag-orange">${kikaku.status}</span>
          </c:when>
          <c:when test="${kikaku.status == '却下'}">
            <span class="tag tag-red">${kikaku.status}</span>
          </c:when>
          <c:otherwise>
            <span class="tag">${kikaku.status}</span>
          </c:otherwise>
        </c:choose>
      </div>

      <div style="margin-bottom: 16px;">
        <div class="subtitle" style="margin-bottom: 6px;">担任名</div>
        <div>${kikaku.teacher}</div>
      </div>

      <div style="margin-bottom: 16px;">
        <div class="subtitle" style="margin-bottom: 6px;">作成日時</div>
        <div>${kikaku.datetime}</div>
      </div>

      <div style="margin-bottom: 16px;">
        <div class="subtitle" style="margin-bottom: 6px;">開催場所</div>
        <div>${kikaku.place}</div>
      </div>

      <div style="margin-bottom: 16px;">
        <div class="subtitle" style="margin-bottom: 6px;">説明</div>
        <div>${kikaku.description}</div>
      </div>

      <c:if test="${not empty kikaku.adminComment}">
        <div style="margin-bottom: 16px; padding: 12px; background: #fff3cd; border-radius: 8px; border-left: 4px solid #ffc107;">
          <div class="subtitle" style="margin-bottom: 6px; color: #856404;">管理者からのコメント</div>
          <div style="color: #856404;">${kikaku.adminComment}</div>
        </div>
      </c:if>
    </div>
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