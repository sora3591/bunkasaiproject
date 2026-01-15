package scoremanager.main;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Kikaku;
import bean.User;
import dao.KikakuDao;

@WebServlet("/scoremanager/main/kikaku_edit")
public class KikakuEditAction extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        HttpSession session = request.getSession(false);
        // セッションチェック
        if (session == null || session.getAttribute("user") == null) {
            try {
                response.sendRedirect(request.getContextPath() + "/scoremanager/main/login.jsp");
            } catch (Exception e) {
                e.printStackTrace();
            }
            return;
        }

        try {
            User user = (User) session.getAttribute("user");
            System.out.println("=== KikakuEditAction doGet START ===");
            System.out.println("User: " + user.getId() + ", Role: " + user.getRole());

            String id = request.getParameter("id");
            System.out.println("Requested kikaku id: " + id);

            if (id == null || id.isEmpty()) {
                request.setAttribute("error", "企画IDが指定されていません");
                request.getRequestDispatcher("/scoremanager/main/kikaku_list.jsp")
                    .forward(request, response);
                return;
            }

            KikakuDao dao = new KikakuDao();
            Kikaku kikaku = dao.get(id);

            if (kikaku == null) {
                request.setAttribute("error", "企画が見つかりません");
                request.getRequestDispatcher("/scoremanager/main/kikaku_list.jsp")
                    .forward(request, response);
                return;
            }

            System.out.println("Retrieved kikaku: " + kikaku.getTitle() + ", Owner: " + kikaku.getOwnerId());

            // 学生が自分の企画以外を編集しようとした場合はエラー
            if ("student".equals(user.getRole()) && !kikaku.getOwnerId().equals(user.getId())) {
                System.out.println("Access denied: Student trying to edit other's proposal");
                request.setAttribute("error", "権限がありません");
                request.getRequestDispatcher("/scoremanager/main/kikaku_list.jsp")
                    .forward(request, response);
                return;
            }

            request.setAttribute("kikaku", kikaku);
            System.out.println("=== KikakuEditAction doGet END ===");
            request.getRequestDispatcher("/scoremanager/main/kikaku_edit.jsp")
                .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("KikakuEditAction doGet Exception: " + e.getMessage());
            request.setAttribute("error", "エラーが発生しました: " + e.getMessage());
            try {
                request.getRequestDispatcher("/scoremanager/main/kikaku_list.jsp")
                    .forward(request, response);
            } catch (ServletException | IOException e1) {
                e1.printStackTrace();
            }
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        HttpSession session = request.getSession(false);
        // セッションチェック
        if (session == null || session.getAttribute("user") == null) {
            try {
                response.sendRedirect(request.getContextPath() + "/scoremanager/main/login.jsp");
            } catch (Exception e) {
                e.printStackTrace();
            }
            return;
        }

        try {
            User user = (User) session.getAttribute("user");
            System.out.println("=== KikakuEditAction doPost START ===");
            System.out.println("User: " + user.getId() + ", Role: " + user.getRole());

            String id = request.getParameter("id");
            String title = request.getParameter("title");
            String datetime = request.getParameter("datetime");
            String place = request.getParameter("place");
            String description = request.getParameter("description");

            System.out.println("Parameters - id: " + id + ", title: " + title +
                ", datetime: " + datetime + ", place: " + place);

            // バリデーション
            if (id == null || id.isEmpty()) {
                request.setAttribute("error", "企画IDが指定されていません");
                request.getRequestDispatcher("/scoremanager/main/kikaku_list.jsp")
                    .forward(request, response);
                return;
            }

            if (title == null || title.isEmpty() || datetime == null || datetime.isEmpty() ||
                place == null || place.isEmpty()) {
                request.setAttribute("error", "必須項目を入力してください");
                request.setAttribute("kikaku", getKikakuFromRequest(id));
                request.getRequestDispatcher("/scoremanager/main/kikaku_edit.jsp")
                    .forward(request, response);
                return;
            }

            KikakuDao dao = new KikakuDao();
            Kikaku kikaku = dao.get(id);

            if (kikaku == null) {
                request.setAttribute("error", "企画が見つかりません");
                request.getRequestDispatcher("/scoremanager/main/kikaku_list.jsp")
                    .forward(request, response);
                return;
            }

            System.out.println("Retrieved kikaku for update: " + kikaku.getTitle());
            System.out.println("Original datetime: " + kikaku.getDatetime());
            System.out.println("New datetime from form: " + datetime);

            // 学生が自分の企画以外を編集しようとした場合はエラー
            if ("student".equals(user.getRole()) && !kikaku.getOwnerId().equals(user.getId())) {
                System.out.println("Access denied: Student trying to edit other's proposal");
                request.setAttribute("error", "権限がありません");
                request.getRequestDispatcher("/scoremanager/main/kikaku_list.jsp")
                    .forward(request, response);
                return;
            }

            // 企画情報を更新
            kikaku.setTitle(title);
            // datetime-localの形式を正しく処理（yyyy-MM-ddTHH:mm形式）
            String formattedDatetime = datetime.replace("T", " ") + ":00";
            kikaku.setDatetime(formattedDatetime);
            kikaku.setPlace(place);
            kikaku.setDescription(description);
            kikaku.setStatus("承認待ち"); // ステータスをリセット

            System.out.println("Formatted datetime: " + formattedDatetime);

            boolean success = dao.update(kikaku);
            System.out.println("Update result: " + success);

            if (success) {
                System.out.println("Kikaku updated successfully");
                System.out.println("=== KikakuEditAction doPost END ===");
                response.sendRedirect(request.getContextPath() + "/scoremanager/main/kikaku_list");
            } else {
                System.out.println("Update failed");
                request.setAttribute("error", "企画の更新に失敗しました");
                request.setAttribute("kikaku", kikaku);
                request.getRequestDispatcher("/scoremanager/main/kikaku_edit.jsp")
                    .forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("KikakuEditAction doPost Exception: " + e.getMessage());
            request.setAttribute("error", "エラーが発生しました: " + e.getMessage());
            try {
                request.getRequestDispatcher("/scoremanager/main/kikaku_list.jsp")
                    .forward(request, response);
            } catch (ServletException | IOException e1) {
                e1.printStackTrace();
            }
        }
    }

    private Kikaku getKikakuFromRequest(String id) {
        try {
            KikakuDao dao = new KikakuDao();
            return dao.get(id);
        } catch (Exception e) {
            return null;
        }
    }
}