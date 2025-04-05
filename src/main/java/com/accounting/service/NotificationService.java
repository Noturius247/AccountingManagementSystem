package com.accounting.service;

import com.accounting.model.Notification;
import java.util.List;

public interface NotificationService {
    
    /**
     * Get system-wide notifications
     */
    List<Notification> getSystemNotifications();

    /**
     * Get count of unread notifications
     */
    int getUnreadNotificationCount();

    /**
     * Mark a notification as read
     */
    void markNotificationAsRead(Long notificationId);

    /**
     * Create a new notification
     */
    void createNotification(String message);
    
    /**
     * Get queue position for a number
     */
    int getQueuePosition(String number);
    
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
    void updateNotificationSettings(String username, Object settings);
    
    /**
     * Mark notifications as read
     */
    void markAsRead(List<Long> notificationIds, String username);
} 