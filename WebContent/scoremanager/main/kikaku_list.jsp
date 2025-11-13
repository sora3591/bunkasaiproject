<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html><html lang="ja"><head>
<meta charset="UTF-8"><title>企画一覧</title>
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
  <div class="title">企画一覧</div>
  <div class="table-wrap">
    <table>
      <thead><tr>
        <th style="width:90px;">アイコン</th>
        <th>タイトル</th><th>日時</th><th>場所</th><th>担任名</th><th>ステータス</th><th style="width:100px;"></th>
      </tr></thead>
      <tbody id="rows"></tbody>
    </table>
  </div>
  <div style="margin-top:12px;"><a class="btn btn-primary" href="kikaku_add.jsp">企画の新規提出</a></div>
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
window.addEventListener('DOMContentLoaded',()=>{
  const u=requireAuth(); if(!u) return; fillWelcome(); renderNav();
  const data=getProposals().filter(p=>u.role==='admin'?true:p.ownerId===u.userId);
  rows.innerHTML=data.map(row=>`
    <tr>
      <td><img class="thumb" src="images/${row.id}.jpg" onerror="this.src='images/main.jpg'"></td>
      <td>${row.title}</td>
      <td>${row.datetime}</td>
      <td>${row.place}</td>
      <td>${row.teacher}</td>
      <td><span class="tag ${row.status==='承認中'?'tag-blue':(row.status==='承認完了'?'tag-green':'tag-orange')}">${row.status}</span></td>
      <td><button class="btn btn-ghost" onclick="openDetail('${row.id}')">開く</button></td>
    </tr>`).join('');
});
function openDetail(id){ location.href = detailPathByRole()+`?id=${encodeURIComponent(id)}`; }
</script>
</body></html>