package com.accounting.service;

import com.accounting.model.Transaction;
import java.util.List;

public interface TransactionService {
    
    int getActiveQueueCount();

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
} 