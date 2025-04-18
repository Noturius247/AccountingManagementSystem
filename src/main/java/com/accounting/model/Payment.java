package com.accounting.model;

import com.accounting.model.enums.PaymentStatus;
import com.accounting.model.enums.PaymentType;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import com.fasterxml.jackson.annotation.JsonIgnore;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Currency;

@Entity
@Table(name = "payments")
@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Payment {
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, precision = 19, scale = 2)
    private BigDecimal amount;

    @Column(name = "payment_number", nullable = false, unique = true)
    private String paymentNumber;

    @Column(name = "transaction_reference")
    private String transactionReference;

    @Column(name = "payment_method")
    private String paymentMethod;

    @Column(nullable = false)
    private String description;

    @Column(name = "tax_amount", precision = 19, scale = 2)
    private BigDecimal taxAmount;

    @Column(length = 3)
    private String currency;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    @JsonIgnore
    private User user;

    @Column(name = "queue_number")
    private String queueNumber;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private PaymentStatus paymentStatus = PaymentStatus.PENDING;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private PaymentType type;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "processed_at")
    private LocalDateTime processedAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
        if (updatedAt == null) {
            updatedAt = LocalDateTime.now();
        }
        if (paymentNumber == null || paymentNumber.isEmpty()) {
            String datePart = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
            String randomPart = String.format("%05d", (int) (Math.random() * 100000));
            paymentNumber = String.format("PAY-%s-%s", datePart, randomPart);
        }
        if (paymentStatus == null) {
            paymentStatus = PaymentStatus.PENDING;
        }
        if (currency == null || currency.isEmpty()) {
            currency = "PHP";
        }
        if (taxAmount == null) {
            taxAmount = BigDecimal.ZERO;
        }
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
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
        this.amount = new BigDecimal(amount);
    }

    public void setTaxAmount(String taxAmount) {
        this.taxAmount = new BigDecimal(taxAmount);
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
        return paymentStatus != null ? paymentStatus.toString().toLowerCase() : "pending";
    }

    public String getTypeIcon() {
        return type != null ? type.toString().toLowerCase() : "payment";
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public PaymentType getType() {
        return type;
    }

    public void setType(PaymentType type) {
        this.type = type;
    }

    public PaymentStatus getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(PaymentStatus paymentStatus) {
        this.paymentStatus = paymentStatus;
    }
} 