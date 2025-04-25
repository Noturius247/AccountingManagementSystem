package com.accounting.repository;

import com.accounting.model.Notification;
import com.accounting.model.enums.NotificationType;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.time.LocalDateTime;

@Repository
public interface NotificationRepository extends JpaRepository<Notification, Long> {
    List<Notification> findByNotificationTypeOrderByCreatedAtDesc(String notificationType);
    List<Notification> findByNotificationTypeAndUserUsernameOrderByCreatedAtDesc(String notificationType, String username);
    
    @Query("SELECT n FROM Notification n WHERE n.notificationType = :type AND n.user.username = :username ORDER BY n.createdAt DESC")
    List<Notification> findUserNotificationsByType(@Param("type") String type, @Param("username") String username);
    
    @Query("SELECT n.notificationType, COUNT(n) FROM Notification n GROUP BY n.notificationType")
    List<Object[]> countByType();
    
    @Query("SELECT n FROM Notification n WHERE n.user.username = ?1 AND n.notificationType = ?2 ORDER BY n.createdAt DESC")
    List<Notification> findByUsernameAndTypeOrderByCreatedAtDesc(String username, String type);
    
    List<Notification> findByStatusAndNotificationTypeOrderByCreatedAtDesc(String status, String notificationType);
    List<Notification> findByUserUsernameAndNotificationTypeOrderByCreatedAtDesc(String username, String notificationType);
    List<Notification> findByUserUsernameAndStatusAndNotificationTypeOrderByCreatedAtDesc(String username, String status, String notificationType);
    List<Notification> findByNotificationTypeAndMessageContainingIgnoreCaseOrderByCreatedAtDesc(String notificationType, String message);
    List<Notification> findByUserUsernameAndStatusAndNotificationTypeAndMessageContainingIgnoreCaseOrderByCreatedAtDesc(String username, String status, String notificationType, String message);

    @Query("SELECT n.status, n.notificationType, COUNT(n) FROM Notification n GROUP BY n.status, n.notificationType")
    List<Object[]> countByStatusAndType();

    @Query("SELECT n.user.username, n.notificationType, COUNT(n) FROM Notification n GROUP BY n.user.username, n.notificationType")
    List<Object[]> countByUserAndType();

    @Query("SELECT n.user.username, n.status, n.notificationType, COUNT(n) FROM Notification n GROUP BY n.user.username, n.status, n.notificationType")
    List<Object[]> countByUserAndStatusAndType();

    List<Notification> findByNotificationTypeAndCreatedAtBetweenOrderByCreatedAtDesc(String notificationType, LocalDateTime startDate, LocalDateTime endDate);
    List<Notification> findByUserUsernameAndNotificationTypeAndCreatedAtBetweenOrderByCreatedAtDesc(String username, String notificationType, LocalDateTime startDate, LocalDateTime endDate);
    List<Notification> findByStatusAndNotificationTypeAndCreatedAtBetweenOrderByCreatedAtDesc(String status, String notificationType, LocalDateTime startDate, LocalDateTime endDate);
    List<Notification> findByUserUsernameAndStatusAndNotificationTypeAndCreatedAtBetweenOrderByCreatedAtDesc(String username, String status, String notificationType, LocalDateTime startDate, LocalDateTime endDate);

    Page<Notification> findByNotificationType(String notificationType, Pageable pageable);
    Page<Notification> findByUserUsernameAndNotificationType(String username, String notificationType, Pageable pageable);
    Page<Notification> findByNotificationTypeAndStatus(String notificationType, String status, Pageable pageable);
    Page<Notification> findByNotificationTypeAndCreatedAtBetween(String notificationType, LocalDateTime startDate, LocalDateTime endDate, Pageable pageable);
    Page<Notification> findByUserUsernameAndNotificationTypeAndStatus(String username, String notificationType, String status, Pageable pageable);
    Page<Notification> findByUserUsernameAndNotificationTypeAndCreatedAtBetween(String username, String notificationType, LocalDateTime startDate, LocalDateTime endDate, Pageable pageable);
    Page<Notification> findByNotificationTypeAndStatusAndCreatedAtBetween(String notificationType, String status, LocalDateTime startDate, LocalDateTime endDate, Pageable pageable);

    @Query("SELECT n FROM Notification n ORDER BY n.createdAt DESC LIMIT 10")
    List<Notification> findTop10ByOrderByCreatedAtDesc();

    List<Notification> findTop5ByOrderByCreatedAtDesc();

    @Query("SELECT n FROM Notification n WHERE n.isSystemNotification = true ORDER BY n.createdAt DESC")
    List<Notification> findSystemNotifications();

    @Query("SELECT COUNT(n) FROM Notification n WHERE n.user.username = :username AND n.isRead = false")
    Long countUnreadByUsername(@Param("username") String username);

    @Query("SELECT n FROM Notification n WHERE n.user.username = :username ORDER BY n.createdAt DESC")
    List<Notification> findByUsernameOrderByCreatedAtDesc(@Param("username") String username);

    @Query("SELECT n FROM Notification n WHERE n.user.username = :username AND n.notificationType = :type ORDER BY n.createdAt DESC")
    List<Notification> findByUserUsernameAndTypeOrderByCreatedAtDesc(@Param("username") String username, @Param("type") String type);

    @Query("SELECT n FROM Notification n ORDER BY n.createdAt DESC")
    List<Notification> findTopByOrderByCreatedAtDesc(int limit);
} 