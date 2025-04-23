package com.accounting.repository;

import com.accounting.model.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long>, JpaSpecificationExecutor<User> {
    Optional<User> findByUsername(String username);
    Optional<User> findByEmail(String email);
    boolean existsByUsername(String username);
    boolean existsByEmail(String email);
    List<User> findByRole(String role);
    List<User> findByLastActivityAfter(LocalDateTime dateTime);
    List<User> findByLastActivityBefore(LocalDateTime dateTime);
    List<User> findByEnabledTrue();
    List<User> findByEnabledFalse();
    
    @Query("SELECT COUNT(u) FROM User u WHERE u.lastActivity > :dateTime")
    long countByLastActivityAfter(@Param("dateTime") LocalDateTime dateTime);
    
    @Query("SELECT u FROM User u ORDER BY u.createdAt DESC")
    List<User> findTop5ByOrderByCreatedAtDesc();

    List<User> findByUsernameContainingOrEmailContaining(String username, String email);
    
    @Query("SELECT COUNT(u) FROM User u WHERE u.username LIKE %:query% OR u.email LIKE %:query%")
    long countByUsernameContainingOrEmailContaining(@Param("query") String query);

    @Query("SELECT SUM(u.balance) FROM User u WHERE u.username LIKE %:query% OR u.email LIKE %:query%")
    Optional<BigDecimal> sumBalanceByUsernameContainingOrEmailContaining(@Param("query") String query);

    @Query("SELECT u FROM User u WHERE u.username = :username")
    Optional<User> findUserByUsername(@Param("username") String username);

    List<User> findByUsernameContaining(String query);
    
    @Query("SELECT u FROM User u WHERE u.username = ?1 ORDER BY u.createdAt DESC")
    List<User> findTop5ByUserUsernameOrderByCreatedAtDesc(String username);
    
    @Query("SELECT COUNT(u) FROM User u WHERE u.username LIKE %?1%")
    long countByUsernameContaining(String query);
    
    @Query("SELECT SUM(u.balance) FROM User u WHERE u.username LIKE %?1%")
    BigDecimal sumBalanceByUsernameContaining(String query);
    
    @Query("SELECT u FROM User u WHERE u.username LIKE %:query% ORDER BY u.createdAt DESC LIMIT 5")
    List<User> findTop5ByUsernameContaining(@Param("query") String query);

    @Query("SELECT u FROM User u ORDER BY u.createdAt DESC LIMIT 10")
    List<User> findTop10ByOrderByCreatedAtDesc();

    @Query("SELECT COUNT(u) FROM User u WHERE DATE(u.createdAt) = CURRENT_DATE")
    long countToday();

    @Query("SELECT COUNT(u) FROM User u WHERE u.enabled = :enabled")
    long countByEnabled(@Param("enabled") boolean enabled);

    @Query("UPDATE User u SET u.lastActivity = CURRENT_TIMESTAMP WHERE u.username = :username")
    void updateLastActivity(@Param("username") String username);

    @EntityGraph(attributePaths = {
        "notificationSettings",
        "documents",
        "transactions",
        "notifications",
        "queues"
    })
    @Query("SELECT u FROM User u WHERE u.username = :username")
    Optional<User> findByUsernameWithCollections(@Param("username") String username);

    long countByLastActivityBetween(LocalDateTime start, LocalDateTime end);
    
    @Query("SELECT u FROM User u WHERE u.username = :username")
    Optional<User> findByUsernameWithNotificationSettings(@Param("username") String username);
    
    @Query("SELECT u FROM User u WHERE u.username = :username")
    Optional<User> findByUsernameWithRoles(@Param("username") String username);
} 