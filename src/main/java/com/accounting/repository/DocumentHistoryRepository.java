package com.accounting.repository;

import com.accounting.model.Document;
import com.accounting.model.DocumentHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DocumentHistoryRepository extends JpaRepository<DocumentHistory, Long> {
    List<DocumentHistory> findByDocumentOrderByCreatedAtDesc(Document document);
    List<DocumentHistory> findByDocumentIdOrderByCreatedAtDesc(Long documentId);
} 