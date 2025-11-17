package scoremanager.main;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Kikaku;
import bean.User;
import dao.KikakuDao;

@WebServlet("/scoremanager/main/kikaku_add")
public class KikakuAddAction extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        try {
            HttpSession session = request.getSession(false);

            // セッションチェック
            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/scoremanager/main/login.jsp");
                return;
            }

            // ロールチェック（学生または管理者）
            User currentUser = (User) session.getAttribute("user");
            if (!"student".equals(currentUser.getRole()) && !"admin".equals(currentUser.getRole())) {
                response.sendRedirect(request.getContextPath() + "/scoremanager/main/index.jsp");
                return;
            }

            // JSPにフォワード
            request.getRequestDispatcher("/scoremanager/main/kikaku_add.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "ページの読み込みに失敗しました");
            try {
                request.getRequestDispatcher("/scoremanager/main/kikaku_add.jsp").forward(request, response);
            } catch (ServletException | IOException e1) {
                e1.printStackTrace();
            }
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        try {
            HttpSession session = request.getSession(false);

            // セッションチェック
            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/scoremanager/main/login.jsp");
                return;
            }

            // ロールチェック（学生または管理者）
            User currentUser = (User) session.getAttribute("user");
            if (!"student".equals(currentUser.getRole()) && !"admin".equals(currentUser.getRole())) {
                response.sendRedirect(request.getContextPath() + "/scoremanager/main/index.jsp");
                return;
            }

            // フォームから値を取得
            String title = request.getParameter("title");
            String datetime = request.getParameter("datetime");
            String place = request.getParameter("place");
            String teacher = request.getParameter("teacher");
            String description = request.getParameter("description");

            // datetimeをTIMESTAMP形式に変換（YYYY-MM-DDTHH:mm → YYYY-MM-DD HH:mm:ss）
            if (datetime != null && !datetime.isEmpty()) {
                datetime = datetime.replace("T", " ") + ":00";
            } else {
                datetime = null;
            }

            // バリデーション
            if (title == null || title.trim().isEmpty()) {
                request.setAttribute("error", "タイトルは必須です");
                request.getRequestDispatcher("/scoremanager/main/kikaku_add.jsp").forward(request, response);
                return;
            }

            // 企画を作成
            Kikaku kikaku = new Kikaku();
            // IDをタイムスタンプベースで生成（20文字以内）
            String id = "K" + System.currentTimeMillis();
            if (id.length() > 20) {
                id = id.substring(0, 20);
            }
            kikaku.setId(id);
            kikaku.setTitle(title.trim());
            kikaku.setDatetime(datetime != null ? datetime : "");
            kikaku.setPlace(place != null ? place : "");
            kikaku.setTeacher(teacher != null ? teacher : "");
            kikaku.setDescription(description != null ? description : "");
            kikaku.setStatus("提出待ち");
            kikaku.setOwnerId(currentUser.getId());

            // 保存
            KikakuDao dao = new KikakuDao();
            boolean saved = dao.save(kikaku);

            if (saved) {
                response.sendRedirect(request.getContextPath() + "/scoremanager/main/kikaku_list");
            } else {
                request.setAttribute("error", "企画の提出に失敗しました");
                request.getRequestDispatcher("/scoremanager/main/kikaku_add.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "企画提出処理中にエラーが発生しました: " + e.getMessage());
            try {
                request.getRequestDispatcher("/scoremanager/main/kikaku_add.jsp").forward(request, response);
            } catch (ServletException | IOException e1) {
                e1.printStackTrace();
            }
        }
    }
}