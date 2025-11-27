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

import bean.Kikaku;          // ★ 企画 Bean
import bean.Survey;
import bean.SurveyQuestion;
import dao.KikakuDao;       // ★ 企画 Dao
import dao.SurveyDao;

@WebServlet("/scoremanager/main/survey_admin")
public class SurveyAdminAction extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String errMsg = null;
        Survey editingSurvey = null;

        try {
            // ---- 編集モード：id パラメータがあれば既存アンケートを取得 ----
            String id = request.getParameter("id");
            if (id != null && !id.isEmpty()) {
                SurveyDao sdao = new SurveyDao();
                editingSurvey = sdao.get(id);
                if (editingSurvey == null) {
                    errMsg = "指定されたアンケートが見つかりません。";
                }
            }

            // ---- 承認済み企画一覧取得（STATUS='承認' の KIKAKU）----
            KikakuDao kdao = new KikakuDao();
            List<Kikaku> approvedProposals = kdao.getApprovedKikaku();

            // JSP でプルダウン表示に使う
            request.setAttribute("approvedProposals", approvedProposals);

        } catch (Exception e) {
            e.printStackTrace();
            errMsg = "画面情報の取得中にエラーが発生しました。";
        }

        request.setAttribute("errMsg", errMsg);
        request.setAttribute("editingSurvey", editingSurvey);

        // 画面へフォワード
        RequestDispatcher rd =
            request.getRequestDispatcher("/scoremanager/main/survey_admin.jsp");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String errMsg = null;

        String surveyId   = request.getParameter("surveyId");  // hidden
        String proposalId = request.getParameter("proposal");  // KIKAKU.ID
        String title      = request.getParameter("title");

        String[] types  = request.getParameterValues("qType");
        String[] labels = request.getParameterValues("qLabel");

        Survey s = null;

        try {
            if (title != null && title.trim().length() > 0 &&
                types != null && labels != null && types.length == labels.length) {

                s = new Survey();

                // ★ 新規 or 編集判定：hidden の surveyId が空なら新規
                if (surveyId == null || surveyId.isEmpty()) {
                    surveyId = "S" + System.currentTimeMillis();
                }
                s.setId(surveyId);
                s.setTitle(title.trim());
                s.setProposalId(proposalId);   // KIKAKU.ID を紐づけ

                List<SurveyQuestion> qList = new ArrayList<>();

                for (int i = 0; i < types.length; i++) {
                    if (labels[i] == null || labels[i].trim().isEmpty()) {
                        continue;   // 質問文が空ならスキップ
                    }
                    SurveyQuestion q = new SurveyQuestion();
                    q.setId("Q" + surveyId + "_" + (i + 1));   // 適当なID
                    q.setSurveyId(surveyId);
                    q.setType(types[i]);
                    q.setLabel(labels[i].trim());
                    qList.add(q);
                }

                s.setQuestions(qList);

                SurveyDao dao = new SurveyDao();
                dao.save(s);   // INSERT or UPDATE + 質問再登録

                // 保存成功 → 一覧の Action にリダイレクト
                response.sendRedirect(
                    request.getContextPath() + "/scoremanager/main/survey_list");
                return;
            } else {
                errMsg = "タイトルと質問を正しく入力してください。";
            }

        } catch (Exception e) {
            e.printStackTrace();
            errMsg = "アンケートの保存に失敗しました。";
        }

        // ★ エラー時：再表示用に必要な情報を詰めて JSP へ forward
        try {
            KikakuDao kdao = new KikakuDao();
            List<Kikaku> approvedProposals = kdao.getApprovedKikaku();
            request.setAttribute("approvedProposals", approvedProposals);
        } catch (Exception e2) {
            e2.printStackTrace();
        }

        request.setAttribute("errMsg", errMsg);
        request.setAttribute("editingSurvey", s);  // 入力内容を残す

        RequestDispatcher rd =
            request.getRequestDispatcher("/scoremanager/main/survey_admin.jsp");
        rd.forward(request, response);
    }
}