package com.accounting.model;

import java.time.LocalDateTime;
import lombok.Data;

@Data
public class Transaction {
    private Long id;
    private String type;
    private Double amount;
    private String description;
    private LocalDateTime date;
    private String status;
    private String statusColor;
    
    // Additional fields for transaction details
    private String category;
    private String subCategory;
    private String currency;
    private double taxAmount;
    private double totalAmount;
    private String notes;
    private boolean isRecurring;
    private String recurringFrequency;
    private LocalDateTime nextDueDate;
    
    // Audit fields
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String createdBy;
    private String updatedBy;
    
    // Constructor
    public Transaction() {
        this.date = LocalDateTime.now();
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }
    
    // Helper method to set status color based on status
    public void setStatusColor() {
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