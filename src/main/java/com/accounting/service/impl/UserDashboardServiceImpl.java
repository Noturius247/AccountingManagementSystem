package com.accounting.service.impl;

import com.accounting.model.*;
import com.accounting.repository.*;
import com.accounting.service.UserDashboardService;
import com.accounting.model.enums.QueueStatus;
import com.accounting.model.enums.TransactionStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.time.LocalDateTime;
import java.util.stream.Collectors;
import java.util.Collections;

@Service
@Transactional
public class UserDashboardServiceImpl implements UserDashboardService {
    private static final Logger logger = LoggerFactory.getLogger(UserDashboardServiceImpl.class);

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
    @Transactional(readOnly = true)
    public Map<String, Object> getDashboardStatistics() {
        Map<String, Object> stats = new HashMap<>();
        try {
            stats.put("totalTransactions", transactionRepository.count());
            stats.put("totalPayments", paymentRepository.count());
            stats.put("totalDocuments", documentRepository.count());
            stats.put("activeQueues", queueRepository.countByStatus(QueueStatus.WAITING));
        } catch (Exception e) {
            logger.error("Error fetching dashboard statistics", e);
            stats.put("error", "Failed to load statistics");
        }
        return stats;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Transaction> getRecentTransactions() {
        try {
            return transactionRepository.findTop5ByOrderByCreatedAtDesc();
        } catch (Exception e) {
            logger.error("Error fetching recent transactions", e);
            return Collections.emptyList();
        }
    }

    @Override
    @Transactional(readOnly = true)
    public List<Notification> getUserNotifications() {
        try {
            return notificationRepository.findTop5ByOrderByCreatedAtDesc();
        } catch (Exception e) {
            logger.error("Error fetching user notifications", e);
            return Collections.emptyList();
        }
    }

    @Override
    @Transactional(readOnly = true)
    public List<Document> getUserDocuments() {
        try {
            return documentRepository.findTop5ByOrderByUploadedAtDesc();
        } catch (Exception e) {
            logger.error("Error fetching user documents", e);
            return Collections.emptyList();
        }
    }

    @Override
    @Transactional(readOnly = true)
    public double getCurrentBalance(String username) {
        try {
            return transactionRepository.sumAmountByUserUsername(username)
                .orElse(BigDecimal.ZERO).doubleValue();
        } catch (Exception e) {
            logger.error("Error fetching current balance for user: " + username, e);
            return 0.0;
        }
    }

    @Override
    @Transactional(readOnly = true)
    public int getPendingPaymentsCount(String username) {
        try {
            return paymentRepository.countPendingByUserUsername(username);
        } catch (Exception e) {
            logger.error("Error fetching pending payments count for user: " + username, e);
            return 0;
        }
    }

    @Override
    @Transactional(readOnly = true)
    public int getQueuePosition(String username) {
        try {
            return queueRepository.getPositionByUsername(username);
        } catch (Exception e) {
            logger.error("Error fetching queue position for user: " + username, e);
            return -1;
        }
    }

    @Override
    @Transactional(readOnly = true)
    public int getEstimatedWaitTime(String username) {
        try {
            return (int) queueRepository.countByStatusAndCreatedAtBefore(QueueStatus.WAITING, LocalDateTime.now());
        } catch (Exception e) {
            logger.error("Error fetching estimated wait time for user: " + username, e);
            return -1;
        }
    }

    @Override
    @Transactional(readOnly = true)
    public List<Map<String, Object>> getRecentPayments(String username) {
        try {
            return paymentRepository.findTop5ByUserUsernameOrderByCreatedAtDesc(username).stream()
                    .map(payment -> {
                        Map<String, Object> map = new HashMap<>();
                        map.put("id", payment.getId());
                        map.put("description", payment.getDescription());
                        map.put("amount", payment.getAmount());
                        map.put("status", payment.getPaymentStatus().toString());
                        map.put("createdAt", payment.getCreatedAt());
                        return map;
                    })
                    .collect(Collectors.toList());
        } catch (Exception e) {
            logger.error("Error fetching recent payments for user: " + username, e);
            return Collections.emptyList();
        }
    }

    @Override
    @Transactional(readOnly = true)
    public List<Map<String, Object>> getRecentDocuments(String username) {
        try {
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
        } catch (Exception e) {
            logger.error("Error fetching recent documents for user: " + username, e);
            return Collections.emptyList();
        }
    }

    @Override
    @Transactional(readOnly = true)
    public boolean verifyReceipt(String receiptId, String username) {
        try {
            return transactionRepository.existsByReceiptIdAndUserUsername(receiptId, username);
        } catch (Exception e) {
            logger.error("Error verifying receipt: " + receiptId + " for user: " + username, e);
            return false;
        }
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getUserProfile(String username) {
        try {
            Map<String, Object> profile = new HashMap<>();
            // Add user profile information
            profile.put("username", username);
            profile.put("email", "user@example.com"); // This should come from User entity
            profile.put("phone", "1234567890"); // This should come from User entity
            profile.put("lastActivity", LocalDateTime.now()); // This should come from User entity
            return profile;
        } catch (Exception e) {
            logger.error("Error fetching user profile for user: " + username, e);
            return Collections.emptyMap();
        }
    }

    @Override
    @Transactional(readOnly = true)
    public double getTotalSpentAmount(String username) {
        try {
            return transactionRepository.findByUserUsernameAndStatus(username, TransactionStatus.COMPLETED)
                .stream()
                .map(t -> t.getAmount().doubleValue())
                .mapToDouble(Double::doubleValue)
                .sum();
        } catch (Exception e) {
            logger.error("Error calculating total spent amount for user: " + username, e);
            return 0.0;
        }
    }
} 