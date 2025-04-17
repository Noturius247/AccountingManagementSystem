package com.accounting.controller;

import com.accounting.service.UserDashboardService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.security.core.Authentication;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

@Controller
public class UserDashboardController {

    private final UserDashboardService userDashboardService;

    public UserDashboardController(UserDashboardService userDashboardService) {
        this.userDashboardService = userDashboardService;
    }

    @GetMapping("/user/profile")
    @Transactional(readOnly = true)
    public String showProfile(Model model, Authentication authentication) {
        String username = authentication.getName();
        
        // Get user profile
        Map<String, Object> profile = userDashboardService.getUserProfile(username);
        model.addAttribute("profile", profile);
        
        // Get total amount spent
        double totalSpent = userDashboardService.getCurrentBalance(username);
        model.addAttribute("totalSpent", totalSpent);
        
        return "user/profile";
    }
} 