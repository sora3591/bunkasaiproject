package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import bean.SurveyQuestion;

public class SurveyQuestionDao extends Dao {

    public List<SurveyQuestion> getBySurveyId(String surveyId) throws Exception {
        List<SurveyQuestion> list = new ArrayList<>();
        Connection connection = getConnection();
        PreparedStatement statement = null;

        try {
            statement = connection.prepareStatement("SELECT * FROM survey_question WHERE survey_id = ?");
            statement.setString(1, surveyId);
            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                SurveyQuestion q = new SurveyQuestion();
                q.setId(rs.getString("id"));
                q.setSurveyId(rs.getString("survey_id"));
                q.setType(rs.getString("type"));
                q.setLabel(rs.getString("label"));
                list.add(q);
            }
        } finally {
            if (statement != null) statement.close();
            if (connection != null) connection.close();
        }
        return list;
    }

    public boolean save(SurveyQuestion q) throws Exception {
        Connection connection = getConnection();
        PreparedStatement statement = null;
        int count = 0;

        try {
            statement = connection.prepareStatement(
                "INSERT INTO survey_question(id, survey_id, type, label) VALUES (?, ?, ?, ?)");
            statement.setString(1, q.getId());
            statement.setString(2, q.getSurveyId());
            statement.setString(3, q.getType());
            statement.setString(4, q.getLabel());
            count = statement.executeUpdate();
        } finally {
            if (statement != null) statement.close();
            if (connection != null) connection.close();
        }
        return count > 0;
    }

    public void deleteBySurveyId(String surveyId) throws Exception {
        Connection connection = getConnection();
        PreparedStatement statement = null;

        try {
            statement = connection.prepareStatement("DELETE FROM survey_question WHERE survey_id = ?");
            statement.setString(1, surveyId);
            statement.executeUpdate();
        } finally {
            if (statement != null) statement.close();
            if (connection != null) connection.close();
        }
    }
}