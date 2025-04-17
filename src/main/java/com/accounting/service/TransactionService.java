package com.accounting.service;

import com.accounting.model.Transaction;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

public interface TransactionService {
    
    int getActiveQueueCount();

    int getCompletedQueueCount();

    int getFailedQueueCount();

    int getCancelledQueueCount();

    BigDecimal getTotalRevenue();

    int getTotalTransactions();

    int getTotalPendingTransactions();

    int getTotalFailedTransactions();

    int getTodayTransactionCount();

    double getTodayTotalAmount();

    int getPendingApprovalCount();

    int getHighPriorityCount();

    int getActiveUserCount();

    int getOnlineUserCount();

    List<Transaction> getRecentTransactions(int limit);

    /**
     * Get all transactions for the current day
     */
    List<Transaction> getDailyTransactions();
    
    /**
     * Get transactions between two dates
     */
    List<Transaction> getTransactionsByDateRange(String startDate, String endDate);
    
    /**
     * Create a new transaction
     */
    Transaction createTransaction(Transaction transaction);
    
    /**
     * Get transaction by ID
     */
    Transaction getTransactionById(Long id);
    
    /**
     * Update transaction status
     */
    Transaction updateTransactionStatus(Long id, String status);
    
    /**
     * Delete transaction
     */
    void deleteTransaction(Long id);

    List<Transaction> getAllTransactions();
    Transaction getTransaction(Long id);
    Transaction updateTransaction(Long id, Transaction transaction);
    List<Transaction> getTransactionsByUser(Long userId);
    Map<String, Object> getTransactionStatistics();
    BigDecimal getTotalAmount(String query);

    Transaction updateTransaction(Transaction transaction);
    List<Transaction> getTransactionsByUser(String username);
    List<Transaction> getTransactionsByStatus(String status);
    List<Transaction> getTransactionsByType(String type);
    List<Transaction> getTransactionsByPriority(String priority);
    List<Transaction> getTransactionsByDescription(String description);
    List<Transaction> getTransactionsByAmount(Double minAmount, Double maxAmount);
    List<Transaction> getTransactionsByDateRange(LocalDateTime start, LocalDateTime end);
    long getTransactionCount();
    long getTransactionCountByUser(String username);
    long getTransactionCountByStatus(String status);
    long getTransactionCountByType(String type);
    long getTransactionCountByPriority(String priority);
    double getTransactionAmount();
    double getTransactionAmountByUser(String username);
    double getTransactionAmountByStatus(String status);
    double getTransactionAmountByType(String type);
    double getTransactionAmountByPriority(String priority);
    Map<String, Long> getTransactionCountByType();
    Map<String, Long> getTransactionCountByStatus();
    Map<String, Long> getTransactionCountByPriority();
    List<Object[]> getTransactionCountByTypeAndDateRange(LocalDateTime start, LocalDateTime end);
    List<Transaction> getTransactionsByNotes(String notes);
} 