package com.accounting;

import org.junit.jupiter.api.Test;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordHashTest {
    
    @Test
    public void generatePasswordHash() {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        String password = "admin";
        String encodedPassword = encoder.encode(password);
        System.out.println("Password: " + password);
        System.out.println("Encoded: " + encodedPassword);
        
        // Verify the password matches
        boolean matches = encoder.matches(password, encodedPassword);
        System.out.println("Password matches: " + matches);
        
        // Also try to verify with the current database hash
        String currentDbHash = "62a$10$GRLdNijSQMUvl/au9ofL.eDwmoohzzS7.rmNSJZ.0FxO/BTk76klW";
        boolean matchesCurrentHash = encoder.matches(password, currentDbHash);
        System.out.println("Matches current DB hash: " + matchesCurrentHash);
    }
} 