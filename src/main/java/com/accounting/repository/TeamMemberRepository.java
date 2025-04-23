package com.accounting.repository;

import com.accounting.model.TeamMember;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Map;

@Repository
public interface TeamMemberRepository extends JpaRepository<TeamMember, Long> {
    
    @Query(value = """
        SELECT 
            tm.id as id,
            tm.name as name,
            tm.role as role,
            tm.status as status,
            tm.last_active as lastActive
        FROM team_members tm
        WHERE tm.status = 'ACTIVE'
        ORDER BY tm.last_active DESC
        """, nativeQuery = true)
    List<Map<String, Object>> findActiveTeamMembers(Pageable pageable);
} 