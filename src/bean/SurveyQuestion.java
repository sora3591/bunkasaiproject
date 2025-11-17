package bean;

import java.io.Serializable;

public class SurveyQuestion implements Serializable {
    private String id;
    private String surveyId;
    private String type;
    private String label;

    public SurveyQuestion() {}

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getSurveyId() { return surveyId; }
    public void setSurveyId(String surveyId) { this.surveyId = surveyId; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getLabel() { return label; }
    public void setLabel(String label) { this.label = label; }
}