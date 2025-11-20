
package scoremanager.main;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Map;
import bean.User;
import dao.MapDao;

@WebServlet("/scoremanager/main/map_list")
public class MapListAction extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // ユーザー認証チェック
            User user = (User) request.getSession().getAttribute("user");
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/scoremanager/main/login.jsp");
                return;
            }

            // 校内図データを全件取得
            MapDao dao = new MapDao();
            List<Map> mapList = dao.getAll();

            // リクエストスコープに設定
            request.setAttribute("mapList", mapList);

            // JSPにフォワード
            request.getRequestDispatcher("map_list.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "データ取得に失敗しました");
            try {
                request.getRequestDispatcher("map_list.jsp").forward(request, response);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
}