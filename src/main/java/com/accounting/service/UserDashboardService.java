package com.accounting.service;

import java.util.Map;
import java.util.List;
import com.accounting.model.Transaction;
import com.accounting.model.Notification;
import com.accounting.model.Document;

public interface UserDashboardService {
    
    /**
     * Get dashboard statistics
     */
    Map<String, Object> getDashboardStatistics();
    
    /**
     * Get recent transactions
     */
    List<Transaction> getRecentTransactions();
    
    /**
     * Get user notifications
     */
    List<Notification> getUserNotifications();
    
    /**
     * Get user documents
     */
    List<Document> getUserDocuments();
    
    /**
     * Get current balance
     */
    double getCurrentBalance(String username);
    
    /**
     * Get pending payments count
     */
    int getPendingPaymentsCount(String username);
    
    /**
     * Get queue position
     */
    int getQueuePosition(String username);
    
    /**
     * Get estimated wait time
     */
    int getEstimatedWaitTime(String username);

    /**
     * Get recent payments for a user
     */
    List<Map<String, Object>> getRecentPayments(String username);

    /**
     * Get recent documents for a user
     */
    List<Map<String, Object>> getRecentDocuments(String username);
} 