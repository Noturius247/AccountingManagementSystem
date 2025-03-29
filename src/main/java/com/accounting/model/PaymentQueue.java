package com.accounting.model;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class PaymentQueue {
    private String queueNumber;
    private String status;
    private String paymentType;
    private double amount;
    private LocalDateTime timestamp;
    private String userId;
    private String description;

    public PaymentQueue() {
        this.timestamp = LocalDateTime.now();
    }

    public PaymentQueue(String paymentType, double amount, String userId) {
        this.paymentType = paymentType;
        this.amount = amount;
        this.userId = userId;
        this.timestamp = LocalDateTime.now();
    }
} 