package com.accounting.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.accounting.model.Notification;
import java.util.List;

@Repository
public interface NotificationRepository extends JpaRepository<Notification, Long> {
    
    /**
     * Find notifications by user's username ordered by creation date
     */
    List<Notification> findByUserUsernameOrderByCreatedAtDesc(String username);
    
    /**
     * Find notifications by type ordered by creation date
     */
    List<Notification> findByTypeOrderByCreatedAtDesc(String type);
    
    /**
     * Find unread notifications for a user
     */
    List<Notification> findByUserUsernameAndReadFalseOrderByCreatedAtDesc(String username);
    
    /**
     * Count unread notifications for a user
     */
    long countByUserUsernameAndReadFalse(String username);
} 