package com.accounting.service;

import com.accounting.model.Document;
import com.accounting.model.enums.DocumentStatus;
import com.accounting.model.enums.DocumentType;
import com.accounting.model.enums.Priority;
import org.springframework.web.multipart.MultipartFile;
import java.util.List;
import java.util.Optional;

public interface DocumentService {
    Document uploadDocument(MultipartFile file, DocumentType type, String username);
    Document saveDocument(Document document, MultipartFile file);
    Document downloadDocument(Long id);
    Document getDocumentById(Long id);
    List<Document> getDocumentsByUser(String username);
    List<Document> getDocumentsByType(DocumentType type);
    List<Document> getDocumentsByStatus(DocumentStatus status);
    List<Document> getDocumentsByPriority(Priority priority);
    List<Document> getDocumentsByDescription(String description);
    void deleteDocument(Long id);
    Document updateDocument(Long id, Document document);
    long getDocumentCount();
    long getDocumentCountByUser(String username);
    long getDocumentCountByType(DocumentType type);
    long getDocumentCountByStatus(DocumentStatus status);
    long getDocumentCountByPriority(Priority priority);
    List<Document> getDocumentsByReferenceId(Long referenceId);
    Optional<Document> getDocument(Long id);
    Document updateDocumentStatus(Long id, DocumentStatus status);
    long countDocumentsByType(String type);
    long countDocumentsByType(DocumentType type);
    long countDocumentsByStatus(String status);
    long countDocumentsByStatus(DocumentStatus status);
    long countDocumentsByPriority(String priority);
    long countDocumentsByPriority(Priority priority);
    byte[] getDocumentContent(Long id);
    String getDocumentFileName(Long id);
    String getDocumentFilename(Long id);
    String getDocumentContentType(Long id);
    long getDocumentSize(Long id);
    List<Document> getDocumentsByTransactionId(Long transactionId);
    long countDocumentsByUser(String username);
} 