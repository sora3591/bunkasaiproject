
const STORAGE_USER='bk_user', STORAGE_USERS='bk_users', STORAGE_PROPOSALS='bk_proposals', STORAGE_SURVEYS='bk_surveys', STORAGE_MAPS='bk_maps';
function setUserSession(user){ localStorage.setItem(STORAGE_USER, JSON.stringify(user)); }
function getUserSession(){ try{ return JSON.parse(localStorage.getItem(STORAGE_USER)||'null'); } catch { return null; } }
function clearUserSession(){ localStorage.removeItem(STORAGE_USER); }
function requireAuth(){ const u=getUserSession(); if(!u){ location.href='login.html'; return null; } return u; }
function requireRole(r){ const u=requireAuth(); if(!u)return null; if(!r.includes(u.role)){ location.href='index.html'; return null; } return u; }
function doLogout(){ clearUserSession(); location.href='login.html'; }
function openLogout(){ const m=document.getElementById('logoutModal'); if(m) m.style.display='flex'; }
function closeLogout(){ const m=document.getElementById('logoutModal'); if(m) m.style.display='none'; }
function confirmLogout(){ doLogout(); }
function fillWelcome(sel='.nav-right'){ const u=getUserSession(); const el=document.querySelector(sel); if(u&&el){ el.innerHTML=`${u.role==='admin'?'管理者':'学生'}さん、ようこそ<br><a style="color:#0ea5e9;text-decoration:none;" href="javascript:void(0)" onclick="openLogout()">ログアウト</a>`; } }
function ensureData(){
  if(!localStorage.getItem(STORAGE_USERS)){
    localStorage.setItem(STORAGE_USERS, JSON.stringify([
      {id:'admin', name:'管理者', role:'admin', class:'', email:'admin@school.jp'},
      {id:'s001', name:'田中', role:'student', class:'3-1', email:'s001@school.jp'},
      {id:'s002', name:'佐々木', role:'student', class:'3-1', email:'s002@school.jp'}
    ]));
  }
  if(!localStorage.getItem(STORAGE_PROPOSALS)){
    localStorage.setItem(STORAGE_PROPOSALS, JSON.stringify([
      {id:'p1', title:'たこ焼き屋', datetime:'2025-10-28 10:00', place:'体育館', teacher:'3年1組 佐藤', status:'承認中', ownerId:'s001', desc:'たこ焼きを販売する模擬店。必要機材：ホットプレート、延長コード。', files:['layout.pdf','menu.png']},
      {id:'p2', title:'月', datetime:'2025-10-24 10:00', place:'校庭', teacher:'3年1組 佐々木', status:'承認完了', ownerId:'s002', desc:'フォトスポットの展示。', files:['photo.jpg']}
    ]));
  }
  if(!localStorage.getItem(STORAGE_SURVEYS)){
    localStorage.setItem(STORAGE_SURVEYS, JSON.stringify([
      {id:'sv1', title:'来場者アンケート', questions:[
        {id:'q1', label:'満足度（1~5）', type:'number'},
        {id:'q2', label:'気に入った企画', type:'text'},
        {id:'q3', label:'ご意見', type:'textarea'}
      ], responses:[]}
    ]));
  }
  if(!localStorage.getItem(STORAGE_MAPS)){
    localStorage.setItem(STORAGE_MAPS, JSON.stringify([ {id:'m1', name:'体育館案内図', img:''}, {id:'m2', name:'本館3F', img:''} ]));
  }
}
ensureData();
function getUsers(){ return JSON.parse(localStorage.getItem(STORAGE_USERS)||'[]'); }
function saveUsers(a){ localStorage.setItem(STORAGE_USERS, JSON.stringify(a)); }
function getProposals(){ return JSON.parse(localStorage.getItem(STORAGE_PROPOSALS)||'[]'); }
function saveProposals(a){ localStorage.setItem(STORAGE_PROPOSALS, JSON.stringify(a)); }
function getSurveys(){ return JSON.parse(localStorage.getItem(STORAGE_SURVEYS)||'[]'); }
function saveSurveys(a){ localStorage.setItem(STORAGE_SURVEYS, JSON.stringify(a)); }
function getMaps(){ return JSON.parse(localStorage.getItem(STORAGE_MAPS)||'[]'); }
function saveMaps(a){ localStorage.setItem(STORAGE_MAPS, JSON.stringify(a)); }
function uid(p){ return p + Math.random().toString(36).slice(2,8); }
function detailPathByRole(){ const u=getUserSession(); return (u&&u.role==='student')?'kikaku_detail_student.html':'kikaku_detail.html'; }


// === Role-based navigation ===
function renderNav(){
  const c = document.getElementById('navCenter');
  if(!c) return;
  const u = getUserSession();
  const itemsAdmin = [
    ['kikaku_list.html','企画一覧'],
    ['users_list.html','ユーザー一覧'],
    ['survey_list.html','アンケート'],
    ['survey_admin.html','アンケート作成'],
    ['map_list.html','校内図'],
    
    
  ];
  const itemsStudent = [
    ['kikaku_list.html','企画一覧'],
    ['kikaku_add.html','企画提出'],
    ['survey_list.html','アンケート'],
    ['map_list.html','校内図']
  ];
  const items = (u && u.role==='admin') ? itemsAdmin : itemsStudent;
  c.innerHTML = items.map(([href,label]) => `<a class="nav-item" href="${href}">${label}</a>`).join('');
  // active highlight
  const here = location.pathname.split('/').pop();
  [...c.querySelectorAll('a')].forEach(a=>{ if(a.getAttribute('href')===here){ a.style.fontWeight='700'; a.style.textDecoration='underline'; }});
}

// helpers
function getProposalTitle(id){
  const p = getProposals().find(x=>x.id===id);
  return p ? p.title : '(不明な企画)';
}
