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

@WebServlet("/scoremanager/main/login")
public class LoginAction extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String id = request.getParameter("id");
        String password = request.getParameter("password");

        try {
            UserDao dao = new UserDao();
            User user = dao.getByIdAndPassword(id, password);

            if (user != null) {
                // ログイン成功
                HttpSession session = request.getSession();

                // ① 原来只有这一行
                session.setAttribute("user", user);

                // ② ★★ 新增：把用户ID单独塞进 session，问卷用这个 ★★
                //    User bean 里大概率是 getId()，如果是 getUserId() 就改成那个
                session.setAttribute("userId", user.getId());

                // （如果你有角色信息的话，也可以在这里顺便塞：session.setAttribute("userRole", user.getRole());）

                // ③ 跳转到主页
                response.sendRedirect(request.getContextPath() + "/scoremanager/main/index.jsp");
            } else {
                // ログイン失敗
                request.setAttribute("error", "ユーザーID またはパスワードが間違っています");
                request.getRequestDispatcher("/scoremanager/main/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "ログインに失敗しました");
            request.getRequestDispatcher("/scoremanager/main/login.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // GETリクエストはlogin.jspにフォワード
        request.getRequestDispatcher("/scoremanager/main/login.jsp").forward(request, response);
    }
}