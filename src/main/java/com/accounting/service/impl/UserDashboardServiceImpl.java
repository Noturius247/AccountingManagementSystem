package com.accounting.service.impl;

import com.accounting.model.*;
import com.accounting.repository.*;
import com.accounting.service.UserDashboardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.time.LocalDateTime;
import java.util.stream.Collectors;

@Service
public class UserDashboardServiceImpl implements UserDashboardService {
    @Autowired
    private TransactionRepository transactionRepository;
    @Autowired
    private PaymentRepository paymentRepository;
    @Autowired
    private DocumentRepository documentRepository;
    @Autowired
    private QueueRepository queueRepository;
    @Autowired
    private NotificationRepository notificationRepository;

    @Override
    public Map<String, Object> getDashboardStatistics() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalTransactions", transactionRepository.count());
        stats.put("totalPayments", paymentRepository.count());
        stats.put("totalDocuments", documentRepository.count());
        stats.put("activeQueues", queueRepository.countByStatus("ACTIVE"));
        return stats;
    }

    @Override
    public List<Transaction> getRecentTransactions() {
        return transactionRepository.findTop5ByOrderByCreatedAtDesc();
    }

    @Override
    public List<Notification> getUserNotifications() {
        return notificationRepository.findTop5ByOrderByCreatedAtDesc();
    }

    @Override
    public List<Document> getUserDocuments() {
        return documentRepository.findTop5ByOrderByUploadedAtDesc();
    }

    @Override
    public double getCurrentBalance(String username) {
        return transactionRepository.sumAmountByUserUsername(username)
            .orElse(BigDecimal.ZERO).doubleValue();
    }

    @Override
    public int getPendingPaymentsCount(String username) {
        return paymentRepository.countPendingByUserUsername(username);
    }

    @Override
    public int getQueuePosition(String username) {
        return queueRepository.getPositionByUsername(username);
    }

    @Override
    public int getEstimatedWaitTime(String username) {
        return (int) queueRepository.countByStatusAndCreatedAtBefore("WAITING", LocalDateTime.now());
    }

    @Override
    public List<Map<String, Object>> getRecentPayments(String username) {
        return paymentRepository.findTop5ByUserUsernameOrderByCreatedAtDesc(username).stream()
                .map(payment -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("id", payment.getId());
                    map.put("description", payment.getDescription());
                    map.put("amount", payment.getAmount());
                    map.put("status", payment.getStatus());
                    map.put("createdAt", payment.getCreatedAt());
                    return map;
                })
                .collect(Collectors.toList());
    }

    @Override
    public List<Map<String, Object>> getRecentDocuments(String username) {
        return documentRepository.findTop5ByUserUsernameOrderByUploadedAtDesc(username).stream()
                .map(document -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("id", document.getId());
                    map.put("name", document.getFileName());
                    map.put("type", document.getType());
                    map.put("createdAt", document.getUploadedAt());
                    return map;
                })
                .collect(Collectors.toList());
    }
} 