package com.accounting.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class PasswordUtil {
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        
        // Test admin password
        String adminPassword = "admin";
        String adminHash = encoder.encode(adminPassword);
        log.info("Admin password hash: {}", adminHash);
        
        // Test manager password
        String managerPassword = "manager";
        String managerHash = encoder.encode(managerPassword);
        log.info("Manager password hash: {}", managerHash);
        
        // Test verification
        log.info("Admin password verification test: {}", encoder.matches(adminPassword, adminHash));
        log.info("Manager password verification test: {}", encoder.matches(managerPassword, managerHash));
    }
} 