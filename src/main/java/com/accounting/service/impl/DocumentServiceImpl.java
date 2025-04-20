package com.accounting.service.impl;

import com.accounting.model.Document;
import com.accounting.model.DocumentHistory;
import com.accounting.model.enums.DocumentStatus;
import com.accounting.model.enums.DocumentType;
import com.accounting.model.enums.Priority;
import com.accounting.repository.DocumentHistoryRepository;
import com.accounting.repository.DocumentRepository;
import com.accounting.service.DocumentService;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.web.multipart.MultipartFile;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import java.io.IOException;
import java.io.File;
import java.io.FileOutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@Service
@Transactional
@Slf4j
public class DocumentServiceImpl implements DocumentService {
    private static final Logger logger = LoggerFactory.getLogger(DocumentServiceImpl.class);
    private final DocumentRepository documentRepository;
    private final DocumentHistoryRepository documentHistoryRepository;

    public DocumentServiceImpl(DocumentRepository documentRepository, DocumentHistoryRepository documentHistoryRepository) {
        this.documentRepository = documentRepository;
        this.documentHistoryRepository = documentHistoryRepository;
    }

    @Override
    @Transactional
    public Document saveDocument(Document document, MultipartFile file) {
        try {
            document.setContent(file.getBytes());
            document.setFileName(file.getOriginalFilename());
            document.setContentType(file.getContentType());
            document.setSize(file.getSize());
            document.setUploadedAt(LocalDateTime.now());
            return documentRepository.save(document);
        } catch (IOException e) {
            logger.error("Error saving document: {}", e.getMessage());
            throw new RuntimeException("Failed to save document", e);
        }
    }

    @Override
    @Transactional(readOnly = true)
    public Document getDocumentById(Long id) {
        return documentRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Document not found with id: " + id));
    }

    @Override
    @Transactional(readOnly = true)
    public List<Document> getDocumentsByTransactionId(Long transactionId) {
        return documentRepository.findByTransactionId(transactionId);
    }

    @Override
    @Transactional
    public void deleteDocument(Long id) {
        documentRepository.deleteById(id);
    }

