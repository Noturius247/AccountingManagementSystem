package com.accounting.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.accounting.service.ManagerDashboardService;
import com.accounting.service.QueueService;
import com.accounting.service.TransactionService;
import com.accounting.model.Queue;
import com.accounting.model.Transaction;
import org.springframework.transaction.annotation.Transactional;
import com.accounting.model.User;
import org.hibernate.Hibernate;
import java.util.Map;
import java.util.HashMap;

@Controller
@RequestMapping("/manager")
@PreAuthorize("hasRole('MANAGER')")
public class ManagerController {

    @Autowired
    private ManagerDashboardService managerDashboardService;

    @Autowired
    private QueueService queueService;

    @Autowired
    private TransactionService transactionService;

    @GetMapping("/dashboard")
    @Transactional(readOnly = true)
    public String dashboard(Model model) {
        // Add dashboard statistics
        model.addAttribute("statistics", managerDashboardService.getDashboardStatistics());
        model.addAttribute("kioskStatus", managerDashboardService.getKioskStatus());
        model.addAttribute("recentTransactions", managerDashboardService.getRecentTransactions());
        
        // Add queue data
        Queue currentQueue = queueService.getCurrentQueue();
        if (currentQueue != null && currentQueue.getUser() != null) {
            User user = currentQueue.getUser();
            // Initialize all collections
            Hibernate.initialize(user.getNotificationSettings());
            Hibernate.initialize(user.getTransactions());
            Hibernate.initialize(user.getDocuments());
            Hibernate.initialize(user.getNotifications());
        }
        model.addAttribute("currentQueue", currentQueue);
        
        return "manager/dashboard";
    }

    @GetMapping("/transactions")
    public String viewTransactions(Model model) {
        model.addAttribute("transactions", transactionService.getAllTransactions());
        return "manager/transactions";
    }

    @GetMapping("/transactions/{id}")
    @ResponseBody
    public Transaction getTransaction(@PathVariable Long id) {
        return transactionService.getTransactionByIdWithUser(id);
    }

    @PostMapping("/transactions/{id}/approve")
    @ResponseBody
    public Map<String, Object> approveTransaction(@PathVariable Long id) {
        Transaction transaction = transactionService.updateTransactionStatus(id, "COMPLETED");
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Transaction approved successfully");
        response.put("transaction", transaction);
        return response;
    }

    @PostMapping("/transactions/{id}/reject")
    @ResponseBody
    public Map<String, Object> rejectTransaction(@PathVariable Long id) {
        Transaction transaction = transactionService.updateTransactionStatus(id, "FAILED");
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Transaction rejected successfully");
        response.put("transaction", transaction);
        return response;
    }

    @GetMapping("/transactions/export")
    public void exportTransactions(@RequestParam String format,
                                 @RequestParam(required = false) String startDate,
                                 @RequestParam(required = false) String endDate) {
        // Implementation for exporting transactions
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