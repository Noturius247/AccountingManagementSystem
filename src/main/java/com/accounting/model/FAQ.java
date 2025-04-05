package com.accounting.model;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class FAQ {
    private String id;
    private String question;
    private String answer;
    private String category;
    private int priority;
    private boolean active;
} 