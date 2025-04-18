package com.accounting.model;

import com.accounting.model.enums.QueueStatus;
import com.accounting.model.enums.QueueType;
import com.accounting.model.enums.Priority;
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

    @Column(name = "user_username", nullable = false)
    private String userUsername;

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
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

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

    public LocalDateTime getProcessedAt() {
        return processedAt;
    }

    public void setProcessedAt(LocalDateTime processedAt) {
        this.processedAt = processedAt != null ? processedAt : null;
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

    public String getFormattedEstimatedWaitTime() {
        if (estimatedWaitTime == null) return null;
        Duration duration = Duration.ofMinutes(estimatedWaitTime);
        long hours = duration.toHours();
        long minutes = duration.toMinutesPart();
        return String.format("%02d:%02d", hours, minutes);
    }

    public void setEstimatedWaitTime(String time) {
        if (time != null) {
            try {
                this.estimatedWaitTime = Integer.parseInt(time.replaceAll("[^0-9]", ""));
            } catch (NumberFormatException e) {
                this.estimatedWaitTime = 0;
            }
        }
    }

    public String getFormattedWaitTime() {
        if (estimatedWaitTime < 60) {
            return estimatedWaitTime + " minutes";
        } else {
            int hours = estimatedWaitTime / 60;
            int minutes = estimatedWaitTime % 60;
            return hours + " hour" + (hours > 1 ? "s" : "") + 
                   (minutes > 0 ? " " + minutes + " minute" + (minutes > 1 ? "s" : "") : "");
        }
    }

    public String getPriorityLevel() {
        return priority != null ? priority.toString().toLowerCase() : "medium";
    }

    public String getStatusColor() {
        return status != null ? status.toString().toLowerCase() : "waiting";
    }

    public void setStatus(QueueStatus status) {
        this.status = status;
    }

    public QueueStatus getStatus() {
        return status;
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

    public User getUser() {
        return this.user;
    }

    public void setUser(User user) {
        this.user = user;
    }
} 