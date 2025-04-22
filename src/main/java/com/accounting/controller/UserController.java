package com.accounting.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import com.accounting.service.UserDashboardService;
import com.accounting.model.User;
import com.accounting.service.UserService;
import org.springframework.transaction.annotation.Transactional;
import com.accounting.service.StudentService;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.security.access.AccessDeniedException;
import com.accounting.model.Transaction;
import com.accounting.service.TransactionService;
import com.accounting.model.Student;
import com.accounting.model.RegistrationStatus;
import com.accounting.model.enums.QueueStatus;
import jakarta.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import java.util.Collections;
import java.util.Comparator;
import java.util.ArrayList;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import java.security.Principal;

@Controller
@RequestMapping("/accounting/user")
@PreAuthorize("hasRole('USER')")
public class UserController {

    @Autowired
    private UserDashboardService userDashboardService;

    @Autowired
    private UserService userService;

    @Autowired
    private StudentService studentService;

    @Autowired
    private TransactionService transactionService;

    @GetMapping("/dashboard")
    public String dashboard(Model model, Principal principal) {
        try {
            if (principal == null) {
                return "redirect:/login";
            }

            User user = userService.findByUsernameWithCollections(principal.getName());
            Map<String, Object> dashboardData = new HashMap<>();
            dashboardData.put("totalTransactions", user.getTransactions().size());
            dashboardData.put("totalDocuments", user.getDocuments().size());
            dashboardData.put("totalNotifications", user.getNotifications().size());
            dashboardData.put("activeQueues", user.getQueues().size());

            model.addAttribute("user", user);
            model.addAttribute("dashboardData", dashboardData);
            
            return "user/dashboard";
        } catch (Exception e) {
            model.addAttribute("error", "Error loading dashboard: " + e.getMessage());
            return "error";
        }
    }

    @GetMapping("/dashboard/data")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getDashboardData(Principal principal) {
        try {
            if (principal == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
            }

            User user = userService.findByUsernameWithCollections(principal.getName());
            Map<String, Object> dashboardData = new HashMap<>();
            dashboardData.put("totalTransactions", user.getTransactions().size());
            dashboardData.put("totalDocuments", user.getDocuments().size());
            dashboardData.put("totalNotifications", user.getNotifications().size());
            dashboardData.put("activeQueues", user.getQueues().size());

            return ResponseEntity.ok(dashboardData);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Collections.singletonMap("error", "Failed to load dashboard data: " + e.getMessage()));
        }
    }

    @GetMapping("/transactions")
    public String transactions(Model model) {
        model.addAttribute("transactions", userDashboardService.getRecentTransactions());
        return "user/transactions";
    }

    @GetMapping("/transactions/{id}")
    @Transactional(readOnly = true)
    public String viewTransaction(@PathVariable Long id, Model model, Authentication authentication) {
        String username = authentication.getName();
        Transaction transaction = transactionService.getTransactionByIdWithUser(id);
        
        // Verify the transaction belongs to the current user
        if (!transaction.getUser().getUsername().equals(username)) {
            model.addAttribute("error", "You do not have permission to view this transaction");
            return "redirect:/user/transactions";
        }
        
        model.addAttribute("transaction", transaction);
        return "user/transaction-details";
    }
} 