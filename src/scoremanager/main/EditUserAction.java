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

@WebServlet("/scoremanager/main/edit_user")
public class EditUserAction extends HttpServlet {
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

            // ロールチェック（管理者のみ）
            User currentUser = (User) session.getAttribute("user");
            if (!"admin".equals(currentUser.getRole())) {
                response.sendRedirect(request.getContextPath() + "/scoremanager/main/index.jsp");
                return;
            }

            String id = request.getParameter("id");
            if (id == null || id.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/scoremanager/main/users_list");
                return;
            }

            // ユーザー情報を取得
            UserDao dao = new UserDao();
            User user = dao.get(id);

            if (user == null) {
                request.setAttribute("error", "ユーザーが見つかりません");
                request.getRequestDispatcher("/scoremanager/main/users_list").forward(request, response);
                return;
            }

            // ユーザー情報をリクエストに設定
            request.setAttribute("user", user);

            // JSPにフォワード
            request.getRequestDispatcher("/scoremanager/main/user_edit.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "ユーザー情報取得に失敗しました");
            try {
                request.getRequestDispatcher("/scoremanager/main/users_list").forward(request, response);
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

            // ロールチェック（管理者のみ）
            User currentUser = (User) session.getAttribute("user");
            if (!"admin".equals(currentUser.getRole())) {
                response.sendRedirect(request.getContextPath() + "/scoremanager/main/index.jsp");
                return;
            }

            // フォームから値を取得
            String id = request.getParameter("id");
            String name = request.getParameter("name");
            String role = request.getParameter("role");
            String classNum = request.getParameter("classNum");
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            // バリデーション
            if (id == null || id.isEmpty() || name == null || name.isEmpty()) {
                request.setAttribute("error", "必須項目を入力してください");
                UserDao dao = new UserDao();
                User user = dao.get(id);
                request.setAttribute("user", user);
                request.getRequestDispatcher("/scoremanager/main/user_edit.jsp").forward(request, response);
                return;
            }

            // ユーザー情報を更新
            UserDao dao = new UserDao();
            User user = dao.get(id);

            if (user == null) {
                request.setAttribute("error", "ユーザーが見つかりません");
                request.getRequestDispatcher("/scoremanager/main/users_list").forward(request, response);
                return;
            }

            // 更新値を設定
            user.setName(name);
            user.setRole(role != null ? role : "student");
            user.setClassNum(classNum);
            user.setEmail(email);

            // パスワードが入力されている場合のみ更新
            if (password != null && !password.isEmpty()) {
                user.setPassword(password);
            }

            // 保存
            boolean saved = dao.save(user);

            if (saved) {
                request.setAttribute("success", "ユーザー情報を更新しました");
                response.sendRedirect(request.getContextPath() + "/scoremanager/main/users_list");
            } else {
                request.setAttribute("error", "更新に失敗しました");
                request.setAttribute("user", user);
                request.getRequestDispatcher("/scoremanager/main/user_edit.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "更新処理中にエラーが発生しました");
            try {
                request.getRequestDispatcher("/scoremanager/main/user_edit.jsp").forward(request, response);
            } catch (ServletException | IOException e1) {
                e1.printStackTrace();
            }
        }
    }
}