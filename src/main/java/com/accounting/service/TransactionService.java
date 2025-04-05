package com.accounting.service;

import com.accounting.model.Transaction;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.List;

@Service
public class TransactionService {
    
    public int getActiveQueueCount() {
        return 5; // Mock value
    }

    public int getTodayTransactionCount() {
        return 10; // Mock value
    }

    public double getTodayTotalAmount() {
        return 1000.00; // Mock value
    }

    public int getPendingApprovalCount() {
        return 3; // Mock value
    }

    public int getHighPriorityCount() {
        return 2; // Mock value
    }

    public int getActiveUserCount() {
        return 15; // Mock value
    }

    public int getOnlineUserCount() {
        return 8; // Mock value
    }

    public List<Transaction> getRecentTransactions(int limit) {
        // Return mock list of transactions
        return new ArrayList<>();
    }
} 