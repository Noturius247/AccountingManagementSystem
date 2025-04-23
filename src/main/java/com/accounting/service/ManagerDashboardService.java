package com.accounting.service;

import java.util.Map;
import java.util.List;
import com.accounting.model.Transaction;
import com.accounting.model.Kiosk;
import com.accounting.model.Student;

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
     * Get total revenue
     */
    double getTotalRevenue();
    
    /**
     * Get last month's revenue
     */
    double getLastMonthRevenue();
    
    /**
     * Get last hour's user count
     */
    int getLastHourUsersCount();
    
    /**
     * Get system health percentage
     */
    int getSystemHealth();
    
    /**
     * Get recent tasks
     */
    List<Map<String, Object>> getRecentTasks();
    
    /**
     * Get team members
     */
    List<Map<String, Object>> getTeamMembers();
    
    /**
     * Get system alerts
     */
    List<Map<String, Object>> getSystemAlerts();
    
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
    
    /**
     * Get pending student registrations
     */
    List<Student> getPendingStudentRegistrations();
} 