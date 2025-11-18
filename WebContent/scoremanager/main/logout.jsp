<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  // このページにアクセスされたら即座にログアウト処理
  session.invalidate();
  response.sendRedirect(request.getContextPath() + "/scoremanager/main/login.jsp");
%>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>ログアウト</title>
</head>
<body>
  <p>ログアウトしています...</p>
  <script>
    // 念のためJavaScriptでもリダイレクト
    location.href = '<%= request.getContextPath() %>/scoremanager/main/login.jsp';
  </script>
</body>
</html>