<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="true" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.Survey, bean.SurveyQuestion" %>
<%@ page import="dao.SurveyDao" %>

<%
    request.setCharacterEncoding("UTF-8");

    String errMsg = null;
    Survey editingSurvey = null;   // 編集対象（idパラメータがあればここに入る）

    // ---- POST：保存処理 ----
    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String surveyId   = request.getParameter("surveyId");  // hidden
        String proposalId = request.getParameter("proposal");
        String title      = request.getParameter("title");

        String[] types  = request.getParameterValues("qType");
        String[] labels = request.getParameterValues("qLabel");

        if (title != null && title.trim().length() > 0 &&
            types != null && labels != null && types.length == labels.length) {

            Survey s = new Survey();

            // ★ 新規 or 編集判定：hiddenのsurveyIdが空なら新規
            if (surveyId == null || surveyId.isEmpty()) {
                surveyId = "S" + System.currentTimeMillis();
            }
            s.setId(surveyId);
            s.setTitle(title.trim());
            s.setProposalId(proposalId);

            List<SurveyQuestion> qList = new ArrayList<>();

            for (int i = 0; i < types.length; i++) {
                if (labels[i] == null || labels[i].trim().isEmpty()) {
                    continue;   // 質問文が空ならスキップ
                }
                SurveyQuestion q = new SurveyQuestion();
                q.setId("Q" + surveyId + "_" + (i + 1));   // 適当なID
                q.setSurveyId(surveyId);
                q.setType(types[i]);
                q.setLabel(labels[i].trim());
                qList.add(q);
            }

            s.setQuestions(qList);

            try {
                SurveyDao dao = new SurveyDao();
                dao.save(s);   // INSERT or UPDATE + 質問再登録

                // 保存成功 → 一覧へ
                response.sendRedirect("survey_list.jsp");
                return;

            } catch (Exception e) {
                e.printStackTrace();
                errMsg = "アンケートの保存に失敗しました。";
            }
        } else {
            errMsg = "タイトルと質問を正しく入力してください。";
        }

    } else {
        // ---- GET：idがあれば編集モードで既存アンケートを取得 ----
        String id = request.getParameter("id");
        if (id != null && !id.isEmpty()) {
            try {
                SurveyDao dao = new SurveyDao();
                editingSurvey = dao.get(id);
                if (editingSurvey == null) {
                    errMsg = "指定されたアンケートが見つかりません。";
                }
            } catch (Exception e) {
                e.printStackTrace();
                errMsg = "アンケートの取得中にエラーが発生しました。";
            }
        }
    }
%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/common/header.jsp"></c:import>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>アンケート作成／編集（管理者）</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link rel="stylesheet" href="styles.css" />
</head>
<body>



