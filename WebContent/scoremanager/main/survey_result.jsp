<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="true" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.Survey, bean.SurveyQuestion, bean.SurveyAnswer" %>
<%@ page import="dao.SurveyDao, dao.SurveyAnswerDao" %>

<%
    request.setCharacterEncoding("UTF-8");

    String surveyId = request.getParameter("id");
    String errMsg = null;

    // ★ 只允许管理者查看
    String role = (String)session.getAttribute("userRole");
    if (role == null || !"admin".equals(role)) {
        errMsg = "この画面は管理者のみ閲覧可能です。";
    }

    Survey survey = null;
    List<SurveyQuestion> questions = new ArrayList<SurveyQuestion>();
    Map<String, List<SurveyAnswer>> answerMap = new HashMap<String, List<SurveyAnswer>>();

    if (errMsg == null) {
        if (surveyId == null || surveyId.isEmpty()) {
            errMsg = "アンケートIDが指定されていません。";
        } else {
            try {
                // アンケート＋質問取得
                SurveyDao sDao = new SurveyDao();
                survey = sDao.get(surveyId);

                if (survey == null) {
                    errMsg = "指定されたアンケートが見つかりません。";
                } else {
                    questions = survey.getQuestions();
                    if (questions == null) questions = new ArrayList<SurveyQuestion>();

                    // 回答取得
                    SurveyAnswerDao aDao = new SurveyAnswerDao();
                    List<SurveyAnswer> allAns = aDao.getBySurveyId(surveyId);

                    // questionId ごとにグルーピング
                    for (SurveyAnswer a : allAns) {
                        String qid = a.getQuestionId();
                        List<SurveyAnswer> list = answerMap.get(qid);
                        if (list == null) {
                            list = new ArrayList<SurveyAnswer>();
                            answerMap.put(qid, list);
                        }
                        list.add(a);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                errMsg = "アンケート結果の取得中にエラーが発生しました。";
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>アンケート結果（管理者用）</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link rel="stylesheet" href="styles.css" />
</head>
<body>

<!-- ===== トップバー ===== -->
<div class="top-bar">
  <div class="nav-left">
    <a href="<%= request.getContextPath() %>/scoremanager/main/index.jsp">
      <img src="https://cdn-icons-png.flaticon.com/512/1946/1946436.png" class="icon-home">
    </a>
    <div class="system-title">文化祭システム</div>
  </div>
  <div class="nav-center" id="navCenter"></div>
  <div class="nav-right">ようこそ</div>
</div>

<div class="wrap">
  <div class="title">アンケート結果（管理者用）</div>

  <% if (errMsg != null) { %>

    <div class="err"><%= errMsg %></div>
    <div style="margin-top:12px;">
      <a class="btn btn-ghost" href="survey_list">アンケート一覧に戻る</a>
    </div>

  <% } else if (survey != null) { %>

    <!-- アンケート概要 -->
    <div class="card" style="margin-bottom:16px;">
      <div style="font-weight:600; font-size:18px; margin-bottom:6px;">
        <%= survey.getTitle() %>
      </div>
      <div style="color:#555; font-size:14px;">
        アンケートID：<%= survey.getId() %><br>
        質問数：<%= questions.size() %>
      </div>
    </div>

    <%
      if (questions.isEmpty()) {
    %>
        <div class="err">このアンケートには質問が登録されていません。</div>
    <%
      } else {
        for (int i = 0; i < questions.size(); i++) {
          SurveyQuestion q = questions.get(i);
          String qid = q.getId();
          List<SurveyAnswer> list = answerMap.get(qid);
          if (list == null) list = new ArrayList<SurveyAnswer>();
    %>

      <!-- 各質問ブロック -->
      <div style="margin-bottom:24px;">
        <!-- 質問文 -->
        <div style="font-weight:600; margin-bottom:4px;">
          Q<%= (i+1) %>. <%= q.getLabel() %>
        </div>
        <div style="font-size:13px; color:#666; margin-bottom:6px;">
          回答数：<%= list.size() %>
        </div>

        <div class="table-wrap">
          <table>
            <thead>
              <tr>
                <th style="width:60px;">No.</th>
                <th style="width:160px;">ユーザーID</th>
                <th>回答内容</th>
                <th style="width:180px;">回答日時</th>
              </tr>
            </thead>
            <tbody>
              <%
                if (list.isEmpty()) {
              %>
                <tr>
                  <td colspan="4" style="text-align:center; color:#999;">
                    まだ回答はありません。
                  </td>
                </tr>
              <%
                } else {
                  for (int j = 0; j < list.size(); j++) {
                    SurveyAnswer a = list.get(j);
              %>
                <tr>
                  <td><%= (j+1) %></td>
                  <td><%= (a.getUserId() != null ? a.getUserId() : "") %></td>
                  <td><%= (a.getAnswer() != null ? a.getAnswer() : "") %></td>
                  <td><%= (a.getCreatedAt() != null ? a.getCreatedAt().toString() : "") %></td>
                </tr>
              <%
                  }
                }
              %>
            </tbody>
          </table>
        </div>
      </div>

    <%
        } // for questions
      }   // else
    %>

    <div style="margin-top:16px;">
      <a class="btn btn-ghost" href="survey_list">アンケート一覧に戻る</a>
    </div>

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