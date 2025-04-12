package com.accounting.service.impl;

import com.accounting.model.Notification;
import com.accounting.model.Queue;
import com.accounting.model.User;
import com.accounting.repository.NotificationRepository;
import com.accounting.repository.QueueRepository;
import com.accounting.repository.UserRepository;
import com.accounting.service.NotificationService;
import jakarta.persistence.EntityNotFoundException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Stream;

@Service
@Transactional
@Slf4j
public class NotificationServiceImpl implements NotificationService {
    private final NotificationRepository notificationRepository;
    private final UserRepository userRepository;
    private final QueueRepository queueRepository;

    @Autowired
    public NotificationServiceImpl(
            NotificationRepository notificationRepository,
            UserRepository userRepository,
            QueueRepository queueRepository) {
        this.notificationRepository = notificationRepository;
        this.userRepository = userRepository;
        this.queueRepository = queueRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Notification> getSystemNotifications() {
        log.debug("Getting system notifications");
        return notificationRepository.findSystemNotifications();
    }

    @Override
    @Transactional(readOnly = true)
    public long getUnreadNotificationCount(String username) {
        log.debug("Getting unread notification count for user: {}", username);
        if (!StringUtils.hasText(username)) {
            throw new IllegalArgumentException("Username cannot be empty");
        }
        return notificationRepository.countUnreadByUsername(username);
    }

    @Override
    @Transactional
    public void markNotificationAsRead(Long notificationId) {
        log.debug("Marking notification as read: {}", notificationId);
        if (notificationId == null) {
            throw new IllegalArgumentException("Notification ID cannot be null");
        }
        Notification notification = notificationRepository.findById(notificationId)
                .orElseThrow(() -> new RuntimeException("Notification not found with id: " + notificationId));
        notification.setRead(true);
        notificationRepository.save(notification);
    }

    @Override
    @Transactional
    public void createNotification(String message) {
        log.debug("Creating new notification with message: {}", message);
        if (!StringUtils.hasText(message)) {
            throw new IllegalArgumentException("Notification message cannot be empty");
        }
        Notification notification = new Notification();
        notification.setMessage(message);
        notification.setCreatedAt(LocalDateTime.now());
        notification.setRead(false);
        notificationRepository.save(notification);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Notification> getUserNotifications(String username) {
        log.debug("Getting notifications for user: {}", username);
        if (!StringUtils.hasText(username)) {
            throw new IllegalArgumentException("Username cannot be empty");
        }
        return notificationRepository.findByUsernameOrderByCreatedAtDesc(username);
    }

    @Override
    @Transactional
    public void subscribe(String username, String type, String queueNumber) {
        log.debug("Subscribing user {} to notifications of type {} for queue {}", username, type, queueNumber);
        if (!StringUtils.hasText(username) || !StringUtils.hasText(type) || !StringUtils.hasText(queueNumber)) {
            throw new IllegalArgumentException("Username, type and queue number cannot be empty");
        }
        Notification notification = new Notification();
        notification.setMessage("Subscribed to " + type + " notifications for queue " + queueNumber);
        notification.setNotificationType(type);
        notification.setUser(userRepository.findByUsername(username)
            .orElseThrow(() -> new EntityNotFoundException("User not found")));
        notification.setCreatedAt(LocalDateTime.now());
        notification.setRead(false);
        notificationRepository.save(notification);
    }

    @Override
    @Transactional
    public void unsubscribe(String username, String type) {
        log.debug("Unsubscribing user {} from notifications of type {}", username, type);
        if (!StringUtils.hasText(username) || !StringUtils.hasText(type)) {
            throw new IllegalArgumentException("Username and type cannot be empty");
        }
        // Implementation depends on your subscription mechanism
        // This is just a placeholder
        List<Notification> notifications = notificationRepository.findByUserUsernameAndTypeOrderByCreatedAtDesc(username, type);
        notificationRepository.deleteAll(notifications);
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getNotificationSettings(String username) {
        log.debug("Getting notification settings for user: {}", username);
        if (!StringUtils.hasText(username)) {
            throw new IllegalArgumentException("Username cannot be empty");
        }
        List<Notification> notifications = notificationRepository.findTopByOrderByCreatedAtDesc(1);
        if (notifications.isEmpty()) {
            throw new RuntimeException("No notification settings found for user: " + username);
        }
        Notification notification = notifications.get(0);
        return notification.getSettings();
    }

    @Override
    @Transactional
    public void updateNotificationSettings(String username, Map<String, Object> settings) {
        log.debug("Updating notification settings for user: {} with settings: {}", username, settings);
        if (!StringUtils.hasText(username)) {
            throw new IllegalArgumentException("Username cannot be empty");
        }
        if (settings == null || settings.isEmpty()) {
            throw new IllegalArgumentException("Settings cannot be null or empty");
        }
        List<Notification> notifications = notificationRepository.findTopByOrderByCreatedAtDesc(1);
        if (notifications.isEmpty()) {
            throw new RuntimeException("No notification settings found for user: " + username);
        }
        Notification notification = notifications.get(0);
        notification.setSettings(settings);
        notificationRepository.save(notification);
    }

    @Override
    @Transactional
    public void markAsRead(List<Long> notificationIds, String username) {
        log.debug("Marking notifications as read for user: {} with ids: {}", username, notificationIds);
        if (!StringUtils.hasText(username)) {
            throw new IllegalArgumentException("Username cannot be empty");
        }
        if (notificationIds == null || notificationIds.isEmpty()) {
            throw new IllegalArgumentException("Notification IDs cannot be null or empty");
        }
        List<Notification> notifications = notificationRepository.findAllById(notificationIds);
        for (Notification notification : notifications) {
            if (!notification.getUser().getUsername().equals(username)) {
                throw new RuntimeException("User " + username + " does not have permission to mark notification " + notification.getId() + " as read");
            }
            notification.setRead(true);
        }
        notificationRepository.saveAll(notifications);
    }

    @Override
    public int getQueuePosition(String queueNumber) {
        Queue queue = queueRepository.findByQueueNumber(queueNumber)
            .orElseThrow(() -> new EntityNotFoundException("Queue not found"));
        return queue.getPosition();
    }
} 