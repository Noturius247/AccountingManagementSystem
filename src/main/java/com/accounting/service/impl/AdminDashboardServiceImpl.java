package com.accounting.service.impl;

import com.accounting.service.AdminDashboardService;
import com.accounting.repository.UserRepository;
import com.accounting.repository.TransactionRepository;
import com.accounting.repository.PaymentRepository;
import com.accounting.repository.QueueRepository;
import com.accounting.repository.NotificationRepository;
import com.accounting.model.User;
import com.accounting.model.Transaction;
import com.accounting.model.Payment;
import com.accounting.model.Queue;
import com.accounting.model.Notification;
import com.accounting.model.enums.PaymentStatus;
import com.accounting.model.enums.QueueStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Collections;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.math.BigDecimal;
import java.util.stream.Collectors;
import java.util.ArrayList;
import org.springframework.transaction.annotation.Transactional;
import com.accounting.model.enums.TransactionStatus;
import java.util.Optional;
import org.springframework.security.core.context.SecurityContextHolder;

@Service
@Transactional
public class AdminDashboardServiceImpl implements AdminDashboardService {

    private static final Logger logger = LoggerFactory.getLogger(AdminDashboardServiceImpl.class);

    private final TransactionRepository transactionRepository;
    private final UserRepository userRepository;
    private final PaymentRepository paymentRepository;
    private final QueueRepository queueRepository;
    private final NotificationRepository notificationRepository;

    @Autowired
    public AdminDashboardServiceImpl(
            TransactionRepository transactionRepository,
            UserRepository userRepository,
            PaymentRepository paymentRepository,
            QueueRepository queueRepository,
            NotificationRepository notificationRepository) {
        this.transactionRepository = transactionRepository;
        this.userRepository = userRepository;
        this.paymentRepository = paymentRepository;
        this.queueRepository = queueRepository;
        this.notificationRepository = notificationRepository;
    }

