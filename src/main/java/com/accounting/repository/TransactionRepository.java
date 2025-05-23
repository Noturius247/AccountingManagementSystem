package com.accounting.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.accounting.model.Transaction;
import com.accounting.model.User;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import com.accounting.model.enums.TransactionStatus;
import com.accounting.model.enums.TransactionType;

@Repository
public interface TransactionRepository extends JpaRepository<Transaction, Long> {
    
    /**
     * Find transactions between two timestamps
     */
    List<Transaction> findByCreatedAtBetween(LocalDateTime start, LocalDateTime end);
    
    /**
     * Count transactions between two timestamps
     */
    @Query("SELECT COUNT(t) FROM Transaction t WHERE t.createdAt BETWEEN :start AND :end")
    long countByCreatedAtBetween(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end);
    
    /**
     * Sum amount of transactions between two timestamps
     */
    @Query("SELECT COALESCE(SUM(t.amount), 0) FROM Transaction t WHERE t.createdAt BETWEEN :start AND :end")
    BigDecimal sumAmountByCreatedAtBetween(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end);
    
    /**
     * Get average daily transactions between two timestamps
     */
    @Query("SELECT COALESCE(COUNT(t) * 1.0 / (EXTRACT(EPOCH FROM (:end - :start)) / 86400 + 1), 0) " +
           "FROM Transaction t WHERE t.createdAt BETWEEN :start AND :end")
    double getAverageDailyTransactions(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end);
    
    /**
     * Count transactions by status
     */
    long countByStatus(TransactionStatus status);
    
    /**
     * Find transactions by status
     */
    List<Transaction> findByStatus(TransactionStatus status);
    
    /**
     * Find transactions by user
     */
    List<Transaction> findByUser(User user);
    
    /**
     * Find transactions by status and user
     */
    List<Transaction> findByStatusAndUser(TransactionStatus status, User user);
    
    List<Transaction> findTop5ByOrderByCreatedAtDesc();

    List<Transaction> findByUserId(Long userId);
    long countByUserIdAndStatus(Long userId, TransactionStatus status);

    Page<Transaction> findByUserUsername(String username, Pageable pageable);
    List<Transaction> findByUserUsername(String username);
    List<Transaction> findByUserUsernameOrderByCreatedAtDesc(String username);
    List<Transaction> findByUserUsernameAndStatusOrderByCreatedAtDesc(String username, TransactionStatus status);
    
    @Query("SELECT SUM(t.amount) FROM Transaction t WHERE t.user.username = :username")
    Optional<BigDecimal> sumAmountByUserUsername(@Param("username") String username);
    
    @Query("SELECT SUM(t.amount) FROM Transaction t WHERE t.status = :status")
    Optional<BigDecimal> sumAmountByStatus(@Param("status") TransactionStatus status);
    
    @Query("SELECT COUNT(t) FROM Transaction t WHERE t.user.username = :username AND t.status = :status")
    long countByUserUsernameAndStatus(@Param("username") String username, @Param("status") TransactionStatus status);

    @Query("SELECT COUNT(t) FROM Transaction t WHERE t.user.username = :username")
    long countByUserUsername(@Param("username") String username);
    
    List<Transaction> findByUserOrderByCreatedAtDesc(User user);
    
    @Query("SELECT SUM(t.amount) FROM Transaction t WHERE t.user = :user")
    Optional<BigDecimal> sumAmountByUser(@Param("user") User user);

    @Query("SELECT SUM(t.amount) FROM Transaction t WHERE t.user.id = :userId")
    Optional<BigDecimal> sumAmountByUserId(@Param("userId") Long userId);

    @Query("SELECT t FROM Transaction t WHERE t.user.username = :username AND t.status = :status")
    List<Transaction> findByUserUsernameAndStatus(@Param("username") String username, @Param("status") TransactionStatus status);
    
    /**
     * Search transactions by username, notes or status
     */
    List<Transaction> findByUserUsernameContainingOrNotesContainingOrStatusContaining(
        String username, String notes, String status);

    List<Transaction> findByNotesContainingOrStatusContaining(String notes, String status);
    
    @Query("SELECT SUM(t.amount) FROM Transaction t WHERE t.notes LIKE %:query%")
    BigDecimal sumAmountByNotesContaining(@Param("query") String query);
    
