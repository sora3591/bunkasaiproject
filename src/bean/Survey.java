package bean;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class Survey implements Serializable {

    private static final long serialVersionUID = 1L;

    private String id;
    private String title;
    private String proposalId;

    // ★ ここ重要！Null防止のため初期化
    private List<SurveyQuestion> questions = new ArrayList<>();

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