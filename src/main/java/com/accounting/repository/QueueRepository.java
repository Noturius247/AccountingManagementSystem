package com.accounting.repository;

import com.accounting.model.Queue;
import com.accounting.model.enums.QueueStatus;
import com.accounting.model.enums.QueueType;
import com.accounting.model.enums.PaymentType;
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
public interface QueueRepository extends JpaRepository<Queue, Long> {
    Optional<Queue> findByQueueNumber(String queueNumber);
    
    // Public queue methods
    Optional<Queue> findByPublicIdentifierAndKioskSessionId(String publicIdentifier, String kioskSessionId);
    boolean existsByPublicIdentifierAndKioskSessionId(String publicIdentifier, String kioskSessionId);
    List<Queue> findByKioskTerminalId(String kioskTerminalId);
    
    @Query("SELECT q FROM Queue q WHERE q.status = 'WAITING' ORDER BY q.createdAt ASC")
    List<Queue> findWaitingQueuesOrderByCreatedAtAsc();
    
    @Query("SELECT COUNT(q) FROM Queue q WHERE q.status = ?1 AND q.createdAt < ?2")
    long countByStatusAndCreatedAtBefore(QueueStatus status, LocalDateTime dateTime);
    
    Optional<Queue> findByUserUsername(String username);
    
    @Query("SELECT q FROM Queue q WHERE q.status = 'WAITING' ORDER BY q.createdAt ASC")
    Queue getNextInQueue();
    
    @Query("SELECT q FROM Queue q WHERE q.status = :status ORDER BY q.createdAt ASC")
    List<Queue> findByStatusOrderByCreatedAtAsc(@Param("status") QueueStatus status);
    
    @Query("SELECT COUNT(q) FROM Queue q WHERE q.status = 'WAITING' AND q.createdAt < (SELECT q2.createdAt FROM Queue q2 WHERE q2.userUsername = :username)")
    int findQueuePosition(@Param("username") String username);
    
    @Query("SELECT AVG(TIMESTAMPDIFF(SECOND, q.createdAt, q.updatedAt)) FROM Queue q WHERE q.status = 'COMPLETED'")
    Double calculateAverageProcessingTime();
    
    @Query("SELECT q FROM Queue q ORDER BY q.createdAt DESC LIMIT :limit")
    List<Queue> findTopNByOrderByCreatedAtDesc(@Param("limit") int limit);
    
    @Query("SELECT q FROM Queue q WHERE q.userUsername = :username AND q.status = :status")
    List<Queue> findByUsernameAndStatus(@Param("username") String username, @Param("status") QueueStatus status);

    @Query("SELECT q FROM Queue q WHERE q.user.username = :username ORDER BY q.createdAt DESC")
    List<Queue> findByUserUsernameOrderByCreatedAtDesc(@Param("username") String username);

    @Query("SELECT q FROM Queue q WHERE q.status = :status ORDER BY q.position ASC")
    List<Queue> findByStatusOrderByPositionAsc(@Param("status") QueueStatus status);

    @Query("SELECT MAX(q.position) FROM Queue q WHERE q.status = :status")
    Integer findMaxPositionByStatus(@Param("status") QueueStatus status);

    @Query("SELECT COUNT(q) FROM Queue q WHERE q.status = :status")
    Long countByStatus(@Param("status") QueueStatus status);

    @Query("SELECT q.status, COUNT(q) FROM Queue q GROUP BY q.status")
    List<Object[]> countByStatus();

    @Query("SELECT q.type, COUNT(q) FROM Queue q GROUP BY q.type")
    List<Object[]> countByType();

    @Query("SELECT q.status, AVG(q.estimatedWaitTime) FROM Queue q GROUP BY q.status")
    List<Object[]> avgWaitTimeByStatus();

    @Query("SELECT q.type, AVG(q.estimatedWaitTime) FROM Queue q GROUP BY q.type")
    List<Object[]> avgWaitTimeByType();

    @Query("SELECT q FROM Queue q WHERE q.user.username = :username AND q.createdAt BETWEEN :startDate AND :endDate ORDER BY q.createdAt DESC")
    List<Queue> findByUserUsernameAndCreatedAtBetweenOrderByCreatedAtDesc(
        @Param("username") String username,
        @Param("startDate") LocalDateTime startDate,
        @Param("endDate") LocalDateTime endDate
    );
    
