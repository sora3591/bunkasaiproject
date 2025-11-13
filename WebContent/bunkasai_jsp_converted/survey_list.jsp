<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html><html lang="ja"><head>
<meta charset="UTF-8"><title>アンケート一覧</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link rel="stylesheet" href="styles.css" /></head><body>
<div class="top-bar">
  <div class="nav-left">
    <a href="index.jsp"><img src="https://cdn-icons-png.flaticon.com/512/1946/1946436.png" class="icon-home" alt="home"></a>
    <div class="system-title">文化祭システム</div>
  <div class="nav-center" id="navCenter"></div>

  </div>
  <div class="nav-right">ようこそ</div>
</div>
<div class="wrap">
  <div class="title">アンケート一覧</div><div class="err">※ 管理者は作成/管理、学生は回答のみ</div>
  <div class="table-wrap">
    <table><thead><tr><th>タイトル</th><th>質問数</th><th style="width:180px;"></th></tr></thead>
      <tbody id="rows"></tbody></table>
  </div>
</div>
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
requireAuth(); fillWelcome(); renderNav(); renderNav();
const u = getUserSession();
const arr = getSurveys();
if(u.role==='admin'){
  rows.innerHTML = arr.map(s=>`
    <tr>
      <td>${s.title} <span class="tag tag-blue" style="margin-left:6px;">${getProposalTitle(s.proposalId)}</span></td>
      <td>${s.questions.length}</td>
      <td>
        <a class="btn btn-primary" href="survey_take.html?id=${s.id}">プレビュー</a>
        <a class="btn btn-ghost" href="survey_admin.jsp">新規作成</a>
      </td>
    </tr>`).join('');
} else {
  rows.innerHTML = arr.map(s=>`
    <tr>
      <td>${s.title} <span class="tag tag-blue" style="margin-left:6px;">${getProposalTitle(s.proposalId)}</span></td>
      <td>${s.questions.length}</td>
      <td><a class="btn btn-primary" href="survey_take.html?id=${s.id}">実施</a></td>
    </tr>`).join('');
}
</script>
</body></html>