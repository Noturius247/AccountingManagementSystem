package com.accounting.repository;

import com.accounting.model.Document;
import com.accounting.model.enums.DocumentStatus;
import com.accounting.model.enums.DocumentType;
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
    List<Document> findByStatusAndTypeOrderByUploadedAtDesc(DocumentStatus status, DocumentType type);
    List<Document> findByUserUsernameAndStatusOrderByUploadedAtDesc(String username, DocumentStatus status);
    List<Document> findByUserUsernameAndTypeOrderByUploadedAtDesc(String username, DocumentType type);
    List<Document> findByUserUsernameAndStatusAndTypeOrderByUploadedAtDesc(String username, DocumentStatus status, DocumentType type);
    List<Document> findByDescriptionContainingIgnoreCaseOrderByUploadedAtDesc(String description);
    List<Document> findByUserUsernameAndDescriptionContainingIgnoreCaseOrderByUploadedAtDesc(String username, String description);
    List<Document> findByStatusAndDescriptionContainingIgnoreCaseOrderByUploadedAtDesc(DocumentStatus status, String description);
    List<Document> findByTypeAndDescriptionContainingIgnoreCaseOrderByUploadedAtDesc(DocumentType type, String description);
    List<Document> findByUserUsernameAndStatusAndDescriptionContainingIgnoreCaseOrderByUploadedAtDesc(String username, DocumentStatus status, String description);
    List<Document> findByUserUsernameAndTypeAndDescriptionContainingIgnoreCaseOrderByUploadedAtDesc(String username, DocumentType type, String description);
    List<Document> findByStatusAndTypeAndDescriptionContainingIgnoreCaseOrderByUploadedAtDesc(DocumentStatus status, DocumentType type, String description);
    List<Document> findByUploadedAtBetweenOrderByUploadedAtDesc(LocalDateTime start, LocalDateTime end);
    List<Document> findByUserUsernameAndUploadedAtBetweenOrderByUploadedAtDesc(String username, LocalDateTime start, LocalDateTime end);
    List<Document> findByStatusAndUploadedAtBetweenOrderByUploadedAtDesc(DocumentStatus status, LocalDateTime start, LocalDateTime end);
    List<Document> findByTypeAndUploadedAtBetweenOrderByUploadedAtDesc(DocumentType type, LocalDateTime start, LocalDateTime end);
    List<Document> findByUserUsernameAndStatusAndUploadedAtBetweenOrderByUploadedAtDesc(String username, DocumentStatus status, LocalDateTime start, LocalDateTime end);
    List<Document> findByUserUsernameAndTypeAndUploadedAtBetweenOrderByUploadedAtDesc(String username, DocumentType type, LocalDateTime start, LocalDateTime end);
    List<Document> findByStatusAndTypeAndUploadedAtBetweenOrderByUploadedAtDesc(DocumentStatus status, DocumentType type, LocalDateTime start, LocalDateTime end);
    List<Document> findByDescriptionContainingIgnoreCaseAndUploadedAtBetweenOrderByUploadedAtDesc(String description, LocalDateTime start, LocalDateTime end);
    List<Document> findByUserUsernameAndDescriptionContainingIgnoreCaseAndUploadedAtBetweenOrderByUploadedAtDesc(String username, String description, LocalDateTime start, LocalDateTime end);
    List<Document> findByStatusAndDescriptionContainingIgnoreCaseAndUploadedAtBetweenOrderByUploadedAtDesc(DocumentStatus status, String description, LocalDateTime start, LocalDateTime end);
    List<Document> findByTypeAndDescriptionContainingIgnoreCaseAndUploadedAtBetweenOrderByUploadedAtDesc(DocumentType type, String description, LocalDateTime start, LocalDateTime end);
    List<Document> findByUserUsernameAndStatusAndDescriptionContainingIgnoreCaseAndUploadedAtBetweenOrderByUploadedAtDesc(String username, DocumentStatus status, String description, LocalDateTime start, LocalDateTime end);
    List<Document> findByUserUsernameAndTypeAndDescriptionContainingIgnoreCaseAndUploadedAtBetweenOrderByUploadedAtDesc(String username, DocumentType type, String description, LocalDateTime start, LocalDateTime end);
    List<Document> findByStatusAndTypeAndDescriptionContainingIgnoreCaseAndUploadedAtBetweenOrderByUploadedAtDesc(DocumentStatus status, DocumentType type, String description, LocalDateTime start, LocalDateTime end);

    @Query("SELECT d FROM Document d WHERE d.referenceId = :transactionId ORDER BY d.uploadedAt DESC")
    List<Document> findByTransactionId(@Param("transactionId") Long transactionId);

    @Query("SELECT d FROM Document d WHERE d.user.username = :username ORDER BY d.uploadedAt DESC")
    List<Document> findByUsernameOrderByUploadedAtDesc(@Param("username") String username);

    @Query("SELECT d.status, COUNT(d) FROM Document d GROUP BY d.status")
    List<Object[]> countByStatus();

    @Query("SELECT d.user.username, d.status, d.type, COUNT(d) FROM Document d GROUP BY d.user.username, d.status, d.type")
    List<Object[]> countByUserAndStatusAndType();

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

    @Query("SELECT d FROM Document d WHERE d.referenceId = :referenceId")
    List<Document> findByReferenceId(@Param("referenceId") Long referenceId);

    List<Document> findTop5ByOrderByUploadedAtDesc();
    List<Document> findTop5ByUserUsernameOrderByUploadedAtDesc(String username);

    List<Document> findByUserId(Long userId);

    @Query("SELECT d FROM Document d WHERE " +
           "LOWER(d.title) LIKE LOWER(CONCAT('%', :searchTerm, '%')) OR " +
           "LOWER(d.description) LIKE LOWER(CONCAT('%', :searchTerm, '%'))")
    Page<Document> searchDocuments(@Param("searchTerm") String searchTerm, Pageable pageable);

    Page<Document> findByStatusAndType(DocumentStatus status, DocumentType type, Pageable pageable);

    List<Document> findByType(DocumentType type);
    Page<Document> findByType(DocumentType type, Pageable pageable);

    List<Document> findByStatus(DocumentStatus status);
    Page<Document> findByStatus(DocumentStatus status, Pageable pageable);
} 