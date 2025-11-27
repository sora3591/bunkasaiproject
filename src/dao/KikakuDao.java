package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import bean.Kikaku;

public class KikakuDao extends Dao {

    // すべての企画を取得
    public List<Kikaku> getAll() throws Exception {
        List<Kikaku> list = new ArrayList<>();
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet rSet = null;

        try {
            connection = getConnection();
            statement = connection.prepareStatement(
                "SELECT * FROM PUBLIC.KIKAKU ORDER BY DATETIME DESC"
            );
            rSet = statement.executeQuery();

            while (rSet.next()) {
                Kikaku kikaku = new Kikaku();
                kikaku.setId(rSet.getString("ID"));
                kikaku.setTitle(rSet.getString("TITLE"));
                kikaku.setDatetime(rSet.getString("DATETIME"));
                kikaku.setPlace(rSet.getString("PLACE"));
                kikaku.setTeacher(rSet.getString("TEACHER"));
                kikaku.setDescription(rSet.getString("DESCRIPTION"));
                kikaku.setStatus(rSet.getString("STATUS"));
                kikaku.setOwnerId(rSet.getString("OWNER_ID"));
                list.add(kikaku);
            }
        } finally {
            closeResources(rSet, statement, connection);
        }
        return list;
    }

    // ID 指定で 1 件取得
    public Kikaku get(String id) throws Exception {
        Kikaku kikaku = null;
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet rSet = null;

        try {
            connection = getConnection();
            statement = connection.prepareStatement(
                "SELECT * FROM PUBLIC.KIKAKU WHERE ID = ?"
            );
            statement.setString(1, id);
            rSet = statement.executeQuery();

            if (rSet.next()) {
                kikaku = createKikakuFromResultSet(rSet);
            }
        } finally {
            closeResources(rSet, statement, connection);
        }
        return kikaku;
    }

    // オーナー(学生)ごとの企画一覧
    public List<Kikaku> getByOwnerId(String ownerId) throws Exception {
        List<Kikaku> list = new ArrayList<>();
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet rSet = null;

        try {
            connection = getConnection();
            statement = connection.prepareStatement(
                "SELECT * FROM PUBLIC.KIKAKU WHERE OWNER_ID = ? ORDER BY DATETIME DESC"
            );
            statement.setString(1, ownerId);
            rSet = statement.executeQuery();

            while (rSet.next()) {
                list.add(createKikakuFromResultSet(rSet));
            }
        } finally {
            closeResources(rSet, statement, connection);
        }
        return list;
    }

    // ★ 新規追加：承認済み企画だけを取得（アンケート用のプルダウンで使用）
    public List<Kikaku> getApprovedKikaku() throws Exception {
        List<Kikaku> list = new ArrayList<>();
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet rs = null;

        try {
            connection = getConnection();
            // STATUS が『承認』の企画だけ
            statement = connection.prepareStatement(
                "SELECT * FROM PUBLIC.KIKAKU WHERE STATUS = '承認' ORDER BY DATETIME DESC"
            );
            rs = statement.executeQuery();

            while (rs.next()) {
                list.add(createKikakuFromResultSet(rs));
            }
        } finally {
            closeResources(rs, statement, connection);
        }

        return list;
    }

    // INSERT / UPDATE
    public boolean save(Kikaku kikaku) throws Exception {
        Connection connection = null;
        PreparedStatement statement = null;
        int count = 0;

        try {
            connection = getConnection();
            Kikaku old = get(kikaku.getId());

            // DATETIME を Timestamp 型に変換
            Timestamp datetimeValue = null;
            if (kikaku.getDatetime() != null && !kikaku.getDatetime().isEmpty()) {
                try {
                    datetimeValue = Timestamp.valueOf(kikaku.getDatetime());
                } catch (Exception e) {
                    // フォーマットが合わない場合は null
                    datetimeValue = null;
                }
            }

            if (old == null) {
                statement = connection.prepareStatement(
                    "INSERT INTO PUBLIC.KIKAKU"
                    + " (ID, TITLE, DATETIME, PLACE, TEACHER, DESCRIPTION, STATUS, OWNER_ID)"
                    + " VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
                );
                statement.setString(1, kikaku.getId());
                statement.setString(2, kikaku.getTitle());
                if (datetimeValue != null) {
                    statement.setTimestamp(3, datetimeValue);
                } else {
                    statement.setNull(3, java.sql.Types.TIMESTAMP);
                }
                statement.setString(4, kikaku.getPlace());
                statement.setString(5, kikaku.getTeacher());
                statement.setString(6, kikaku.getDescription());
                statement.setString(7, kikaku.getStatus());
                statement.setString(8, kikaku.getOwnerId());
            } else {
                statement = connection.prepareStatement(
                    "UPDATE PUBLIC.KIKAKU"
                    + " SET TITLE = ?, DATETIME = ?, PLACE = ?, TEACHER = ?,"
                    + " DESCRIPTION = ?, STATUS = ?"
                    + " WHERE ID = ?"
                );
                statement.setString(1, kikaku.getTitle());
                if (datetimeValue != null) {
                    statement.setTimestamp(2, datetimeValue);
                } else {
                    statement.setNull(2, java.sql.Types.TIMESTAMP);
                }
                statement.setString(3, kikaku.getPlace());
                statement.setString(4, kikaku.getTeacher());
                statement.setString(5, kikaku.getDescription());
                statement.setString(6, kikaku.getStatus());
                statement.setString(7, kikaku.getId());
            }
            count = statement.executeUpdate();
        } finally {
            if (statement != null) {
                try {
                    statement.close();
                } catch (SQLException sqle) {
                    // ignore
                }
            }
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException sqle) {
                    // ignore
                }
            }
        }
        return count > 0;
    }

    // 削除
    public boolean delete(String id) throws Exception {
        Connection connection = null;
        PreparedStatement statement = null;
        int count = 0;

        try {
            connection = getConnection();
            statement = connection.prepareStatement(
                "DELETE FROM PUBLIC.KIKAKU WHERE ID = ?"
            );
            statement.setString(1, id);
            count = statement.executeUpdate();
        } finally {
            if (statement != null) {
                try {
                    statement.close();
                } catch (SQLException sqle) {
                    // ignore
                }
            }
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException sqle) {
                    // ignore
                }
            }
        }
        return count > 0;
    }

    // ResultSet から Kikaku を 1 件作る共通処理
    private Kikaku createKikakuFromResultSet(ResultSet rSet) throws SQLException {
        Kikaku kikaku = new Kikaku();
        kikaku.setId(rSet.getString("ID"));
        kikaku.setTitle(rSet.getString("TITLE"));
        kikaku.setDatetime(rSet.getString("DATETIME"));
        kikaku.setPlace(rSet.getString("PLACE"));
        kikaku.setTeacher(rSet.getString("TEACHER"));
        kikaku.setDescription(rSet.getString("DESCRIPTION"));
        kikaku.setStatus(rSet.getString("STATUS"));
        kikaku.setOwnerId(rSet.getString("OWNER_ID"));
        return kikaku;
    }

    // リソースクローズ共通処理
    private void closeResources(ResultSet rSet, PreparedStatement statement, Connection connection) {
        if (rSet != null) {
            try {
                rSet.close();
            } catch (SQLException sqle) {
                // ignore
            }
        }
        if (statement != null) {
            try {
                statement.close();
            } catch (SQLException sqle) {
                // ignore
            }
        }
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException sqle) {
                // ignore
            }
        }
    }
}