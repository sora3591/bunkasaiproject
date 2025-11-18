<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html><html lang="ja"><head>
<meta charset="UTF-8"><title>企画詳細（管理者）</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link rel="stylesheet" href="styles.css" /></head><body>
<div class="top-bar">
  <div class="nav-left">
    <a href="../index.jsp"><img src="https://cdn-icons-png.flaticon.com/512/1946/1946436.png" class="icon-home" alt="home"></a>
    <div class="system-title">文化祭システム</div>
  <div class="nav-center" id="navCenter"></div>

  </div>
  <div class="nav-right">ようこそ</div>
</div>
<div class="wrap">
  <div class="title" id="ttl">企画詳細</div>
  <div class="grid">
    <div class="card" style="flex:1;">
      <div class="subtitle">概要</div>
      <div class="subtitle" id="datetime"></div>
      <div id="desc"></div>
      <div class="subtitle">添付資料</div>
      <ul id="files"></ul>
    </div>
    <div class="card" style="flex:1;">
      <div class="subtitle">承認パネル</div>
      <div class="row">
        <button class="btn btn-success" onclick="setStatus('承認完了')">承認</button>
        <button class="btn btn-warn" onclick="setStatus('修正依頼')">修正依頼</button>
        <button class="btn btn-danger" onclick="setStatus('却下')">却下</button>
      </div>
      <div class="subtitle">管理者コメント</div>
      <textarea id="adminComment" placeholder=""></textarea>
      <div style="display:flex; gap:10px;">
        <button class="btn btn-primary" onclick="saveComment()">保存</button>
        <a class="btn btn-ghost" href="kikaku_list.jsp">戻る</a>
      </div>
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
const id=new URLSearchParams(location.search).get('id');
let list=getProposals(); let p=list.find(x=>x.id===id); if(!p) location.href='kikaku_list.jsp';
ttl.textContent='企画詳細：'+p.title;
datetime.textContent=`日時：${p.datetime} / ${p.place} / 担任:${p.teacher}`;
desc.textContent=p.desc||'';
files.innerHTML=(p.files||[]).map(f=>`<li>${f}</li>`).join('')||'<li>なし</li>';
function setStatus(s){ p.status=s; saveProposals(list); alert('更新しました'); location.reload(); }
function saveComment(){ alert('コメントを保存（デモ）: '+adminComment.value); }
</script>
</body></html>