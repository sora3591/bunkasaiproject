<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ page import="java.util.List" %>
<%@ page import="bean.Survey" %>
<%@ page import="dao.SurveyDao" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


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
  <div class="err">※ 管理者：プレビュー／結果確認　学生：回答のみ</div>

  <div class="table-wrap">
    <table>
      <thead>
        <tr>
          <th>タイトル</th>
          <th>質問数</th>
          <th style="width:260px;"></th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="s" items="${surveys}">
          <tr>
            <td>
              ${s.title}
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
                  <!-- プレビュー：編集画面へ -->
                  <a class="btn btn-ghost" href="survey_admin.jsp?id=${s.id}">
                    プレビュー
                  </a>
                  <!-- 結果を見る：あとで学生回答表示用に実装 -->
                  <a class="btn btn-primary" href="survey_result.jsp?id=${s.id}">
                    結果を見る
                  </a>
                </c:when>


                <c:otherwise>
                  <a class="btn btn-primary" href="survey_take.jsp?id=${s.id}">
                    実施
                  </a>
                </c:otherwise>
              </c:choose>
            </td>
          </tr>
        </c:forEach>

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
  // 管理者も学生もこの一覧は見れるので requireAuth のみ
  try { requireAuth && requireAuth(); } catch(e) {}
  try { fillWelcome && fillWelcome(); } catch(e) {}
  try { renderNav && renderNav(); } catch(e) {}
</script>
</body>
</html>