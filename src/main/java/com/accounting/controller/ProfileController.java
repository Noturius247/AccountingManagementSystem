package com.accounting.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/profile")
public class ProfileController {
    
    // Mock user profile data
    private static final Map<String, Map<String, String>> userProfiles = new HashMap<>();
    
    static {
        // Initialize mock profile for admin user
        Map<String, String> adminProfile = new HashMap<>();
        adminProfile.put("fullName", "Admin User");
        adminProfile.put("email", "admin@example.com");
        adminProfile.put("phone", "+1234567890");
        adminProfile.put("department", "Administration");
        adminProfile.put("role", "System Administrator");
        adminProfile.put("joinDate", "2024-01-01");
        userProfiles.put("admin", adminProfile);
    }
    
    @GetMapping
    public String viewProfile(Model model, Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }
        
        String username = authentication.getName();
        Map<String, String> userProfile = userProfiles.get(username);
        
        model.addAttribute("pageTitle", "User Profile");
        model.addAttribute("profile", userProfile);
        return "profile";
    }
    
    @PostMapping
    public String updateProfile(@RequestParam Map<String, String> formData, 
                              Model model, 
                              Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }
        
        String username = authentication.getName();
        Map<String, String> profile = userProfiles.get(username);
        
        // Update profile with form data
        profile.put("fullName", formData.get("fullName"));
        profile.put("email", formData.get("email"));
        profile.put("phone", formData.get("phone"));
        profile.put("department", formData.get("department"));
        
        model.addAttribute("success", "Profile updated successfully");
        model.addAttribute("profile", profile);
        return "profile";
    }
} 