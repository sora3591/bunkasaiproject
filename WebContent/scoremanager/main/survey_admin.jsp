<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="bean.Survey" %>

<%
    // ログインチェック（企画一覧と同じパターン）
    bean.User user = (bean.User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/scoremanager/main/login.jsp");
        return;
    }

    // SurveyAdminAction から渡される編集対象
    Survey editingSurvey = (Survey) request.getAttribute("editingSurvey");
%>

<!-- 共通ヘッダー（ナビ・ロゴなど） -->
<c:import url="/common/header.jsp"></c:import>

<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>アンケート作成（管理者）</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <!-- 企画一覧と同じ CSS を利用 -->
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css" />
</head>
<body>

<div class="wrap">
  <!-- ★ 見出しも企画一覧 / ユーザー一覧と同じ .title クラス -->
  <div class="title">アンケート作成（管理者）</div>

  <!-- エラー表示 -->
  <c:if test="${not empty error}">
    <div class="err">${error}</div>
  </c:if>
  <c:if test="${not empty errors}">
    <div class="err">
      <c:forEach var="e" items="${errors}">
        ・${e}<br/>
      </c:forEach>
    </div>
  </c:if>

  <!-- アンケート編集フォーム -->
  <form method="post" action="<%= request.getContextPath() %>/scoremanager/main/survey_admin">
    <!-- 編集時用 ID -->
    <input type="hidden" name="surveyId"
           value="<c:out value='${editingSurvey != null ? editingSurvey.id : ""}'/>" />

    <div class="card">

      <!-- 対象企画（承認完了のみ：kikakuList） -->
      <label class="label">対象企画</label>
      <select name="proposalId" class="select">
        <option value="">企画を選択してください</option>
        <c:forEach var="k" items="${kikakuList}">
          <option value="${k.id}"
            <c:if test="${editingSurvey != null && editingSurvey.proposalId == k.id}">
              selected
            </c:if>>
            ${k.title}
          </option>
        </c:forEach>
      </select>

      <!-- アンケートタイトル -->
      <label class="label" style="margin-top:8px;">アンケートタイトル</label>
      <input class="input" name="title" placeholder="例）来場者アンケート"
             value="<c:out value='${editingSurvey != null ? editingSurvey.title : ""}'/>" />

      <!-- 質問エリア -->
      <div class="subtitle" style="margin-top:12px;">質問</div>
      <div id="qs"></div>

      <div style="margin-top:8px; display:flex; gap:8px;">
        <button type="button" class="btn btn-ghost" onclick="addQ('text')">+ テキスト</button>
        <button type="button" class="btn btn-ghost" onclick="addQ('number')">+ 数値</button>
        <button type="button" class="btn btn-ghost" onclick="addQ('textarea')">+ テキストエリア</button>
      </div>

      <div style="margin-top:14px;">
        <button type="submit" class="btn btn-primary">保存</button>
        <a class="btn btn-ghost"
           href="<%= request.getContextPath() %>/scoremanager/main/survey_list">一覧に戻る</a>
      </div>
    </div>
  </form>
</div>

<!-- ログアウト確認モーダル（企画一覧と同じ構造にしたいなら、必要なら残してOK） -->
<div class="modal-bg" id="logoutModal">
  <div class="modal">
    <div>ログアウトしますか？</div>
    <div class="modal-actions">
      <button class="btn btn-primary" onclick="confirmLogout()">はい</button>
      <button class="btn btn-ghost" onclick="closeLogout()">いいえ</button>
    </div>
  </div>
</div>

<script>
  // ===== 既存質問（編集時用）を JS に渡す =====
  var initialQuestions = [];
  <%-- editingSurvey.questions を JS 配列へ --%>
  <c:if test="${editingSurvey != null && editingSurvey.questions != null}">
    <c:forEach var="q" items="${editingSurvey.questions}">
      initialQuestions.push({
        type:  "${q.type}",
        label: "${fn:escapeXml(q.label)}"
      });
    </c:forEach>
  </c:if>

  const qsDiv = document.getElementById('qs');

  function renderQuestions(list){
    if (!list || list.length === 0) {
      qsDiv.innerHTML = '<div class="err">+ ボタンで質問を追加してください</div>';
      return;
    }
    qsDiv.innerHTML = '';
    list.forEach(function(q, idx){
      const row = document.createElement('div');
      row.style.cssText = "display:flex; gap:8px; align-items:center; margin:6px 0;";

      // 種別
      const sel = document.createElement('select');
      sel.name = "qType";
      sel.className = "select";
      sel.style.maxWidth = "140px";
      ["text","number","textarea"].forEach(function(t){
        const opt = document.createElement('option');
        opt.value = t;
        opt.textContent =
          (t === "text" ? "テキスト" :
           t === "number" ? "数値" : "テキストエリア");
        if (q.type === t) opt.selected = true;
        sel.appendChild(opt);
      });

      // ラベル
      const inp = document.createElement('input');
      inp.name = "qLabel";
      inp.className = "input";
      inp.placeholder = "質問文";
      inp.value = q.label || "";

      // 削除ボタン
      const btn = document.createElement('button');
      btn.type = "button";
      btn.className = "btn btn-danger";
      btn.textContent = "削除";
      btn.onclick = function(){
        list.splice(idx, 1);
        renderQuestions(list);
      };

      row.appendChild(sel);
      row.appendChild(inp);
      row.appendChild(btn);
      qsDiv.appendChild(row);
    });
  }

  let questionList = initialQuestions.slice();

  function addQ(type){
    questionList.push({ type: type, label: "" });
    renderQuestions(questionList);
  }

  document.addEventListener('DOMContentLoaded', function(){
    renderQuestions(questionList);
  });

  // ===== ログアウトモーダル制御（企画一覧と同じ） =====
  function openLogoutModal() {
    document.getElementById('logoutModal').style.display = 'flex';
  }

  function closeLogout() {
    document.getElementById('logoutModal').style.display = 'none';
  }

  function confirmLogout() {
    location.href = '<%= request.getContextPath() %>/scoremanager/main/logout';
  }
</script>
</body>
</html>