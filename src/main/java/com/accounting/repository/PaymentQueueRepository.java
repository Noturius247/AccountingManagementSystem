package com.accounting.repository;

import com.accounting.model.PaymentQueue;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Repository
public interface PaymentQueueRepository extends JpaRepository<PaymentQueue, Long> {
    Optional<PaymentQueue> findByUsername(String username);
    List<PaymentQueue> findByStatus(String status);
    List<PaymentQueue> findByStatusOrderByCreatedAtAsc(String status);
    List<PaymentQueue> findByUsernameAndStatus(String username, String status);
    
    @Query("SELECT COUNT(p) FROM PaymentQueue p WHERE p.status = :status")
    long countByStatus(@Param("status") String status);
    
    @Query("SELECT p FROM PaymentQueue p WHERE p.status = 'WAITING' ORDER BY p.createdAt ASC")
    List<PaymentQueue> findWaitingQueue();
    
    @Query("SELECT p FROM PaymentQueue p WHERE p.status = 'PROCESSING'")
    List<PaymentQueue> findProcessingQueue();
    
    @Query("SELECT SUM(p.amount) FROM PaymentQueue p WHERE p.status = 'PENDING'")
    BigDecimal sumPendingAmount();
    
    @Query("SELECT COUNT(p) FROM PaymentQueue p WHERE p.status = 'PENDING'")
    long countPending();

    Optional<PaymentQueue> findByQueueNumber(String queueNumber);
    void deleteByQueueNumber(String queueNumber);
} 