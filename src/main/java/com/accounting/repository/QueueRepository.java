package com.accounting.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.accounting.model.PaymentQueue;
import java.util.List;
import java.util.Optional;

@Repository
public interface QueueRepository extends JpaRepository<PaymentQueue, Long> {
    
    /**
     * Find the position of a queue number in the current queue
     */
    @Query("SELECT COUNT(q) + 1 FROM PaymentQueue q " +
           "WHERE q.status = 'PENDING' AND q.timestamp < " +
           "(SELECT pq.timestamp FROM PaymentQueue pq WHERE pq.queueNumber = :number AND pq.status = 'PENDING')")
    int findQueuePosition(@Param("number") String number);
    
    /**
     * Find all pending queues ordered by timestamp
     */
    List<PaymentQueue> findByStatusOrderByTimestampAsc(String status);
    
    /**
     * Count queues by status
     */
    long countByStatus(String status);
    
    /**
     * Find queue by queue number
     */
    Optional<PaymentQueue> findByQueueNumber(String queueNumber);
    
    /**
     * Find queues by user ID
     */
    List<PaymentQueue> findByUserId(Long userId);
    
    /**
     * Find queues by status and user ID
     */
    List<PaymentQueue> findByStatusAndUserId(String status, Long userId);
} 