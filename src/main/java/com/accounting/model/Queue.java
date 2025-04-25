package com.accounting.model;

import com.accounting.model.enums.QueueStatus;
import com.accounting.model.enums.QueueType;
import com.accounting.model.enums.ReceiptPreference;
import com.accounting.model.enums.PaymentType;
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.time.Duration;
import java.util.Date;
import java.math.BigDecimal;

@Entity
@Table(name = "queues")
@Data
@NoArgsConstructor
public class Queue {
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "queue_number", nullable = false, length = 255)
    private String queueNumber;

    @Column(name = "student_id", nullable = false, length = 20)
    private String studentId;

    @Column(name = "kiosk_session_id", length = 255)
    private String kioskSessionId;

    @Column(name = "public_identifier", length = 255)
    private String publicIdentifier;

    @Column(name = "kiosk_terminal_id", length = 255)
    private String kioskTerminalId;

    @Enumerated(EnumType.STRING)
    @Column(name = "receipt_preference")
    private ReceiptPreference receiptPreference;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private QueueStatus status = QueueStatus.PENDING;

    @Column(name = "payment_id", length = 20)
    private Long paymentId;

    @Column(name = "payment_number", length = 50)
    private String paymentNumber;

    @Column(name = "receipt_url", length = 255)
    private String receiptUrl;

    @Column(name = "amount", precision = 38, scale = 2)
    private BigDecimal amount;

    @Column(name = "description", length = 255)
    private String description;

    @Column(name = "error_message", columnDefinition = "TEXT")
    private String errorMessage;

    @Column(name = "payment_gateway_response", columnDefinition = "TEXT")
    private String paymentGatewayResponse;

    @Column(name = "schedule", length = 50)
    private String schedule;

    @Column(name = "schedule_id", length = 50)
    private String scheduleId;

    @Column(name = "type")
    private PaymentType type;

    @Column(name = "currency", length = 3)
    private String currency = "USD";

    @Column(name = "tax_amount", precision = 19, scale = 2)
    private BigDecimal taxAmount = BigDecimal.ZERO;

    @Column(name = "notes", columnDefinition = "TEXT")
    private String notes;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "processed_at")
    private LocalDateTime processedAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @Column(name = "payment_method", length = 255)
    private String paymentMethod;

    @Column(name = "transaction_reference", length = 255)
    private String transactionReference;

    @Column(name = "user_username", length = 255)
    private String userUsername;

    @Column(name = "position")
    private Integer position;

    @Column(name = "estimated_wait_time")
    private Integer estimatedWaitTime;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    // Helper methods
    public boolean isActive() {
        return status == QueueStatus.PENDING || status == QueueStatus.PROCESSED;
    }

    public boolean isProcessed() {
        return status == QueueStatus.PROCESSED || status == QueueStatus.REFUNDED;
    }

    public void markAsProcessed() {
        this.status = QueueStatus.PROCESSED;
        this.processedAt = LocalDateTime.now();
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getQueueNumber() {
        return queueNumber;
    }

    public void setQueueNumber(String queueNumber) {
        this.queueNumber = queueNumber;
    }

    public String getStudentId() {
        return studentId;
    }

    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }

    public QueueStatus getStatus() {
        return status;
    }

    public void setStatus(QueueStatus status) {
        this.status = status;
    }

    public Long getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(Long paymentId) {
        this.paymentId = paymentId;
    }

    public String getPaymentNumber() {
        return paymentNumber;
    }

    public void setPaymentNumber(String paymentNumber) {
        this.paymentNumber = paymentNumber;
    }

    public String getReceiptUrl() {
        return receiptUrl;
    }

    public void setReceiptUrl(String receiptUrl) {
        this.receiptUrl = receiptUrl;
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

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    public String getPaymentGatewayResponse() {
        return paymentGatewayResponse;
    }

    public void setPaymentGatewayResponse(String paymentGatewayResponse) {
        this.paymentGatewayResponse = paymentGatewayResponse;
    }

    public String getSchedule() {
        return schedule;
    }

    public void setSchedule(String schedule) {
        this.schedule = schedule;
    }

    public String getScheduleId() {
        return scheduleId;
    }

    public void setScheduleId(String scheduleId) {
        this.scheduleId = scheduleId;
    }

    public PaymentType getType() {
        return type;
    }

    public void setType(PaymentType type) {
        this.type = type;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public BigDecimal getTaxAmount() {
        return taxAmount;
    }

    public void setTaxAmount(BigDecimal taxAmount) {
        this.taxAmount = taxAmount;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public LocalDateTime getProcessedAt() {
        return processedAt;
    }

    public void setProcessedAt(LocalDateTime processedAt) {
        this.processedAt = processedAt;
    }

    public Long getUserId() {
        return user.getId();
    }

    public void setUserId(Long userId) {
        user.setId(userId);
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getTransactionReference() {
        return transactionReference;
    }

    public void setTransactionReference(String transactionReference) {
        this.transactionReference = transactionReference;
    }

    public String getUserUsername() {
        return userUsername;
    }

    public void setUserUsername(String userUsername) {
        this.userUsername = userUsername;
    }

    public Integer getPosition() {
        return position;
    }

    public void setPosition(Integer position) {
        this.position = position;
    }

    public Integer getEstimatedWaitTime() {
        return estimatedWaitTime;
    }

    public void setEstimatedWaitTime(Integer estimatedWaitTime) {
        this.estimatedWaitTime = estimatedWaitTime;
    }

    public Date getCreatedAtAsDate() {
        return Date.from(createdAt.atZone(ZoneId.systemDefault()).toInstant());
    }

    public long getCreatedAtTimestamp() {
        return createdAt.toInstant(ZoneOffset.UTC).toEpochMilli();
    }

    public long getProcessedAtTimestamp() {
        return processedAt != null ? processedAt.toInstant(ZoneOffset.UTC).toEpochMilli() : 0;
    }

    public String getKioskSessionId() {
        return kioskSessionId;
    }

    public void setKioskSessionId(String kioskSessionId) {
        this.kioskSessionId = kioskSessionId;
    }

    public String getPublicIdentifier() {
        return publicIdentifier;
    }

    public void setPublicIdentifier(String publicIdentifier) {
        this.publicIdentifier = publicIdentifier;
    }

    public String getKioskTerminalId() {
        return kioskTerminalId;
    }

    public void setKioskTerminalId(String kioskTerminalId) {
        this.kioskTerminalId = kioskTerminalId;
    }

    public ReceiptPreference getReceiptPreference() {
        return receiptPreference;
    }

    public void setReceiptPreference(ReceiptPreference receiptPreference) {
        this.receiptPreference = receiptPreference;
    }
} 