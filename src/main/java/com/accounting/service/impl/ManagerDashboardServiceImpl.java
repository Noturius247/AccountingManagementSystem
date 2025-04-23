package com.accounting.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.accounting.service.ManagerDashboardService;
import com.accounting.repository.*;
import com.accounting.model.Kiosk;
import com.accounting.model.Transaction;
import com.accounting.model.DashboardStats;
import com.accounting.model.Student;
import com.accounting.model.enums.TransactionStatus;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.TimeUnit;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import java.time.LocalDateTime;
import java.time.LocalDate;
import java.math.BigDecimal;

@Service
public class ManagerDashboardServiceImpl implements ManagerDashboardService {
    private static final Logger log = LoggerFactory.getLogger(ManagerDashboardServiceImpl.class);

    @Autowired
    private DashboardRepository dashboardRepository;
    
    @Autowired
    private TransactionRepository transactionRepository;
    
    @Autowired
    private KioskRepository kioskRepository;
    
    @Autowired
    private TaskRepository taskRepository;

    @Autowired
    private TeamMemberRepository teamMemberRepository;

    @Autowired
    private SystemAlertRepository systemAlertRepository;
    
    @Autowired
    private StudentRepository studentRepository;

    @Override
    @Transactional(readOnly = true)
    public List<Student> getPendingStudentRegistrations() {
        try {
            return studentRepository.findByRegistrationStatus(Student.RegistrationStatus.PENDING);
        } catch (Exception e) {
            log.error("Error getting pending student registrations", e);
            throw e;
        }
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getDashboardStatistics() {
        try {
            LocalDateTime now = LocalDateTime.now();
            LocalDateTime lastHour = now.minusHours(1);
            LocalDateTime startOfDay = LocalDate.now().atStartOfDay();
            LocalDateTime endOfDay = startOfDay.plusDays(1);
            LocalDateTime startOfMonth = LocalDate.now().withDayOfMonth(1).atStartOfDay();
            LocalDateTime startOfLastMonth = LocalDate.now().minusMonths(1).withDayOfMonth(1).atStartOfDay();
            LocalDateTime endOfLastMonth = LocalDate.now().withDayOfMonth(1).atStartOfDay();

            Map<String, Object> stats = dashboardRepository.getDashboardStatistics(
                lastHour, startOfDay, endOfDay, startOfMonth, startOfLastMonth, endOfLastMonth
            );

            // Add pending student registrations count
            long pendingRegistrations = studentRepository.countByRegistrationStatus(Student.RegistrationStatus.PENDING);
            stats.put("pendingRegistrations", pendingRegistrations);
            stats.put("pendingStudentCount", pendingRegistrations);

            // Ensure values are not null
            stats.putIfAbsent("activeUsers", 0);
            stats.putIfAbsent("activeKiosks", 0);
            stats.putIfAbsent("todaysTransactions", 0);
            stats.putIfAbsent("pendingCount", 0);
            stats.putIfAbsent("totalRevenue", BigDecimal.ZERO);
            stats.putIfAbsent("lastMonthRevenue", BigDecimal.ZERO);

            // Calculate revenue growth
            BigDecimal totalRevenue = (BigDecimal) stats.get("totalRevenue");
            BigDecimal lastMonthRevenue = (BigDecimal) stats.get("lastMonthRevenue");
            double revenueGrowth = lastMonthRevenue.compareTo(BigDecimal.ZERO) > 0 ? 
                ((totalRevenue.doubleValue() - lastMonthRevenue.doubleValue()) / lastMonthRevenue.doubleValue()) * 100 : 0;
            
            stats.put("revenueGrowth", revenueGrowth);

            // Store statistics asynchronously in a separate transaction
            CompletableFuture.runAsync(() -> saveStatsInNewTransaction(stats));
            
            return stats;
        } catch (Exception e) {
            log.error("Error getting dashboard statistics", e);
            // Try to get latest stored stats as fallback
            try {
                DashboardStats latestStats = dashboardRepository.findLatestStats();
                if (latestStats != null) {
                    Map<String, Object> fallbackStats = new HashMap<>();
                    fallbackStats.put("activeUsers", latestStats.getActiveUsers());
                    fallbackStats.put("activeKiosks", latestStats.getActiveKiosks());
                    fallbackStats.put("todaysTransactions", latestStats.getTodaysTransactions());
                    fallbackStats.put("pendingCount", latestStats.getPendingCount());
                    fallbackStats.put("totalRevenue", latestStats.getTotalRevenue());
                    fallbackStats.put("lastMonthRevenue", latestStats.getLastMonthRevenue());
                    
                    // Calculate revenue growth
                    BigDecimal totalRevenue = latestStats.getTotalRevenue();
                    BigDecimal lastMonthRevenue = latestStats.getLastMonthRevenue();
                    double revenueGrowth = lastMonthRevenue.compareTo(BigDecimal.ZERO) > 0 ? 
                        ((totalRevenue.doubleValue() - lastMonthRevenue.doubleValue()) / lastMonthRevenue.doubleValue()) * 100 : 0;
                    fallbackStats.put("revenueGrowth", revenueGrowth);
                    
                    return fallbackStats;
                }
            } catch (Exception fallbackError) {
                log.error("Error getting fallback statistics", fallbackError);
            }
            throw e;
        }
    }

    @Transactional
    protected void saveStatsInNewTransaction(Map<String, Object> stats) {
        try {
            DashboardStats dashboardStats = new DashboardStats();
            dashboardStats.setActiveUsers(((Number) stats.get("activeUsers")).intValue());
            dashboardStats.setActiveKiosks(((Number) stats.get("activeKiosks")).intValue());
            dashboardStats.setTodaysTransactions(((Number) stats.get("todaysTransactions")).intValue());
            dashboardStats.setPendingCount(((Number) stats.get("pendingCount")).intValue());
            dashboardStats.setTotalRevenue((BigDecimal) stats.get("totalRevenue"));
            dashboardStats.setLastMonthRevenue((BigDecimal) stats.get("lastMonthRevenue"));
            dashboardRepository.save(dashboardStats);
        } catch (Exception e) {
            log.error("Error saving dashboard statistics", e);
            // Don't throw the exception since this is a non-critical operation
        }
    }

    @Override
    @Transactional(readOnly = true)
    public List<Kiosk> getKioskStatus() {
        try {
            return kioskRepository.findAll(PageRequest.of(0, 10, Sort.by(Sort.Direction.DESC, "lastActivity")))
                .getContent();
        } catch (Exception e) {
            log.error("Error getting kiosk status", e);
            throw e;
        }
    }

    @Override
    @Transactional(readOnly = true)
    public List<Transaction> getRecentTransactions() {
        try {
            return transactionRepository.findAll(
                PageRequest.of(0, 5, Sort.by(Sort.Direction.DESC, "createdAt"))
            ).getContent();
        } catch (Exception e) {
            log.error("Error getting recent transactions", e);
            throw e;
        }
    }

    @Override
    @Transactional(readOnly = true)
    public List<Map<String, Object>> getRecentTasks() {
        try {
            return taskRepository.findRecentTasks(PageRequest.of(0, 5));
        } catch (Exception e) {
            log.error("Error getting recent tasks", e);
            throw e;
        }
    }

    @Override
    @Transactional(readOnly = true)
    public List<Map<String, Object>> getTeamMembers() {
        try {
            return teamMemberRepository.findActiveTeamMembers(PageRequest.of(0, 5));
        } catch (Exception e) {
            log.error("Error getting team members", e);
            throw e;
        }
    }

    @Override
    @Transactional(readOnly = true)
    public List<Map<String, Object>> getSystemAlerts() {
        try {
            return systemAlertRepository.findRecentAlerts(PageRequest.of(0, 5));
        } catch (Exception e) {
            log.error("Error getting system alerts", e);
            throw e;
        }
    }

    @Override
    @Transactional(readOnly = true)
    public int getSystemHealth() {
        try {
            // Calculate system health based on various metrics
            int activeKiosks = (int) kioskRepository.countByStatus("ONLINE");
            int totalKiosks = (int) kioskRepository.count();
            int pendingTransactions = (int) transactionRepository.countByStatus(TransactionStatus.PENDING);
            int totalTransactions = (int) transactionRepository.count();
            
            // Weight different factors
            double kioskHealth = totalKiosks > 0 ? (activeKiosks / (double) totalKiosks) * 100 : 100;
            double transactionHealth = totalTransactions > 0 ? 
                ((totalTransactions - pendingTransactions) / (double) totalTransactions) * 100 : 100;
            
            // Calculate weighted average
            return (int) ((kioskHealth * 0.6) + (transactionHealth * 0.4));
        } catch (Exception e) {
            log.error("Error calculating system health", e);
            throw e;
        }
    }

    @Override
    @Transactional(readOnly = true)
    public int getActiveUsersCount() {
        Map<String, Object> stats = getDashboardStatistics();
        return ((Number) stats.get("activeUsers")).intValue();
    }

    @Override
    @Transactional(readOnly = true)
    public double getTotalRevenue() {
        Map<String, Object> stats = getDashboardStatistics();
        return ((Number) stats.get("totalRevenue")).doubleValue();
    }

    @Override
    @Transactional(readOnly = true)
    public double getLastMonthRevenue() {
        Map<String, Object> stats = getDashboardStatistics();
        return ((Number) stats.get("lastMonthRevenue")).doubleValue();
    }

    @Override
    @Transactional(readOnly = true)
    public int getLastHourUsersCount() {
        // This is now handled in the dashboard statistics query
        return getActiveUsersCount();
    }

    @Override
    @Transactional(readOnly = true)
    public int getActiveKiosksCount() {
        Map<String, Object> stats = getDashboardStatistics();
        return ((Number) stats.get("activeKiosks")).intValue();
    }

    @Override
    @Transactional(readOnly = true)
    public int getTodaysTransactionsCount() {
        Map<String, Object> stats = getDashboardStatistics();
        return ((Number) stats.get("todaysTransactions")).intValue();
    }

    @Override
    @Transactional(readOnly = true)
    public int getCurrentQueueCount() {
        Map<String, Object> stats = getDashboardStatistics();
        return ((Number) stats.get("pendingCount")).intValue();
    }
} 