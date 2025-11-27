<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ page import="java.util.List" %>
<%@ page import="bean.Map" %>
<%@ page import="dao.MapDao" %>
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
    String welcome = "管理者さん、ようこそ";
    if ("student".equals(role)) welcome = "学生さん、ようこそ";

    // MapListActionから渡されたデータを取得
    List<Map> mapList = (List<Map>) request.getAttribute("mapList");
    String error = (String) request.getAttribute("error");

    // 直接アクセスされた場合は、ここでデータを取得（フォールバック）
    if (mapList == null) {
        try {
            MapDao dao = new MapDao();
            mapList = dao.getAll();
        } catch (Exception e) {
            e.printStackTrace();
            error = "データの取得に失敗しました";
        }
    }
%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>校内図一覧 - 文化祭システム</title>
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
  .wrap{ width:100%; max-width:1200px; padding:28px 24px 56px; }
  .page-title{
    font-size:28px; font-weight:800; margin-bottom:24px;
    background:var(--grad);
    -webkit-background-clip:text;
    -webkit-text-fill-color:transparent;
  }
  .table-wrap{
    width:100%; background:var(--white); border-radius:14px;
    border:1px solid var(--border); box-shadow:var(--shadow);
    overflow:hidden;
  }
  table{
    width:100%; border-collapse:collapse;
  }
  thead{
    background:#f8f9fb;
  }
  th{
    padding:14px 12px; text-align:left; font-weight:700;
    border-bottom:2px solid var(--border); color:#374151;
  }
  td{
    padding:12px; border-bottom:1px solid #f3f4f6;
  }
  tbody tr:hover{
    background:#f9fafb;
  }
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
  .err{
    color:#dc2626; font-size:13px;
  }
  .error-box{
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

<div class="topbar">
  <div class="left">
    <a href="<%= request.getContextPath() %>/scoremanager/main/index.jsp"><img class="home" src="https://cdn-icons-png.flaticon.com/512/25/25694.png" alt="Home"></a>
    <div class="title">文化祭システム</div>
  </div>
  <div class="center nav">
    <% if ("admin".equals(role)) { %>
      <a href="<%= request.getContextPath() %>/scoremanager/main/kikaku_list">企画一覧</a>
      <a href="<%= request.getContextPath() %>/scoremanager/main/users_list.jsp">ユーザー一覧</a>
      <a href="<%= request.getContextPath() %>/scoremanager/main/survey_list.jsp">アンケート</a>
      <a href="<%= request.getContextPath() %>/scoremanager/main/survey_admin.jsp">アンケート作成</a>
      <a href="<%= request.getContextPath() %>/scoremanager/main/map_list">校内図</a>
    <% } else { %>
      <a href="<%= request.getContextPath() %>/scoremanager/main/kikaku_list">企画一覧</a>
      <a href="<%= request.getContextPath() %>/scoremanager/main/kikaku_add">企画提出</a>
      <a href="<%= request.getContextPath() %>/scoremanager/main/survey_list.jsp">アンケート</a>
      <a href="<%= request.getContextPath() %>/scoremanager/main/map_list.jsp">校内図</a>
    <% } %>
  </div>
  <div class="right">
    <div><%= welcome %></div>
    <a class="logout" href="javascript:void(0)" onclick="openLogout()">ログアウト</a>
  </div>
</div>

<div class="wrap">
  <div class="page-title">校内図一覧</div>

  <% if (error != null) { %>
    <div class="error-box"><%= error %></div>
  <% } %>

  <div class="table-wrap">
    <table>
      <thead>
        <tr>
          <th style="width:180px;">ID</th>
          <th>名称</th>
          <th style="width:220px;">プレビュー</th>
        </tr>
      </thead>
      <tbody>
        <% if (mapList == null || mapList.isEmpty()) { %>
          <tr>
            <td colspan="3" style="text-align:center; color:#6b7280; padding:40px;">校内図データがありません</td>
          </tr>
        <% } else { %>
          <% for (Map map : mapList) { %>
            <tr>
              <td style="font-size:13px; color:#6b7280;"><%= map.getId() %></td>
              <td style="font-weight:600;"><%= map.getName() %></td>
              <td>
                <% if (map.getImg() != null && !map.getImg().isEmpty()) { %>
                  <img src="<%= map.getImg() %>" style="width:180px; height:120px; object-fit:cover; border-radius:8px; box-shadow:0 2px 8px rgba(0,0,0,0.1);">
                <% } else { %>
                  <span class="err">画像なし</span>
                <% } %>
              </td>
            </tr>
          <% } %>
        <% } %>
      </tbody>
    </table>
  </div>

  <div style="margin-top:20px;">
    <% if ("admin".equals(role)) { %>
      <a class="btn btn-primary" href="<%= request.getContextPath() %>/scoremanager/main/map_add">校内図追加</a>
    <% } %>
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
</script>

</body>
</html>