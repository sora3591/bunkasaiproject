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

@WebServlet("/scoremanager/main/user_add")
public class UserAddAction extends HttpServlet {
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

            // JSPにフォワード
            request.getRequestDispatcher("/scoremanager/main/user_add.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "ページの読み込みに失敗しました");
            try {
                request.getRequestDispatcher("/scoremanager/main/user_add.jsp").forward(request, response);
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
            String password = request.getParameter("password");
            String role = request.getParameter("role");
            String classNum = request.getParameter("classNum");
            String email = request.getParameter("email");

            // バリデーション
            if (id == null || id.trim().isEmpty() ||
                name == null || name.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
                request.setAttribute("error", "ID、氏名、パスワードは必須です");
                request.getRequestDispatcher("/scoremanager/main/user_add.jsp").forward(request, response);
                return;
            }

            // ユーザーIDが既に存在するかチェック
            UserDao dao = new UserDao();
            User existingUser = dao.get(id.trim());
            if (existingUser != null) {
                request.setAttribute("error", "このユーザーIDは既に使用されています");
                request.getRequestDispatcher("/scoremanager/main/user_add.jsp").forward(request, response);
                return;
            }

            // 新規ユーザーを作成
            User newUser = new User();
            newUser.setId(id.trim());
            newUser.setName(name.trim());
            newUser.setPassword(password.trim());
            newUser.setRole(role != null ? role : "student");
            newUser.setClassNum(classNum != null ? classNum.trim() : "");
            newUser.setEmail(email != null ? email.trim() : "");

            // 保存
            boolean saved = dao.save(newUser);

            if (saved) {
                response.sendRedirect(request.getContextPath() + "/scoremanager/main/users_list.jsp");
            } else {
                request.setAttribute("error", "ユーザーの追加に失敗しました");
                request.getRequestDispatcher("/scoremanager/main/user_add.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "ユーザー追加処理中にエラーが発生しました");
            try {
                request.getRequestDispatcher("/scoremanager/main/user_add.jsp").forward(request, response);
            } catch (ServletException | IOException e1) {
                e1.printStackTrace();
            }
        }
    }
}