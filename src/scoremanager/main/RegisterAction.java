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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String role = request.getParameter("role");
        String classNum = request.getParameter("classNum");
        String email = request.getParameter("email");

        if (id == null || id.isEmpty() || name == null || name.isEmpty()) {
            request.setAttribute("error", "IDと氏名は必須です");
            request.getRequestDispatcher("/scoremanager/main/register.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setId(id);
        user.setName(name);
        user.setRole(role);
        user.setClassNum(classNum);
        user.setEmail(email);
        user.setPassword("1234");

        try {
            UserDao dao = new UserDao();
            if (dao.get(id) != null) {
                request.setAttribute("error", "このIDは既に登録されています");
                request.getRequestDispatcher("/scoremanager/main/register.jsp").forward(request, response);
                return;
            }
            dao.save(user);
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "登録に失敗しました");
            request.getRequestDispatcher("/scoremanager/main/register.jsp").forward(request, response);
        }
    }
}