package com.accounting.model;

import com.accounting.model.enums.DocumentStatus;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "document_history")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class DocumentHistory {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "document_id", nullable = false)
    private Document document;

    @Enumerated(EnumType.STRING)
    @Column(name = "old_status")
    private DocumentStatus oldStatus;

    @Enumerated(EnumType.STRING)
    @Column(name = "new_status")
    private DocumentStatus newStatus;

    @Column(length = 1000)
    private String comment;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    public DocumentHistory(Document document, DocumentStatus oldStatus, DocumentStatus newStatus, String comment, User user) {
        this.document = document;
        this.oldStatus = oldStatus;
        this.newStatus = newStatus;
        this.comment = comment;
        this.user = user;
    }

    // Explicit getter methods
    public Long getId() {
        return id;
    }

    public DocumentStatus getOldStatus() {
        return oldStatus;
    }

    public DocumentStatus getNewStatus() {
        return newStatus;
    }

    public String getComment() {
        return comment;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
} 