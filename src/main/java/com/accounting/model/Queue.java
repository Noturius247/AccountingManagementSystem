package com.accounting.model;

import com.accounting.model.enums.QueueStatus;
import com.accounting.model.enums.QueueType;
import com.accounting.model.enums.Priority;
import com.accounting.model.enums.ReceiptPreference;
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

@Entity
@Table(name = "queues")
@Data
@NoArgsConstructor
public class Queue {
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "queue_number", nullable = false, unique = true)
    private String queueNumber;

    @Column(name = "user_username", nullable = true)
    private String userUsername;

    @Column(name = "kiosk_session_id", unique = true)
    private String kioskSessionId;

    @Column(name = "public_identifier")
    private String publicIdentifier;

    @Column(name = "kiosk_terminal_id")
    private String kioskTerminalId;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private QueueStatus status = QueueStatus.WAITING;

    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private QueueType type;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Priority priority = Priority.NORMAL;

    @Column(nullable = false)
    private Integer position = 1;

    @Column(name = "estimated_wait_time")
    private Integer estimatedWaitTime;

    @Column(length = 1000)
    private String description;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "processed_at")
    private LocalDateTime processedAt;

    @Column
    private Long serviceId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @Enumerated(EnumType.STRING)
    @Column(name = "receipt_preference")
    private ReceiptPreference receiptPreference = ReceiptPreference.DIGITAL;

    @Column(name = "email_address")
    private String emailAddress;

    @Column(name = "phone_number")
    private String phoneNumber;

    @PrePersist
    protected void onCreate() {
        if (status == null) {
            status = QueueStatus.WAITING;
        }
        if (position == null) {
            position = 1;
        }
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
        if (updatedAt == null) {
            updatedAt = LocalDateTime.now();
        }
        if (priority == null) {
            priority = Priority.NORMAL;
        }
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    // Helper methods
    public boolean isActive() {
        return status == QueueStatus.WAITING || status == QueueStatus.PROCESSING;
    }

    public boolean isProcessed() {
        return status == QueueStatus.COMPLETED || status == QueueStatus.CANCELLED;
    }

    public boolean isHighPriority() {
        return priority == Priority.HIGH;
    }

    public boolean isLowPriority() {
        return priority == Priority.LOW;
    }

    public void markAsProcessed() {
        this.status = QueueStatus.COMPLETED;
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

    public String getUserUsername() {
        return userUsername;
    }

    public void setUserUsername(String userUsername) {
        this.userUsername = userUsername;
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

    public QueueStatus getStatus() {
        return status;
    }

    public void setStatus(QueueStatus status) {
        this.status = status;
    }

    public QueueType getType() {
        return type;
    }

    public void setType(QueueType type) {
        this.type = type;
    }

    public Priority getPriority() {
        return priority;
    }

    public void setPriority(Priority priority) {
        this.priority = priority;
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

    public Long getServiceId() {
        return serviceId;
    }

    public void setServiceId(Long serviceId) {
        this.serviceId = serviceId;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public ReceiptPreference getReceiptPreference() {
        return receiptPreference;
    }

    public void setReceiptPreference(ReceiptPreference receiptPreference) {
        this.receiptPreference = receiptPreference;
    }

    public String getEmailAddress() {
        return emailAddress;
    }

    public void setEmailAddress(String emailAddress) {
        this.emailAddress = emailAddress;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
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
} 