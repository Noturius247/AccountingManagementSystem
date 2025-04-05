package com.accounting.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.accounting.service.AdminService;
import com.accounting.service.QueueService;
import com.accounting.service.TransactionService;

@Controller
@RequestMapping("/admin")
@PreAuthorize("hasRole('ADMIN')")
public class AdminController {

    @Autowired
    private AdminService adminService;

    @Autowired
    private QueueService queueService;

    @Autowired
    private TransactionService transactionService;

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("currentQueue", queueService.getCurrentQueue());
        model.addAttribute("dailyTransactions", transactionService.getDailyTransactions());
        model.addAttribute("pendingPayments", adminService.getPendingPayments());
        return "admin/dashboard";
    }

    @GetMapping("/queue/current")
    public String currentQueue(Model model) {
        model.addAttribute("queueDetails", queueService.getCurrentQueueDetails());
        return "admin/queue";
    }

    @PostMapping("/queue/next")
    @ResponseBody
    public String processNextInQueue() {
        return queueService.processNextInQueue();
    }

    @GetMapping("/transactions")
    public String transactions(
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            Model model) {
        model.addAttribute("transactions", 
            transactionService.getTransactionsByDateRange(startDate, endDate));
        return "admin/transactions";
    }

    @GetMapping("/reports")
    public String reports(Model model) {
        model.addAttribute("dailyReport", adminService.getDailyReport());
        model.addAttribute("monthlyReport", adminService.getMonthlyReport());
        return "admin/reports";
    }

    @PostMapping("/verify-receipt")
    @ResponseBody
    public boolean verifyReceipt(@RequestParam String receiptNumber) {
        return adminService.verifyReceipt(receiptNumber);
    }

    @GetMapping("/settings")
    public String settings(Model model) {
        model.addAttribute("systemSettings", adminService.getSystemSettings());
        return "admin/settings";
    }
} 