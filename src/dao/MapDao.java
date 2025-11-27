package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import bean.Map;

public class MapDao extends Dao {
    private String baseSql = "SELECT * FROM map";

    public Map get(String id) throws Exception {
        Map map = new Map();
        Connection connection = getConnection();
        PreparedStatement statement = null;

        try {
            statement = connection.prepareStatement("SELECT * FROM map WHERE id = ?");
            statement.setString(1, id);
            ResultSet rs = statement.executeQuery();

            if (rs.next()) {
                map.setId(rs.getString("id"));
                map.setName(rs.getString("name"));
                map.setImg(rs.getString("img"));
            } else {
                map = null;
            }
        } finally {
            if (statement != null) statement.close();
            if (connection != null) connection.close();
        }
        return map;
    }

    public List<Map> getAll() throws Exception {
        List<Map> list = new ArrayList<>();
        Connection connection = getConnection();
        PreparedStatement statement = null;
        ResultSet rs = null;

        try {
            statement = connection.prepareStatement(baseSql + " ORDER BY id ASC");
            rs = statement.executeQuery();
            while (rs.next()) {
                Map map = new Map();
                map.setId(rs.getString("id"));
                map.setName(rs.getString("name"));
                map.setImg(rs.getString("img"));
                list.add(map);
            }
        } finally {
            if (statement != null) statement.close();
            if (connection != null) connection.close();
        }
        return list;
    }

    public boolean save(Map map) throws Exception {
        Connection connection = getConnection();
        PreparedStatement statement = null;
        int count = 0;

        try {
            Map old = get(map.getId());
            if (old == null) {
                statement = connection.prepareStatement(
                    "INSERT INTO map(id, name, img) VALUES (?, ?, ?)");
                statement.setString(1, map.getId());
                statement.setString(2, map.getName());
                statement.setString(3, map.getImg());
            } else {
                statement = connection.prepareStatement(
                    "UPDATE map SET name = ?, img = ? WHERE id = ?");
                statement.setString(1, map.getName());
                statement.setString(2, map.getImg());
                statement.setString(3, map.getId());
            }
            count = statement.executeUpdate();
        } finally {
            if (statement != null) statement.close();
            if (connection != null) connection.close();
        }
        return count > 0;
    }


public boolean delete(String id) throws Exception {
    Connection connection = getConnection();
    PreparedStatement statement = null;
    int count = 0;
    try {
        statement = connection.prepareStatement("DELETE FROM map WHERE id = ?");
        statement.setString(1, id);
        count = statement.executeUpdate();
    } finally {
        if (statement != null) statement.close();
        if (connection != null) connection.close();
    }
    return count > 0;
}
}