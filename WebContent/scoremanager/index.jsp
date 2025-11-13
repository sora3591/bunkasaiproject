<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  // =========================
  //  セッション上のロール判定
  //  ※ 実環境では LoginAction 等で session.setAttribute("userRole", "admin"/"student")
  // =========================
  String role = (String)session.getAttribute("userRole");
  if (role == null) role = "admin"; // デモのため未ログイン時は管理者表示
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
  /* =========================
     カラートークン
     ========================= */
  :root{
    --bg:#eef2f8;           /* 背景の薄いブルー */
    --text:#111;            /* 文字色 */
    --border:#e5e7eb;       /* 境界線 */
    --white:#fff;           /* 白 */
    --primary:#1d8cf8;      /* 主色（リンク/アクセント）*/
    --shadow:0 6px 16px rgba(0,0,0,.07); /* ソフトな影 */
    --grad:linear-gradient(135deg,#3fa9ff,#0078d7); /* タイトル用グラデ */
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

  /* =========================
     トップナビ（磨りガラス + グラデ文字 + ホバーアニメ）
     ========================= */
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
    -webkit-text-fill-color:transparent; /* グラデ文字 */
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
  .logout{ color:var(--primary); text-decoration:none; }
  .logout:hover{ text-decoration:underline; }

  /* =========================
     メインセクション（中央寄せ）
     ========================= */
  .wrap{ width:100%; max-width:1200px; padding:28px 24px 56px; display:flex; flex-direction:column; align-items:center; }

  /* 大きな丸角ピル（メイン画像）/ 小ピル（サムネ） */
  .hero, .thumb{
    width:70vw; max-width:980px; min-height:54px;
    background:#eef1f6; border:1px solid var(--border); border-radius:999px;
    display:flex; align-items:center; justify-content:center;
    box-shadow:var(--shadow); color:#2c2f36; font-weight:800; letter-spacing:.02em;
  }
  .thumbs{ display:flex; gap:32px; margin-top:22px; }
  .thumb{ width:28vw; max-width:420px; }

  /* 画像ボックス（画像が無ければラベルを表示） */
  .imgbox{ position:relative; overflow:hidden; border-radius:999px; width:100%; }
  .imgbox img{ width:100%; height:100%; object-fit:cover; display:block; }
  .imgbox[data-alt]::after{
    content:attr(data-alt);
    position:absolute; inset:0; display:flex; align-items:center; justify-content:center;
    color:#2c2f36; font-weight:800; letter-spacing:.02em;
  }

  /* SNS と住所 */
  .sns{ display:flex; gap:28px; align-items:center; justify-content:center; margin:26px 0 6px; }
  .sns img{ width:52px; height:52px; display:block; }
  .addr{ color:#2c2f36; font-weight:700; letter-spacing:.02em; }

  /* =========================
     ログアウト確認モーダル
     ========================= */
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

  <!-- =========================
       トップナビ
       （管理者/学生で項目を出し分け）
       ========================= -->
  <div class="topbar">
    <div class="left">
      <!-- ホームアイコン -->
      <a href="index.jsp"><img class="home" src="https://cdn-icons-png.flaticon.com/512/25/25694.png" alt="Home"></a>
      <div class="title">文化祭システム</div>
    </div>

    <!-- 中央ナビ（管理者 or 学生） -->
    <div class="center nav">
      <% if ("admin".equals(role)) { %>
        <a href="kikaku_list.jsp">企画一覧</a>
        <a href="users_list.jsp">ユーザー一覧</a>
        <a href="survey_list.jsp">アンケート</a>
        <a href="survey_admin.jsp">アンケート作成</a>
        <a href="map_list.jsp">校内図</a>
      <% } else { %>
        <a href="kikaku_list.jsp">企画一覧</a>
        <a href="kikaku_add.jsp">企画提出</a>
        <a href="survey_list.jsp">アンケート</a>
        <a href="map_list.jsp">校内図</a>
      <% } %>
    </div>

    <div class="right">
      <div><%= welcome %></div>
      <a class="logout" href="javascript:void(0)" onclick="openLogout()">ログアウト</a>
    </div>
  </div>

  <!-- =========================
       メインセクション
       ========================= -->
  <div class="wrap">
    <!-- メイン画像（無ければ "main" ラベル） -->
    <div class="hero">
      <div class="imgbox" data-alt="main">
        <img src="images/main.jpg" alt="main" onerror="this.style.display='none'">
      </div>
    </div>

    <!-- サムネ 2枚（無ければ "e1" / "e2" ラベル） -->
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

    <!-- SNS アイコン -->
    <div class="sns">
      <img src="https://cdn-icons-png.flaticon.com/512/3670/3670051.png" alt="whatsapp">
      <img src="https://cdn-icons-png.flaticon.com/512/733/733547.png" alt="facebook">
      <img src="https://cdn-icons-png.flaticon.com/512/733/733579.png" alt="twitter">
      <img src="https://cdn-icons-png.flaticon.com/512/3670/3670147.png" alt="youtube">
    </div>

    <!-- 住所 -->
    <div class="addr">〒101-8551 東京都千代田区神田三崎町2-4-1</div>
  </div>

  <!-- =========================
       ログアウト確認モーダル
       ========================= -->
  <div class="modal-bg" id="logoutModal">
    <div class="modal">
      <h3>ログアウトしますか？</h3>
      <div class="actions">
        <!-- 実運用では LogoutAction を GET/POST で呼び出す設計に置換可 -->
        <button class="btn primary" onclick="location.href='login.jsp'">はい</button>
        <button class="btn" onclick="closeLogout()">いいえ</button>
      </div>
    </div>
  </div>

<script>
  // =========================
  //  モーダル制御（シンプル版）
  // =========================
  function openLogout(){ document.getElementById('logoutModal').style.display='flex'; }
  function closeLogout(){ document.getElementById('logoutModal').style.display='none'; }
</script>
</body>
</html>
