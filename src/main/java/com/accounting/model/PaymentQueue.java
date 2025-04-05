package com.accounting.model;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PaymentQueue {
    private Long id;
    private String queueNumber;
    private String status;
    private String paymentType;
    private Double amount;
    private LocalDateTime timestamp;
    private String userId;
    private String description;

    // Constructor for mock data
    public PaymentQueue(String queueNumber, String status, String paymentType, Double amount) {
        this.queueNumber = queueNumber;
        this.status = status;
        this.paymentType = paymentType;
        this.amount = amount;
        this.timestamp = LocalDateTime.now();
    }
} 