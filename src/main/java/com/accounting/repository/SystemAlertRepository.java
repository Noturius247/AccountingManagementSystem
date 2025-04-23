package com.accounting.repository;

import com.accounting.model.SystemAlert;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Map;

@Repository
public interface SystemAlertRepository extends JpaRepository<SystemAlert, Long> {
    
    @Query(value = """
        SELECT 
            sa.id as id,
            sa.title as title,
            sa.message as message,
            sa.type as type,
            sa.created_at as createdAt,
            sa.severity as severity
        FROM system_alerts sa
        WHERE sa.resolved = false
        ORDER BY sa.created_at DESC
        """, nativeQuery = true)
    List<Map<String, Object>> findRecentAlerts(Pageable pageable);
} 