package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import bean.SurveyAnswer;

public class SurveyAnswerDao extends Dao {

    // 回答を1件INSERT
    public boolean save(SurveyAnswer a) throws Exception {
        Connection con = getConnection();
        PreparedStatement st = null;
        int cnt = 0;

        try {
            st = con.prepareStatement(
                "INSERT INTO SURVEY_ANSWER (ID, SURVEY_ID, QUESTION_ID, USER_ID, ANSWER, CREATED_AT) " +
                "VALUES (?,?,?,?,?, CURRENT_TIMESTAMP)"
            );
            st.setString(1, a.getId());
            st.setString(2, a.getSurveyId());
            st.setString(3, a.getQuestionId());
            st.setString(4, a.getUserId());
            st.setString(5, a.getAnswer());
            cnt = st.executeUpdate();
        } finally {
            if (st != null) st.close();
            if (con != null) con.close();
        }
        return cnt > 0;
    }

    // 指定アンケートの全回答を取得（将来「結果を見る」で使う）
    public List<SurveyAnswer> getBySurveyId(String surveyId) throws Exception {
        List<SurveyAnswer> list = new ArrayList<>();

        Connection con = getConnection();
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            st = con.prepareStatement(
                "SELECT * FROM SURVEY_ANSWER WHERE SURVEY_ID = ? ORDER BY CREATED_AT"
            );
            st.setString(1, surveyId);
            rs = st.executeQuery();

            while (rs.next()) {
                SurveyAnswer a = new SurveyAnswer();
                a.setId(rs.getString("ID"));
                a.setSurveyId(rs.getString("SURVEY_ID"));
                a.setQuestionId(rs.getString("QUESTION_ID"));
                a.setUserId(rs.getString("USER_ID"));
                a.setAnswer(rs.getString("ANSWER"));
                a.setCreatedAt(rs.getTimestamp("CREATED_AT"));
                list.add(a);
            }
        } finally {
            if (rs != null) rs.close();
            if (st != null) st.close();
            if (con != null) con.close();
        }
        return list;
    }
}