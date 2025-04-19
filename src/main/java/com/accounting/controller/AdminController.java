package com.accounting.controller;

import com.accounting.model.User;
import com.accounting.model.Transaction;
import com.accounting.service.AdminDashboardService;
import com.accounting.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private final AdminDashboardService adminDashboardService;
    private final UserService userService;

    @Autowired
    public AdminController(AdminDashboardService adminDashboardService, UserService userService) {
        this.adminDashboardService = adminDashboardService;
        this.userService = userService;
    }

    @GetMapping("/dashboard")
    @Transactional(readOnly = true)
    public String showDashboard(Model model, 
                              @RequestParam(defaultValue = "1") int page,
                              @RequestParam(defaultValue = "10") int size) {
        // Get dashboard statistics
        Map<String, Object> stats = adminDashboardService.getDashboardStatistics();
        model.addAttribute("totalUsers", stats.get("totalUsers"));
        model.addAttribute("activeUsers", stats.get("activeUsers"));
        model.addAttribute("totalRevenue", stats.get("totalRevenue"));
        
        // Get queue statistics
        Map<String, Long> statusCounts = adminDashboardService.getStatusCounts();
        Map<String, Long> dailyCounts = adminDashboardService.getDailyCounts();
        Map<String, Long> queueStats = adminDashboardService.getQueueStats();
        
        model.addAttribute("pendingQueues", statusCounts.get("waitingQueues"));
        model.addAttribute("todayTransactions", dailyCounts.get("todayTransactions"));
        model.addAttribute("averageWaitTime", queueStats.get("averageWaitTime"));
        
        // Get chart data
        Map<String, Object> transactionStats = adminDashboardService.getTransactionStatistics(
            LocalDateTime.now().minusDays(7), LocalDateTime.now());
        model.addAttribute("transactionLabels", transactionStats.get("labels"));
        model.addAttribute("transactionData", transactionStats.get("data"));
        
        model.addAttribute("queueLabels", queueStats.get("labels"));
        model.addAttribute("queueData", queueStats.get("data"));

        // Get paginated users and initialize their collections
        Page<User> usersPage = userService.findAllUsers(PageRequest.of(page - 1, size));
        List<User> users = usersPage.getContent();
        for (User user : users) {
            // Initialize all collections
            if (user.getNotificationSettings() != null) {
                user.getNotificationSettings().size();
            }
            if (user.getTransactions() != null) {
                user.getTransactions().size();
            }
            if (user.getDocuments() != null) {
                user.getDocuments().size();
            }
            if (user.getNotifications() != null) {
                user.getNotifications().size();
            }
        }
        model.addAttribute("users", users);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", usersPage.getTotalPages());

        // Get recent transactions and initialize their user collections
        List<Transaction> recentTransactions = adminDashboardService.getRecentTransactions();
        for (Transaction transaction : recentTransactions) {
            if (transaction.getUser() != null) {
                User user = transaction.getUser();
                // Initialize all collections for the transaction's user
                if (user.getNotificationSettings() != null) {
                    user.getNotificationSettings().size();
                }
                if (user.getTransactions() != null) {
                    user.getTransactions().size();
                }
                if (user.getDocuments() != null) {
                    user.getDocuments().size();
                }
                if (user.getNotifications() != null) {
                    user.getNotifications().size();
                }
            }
        }
        model.addAttribute("recentTransactions", recentTransactions);
        
        // Get notifications
        model.addAttribute("notifications", adminDashboardService.getRecentNotifications());

        return "admin/dashboard";
    }

    @GetMapping("/user/{username}")
    @ResponseBody
    public User getUser(@PathVariable String username) {
        return userService.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    @PutMapping("/user/{username}")
    @ResponseBody
    public ResponseEntity<?> updateUser(@PathVariable String username, @RequestBody User userData) {
        try {
            userService.updateUser(username, userData);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @DeleteMapping("/user/{username}")
    @ResponseBody
    public ResponseEntity<?> deleteUser(@PathVariable String username) {
        try {
            userService.deleteUser(username);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/transactions")
    @ResponseBody
    public ResponseEntity<?> searchTransactions(
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String status) {
        try {
            return ResponseEntity.ok(adminDashboardService.searchTransactions(search, status));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/users")
    @Transactional(readOnly = true)
    public String showUsers(Model model, 
                          @RequestParam(defaultValue = "1") int page,
                          @RequestParam(defaultValue = "10") int size) {
        // Get paginated users and initialize their collections
        Page<User> usersPage = userService.findAllUsers(PageRequest.of(page - 1, size));
        List<User> users = usersPage.getContent();
        for (User user : users) {
            // Initialize all collections
            if (user.getNotificationSettings() != null) {
                user.getNotificationSettings().size();
            }
            if (user.getTransactions() != null) {
                user.getTransactions().size();
            }
            if (user.getDocuments() != null) {
                user.getDocuments().size();
            }
            if (user.getNotifications() != null) {
                user.getNotifications().size();
            }
        }
        model.addAttribute("users", users);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", usersPage.getTotalPages());
        return "admin/users";
    }

    @GetMapping("/content/{page}")
    public String getContent(@PathVariable String page, Model model) {
        // Add any necessary data to the model based on the page being loaded
        switch (page) {
            case "admin/dashboard":
                Map<String, Object> stats = adminDashboardService.getDashboardStatistics();
                model.addAttribute("dashboardStats", stats);
                break;
            case "admin/queue":
                model.addAttribute("queueStats", adminDashboardService.getQueueStats());
                break;
            case "admin/reports":
                model.addAttribute("reportStats", adminDashboardService.getReportStats());
                break;
            case "admin/settings":
                model.addAttribute("systemSettings", adminDashboardService.getSystemSettings());
                break;
            case "admin/transactions":
                model.addAttribute("transactionStats", adminDashboardService.getTransactionStatistics(
                    LocalDateTime.now().minusDays(7), LocalDateTime.now()));
                break;
            case "admin/users":
                model.addAttribute("users", userService.findAllUsers(PageRequest.of(0, 10)));
                break;
        }
        
        // Return the corresponding JSP view
        return page;
    }
} 