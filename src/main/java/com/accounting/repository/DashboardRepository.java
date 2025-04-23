package com.accounting.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.accounting.model.DashboardStats;
import java.time.LocalDateTime;
import java.util.Map;

@Repository
public interface DashboardRepository extends JpaRepository<DashboardStats, Long> {
    @Query("""
        SELECT new map(
            COUNT(DISTINCT CASE WHEN u.lastActivity > :lastHour THEN u.id END) as activeUsers,
            COUNT(DISTINCT CASE WHEN k.status = 'ONLINE' THEN k.id END) as activeKiosks,
            COUNT(DISTINCT CASE WHEN t.createdAt BETWEEN :startOfDay AND :endOfDay THEN t.id END) as todaysTransactions,
            COUNT(DISTINCT CASE WHEN t.status = 'PENDING' THEN t.id END) as pendingCount,
            COALESCE(SUM(CASE WHEN t.status = 'COMPLETED' AND t.createdAt >= :startOfMonth THEN t.amount ELSE 0 END), 0) as totalRevenue,
            COALESCE(SUM(CASE WHEN t.status = 'COMPLETED' AND t.createdAt BETWEEN :startOfLastMonth AND :endOfLastMonth THEN t.amount ELSE 0 END), 0) as lastMonthRevenue
        )
        FROM User u, Kiosk k, Transaction t
        """)
    Map<String, Object> getDashboardStatistics(
        @Param("lastHour") LocalDateTime lastHour,
        @Param("startOfDay") LocalDateTime startOfDay,
        @Param("endOfDay") LocalDateTime endOfDay,
        @Param("startOfMonth") LocalDateTime startOfMonth,
        @Param("startOfLastMonth") LocalDateTime startOfLastMonth,
        @Param("endOfLastMonth") LocalDateTime endOfLastMonth
    );

    @Query("SELECT ds FROM DashboardStats ds ORDER BY ds.createdAt DESC")
    DashboardStats findLatestStats();
} 