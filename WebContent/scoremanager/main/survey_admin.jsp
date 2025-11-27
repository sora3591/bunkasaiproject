<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="true" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.Survey, bean.SurveyQuestion" %>
<%@ page import="bean.Kikaku" %>      <!-- 企画用 Bean -->
<%@ page import="dao.SurveyDao" %>

<%
    request.setCharacterEncoding("UTF-8");

    // Action( Servlet ) からもらう値
    String errMsg = (String)request.getAttribute("errMsg");
    Survey editingSurvey = (Survey)request.getAttribute("editingSurvey");

    // 承認済み企画一覧
    @SuppressWarnings("unchecked")
    List<Kikaku> approvedProposals =
        (List<Kikaku>)request.getAttribute("approvedProposals");
%>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>アンケート作成／編集（管理者）</title>
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

  <!-- ★ Action の URL を指定 -->
  <form method="post"
        action="<%= request.getContextPath() %>/scoremanager/main/survey_admin"
        id="surveyForm">

    <!-- 編集時に使うアンケートID -->
    <input type="hidden" name="surveyId"
           value="<%= (editingSurvey != null ? editingSurvey.getId() : "") %>">

    <div class="card">

      <!-- 対象企画：承認済み企画だけを DB から取得して表示 -->
      <label class="label">対象企画</label>

      <%
        // どれを選択状態にするか（編集時は既存の proposalId）
        String selectedProposalId = null;
        if (editingSurvey != null && editingSurvey.getProposalId() != null) {
            selectedProposalId = editingSurvey.getProposalId();
        } else {
            // バリデーションエラーで戻ってきたとき用
            String reqP = request.getParameter("proposal");
            if (reqP != null && !reqP.isEmpty()) {
                selectedProposalId = reqP;
            }
        }
      %>

      <select id="proposal" name="proposal" class="select">
        <option value="">企画を選択してください</option>

        <% if (approvedProposals != null) {
             for (Kikaku k : approvedProposals) {
                 String pid = k.getId();      // 企画ID
                 String pname = k.getTitle(); // 企画タイトル
        %>
          <option value="<%= pid %>"
            <%= (pid != null && pid.equals(selectedProposalId)) ? "selected" : "" %>>
            <%= pname %>
          </option>
        <%   }
           } %>
      </select>

      <!-- アンケートタイトル -->
      <label class="label" style="margin-top:8px;">アンケートタイトル</label>
      <input id="title" name="title" class="input"
             placeholder="例）来場者アンケート"
             value="<%= (editingSurvey != null && editingSurvey.getTitle() != null)
                        ? editingSurvey.getTitle()
                        : (request.getParameter("title") != null ? request.getParameter("title") : "") %>">

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
        <a class="btn btn-ghost"
           href="<%= request.getContextPath() %>/scoremanager/main/survey_list">一覧に戻る</a>
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
           // JS 文字列用にエスケープ
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

    // デバッグ用ログ
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

  // 初期表示
  redraw();
});
</script>
</body>
</html>