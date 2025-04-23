package com.accounting.repository;

import com.accounting.model.Task;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Map;

@Repository
public interface TaskRepository extends JpaRepository<Task, Long> {
    
    @Query(value = """
        SELECT 
            t.id as id,
            t.title as title,
            t.description as description,
            t.priority as priority,
            t.due_date as dueDate,
            t.completed as completed,
            t.created_at as createdAt
        FROM tasks t
        WHERE t.completed = false
        ORDER BY t.due_date ASC
        """, nativeQuery = true)
    List<Map<String, Object>> findRecentTasks(Pageable pageable);
} 