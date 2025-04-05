package com.accounting.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.time.LocalDateTime;

@Entity
@Table(name = "payment_queue")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PaymentQueue {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(unique = true)
    private String queueNumber;
    
    @Column(nullable = false)
    private String status;
    
    @Column(name = "payment_type")
    private String paymentType;
    
    private Double amount;
    
    @Column(nullable = false)
    private LocalDateTime timestamp;
    
    @Column(name = "user_id")
    private Long userId;
    
    @Column(length = 1000)
    private String description;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", insertable = false, updatable = false)
    private User user;

    // Constructor for mock data
    public PaymentQueue(String queueNumber, String status, String paymentType, Double amount) {
        this.queueNumber = queueNumber;
        this.status = status;
        this.paymentType = paymentType;
        this.amount = amount;
        this.timestamp = LocalDateTime.now();
    }
    
    @PrePersist
    protected void onCreate() {
        if (this.timestamp == null) {
            this.timestamp = LocalDateTime.now();
        }
    }
} 