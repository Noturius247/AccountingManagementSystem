package com.accounting.service;

import java.util.List;
import java.util.Map;
import com.accounting.model.PaymentQueue;
import com.accounting.model.SystemSettings;

public interface AdminService {
    
    /**
     * Get list of pending payments that need admin approval
     */
    List<PaymentQueue> getPendingPayments();
    
    /**
     * Get daily report with statistics and metrics
     */
    Map<String, Object> getDailyReport();
    
    /**
     * Get monthly report with statistics and metrics
     */
    Map<String, Object> getMonthlyReport();
    
    /**
     * Verify a receipt by its number
     */
    boolean verifyReceipt(String receiptNumber);
    
    /**
     * Get system settings and configurations
     */
    SystemSettings getSystemSettings();
} 