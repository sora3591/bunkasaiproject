<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html><html lang="ja"><head>
<meta charset="UTF-8"><title>企画新規提出</title>
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
  <div class="title">企画新規提出（学生）</div>
  <div class="card">
    <label class="label">タイトル</label><input class="input" id="title">
    <div class="row">
      <div><label class="label">日時</label><input class="input" id="dt" placeholder="YYYY-MM-DD HH:mm"></div>
      <div><label class="label">場所</label><input class="input" id="place"></div>
    </div>
    <label class="label">担任名</label><input class="input" id="teacher" placeholder="3年1組 佐藤 など">
    <label class="label">概要</label><textarea id="desc"></textarea>
    <div style="margin-top:10px;">
      <button class="btn btn-primary" onclick="submitK()">提出</button>
      <a class="btn btn-ghost" href="kikaku_list.jsp">戻る</a>
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
const u=requireRole(['student','admin']); if(!u){}; fillWelcome(); renderNav();
function submitK(){
  const proposals=getProposals();
  const id=uid('p');
  proposals.push({id, title:title.value.trim(), datetime:dt.value, place:place.value, teacher:teacher.value, status:'提出待ち', ownerId:u.userId, desc:desc.value, files:[]});
  saveProposals(proposals);
  alert('提出しました'); location.href='kikaku_list.jsp';
}
</script>
</body></html>