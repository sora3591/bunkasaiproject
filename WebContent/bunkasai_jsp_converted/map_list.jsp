<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html><html lang="ja"><head>
<meta charset="UTF-8"><title>校内図一覧</title>
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
  <div class="title">校内図一覧</div>
  <div class="table-wrap">
    <table><thead><tr><th>ID</th><th>名称</th><th>プレビュー</th></tr></thead><tbody id="rows"></tbody></table>
  </div>
  <div style="margin-top:12px;"><a class="btn btn-primary" href="map_add.jsp">校内図追加</a></div>
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
function render(){
  const data = getMaps();
  rows.innerHTML = data.map(m=>`
    <tr>
      <td>${m.id}</td>
      <td>${m.name}</td>
      <td>${m.img ? `<img src="${m.img}" style="width:120px; height:80px; object-fit:cover; border-radius:8px;">` : '<span class="err">画像なし</span>'}</td>
    </tr>`).join('');
}
render();
</script>
</body></html>