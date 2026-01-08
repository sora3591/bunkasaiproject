 <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.Survey, bean.SurveyQuestion, bean.SurveyAnswer" %>
<%@ page import="bean.User" %>
<%@ page import="dao.SurveyDao, dao.SurveyAnswerDao" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
    request.setCharacterEncoding("UTF-8");

    // ★ ログインチェック（他画面と同じパターン）
    User user = (User)session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/scoremanager/main/login.jsp");
        return;
    }
    // ★ 回答者 ID はログインユーザーの ID を使う
    String userId = user.getId();

    String surveyId = request.getParameter("id");   // GET 時 ?id=...
    String err = null;
    Survey survey = null;

    // ---- POST: 回答送信 ----
    if ("POST".equalsIgnoreCase(request.getMethod())) {

        surveyId = request.getParameter("surveyId");

        try {
            SurveyDao sDao = new SurveyDao();
            survey = sDao.get(surveyId);

            if (survey == null) {
                err = "アンケートが見つかりません。";
            } else {

                List<SurveyQuestion> qs = survey.getQuestions();
                SurveyAnswerDao aDao = new SurveyAnswerDao();

                int idx = 1;
                for (SurveyQuestion q : qs) {
                    String qId = q.getId();
                    String paramName = "q_" + qId;
                    String val = request.getParameter(paramName);

                    if (val == null || val.trim().isEmpty()) continue;

                    SurveyAnswer a = new SurveyAnswer();
                    a.setId("A" + System.currentTimeMillis() + "_" + idx);
                    a.setSurveyId(surveyId);
                    a.setQuestionId(qId);
                    a.setUserId(userId);
                    a.setAnswer(val.trim());

                    aDao.save(a);
                    idx++;
                }

                // ★ 保存OK → 感谢页面（Servlet 経由じゃないなら JSP 直指定でOK）
                response.sendRedirect(request.getContextPath() + "/scoremanager/main/thanks.jsp");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            err = "回答の保存中にエラーが発生しました。";
        }
    }
    // ---- GET: アンケート内容の取得 ----
    else {
        try {
            SurveyDao dao = new SurveyDao();
            survey = dao.get(surveyId);
            if (survey == null) {
                err = "指定されたアンケートが見つかりません。";
            }
        } catch (Exception e) {
            e.printStackTrace();
            err = "アンケートの取得中にエラーが発生しました。";
        }
    }
%>

<!-- 共通ヘッダー（ナビ・ロゴ） -->
<c:import url="/common/header.jsp"></c:import>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>アンケート実施</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css" />
</head>
<body>

<div class="wrap">
  <% if (err != null) { %>

    <div class="title">アンケート実施</div>
    <div class="err"><%= err %></div>
    <div style="margin-top:12px;">
      <!-- ★ 一覧へ戻るのリンクは Servlet 経由 -->
      <a href="<%= request.getContextPath() %>/scoremanager/main/survey_list"
         class="btn btn-ghost">アンケート一覧に戻る</a>
    </div>

  <% } else if (survey != null) { %>

    <div class="title"><%= survey.getTitle() %></div>
    <div style="margin-bottom:8px; color:#555;">
      アンケートID：<%= survey.getId() %>
    </div>

    <!-- ★ 回答用フォーム：action を空にして「この JSP 自身」に POST -->
    <form method="post">
      <!-- アンケートID を hidden で送る -->
      <input type="hidden" name="surveyId" value="<%= survey.getId() %>">

      <%
        List<SurveyQuestion> qs = survey.getQuestions();
        for (int i = 0; i < qs.size(); i++) {
            SurveyQuestion q = qs.get(i);
            String t = q.getType();         // text / number / textarea
            String name = "q_" + q.getId(); // パラメータ名
      %>

        <div class="form-group" style="margin-bottom:12px;">
          <div class="label">
            Q<%= (i+1) %>. <%= q.getLabel() %>
          </div>

          <% if ("number".equals(t)) { %>
            <input type="number" name="<%= name %>" class="input">
          <% } else if ("textarea".equals(t)) { %>
            <textarea name="<%= name %>" rows="3" class="input"></textarea>
          <% } else { %> <!-- text or その他 -->
            <input type="text" name="<%= name %>" class="input">
          <% } %>
        </div>

      <% } // end for %>

      <div style="margin-top:16px;">
        <button type="submit" class="btn btn-primary">送信</button>
        <a href="<%= request.getContextPath() %>/scoremanager/main/survey_list"
           class="btn btn-ghost">一覧に戻る</a>
      </div>
    </form>

  <% } %>
</div>

<!-- ログアウトモーダル（必要なら） -->
<div class="modal-bg" id="logoutModal">
  <div class="modal">
    <div>ログアウトしますか？</div>
    <div class="modal-actions">
      <button class="btn btn-primary" onclick="confirmLogout()">はい</button>
      <button class="btn btn-ghost" onclick="closeLogout()">いいえ</button>
    </div>
  </div>
</div>

<script src="<%= request.getContextPath() %>/scoremanager/main/app.js"></script>
<script>
  try { requireAuth && requireAuth(); } catch(e) {}
  try { fillWelcome && fillWelcome(); } catch(e) {}
  try { renderNav && renderNav(); } catch(e) {}
</script>
</body>
</html>