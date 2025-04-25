package com.accounting.model;

import com.accounting.model.enums.DocumentStatus;
import com.accounting.model.enums.DocumentType;
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.regex.Pattern;

@Entity
@Table(name = "documents")
@Data
@NoArgsConstructor
public class Document {
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private static final Pattern FILE_NAME_PATTERN = Pattern.compile("^[a-zA-Z0-9._-]+$");
    private static final Pattern FILE_TYPE_PATTERN = Pattern.compile("^[a-zA-Z0-9/.-]+$");

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "file_name", nullable = false)
    private String fileName;

    @Column(name = "content_type", nullable = false)
    private String contentType;

    @Column(nullable = false)
    private long size;

    @Lob
    @Column(nullable = false)
    private byte[] content;

    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private DocumentType type;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "user_username", nullable = false)
    private String userUsername;

    @CreationTimestamp
    @Column(name = "uploaded_at", nullable = false, updatable = false)
    private LocalDateTime uploadedAt;

    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private DocumentStatus status;

    @Column(length = 1000)
    private String description;

    @Column(name = "reference_id")
    private Long referenceId;

    @Column(nullable = false)
    private String title;

    @Column(nullable = false)
    private String filePath;

    @Column(nullable = false)
    private String fileType;

    @Column(nullable = false)
    private Long studentId;

    @Column(name = "document_type", nullable = false)
    private String documentType;

    @Column(name = "reference_number", nullable = false)
    private String referenceNumber;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(nullable = false)
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        if (uploadedAt == null) {
            uploadedAt = LocalDateTime.now();
        }
        if (status == null) {
            status = DocumentStatus.DRAFT;
        }
        if (user != null) {
            userUsername = user.getUsername();
        }
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    public String getSanitizedFileName() {
        return fileName != null ? fileName.replaceAll("[^a-zA-Z0-9._-]", "_") : "";
    }

    public boolean isValidFileType() {
        return contentType != null && FILE_TYPE_PATTERN.matcher(contentType).matches();
    }

    public String getFileExtension() {
        if (fileName == null) return "";
        int lastDot = fileName.lastIndexOf('.');
        return lastDot > 0 ? fileName.substring(lastDot + 1).toLowerCase() : "";
    }

    public void setFileSize(String size) {
        if (size != null) {
            try {
                size = size.toUpperCase().trim();
                if (size.endsWith("B")) {
                    this.size = Long.parseLong(size.replace("B", "").trim());
                } else if (size.endsWith("KB")) {
                    this.size = (long) (Double.parseDouble(size.replace("KB", "").trim()) * 1024);
                } else if (size.endsWith("MB")) {
                    this.size = (long) (Double.parseDouble(size.replace("MB", "").trim()) * 1024 * 1024);
                } else if (size.endsWith("GB")) {
                    this.size = (long) (Double.parseDouble(size.replace("GB", "").trim()) * 1024 * 1024 * 1024);
                } else {
                    this.size = Long.parseLong(size);
                }
            } catch (NumberFormatException e) {
                this.size = 0;
            }
        }
    }

    public String getFormattedUploadedAt() {
        return uploadedAt != null ? uploadedAt.format(DATE_FORMATTER) : "";
    }

    public String getFormattedFileSize() {
        if (size < 1024) return size + " B";
        if (size < 1024 * 1024) return String.format("%.2f KB", size / 1024.0);
        if (size < 1024 * 1024 * 1024) return String.format("%.2f MB", size / (1024.0 * 1024));
        return String.format("%.2f GB", size / (1024.0 * 1024 * 1024));
    }

    public String getStatusColor() {
        return status != null ? status.toString().toLowerCase() : "draft";
    }

    public Long getId() {
        return id;
    }

    public String getFileName() {
        return fileName;
    }

    public String getContentType() {
        return contentType;
    }

    public long getSize() {
        return size;
    }

    public byte[] getContent() {
        return content;
    }

    public DocumentType getType() {
        return type;
    }

    public User getUser() {
        return user;
    }

    public String getUserUsername() {
        return userUsername;
    }

    public LocalDateTime getUploadedAt() {
        return uploadedAt;
    }

    public DocumentStatus getStatus() {
        return status;
    }

    public String getDescription() {
        return description;
    }

    public Long getReferenceId() {
        return referenceId;
    }

    public String getTitle() {
        return title;
    }

    public String getFilePath() {
        return filePath;
    }

    public String getFileType() {
        return fileType;
    }

    public Long getStudentId() {
        return studentId;
    }

    public String getDocumentType() {
        return documentType;
    }

    public String getReferenceNumber() {
        return referenceNumber;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    public void setSize(long size) {
        this.size = size;
    }

    public void setContent(byte[] content) {
        this.content = content;
    }

    public void setType(DocumentType type) {
        this.type = type;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public void setUserUsername(String userUsername) {
        this.userUsername = userUsername;
    }

    public void setUploadedAt(LocalDateTime uploadedAt) {
        this.uploadedAt = uploadedAt;
    }

    public void setStatus(DocumentStatus status) {
        this.status = status;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setReferenceId(Long referenceId) {
        this.referenceId = referenceId;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    public void setStudentId(Long studentId) {
        this.studentId = studentId;
    }

    public void setDocumentType(String documentType) {
        this.documentType = documentType;
    }

    public void setReferenceNumber(String referenceNumber) {
        this.referenceNumber = referenceNumber;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public void setId(Long id) {
        this.id = id;
    }
} 