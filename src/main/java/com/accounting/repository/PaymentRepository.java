package com.accounting.repository;

import com.accounting.model.Payment;
import com.accounting.model.enums.PaymentStatus;
import com.accounting.model.enums.PaymentType;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Optional;
import java.util.Date;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, Long> {
    List<Payment> findByDescriptionContaining(String query);
    
    @Query("SELECT p FROM Payment p WHERE p.userUsername = ?1 ORDER BY p.createdAt DESC")
    List<Payment> findTop5ByUserUsernameOrderByCreatedAtDesc(String username);
    
    @Query("SELECT COUNT(p) FROM Payment p WHERE p.description LIKE %?1%")
    long countByDescriptionContaining(String query);
    
    @Query("SELECT SUM(p.amount) FROM Payment p WHERE p.description LIKE %?1%")
    BigDecimal sumAmountByDescriptionContaining(String query);
    
    @Query("SELECT COUNT(p) FROM Payment p WHERE p.userUsername = :username")
    long countByUserUsername(@Param("username") String username);
    
    @Query("SELECT SUM(p.amount) FROM Payment p WHERE p.userUsername = ?1")
    BigDecimal sumAmountByUserUsername(String username);
    
    @Query("SELECT p FROM Payment p WHERE p.description LIKE %:query% ORDER BY p.createdAt DESC LIMIT 5")
    List<Payment> findTop5ByDescriptionContaining(@Param("query") String query);

    @Query("SELECT p FROM Payment p WHERE p.userUsername = :username ORDER BY p.createdAt DESC")
    List<Payment> findByUserUsernameOrderByCreatedAtDesc(@Param("username") String username);

    @Query("SELECT p FROM Payment p WHERE p.status = :status")
    List<Payment> findByStatus(@Param("status") PaymentStatus status);

    @Query("SELECT p FROM Payment p WHERE p.createdAt BETWEEN :startDate AND :endDate")
    List<Payment> findByCreatedAtBetween(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);

    @Query("SELECT p FROM Payment p WHERE p.userUsername = :username AND p.status = :status")
    List<Payment> findByUserUsernameAndStatus(@Param("username") String username, @Param("status") String status);

    List<Payment> findByTypeOrderByCreatedAtDesc(String type);
    List<Payment> findByStatusAndTypeOrderByCreatedAtDesc(String status, String type);
    List<Payment> findByUserUsernameAndStatusOrderByCreatedAtDesc(String username, String status);
    List<Payment> findByUserUsernameAndTypeOrderByCreatedAtDesc(String username, String type);
    List<Payment> findByUserUsernameAndStatusAndTypeOrderByCreatedAtDesc(String username, String status, String type);
    List<Payment> findByDescriptionContainingIgnoreCaseOrderByCreatedAtDesc(String description);
    List<Payment> findByUserUsernameAndDescriptionContainingIgnoreCaseOrderByCreatedAtDesc(String username, String description);
    List<Payment> findByStatusAndDescriptionContainingIgnoreCaseOrderByCreatedAtDesc(String status, String description);
    List<Payment> findByTypeAndDescriptionContainingIgnoreCaseOrderByCreatedAtDesc(String type, String description);
    List<Payment> findByUserUsernameAndStatusAndDescriptionContainingIgnoreCaseOrderByCreatedAtDesc(String username, String status, String description);
    List<Payment> findByUserUsernameAndTypeAndDescriptionContainingIgnoreCaseOrderByCreatedAtDesc(String username, String type, String description);
    List<Payment> findByStatusAndTypeAndDescriptionContainingIgnoreCaseOrderByCreatedAtDesc(String status, String type, String description);
    List<Payment> findByUserUsernameAndStatusAndTypeAndDescriptionContainingIgnoreCaseOrderByCreatedAtDesc(String username, String status, String type, String description);

    @Query("SELECT p FROM Payment p WHERE p.transactionReference = :transactionId ORDER BY p.createdAt DESC")
    List<Payment> findByTransactionId(@Param("transactionId") Long transactionId);

    @Query("SELECT p FROM Payment p WHERE p.userUsername = :username ORDER BY p.createdAt DESC")
    List<Payment> findByUsernameOrderByCreatedAtDesc(@Param("username") String username);

    @Query("SELECT p.status, COUNT(p) FROM Payment p GROUP BY p.status")
    List<Object[]> countByStatus();

    @Query("SELECT p.type, COUNT(p) FROM Payment p GROUP BY p.type")
    List<Object[]> countByType();

    @Query("SELECT p.status, p.type, COUNT(p) FROM Payment p GROUP BY p.status, p.type")
    List<Object[]> countByStatusAndType();

    @Query("SELECT p.status, p.type, COUNT(p) FROM Payment p GROUP BY p.status, p.type")
    List<Object[]> countByStatusAndTypeAndPriority();

    @Query("SELECT p.userUsername, COUNT(p) FROM Payment p GROUP BY p.userUsername")
    List<Object[]> countByUser();

    @Query("SELECT p.userUsername, p.status, COUNT(p) FROM Payment p GROUP BY p.userUsername, p.status")
    List<Object[]> countByUserAndStatus();

    @Query("SELECT p.userUsername, p.type, COUNT(p) FROM Payment p GROUP BY p.userUsername, p.type")
    List<Object[]> countByUserAndType();

    @Query("SELECT p.userUsername, p.status, p.type, COUNT(p) FROM Payment p GROUP BY p.userUsername, p.status, p.type")
    List<Object[]> countByUserAndStatusAndType();

    @Query("SELECT SUM(p.amount) FROM Payment p WHERE p.status = :status")
    Optional<Double> sumAmountByStatus(@Param("status") PaymentStatus status);

    @Query("SELECT SUM(p.amount) FROM Payment p WHERE p.type = :type")
    Optional<Double> sumAmountByType(@Param("type") String type);

    @Query("SELECT SUM(p.amount) FROM Payment p WHERE p.status = :status AND p.type = :type")
    Optional<Double> sumAmountByStatusAndType(@Param("status") String status, @Param("type") String type);

    @Query("SELECT p.userUsername, SUM(p.amount) FROM Payment p GROUP BY p.userUsername")
    List<Object[]> sumAmountByUser();

    @Query("SELECT p.userUsername, p.status, SUM(p.amount) FROM Payment p GROUP BY p.userUsername, p.status")
    List<Object[]> sumAmountByUserAndStatus();

    @Query("SELECT p.userUsername, p.type, SUM(p.amount) FROM Payment p GROUP BY p.userUsername, p.type")
    List<Object[]> sumAmountByUserAndType();

    @Query("SELECT p.userUsername, p.status, p.type, SUM(p.amount) FROM Payment p GROUP BY p.userUsername, p.status, p.type")
    List<Object[]> sumAmountByUserAndStatusAndType();

    List<Payment> findByUserUsernameAndStatusOrderByCreatedAtDesc(String username, PaymentStatus status);
    List<Payment> findByUserUsernameAndTypeOrderByCreatedAtDesc(String username, PaymentType type);
    
    @Query("SELECT p FROM Payment p WHERE p.userUsername = :username AND p.createdAt BETWEEN :startDate AND :endDate ORDER BY p.createdAt DESC")
    List<Payment> findByUserUsernameAndCreatedAtBetweenOrderByCreatedAtDesc(
        @Param("username") String username,
        @Param("startDate") LocalDateTime startDate,
        @Param("endDate") LocalDateTime endDate
    );
    
    @Query("SELECT p FROM Payment p WHERE p.userUsername = :username AND " +
           "(LOWER(p.description) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(p.transactionReference) LIKE LOWER(CONCAT('%', :keyword, '%'))) " +
           "ORDER BY p.createdAt DESC")
    List<Payment> searchByUserAndKeyword(@Param("username") String username, @Param("keyword") String keyword);
    
    @Query("SELECT COUNT(p) FROM Payment p WHERE p.userUsername = :username AND p.status = :status")
    long countByUserUsernameAndStatus(@Param("username") String username, @Param("status") PaymentStatus status);
    
    @Query("SELECT COUNT(p) FROM Payment p WHERE p.userUsername = :username AND p.type = :type")
    long countByUserUsernameAndType(@Param("username") String username, @Param("type") PaymentType type);
    
    @Query("SELECT SUM(p.amount) FROM Payment p WHERE p.userUsername = :username AND p.status = :status")
    Double sumAmountByUserUsernameAndStatus(@Param("username") String username, @Param("status") PaymentStatus status);
    
    @Query("SELECT p FROM Payment p WHERE p.userUsername = :username " +
           "AND p.createdAt BETWEEN :startDate AND :endDate " +
           "ORDER BY p.createdAt DESC")
    Page<Payment> findByUserUsernameAndDateRange(
        @Param("username") String username,
        @Param("startDate") LocalDateTime startDate,
        @Param("endDate") LocalDateTime endDate,
        Pageable pageable);

    @Query("SELECT p FROM Payment p WHERE p.createdAt BETWEEN :startDate AND :endDate")
    List<Payment> findByPaymentDateBetween(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);
    
    @Query("SELECT COALESCE(SUM(p.amount), 0) FROM Payment p WHERE p.createdAt BETWEEN :startDate AND :endDate")
    BigDecimal getTotalPaymentsBetween(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);
    
    @Query("SELECT p FROM Payment p WHERE p.userUsername = :username AND p.createdAt BETWEEN :startDate AND :endDate ORDER BY p.createdAt DESC")
    List<Payment> findByUserUsernameAndPaymentDateBetweenOrderByPaymentDateDesc(
        @Param("username") String username,
        @Param("startDate") LocalDateTime startDate,
        @Param("endDate") LocalDateTime endDate
    );

    @Query("SELECT SUM(p.amount) FROM Payment p WHERE p.description LIKE %:query% OR p.status LIKE %:query%")
    Optional<BigDecimal> sumAmountByDescriptionContainingOrStatusContaining(@Param("query") String query);

    @Query("SELECT COUNT(p) FROM Payment p WHERE p.description LIKE %:query% OR p.status LIKE %:query%")
    long countByDescriptionContainingOrStatusContaining(@Param("query") String query);

    @Query("SELECT SUM(p.amount) FROM Payment p")
    Optional<BigDecimal> sumAmount();

    @Query("SELECT p FROM Payment p ORDER BY p.createdAt DESC LIMIT 10")
    List<Payment> findTop10ByOrderByCreatedAtDesc();

    @Query("SELECT SUM(p.amount) FROM Payment p WHERE DATE(p.createdAt) = CURRENT_DATE")
    Optional<BigDecimal> sumAmountToday();

    @Query("SELECT COUNT(p) FROM Payment p WHERE DATE(p.createdAt) = CURRENT_DATE")
    long countToday();

    @Query("SELECT p FROM Payment p ORDER BY p.createdAt DESC LIMIT 5")
    List<Payment> findTop5ByOrderByCreatedAtDesc();

    List<Payment> findByStatusOrderByCreatedAtDesc(PaymentStatus status);
    List<Payment> findByAmountBetweenOrderByCreatedAtDesc(Double minAmount, Double maxAmount);
    long countByStatus(PaymentStatus status);

    @Query("SELECT COUNT(p) FROM Payment p WHERE p.type = :type")
    long countByType(@Param("type") String type);

    Optional<Payment> findByQueueNumber(String queueNumber);

    @Query("SELECT SUM(p.amount) FROM Payment p WHERE p.createdAt BETWEEN :startDate AND :endDate")
    BigDecimal sumTotalAmountByDateRange(@Param("startDate") Date startDate, @Param("endDate") Date endDate);

    @Query("SELECT COUNT(p) FROM Payment p WHERE p.userUsername = :username AND p.status = 'PENDING'")
    int countPendingByUserUsername(@Param("username") String username);

    @Query("SELECT COUNT(p) FROM Payment p WHERE p.userUsername = :username AND p.status = :status")
    Long countByUserAndStatus(@Param("username") String username, @Param("status") PaymentStatus status);
} 