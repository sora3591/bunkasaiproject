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

import bean.Survey;
import dao.SurveyDao;

/**
 * アンケート一覧表示用アクション
 *  - DB からアンケート一覧を取得
 *  - ロール（admin / student）を判定
 *  - 結果を request に詰めて survey_list.jsp へフォワード
 */
@WebServlet("/scoremanager/main/survey_list")
public class SurveyListAction extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        List<Survey> surveys = null;
        String role = "student";   // デフォルト学生

        try {
            // --- ロール取得（セッションから） ---
            HttpSession session = request.getSession(false);
            if (session != null) {
                Object r = session.getAttribute("userRole");
                if (r instanceof String && ((String) r).length() > 0) {
                    role = (String) r;
                }
            }

            // --- DB からアンケート一覧取得 ---
            SurveyDao dao = new SurveyDao();
            surveys = dao.getAll();
            if (surveys == null) {
                surveys = new ArrayList<>();
            }

        } catch (Exception e) {
            e.printStackTrace();
            // 必要ならエラーメッセージを JSP に渡す
            request.setAttribute("error", "アンケート一覧の取得中にエラーが発生しました。");
            if (surveys == null) {
                surveys = new ArrayList<>();
            }
        }

        // JSP で使う属性をセット
        request.setAttribute("surveys", surveys);
        request.setAttribute("role", role);

        // 画面へフォワード
        RequestDispatcher rd =
            request.getRequestDispatcher("/scoremanager/main/survey_list.jsp");
        rd.forward(request, response);
    }

    // POST で来ても同じ処理
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}