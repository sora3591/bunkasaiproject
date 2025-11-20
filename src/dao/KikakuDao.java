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

    public List<Kikaku> getAll() throws Exception {
        List<Kikaku> list = new ArrayList<>();
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet rSet = null;

        try {
            connection = getConnection();
            statement = connection.prepareStatement("SELECT * FROM PUBLIC.KIKAKU ORDER BY DATETIME DESC");
            rSet = statement.executeQuery();

            while (rSet.next()) {
                list.add(createKikakuFromResultSet(rSet));
            }
        } catch (Exception e) {
            throw e;
        } finally {
            closeResources(rSet, statement, connection);
        }
        return list;
    }

    public Kikaku get(String id) throws Exception {
        Kikaku kikaku = null;
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet rSet = null;

        try {
            connection = getConnection();
            statement = connection.prepareStatement("SELECT * FROM PUBLIC.KIKAKU WHERE ID = ?");
            statement.setString(1, id);
            rSet = statement.executeQuery();

            if (rSet.next()) {
                kikaku = createKikakuFromResultSet(rSet);
            }
        } catch (Exception e) {
            throw e;
        } finally {
            closeResources(rSet, statement, connection);
        }
        return kikaku;
    }

    public List<Kikaku> getByOwnerId(String ownerId) throws Exception {
        List<Kikaku> list = new ArrayList<>();
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet rSet = null;

        try {
            connection = getConnection();
            statement = connection.prepareStatement("SELECT * FROM PUBLIC.KIKAKU WHERE OWNER_ID = ? ORDER BY DATETIME DESC");
            statement.setString(1, ownerId);
            rSet = statement.executeQuery();

            while (rSet.next()) {
                list.add(createKikakuFromResultSet(rSet));
            }
        } catch (Exception e) {
            throw e;
        } finally {
            closeResources(rSet, statement, connection);
        }
        return list;
    }

    public boolean save(Kikaku kikaku) throws Exception {
        Connection connection = null;
        PreparedStatement checkStatement = null;
        PreparedStatement statement = null;
        ResultSet rSet = null;
        int count = 0;

        try {
            connection = getConnection();

            // 同じコネクションで既存確認
            checkStatement = connection.prepareStatement("SELECT ID FROM PUBLIC.KIKAKU WHERE ID = ?");
            checkStatement.setString(1, kikaku.getId());
            rSet = checkStatement.executeQuery();
            boolean exists = rSet.next();
            rSet.close();
            checkStatement.close();

            // DATETIMEをTimestamp型に変換
            Timestamp datetimeValue = null;
            if (kikaku.getDatetime() != null && !kikaku.getDatetime().isEmpty()) {
                try {
                    datetimeValue = Timestamp.valueOf(kikaku.getDatetime());
                } catch (Exception e) {
                    datetimeValue = null;
                }
            }

            if (!exists) {
                // INSERT
                statement = connection.prepareStatement(
                    "INSERT INTO PUBLIC.KIKAKU(ID, TITLE, DATETIME, PLACE, TEACHER, DESCRIPTION, STATUS, OWNER_ID) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
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
                // UPDATE
                statement = connection.prepareStatement(
                    "UPDATE PUBLIC.KIKAKU SET TITLE = ?, DATETIME = ?, PLACE = ?, TEACHER = ?, DESCRIPTION = ?, STATUS = ? WHERE ID = ?");
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

        } catch (Exception e) {
            System.out.println("KikakuDao.save() Exception: " + e.getMessage());
            e.printStackTrace();
            throw e;
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

    public boolean delete(String id) throws Exception {
        Connection connection = null;
        PreparedStatement statement = null;
        int count = 0;

        try {
            connection = getConnection();
            statement = connection.prepareStatement("DELETE FROM PUBLIC.KIKAKU WHERE ID = ?");
            statement.setString(1, id);
            count = statement.executeUpdate();
        } catch (Exception e) {
            throw e;
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