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

@WebServlet("/scoremanager/main/kikaku_detail")
public class KikakuDetailAction extends HttpServlet {
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

            // 企画IDを取得
            String id = request.getParameter("id");
            if (id == null || id.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/scoremanager/main/kikaku_list.jsp");
                return;
            }

            // 企画情報を取得
            KikakuDao dao = new KikakuDao();
            Kikaku kikaku = dao.get(id);

            if (kikaku == null) {
                request.setAttribute("error", "企画が見つかりません");
                request.getRequestDispatcher("/scoremanager/main/kikaku_list.jsp").forward(request, response);
                return;
            }

            // リクエストに設定
            request.setAttribute("kikaku", kikaku);

            // JSPにフォワード
            request.getRequestDispatcher("/scoremanager/main/kikaku_detail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "企画詳細の取得に失敗しました");
            try {
                request.getRequestDispatcher("/scoremanager/main/kikaku_list.jsp").forward(request, response);
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

            User currentUser = (User) session.getAttribute("user");

            // 管理者のみステータス更新可能
            if (!"admin".equals(currentUser.getRole())) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return;
            }

            String id = request.getParameter("id");
            String status = request.getParameter("status");
            String adminComment = request.getParameter("adminComment");

            if (id == null || id.isEmpty() || status == null || status.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

            // 企画情報を取得
            KikakuDao dao = new KikakuDao();
            Kikaku kikaku = dao.get(id);

            if (kikaku == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            // ステータスを更新
            kikaku.setStatus(status);
            // adminCommentフィールドがあれば設定（Beanに追加が必要）

            // 保存
            boolean saved = dao.save(kikaku);

            if (saved) {
                response.sendRedirect(request.getContextPath() + "/scoremanager/main/kikaku_detail?id=" + id);
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}