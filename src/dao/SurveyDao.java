package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import bean.Survey;
import bean.SurveyQuestion;

public class SurveyDao extends Dao {
    private String baseSql = "SELECT * FROM survey";

    public Survey get(String id) throws Exception {
        Survey s = new Survey();
        Connection connection = getConnection();
        PreparedStatement statement = null;

        try {
            statement = connection.prepareStatement("SELECT * FROM survey WHERE id = ?");
            statement.setString(1, id);
            ResultSet rs = statement.executeQuery();

            if (rs.next()) {
                s.setId(rs.getString("id"));
                s.setTitle(rs.getString("title"));
                s.setProposalId(rs.getString("proposal_id"));
                s.setQuestions(new SurveyQuestionDao().getBySurveyId(s.getId()));
            } else {
                s = null;
            }
        } finally {
            if (statement != null) statement.close();
            if (connection != null) connection.close();
        }
        return s;
    }

    public List<Survey> getAll() throws Exception {
        List<Survey> list = new ArrayList<>();
        Connection connection = getConnection();
        PreparedStatement statement = null;
        ResultSet rs = null;

        try {
            statement = connection.prepareStatement(baseSql + " ORDER BY id ASC");
            rs = statement.executeQuery();
            while (rs.next()) {
                Survey s = new Survey();
                s.setId(rs.getString("id"));
                s.setTitle(rs.getString("title"));
                s.setProposalId(rs.getString("proposal_id"));
                s.setQuestions(new SurveyQuestionDao().getBySurveyId(s.getId()));
                list.add(s);
            }
        } finally {
            if (statement != null) statement.close();
            if (connection != null) connection.close();
        }
        return list;
    }

    public boolean save(Survey s) throws Exception {
        Connection connection = getConnection();
        PreparedStatement statement = null;
        int count = 0;

        try {
            Survey old = get(s.getId());
            if (old == null) {
                statement = connection.prepareStatement("INSERT INTO survey(id, title, proposal_id) VALUES (?, ?, ?)");
                statement.setString(1, s.getId());
                statement.setString(2, s.getTitle());
                statement.setString(3, s.getProposalId());
            } else {
                statement = connection.prepareStatement("UPDATE survey SET title=?, proposal_id=? WHERE id=?");
                statement.setString(1, s.getTitle());
                statement.setString(2, s.getProposalId());
                statement.setString(3, s.getId());
            }
            count = statement.executeUpdate();

            // 質問保存
            SurveyQuestionDao qDao = new SurveyQuestionDao();
            qDao.deleteBySurveyId(s.getId());
            for (SurveyQuestion q : s.getQuestions()) {
                q.setSurveyId(s.getId());
                qDao.save(q);
            }
        } finally {
            if (statement != null) statement.close();
            if (connection != null) connection.close();
        }
        return count > 0;
    }
}