    @Override
    public Map<String, Object> getDashboardStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalUsers", userRepository.count());
        stats.put("totalTransactions", transactionRepository.count());
        stats.put("totalPayments", paymentRepository.count());
        stats.put("activeQueues", queueRepository.countByStatus(QueueStatus.WAITING));
        return stats;
    }

    @Override
    public Map<String, Double> getRevenueStats() {
        Map<String, Double> revenue = new HashMap<>();
        revenue.put("totalRevenue", transactionRepository.sumAmount().orElse(BigDecimal.ZERO).doubleValue());
        revenue.put("averageTransaction", transactionRepository.averageAmount().orElse(BigDecimal.ZERO).doubleValue());
        revenue.put("pendingAmount", transactionRepository.sumAmountByStatus(TransactionStatus.PENDING).orElse(BigDecimal.ZERO).doubleValue());
        return revenue;
    }

    @Override
    public List<Map<String, Object>> getRecentActivity() {
        return transactionRepository.findTop10ByOrderByCreatedAtDesc()
            .stream()
            .map(this::convertTransactionToMap)
            .collect(Collectors.toList());
    }

    @Override
    public Map<String, Long> getQueueStats() {
        Map<String, Long> stats = new HashMap<>();
        stats.put("waiting", queueRepository.countByStatus(QueueStatus.WAITING));
        stats.put("processing", queueRepository.countByStatus(QueueStatus.PROCESSING));
        stats.put("completed", queueRepository.countByStatus(QueueStatus.COMPLETED));
        return stats;
    }

    @Override
    public List<Map<String, Object>> getSystemAlerts() {
        return List.of(); // TODO: Implement system alerts
    }

    private Map<String, Object> convertTransactionToMap(Transaction transaction) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", transaction.getId());
        map.put("notes", transaction.getNotes());
        map.put("amount", transaction.getAmount());
        map.put("status", transaction.getStatus());
        map.put("createdAt", transaction.getCreatedAt());
        return map;
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getDashboardStatistics() {
        logger.info("Fetching dashboard statistics");
        Map<String, Object> stats = new HashMap<>();
        
        // Transaction statistics
        stats.put("totalTransactions", transactionRepository.count());
        stats.put("totalTransactionAmount", 
            transactionRepository.sumAmount().orElse(BigDecimal.ZERO));
        
        // User statistics
        stats.put("totalUsers", userRepository.count());
        stats.put("activeUsers", userRepository.countByEnabled(true));
        
        // Payment statistics
        stats.put("totalPayments", paymentRepository.count());
        stats.put("pendingPayments", paymentRepository.countByStatus(PaymentStatus.PENDING));
        
        logger.info("Successfully fetched dashboard statistics");
        return stats;
    }

    @Override
    @Transactional(readOnly = true)
    public List<User> getRecentUsers() {
        return userRepository.findTop10ByOrderByCreatedAtDesc();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Transaction> getRecentTransactions() {
        return transactionRepository.findTop10ByOrderByCreatedAtDesc();
    }

    @Override
    public long getTotalUsersCount() {
        logger.info("Fetching total users count");
        try {
            long count = userRepository.count();
            logger.debug("Total users count: {}", count);
            return count;
        } catch (Exception e) {
            logger.error("Error fetching total users count: {}", e.getMessage(), e);
            return 0;
        }
    }

    @Override
    public long getTotalTransactionsCount() {
        logger.info("Fetching total transactions count");
        try {
            long count = transactionRepository.count();
            logger.debug("Total transactions count: {}", count);
            return count;
        } catch (Exception e) {
            logger.error("Error fetching total transactions count: {}", e.getMessage(), e);
            return 0;
        }
    }

    @Override
    public double getTotalRevenue() {
        logger.info("Fetching total revenue");
        try {
            BigDecimal revenue = transactionRepository.sumAmountByStatus(TransactionStatus.COMPLETED).orElse(BigDecimal.ZERO);
            double result = revenue.doubleValue();
            logger.debug("Total revenue: {}", result);
            return result;
        } catch (Exception e) {
            logger.error("Error fetching total revenue: {}", e.getMessage(), e);
            return 0.0;
        }
    }

    @Override
    public long getPendingTransactionsCount() {
        logger.info("Fetching pending transactions count");
        try {
            long count = transactionRepository.countByStatus(TransactionStatus.PENDING);
            logger.debug("Pending transactions count: {}", count);
            return count;
        } catch (Exception e) {
            logger.error("Error fetching pending transactions count: {}", e.getMessage(), e);
            return 0;
        }
    }

    @Override
    public Map<String, Object> getDailyReport() {
        logger.info("Fetching daily report");
        Map<String, Object> report = new HashMap<>();
        try {
            LocalDateTime startOfDay = LocalDate.now().atStartOfDay();
            LocalDateTime endOfDay = LocalDate.now().atTime(23, 59, 59);
            
            report.put("totalTransactions", transactionRepository.countByCreatedAtBetween(startOfDay, endOfDay));
            report.put("totalAmount", transactionRepository.sumAmountByCreatedAtBetween(startOfDay, endOfDay));
            report.put("completedTransactions", transactionRepository.countByStatusAndCreatedAtBetween(TransactionStatus.COMPLETED, startOfDay, endOfDay));
            report.put("pendingTransactions", transactionRepository.countByStatusAndCreatedAtBetween(TransactionStatus.PENDING, startOfDay, endOfDay));
            
            logger.debug("Daily report: {}", report);
            return report;
        } catch (Exception e) {
            logger.error("Error fetching daily report: {}", e.getMessage(), e);
            return Collections.emptyMap();
        }
    }

    @Override
    public Map<String, Object> getMonthlyReport() {
        logger.info("Fetching monthly report");
        Map<String, Object> report = new HashMap<>();
        try {
            YearMonth currentMonth = YearMonth.now();
            LocalDateTime startOfMonth = currentMonth.atDay(1).atStartOfDay();
            LocalDateTime endOfMonth = currentMonth.atEndOfMonth().atTime(23, 59, 59);
            
            report.put("totalTransactions", transactionRepository.countByCreatedAtBetween(startOfMonth, endOfMonth));
            report.put("totalAmount", transactionRepository.sumAmountByCreatedAtBetween(startOfMonth, endOfMonth));
            report.put("completedTransactions", transactionRepository.countByStatusAndCreatedAtBetween(TransactionStatus.COMPLETED, startOfMonth, endOfMonth));
            report.put("pendingTransactions", transactionRepository.countByStatusAndCreatedAtBetween(TransactionStatus.PENDING, startOfMonth, endOfMonth));
            
            logger.debug("Monthly report: {}", report);
            return report;
        } catch (Exception e) {
            logger.error("Error fetching monthly report: {}", e.getMessage(), e);
            return Collections.emptyMap();
        }
    }

    @Override
    public boolean verifyReceipt(String receiptId) {
        logger.info("Verifying receipt: {}", receiptId);
        try {
            return transactionRepository.existsByReceiptId(receiptId);
        } catch (Exception e) {
            logger.error("Error verifying receipt: {}", e.getMessage(), e);
            return false;
        }
    }

    @Override
    public Map<String, Object> getSystemSettings() {
        logger.info("Fetching system settings");
        Map<String, Object> settings = new HashMap<>();
        try {
            // Add system settings here
            settings.put("maxConcurrentTransactions", 100);
            settings.put("transactionTimeoutMinutes", 30);
            settings.put("autoLogoutMinutes", 15);
            settings.put("maxFileSizeMB", 10);
            settings.put("allowedFileTypes", new String[]{"pdf", "jpg", "png"});
            
            logger.debug("System settings: {}", settings);
            return settings;
        } catch (Exception e) {
            logger.error("Error fetching system settings: {}", e.getMessage(), e);
            return Collections.emptyMap();
        }
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getTransactionStatistics(LocalDateTime startDate, LocalDateTime endDate) {
        Map<String, Object> stats = new HashMap<>();
        
        // Transaction counts by status
        stats.put("completedTransactions", 
            transactionRepository.countByStatusAndCreatedAtBetween(TransactionStatus.COMPLETED, startDate, endDate));
        stats.put("pendingTransactions", 
            transactionRepository.countByStatusAndCreatedAtBetween(TransactionStatus.PENDING, startDate, endDate));
        stats.put("failedTransactions", 
            transactionRepository.countByStatusAndCreatedAtBetween(TransactionStatus.FAILED, startDate, endDate));
        
        // Transaction amounts
        stats.put("totalAmount", 
            transactionRepository.sumAmountByCreatedAtBetween(startDate, endDate));
        
        // Initialize collections for the current user
        User currentUser = userRepository.findByUsername(SecurityContextHolder.getContext().getAuthentication().getName())
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        // Initialize all collections
        if (currentUser.getNotificationSettings() != null) {
            currentUser.getNotificationSettings().size();
        }
        if (currentUser.getTransactions() != null) {
            currentUser.getTransactions().size();
        }
        if (currentUser.getDocuments() != null) {
            currentUser.getDocuments().size();
        }
        if (currentUser.getNotifications() != null) {
            currentUser.getNotifications().size();
        }
        
        return stats;
    }

    @Override
    public Map<String, Object> getPaymentStatistics(LocalDateTime startDate, LocalDateTime endDate) {
        Map<String, Object> stats = new HashMap<>();
        
        // Payment counts by status and type
        List<Object[]> statusTypeCounts = paymentRepository.countByStatusAndType();
        for (Object[] count : statusTypeCounts) {
            String status = (String) count[0];
            String type = (String) count[1];
            Long countValue = (Long) count[2];
            stats.put(status + "_" + type + "_count", countValue);
        }
        
        // Payment amounts
        stats.put("totalAmount", 
            paymentRepository.sumAmountByDescriptionContainingOrStatusContaining("")
                .orElse(BigDecimal.ZERO).doubleValue());
        
        return stats;
    }

    @Override
    public Map<String, Long> getCounts() {
        Map<String, Long> counts = new HashMap<>();
        counts.put("users", userRepository.count());
        counts.put("transactions", transactionRepository.count());
        counts.put("payments", paymentRepository.count());
        counts.put("queues", queueRepository.count());
        return counts;
    }

    @Override
    public Map<String, BigDecimal> getAmounts() {
        Map<String, BigDecimal> amounts = new HashMap<>();
        amounts.put("totalTransactions", transactionRepository.sumAmount().orElse(BigDecimal.ZERO));
        amounts.put("totalPayments", paymentRepository.sumAmount().orElse(BigDecimal.ZERO));
        amounts.put("averageTransaction", transactionRepository.averageAmount().orElse(BigDecimal.ZERO));
        return amounts;
    }

    @Override
    public List<Payment> getRecentPayments() {
        return paymentRepository.findTop10ByOrderByCreatedAtDesc();
    }

    @Override
    public List<Queue> getActiveQueues() {
        return queueRepository.findByStatus(QueueStatus.WAITING);
    }

    @Override
    public List<Notification> getRecentNotifications() {
        return notificationRepository.findTop10ByOrderByCreatedAtDesc();
    }

    @Override
    public Map<String, Long> getStatusCounts() {
        Map<String, Long> counts = new HashMap<>();
        counts.put("pendingTransactions", transactionRepository.countByStatus(TransactionStatus.PENDING));
        counts.put("completedTransactions", transactionRepository.countByStatus(TransactionStatus.COMPLETED));
        counts.put("failedTransactions", transactionRepository.countByStatus(TransactionStatus.FAILED));
        counts.put("activeQueues", queueRepository.countByStatus(QueueStatus.WAITING));
        counts.put("waitingQueues", queueRepository.countByStatus(QueueStatus.WAITING));
        return counts;
    }

    @Override
    public Map<String, BigDecimal> getDailyAmounts() {
        Map<String, BigDecimal> amounts = new HashMap<>();
        amounts.put("todayTransactions", transactionRepository.sumAmountToday().orElse(BigDecimal.ZERO));
        amounts.put("todayPayments", paymentRepository.sumAmountToday().orElse(BigDecimal.ZERO));
        return amounts;
    }

    @Override
    public Map<String, Long> getDailyCounts() {
        Map<String, Long> counts = new HashMap<>();
        counts.put("todayTransactions", transactionRepository.countToday());
        counts.put("todayPayments", paymentRepository.countToday());
        counts.put("todayUsers", userRepository.countToday());
        return counts;
    }

    @Override
    public List<Map<String, Object>> getRecentActivities() {
        List<Map<String, Object>> activities = new ArrayList<>();
        
        // Add recent transactions
        transactionRepository.findTop5ByOrderByCreatedAtDesc().forEach(t -> {
            Map<String, Object> activity = new HashMap<>();
            activity.put("type", "Transaction");
            activity.put("id", t.getId());
            activity.put("description", t.getNotes());
            activity.put("amount", t.getAmount());
            activity.put("createdAt", t.getCreatedAt());
            activities.add(activity);
        });

        // Add recent payments
        paymentRepository.findTop5ByOrderByCreatedAtDesc().forEach(p -> {
            Map<String, Object> activity = new HashMap<>();
            activity.put("type", "Payment");
            activity.put("id", p.getId());
            activity.put("description", p.getDescription());
            activity.put("amount", p.getAmount());
            activity.put("createdAt", p.getCreatedAt());
            activities.add(activity);
        });

        // Sort by createdAt
        activities.sort((a, b) -> ((LocalDateTime) b.get("createdAt")).compareTo((LocalDateTime) a.get("createdAt")));
        
        return activities;
    }

    @Override
    public List<Transaction> searchTransactions(String search, String status) {
        if (search != null && !search.isEmpty()) {
            if (status != null && !status.isEmpty()) {
                return transactionRepository.findByNotesContainingAndStatus(search, TransactionStatus.valueOf(status.toUpperCase()));
            }
            return transactionRepository.findByNotesContaining(search);
        } else if (status != null && !status.isEmpty()) {
            return transactionRepository.findByStatus(TransactionStatus.valueOf(status.toUpperCase()));
        }
        return transactionRepository.findTop10ByOrderByCreatedAtDesc();
    }

    @Override
    public double getTransactionAmountByStatus(String status) {
        Optional<BigDecimal> amount = transactionRepository.sumAmountByStatus(TransactionStatus.valueOf(status));
        return amount.map(BigDecimal::doubleValue).orElse(0.0);
    }

    @Override
    public long getTransactionCountByStatus(String status) {
        return transactionRepository.countByStatus(TransactionStatus.valueOf(status));
    }
} 