    @Query("SELECT COUNT(t) FROM Transaction t WHERE t.notes LIKE %:query%")
    long countByNotesContaining(@Param("query") String query);

    @Query("SELECT SUM(t.amount) FROM Transaction t WHERE t.notes LIKE %:query% OR t.status LIKE %:query%")
    Optional<BigDecimal> sumAmountByNotesContainingOrStatusContaining(@Param("query") String query);

    List<Transaction> findByNotesContaining(@Param("notes") String notes);
    
    List<Transaction> findTop5ByNotesContainingOrderByCreatedAtDesc(String query);

    List<Transaction> findByNotesContainingIgnoreCaseOrderByCreatedAtDesc(String notes);

    List<Transaction> findByUserUsernameAndNotesContainingIgnoreCaseOrderByCreatedAtDesc(String username, String notes);
    List<Transaction> findByStatusAndNotesContainingIgnoreCaseOrderByCreatedAtDesc(String status, String notes);
    List<Transaction> findByTypeAndNotesContainingIgnoreCaseOrderByCreatedAtDesc(String type, String notes);
    List<Transaction> findByUserUsernameAndStatusAndNotesContainingIgnoreCaseOrderByCreatedAtDesc(String username, String status, String notes);
    List<Transaction> findByUserUsernameAndTypeAndNotesContainingIgnoreCaseOrderByCreatedAtDesc(String username, String type, String notes);
    List<Transaction> findByStatusAndTypeAndNotesContainingIgnoreCaseOrderByCreatedAtDesc(String status, String type, String notes);
    List<Transaction> findByUserUsernameAndStatusAndTypeAndNotesContainingIgnoreCaseOrderByCreatedAtDesc(String username, String status, String type, String notes);

    @Query("SELECT t FROM Transaction t WHERE t.user.username = :username AND " +
           "LOWER(t.notes) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
           "ORDER BY t.createdAt DESC")
    List<Transaction> searchByUserAndKeyword(@Param("username") String username, @Param("keyword") String keyword);

    List<Transaction> findByStatusOrderByCreatedAtDesc(TransactionStatus status);
    List<Transaction> findByTypeOrderByCreatedAtDesc(TransactionType type);
    
    @Query("SELECT COUNT(t) FROM Transaction t WHERE t.type = :type")
    long countByType(@Param("type") TransactionType type);
    
    @Query("SELECT SUM(t.amount) FROM Transaction t")
    Optional<BigDecimal> sumAmount();
    
    @Query("SELECT SUM(t.amount) FROM Transaction t WHERE t.type = :type")
    Optional<Double> sumAmountByType(@Param("type") TransactionType type);
    
    @Query("SELECT t.type, COUNT(t) FROM Transaction t WHERE t.createdAt BETWEEN :start AND :end GROUP BY t.type")
    List<Object[]> countByTypeAndDateRange(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end);

    @Query("SELECT COUNT(t) FROM Transaction t WHERE t.user.username = :username AND t.type = :type")
    long countByUserUsernameAndType(@Param("username") String username, @Param("type") TransactionType type);
    
    @Query("SELECT SUM(t.amount) FROM Transaction t WHERE t.user.username = :username AND t.status = :status")
    BigDecimal sumAmountByUserUsernameAndStatus(@Param("username") String username, @Param("status") TransactionStatus status);
    
    @Query("SELECT t FROM Transaction t WHERE t.user.username = :username " +
           "AND t.createdAt BETWEEN :startDate AND :endDate " +
           "ORDER BY t.createdAt DESC")
    Page<Transaction> findByUserUsernameAndDateRange(
        @Param("username") String username,
        @Param("startDate") LocalDateTime startDate,
        @Param("endDate") LocalDateTime endDate,
        Pageable pageable);

    List<Transaction> findTop10ByOrderByCreatedAtDesc();

    @Query("SELECT SUM(t.amount) FROM Transaction t WHERE DATE(t.createdAt) = CURRENT_DATE")
    Optional<BigDecimal> sumAmountToday();

    @Query("SELECT COUNT(t) FROM Transaction t WHERE DATE(t.createdAt) = CURRENT_DATE")
    long countToday();

    @Query("SELECT t FROM Transaction t WHERE t.amount BETWEEN :min AND :max ORDER BY t.createdAt DESC")
    List<Transaction> findByAmountBetweenOrderByCreatedAtDesc(@Param("min") BigDecimal min, @Param("max") BigDecimal max);

