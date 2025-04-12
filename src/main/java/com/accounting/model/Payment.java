package com.accounting.model;

import com.accounting.model.enums.PaymentStatus;
import com.accounting.model.enums.PaymentType;
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Currency;

@Entity
@Table(name = "payments")
@Data
@NoArgsConstructor
public class Payment {
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String description;

    @Column(nullable = false, precision = 19, scale = 2)
    private BigDecimal amount;

    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private PaymentStatus status;

    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private PaymentType type;

    @Column(name = "user_username", nullable = false)
    private String userUsername;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "processed_at")
    private LocalDateTime processedAt;

    @Column(precision = 19, scale = 2)
    private BigDecimal taxAmount;

    @Column(length = 3)
    private String currency;

    @Column(name = "payment_method")
    private String paymentMethod;

    @Column(name = "transaction_reference")
    private String transactionReference;

    @Column(name = "queue_number", unique = true)
    private String queueNumber;

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
        if (status == null) {
            status = PaymentStatus.PENDING;
        }
        if (currency == null || currency.isEmpty()) {
            currency = "USD";
        }
    }

    public String getFormattedCreatedAt() {
        return createdAt != null ? createdAt.format(DATE_FORMATTER) : "";
    }

    public String getFormattedUpdatedAt() {
        return updatedAt != null ? updatedAt.format(DATE_FORMATTER) : "";
    }

    public String getFormattedProcessedAt() {
        return processedAt != null ? processedAt.format(DATE_FORMATTER) : "";
    }

    public void setAmount(String amount) {
        if (amount != null) {
            try {
                this.amount = new BigDecimal(amount.replaceAll("[^0-9.]", ""));
            } catch (NumberFormatException e) {
                this.amount = BigDecimal.ZERO;
            }
        }
    }

    public void setTaxAmount(String taxAmount) {
        if (taxAmount != null) {
            try {
                this.taxAmount = new BigDecimal(taxAmount.replaceAll("[^0-9.]", ""));
            } catch (NumberFormatException e) {
                this.taxAmount = BigDecimal.ZERO;
            }
        }
    }

    public String getFormattedAmount() {
        return amount != null ? String.format("%,.2f", amount) : "0.00";
    }

    public String getFormattedTaxAmount() {
        return taxAmount != null ? String.format("%,.2f", taxAmount) : "0.00";
    }

    public String getCurrencySymbol() {
        try {
            return Currency.getInstance(currency).getSymbol();
        } catch (IllegalArgumentException e) {
            return "USD";
        }
    }

    public BigDecimal getTotalAmount() {
        BigDecimal total = amount != null ? amount : BigDecimal.ZERO;
        if (taxAmount != null) {
            total = total.add(taxAmount);
        }
        return total;
    }

    public String getFormattedTotalAmount() {
        return String.format("%,.2f", getTotalAmount());
    }

    public String getFormattedPaymentMethod() {
        return paymentMethod != null ? paymentMethod.toLowerCase().replace("_", " ") : null;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod != null ? paymentMethod.toUpperCase().replace(" ", "_") : null;
    }

    public String getStatusColor() {
        return status != null ? status.toString().toLowerCase() : "pending";
    }

    public String getTypeIcon() {
        return type != null ? type.toString().toLowerCase() : "payment";
    }

    public Long getId() {
        return id;
    }

    public String getDescription() {
        return description;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
} 