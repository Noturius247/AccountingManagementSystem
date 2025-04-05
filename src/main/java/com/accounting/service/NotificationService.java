package com.accounting.service;

import org.springframework.stereotype.Service;
import com.accounting.model.Notification;
import java.util.ArrayList;
import java.util.List;
import java.util.Date;

@Service
public class NotificationService {
    
    public List<Notification> getSystemNotifications() {
        List<Notification> notifications = new ArrayList<>();
        
        // Create mock notifications
        Notification n1 = new Notification();
        n1.setId(1L);
        n1.setTitle("System Update");
        n1.setMessage("Welcome to the Accounting System");
        n1.setType("INFO");
        n1.setPriority("LOW");
        n1.setTime(new Date());
        notifications.add(n1);
        
        Notification n2 = new Notification();
        n2.setId(2L);
        n2.setTitle("New Feature");
        n2.setMessage("Check out our new dashboard features!");
        n2.setType("SUCCESS");
        n2.setPriority("MEDIUM");
        n2.setTime(new Date());
        notifications.add(n2);
        
        return notifications;
    }

    public int getUnreadNotificationCount() {
        return 2; // Mock value
    }

    public void markNotificationAsRead(Long notificationId) {
        // Mock implementation
    }

    public void createNotification(String message) {
        // Mock implementation
    }
} 