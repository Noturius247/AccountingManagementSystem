package com.accounting.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import com.accounting.service.TransactionService;
import com.accounting.service.UserService;
import com.accounting.model.User;
import java.security.Principal;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/user/payments")
public class UserPaymentController {

    @Autowired
    private TransactionService transactionService;

    @Autowired
    private UserService userService;

    @GetMapping
    public String viewPayments(Model model, Principal principal) {
        User user = userService.findByUsername(principal.getName()).orElseThrow();
        
        // Get payment statistics
        Map<String, Object> statistics = new HashMap<>();
        statistics.put("totalPayments", transactionService.getTotalPaymentsByUser(user));
        statistics.put("pendingPayments", transactionService.getTransactionCountByStatus("PENDING"));
        statistics.put("currentBalance", transactionService.getCurrentBalance(user.getId()));
        
        // Get recent payments
        model.addAttribute("payments", transactionService.getTransactionsByUser(user.getId()));
        model.addAttribute("statistics", statistics);
        
        return "user/payments";
    }

    @GetMapping("/new")
    public String newPayment() {
        return "redirect:/kiosk/payment";
    }
} 