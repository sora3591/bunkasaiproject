
package scoremanager.main;

import java.io.IOException;
import java.io.InputStream;
import java.util.Base64;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import bean.Map;
import bean.User;
import dao.MapDao;

@WebServlet("/scoremanager/main/map_add")
@MultipartConfig(
    maxFileSize = 5 * 1024 * 1024,      // 5MB
    maxRequestSize = 10 * 1024 * 1024,  // 10MB
    fileSizeThreshold = 1024 * 1024     // 1MB
)
public class MapAddAction extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("===== MapAddAction: GET開始 =====");
        // GETリクエストの場合は追加画面を表示
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/scoremanager/main/login.jsp");
            return;
        }

        request.getRequestDispatcher("map_add.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("===== MapAddAction: POST開始 =====");
        request.setCharacterEncoding("UTF-8");

        try {
            // ユーザー認証チェック
            User user = (User) request.getSession().getAttribute("user");
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/scoremanager/main/login.jsp");
                return;
            }

            // 管理者チェック
            if (!"admin".equals(user.getRole())) {
                request.setAttribute("error", "権限がありません");
                request.getRequestDispatcher("map_add.jsp").forward(request, response);
                return;
            }

            // フォームデータ取得
            String name = request.getParameter("name");
            Part imagePart = request.getPart("image");

            // バリデーション
            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("error", "名称を入力してください");
                request.getRequestDispatcher("map_add.jsp").forward(request, response);
                return;
            }

            // 画像データの処理
            String imageData = null;
            if (imagePart != null && imagePart.getSize() > 0) {
                // 画像をBase64エンコード（Java 8対応）
                InputStream inputStream = imagePart.getInputStream();

                // InputStreamをbyte配列に変換
                java.io.ByteArrayOutputStream buffer = new java.io.ByteArrayOutputStream();
                int nRead;
                byte[] data = new byte[1024];
                while ((nRead = inputStream.read(data, 0, data.length)) != -1) {
                    buffer.write(data, 0, nRead);
                }
                buffer.flush();
                byte[] bytes = buffer.toByteArray();

                imageData = Base64.getEncoder().encodeToString(bytes);

                // MIMEタイプを取得してプレフィックスを追加
                String contentType = imagePart.getContentType();
                imageData = "data:" + contentType + ";base64," + imageData;
            }

            // ユニークなIDを生成（短縮版：20文字以内）
            String uniqueId = "m" + System.currentTimeMillis();

            // Mapオブジェクト作成
            Map map = new Map();
            map.setId(uniqueId);
            map.setName(name.trim());
            map.setImg(imageData);

            // データベースに保存
            MapDao dao = new MapDao();
            boolean success = dao.save(map);

            if (success) {
                // 成功時は一覧画面にリダイレクト
                response.sendRedirect(request.getContextPath() + "/scoremanager/main/map_list.jsp");
            } else {
                request.setAttribute("error", "保存に失敗しました");
                request.getRequestDispatcher("map_add.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "エラーが発生しました: " + e.getMessage());
            request.getRequestDispatcher("map_add.jsp").forward(request, response);
        }
    }
}

