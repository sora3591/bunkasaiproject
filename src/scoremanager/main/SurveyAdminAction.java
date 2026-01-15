package scoremanager.main;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Kikaku;
import bean.Survey;
import bean.SurveyQuestion;
import dao.KikakuDao;
import dao.SurveyDao;

@WebServlet("/scoremanager/main/survey_admin")
public class SurveyAdminAction extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // =============================
    //  共通：フォーム表示メソッド
    // =============================
    private void showForm(HttpServletRequest request,
                          HttpServletResponse response,
                          Survey editingSurvey,
                          List<String> errors,
                          String errMsg)
            throws ServletException, IOException {

        try {
            // 承認完了の企画だけ取得
            KikakuDao kDao = new KikakuDao();
            List<Kikaku> kikakuList = kDao.getApproved();
            if (kikakuList == null) {
                kikakuList = new ArrayList<>();
            }

            request.setAttribute("kikakuList", kikakuList);
            request.setAttribute("editingSurvey", editingSurvey);

            if (errMsg != null) {
                request.setAttribute("error", errMsg);
            }
            if (errors != null && !errors.isEmpty()) {
                request.setAttribute("errors", errors);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "アンケート作成画面の準備中にエラーが発生しました。");
        }

        // ★ ここは「.jsp」に必ず forward する（自分自身の URL にはしない）
        RequestDispatcher rd =
                request.getRequestDispatcher("/scoremanager/main/survey_admin.jsp");
        rd.forward(request, response);
    }

    // =============================
    //  GET：新規 or 編集画面表示
    // =============================

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {


        request.setCharacterEncoding("UTF-8");

        // ロール確認（管理者だけ）
        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("userRole") : null;
        if (role == null || !"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/scoremanager/main/index.jsp");
            return;
        }

        String surveyId = request.getParameter("id");
        Survey editingSurvey = null;
        String errMsg = null;

        if (surveyId != null && !surveyId.isEmpty()) {
            try {
                SurveyDao sDao = new SurveyDao();
                editingSurvey = sDao.get(surveyId);
                if (editingSurvey == null) {
                    errMsg = "指定されたアンケートが見つかりません。";
                }
            } catch (Exception e) {
                e.printStackTrace();
                errMsg = "アンケート情報の取得中にエラーが発生しました。";
            }
        }

        // 共通メソッドでフォーム表示
        showForm(request, response, editingSurvey, null, errMsg);
    }

    // =============================
    //  POST：保存処理
    // =============================

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("userRole") : null;
        if (role == null || !"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/scoremanager/main/index.jsp");
            return;
        }

        String surveyId   = request.getParameter("surveyId");
        String proposalId = request.getParameter("proposalId");
        String title      = request.getParameter("title");

        String[] qTypes  = request.getParameterValues("qType");
        String[] qLabels = request.getParameterValues("qLabel");

        List<String> errors = new ArrayList<>();

        if (proposalId == null || proposalId.isEmpty()) {
            errors.add("対象企画を選択してください。");
        }
        if (title == null || title.trim().isEmpty()) {
            errors.add("アンケートタイトルを入力してください。");
        }
        if (qTypes == null || qLabels == null || qTypes.length == 0) {
            errors.add("質問を1つ以上追加してください。");
        }

        // 入力内容を保持するための一時オブジェクト（エラー時用）
        Survey editingSurvey = new Survey();
        editingSurvey.setId(surveyId);
        editingSurvey.setProposalId(proposalId);
        editingSurvey.setTitle(title);

        // ★ エラーがあれば JSP に forward（doGet を再帰呼び出ししない）
        if (!errors.isEmpty()) {
            showForm(request, response, editingSurvey, errors, null);
            return;
        }

        try {
            // ID が空なら新規発番
            if (surveyId == null || surveyId.isEmpty()) {
                surveyId = "S" + System.currentTimeMillis();
            }

            Survey s = new Survey();
            s.setId(surveyId);
            s.setProposalId(proposalId);
            s.setTitle(title.trim());

            List<SurveyQuestion> qs = new ArrayList<>();
            for (int i = 0; i < qTypes.length; i++) {
                String type  = qTypes[i];
                String label = (i < qLabels.length) ? qLabels[i] : null;

                if (label == null || label.trim().isEmpty()) continue;

                SurveyQuestion q = new SurveyQuestion();
                q.setId("Q" + surveyId + "_" + (i + 1));
                q.setSurveyId(surveyId);
                q.setType(type);
                q.setLabel(label.trim());
                qs.add(q);
            }
            s.setQuestions(qs);

            SurveyDao dao = new SurveyDao();
            dao.save(s);

            // 保存完了 → 一覧へ
            response.sendRedirect(request.getContextPath() + "/scoremanager/main/survey_list");

        } catch (Exception e) {
            e.printStackTrace();
            errors.add("アンケートの保存中にエラーが発生しました。");
            showForm(request, response, editingSurvey, errors, null);
        }
    }
}
