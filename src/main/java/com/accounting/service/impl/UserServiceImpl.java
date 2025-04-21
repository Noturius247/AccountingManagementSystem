package com.accounting.service.impl;

import com.accounting.model.User;
import com.accounting.model.RegistrationStatus;
import com.accounting.repository.UserRepository;
import com.accounting.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import jakarta.persistence.EntityNotFoundException;
import org.hibernate.Hibernate;
import org.springframework.dao.EmptyResultDataAccessException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private static final Logger logger = LoggerFactory.getLogger(UserServiceImpl.class);

    @Autowired
    public UserServiceImpl(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public Page<User> findAllUsers(Pageable pageable) {
        return userRepository.findAll(pageable);
    }

    @Override
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    @Override
    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    @Override
    @Transactional(readOnly = true)
    public User findByUsernameWithCollections(String username) {
        try {
            User user = userRepository.findByUsername(username)
                    .orElseThrow(() -> new EntityNotFoundException("User not found: " + username));
            
            // Initialize all collections to prevent LazyInitializationException
            if (user.getNotificationSettings() != null) {
                Hibernate.initialize(user.getNotificationSettings());
            }
            if (user.getDocuments() != null) {
                Hibernate.initialize(user.getDocuments());
            }
            if (user.getTransactions() != null) {
                Hibernate.initialize(user.getTransactions());
            }
            if (user.getNotifications() != null) {
                Hibernate.initialize(user.getNotifications());
            }
            
            return user;
        } catch (Exception e) {
            logger.error("Error loading user with collections: {}", e.getMessage(), e);
            throw new RuntimeException("Failed to load user data", e);
        }
    }

    @Override
    public void updateUser(String username, User userData) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        if (userData.getEmail() != null) {
            user.setEmail(userData.getEmail());
        }
        if (userData.getRole() != null) {
            user.setRole(userData.getRole());
        }
        if (userData.isEnabled() != user.isEnabled()) {
            user.setEnabled(userData.isEnabled());
        }
        
        userRepository.save(user);
    }

    @Override
    public void updateUser(User user) {
        userRepository.save(user);
    }

    @Override
    public void deleteUser(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found"));
        userRepository.delete(user);
    }

    @Override
    public void registerUser(User user) {
        if (userRepository.findByUsername(user.getUsername()).isPresent()) {
            throw new RuntimeException("Username already exists");
        }
        user.setRegistrationStatus(RegistrationStatus.PENDING);
        userRepository.save(user);
    }

    @Override
    public void deleteUser(String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        userRepository.delete(user);
    }

    @Override
    public User getUserByUsername(String username) {
        return userRepository.findByUsername(username)
            .orElseThrow(() -> new EntityNotFoundException("User not found: " + username));
    }

    @Override
    public User save(User user) {
        return userRepository.save(user);
    }

    @Override
    public void updateLastActivity(String username) {
        userRepository.updateLastActivity(username);
    }

    @Override
    public boolean existsByUsername(String username) {
        return userRepository.existsByUsername(username);
    }

    @Override
    public boolean existsByEmail(String email) {
        return userRepository.existsByEmail(email);
    }

    @Override
    public void updateProfile(String username, User userData) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new EntityNotFoundException("User not found: " + username));
        
        if (userData.getFirstName() != null) {
            user.setFirstName(userData.getFirstName());
        }
        if (userData.getLastName() != null) {
            user.setLastName(userData.getLastName());
        }
        if (userData.getEmail() != null) {
            user.setEmail(userData.getEmail());
        }
        
        userRepository.save(user);
    }

    @Override
    public void changePassword(String username, String currentPassword, String newPassword) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new EntityNotFoundException("User not found: " + username));
        
        if (!passwordEncoder.matches(currentPassword, user.getPassword())) {
            throw new IllegalArgumentException("Current password is incorrect");
        }
        
        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
    }

    @Override
    public void updateNotificationSettings(String username, boolean emailNotifications, boolean paymentNotifications, boolean documentNotifications) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new EntityNotFoundException("User not found: " + username));
        
        user.getNotificationSettings().put("email", String.valueOf(emailNotifications));
        user.getNotificationSettings().put("payment", String.valueOf(paymentNotifications));
        user.getNotificationSettings().put("document", String.valueOf(documentNotifications));
        
        userRepository.save(user);
    }

    @Override
    public User findById(Long id) throws EmptyResultDataAccessException {
        return userRepository.findById(id)
                .orElseThrow(() -> new EmptyResultDataAccessException("User not found with id: " + id, 1));
    }

    @Override
    public long countActiveUsers() {
        return userRepository.countByEnabled(true);
    }

    @Override
    public long countAllUsers() {
        return userRepository.count();
    }

    @Override
    @Transactional(readOnly = true)
    public Page<User> searchUsers(String term, String role, String status, PageRequest pageRequest) {
        Specification<User> spec = Specification.where(null);
        
        if (term != null && !term.isEmpty()) {
            spec = spec.and((root, query, cb) -> 
                cb.or(
                    cb.like(cb.lower(root.get("username")), "%" + term.toLowerCase() + "%"),
                    cb.like(cb.lower(root.get("email")), "%" + term.toLowerCase() + "%")
                )
            );
        }
        
        if (role != null && !role.isEmpty()) {
            spec = spec.and((root, query, cb) -> 
                cb.equal(root.get("role"), role)
            );
        }
        
        if (status != null && !status.isEmpty()) {
            boolean enabled = "Active".equals(status);
            spec = spec.and((root, query, cb) -> 
                cb.equal(root.get("enabled"), enabled)
            );
        }
        
        return userRepository.findAll(spec, pageRequest);
    }
} 