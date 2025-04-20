package com.accounting.service;

import com.accounting.model.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.dao.EmptyResultDataAccessException;
import java.util.List;
import java.util.Optional;

public interface UserService {
    Page<User> findAllUsers(Pageable pageable);
    Optional<User> findByUsername(String username);
    User findByUsernameWithCollections(String username);
    void updateUser(String username, User userData);
    void deleteUser(String username);
    void updateUser(User user);
    void deleteUser(Long id);
    void registerUser(User user);
    User getUserByUsername(String username);
    User save(User user);
    void updateLastActivity(String username);
    boolean existsByUsername(String username);
    boolean existsByEmail(String email);
    
    // New methods for user settings
    void updateProfile(String username, User userData);
    void changePassword(String username, String currentPassword, String newPassword);
    void updateNotificationSettings(String username, boolean emailNotifications, boolean paymentNotifications, boolean documentNotifications);

    /**
     * Find a user by their ID
     * @param id the user ID
     * @return the user if found
     * @throws EmptyResultDataAccessException if the user is not found
     */
    User findById(Long id) throws EmptyResultDataAccessException;

    /**
     * Count all active users
     * @return the number of active users
     */
    long countActiveUsers();

    /**
     * Count all users
     * @return the total number of users
     */
    long countAllUsers();

    Page<User> searchUsers(String term, String role, String status, PageRequest pageRequest);

    List<User> getAllUsers();
} 