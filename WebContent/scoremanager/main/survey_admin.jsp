<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="true" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.Survey, bean.SurveyQuestion" %>
<%@ page import="dao.SurveyDao" %>

<%
    request.setCharacterEncoding("UTF-8");

    // エラーメッセージ用
    String errMsg = null;

    // ★ このページへの POST を受け取ってDBに保存する
    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String proposalId = request.getParameter("proposal");
        String title = request.getParameter("title");

        String[] types  = request.getParameterValues("qType");
        String[] labels = request.getParameterValues("qLabel");

        if (title != null && title.trim().length() > 0 &&
            types != null && labels != null && types.length == labels.length) {

            // ---- Survey オブジェクト作成 ----
            Survey s = new Survey();
            // IDはとりあえず時間ベースでユニークにする
            String surveyId = "S" + System.currentTimeMillis();
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
                dao.save(s);   // SurveyDaoのsaveがSurveyQuestionも保存してくれる

                // 保存成功 → 一覧へリダイレクト
                response.sendRedirect("survey_list.jsp");
                return;

            } catch (Exception e) {
                e.printStackTrace();
                errMsg = "アンケートの保存に失敗しました。";
            }
        } else {
            errMsg = "タイトルと質問を正しく入力してください。";
        }
    }
%>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>アンケート作成（管理者）</title>
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
  <div class="title">アンケート作成（管理者）</div>

  <% if (errMsg != null) { %>
    <div class="err"><%= errMsg %></div>
  <% } %>

  <!-- ★★★ form開始：自分自身にPOSTする ★★★ -->
  <form method="post" action="survey_admin.jsp" id="surveyForm">

    <div class="card">

      <!-- 対象企画 -->
      <label class="label">対象企画</label>
      <select id="proposal" name="proposal" class="select"></select>

      <!-- アンケートタイトル -->
      <label class="label" style="margin-top:8px;">アンケートタイトル</label>
      <input id="title" name="title" class="input" placeholder="例）来場者アンケート">

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
        <!-- beforeSubmit で入力チェックを行う -->
        <button type="submit" class="btn btn-primary" onclick="return beforeSubmit()">保存</button>
        <a class="btn btn-ghost" href="survey_list.jsp">戻る</a>
      </div>
    </div>

  </form>
  <!-- ★★★ form終了 ★★★ -->
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
  // ===== ナビ・ログイン関連（app.js にあれば実行、なければ無視） =====
  try { requireAuth && requireAuth(); } catch(e) {}
  try { fillWelcome && fillWelcome(); } catch(e) {}
  try { renderNav && renderNav(); } catch(e) {}

  // ===== 対象企画セレクト（とりあえずプレースホルダ。あとでDBと連携） =====
  if (typeof proposal !== 'undefined') {
    if (!proposal.innerHTML.trim()) {
      proposal.innerHTML = '<option value="">企画を選択してください</option>';
    }
  }

  // ===== 質問リスト管理用 =====
  let list = [];  // {id, type, label} の配列

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

  // ===== フォーム送信前チェック =====
  function beforeSubmit() {
    if (!title.value.trim()) {
      alert('タイトルを入力してください');
      return false;
    }
    if (!list.length) {
      alert('質問を1つ以上追加してください');
      return false;
    }

    // どんなデータが送られるか確認
    console.log('送信予定データ', {
      proposalId: proposal.value,
      title: title.value.trim(),
      questions: list
    });

    return true; // ここで true を返すと submit 続行
  }

  // ===== グローバル公開（HTMLのonclick から呼べるように） =====
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