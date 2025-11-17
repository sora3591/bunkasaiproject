<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="true" %>
<!DOCTYPE html><html lang="ja"><head>
<meta charset="UTF-8"><title>アンケート作成（管理者）</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link rel="stylesheet" href="styles.css" /></head><body>
<div class="top-bar">
  <div class="nav-left">
    <a href="../index.jsp"><img src="https://cdn-icons-png.flaticon.com/512/1946/1946436.png" class="icon-home"></a>
    <div class="system-title">文化祭システム</div>
  </div>
  <div class="nav-center" id="navCenter"></div>
  <div class="nav-right">ようこそ</div>
</div>
<div class="wrap">
  <div class="title">アンケート作成（管理者）</div>
  <div class="card">
    <label class="label">対象企画</label>
    <select id="proposal" class="select"></select>

    <label class="label" style="margin-top:8px;">アンケートタイトル</label>
    <input id="title" class="input" placeholder="例）来場者アンケート">

    <div class="subtitle" style="margin-top:12px;">質問</div>
    <div id="qs"></div>
    <div style="margin-top:8px; display:flex; gap:8px;">
      <button class="btn btn-ghost" onclick="addQ('text')">+ テキスト</button>
      <button class="btn btn-ghost" onclick="addQ('number')">+ 数値</button>
      <button class="btn btn-ghost" onclick="addQ('textarea')">+ テキストエリア</button>
    </div>

    <div style="margin-top:14px;">
      <button class="btn btn-primary" onclick="save()">保存</button>
      <a class="btn btn-ghost" href="survey_list.jsp">戻る</a>
    </div>
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
const u=requireRole(['admin']); if(!u){}; fillWelcome(); renderNav();
const ps = getProposals();
proposal.innerHTML = ps.map(p=>`<option value="${p.id}">${p.title}</option>`).join('');

let list = [];
function addQ(type){
  const id = 'q'+Math.random().toString(36).slice(2,8);
  list.push({id, type, label:''});
  redraw();
}
function delQ(id){
  list = list.filter(q=>q.id!==id);
  redraw();
}
function redraw(){
  qs.innerHTML = list.map(q=>`
    <div style="display:flex; gap:8px; align-items:center; margin:6px 0;">
      <select class="select" style="max-width:140px;" onchange="chgType('${q.id}', this.value)">
        <option value="text" ${q.type==='text'?'selected':''}>テキスト</option>
        <option value="number" ${q.type==='number'?'selected':''}>数値</option>
        <option value="textarea" ${q.type==='textarea'?'selected':''}>テキストエリア</option>
      </select>
      <input class="input" placeholder="質問文" value="${q.label}" oninput="chgLabel('${q.id}', this.value)">
      <button class="btn btn-danger" onclick="delQ('${q.id}')">削除</button>
    </div>`).join('') || '<div class="err">+ ボタンで質問を追加してください</div>';
}
function chgType(id,val){ const q=list.find(x=>x.id===id); if(q){ q.type=val; } }
function chgLabel(id,val){ const q=list.find(x=>x.id===id); if(q){ q.label=val; } }
function save(){
  if(!title.value.trim()) return alert('タイトルを入力してください');
  if(!list.length) return alert('質問を1つ以上追加してください');
  const all = getSurveys();
  const id = 'sv'+Math.random().toString(36).slice(2,8);
  all.push({id, proposalId: proposal.value, title: title.value.trim(), questions: list, responses: []});
  saveSurveys(all);
  alert('作成しました'); location.href='survey_list.jsp';
}
redraw();
</script>
</body></html>
