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
import com.accounting.model.User;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, Long> {
    @Query("SELECT COALESCE(SUM(p.amount), 0) FROM Payment p")
    Optional<BigDecimal> sumAmount();

    @Query("SELECT COALESCE(SUM(p.amount), 0) FROM Payment p WHERE p.status = :status")
    Optional<BigDecimal> sumAmountByStatus(@Param("status") PaymentStatus status);

    @Query("SELECT COALESCE(SUM(p.amount), 0) FROM Payment p WHERE p.type = :type")
    Optional<BigDecimal> sumAmountByType(@Param("type") String type);

    @Query("SELECT COALESCE(SUM(p.amount), 0) FROM Payment p WHERE p.user = :user")
    Optional<BigDecimal> sumAmountByUser(@Param("user") User user);

    @Query("SELECT COALESCE(SUM(p.amount), 0) FROM Payment p WHERE p.createdAt BETWEEN :startDate AND :endDate")
    BigDecimal sumTotalAmountByDateRange(@Param("startDate") Date startDate, @Param("endDate") Date endDate);

    @Query("SELECT COUNT(p) FROM Payment p WHERE p.status = :status")
    long countByStatus(@Param("status") PaymentStatus status);

    @Query("SELECT COUNT(p) FROM Payment p WHERE p.type = :type")
    long countByType(@Param("type") String type);

    @Query("SELECT COUNT(p) FROM Payment p WHERE p.user = :user")
    long countByUser(@Param("user") User user);

    Optional<Payment> findByQueueNumber(String queueNumber);

    @Query("SELECT p FROM Payment p WHERE p.user = :user ORDER BY p.createdAt DESC")
    List<Payment> findByUserOrderByCreatedAtDesc(@Param("user") User user);

    @Query("SELECT p FROM Payment p WHERE p.status = :status")
    List<Payment> findByStatus(@Param("status") PaymentStatus status);

    @Query("SELECT p FROM Payment p WHERE p.type = :type ORDER BY p.createdAt DESC")
    List<Payment> findByTypeOrderByCreatedAtDesc(@Param("type") String type);

    @Query("SELECT p FROM Payment p WHERE p.description LIKE %:description%")
    List<Payment> findByDescriptionContaining(@Param("description") String description);

    @Query("SELECT p FROM Payment p WHERE p.description LIKE %:description% ORDER BY p.createdAt DESC LIMIT 5")
    List<Payment> findTop5ByDescriptionContaining(@Param("description") String description);

    @Query("SELECT p FROM Payment p WHERE p.amount BETWEEN :minAmount AND :maxAmount ORDER BY p.createdAt DESC")
    List<Payment> findByAmountBetweenOrderByCreatedAtDesc(@Param("minAmount") Double minAmount, @Param("maxAmount") Double maxAmount);

    @Query("SELECT COUNT(p) FROM Payment p WHERE p.user.username = :username AND p.status = 'PENDING'")
    int countPendingByUserUsername(@Param("username") String username);

    @Query("SELECT p FROM Payment p WHERE p.user.username = :username ORDER BY p.createdAt DESC LIMIT 5")
    List<Payment> findTop5ByUserUsernameOrderByCreatedAtDesc(@Param("username") String username);

    @Query("SELECT COUNT(p) FROM Payment p WHERE p.description LIKE %:description%")
    long countByDescriptionContaining(@Param("description") String description);

    @Query("SELECT p.status, p.type, COUNT(p) FROM Payment p GROUP BY p.status, p.type")
    List<Object[]> countByStatusAndType();

    @Query("SELECT COALESCE(SUM(p.amount), 0) FROM Payment p WHERE p.description LIKE %:query% OR p.status LIKE %:query%")
    Optional<BigDecimal> sumAmountByDescriptionContainingOrStatusContaining(@Param("query") String query);

    @Query("SELECT p FROM Payment p ORDER BY p.createdAt DESC LIMIT 10")
    List<Payment> findTop10ByOrderByCreatedAtDesc();

    @Query("SELECT p FROM Payment p ORDER BY p.createdAt DESC LIMIT 5")
    List<Payment> findTop5ByOrderByCreatedAtDesc();

    @Query("SELECT COALESCE(SUM(p.amount), 0) FROM Payment p WHERE DATE(p.createdAt) = CURRENT_DATE")
    Optional<BigDecimal> sumAmountToday();

    @Query("SELECT COUNT(p) FROM Payment p WHERE DATE(p.createdAt) = CURRENT_DATE")
    long countToday();
} 