<div class="wrap">
  <div class="title">
    <% if (editingSurvey != null) { %>
      アンケート編集（管理者）
    <% } else { %>
      アンケート作成（管理者）
    <% } %>
  </div>

  <% if (errMsg != null) { %>
    <div class="err"><%= errMsg %></div>
  <% } %>


  <form method="post" action="survey_admin.jsp" id="surveyForm">

    <!-- 編集時に使うアンケートID -->
    <input type="hidden" name="surveyId"
           value="<%= (editingSurvey != null ? editingSurvey.getId() : "") %>">

    <div class="card">

      <!-- 対象企画（现在简单放着，将来再连 proposals 表） -->
      <label class="label">対象企画</label>
      <select id="proposal" name="proposal" class="select">
        <option value="">企画を選択してください</option>
        <!-- TODO: 以后从企画テーブル生成 option -->
      </select>

      <!-- アンケートタイトル -->
      <label class="label" style="margin-top:8px;">アンケートタイトル</label>
      <input id="title" name="title" class="input"
             placeholder="例）来場者アンケート"
             value="<%= (editingSurvey != null && editingSurvey.getTitle() != null)
                        ? editingSurvey.getTitle() : "" %>">

      <!-- 質問群 -->
      <div class="subtitle" style="margin-top:12px;">質問</div>

      <!-- 質問リスト出力位置 -->
      <div id="qs"></div>

      <!-- 質問追加ボタン -->
      <div style="margin-top:8px; display:flex; gap:8px;">
        <button type="button" class="btn btn-ghost" onclick="addQ('text')">+ テキスト</button>
        <button type="button" class="btn btn-ghost" onclick="addQ('number')">+ 数値</button>
        <button type="button" class="btn btn-ghost" onclick="addQ('textarea')">+ テキストエリア</button>
      </div>

      <!-- 保存・戻る -->
      <div style="margin-top:14px;">
        <!-- beforeSubmit で入力チェック -->
        <button type="submit" class="btn btn-primary" onclick="return beforeSubmit()">保存</button>
        <a class="btn btn-ghost" href="survey_list.jsp">一覧に戻る</a>
      </div>
    </div>

  </form>

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
document.addEventListener('DOMContentLoaded', function() {
  // ===== ナビ・ログイン関連 =====
  try { requireAuth && requireAuth(); } catch(e) {}
  try { fillWelcome && fillWelcome(); } catch(e) {}
  try { renderNav && renderNav(); } catch(e) {}

  // ===== 対象企画セレクト（现在先不连DB） =====
  if (typeof proposal !== 'undefined') {
    // 如果将来要根据 editingSurvey.getProposalId() 设定默认值，可以在这里处理
  }

  // ===== 質問リスト管理用 =====
  let list = [];

  // ★ サーバーから既存質問を埋め込む（編集モードのときだけ）
  <%
    if (editingSurvey != null &&
        editingSurvey.getQuestions() != null &&
        !editingSurvey.getQuestions().isEmpty()) {

      List<SurveyQuestion> qList = editingSurvey.getQuestions();
  %>
    list = [
      <% for (int i = 0; i < qList.size(); i++) {
           SurveyQuestion q = qList.get(i);
           String lbl = q.getLabel();
           if (lbl == null) lbl = "";
           // 简单处理一下防止 JS 字符串崩掉
           lbl = lbl.replace("\\", "\\\\").replace("\"", "\\\"").replace("\r", "").replace("\n", "");
      %>
        { id: "<%= q.getId() %>", type: "<%= q.getType() %>", label: "<%= lbl %>" }<%= (i < qList.size()-1 ? "," : "") %>
      <% } %>
    ];
  <% } %>

  function redraw() {
    if (!list.length) {
      qs.innerHTML = '<div class="err">+ ボタンで質問を追加してください</div>';
      return;
    }

    qs.innerHTML = list.map(q => `
      <div style="display:flex; gap:8px; align-items:center; margin:6px 0;">
        <select name="qType" class="select" style="max-width:140px;"
                onchange="chgType('${q.id}', this.value)">
          <option value="text" ${q.type==='text'?'selected':''}>テキスト</option>
          <option value="number" ${q.type==='number'?'selected':''}>数値</option>
          <option value="textarea" ${q.type==='textarea'?'selected':''}>テキストエリア</option>
        </select>

        <input name="qLabel" class="input" placeholder="質問文"
               value="${q.label}" oninput="chgLabel('${q.id}', this.value)">

        <button type="button" class="btn btn-danger" onclick="delQ('${q.id}')">削除</button>
      </div>
    `).join('');
  }

  function addQ(type) {
    const id = 'q' + Math.random().toString(36).slice(2, 8);
    list.push({ id, type, label: '' });
    redraw();
  }

  function delQ(id) {
    list = list.filter(q => q.id !== id);
    redraw();
  }

  function chgType(id, val) {
    const q = list.find(x => x.id === id);
    if (q) q.type = val;
  }

  function chgLabel(id, val) {
    const q = list.find(x => x.id === id);
    if (q) q.label = val;
  }

  function beforeSubmit() {
    if (!title.value.trim()) {
      alert('タイトルを入力してください');
      return false;
    }
    if (!list.length) {
      alert('質問を1つ以上追加してください');
      return false;
    }

    console.log('送信予定データ', {
      surveyId: document.querySelector('input[name="surveyId"]').value,
      proposalId: proposal.value,
      title: title.value.trim(),
      questions: list
    });

    return true;
  }

  window.addQ         = addQ;
  window.delQ         = delQ;
  window.chgType      = chgType;
  window.chgLabel     = chgLabel;
  window.beforeSubmit = beforeSubmit;

  // 初期表示（编辑模式时会显示原问题，新规时显示「+ボタンで追加してください」）
  redraw();
});
</script>
</body>
</html>