package com.accounting.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.accounting.service.NotificationService;
import com.accounting.model.Notification;
import com.accounting.repository.NotificationRepository;
import com.accounting.repository.UserRepository;
import com.accounting.repository.QueueRepository;

import java.util.List;
import java.util.HashMap;
import java.util.Map;
import java.time.LocalDateTime;
import java.util.ArrayList;

@Service
public class NotificationServiceImpl implements NotificationService {

    @Autowired
    private NotificationRepository notificationRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private QueueRepository queueRepository;

    @Override
    public List<Notification> getSystemNotifications() {
        return notificationRepository.findByTypeOrderByCreatedAtDesc("SYSTEM");
    }

    @Override
    public int getUnreadNotificationCount() {
        return (int) notificationRepository.count();
    }

    @Override
    public void markNotificationAsRead(Long notificationId) {
        notificationRepository.findById(notificationId).ifPresent(n -> {
            n.setRead(true);
            n.setReadAt(LocalDateTime.now());
            notificationRepository.save(n);
        });
    }

    @Override
    public void createNotification(String message) {
        Notification notification = new Notification();
        notification.setMessage(message);
        notification.setType("SYSTEM");
        notification.setCreatedAt(LocalDateTime.now());
        notificationRepository.save(notification);
    }

    @Override
    public int getQueuePosition(String number) {
        return queueRepository.findQueuePosition(number);
    }

    @Override
    public List<Notification> getUserNotifications(String username) {
        return notificationRepository.findByUserUsernameOrderByCreatedAtDesc(username);
    }

    @Override
    public void subscribe(String username, String type, String queueNumber) {
        var user = userRepository.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
            
        var settings = user.getNotificationSettings();
        if (settings == null) {
            settings = new HashMap<>();
        }
        
        if (!settings.containsKey("subscriptions")) {
            settings.put("subscriptions", new HashMap<>());
        }
        
        @SuppressWarnings("unchecked")
        Map<String, Object> subscriptions = (Map<String, Object>) settings.get("subscriptions");
        subscriptions.put(type, queueNumber != null ? queueNumber : true);
        
        user.setNotificationSettings(settings);
        userRepository.save(user);
    }

    @Override
    public void unsubscribe(String username, String type) {
        var user = userRepository.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
            
        var settings = user.getNotificationSettings();
        if (settings != null && settings.containsKey("subscriptions")) {
            @SuppressWarnings("unchecked")
            Map<String, Object> subscriptions = (Map<String, Object>) settings.get("subscriptions");
            subscriptions.remove(type);
            user.setNotificationSettings(settings);
            userRepository.save(user);
        }
    }

    @Override
    public Object getNotificationSettings(String username) {
        return userRepository.findByUsername(username)
            .map(user -> user.getNotificationSettings())
            .orElse(new HashMap<>());
    }

    @Override
    @SuppressWarnings("unchecked")
    public void updateNotificationSettings(String username, Object settings) {
        var user = userRepository.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
            
        if (settings instanceof Map) {
            user.setNotificationSettings((Map<String, Object>) settings);
        } else {
            // If settings is not a Map, create a new map with a default key
            Map<String, Object> settingsMap = new HashMap<>();
            settingsMap.put("settings", settings);
            user.setNotificationSettings(settingsMap);
        }
        
        userRepository.save(user);
    }

    @Override
    public void markAsRead(List<Long> notificationIds, String username) {
        var notifications = notificationRepository.findAllById(notificationIds);
        notifications.forEach(n -> {
            if (n.getUser().getUsername().equals(username)) {
                n.setRead(true);
                n.setReadAt(LocalDateTime.now());
            }
        });
        notificationRepository.saveAll(notifications);
    }
} 