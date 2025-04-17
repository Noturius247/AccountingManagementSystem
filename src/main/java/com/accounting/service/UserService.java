package com.accounting.service;

import com.accounting.model.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
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
} 