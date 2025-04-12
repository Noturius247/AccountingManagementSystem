package com.accounting.config;

import com.accounting.model.Role;
import com.accounting.model.User;
import com.accounting.model.SystemSettings;
import com.accounting.repository.RoleRepository;
import com.accounting.repository.UserRepository;
import com.accounting.repository.SystemSettingsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.math.BigDecimal;

@Component
public class DatabaseInitializer implements CommandLineRunner {
    
    private static final Logger logger = LoggerFactory.getLogger(DatabaseInitializer.class);

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private SystemSettingsRepository systemSettingsRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    @Transactional
    public void run(String... args) {
        // Initialize roles if they don't exist
        if (roleRepository.count() == 0) {
            Role adminRole = new Role("ADMIN", "Administrator with full system access");
            Role managerRole = new Role("MANAGER", "Manager with elevated privileges");
            Role userRole = new Role("USER", "Regular user with basic access");
            roleRepository.saveAll(Arrays.asList(adminRole, managerRole, userRole));
        }

        // Initialize admin user if it doesn't exist
        if (!userRepository.existsByUsername("admin")) {
            User admin = new User();
            admin.setUsername("admin");
            String adminPassword = passwordEncoder.encode("admin");
            logger.info("Creating admin user with password hash: {}", adminPassword);
            admin.setPassword(adminPassword);
            admin.setEmail("admin@example.com");
            admin.setFirstName("Admin");
            admin.setLastName("User");
            admin.setEnabled(true);
            admin.setCreatedAt(LocalDateTime.now());
            admin.setRole("ADMIN");
            admin.setBalance(BigDecimal.ZERO);
            userRepository.save(admin);
        }

        // Initialize manager user if it doesn't exist
        if (!userRepository.existsByUsername("manager")) {
            User manager = new User();
            manager.setUsername("manager");
            String managerPassword = passwordEncoder.encode("manager");
            logger.info("Creating manager user with password hash: {}", managerPassword);
            manager.setPassword(managerPassword);
            manager.setEmail("manager@example.com");
            manager.setFirstName("Manager");
            manager.setLastName("User");
            manager.setEnabled(true);
            manager.setCreatedAt(LocalDateTime.now());
            manager.setRole("MANAGER");
            manager.setBalance(BigDecimal.ZERO);
            userRepository.save(manager);
        }

        // Initialize system settings if they don't exist
        if (systemSettingsRepository.count() == 0) {
            SystemSettings[] settings = {
                createSetting("system.name", "Accounting Management System", "Name of the system"),
                createSetting("system.version", "1.0.0", "Current system version"),
                createSetting("system.maintenance", "false", "System maintenance mode"),
                createSetting("system.timezone", "UTC", "System timezone"),
                createSetting("system.currency", "USD", "Default system currency"),
                createSetting("system.queue.max_wait_time", "30", "Maximum wait time in minutes"),
                createSetting("system.notification.enabled", "true", "Enable system notifications"),
                createSetting("system.payment.methods", "CASH,CREDIT_CARD,BANK_TRANSFER", "Available payment methods")
            };
            systemSettingsRepository.saveAll(Arrays.asList(settings));
        }
    }

    private SystemSettings createSetting(String key, String value, String description) {
        SystemSettings setting = new SystemSettings();
        setting.setKey(key);
        setting.setValue(value);
        setting.setDescription(description);
        setting.setCreatedAt(LocalDateTime.now());
        setting.setLastModified(LocalDateTime.now());
        return setting;
    }
} 