package com.accounting.model;

import com.accounting.model.enums.NotificationStatus;
import com.accounting.model.enums.NotificationType;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.accounting.model.converter.JsonToMapConverter;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Entity
@Table(name = "notifications")
@Getter
@Setter
@NoArgsConstructor
@Slf4j
public class Notification {
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private static final ObjectMapper objectMapper = new ObjectMapper();

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String title;

    @Column(length = 1000, nullable = false)
    private String message;

    @Column(nullable = false)
    @JdbcTypeCode(SqlTypes.LONGVARCHAR)
    private String content;

    @Column(name = "notification_type")
    private String notificationType;

    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private NotificationStatus status;

    @Column(name = "is_read", nullable = false)
    private boolean isRead = false;

    @Column(name = "is_system_notification", nullable = false)
    private boolean isSystemNotification = false;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "read_at")
    private LocalDateTime readAt;

    @Column(name = "expires_at")
    private LocalDateTime expiresAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(columnDefinition = "JSON")
    @Convert(converter = JsonToMapConverter.class)
    private Map<String, Object> settings = new HashMap<>();

    @Column(name = "payment_settings", columnDefinition = "JSON")
    @Convert(converter = JsonToMapConverter.class)
    private Map<String, Object> paymentSettings = new HashMap<>(Map.of(
        "allowedMethods", List.of("CASH"),
        "defaultMethod", "CASH",
        "cashOnly", true,
        "version", "1.0"
    ));

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
        if (status == null) {
            status = NotificationStatus.UNREAD;
        }
    }

    public boolean isUnread() {
        return !isRead;
    }

    public void markAsRead() {
        this.isRead = true;
        this.readAt = LocalDateTime.now();
    }

    public boolean isUserNotification() {
        return !isSystemNotification;
    }

    public void updateSettings(Map<String, Object> newSettings) {
        if (newSettings != null) {
            this.settings = newSettings;
        }
    }

    public String getFormattedCreatedAt() {
        return createdAt != null ? createdAt.format(DATE_FORMATTER) : "";
    }

    public String getFormattedReadAt() {
        return readAt != null ? readAt.format(DATE_FORMATTER) : "";
    }

    public Map<String, Object> getSettings() {
        return settings;
    }

    public void setSettings(Map<String, Object> settings) {
        this.settings = settings != null ? settings : new HashMap<>();
    }

    public String getStatusColor() {
        return status != null ? status.toString().toLowerCase() : "unread";
    }

    public String getTypeIcon() {
        return notificationType != null ? notificationType.toLowerCase() : "info";
    }

    public boolean isExpired() {
        return expiresAt != null && LocalDateTime.now().isAfter(expiresAt);
    }

    public void setExpiration(int days) {
        if (days > 0) {
            this.expiresAt = LocalDateTime.now().plusDays(days);
        }
    }

    public String getFormattedExpiresAt() {
        return expiresAt != null ? expiresAt.format(DATE_FORMATTER) : "";
    }

    public Map<String, Object> getPaymentSettings() {
        return paymentSettings;
    }

    public void setPaymentSettings(Map<String, Object> paymentSettings) {
        this.paymentSettings = paymentSettings != null ? paymentSettings : new HashMap<>();
    }
} 