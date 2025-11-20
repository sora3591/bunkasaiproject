package scoremanager.main;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Kikaku;
import bean.User;
import dao.KikakuDao;

@WebServlet("/scoremanager/main/kikaku_list")
public class KikakuListAction extends HttpServlet {
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

            User user = (User) session.getAttribute("user");
            System.out.println("=== KikakuListAction START ===");
            System.out.println("User: " + user.getId() + ", Role: " + user.getRole());

            // 企画一覧を取得
            KikakuDao dao = new KikakuDao();
            List<Kikaku> kikakuList = null;

            try {
                // 学生の場合は自分の企画のみ、管理者は全企画を表示
                if ("student".equals(user.getRole())) {
                    kikakuList = dao.getByOwnerId(user.getId());
                    System.out.println("Student - Retrieved " + kikakuList.size() + " proposals");
                } else {
                    kikakuList = dao.getAll();
                    System.out.println("Admin - Retrieved " + kikakuList.size() + " proposals");
                }
            } catch (Exception e) {
                System.out.println("Error retrieving proposals: " + e.getMessage());
                e.printStackTrace();
                kikakuList = new java.util.ArrayList<>();
            }

            // リクエストに設定
            request.setAttribute("kikakuList", kikakuList);

            System.out.println("=== KikakuListAction END ===");

            // JSPにフォワード
            request.getRequestDispatcher("/scoremanager/main/kikaku_list.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("KikakuListAction Exception: " + e.getMessage());
            request.setAttribute("error", "企画一覧の取得に失敗しました: " + e.getMessage());
            try {
                request.getRequestDispatcher("/scoremanager/main/kikaku_list.jsp").forward(request, response);
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