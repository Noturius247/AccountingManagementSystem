package com.accounting.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "dashboard_stats")
public class DashboardStats {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private int activeUsers;
    private int activeKiosks;
    private int todaysTransactions;
    private int pendingCount;
    
    @Column(precision = 19, scale = 4)
    private BigDecimal totalRevenue;
    
    @Column(precision = 19, scale = 4)
    private BigDecimal lastMonthRevenue;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
    
    // Getters and Setters
    
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public int getActiveUsers() {
        return activeUsers;
    }
    
    public void setActiveUsers(int activeUsers) {
        this.activeUsers = activeUsers;
    }
    
    public int getActiveKiosks() {
        return activeKiosks;
    }
    
    public void setActiveKiosks(int activeKiosks) {
        this.activeKiosks = activeKiosks;
    }
    
    public int getTodaysTransactions() {
        return todaysTransactions;
    }
    
    public void setTodaysTransactions(int todaysTransactions) {
        this.todaysTransactions = todaysTransactions;
    }
    
    public int getPendingCount() {
        return pendingCount;
    }
    
    public void setPendingCount(int pendingCount) {
        this.pendingCount = pendingCount;
    }
    
    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }
    
    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = totalRevenue;
    }
    
    public BigDecimal getLastMonthRevenue() {
        return lastMonthRevenue;
    }
    
    public void setLastMonthRevenue(BigDecimal lastMonthRevenue) {
        this.lastMonthRevenue = lastMonthRevenue;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
} 