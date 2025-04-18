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
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }

        // Check user role and redirect accordingly
        for (GrantedAuthority authority : authentication.getAuthorities()) {
            if (authority.getAuthority().equals("ROLE_ADMIN")) {
                return "redirect:/admin/dashboard";
            } else if (authority.getAuthority().equals("ROLE_MANAGER")) {
                return "redirect:/manager/dashboard";
            } else if (authority.getAuthority().equals("ROLE_USER")) {
                return "redirect:/user/dashboard";
            }
        }

        // If no role matches, redirect to login
        return "redirect:/login";
    }

    @GetMapping("/transactions")
    public String transactions(Model model) {
        model.addAttribute("transactions", transactionService.getRecentTransactions(10));
        return "user/transactions";
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
} 