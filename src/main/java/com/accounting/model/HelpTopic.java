package com.accounting.model;

import lombok.Data;
import java.util.List;

@Data
public class HelpTopic {
    private String id;
    private String title;
    private String content;
    private String category;
    private List<String> relatedTopics;
    private int priority;
    private boolean active;
} 