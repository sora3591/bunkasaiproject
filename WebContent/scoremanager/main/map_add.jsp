<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%
    bean.User user = (bean.User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/scoremanager/main/login.jsp");
        return;
    }
    String role = (String)session.getAttribute("userRole");
    if (role == null) {
        role = user.getRole();
        session.setAttribute("userRole", role);
    }

    // 管理者チェック
    if (!"admin".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/scoremanager/main/index.jsp");
        return;
    }

    String welcome = "管理者さん、ようこそ";
    String error = (String) request.getAttribute("error");
%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/common/header.jsp"></c:import>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>校内図追加 - 文化祭システム</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<style>
  :root{
    --bg:#eef2f8;
    --text:#111;
    --border:#e5e7eb;
    --white:#fff;
    --primary:#1d8cf8;
    --shadow:0 6px 16px rgba(0,0,0,.07);
    --grad:linear-gradient(135deg,#3fa9ff,#0078d7);
  }
  *{ box-sizing:border-box; }
  html,body{ height:100%; }
  body{
    margin:0;
    color:var(--text);
    background:linear-gradient(180deg,var(--bg) 0%, #f7f8fb 40%, var(--bg) 100%);
    font-family: "Noto Sans JP", system-ui, -apple-system,"Segoe UI",Roboto,"Helvetica Neue",Arial,"Yu Gothic","Meiryo",sans-serif;
    display:flex; flex-direction:column; align-items:center;
  }
  .topbar{
    width:100%; max-width:1200px; height:78px;
    display:flex; align-items:center; justify-content:space-between;
    padding:0 26px;
    background:rgba(255,255,255,0.72);
    backdrop-filter:blur(10px);
    border-radius:14px;
    border:1px solid rgba(255,255,255,0.35);
    box-shadow:var(--shadow);
    margin-top:10px;
    transition:box-shadow .3s ease;
  }
  .topbar:hover{ box-shadow:0 10px 24px rgba(0,0,0,.12); }
  .left{ display:flex; align-items:center; gap:14px; }
  .home{ width:50px; height:50px; display:block; transition:transform .18s ease; }
  .home:hover{ transform:scale(1.06); }
  .title{
    font-size:24px; font-weight:800; letter-spacing:.03em;
    background:var(--grad);
    -webkit-background-clip:text;
    -webkit-text-fill-color:transparent;
  }
  .center{ display:flex; align-items:center; gap:28px; font-weight:700; }
  .nav a{
    position:relative; text-decoration:none; color:#222; font-size:16px; padding:6px 4px;
    transition:color .2s ease;
  }
  .nav a::after{
    content:''; position:absolute; left:0; bottom:-4px; width:0; height:3px;
    background:var(--primary); border-radius:2px; transition:width .22s ease;
  }
  .nav a:hover{ color:var(--primary); }
  .nav a:hover::after{ width:100%; }
  .right{ display:flex; flex-direction:column; align-items:flex-end; gap:4px; font-weight:700; }
  .logout{ color:var(--primary); text-decoration:none; cursor:pointer; }
  .logout:hover{ text-decoration:underline; }
  .wrap{ width:100%; max-width:800px; padding:28px 24px 56px; }
  .page-title{
    font-size:28px; font-weight:800; margin-bottom:24px;
    background:var(--grad);
    -webkit-background-clip:text;
    -webkit-text-fill-color:transparent;
  }
  .card{
    background:var(--white); padding:24px; border-radius:14px;
    border:1px solid var(--border); box-shadow:var(--shadow);
  }
  .label{ display:block; font-weight:700; margin-bottom:8px; }
  .input{
    width:100%; padding:10px 14px; border:1px solid var(--border);
    border-radius:8px; font-size:15px;
  }
  .input:focus{ outline:none; border-color:var(--primary); }
  .btn{
    padding:10px 18px; border-radius:8px; text-decoration:none;
    font-weight:600; display:inline-block; cursor:pointer;
    border:none; transition:all .2s ease;
  }
  .btn-primary{
    background:var(--primary); color:var(--white);
    border:1px solid var(--primary);
  }
  .btn-primary:hover{ background:#0078d7; }
  .btn-ghost{
    background:var(--white); color:var(--primary);
    border:1px solid var(--border);
  }
  .btn-ghost:hover{ background:#f3f4f6; }
  .err{
    background:#fee; color:#c33; padding:12px 18px; border-radius:8px;
    border:1px solid #fcc; margin-bottom:16px;
  }
  .modal-bg{
    position:fixed; inset:0; background:rgba(0,0,0,.28);
    display:none; align-items:center; justify-content:center; z-index:50;
  }
  .modal{
    width:360px; background:#fff; border-radius:16px;
    border:1px solid var(--border); box-shadow:var(--shadow);
    padding:24px; text-align:center;
  }
  .modal h3{ margin:0 0 10px; }
  .modal-actions{
    display:flex; gap:12px; justify-content:center; margin-top:12px;
  }
  .modal-btn{
    padding:10px 18px; border-radius:10px; border:1px solid #d0d7e2;
    background:#fff; cursor:pointer; font-weight:700;
  }
  .modal-btn.primary{
    background:#19a3ff; color:#fff; border-color:#19a3ff;
  }
</style>
</head>
<body>


<div class="wrap">
  <div class="page-title">校内図追加</div>

  <% if (error != null) { %>
    <div class="err"><%= error %></div>
  <% } %>

  <div class="card">
    <form method="post" action="<%= request.getContextPath() %>/scoremanager/main/map_add" enctype="multipart/form-data">
      <label class="label">名称</label>
      <input type="text" name="name" class="input" placeholder="例：本館1階" required>

      <label class="label" style="margin-top:16px;">画像</label>
      <input type="file" name="image" id="imageFile" accept="image/*" class="input">

      <div style="margin-top:12px;">
        <img id="preview" style="max-width:100%; max-height:300px; border-radius:10px; display:none;">
      </div>

      <div style="margin-top:20px; display:flex; gap:12px;">
        <button type="submit" class="btn btn-primary">追加</button>
        <a class="btn btn-ghost" href="<%= request.getContextPath() %>/scoremanager/main/map_list.jsp">戻る</a>
      </div>
    </form>
  </div>
</div>

<div class="modal-bg" id="logoutModal">
  <div class="modal">
    <h3>ログアウトしますか？</h3>
    <div class="modal-actions">
      <button class="modal-btn primary" onclick="confirmLogout()">はい</button>
      <button class="modal-btn" onclick="closeLogout()">いいえ</button>
    </div>
  </div>
</div>

<script>
// ログアウト関連
function openLogout(){
  document.getElementById('logoutModal').style.display='flex';
}
function closeLogout(){
  document.getElementById('logoutModal').style.display='none';
}
function confirmLogout(){
  location.href='<%= request.getContextPath() %>/scoremanager/main/logout';
}

// プレビュー表示
document.getElementById('imageFile').addEventListener('change', function(){
  const file = this.files[0];
  const preview = document.getElementById('preview');

  if(!file){
    preview.style.display='none';
    return;
  }

  const reader = new FileReader();
  reader.onload = function(){
    preview.src = reader.result;
    preview.style.display='block';
  };
  reader.readAsDataURL(file);
});
</script>

</body>
</html>