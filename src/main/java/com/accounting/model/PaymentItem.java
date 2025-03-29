package com.accounting.model;

import lombok.Data;

@Data
public class PaymentItem {
    private String id;
    private String name;
    private String description;
    private double amount;
    private String category;
    private boolean active;
    private String paymentType;
} 