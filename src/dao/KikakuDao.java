package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
            statement = connection.prepareStatement("SELECT * FROM KIKAKU ORDER BY DATETIME DESC");
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
        } catch (Exception e) {
            throw e;
        } finally {
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
        return list;
    }

    public Kikaku get(String id) throws Exception {
        Kikaku kikaku = null;
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet rSet = null;

        try {
            connection = getConnection();
            statement = connection.prepareStatement("SELECT * FROM KIKAKU WHERE ID = ?");
            statement.setString(1, id);
            rSet = statement.executeQuery();

            if (rSet.next()) {
                kikaku = new Kikaku();
                kikaku.setId(rSet.getString("ID"));
                kikaku.setTitle(rSet.getString("TITLE"));
                kikaku.setDatetime(rSet.getString("DATETIME"));
                kikaku.setPlace(rSet.getString("PLACE"));
                kikaku.setTeacher(rSet.getString("TEACHER"));
                kikaku.setDescription(rSet.getString("DESCRIPTION"));
                kikaku.setStatus(rSet.getString("STATUS"));
                kikaku.setOwnerId(rSet.getString("OWNER_ID"));
            }
        } catch (Exception e) {
            throw e;
        } finally {
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
        return kikaku;
    }

    public boolean save(Kikaku kikaku) throws Exception {
        Connection connection = null;
        PreparedStatement statement = null;
        int count = 0;

        try {
            connection = getConnection();
            Kikaku old = get(kikaku.getId());
            if (old == null) {
                statement = connection.prepareStatement(
                    "INSERT INTO KIKAKU(ID, TITLE, DATETIME, PLACE, TEACHER, DESCRIPTION, STATUS, OWNER_ID) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
                statement.setString(1, kikaku.getId());
                statement.setString(2, kikaku.getTitle());
                statement.setString(3, kikaku.getDatetime());
                statement.setString(4, kikaku.getPlace());
                statement.setString(5, kikaku.getTeacher());
                statement.setString(6, kikaku.getDescription());
                statement.setString(7, kikaku.getStatus());
                statement.setString(8, kikaku.getOwnerId());
            } else {
                statement = connection.prepareStatement(
                    "UPDATE KIKAKU SET TITLE = ?, DATETIME = ?, PLACE = ?, TEACHER = ?, DESCRIPTION = ?, STATUS = ? WHERE ID = ?");
                statement.setString(1, kikaku.getTitle());
                statement.setString(2, kikaku.getDatetime());
                statement.setString(3, kikaku.getPlace());
                statement.setString(4, kikaku.getTeacher());
                statement.setString(5, kikaku.getDescription());
                statement.setString(6, kikaku.getStatus());
                statement.setString(7, kikaku.getId());
            }
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

    public boolean delete(String id) throws Exception {
        Connection connection = null;
        PreparedStatement statement = null;
        int count = 0;

        try {
            connection = getConnection();
            statement = connection.prepareStatement("DELETE FROM KIKAKU WHERE ID = ?");
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
}