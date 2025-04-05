package com.accounting.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import com.accounting.service.NotificationService;
import com.accounting.model.Notification;
import java.util.List;

@RestController
@RequestMapping("/api/notifications")
public class NotificationController {

    @Autowired
    private NotificationService notificationService;

    @GetMapping("/queue/{number}")
    public int getQueuePosition(@PathVariable String number) {
        return notificationService.getQueuePosition(number);
    }

    @GetMapping("/user")
    public List<Notification> getUserNotifications(Authentication auth) {
        return notificationService.getUserNotifications(auth.getName());
    }

    @PostMapping("/subscribe")
    public void subscribeToNotifications(
            @RequestParam String type,
            @RequestParam(required = false) String queueNumber,
            Authentication auth) {
        notificationService.subscribe(auth.getName(), type, queueNumber);
    }

    @PostMapping("/unsubscribe")
    public void unsubscribeFromNotifications(
            @RequestParam String type,
            Authentication auth) {
        notificationService.unsubscribe(auth.getName(), type);
    }

    @GetMapping("/settings")
    public Object getNotificationSettings(Authentication auth) {
        return notificationService.getNotificationSettings(auth.getName());
    }

    @PostMapping("/settings")
    public void updateNotificationSettings(
            @RequestBody Object settings,
            Authentication auth) {
        notificationService.updateNotificationSettings(auth.getName(), settings);
    }

    @PostMapping("/mark-read")
    public void markNotificationsAsRead(
            @RequestBody List<Long> notificationIds,
            Authentication auth) {
        notificationService.markAsRead(notificationIds, auth.getName());
    }
} 