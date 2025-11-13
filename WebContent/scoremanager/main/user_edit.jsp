<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html><html lang="ja"><head>
<meta charset="UTF-8"><title>ユーザー編集</title>
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
  <div class="title">ユーザー編集</div>
  <div class="card">
    <div class="row">
      <div><label class="label">ID</label><input class="input" id="id" disabled></div>
      <div><label class="label">氏名</label><input class="input" id="name"></div>
    </div>
    <div class="row">
      <div><label class="label">ロール</label><select id="role" class="select"><option value="student">学生</option><option value="admin">管理者</option></select></div>
      <div><label class="label">クラス</label><input class="input" id="cls"></div>
    </div>
    <label class="label">メール</label><input class="input" id="mail">
    <div style="margin-top:10px;">
      <button class="btn btn-primary" onclick="saveEdit()">保存</button>
      <a class="btn btn-ghost" href="users_list.jsp">戻る</a>
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
const q=new URLSearchParams(location.search); const uid=q.get('id');
const users=getUsers(); const me=users.find(x=>x.id===uid); if(!me) location.href='users_list.jsp';
id.value=me.id; name.value=me.name; role.value=me.role; cls.value=me.class||''; mail.value=me.email||'';
function saveEdit(){
  me.name=name.value.trim(); me.role=role.value; me.class=cls.value; me.email=mail.value; saveUsers(users);
  alert('保存しました'); location.href='users_list.jsp';
}
</script>
</body></html>