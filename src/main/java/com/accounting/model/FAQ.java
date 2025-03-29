package com.accounting.model;

import lombok.Data;

@Data
public class FAQ {
    private String id;
    private String question;
    private String answer;
    private String category;
    private int priority;
    private boolean active;
} 