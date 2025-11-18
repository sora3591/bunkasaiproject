package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import bean.User;

public class UserDao extends Dao {
	private String baseSql = "SELECT * FROM USERS";

	public User get(String id) throws Exception {
		User user = null;
		Connection connection = null;
		PreparedStatement statement = null;
		ResultSet rSet = null;

		try {
			connection = getConnection();
			statement = connection.prepareStatement("SELECT * FROM USERS WHERE ID = ?");
			statement.setString(1, id);
			rSet = statement.executeQuery();

			if (rSet.next()) {
				user = new User();
				user.setId(rSet.getString("ID"));
				user.setPassword(rSet.getString("PASSWORD"));
				user.setRole(rSet.getString("ROLE"));
				user.setName(rSet.getString("NAME"));
				user.setClassNum(rSet.getString("CLASS_NUM"));
				user.setEmail(rSet.getString("EMAIL"));
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
		return user;
	}

	// 内部用：同じ接続を使う get メソッド
	private User get(Connection connection, String id) throws Exception {
		User user = null;
		PreparedStatement statement = null;
		ResultSet rSet = null;

		try {
			statement = connection.prepareStatement("SELECT * FROM USERS WHERE ID = ?");
			statement.setString(1, id);
			rSet = statement.executeQuery();

			if (rSet.next()) {
				user = new User();
				user.setId(rSet.getString("ID"));
				user.setPassword(rSet.getString("PASSWORD"));
				user.setRole(rSet.getString("ROLE"));
				user.setName(rSet.getString("NAME"));
				user.setClassNum(rSet.getString("CLASS_NUM"));
				user.setEmail(rSet.getString("EMAIL"));
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
		}
		return user;
	}

	public List<User> getAll() throws Exception {
		List<User> list = new ArrayList<>();
		Connection connection = null;
		PreparedStatement statement = null;
		ResultSet rSet = null;

		try {
			connection = getConnection();
			statement = connection.prepareStatement(baseSql + " ORDER BY ID ASC");
			rSet = statement.executeQuery();

			while (rSet.next()) {
				User user = new User();
				user.setId(rSet.getString("ID"));
				user.setPassword(rSet.getString("PASSWORD"));
				user.setRole(rSet.getString("ROLE"));
				user.setName(rSet.getString("NAME"));
				user.setClassNum(rSet.getString("CLASS_NUM"));
				user.setEmail(rSet.getString("EMAIL"));
				list.add(user);
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

	public User getByIdAndPassword(String id, String password) throws Exception {
		User user = null;
		Connection connection = null;
		PreparedStatement statement = null;
		ResultSet rSet = null;

		try {
			connection = getConnection();
			statement = connection.prepareStatement("SELECT * FROM USERS WHERE ID = ? AND PASSWORD = ?");
			statement.setString(1, id);
			statement.setString(2, password);
			rSet = statement.executeQuery();

			if (rSet.next()) {
				user = new User();
				user.setId(rSet.getString("ID"));
				user.setPassword(rSet.getString("PASSWORD"));
				user.setRole(rSet.getString("ROLE"));
				user.setName(rSet.getString("NAME"));
				user.setClassNum(rSet.getString("CLASS_NUM"));
				user.setEmail(rSet.getString("EMAIL"));
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
		return user;
	}

	public boolean save(User user) throws Exception {
		Connection connection = null;
		PreparedStatement statement = null;
		int count = 0;

		try {
			connection = getConnection();
			// 同じ接続を使って既存ユーザーをチェック
			User old = get(connection, user.getId());
			if (old == null) {
				statement = connection.prepareStatement(
					"INSERT INTO USERS(ID, PASSWORD, ROLE, NAME, CLASS_NUM, EMAIL) VALUES (?, ?, ?, ?, ?, ?)");
				statement.setString(1, user.getId());
				statement.setString(2, user.getPassword());
				statement.setString(3, user.getRole());
				statement.setString(4, user.getName());
				statement.setString(5, user.getClassNum());
				statement.setString(6, user.getEmail());
			} else {
				statement = connection.prepareStatement(
					"UPDATE USERS SET PASSWORD = ?, ROLE = ?, NAME = ?, CLASS_NUM = ?, EMAIL = ? WHERE ID = ?");
				statement.setString(1, user.getPassword());
				statement.setString(2, user.getRole());
				statement.setString(3, user.getName());
				statement.setString(4, user.getClassNum());
				statement.setString(5, user.getEmail());
				statement.setString(6, user.getId());
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

//以下のメソッドをUserDao.javaの最後に追加してください

	public boolean delete(String id) throws Exception {
		Connection connection = null;
		PreparedStatement statement = null;
		int count = 0;

		try {
			connection = getConnection();
			statement = connection.prepareStatement("DELETE FROM USERS WHERE ID = ?");
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