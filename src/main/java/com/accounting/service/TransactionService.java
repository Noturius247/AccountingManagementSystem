package com.accounting.service;

import com.accounting.model.Transaction;
import com.accounting.model.User;
import com.accounting.model.enums.TransactionStatus;
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
    
    Transaction getTransactionByIdWithUser(Long id);
    
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
    List<Transaction> getTransactionsByDescription(String description);
    List<Transaction> getTransactionsByAmount(Double minAmount, Double maxAmount);
    List<Transaction> getTransactionsByDateRange(LocalDateTime start, LocalDateTime end);
    long getTransactionCount();
    long getTransactionCountByUser(String username);
    long getTransactionCountByStatus(String status);
    long getTransactionCountByType(String type);
    double getTransactionAmount();
    double getTransactionAmountByUser(String username);
    double getTransactionAmountByStatus(String status);
    double getTransactionAmountByType(String type);
    Map<String, Long> getTransactionCountByType();
    Map<String, Long> getTransactionCountByStatus();
    List<Object[]> getTransactionCountByTypeAndDateRange(LocalDateTime start, LocalDateTime end);
    List<Transaction> getTransactionsByNotes(String notes);

    double getCurrentBalance(Long studentId);
    double getLastPaymentAmount(Long studentId);
    String getNextDueDate(Long studentId);
    List<Transaction> getRecentTransactions(Long studentId, int limit);
    Transaction save(Transaction transaction);
    List<Transaction> findAll();
    Transaction findById(Long id);
    void deleteById(Long id);

    /**
     * Get total number of transactions for a user
     */
    long getTotalTransactionsByUser(User user);

    /**
     * Get total number of payments for a user
     */
    long getTotalPaymentsByUser(User user);

    List<Transaction> findTransactionsWithFilters(String status, String startDate, String endDate, String amountRange);
    
    byte[] exportTransactions(String format, String startDate, String endDate) throws Exception;
    
    void bulkUpdateStatus(List<Long> transactionIds, TransactionStatus newStatus);
} 