package scoremanager.main;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.User;
import dao.UserDao;

@WebServlet("/scoremanager/main/delete_user_action")
public class DeleteUserAction extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession();

        // セッションチェック
        Object userObj = session.getAttribute("user");
        if (userObj == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\":\"ログインしてください\"}");
            return;
        }

        User currentUser = (User) userObj;

        // 管理者権限チェック
        if (!"admin".equals(currentUser.getRole())) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write("{\"error\":\"管理者権限がありません\"}");
            return;
        }

        // パラメータから削除対象ユーザーIDを取得
        String userId = request.getParameter("id");

        if (userId == null || userId.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"ユーザーIDが指定されていません\"}");
            return;
        }

        try {
            UserDao dao = new UserDao();
            boolean result = dao.delete(userId);

            if (result) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("{\"success\":true}");
                System.out.println("=== User Deleted: " + userId + " ===");
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\":\"ユーザーが見つかりません\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"削除に失敗しました: " + e.getMessage() + "\"}");
        }
    }
}