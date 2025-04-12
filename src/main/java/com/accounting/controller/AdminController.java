package com.accounting.controller;

import com.accounting.model.User;
import com.accounting.service.AdminDashboardService;
import com.accounting.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
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

        // Get paginated users
        Page<User> usersPage = userService.findAllUsers(PageRequest.of(page - 1, size));
        model.addAttribute("users", usersPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", usersPage.getTotalPages());

        // Get recent transactions
        model.addAttribute("recentTransactions", adminDashboardService.getRecentTransactions());
        
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
} 