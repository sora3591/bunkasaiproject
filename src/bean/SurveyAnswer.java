package bean;

import java.io.Serializable;
import java.sql.Timestamp;

public class SurveyAnswer implements Serializable {

    private static final long serialVersionUID = 1L;

    private String id;
    private String surveyId;
    private String questionId;
    private String userId;
    private String answer;
    private Timestamp createdAt;

    public SurveyAnswer() {}

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getSurveyId() { return surveyId; }
    public void setSurveyId(String surveyId) { this.surveyId = surveyId; }

    public String getQuestionId() { return questionId; }
    public void setQuestionId(String questionId) { this.questionId = questionId; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getAnswer() { return answer; }
    public void setAnswer(String answer) { this.answer = answer; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}