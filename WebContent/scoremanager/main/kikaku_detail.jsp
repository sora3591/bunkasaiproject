<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%
  // ユーザーがログインしているか確認
  bean.User user = (bean.User) session.getAttribute("user");
  if (user == null) {
    response.sendRedirect(request.getContextPath() + "/scoremanager/main/login.jsp");
    return;
  }

  bean.Kikaku kikaku = (bean.Kikaku) request.getAttribute("kikaku");
  if (kikaku == null) {
    response.sendRedirect(request.getContextPath() + "/scoremanager/main/kikaku_list.jsp");
    return;
  }
%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/common/header.jsp"></c:import>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>企画詳細</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link rel="stylesheet" href="styles.css" />
  <style>
    .detail-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 24px;
      margin-top: 20px;
    }
    @media (max-width: 768px) {
      .detail-grid {
        grid-template-columns: 1fr;
      }
    }
    .card {
      border: 1px solid #e5e7eb;
      border-radius: 8px;
      padding: 20px;
      background: #fff;
    }
    .subtitle {
      font-weight: 700;
      margin-top: 16px;
      margin-bottom: 8px;
      font-size: 14px;
    }
    .info-row {
      display: flex;
      justify-content: space-between;
      padding: 8px 0;
      border-bottom: 1px solid #f0f0f0;
    }
    .info-label {
      font-weight: 600;
      color: #666;
    }
    .info-value {
      color: #222;
    }
    .status-badge {
      display: inline-block;
      padding: 6px 12px;
      border-radius: 6px;
      font-size: 12px;
      font-weight: 600;
    }
    .status-approved {
      background: #d4edda;
      color: #155724;
    }
    .status-pending {
      background: #d1ecf1;
      color: #0c5460;
    }
    .status-rejected {
      background: #f8d7da;
      color: #721c24;
    }
    .status-waiting {
      background: #fff3cd;
      color: #856404;
    }
    textarea {
      width: 100%;
      min-height: 100px;
      padding: 12px;
      border: 1px solid #d0d7e2;
      border-radius: 6px;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto;
      font-size: 14px;
      resize: vertical;
    }
    .button-group {
      display: flex;
      gap: 12px;
      margin-top: 12px;
    }
    .btn {
      padding: 10px 18px;
      border-radius: 6px;
      border: none;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.2s ease;
    }
    .btn-primary {
      background: #1d8cf8;
      color: #fff;
    }
    .btn-primary:hover {
      background: #0078d7;
    }
    .btn-ghost {
      background: #fff;
      color: #1d8cf8;
      border: 1px solid #1d8cf8;
    }
    .btn-ghost:hover {
      background: #f0f7ff;
    }
    .btn-success {
      background: #28a745;
      color: #fff;
    }
    .btn-success:hover {
      background: #218838;
    }
    .btn-warning {
      background: #ffc107;
      color: #000;
    }
    .btn-warning:hover {
      background: #e0a800;
    }
    .btn-danger {
      background: #dc3545;
      color: #fff;
    }
    .btn-danger:hover {
      background: #c82333;
    }
  </style>
</head>
<body>


<div class="wrap">
  <div class="title">企画詳細：<%= kikaku.getTitle() %></div>

  <% if (request.getAttribute("error") != null) { %>
    <div class="err"><%= request.getAttribute("error") %></div>
  <% } %>

  <div class="detail-grid">
    <!-- 左側：企画情報 -->
    <div class="card">
      <div class="subtitle">基本情報</div>
      <div class="info-row">
        <span class="info-label">ID</span>
        <span class="info-value"><%= kikaku.getId() %></span>
      </div>
      <div class="info-row">
        <span class="info-label">タイトル</span>
        <span class="info-value"><%= kikaku.getTitle() %></span>
      </div>
      <div class="info-row">
        <span class="info-label">日時</span>
        <span class="info-value"><%= kikaku.getDatetime() != null ? kikaku.getDatetime() : "未設定" %></span>
      </div>
      <div class="info-row">
        <span class="info-label">場所</span>
        <span class="info-value"><%= kikaku.getPlace() != null ? kikaku.getPlace() : "未設定" %></span>
      </div>
      <div class="info-row">
        <span class="info-label">担任名</span>
        <span class="info-value"><%= kikaku.getTeacher() != null ? kikaku.getTeacher() : "未設定" %></span>
      </div>
      <div class="info-row">
        <span class="info-label">提出者ID</span>
        <span class="info-value"><%= kikaku.getOwnerId() %></span>
      </div>

      <div class="subtitle">概要</div>
      <div style="padding: 8px 0; color: #222; line-height: 1.6;">
        <%= kikaku.getDescription() != null ? kikaku.getDescription() : "説明がありません" %>
      </div>
    </div>

    <!-- 右側：承認パネル（管理者のみ） -->
    <div class="card">
      <div class="subtitle">ステータス</div>
      <div style="margin-bottom: 16px;">
        <%
          String status = kikaku.getStatus();
          String statusClass = "status-waiting";
          if ("承認完了".equals(status)) {
            statusClass = "status-approved";
          } else if ("承認中".equals(status)) {
            statusClass = "status-pending";
          } else if ("却下".equals(status) || "修正依頼".equals(status)) {
            statusClass = "status-rejected";
          }
        %>
        <span class="status-badge <%= statusClass %>"><%= status %></span>
      </div>

      <% if ("admin".equals(user.getRole())) { %>
        <div class="subtitle">承認パネル</div>
       <form method="post" action="<%= request.getContextPath() %>/scoremanager/main/kikaku_detail">
          <input type="hidden" name="id" value="<%= kikaku.getId() %>">

          <div class="button-group">
            <button type="button" class="btn btn-success" onclick="setStatus(this.form, '承認完了')">承認</button>
            <button type="button" class="btn btn-warning" onclick="setStatus(this.form, '修正依頼')">修正依頼</button>
            <button type="button" class="btn btn-danger" onclick="setStatus(this.form, '却下')">却下</button>
          </div>

          <div class="subtitle" style="margin-top: 16px;">管理者コメント</div>
          <textarea name="adminComment" placeholder="コメントを入力..."></textarea>

          <div class="button-group" style="margin-top: 12px;">
            <button type="submit" class="btn btn-primary">保存</button>
            <a class="btn btn-ghost" href="<%= request.getContextPath() %>/scoremanager/main/kikaku_list">戻る</a>
          </div>
        </form>
      <% } else { %>
        <p style="color: #666; font-size: 14px;">管理者のみステータスを変更できます</p>
        <div style="margin-top: 16px;">
          <a class="btn btn-ghost" href="<%= request.getContextPath() %>/scoremanager/main/kikaku_list">戻る</a>
        </div>
      <% } %>
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

  function setStatus(form, status) {
    const statusInput = document.createElement('input');
    statusInput.type = 'hidden';
    statusInput.name = 'status';
    statusInput.value = status;
    form.appendChild(statusInput);
    form.submit();
  }
</script>
</body>
</html>