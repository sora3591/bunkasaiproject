<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ page import="java.util.List" %>
<%@ page import="bean.Survey" %>
<%@ page import="dao.SurveyDao" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    // ★ 这里直接在 JSP 里面调用 Dao，从 H2 取出アンケート列表
    List<Survey> surveys = null;
    try {
        SurveyDao dao = new SurveyDao();
        surveys = dao.getAll();          // SELECT * FROM SURVEY ...
    } catch (Exception e) {
        e.printStackTrace();
    }
    if (surveys == null) {
        surveys = new java.util.ArrayList<Survey>();
    }
    request.setAttribute("surveys", surveys);

    // 登录用户角色（管理者 / 学生），按你之前 session 里保存的 key 来改
    String role = (String)session.getAttribute("userRole");
    if (role == null) {
        role = "student";   // 保险起见给个默认
    }
%>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>アンケート一覧</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link rel="stylesheet" href="styles.css" />
</head>
<body>

<!-- ===== トップバー ===== -->
<div class="top-bar">
  <div class="nav-left">
    <a href="<%= request.getContextPath() %>/scoremanager/main/index.jsp">
      <img src="https://cdn-icons-png.flaticon.com/512/1946/1946436.png" class="icon-home" alt="home">
    </a>
    <div class="system-title">文化祭システム</div>
  </div>
  <div class="nav-center" id="navCenter"></div>
  <div class="nav-right">ようこそ</div>
</div>

<div class="wrap">
  <div class="title">アンケート一覧</div>
  <div class="err">※ 管理者は作成/管理、学生は回答のみ</div>

  <div class="table-wrap">
    <table>
      <thead>
        <tr>
          <th>タイトル</th>
          <th>質問数</th>
          <th style="width:180px;"></th>
        </tr>
      </thead>
      <tbody>
        <!-- ★ 这里用 JSTL 把刚才 Dao 取出来的 surveys 显示出来 -->
        <c:forEach var="s" items="${surveys}">
          <tr>
            <td>
              ${s.title}
              <!-- 这里先简单显示 proposalId，如果以后要显示企画名再改 -->
              <c:if test="${not empty s.proposalId}">
                <span class="tag tag-blue" style="margin-left:6px;">
                  ${s.proposalId}
                </span>
              </c:if>
            </td>
            <td>${s.questions.size()}</td>
            <td>
              <c:choose>
                <c:when test="${role eq 'admin'}">
                  <a class="btn btn-primary" href="survey_take.jsp?id=${s.id}">プレビュー</a>
                  <a class="btn btn-ghost" href="survey_admin.jsp">新規作成</a>
                </c:when>
                <c:otherwise>
                  <a class="btn btn-primary" href="survey_take.jsp?id=${s.id}">実施</a>
                </c:otherwise>
              </c:choose>
            </td>
          </tr>
        </c:forEach>

        <!-- 没有数据时的提示 -->
        <c:if test="${empty surveys}">
          <tr>
            <td colspan="3" style="text-align:center; color:#666;">
              アンケートが登録されていません。
            </td>
          </tr>
        </c:if>
      </tbody>
    </table>
  </div>
</div>

<!-- ログアウトモーダル -->
<div class="modal-bg" id="logoutModal">
  <div class="modal">
    <div>ログアウトしますか？</div>
    <div class="modal-actions">
      <button class="btn btn-primary" onclick="confirmLogout()">はい</button>
      <button class="btn btn-ghost" onclick="closeLogout()">いいえ</button>
    </div>
  </div>
</div>

<script src="app.js"></script>
<script>
  // 导航/ログアウト这些 JS 你原来在用的就保留
  requireAuth();
  fillWelcome();
  renderNav();
</script>
</body>
</html>