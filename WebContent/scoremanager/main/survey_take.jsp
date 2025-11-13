<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html><html lang="ja"><head>
<meta charset="UTF-8"><title>アンケート実施</title>
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
  <div class="title" id="ttl">アンケート実施</div>
  <div class="card" id="form"></div>
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
const u=requireAuth(); if(!u){}; fillWelcome(); renderNav();
const id=new URLSearchParams(location.search).get('id');
let s=getSurveys().find(x=>x.id===id); if(!s) location.href='survey_list.jsp';
ttl.textContent='アンケート実施：'+s.title;
form.innerHTML = s.questions.map(q=>`
  <div class="subtitle">${q.label}</div>
  ${q.type==='textarea' ? '<textarea data-id="'+q.id+'"></textarea>' : '<input class="input" data-id="'+q.id+'" type="'+(q.type||'text')+'">'}
`).join('') + '<div style="margin-top:12px;"><button class="btn btn-primary" onclick="submit()">送信</button> <a class="btn btn-ghost" href="survey_list.jsp">戻る</a></div>';
function submit(){
  const inputs=[...document.querySelectorAll('[data-id]')];
  const ans = inputs.map(el=>({id:el.dataset.id, value:el.value}));
  s.responses = s.responses||[]; s.responses.push({user:getUserSession().userId, answers:ans, at:Date.now()});
  const all=getSurveys(); const idx=all.findIndex(x=>x.id===s.id); all[idx]=s; saveSurveys(all);
  alert('送信しました'); location.href='survey_list.jsp';
}
</script>
</body></html>