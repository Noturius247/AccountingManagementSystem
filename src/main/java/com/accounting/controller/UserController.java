package com.accounting.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import com.accounting.service.UserDashboardService;
import com.accounting.model.User;
import com.accounting.service.UserService;
import org.springframework.transaction.annotation.Transactional;

@Controller
@RequestMapping("/user")
@PreAuthorize("hasRole('USER')")
public class UserController {

    @Autowired
    private UserDashboardService userDashboardService;

    @Autowired
    private UserService userService;

    @GetMapping("/dashboard")
    @Transactional(readOnly = true)
    public String dashboard(Model model, Authentication authentication) {
        String username = authentication.getName();
        
        // Get user with initialized collections
        User user = userService.findByUsernameWithCollections(username);
        
        // Add user to model
        model.addAttribute("user", user);
        
        // Add dashboard statistics
        model.addAttribute("stats", userDashboardService.getDashboardStatistics());
        
        // Add recent transactions
        model.addAttribute("recentTransactions", userDashboardService.getRecentTransactions());
        
        // Add user notifications
        model.addAttribute("notifications", userDashboardService.getUserNotifications());
        
        // Add user documents
        model.addAttribute("documents", userDashboardService.getUserDocuments());
        
        // Add current balance
        model.addAttribute("currentBalance", userDashboardService.getCurrentBalance(username));
        
        // Add pending payments count
        model.addAttribute("pendingPaymentsCount", userDashboardService.getPendingPaymentsCount(username));
        
        // Add queue position
        model.addAttribute("queuePosition", userDashboardService.getQueuePosition(username));
        
        // Add estimated wait time
        model.addAttribute("estimatedWaitTime", userDashboardService.getEstimatedWaitTime(username));
        
        // Add recent payments
        model.addAttribute("recentPayments", userDashboardService.getRecentPayments(username));
        
        // Add recent documents
        model.addAttribute("recentDocuments", userDashboardService.getRecentDocuments(username));
        
        return "user/dashboard";
    }

    @GetMapping("/transactions")
    public String transactions(Model model) {
        model.addAttribute("transactions", userDashboardService.getRecentTransactions());
        return "user/transactions";
    }
} 