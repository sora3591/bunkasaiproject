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
                session.setAttribute("user", user);
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