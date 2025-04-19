package com.accounting.repository;

import com.accounting.model.Document;
import com.accounting.model.enums.DocumentStatus;
import com.accounting.model.enums.DocumentType;
import com.accounting.model.enums.Priority;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface DocumentRepository extends JpaRepository<Document, Long> {
    List<Document> findByUserUsername(String username);
    List<Document> findByUserUsernameAndType(String username, DocumentType type);
    long countByUserId(Long userId);
    List<Document> findByUserUsernameOrderByUploadedAtDesc(String username);
    List<Document> findByTypeOrderByUploadedAtDesc(DocumentType type);
    List<Document> findByStatusOrderByUploadedAtDesc(DocumentStatus status);
    List<Document> findByPriorityOrderByUploadedAtDesc(Priority priority);
    List<Document> findByStatusAndTypeOrderByUploadedAtDesc(DocumentStatus status, DocumentType type);
    List<Document> findByStatusAndPriorityOrderByUploadedAtDesc(DocumentStatus status, Priority priority);
    List<Document> findByTypeAndPriorityOrderByUploadedAtDesc(DocumentType type, Priority priority);
    List<Document> findByStatusAndTypeAndPriorityOrderByUploadedAtDesc(DocumentStatus status, DocumentType type, Priority priority);
    List<Document> findByUserUsernameAndStatusOrderByUploadedAtDesc(String username, DocumentStatus status);
    List<Document> findByUserUsernameAndTypeOrderByUploadedAtDesc(String username, DocumentType type);
    List<Document> findByUserUsernameAndPriorityOrderByUploadedAtDesc(String username, Priority priority);
    List<Document> findByUserUsernameAndStatusAndTypeOrderByUploadedAtDesc(String username, DocumentStatus status, DocumentType type);
    List<Document> findByUserUsernameAndStatusAndPriorityOrderByUploadedAtDesc(String username, DocumentStatus status, Priority priority);
    List<Document> findByUserUsernameAndTypeAndPriorityOrderByUploadedAtDesc(String username, DocumentType type, Priority priority);
    List<Document> findByUserUsernameAndStatusAndTypeAndPriorityOrderByUploadedAtDesc(String username, DocumentStatus status, DocumentType type, Priority priority);
    List<Document> findByDescriptionContainingIgnoreCaseOrderByUploadedAtDesc(String description);
    List<Document> findByUserUsernameAndDescriptionContainingIgnoreCaseOrderByUploadedAtDesc(String username, String description);
    List<Document> findByStatusAndDescriptionContainingIgnoreCaseOrderByUploadedAtDesc(DocumentStatus status, String description);
    List<Document> findByTypeAndDescriptionContainingIgnoreCaseOrderByUploadedAtDesc(DocumentType type, String description);
    List<Document> findByPriorityAndDescriptionContainingIgnoreCaseOrderByUploadedAtDesc(Priority priority, String description);
    List<Document> findByUserUsernameAndStatusAndDescriptionContainingIgnoreCaseOrderByUploadedAtDesc(String username, DocumentStatus status, String description);
    List<Document> findByUserUsernameAndTypeAndDescriptionContainingIgnoreCaseOrderByUploadedAtDesc(String username, DocumentType type, String description);
    List<Document> findByUserUsernameAndPriorityAndDescriptionContainingIgnoreCaseOrderByUploadedAtDesc(String username, Priority priority, String description);
    List<Document> findByStatusAndTypeAndDescriptionContainingIgnoreCaseOrderByUploadedAtDesc(DocumentStatus status, DocumentType type, String description);
    List<Document> findByStatusAndPriorityAndDescriptionContainingIgnoreCaseOrderByUploadedAtDesc(DocumentStatus status, Priority priority, String description);
    List<Document> findByTypeAndPriorityAndDescriptionContainingIgnoreCaseOrderByUploadedAtDesc(DocumentType type, Priority priority, String description);
    List<Document> findByUserUsernameAndStatusAndTypeAndDescriptionContainingIgnoreCaseOrderByUploadedAtDesc(String username, DocumentStatus status, DocumentType type, String description);
    List<Document> findByUserUsernameAndStatusAndPriorityAndDescriptionContainingIgnoreCaseOrderByUploadedAtDesc(String username, DocumentStatus status, Priority priority, String description);
    List<Document> findByUserUsernameAndTypeAndPriorityAndDescriptionContainingIgnoreCaseOrderByUploadedAtDesc(String username, DocumentType type, Priority priority, String description);
    List<Document> findByStatusAndTypeAndPriorityAndDescriptionContainingIgnoreCaseOrderByUploadedAtDesc(DocumentStatus status, DocumentType type, Priority priority, String description);
    List<Document> findByUserUsernameAndStatusAndTypeAndPriorityAndDescriptionContainingIgnoreCaseOrderByUploadedAtDesc(String username, DocumentStatus status, DocumentType type, Priority priority, String description);
    List<Document> findByUploadedAtBetweenOrderByUploadedAtDesc(LocalDateTime start, LocalDateTime end);
    List<Document> findByUserUsernameAndUploadedAtBetweenOrderByUploadedAtDesc(String username, LocalDateTime start, LocalDateTime end);
    List<Document> findByStatusAndUploadedAtBetweenOrderByUploadedAtDesc(DocumentStatus status, LocalDateTime start, LocalDateTime end);
    List<Document> findByTypeAndUploadedAtBetweenOrderByUploadedAtDesc(DocumentType type, LocalDateTime start, LocalDateTime end);
    List<Document> findByPriorityAndUploadedAtBetweenOrderByUploadedAtDesc(Priority priority, LocalDateTime start, LocalDateTime end);
    List<Document> findByUserUsernameAndStatusAndUploadedAtBetweenOrderByUploadedAtDesc(String username, DocumentStatus status, LocalDateTime start, LocalDateTime end);
    List<Document> findByUserUsernameAndTypeAndUploadedAtBetweenOrderByUploadedAtDesc(String username, DocumentType type, LocalDateTime start, LocalDateTime end);
    List<Document> findByUserUsernameAndPriorityAndUploadedAtBetweenOrderByUploadedAtDesc(String username, Priority priority, LocalDateTime start, LocalDateTime end);
    List<Document> findByStatusAndTypeAndUploadedAtBetweenOrderByUploadedAtDesc(DocumentStatus status, DocumentType type, LocalDateTime start, LocalDateTime end);
    List<Document> findByStatusAndPriorityAndUploadedAtBetweenOrderByUploadedAtDesc(DocumentStatus status, Priority priority, LocalDateTime start, LocalDateTime end);
    List<Document> findByTypeAndPriorityAndUploadedAtBetweenOrderByUploadedAtDesc(DocumentType type, Priority priority, LocalDateTime start, LocalDateTime end);
    List<Document> findByUserUsernameAndStatusAndTypeAndUploadedAtBetweenOrderByUploadedAtDesc(String username, DocumentStatus status, DocumentType type, LocalDateTime start, LocalDateTime end);
    List<Document> findByUserUsernameAndStatusAndPriorityAndUploadedAtBetweenOrderByUploadedAtDesc(String username, DocumentStatus status, Priority priority, LocalDateTime start, LocalDateTime end);
    List<Document> findByUserUsernameAndTypeAndPriorityAndUploadedAtBetweenOrderByUploadedAtDesc(String username, DocumentType type, Priority priority, LocalDateTime start, LocalDateTime end);
    List<Document> findByStatusAndTypeAndPriorityAndUploadedAtBetweenOrderByUploadedAtDesc(DocumentStatus status, DocumentType type, Priority priority, LocalDateTime start, LocalDateTime end);
    List<Document> findByUserUsernameAndStatusAndTypeAndPriorityAndUploadedAtBetweenOrderByUploadedAtDesc(String username, DocumentStatus status, DocumentType type, Priority priority, LocalDateTime start, LocalDateTime end);
    List<Document> findByDescriptionContainingIgnoreCaseAndUploadedAtBetweenOrderByUploadedAtDesc(String description, LocalDateTime start, LocalDateTime end);
    List<Document> findByUserUsernameAndDescriptionContainingIgnoreCaseAndUploadedAtBetweenOrderByUploadedAtDesc(String username, String description, LocalDateTime start, LocalDateTime end);
    List<Document> findByStatusAndDescriptionContainingIgnoreCaseAndUploadedAtBetweenOrderByUploadedAtDesc(DocumentStatus status, String description, LocalDateTime start, LocalDateTime end);
    List<Document> findByTypeAndDescriptionContainingIgnoreCaseAndUploadedAtBetweenOrderByUploadedAtDesc(DocumentType type, String description, LocalDateTime start, LocalDateTime end);
    List<Document> findByPriorityAndDescriptionContainingIgnoreCaseAndUploadedAtBetweenOrderByUploadedAtDesc(Priority priority, String description, LocalDateTime start, LocalDateTime end);
    List<Document> findByUserUsernameAndStatusAndDescriptionContainingIgnoreCaseAndUploadedAtBetweenOrderByUploadedAtDesc(String username, DocumentStatus status, String description, LocalDateTime start, LocalDateTime end);
    List<Document> findByUserUsernameAndTypeAndDescriptionContainingIgnoreCaseAndUploadedAtBetweenOrderByUploadedAtDesc(String username, DocumentType type, String description, LocalDateTime start, LocalDateTime end);
    List<Document> findByUserUsernameAndPriorityAndDescriptionContainingIgnoreCaseAndUploadedAtBetweenOrderByUploadedAtDesc(String username, Priority priority, String description, LocalDateTime start, LocalDateTime end);
    List<Document> findByStatusAndTypeAndDescriptionContainingIgnoreCaseAndUploadedAtBetweenOrderByUploadedAtDesc(DocumentStatus status, DocumentType type, String description, LocalDateTime start, LocalDateTime end);
    List<Document> findByStatusAndPriorityAndDescriptionContainingIgnoreCaseAndUploadedAtBetweenOrderByUploadedAtDesc(DocumentStatus status, Priority priority, String description, LocalDateTime start, LocalDateTime end);
    List<Document> findByTypeAndPriorityAndDescriptionContainingIgnoreCaseAndUploadedAtBetweenOrderByUploadedAtDesc(DocumentType type, Priority priority, String description, LocalDateTime start, LocalDateTime end);
    List<Document> findByUserUsernameAndStatusAndTypeAndDescriptionContainingIgnoreCaseAndUploadedAtBetweenOrderByUploadedAtDesc(String username, DocumentStatus status, DocumentType type, String description, LocalDateTime start, LocalDateTime end);
    List<Document> findByUserUsernameAndStatusAndPriorityAndDescriptionContainingIgnoreCaseAndUploadedAtBetweenOrderByUploadedAtDesc(String username, DocumentStatus status, Priority priority, String description, LocalDateTime start, LocalDateTime end);
    List<Document> findByUserUsernameAndTypeAndPriorityAndDescriptionContainingIgnoreCaseAndUploadedAtBetweenOrderByUploadedAtDesc(String username, DocumentType type, Priority priority, String description, LocalDateTime start, LocalDateTime end);
    List<Document> findByStatusAndTypeAndPriorityAndDescriptionContainingIgnoreCaseAndUploadedAtBetweenOrderByUploadedAtDesc(DocumentStatus status, DocumentType type, Priority priority, String description, LocalDateTime start, LocalDateTime end);
    List<Document> findByUserUsernameAndStatusAndTypeAndPriorityAndDescriptionContainingIgnoreCaseAndUploadedAtBetweenOrderByUploadedAtDesc(String username, DocumentStatus status, DocumentType type, Priority priority, String description, LocalDateTime start, LocalDateTime end);

    @Query("SELECT d FROM Document d WHERE d.referenceId = :transactionId ORDER BY d.uploadedAt DESC")
    List<Document> findByTransactionId(@Param("transactionId") Long transactionId);

    @Query("SELECT d FROM Document d WHERE d.user.username = :username ORDER BY d.uploadedAt DESC")
    List<Document> findByUsernameOrderByUploadedAtDesc(@Param("username") String username);

    @Query("SELECT d.status, COUNT(d) FROM Document d GROUP BY d.status")
    List<Object[]> countByStatus();

    @Query("SELECT d.user.username, d.status, d.type, d.priority, COUNT(d) FROM Document d GROUP BY d.user.username, d.status, d.type, d.priority")
    List<Object[]> countByUserAndStatusAndTypeAndPriority();

    @Query("SELECT d FROM Document d WHERE d.userUsername = :username AND " +
           "(LOWER(d.fileName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(d.description) LIKE LOWER(CONCAT('%', :keyword, '%'))) " +
           "ORDER BY d.uploadedAt DESC")
    List<Document> searchByUserAndKeyword(@Param("username") String username, @Param("keyword") String keyword);

    @Query("SELECT COUNT(d) FROM Document d WHERE d.userUsername = :username")
    long countByUserUsername(@Param("username") String username);

    @Query("SELECT COUNT(d) FROM Document d WHERE d.userUsername = :username AND d.status = :status")
    long countByUserUsernameAndStatus(@Param("username") String username, @Param("status") DocumentStatus status);

    @Query("SELECT COUNT(d) FROM Document d WHERE d.userUsername = :username AND d.type = :type")
    long countByUserUsernameAndType(@Param("username") String username, @Param("type") DocumentType type);

    @Query("SELECT SUM(d.size) FROM Document d WHERE d.userUsername = :username")
    Long sumFileSizeByUserUsername(@Param("username") String username);

    @Query("SELECT d FROM Document d WHERE d.userUsername = :username " +
           "AND d.uploadedAt BETWEEN :startDate AND :endDate " +
           "ORDER BY d.uploadedAt DESC")
    Page<Document> findByUserUsernameAndDateRange(
        @Param("username") String username,
        @Param("startDate") LocalDateTime startDate,
        @Param("endDate") LocalDateTime endDate,
        Pageable pageable);

    @Query("SELECT COUNT(d) FROM Document d WHERE d.type = :type")
    long countByType(@Param("type") DocumentType type);

    @Query("SELECT COUNT(d) FROM Document d WHERE d.status = :status")
    long countByStatus(@Param("status") DocumentStatus status);

    @Query("SELECT COUNT(d) FROM Document d WHERE d.priority = :priority")
    long countByPriority(@Param("priority") Priority priority);

    @Query("SELECT d FROM Document d WHERE d.referenceId = :referenceId")
    List<Document> findByReferenceId(@Param("referenceId") Long referenceId);

    List<Document> findTop5ByOrderByUploadedAtDesc();
    List<Document> findTop5ByUserUsernameOrderByUploadedAtDesc(String username);

    List<Document> findByUserId(Long userId);
} 