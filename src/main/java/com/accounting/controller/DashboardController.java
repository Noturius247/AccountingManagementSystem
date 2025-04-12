package com.accounting.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import com.accounting.service.TransactionService;
import com.accounting.service.NotificationService;
import com.accounting.model.Transaction;
import com.accounting.model.Notification;
import java.util.List;
import java.util.Date;
import org.springframework.security.core.GrantedAuthority;

@Controller
@RequestMapping("/dashboard")
public class DashboardController {

    @Autowired
    private TransactionService transactionService;
    
    @Autowired
    private NotificationService notificationService;

    @GetMapping
    public String dashboard(Model model, Authentication authentication) {
        // Set page title
        model.addAttribute("pageTitle", "Dashboard");
        
        // Add user information
        if (authentication != null && authentication.isAuthenticated()) {
            model.addAttribute("username", authentication.getName());
        }
        
        // Add transaction statistics
        model.addAttribute("activeQueueCount", transactionService.getActiveQueueCount());
        model.addAttribute("lastUpdateTime", new Date());
        model.addAttribute("todayTransactions", transactionService.getTodayTransactionCount());
        model.addAttribute("todayTotal", transactionService.getTodayTotalAmount());
        model.addAttribute("pendingApprovals", transactionService.getPendingApprovalCount());
        model.addAttribute("highPriorityCount", transactionService.getHighPriorityCount());
        model.addAttribute("activeUsers", transactionService.getActiveUserCount());
        model.addAttribute("onlineUsers", transactionService.getOnlineUserCount());
        
        // Get recent transactions
        List<Transaction> recentTransactions = transactionService.getRecentTransactions(10);
        model.addAttribute("recentTransactions", recentTransactions);
        
        // Get system notifications
        List<Notification> notifications = notificationService.getSystemNotifications();
        model.addAttribute("notifications", notifications);
        
        return "dashboard";
    }

    @GetMapping("/admin/dashboard")
    public String adminDashboard(Model model, Authentication authentication) {
        if (authentication != null && authentication.isAuthenticated()) {
            for (GrantedAuthority authority : authentication.getAuthorities()) {
                if (authority.getAuthority().equals("ROLE_ADMIN")) {
                    model.addAttribute("username", authentication.getName());
                    return "jsp/admin/dashboard";
                }
            }
        }
        return "redirect:/login";
    }

    @GetMapping("/manager/dashboard")
    public String managerDashboard(Model model, Authentication authentication) {
        if (authentication != null && authentication.isAuthenticated()) {
            for (GrantedAuthority authority : authentication.getAuthorities()) {
                if (authority.getAuthority().equals("ROLE_MANAGER")) {
                    model.addAttribute("username", authentication.getName());
                    return "jsp/manager/dashboard";
                }
            }
        }
        return "redirect:/login";
    }

    @GetMapping("/user/dashboard")
    public String userDashboard(Model model, Authentication authentication) {
        if (authentication != null && authentication.isAuthenticated()) {
            for (GrantedAuthority authority : authentication.getAuthorities()) {
                if (authority.getAuthority().equals("ROLE_USER")) {
                    model.addAttribute("username", authentication.getName());
                    return "jsp/user/dashboard";
                }
            }
        }
        return "redirect:/login";
    }
} 