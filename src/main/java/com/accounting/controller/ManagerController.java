package com.accounting.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import com.accounting.service.ManagerDashboardService;
import com.accounting.service.QueueService;

@Controller
@RequestMapping("/manager")
@PreAuthorize("hasRole('MANAGER')")
public class ManagerController {

    @Autowired
    private ManagerDashboardService managerDashboardService;

    @Autowired
    private QueueService queueService;

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        // Add dashboard statistics
        model.addAttribute("statistics", managerDashboardService.getDashboardStatistics());
        model.addAttribute("kioskStatus", managerDashboardService.getKioskStatus());
        model.addAttribute("recentTransactions", managerDashboardService.getRecentTransactions());
        
        // Add queue data
        model.addAttribute("currentQueue", queueService.getCurrentQueue());
        
        return "manager/dashboard";
    }

    @GetMapping("/transactions")
    public String viewTransactions(Model model) {
        model.addAttribute("transactions", managerDashboardService.getRecentTransactions());
        return "manager/transactions";
    }

    @GetMapping("/reports")
    public String viewReports(Model model) {
        // Add report data
        return "manager/reports";
    }

    @GetMapping("/queue")
    public String manageQueue(Model model) {
        model.addAttribute("queueList", queueService.getCurrentQueue());
        return "manager/queue";
    }
} 