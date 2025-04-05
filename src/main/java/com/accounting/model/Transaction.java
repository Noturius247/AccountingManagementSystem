package com.accounting.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Entity
@Table(name = "transactions")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Transaction {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String type;
    private Double amount;
    private String description;
    
    @Column(name = "timestamp")
    private LocalDateTime timestamp;
    
    private String status;
    
    @Transient
    private String statusColor;
    
    // User relationship
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
    
    // Additional fields for transaction details
    private String category;
    private String subCategory;
    private String currency;
    private double taxAmount;
    private double totalAmount;
    
    @Column(length = 1000)
    private String notes;
    
    private boolean isRecurring;
    private String recurringFrequency;
    private LocalDateTime nextDueDate;
    
    // Audit fields
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @Column(name = "created_by", updatable = false)
    private String createdBy;
    
    @Column(name = "updated_by")
    private String updatedBy;
    
    @PrePersist
    protected void onCreate() {
        this.timestamp = LocalDateTime.now();
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
    
    // Helper method to set status color based on status
    public void setStatusColor() {
        if (status == null) return;
        
        switch (status.toLowerCase()) {
            case "completed":
                this.statusColor = "success";
                break;
            case "pending":
                this.statusColor = "warning";
                break;
            case "failed":
                this.statusColor = "danger";
                break;
            case "cancelled":
                this.statusColor = "secondary";
                break;
            default:
                this.statusColor = "info";
        }
    }
    
    // Helper method to format amount with currency
    public String getFormattedAmount() {
        return String.format("%s %.2f", currency, amount);
    }
    
    // Helper method to calculate total with tax
    public double calculateTotal() {
        return amount + taxAmount;
    }
    
    // Helper method to check if transaction is overdue
    public boolean isOverdue() {
        if (nextDueDate != null) {
            return LocalDateTime.now().isAfter(nextDueDate);
        }
        return false;
    }
} 