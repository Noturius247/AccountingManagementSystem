package com.accounting.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import com.accounting.service.TransactionService;
import com.accounting.service.NotificationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
public class DashboardController {
    
    private static final Logger logger = LoggerFactory.getLogger(DashboardController.class);

    @Autowired
    private TransactionService transactionService;
    
    @Autowired
    private NotificationService notificationService;
    
    @GetMapping("/dashboard")
    public String redirectToDashboard() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        logger.debug("Dashboard redirect accessed. Authentication: {}", auth);
        
        if (auth == null || auth.getName().equals("anonymousUser")) {
            logger.debug("User not authenticated, redirecting to login");
            return "redirect:/login";
        }

        if (auth.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_ADMIN"))) {
            return "redirect:/admin/dashboard";
        } else if (auth.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_MANAGER"))) {
            return "redirect:/manager/dashboard";
        } else if (auth.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_USER"))) {
            return "redirect:/user/dashboard";
        } else if (auth.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_STUDENT"))) {
            return "redirect:/student/dashboard";
        }

        logger.warn("User has no recognized role, redirecting to login");
        return "redirect:/login";
    }
} 