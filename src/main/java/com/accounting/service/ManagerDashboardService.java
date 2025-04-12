package com.accounting.service;

import java.util.Map;
import java.util.List;
import com.accounting.model.Transaction;
import com.accounting.model.Kiosk;

public interface ManagerDashboardService {
    
    /**
     * Get dashboard statistics
     */
    Map<String, Object> getDashboardStatistics();
    
    /**
     * Get kiosk status
     */
    List<Kiosk> getKioskStatus();
    
    /**
     * Get recent transactions
     */
    List<Transaction> getRecentTransactions();
    
    /**
     * Get active users count
     */
    int getActiveUsersCount();
    
    /**
     * Get active kiosks count
     */
    int getActiveKiosksCount();
    
    /**
     * Get today's transactions count
     */
    int getTodaysTransactionsCount();
    
    /**
     * Get current queue count
     */
    int getCurrentQueueCount();
} 