package com.accounting.controller;

import com.accounting.model.User;
import com.accounting.model.Transaction;
import com.accounting.service.AdminDashboardService;
import com.accounting.service.UserService;
import com.accounting.model.Student;
import com.accounting.service.StudentService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
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

    private static final Logger logger = LoggerFactory.getLogger(AdminController.class);

    private final AdminDashboardService adminDashboardService;
    private final UserService userService;
    private final StudentService studentService;

    @Autowired
    public AdminController(AdminDashboardService adminDashboardService, UserService userService, StudentService studentService) {
        this.adminDashboardService = adminDashboardService;
        this.userService = userService;
        this.studentService = studentService;
    }

    @GetMapping("/dashboard")
    @Transactional(readOnly = true)
    public String showDashboard(Model model, 
                              @RequestParam(defaultValue = "1") int page,
                              @RequestParam(defaultValue = "10") int size) {
        try {
            // Get dashboard statistics
            Map<String, Object> stats = adminDashboardService.getDashboardStatistics();
            
            // Add statistics to model
            model.addAttribute("totalUsers", stats.get("totalUsers"));
            model.addAttribute("activeUsers", stats.get("activeUsers"));
            model.addAttribute("totalRevenue", stats.get("totalRevenue"));
            model.addAttribute("pendingQueues", stats.get("pendingQueues"));
            model.addAttribute("todayTransactions", stats.get("todayTransactions"));
            model.addAttribute("averageWaitTime", stats.get("averageWaitTime"));
            model.addAttribute("pendingStudentRegistrations", stats.get("pendingStudentRegistrations"));
            
            // Add chart data
            model.addAttribute("transactionLabels", stats.get("transactionLabels"));
            model.addAttribute("transactionData", stats.get("transactionData"));
            model.addAttribute("queueLabels", stats.get("queueLabels"));
            model.addAttribute("queueData", stats.get("queueData"));
            
            // Get paginated users and initialize collections
            Page<User> usersPage = userService.findAllUsers(PageRequest.of(page - 1, size));
            List<User> users = usersPage.getContent();
            for (User user : users) {
                // Initialize collections to prevent lazy loading issues
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
            model.addAttribute("currentPage", usersPage.getNumber() + 1);
            model.addAttribute("totalPages", usersPage.getTotalPages());
            model.addAttribute("totalItems", usersPage.getTotalElements());
            
            return "admin/dashboard";
        } catch (Exception e) {
            logger.error("Error loading dashboard: {}", e.getMessage(), e);
            model.addAttribute("error", "Failed to load dashboard data. Please try again later.");
            return "admin/dashboard";
        }
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
    public String showUsers(Model model) {
        try {
            List<User> users = userService.getAllUsers();
            
            // Initialize collections to prevent lazy loading issues
            for (User user : users) {
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
            return "admin/users";
        } catch (Exception e) {
            logger.error("Error loading users: {}", e.getMessage(), e);
            model.addAttribute("error", "Failed to load users. Please try again later.");
            return "admin/users";
        }
    }

    @GetMapping("/users/partial")
    @Transactional(readOnly = true)
    public String showUsersPartial(Model model) {
        try {
            List<User> users = userService.getAllUsers();
            
            // Initialize collections to prevent lazy loading issues
            for (User user : users) {
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
            return "admin/users";
        } catch (Exception e) {
            logger.error("Error loading users: {}", e.getMessage(), e);
            model.addAttribute("error", "Failed to load users. Please try again later.");
            return "admin/users";
        }
    }

    @GetMapping("/content/{page}")
    public String getContent(@PathVariable String page, Model model) {
        try {
            switch (page) {
                case "dashboard":
                    Map<String, Object> stats = adminDashboardService.getDashboardStatistics();
                    model.addAttribute("dashboardStats", stats);
                    return "admin/dashboard :: #dashboard-content";
                case "users":
                    List<User> users = userService.getAllUsers();
                    // Initialize collections to prevent lazy loading issues
                    for (User user : users) {
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
                    return "admin/users :: #users-content";
                case "transactions":
                    model.addAttribute("transactionStats", adminDashboardService.getTransactionStatistics(
                        LocalDateTime.now().minusDays(7), LocalDateTime.now()));
                    return "admin/transactions :: #transactions-content";
                case "queue":
                    model.addAttribute("queueStats", adminDashboardService.getQueueStats());
                    return "admin/queue :: #queue-content";
                case "student":
                    Pageable pageable = PageRequest.of(0, 9, Sort.by("createdAt").descending());
                    Page<Student> studentsPage = studentService.getStudentsByStatusAndProgram(null, null, pageable);
                    
                    // Initialize collections to prevent lazy loading issues
                    studentsPage.getContent().forEach(student -> {
                        student.getUser().getNotificationSettings().size();
                        student.getUser().getNotifications().size();
                        student.getUser().getTransactions().size();
                        student.getUser().getDocuments().size();
                    });
                    
                    model.addAttribute("students", studentsPage.getContent());
                    model.addAttribute("currentPage", studentsPage.getNumber());
                    model.addAttribute("totalPages", studentsPage.getTotalPages());
                    model.addAttribute("totalItems", studentsPage.getTotalElements());
                    return "admin/students :: #student-content";
                case "reports":
                    return "admin/reports :: #reports-content";
                case "settings":
                    return "admin/settings :: #settings-content";
                default:
                    logger.warn("Unknown page requested: {}", page);
                    return "admin/dashboard :: #dashboard-content";
            }
        } catch (Exception e) {
            logger.error("Error loading content for page {}: {}", page, e.getMessage(), e);
            model.addAttribute("error", "Failed to load content. Please try again later.");
            return "admin/dashboard :: #dashboard-content";
        }
    }

    @GetMapping("/users/{id}")
    @Transactional(readOnly = true)
    public String viewUser(@PathVariable Long id, Model model) {
        User user = userService.findById(id);
        
        // Initialize collections to prevent lazy loading issues
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
        
        model.addAttribute("user", user);
        model.addAttribute("content", "admin/user-details");
        return "admin/dashboard";
    }

    @GetMapping("/users/search")
    @Transactional(readOnly = true)
    public String searchUsers(
            @RequestParam(required = false) String term,
            @RequestParam(required = false) String role,
            @RequestParam(required = false) String status,
            Model model) {
        try {
            // Get filtered users
            Page<User> usersPage = userService.searchUsers(term, role, status, PageRequest.of(0, 10));
            List<User> users = usersPage.getContent();
            
            // Initialize collections
            for (User user : users) {
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
            return "admin/users :: #userTableBody";
        } catch (Exception e) {
            logger.error("Error searching users: {}", e.getMessage(), e);
            model.addAttribute("error", "Failed to search users. Please try again later.");
            return "admin/users :: #userTableBody";
        }
    }
} 