    @Query("SELECT COUNT(t) FROM Transaction t WHERE t.status = :status AND t.createdAt BETWEEN :start AND :end")
    long countByStatusAndCreatedAtBetween(@Param("status") TransactionStatus status, @Param("start") LocalDateTime start, @Param("end") LocalDateTime end);

    @Query("SELECT AVG(t.amount) FROM Transaction t")
    Optional<BigDecimal> averageAmount();

    @Query("SELECT CASE WHEN COUNT(t) > 0 THEN true ELSE false END FROM Transaction t WHERE t.receiptId = :receiptId AND t.user.username = :username")
    boolean existsByReceiptIdAndUserUsername(@Param("receiptId") String receiptId, @Param("username") String username);

    @Query("SELECT t FROM Transaction t WHERE t.notes LIKE %:notes% AND t.status = :status")
    List<Transaction> findByNotesContainingAndStatus(@Param("notes") String notes, @Param("status") TransactionStatus status);

    @Query("SELECT CASE WHEN COUNT(t) > 0 THEN true ELSE false END FROM Transaction t WHERE t.receiptId = :receiptId")
    boolean existsByReceiptId(@Param("receiptId") String receiptId);

    List<Transaction> findByUserUsernameAndStatusAndNotesContainingIgnoreCaseOrderByCreatedAtDesc(String username, TransactionStatus status, String notes);
    List<Transaction> findByStatusAndTypeAndNotesContainingIgnoreCaseOrderByCreatedAtDesc(TransactionStatus status, TransactionType type, String notes);

    @Query("SELECT COUNT(t) FROM Transaction t WHERE t.status = :status")
    long countByStatus(String status);
    
    @Query("SELECT t.status, COUNT(t) FROM Transaction t GROUP BY t.status")
    List<Object[]> countByStatusGroupByStatus();
    
    @Query("SELECT DATE(t.createdAt) as date, COUNT(t) FROM Transaction t " +
           "WHERE t.createdAt BETWEEN :start AND :end " +
           "GROUP BY DATE(t.createdAt) " +
           "ORDER BY date")
    List<Object[]> countByCreatedAtBetweenGroupByDate(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end);

    Optional<Transaction> findTopByUserIdOrderByCreatedAtDesc(@Param("userId") Long userId);

    @Query("SELECT t FROM Transaction t LEFT JOIN FETCH t.user WHERE t.id = :id")
    Optional<Transaction> findByIdWithUser(@Param("id") Long id);

    List<Transaction> findByUserIdOrderByCreatedAtDesc(Long userId);

    @Query("SELECT COALESCE(SUM(t.amount), 0) FROM Transaction t WHERE t.status = :status AND t.createdAt >= :startDate")
    double sumAmountByStatusAndCreatedAtAfter(
        @Param("status") TransactionStatus status,
        @Param("startDate") LocalDateTime startDate
    );
    
    @Query("SELECT COALESCE(SUM(t.amount), 0) FROM Transaction t WHERE t.status = :status AND t.createdAt BETWEEN :startDate AND :endDate")
    double sumAmountByStatusAndCreatedAtBetween(
        @Param("status") TransactionStatus status,
        @Param("startDate") LocalDateTime startDate,
        @Param("endDate") LocalDateTime endDate
    );
    
    Page<Transaction> findByStatus(TransactionStatus status, Pageable pageable);
    
    List<Transaction> findByStatusAndCreatedAtBetween(
        TransactionStatus status,
        LocalDateTime startDate,
        LocalDateTime endDate
    );

    @Query("SELECT t FROM Transaction t WHERE " +
           "(:status IS NULL OR t.status = :status) AND " +
           "(:startDate IS NULL OR t.createdAt >= :startDate) AND " +
           "(:endDate IS NULL OR t.createdAt <= :endDate) AND " +
           "(:minAmount IS NULL OR t.amount >= :minAmount) AND " +
           "(:maxAmount IS NULL OR t.amount <= :maxAmount)")
    List<Transaction> findTransactionsWithFilters(
        @Param("status") TransactionStatus status,
        @Param("startDate") LocalDateTime startDate,
        @Param("endDate") LocalDateTime endDate,
        @Param("minAmount") BigDecimal minAmount,
        @Param("maxAmount") BigDecimal maxAmount
    );
} 