package com.accounting.service;

import com.accounting.model.Notification;
import java.util.List;
import java.util.Map;

public interface NotificationService {
    
    /**
     * Get system-wide notifications
     */
    List<Notification> getSystemNotifications();

    /**
     * Get count of unread notifications for a user
     */
    long getUnreadNotificationCount(String username);

    /**
     * Mark a notification as read
     */
    void markNotificationAsRead(Long notificationId);

    /**
     * Create a new notification
     */
    void createNotification(String message);
    
    /**
     * Get notifications for a specific user
     */
    List<Notification> getUserNotifications(String username);
    
    /**
     * Subscribe a user to notifications
     */
    void subscribe(String username, String type, String queueNumber);
    
    /**
     * Unsubscribe a user from notifications
     */
    void unsubscribe(String username, String type);
    
    /**
     * Get notification settings for a user
     */
    Object getNotificationSettings(String username);
    
    /**
     * Update notification settings for a user
     */
    void updateNotificationSettings(String username, Map<String, Object> settings);
    
    /**
     * Mark notifications as read
     */
    void markAsRead(List<Long> notificationIds, String username);

    int getQueuePosition(String queueNumber);
} 