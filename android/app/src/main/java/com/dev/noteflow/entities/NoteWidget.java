package com.dev.noteflow.entities;

import android.graphics.Color;

import java.util.HashMap;

public class NoteWidget {
    public String id;
    public String title;
    public String content;
    public int contentColor;
    public int backgroundColor;

    public NoteWidget(String id, String title, String content, int contentColor, int backgroundColor) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.contentColor = contentColor;
        this.backgroundColor = backgroundColor;
    }

    public static NoteWidget fromMap(HashMap<String, Object> hashMap) {
        final String id = (String) hashMap.get("id");
        final String title = (String) hashMap.get("title");
        final String content = (String) hashMap.get("content");
        final int contentColor = Color.parseColor((String) hashMap.get("contentColor"));
        final int backgroundColor = Color.parseColor((String) hashMap.get("backgroundColor"));

        return new NoteWidget(id, title, content, contentColor, backgroundColor);
    }
}
