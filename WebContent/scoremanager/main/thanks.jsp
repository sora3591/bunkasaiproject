<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>ご回答ありがとうございました</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link rel="stylesheet" href="styles.css" />

<style>
  .thanks-box {
    margin: 80px auto;
    max-width: 480px;
    padding: 32px;
    background: #fff;
    border-radius: 12px;
    text-align: center;
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
  }
  .thanks-title {
    font-size: 22px;
    font-weight: 700;
    margin-bottom: 16px;
  }
  .thanks-text {
    font-size: 16px;
    color: #444;
    margin-bottom: 24px;
  }
</style>

<!-- 自动 3 秒跳转 -->
<meta http-equiv="refresh" content="3;URL=survey_list.jsp">
</head>
<body>

<div class="top-bar">
  <div class="nav-left">
    <a href="index.jsp"><img src="https://cdn-icons-png.flaticon.com/512/1946/1946436.png" class="icon-home"></a>
    <div class="system-title">文化祭システム</div>
  </div>
  <div class="nav-center"></div>
  <div class="nav-right">ようこそ</div>
</div>

<div class="wrap">
  <div class="thanks-box">
    <div class="thanks-title">ご回答ありがとうございました！</div>
    <div class="thanks-text">
      ご協力に感謝いたします。<br>
      自動的にアンケート一覧へ戻ります。
    </div>
    <a href="survey_list" class="btn btn-primary">アンケート一覧に戻る</a>
  </div>
</div>

<script src="app.js"></script>
<script>
try { requireAuth(); fillWelcome(); renderNav(); } catch(e){}
</script>
</body>
</html>