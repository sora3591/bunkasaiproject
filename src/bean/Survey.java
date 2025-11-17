package bean;

import java.io.Serializable;
import java.util.List;

public class Survey implements Serializable {
    private String id;
    private String title;
    private String proposalId;
    private List<SurveyQuestion> questions;

    public Survey() {}

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getProposalId() { return proposalId; }
    public void setProposalId(String proposalId) { this.proposalId = proposalId; }

    public List<SurveyQuestion> getQuestions() { return questions; }
    public void setQuestions(List<SurveyQuestion> questions) { this.questions = questions; }
}