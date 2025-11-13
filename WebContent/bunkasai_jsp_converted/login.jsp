<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html><html lang="ja"><head>
<meta charset="UTF-8"><title>文化祭システム - ログイン</title>
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
<div class="login-box">
  <div class="login-title">ログイン</div>
  <label class="label">ユーザーID / 管理者ID</label>
  <input class="input" id="id" placeholder="admin / s001 / s002">
  <label class="label">パスワード</label>
  <input class="input" type="password" id="pw" placeholder="1234">
  <div class="err">※ デモ用：上記のID/PWでログインできます</div>
  <div style="margin-top:14px; display:flex; gap:10px;">
    <button class="btn btn-primary" onclick="login()">ログイン</button>
    <a class="btn btn-ghost" href="register.jsp">新規登録</a>
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
function login(){
  const id=document.getElementById('id').value.trim();
  const pw=document.getElementById('pw').value;
  if(!id||!pw) return alert('ID/PW を入力してください');
  const users=getUsers();
  const u=users.find(x=>x.id===id);
  if((id==='admin'&&pw==='1234')||((id==='s001'||id==='s002')&&pw==='1234')||u){ 
    const role=u?u.role:(id==='admin'?'admin':'student');
    setUserSession({userId:id, role});
    location.href='index.jsp';
  } else alert('ID またはパスワードが正しくありません');
}
fillWelcome(); renderNav();
</script>
</body></html>