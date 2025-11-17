package scoremanager.main;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.User;
import dao.UserDao;

@WebServlet("/scoremanager/main/users_list")
public class UsersListAction extends HttpServlet {
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

            // ユーザーロールチェック（管理者のみ）
            User user = (User) session.getAttribute("user");
            if (!"admin".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/scoremanager/main/index.jsp");
                return;
            }

            // ユーザー一覧を取得
            UserDao dao = new UserDao();
            List<User> users = dao.getAll();

            // リクエストに設定
            request.setAttribute("users", users);

            // JSPにフォワード
            request.getRequestDispatcher("/scoremanager/main/users_list.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "ユーザー一覧取得に失敗しました");
            try {
                request.getRequestDispatcher("/scoremanager/main/users_list.jsp").forward(request, response);
            } catch (ServletException | IOException e1) {
                e1.printStackTrace();
            }
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}