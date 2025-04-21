package com.accounting.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import com.accounting.service.TransactionService;
import com.accounting.service.NotificationService;

@Controller
public class DashboardController {

    @Autowired
    private TransactionService transactionService;
    
    @Autowired
    private NotificationService notificationService;
} 