package com.accounting.model;

import java.util.Date;
import lombok.Data;

@Data
public class Transaction {
    private Long id;
    private String type;
    private double amount;
    private String status;
    private Date date;
    private String description;
    private Long userId;
    private String referenceNumber;
    private String paymentMethod;
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
    private Date nextDueDate;
    
    // Audit fields
    private Date createdAt;
    private Date updatedAt;
    private String createdBy;
    private String updatedBy;
    
    // Constructor
    public Transaction() {
        this.date = new Date();
        this.createdAt = new Date();
        this.updatedAt = new Date();
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
            return new Date().after(nextDueDate);
        }
        return false;
    }
} 