package com.accounting.controller;

import com.accounting.model.User;
import com.accounting.model.Transaction;
import com.accounting.model.Manager;
import com.accounting.service.AdminDashboardService;
import com.accounting.service.UserService;
import com.accounting.service.ManagerService;
import com.accounting.model.Student;
import com.accounting.service.StudentService;
import jakarta.persistence.EntityNotFoundException;
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
    private final ManagerService managerService;
    private final StudentService studentService;

    @Autowired
    public AdminController(AdminDashboardService adminDashboardService, 
                         UserService userService,
                         ManagerService managerService,
                         StudentService studentService) {
        this.adminDashboardService = adminDashboardService;
        this.userService = userService;
        this.managerService = managerService;
        this.studentService = studentService;
    }

    @GetMapping("/dashboard")
    @Transactional(readOnly = true)
    public String showDashboard(Model model, 
                              @RequestParam(defaultValue = "1") int page,
                              @RequestParam(defaultValue = "10") int size) {
        try {
            Map<String, Object> stats = adminDashboardService.getDashboardStatistics();
            List<Map<String, Object>> recentActivities = adminDashboardService.getRecentActivities();
            
            model.addAttribute("stats", stats);
            model.addAttribute("recentActivities", recentActivities);
            return "admin/layout";
        } catch (Exception e) {
            logger.error("Error loading dashboard: {}", e.getMessage(), e);
            model.addAttribute("error", "Failed to load dashboard data");
            return "admin/layout";
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
                    List<Map<String, Object>> recentActivities = adminDashboardService.getRecentActivities();
                    model.addAttribute("stats", stats);
                    model.addAttribute("recentActivities", recentActivities);
                    return "admin/partials/dashboard";
                case "users":
                    Page<User> usersPage = userService.findAllUsers(PageRequest.of(0, 10));
                    model.addAttribute("users", usersPage.getContent());
                    model.addAttribute("currentPage", usersPage.getNumber() + 1);
                    model.addAttribute("totalPages", usersPage.getTotalPages());
                    return "admin/partials/users";
                case "managers":
                    Page<Manager> managersPage = managerService.findAllManagers(PageRequest.of(0, 10));
                    model.addAttribute("managers", managersPage.getContent());
                    model.addAttribute("currentPage", managersPage.getNumber() + 1);
                    model.addAttribute("totalPages", managersPage.getTotalPages());
                    return "admin/partials/managers";
                case "transactions":
                    List<Transaction> transactions = adminDashboardService.getRecentTransactions();
                    model.addAttribute("transactions", transactions);
                    return "admin/partials/transactions";
                case "students":
                    Page<Student> studentsPage = studentService.getStudentsByStatusAndProgram(null, null, PageRequest.of(0, 10));
                    model.addAttribute("students", studentsPage.getContent());
                    model.addAttribute("currentPage", studentsPage.getNumber() + 1);
                    model.addAttribute("totalPages", studentsPage.getTotalPages());
                    return "admin/partials/students";
                default:
                    return "admin/partials/dashboard";
            }
        } catch (Exception e) {
            logger.error("Error loading content for page {}: {}", page, e.getMessage(), e);
            model.addAttribute("error", "Failed to load content");
            return "admin/partials/error";
        }
    }

    @GetMapping("/users/{id}")
    @Transactional(readOnly = true)
    public String viewUser(@PathVariable Long id, Model model) {
        try {
            User user = userService.findById(id);
            model.addAttribute("user", user);
            return "admin/partials/user-details";
        } catch (Exception e) {
            logger.error("Error viewing user: {}", e.getMessage(), e);
            return "admin/partials/error";
        }
    }

    @GetMapping("/users/search")
    @Transactional(readOnly = true)
    public String searchUsers(
            @RequestParam(required = false) String term,
            @RequestParam(required = false) String role,
            @RequestParam(required = false) String status,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            Model model) {
        try {
            Page<User> usersPage = userService.searchUsers(term, role, status, PageRequest.of(page, size));
            model.addAttribute("users", usersPage.getContent());
            model.addAttribute("currentPage", usersPage.getNumber() + 1);
            model.addAttribute("totalPages", usersPage.getTotalPages());
            return "admin/partials/users-table";
        } catch (Exception e) {
            logger.error("Error searching users: {}", e.getMessage(), e);
            return "admin/partials/error";
        }
    }

    @GetMapping("/managers/search")
    @Transactional(readOnly = true)
    public String searchManagers(
            @RequestParam(required = false) String term,
            @RequestParam(required = false) String status,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            Model model) {
        try {
            Page<Manager> managersPage = managerService.searchManagers(term, status, PageRequest.of(page, size));
            model.addAttribute("managers", managersPage.getContent());
            model.addAttribute("currentPage", managersPage.getNumber() + 1);
            model.addAttribute("totalPages", managersPage.getTotalPages());
            return "admin/partials/managers-table";
        } catch (Exception e) {
            logger.error("Error searching managers: {}", e.getMessage(), e);
            return "admin/partials/error";
        }
    }

    @PostMapping("/managers")
    @ResponseBody
    public ResponseEntity<?> createManager(@RequestBody Manager manager) {
        try {
            Manager savedManager = managerService.createManager(manager);
            return ResponseEntity.ok(savedManager);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PutMapping("/managers/{id}")
    @ResponseBody
    public ResponseEntity<?> updateManager(@PathVariable Long id, @RequestBody Manager manager) {
        try {
            Manager updatedManager = managerService.updateManager(id, manager);
            return ResponseEntity.ok(updatedManager);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @DeleteMapping("/managers/{id}")
    @ResponseBody
    public ResponseEntity<?> deleteManager(@PathVariable Long id) {
        try {
            managerService.deleteManager(id);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping("/managers/{id}/assign-students")
    @ResponseBody
    public ResponseEntity<?> assignStudents(@PathVariable Long id, @RequestBody List<Long> studentIds) {
        try {
            managerService.assignStudentsToManager(id, studentIds);
            return ResponseEntity.ok().build();
        } catch (EntityNotFoundException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Failed to assign students to manager");
        }
    }

    @GetMapping("/managers")
    @Transactional(readOnly = true)
    public String showManagers(Model model, 
                           @RequestParam(defaultValue = "0") int page,
                           @RequestParam(defaultValue = "10") int size) {
        try {
            Page<Manager> managersPage = managerService.findAllManagers(PageRequest.of(page, size));
            model.addAttribute("managers", managersPage.getContent());
            model.addAttribute("currentPage", managersPage.getNumber() + 1);
            model.addAttribute("totalPages", managersPage.getTotalPages());
            model.addAttribute("contentPage", "managers");
            return "admin/layout";
        } catch (Exception e) {
            logger.error("Error loading managers: {}", e.getMessage(), e);
            model.addAttribute("error", "Failed to load managers");
            return "admin/layout";
        }
    }
} 