    @Override
    @Transactional
    public Document updateDocumentStatus(Long id, DocumentStatus status) {
        Document document = getDocumentById(id);
        document.setStatus(status);
        return documentRepository.save(document);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Document> getDocumentsByUser(String username) {
        return documentRepository.findByUserUsernameOrderByUploadedAtDesc(username);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Document> getDocumentsByType(DocumentType type) {
        return documentRepository.findByTypeOrderByUploadedAtDesc(type);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Document> getDocumentsByStatus(DocumentStatus status) {
        return documentRepository.findByStatusOrderByUploadedAtDesc(status);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Document> getDocumentsByPriority(Priority priority) {
        return documentRepository.findByPriorityOrderByUploadedAtDesc(priority);
    }

    @Override
    @Transactional(readOnly = true)
    public long countDocumentsByUser(String username) {
        return documentRepository.countByUserUsername(username);
    }

    @Override
    @Transactional(readOnly = true)
    public long countDocumentsByType(DocumentType type) {
        return documentRepository.countByType(type);
    }

    @Override
    @Transactional(readOnly = true)
    public long countDocumentsByStatus(DocumentStatus status) {
        return documentRepository.countByStatus(status);
    }

    @Override
    @Transactional(readOnly = true)
    public long countDocumentsByPriority(Priority priority) {
        return documentRepository.countByPriority(priority);
    }

    @Override
    @Transactional(readOnly = true)
    public byte[] getDocumentContent(Long id) {
        return getDocumentById(id).getContent();
    }

    @Override
    @Transactional(readOnly = true)
    public String getDocumentFilename(Long id) {
        return getDocumentById(id).getFileName();
    }

    @Override
    @Transactional(readOnly = true)
    public String getDocumentContentType(Long id) {
        return getDocumentById(id).getContentType();
    }

    @Override
    @Transactional(readOnly = true)
    public long getDocumentSize(Long id) {
        return getDocumentById(id).getSize();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Document> getDocumentsByDescription(String description) {
        logger.debug("Getting documents by description containing: {}", description);
        if (!StringUtils.hasText(description)) {
            throw new IllegalArgumentException("Description cannot be empty");
        }
        return documentRepository.findByDescriptionContainingIgnoreCaseOrderByUploadedAtDesc(description);
    }

    @Override
    @Transactional
    public Document updateDocument(Long id, Document document) {
        logger.debug("Updating document with id: {}", id);
        if (id == null) {
            throw new IllegalArgumentException("Document ID cannot be null");
        }
        if (document == null) {
            throw new IllegalArgumentException("Document cannot be null");
        }

        Document existingDocument = documentRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Document not found with id: " + id));

        existingDocument.setFileName(document.getFileName());
        existingDocument.setContentType(document.getContentType());
        existingDocument.setSize(document.getSize());
        existingDocument.setContent(document.getContent());
        existingDocument.setType(document.getType());
        existingDocument.setUserUsername(document.getUserUsername());
        existingDocument.setStatus(document.getStatus());

        return documentRepository.save(existingDocument);
    }

    @Override
    @Transactional(readOnly = true)
    public long getDocumentCount() {
        logger.debug("Getting total document count");
        return documentRepository.count();
    }

    @Override
    @Transactional(readOnly = true)
    public long getDocumentCountByType(DocumentType type) {
        logger.debug("Getting document count by type: {}", type);
        if (type == null) {
            throw new IllegalArgumentException("Document type cannot be null");
        }
        return documentRepository.countByType(type);
    }

    @Override
    @Transactional(readOnly = true)
    public long getDocumentCountByStatus(DocumentStatus status) {
        logger.debug("Getting document count by status: {}", status);
        if (status == null) {
            throw new IllegalArgumentException("Status cannot be null");
        }
        return documentRepository.countByStatus(status);
    }

    @Override
    @Transactional(readOnly = true)
    public long getDocumentCountByPriority(Priority priority) {
        logger.debug("Getting document count by priority: {}", priority);
        if (priority == null) {
            throw new IllegalArgumentException("Priority cannot be null");
        }
        return documentRepository.countByPriority(priority);
    }

    @Override
    public List<Document> getDocumentsByReferenceId(Long referenceId) {
        return documentRepository.findByReferenceId(referenceId);
    }

    @Override
    public Optional<Document> getDocument(Long id) {
        return documentRepository.findById(id);
    }

    @Override
    public long countDocumentsByPriority(String priority) {
        return documentRepository.countByPriority(Priority.valueOf(priority));
    }

    @Override
    public long countDocumentsByType(String type) {
        return documentRepository.countByType(DocumentType.valueOf(type));
    }

    @Override
    public String getDocumentFileName(Long id) {
        return getDocumentById(id).getFileName();
    }

    @Override
    public Document downloadDocument(Long id) {
        return getDocumentById(id);
    }

    @Override
    public long getDocumentCountByUser(String username) {
        return documentRepository.countByUserUsername(username);
    }

    @Override
    public long countDocumentsByStatus(String status) {
        return documentRepository.countByStatus(DocumentStatus.valueOf(status));
    }

    @Override
    public Document uploadDocument(MultipartFile file, DocumentType type, String username) {
        Document document = new Document();
        document.setType(type);
        document.setUserUsername(username);
        return saveDocument(document, file);
    }

    @Override
    public List<Document> getStudentDocuments(Long userId) {
        return documentRepository.findByUserId(userId);
    }

    @Override
    public List<Document> getRecentDocuments(Long userId, int limit) {
        return documentRepository.findByUserId(userId)
            .stream()
            .limit(limit)
            .collect(Collectors.toList());
    }

    @Override
    public void deleteById(Long id) {
        documentRepository.deleteById(id);
    }

    @Override
    public Document findById(Long id) {
        return documentRepository.findById(id)
            .orElseThrow(() -> new EntityNotFoundException("Document not found with id: " + id));
    }

    @Override
    public List<Document> findAll() {
        return documentRepository.findAll();
    }

    @Override
    public Document save(Document document) {
        return documentRepository.save(document);
    }

    @Override
    public Page<Document> findAll(Pageable pageable) {
        return documentRepository.findAll(pageable);
    }

    @Override
    public List<Document> findByUserUsername(String username) {
        return documentRepository.findByUserUsername(username);
    }

    @Override
    public List<Document> findByStatus(DocumentStatus status) {
        return documentRepository.findByStatus(status);
    }

    @Override
    public Page<Document> findByStatus(DocumentStatus status, Pageable pageable) {
        return documentRepository.findByStatus(status, pageable);
    }

    @Override
    public List<Document> findByType(DocumentType type) {
        return documentRepository.findByType(type);
    }

    @Override
    public Page<Document> findByType(DocumentType type, Pageable pageable) {
        return documentRepository.findByType(type, pageable);
    }

    @Override
    public Page<Document> findByStatusAndType(DocumentStatus status, DocumentType type, Pageable pageable) {
        return documentRepository.findByStatusAndType(status, type, pageable);
    }

    @Override
    public Page<Document> searchDocuments(String searchTerm, Pageable pageable) {
        return documentRepository.searchDocuments(searchTerm, pageable);
    }

    @Override
    @Transactional
    public Document updateDocumentStatus(Long id, DocumentStatus status, String comment) {
        Document document = getDocumentById(id);
        if (document != null) {
            DocumentStatus oldStatus = document.getStatus();
            document.setStatus(status);
            document.setUpdatedAt(LocalDateTime.now());
            document = saveDocument(document, null);

            // Record history
            DocumentHistory history = new DocumentHistory(document, oldStatus, status, comment, document.getUser());
            documentHistoryRepository.save(history);

            return document;
        }
        return null;
    }

    @Override
    public List<Map<String, Object>> getDocumentHistory(Long id) {
        return documentHistoryRepository.findByDocumentIdOrderByCreatedAtDesc(id)
                .stream()
                .map(history -> {
                    Map<String, Object> historyMap = new HashMap<>();
                    historyMap.put("id", history.getId());
                    historyMap.put("oldStatus", history.getOldStatus());
                    historyMap.put("newStatus", history.getNewStatus());
                    historyMap.put("comment", history.getComment());
                    historyMap.put("createdAt", history.getCreatedAt());
                    return historyMap;
                })
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void addComment(Long id, String comment) {
        Document document = getDocumentById(id);
        if (document != null) {
            DocumentHistory history = new DocumentHistory(document, document.getStatus(), document.getStatus(), comment, document.getUser());
            documentHistoryRepository.save(history);
        }
    }

    private void validateDocument(Document document) {
        if (document == null) {
            throw new IllegalArgumentException("Document cannot be null");
        }
        if (document.getType() == null) {
            throw new IllegalArgumentException("Document type cannot be null");
        }
        if (document.getStatus() == null) {
            throw new IllegalArgumentException("Document status cannot be null");
        }
        if (document.getContent() == null || document.getContent().length == 0) {
            throw new IllegalArgumentException("Document content cannot be empty");
        }
        if (!StringUtils.hasText(document.getFileName())) {
            throw new IllegalArgumentException("Document filename cannot be empty");
        }
        if (!StringUtils.hasText(document.getContentType())) {
            throw new IllegalArgumentException("Document content type cannot be empty");
        }
        if (document.getSize() <= 0) {
            throw new IllegalArgumentException("Document size must be greater than 0");
        }
    }
} 