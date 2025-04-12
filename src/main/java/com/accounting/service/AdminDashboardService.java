package com.accounting.service;

import java.util.Map;
import java.util.List;
import com.accounting.model.User;
import com.accounting.model.Transaction;
import java.time.LocalDateTime;
import java.math.BigDecimal;
import com.accounting.model.Payment;
import com.accounting.model.Queue;
import com.accounting.model.Notification;

public interface AdminDashboardService {
    
    /**
     * Get dashboard statistics
     */
    Map<String, Object> getDashboardStatistics();
    
    /**
     * Get recent users
     */
    List<User> getRecentUsers();
    
    /**
     * Get recent transactions
     */
    List<Transaction> getRecentTransactions();
    
    /**
     * Get total users count
     */
    long getTotalUsersCount();
    
    /**
     * Get total transactions count
     */
    long getTotalTransactionsCount();
    
    /**
     * Get total revenue
     */
    double getTotalRevenue();
    
    /**
     * Get pending transactions count
     */
    long getPendingTransactionsCount();
    
    Map<String, Object> getDailyReport();
    Map<String, Object> getMonthlyReport();
    boolean verifyReceipt(String receiptId);
    Map<String, Object> getSystemSettings();
    Map<String, Object> getDashboardStats();
    Map<String, Double> getRevenueStats();
    
    List<Map<String, Object>> getRecentActivity();
    
    Map<String, Long> getQueueStats();
    
    List<Map<String, Object>> getSystemAlerts();

    Map<String, Object> getTransactionStatistics(LocalDateTime startDate, LocalDateTime endDate);

    Map<String, Object> getPaymentStatistics(LocalDateTime startDate, LocalDateTime endDate);

    Map<String, Long> getCounts();

    Map<String, BigDecimal> getAmounts();

    List<Payment> getRecentPayments();

    List<Queue> getActiveQueues();

    List<Notification> getRecentNotifications();

    Map<String, Long> getStatusCounts();

    Map<String, BigDecimal> getDailyAmounts();

    Map<String, Long> getDailyCounts();

    List<Map<String, Object>> getRecentActivities();

    List<Transaction> searchTransactions(String search, String status);
} 