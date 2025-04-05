package com.accounting.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.accounting.model.PaymentQueue;
import java.util.List;

@Repository
public interface PaymentQueueRepository extends JpaRepository<PaymentQueue, Long> {
    
    /**
     * Find payment queues by status
     */
    List<PaymentQueue> findByStatus(String status);
    
    /**
     * Count payment queues by status
     */
    long countByStatus(String status);
} 