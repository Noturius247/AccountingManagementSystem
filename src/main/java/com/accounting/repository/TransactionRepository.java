package com.accounting.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.accounting.model.Transaction;
import com.accounting.model.User;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface TransactionRepository extends JpaRepository<Transaction, Long> {
    
    /**
     * Find transactions between two timestamps
     */
    List<Transaction> findByTimestampBetween(LocalDateTime start, LocalDateTime end);
    
    /**
     * Count transactions between two timestamps
     */
    long countByTimestampBetween(LocalDateTime start, LocalDateTime end);
    
    /**
     * Sum amount of transactions between two timestamps
     */
    @Query("SELECT COALESCE(SUM(t.amount), 0) FROM Transaction t WHERE t.timestamp BETWEEN :start AND :end")
    double sumAmountByTimestampBetween(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end);
    
    /**
     * Get average daily transactions between two timestamps
     */
    @Query("SELECT COALESCE(COUNT(t) * 1.0 / (EXTRACT(EPOCH FROM (:end - :start)) / 86400 + 1), 0) " +
           "FROM Transaction t WHERE t.timestamp BETWEEN :start AND :end")
    double getAverageDailyTransactions(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end);
    
    /**
     * Count transactions by status
     */
    long countByStatus(String status);
    
    /**
     * Find transactions by status
     */
    List<Transaction> findByStatus(String status);
    
    /**
     * Find transactions by user
     */
    List<Transaction> findByUser(User user);
    
    /**
     * Find transactions by status and user
     */
    List<Transaction> findByStatusAndUser(String status, User user);
} 