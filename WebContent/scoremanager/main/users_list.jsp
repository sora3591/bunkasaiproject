<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html><html lang="ja"><head>
<meta charset="UTF-8"><title>ユーザー一覧</title>
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
  <div class="title">ユーザー一覧</div>
  <div class="table-wrap">
    <table>
      <thead><tr><th>ID</th><th>氏名</th><th>ロール</th><th>クラス</th><th>メール</th><th style="width:160px;"></th></tr></thead>
      <tbody id="rows"></tbody>
    </table>
  </div>
  <div style="margin-top:12px;"><a class="btn btn-primary" href="user_add.jsp">ユーザー追加</a></div>
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
function render(){
  rows.innerHTML=getUsers().map(x=>`
    <tr>
      <td>${x.id}</td><td>${x.name}</td><td>${x.role}</td><td>${x.class||''}</td><td>${x.email||''}</td>
      <td>
        <a class="btn btn-ghost" href="user_edit.html?id=${encodeURIComponent(x.id)}">編集</a>
        <button class="btn btn-danger" onclick="delUser('${x.id}')">削除</button>
      </td>
    </tr>`).join('');
}
function delUser(id){ if(!confirm('削除しますか？')) return; const arr=getUsers().filter(u=>u.id!==id); saveUsers(arr); render(); }
render();
</script>
</body></html>