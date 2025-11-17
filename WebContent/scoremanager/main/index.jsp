<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%
  // セッション上のロール判定
  String role = (String)session.getAttribute("userRole");
  if (role == null) {
    // ロール情報がない場合、セッションからユーザー情報を確認
    Object userObj = session.getAttribute("user");
    if (userObj != null) {
      bean.User user = (bean.User) userObj;
      role = user.getRole();
      session.setAttribute("userRole", role);
    } else {
      // ログインページへリダイレクト
      response.sendRedirect(request.getContextPath() + "/scoremanager/main/login.jsp");
      return;
    }
  }

  String welcome = "管理者さん、ようこそ";
  if ("student".equals(role)) welcome = "学生さん、ようこそ";
%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8" />
<title>文化祭システム - ホーム</title>
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
  .home{
    width:50px; height:50px; display:block;
    transition:transform .18s ease;
  }
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

  .wrap{ width:100%; max-width:1200px; padding:28px 24px 56px; display:flex; flex-direction:column; align-items:center; }

  .hero, .thumb{
    width:70vw; max-width:980px; min-height:54px;
    background:#eef1f6; border:1px solid var(--border); border-radius:999px;
    display:flex; align-items:center; justify-content:center;
    box-shadow:var(--shadow); color:#2c2f36; font-weight:800; letter-spacing:.02em;
  }
  .thumbs{ display:flex; gap:32px; margin-top:22px; }
  .thumb{ width:28vw; max-width:420px; }

  .imgbox{ position:relative; overflow:hidden; border-radius:999px; width:100%; }
  .imgbox img{ width:100%; height:100%; object-fit:cover; display:block; }
  .imgbox[data-alt]::after{
    content:attr(data-alt);
    position:absolute; inset:0; display:flex; align-items:center; justify-content:center;
    color:#2c2f36; font-weight:800; letter-spacing:.02em;
  }

  .sns{ display:flex; gap:28px; align-items:center; justify-content:center; margin:26px 0 6px; }
  .sns img{ width:52px; height:52px; display:block; }
  .addr{ color:#2c2f36; font-weight:700; letter-spacing:.02em; }

  .modal-bg{ position:fixed; inset:0; background:rgba(0,0,0,.28); display:none; align-items:center; justify-content:center; z-index:50; }
  .modal{ width:360px; background:#fff; border-radius:16px; border:1px solid var(--border); box-shadow:var(--shadow);
    padding:24px; text-align:center; }
  .modal h3{ margin:0 0 10px; }
  .actions{ display:flex; gap:12px; justify-content:center; margin-top:12px; }
  .btn{ padding:10px 18px; border-radius:10px; border:1px solid #d0d7e2; background:#fff; cursor:pointer; font-weight:700; }
  .btn.primary{ background:#19a3ff; color:#fff; border-color:#19a3ff; }
</style>
</head>
<body>

  <div class="topbar">
    <div class="left">
      <a href="<%= request.getContextPath() %>/scoremanager/main/index.jsp"><img class="home" src="https://cdn-icons-png.flaticon.com/512/25/25694.png" alt="Home"></a>
      <div class="title">文化祭システム</div>
    </div>

    <div class="center nav">
      <% if ("admin".equals(role)) { %>
        <a href="<%= request.getContextPath() %>/scoremanager/main/kikaku_list">企画一覧</a>
        <a href="<%= request.getContextPath() %>/scoremanager/main/users_list">ユーザー一覧</a>
        <a href="<%= request.getContextPath() %>/scoremanager/main/survey_list">アンケート</a>
        <a href="<%= request.getContextPath() %>/scoremanager/main/survey_admin">アンケート作成</a>
        <a href="<%= request.getContextPath() %>/scoremanager/main/map_list">校内図</a>
      <% } else { %>
        <a href="<%= request.getContextPath() %>/scoremanager/main/kikaku_list">企画一覧</a>
        <a href="<%= request.getContextPath() %>/scoremanager/main/kikaku_add">企画提出</a>
        <a href="<%= request.getContextPath() %>/scoremanager/main/survey_list">アンケート</a>
        <a href="<%= request.getContextPath() %>/scoremanager/main/map_list">校内図</a>
      <% } %>
    </div>

    <div class="right">
      <div><%= welcome %></div>
      <a class="logout" href="javascript:void(0)" onclick="openLogout()">ログアウト</a>
    </div>
  </div>

  <div class="wrap">
    <div class="hero">
      <div class="imgbox" data-alt="main">
        <img src="<%= request.getContextPath() %>/scoremanager/main/images/main.jpg" alt="main" onerror="this.style.display='none'">
      </div>
    </div>

    <div class="thumbs">
      <div class="thumb">
        <div class="imgbox" data-alt="e1">
          <img src="images/e1.jpg" alt="e1" onerror="this.style.display='none'">
        </div>
      </div>
      <div class="thumb">
        <div class="imgbox" data-alt="e2">
          <img src="images/e2.jpg" alt="e2" onerror="this.style.display='none'">
        </div>
      </div>
    </div>

    <div class="sns">
      <img src="https://cdn-icons-png.flaticon.com/512/3670/3670051.png" alt="whatsapp">
      <img src="https://cdn-icons-png.flaticon.com/512/733/733547.png" alt="facebook">
      <img src="https://cdn-icons-png.flaticon.com/512/733/733579.png" alt="twitter">
      <img src="https://cdn-icons-png.flaticon.com/512/3670/3670147.png" alt="youtube">
    </div>

    <div class="addr">〒101-8551 東京都千代田区神田三崎町2-4-1</div>
  </div>

  <div class="modal-bg" id="logoutModal">
    <div class="modal">
      <h3>ログアウトしますか？</h3>
      <div class="actions">
        <button class="btn primary" onclick="confirmLogout()">はい</button>
        <button class="btn" onclick="closeLogout()">いいえ</button>
      </div>
    </div>
  </div>

<script>
  function openLogout(){
    document.getElementById('logoutModal').style.display='flex';
  }
  function closeLogout(){
    document.getElementById('logoutModal').style.display='none';
  }
  function confirmLogout(){
    location.href='<%= request.getContextPath() %>/scoremanager/main/logout';
  }
</script>
</body>
</html>