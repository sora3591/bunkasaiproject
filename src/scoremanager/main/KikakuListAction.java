package scoremanager.main;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Kikaku;
import bean.User;
import dao.KikakuDao;

@WebServlet("/scoremanager/main/kikaku_list")
public class KikakuListAction extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        try {
            User user = (User) request.getSession().getAttribute("user");

            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            KikakuDao dao = new KikakuDao();
            List<Kikaku> allKikaku = dao.getAll();

            // ユーザーに応じてフィルタリング
            List<Kikaku> filteredKikaku = new java.util.ArrayList<>();
            for (Kikaku k : allKikaku) {
                if ("admin".equals(user.getRole()) || k.getOwnerId().equals(user.getId())) {
                    filteredKikaku.add(k);
                }
            }

            request.setAttribute("kikakuList", filteredKikaku);
            request.getRequestDispatcher("kikaku_list.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "データ取得に失敗しました");
            try {
                request.getRequestDispatcher("kikaku_list.jsp").forward(request, response);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
}