    @Query("SELECT q FROM Queue q WHERE q.userUsername = :username AND " +
           "(LOWER(q.description) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "CAST(q.scheduleId AS string) LIKE CONCAT('%', :keyword, '%')) " +
           "ORDER BY q.createdAt DESC")
    List<Queue> searchByUserAndKeyword(@Param("username") String username, @Param("keyword") String keyword);
    
    @Query("SELECT COUNT(q) FROM Queue q WHERE q.userUsername = :username")
    long countByUserUsername(@Param("username") String username);
    
    @Query("SELECT COUNT(q) FROM Queue q WHERE q.userUsername = :username AND q.status = :status")
    long countByUserUsernameAndStatus(@Param("username") String username, @Param("status") QueueStatus status);
    
    @Query("SELECT COUNT(q) FROM Queue q WHERE q.userUsername = :username AND q.type = :type")
    long countByUserUsernameAndType(@Param("username") String username, @Param("type") QueueType type);
    
    @Query("SELECT AVG(q.estimatedWaitTime) FROM Queue q WHERE q.userUsername = :username")
    Double averageWaitTimeByUserUsername(@Param("username") String username);
    
    @Query("SELECT q FROM Queue q WHERE q.userUsername = :username " +
           "AND q.createdAt BETWEEN :startDate AND :endDate " +
           "ORDER BY q.createdAt DESC")
    Page<Queue> findByUserUsernameAndDateRange(
        @Param("username") String username,
        @Param("startDate") LocalDateTime startDate,
        @Param("endDate") LocalDateTime endDate,
        Pageable pageable);

    @Query("SELECT q FROM Queue q WHERE q.createdAt BETWEEN :startDate AND :endDate")
    List<Queue> findByCreatedAtBetween(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);
    
    @Query("SELECT q FROM Queue q WHERE q.status = :status")
    List<Queue> findByStatus(@Param("status") QueueStatus status);
    
    @Query("SELECT q FROM Queue q WHERE q.user.username = :username AND q.status = :status")
    List<Queue> findByUserUsernameAndStatus(@Param("username") String username, @Param("status") QueueStatus status);

    List<Queue> findByStatusOrderByCreatedAtDesc(QueueStatus status);
    
    @Query("SELECT q FROM Queue q LEFT JOIN FETCH q.user u LEFT JOIN FETCH u.notificationSettings WHERE q.status = :status ORDER BY q.position ASC")
    Optional<Queue> findFirstByStatusOrderByPositionAsc(@Param("status") QueueStatus status);
    
    @Query("SELECT AVG(TIMESTAMPDIFF(SECOND, q.createdAt, q.processedAt)) FROM Queue q WHERE q.status = 'COMPLETED'")
    Double avgWaitTime();

    @Query("SELECT AVG(TIMESTAMPDIFF(SECOND, q.createdAt, q.processedAt)) FROM Queue q WHERE q.status = :status")
    Double avgWaitTimeByStatus(@Param("status") QueueStatus status);

    @Query("SELECT MAX(q.position) FROM Queue q")
    Optional<Integer> findMaxPosition();

    List<Queue> findByTypeOrderByCreatedAtDesc(PaymentType type);

    List<Queue> findByDescriptionContainingIgnoreCaseOrderByCreatedAtDesc(String description);

    List<Queue> findByEstimatedWaitTimeBetweenOrderByCreatedAtDesc(Integer minWaitTime, Integer maxWaitTime);

    List<Queue> findByProcessedAtBetweenOrderByCreatedAtDesc(LocalDateTime startDate, LocalDateTime endDate);

    @Query("SELECT COUNT(q) FROM Queue q WHERE q.type = :type")
    long countByType(@Param("type") PaymentType type);

    @Query("SELECT COUNT(q) FROM Queue q WHERE q.user.username = :username AND q.createdAt < (SELECT q2.createdAt FROM Queue q2 WHERE q2.user.username = :username AND q2.status = 'ACTIVE')")
    int getPositionByUsername(@Param("username") String username);

    @Query("SELECT q.status, COUNT(q) FROM Queue q GROUP BY q.status")
    List<Object[]> countByStatusGroupByStatus();
} 