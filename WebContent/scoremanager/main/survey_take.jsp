<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="true" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.Survey, bean.SurveyQuestion, bean.SurveyAnswer" %>
<%@ page import="dao.SurveyDao, dao.SurveyAnswerDao" %>

<%
    request.setCharacterEncoding("UTF-8");

    String surveyId = request.getParameter("id");   // GET 時の ?id=...
    String err = null;
    Survey survey = null;

    // ★ 这里按你的系统实际情况改：session 里的用户ID名
    // 例如如果你是 loginId，就写 "loginId"
    String userId = (String)session.getAttribute("userId");
    if (userId == null) {
        userId = "guest";   // 没登录的情况先作为 guest 处理（最好本来就 requireAuth）
    }

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

                // ★ 保存OK → 感谢页面 ★
                response.sendRedirect("thanks.jsp");
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
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/common/header.jsp"></c:import>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>アンケート実施</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link rel="stylesheet" href="styles.css" />
</head>
<body>



<div class="wrap">
  <% if (err != null) { %>

    <div class="title">アンケート実施</div>
    <div class="err"><%= err %></div>
    <div style="margin-top:12px;">
      <a href="survey_list.jsp" class="btn btn-ghost">アンケート一覧に戻る</a>
    </div>

  <% } else if (survey != null) { %>

    <div class="title"><%= survey.getTitle() %></div>
    <div style="margin-bottom:8px; color:#555;">
      アンケートID：<%= survey.getId() %>
    </div>

    <!-- ★ 回答用フォーム（POST） -->
    <form method="post" action="survey_take.jsp">
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
        <a href="survey_list.jsp" class="btn btn-ghost">一覧に戻る</a>
      </div>
    </form>

  <% } %>
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
  try { requireAuth && requireAuth(); } catch(e) {}
  try { fillWelcome && fillWelcome(); } catch(e) {}
  try { renderNav && renderNav(); } catch(e) {}
</script>
</body>
</html>