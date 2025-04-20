package com.accounting.model;

import com.accounting.model.enums.TransactionStatus;
import com.accounting.model.enums.TransactionType;
import com.accounting.model.enums.Priority;
import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import java.util.Currency;
import lombok.ToString;
import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
@Table(name = "transactions")
@Data
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Transaction {
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "transaction_number", nullable = false, unique = true)
    private String transactionNumber;
    
    @Column(name = "receipt_id", unique = true)
    private String receiptId;
    
    @Column(nullable = false, precision = 19, scale = 2)
    private BigDecimal amount;
    
    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private TransactionStatus status;
    
    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private TransactionType type;
    
    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private Priority priority;
    
    @Column
    private String category;
    
    @Column(name = "sub_category")
    private String subCategory;
    
    @Column(name = "currency", length = 3)
    private String currency = "USD";
    
    @Column(name = "tax_amount", precision = 19, scale = 2)
    private BigDecimal taxAmount = BigDecimal.ZERO;
    
    @Column(length = 1000)
    private String notes;
    
    @Column(name = "is_recurring")
    private boolean isRecurring = false;
    
    @Column(name = "recurring_frequency")
    private String recurringFrequency;
    
    @Column(name = "next_due_date")
    private Date nextDueDate;
    
    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();
    
    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @Column(name = "processed_at")
    private LocalDateTime processedAt;
    
    @Column(name = "created_by")
    private String createdBy;
    
    @Column(name = "updated_by")
    private String updatedBy;
    
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id", nullable = false)
    @JsonIgnore
    private User user;
    
    @Transient
    private String statusColor;
    
    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
        if (updatedAt == null) {
            updatedAt = LocalDateTime.now();
        }
        if (currency == null) {
            currency = "USD";
        }
        setStatusColor();
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
    
    // Helper method to set status color based on status
    private void setStatusColor() {
        if (status == null) return;
        
        switch (status.toString()) {
            case "COMPLETED":
                this.status = TransactionStatus.COMPLETED;
                break;
            case "PENDING":
                this.status = TransactionStatus.PENDING;
                break;
            case "CANCELLED":
                this.status = TransactionStatus.CANCELLED;
                break;
            default:
                this.status = TransactionStatus.INFO;
        }
    }
    
    // Helper method to format amount with currency
    public String getFormattedAmount() {
        return amount != null ? String.format("%,.2f", amount) : null;
    }
    
    // Helper method to calculate total with tax
    public double calculateTotal() {
        return amount.doubleValue() + taxAmount.doubleValue();
    }
    
    // Helper method to check if transaction is overdue
    public boolean isOverdue() {
        return status == TransactionStatus.PENDING && 
               nextDueDate != null && 
               nextDueDate.before(new Date());
    }
    
    // Helper methods
    public double getTotalAmount() {
        return amount.doubleValue() + (taxAmount != null ? taxAmount.doubleValue() : 0.0);
    }

    public boolean isRecurring() {
        return isRecurring;
    }

    public boolean isCompleted() {
        return status == TransactionStatus.COMPLETED;
    }

    public boolean isPending() {
        return status == TransactionStatus.PENDING;
    }

    public String getFormattedCreatedAt() {
        return createdAt != null ? createdAt.format(DATE_FORMATTER) : null;
    }

    public String getFormattedUpdatedAt() {
        return updatedAt != null ? updatedAt.format(DATE_FORMATTER) : null;
    }

    public String getFormattedProcessedAt() {
        return processedAt != null ? processedAt.format(DATE_FORMATTER) : null;
    }

    public String getFormattedNextDueDate() {
        if (nextDueDate != null) {
            return nextDueDate.toInstant()
                .atZone(java.time.ZoneId.systemDefault())
                .toLocalDateTime()
                .format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        }
        return null;
    }

    public void setAmount(String amount) {
        if (amount != null) {
            this.amount = new BigDecimal(amount);
        }
    }

    public String getAmountAsString() {
        return amount != null ? amount.toString() : null;
    }

    public void setTaxAmount(String taxAmount) {
        if (taxAmount != null) {
            this.taxAmount = new BigDecimal(taxAmount);
        }
    }

    public String getFormattedTaxAmount() {
        return taxAmount != null ? String.format("%,.2f", taxAmount) : null;
    }

    public String getFormattedCurrency() {
        try {
            return currency != null ? Currency.getInstance(currency).getSymbol() : "USD";
        } catch (IllegalArgumentException e) {
            return "USD";
        }
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        if (currency != null) {
            try {
                Currency.getInstance(currency);
                this.currency = currency.toUpperCase();
            } catch (IllegalArgumentException e) {
                this.currency = "USD";
            }
        }
    }

    public String getFormattedTotalAmount() {
        return String.format("%,.2f", getTotalAmount());
    }

    // Explicit getter methods
    public Long getId() {
        return id;
    }

    public String getNotes() {
        return notes;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public TransactionStatus getStatus() {
        return status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    // Additional getter and setter methods
    public String getTransactionNumber() {
        return transactionNumber;
    }

    public void setTransactionNumber(String transactionNumber) {
        this.transactionNumber = transactionNumber;
    }

    public void setStatus(TransactionStatus status) {
        this.status = status;
    }

    public TransactionType getType() {
        return type;
    }

    public void setType(TransactionType type) {
        this.type = type;
    }

    public Priority getPriority() {
        return priority;
    }

    public void setPriority(Priority priority) {
        this.priority = priority;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getSubCategory() {
        return subCategory;
    }

    public void setSubCategory(String subCategory) {
        this.subCategory = subCategory;
    }

    public BigDecimal getTaxAmount() {
        return taxAmount;
    }

    public void setTaxAmount(BigDecimal taxAmount) {
        this.taxAmount = taxAmount;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getRecurringFrequency() {
        return recurringFrequency;
    }

    public void setRecurringFrequency(String recurringFrequency) {
        this.recurringFrequency = recurringFrequency;
    }

    public Date getNextDueDate() {
        return nextDueDate;
    }

    public void setNextDueDate(Date nextDueDate) {
        this.nextDueDate = nextDueDate;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Override
    public String toString() {
        return "Transaction{" +
            "id=" + id +
            ", transactionNumber='" + transactionNumber + '\'' +
            ", receiptId='" + receiptId + '\'' +
            ", amount=" + amount +
            ", status=" + status +
            ", type=" + type +
            ", priority=" + priority +
            ", category='" + category + '\'' +
            ", subCategory='" + subCategory + '\'' +
            ", currency='" + currency + '\'' +
            ", taxAmount=" + taxAmount +
            ", notes='" + notes + '\'' +
            ", isRecurring=" + isRecurring +
            ", recurringFrequency='" + recurringFrequency + '\'' +
            ", nextDueDate=" + nextDueDate +
            ", createdAt=" + createdAt +
            ", updatedAt=" + updatedAt +
            ", processedAt=" + processedAt +
            ", createdBy='" + createdBy + '\'' +
            ", updatedBy='" + updatedBy + '\'' +
            '}';
    }
} 