package bean;

import java.io.Serializable;

public class Map implements Serializable {
    private String id;
    private String name;
    private String img; // Base64形式の画像データ（DataURL）

    public Map() {}

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getImg() {
        return img;
    }

    public void setImg(String img) {
        this.img = img;
    }
}