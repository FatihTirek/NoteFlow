package com.dev.noteflow.entities;

import android.graphics.Color;

import java.util.HashMap;

public class SingleNoteWidget {
    public String id;
    public String title;
    public String content;
    public int contentCIndex;
    public int backgroundCIndex;

    public SingleNoteWidget(String id, String title, String content, int contentCIndex, int backgroundCIndex) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.contentCIndex = contentCIndex;
        this.backgroundCIndex = backgroundCIndex;
    }

    public static SingleNoteWidget fromMap(HashMap<String, Object> hashMap) {
        final String id = (String) hashMap.get("id");
        final String title = (String) hashMap.get("title");
        final String content = (String) hashMap.get("content");
        final int contentCIndex = (int) hashMap.get("contentCIndex");
        final int backgroundCIndex = (int) hashMap.get("backgroundCIndex");

        return new SingleNoteWidget(id, title, content, contentCIndex, backgroundCIndex);
    }
}
