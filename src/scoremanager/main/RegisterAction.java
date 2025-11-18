package scoremanager.main;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.User;
import dao.UserDao;

@WebServlet("/scoremanager/main/register")
public class RegisterAction extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        try {
            // 登録ページを表示
            request.getRequestDispatcher("/scoremanager/main/register.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "ページの読み込みに失敗しました");
            try {
                request.getRequestDispatcher("/scoremanager/main/register.jsp").forward(request, response);
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
                request.getRequestDispatcher("/scoremanager/main/register.jsp").forward(request, response);
                return;
            }

            // ユーザーIDが既に存在するかチェック
            UserDao dao = new UserDao();
            User existingUser = dao.get(id.trim());
            if (existingUser != null) {
                request.setAttribute("error", "このIDは既に登録されています");
                request.getRequestDispatcher("/scoremanager/main/register.jsp").forward(request, response);
                return;
            }

            // 新規ユーザーを作成
            User user = new User();
            user.setId(id.trim());
            user.setName(name.trim());
            user.setPassword(password.trim());
            user.setRole(role != null ? role : "student");
            user.setClassNum(classNum != null ? classNum.trim() : "");
            user.setEmail(email != null ? email.trim() : "");

            // 保存
            boolean saved = dao.save(user);

            if (saved) {
                // 登録成功時はログインページへリダイレクト
                response.sendRedirect(request.getContextPath() + "/scoremanager/main/login.jsp");
            } else {
                request.setAttribute("error", "ユーザー登録に失敗しました");
                request.getRequestDispatcher("/scoremanager/main/register.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "登録処理中にエラーが発生しました: " + e.getMessage());
            try {
                request.getRequestDispatcher("/scoremanager/main/register.jsp").forward(request, response);
            } catch (ServletException | IOException e1) {
                e1.printStackTrace();
            }
        }
    }
}