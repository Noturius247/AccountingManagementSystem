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
import com.accounting.model.Queue;

@Controller
@RequestMapping("/user")
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

            // Get the full user with all collections loaded
            User user = userService.findByUsernameWithCollections(principal.getName());
            model.addAttribute("user", user);
            
            // Dashboard statistics
            Map<String, Object> dashboardData = new HashMap<>();
            dashboardData.put("totalTransactions", user.getTransactions().size());
            dashboardData.put("totalDocuments", user.getDocuments().size());
            dashboardData.put("totalNotifications", user.getNotifications().size());
            dashboardData.put("activeQueues", user.getQueues().size());
            dashboardData.put("totalPayments", transactionService.getTotalPaymentsByUser(user));
            dashboardData.put("currentBalance", transactionService.getCurrentBalance(user.getId()));
            model.addAttribute("userStats", dashboardData);

            // Student information if available
            if (user.isStudent()) {
                try {
                    Student student = studentService.getStudentByUser(user);
                    model.addAttribute("student", student);
                    model.addAttribute("studentRegistered", true);
                    
                    // Explicitly check registration status
                    String status = student.getRegistrationStatus().name();
                    model.addAttribute("registrationPending", "PENDING".equals(status));
                    model.addAttribute("registrationRejected", "REJECTED".equals(status));
                    model.addAttribute("registrationApproved", "APPROVED".equals(status));
                    
                } catch (Exception e) {
                    model.addAttribute("studentRegistered", false);
                    model.addAttribute("registrationError", e.getMessage());
                }
            } else {
                model.addAttribute("studentRegistered", false);
            }

            // Check if user has an active queue
            Optional<Queue> activeQueue = user.getQueues().stream()
                .filter(q -> q.getStatus() == QueueStatus.PENDING || q.getStatus() == QueueStatus.PROCESSED)
                .findFirst();

            // Set queue information
            if (activeQueue.isPresent()) {
                Queue queue = activeQueue.get();
                model.addAttribute("showQueueStatus", true);
                model.addAttribute("activeQueue", queue);
            } else {
                model.addAttribute("showQueueStatus", false);
                model.addAttribute("activeQueue", null);
            }

            // Add recent transactions
            model.addAttribute("recentTransactions", 
                transactionService.getRecentTransactions(user.getId(), 5));
            
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
            
            // Add registration status if user is a student
            if (user.isStudent()) {
                try {
                    Student student = studentService.getStudentByUser(user);
                    String status = student.getRegistrationStatus().name();
                    dashboardData.put("registrationStatus", status);
                    dashboardData.put("registrationPending", "PENDING".equals(status));
                    dashboardData.put("registrationRejected", "REJECTED".equals(status));
                    dashboardData.put("registrationApproved", "APPROVED".equals(status));
                } catch (Exception e) {
                    dashboardData.put("studentRegistered", false);
                }
            }
            
            // Add other dashboard data
            dashboardData.put("totalTransactions", user.getTransactions().size());
            dashboardData.put("totalDocuments", user.getDocuments().size());
            dashboardData.put("totalNotifications", user.getNotifications().size());
            dashboardData.put("activeQueues", user.getQueues().size());
            dashboardData.put("currentBalance", transactionService.getCurrentBalance(user.getId()));
            
            // Check if user has an active queue
            Optional<Queue> userQueue = user.getQueues().stream()
                .filter(q -> q.getStatus() == QueueStatus.PENDING || q.getStatus() == QueueStatus.PROCESSED)
                .findFirst();
                
            if (userQueue.isPresent()) {
                Queue queue = userQueue.get();
                dashboardData.put("queueNumber", queue.getQueueNumber());
                dashboardData.put("position", queue.getPosition());
                dashboardData.put("estimatedWaitTime", queue.getEstimatedWaitTime());
                dashboardData.put("queueStatus", "ACTIVE");
            } else {
                dashboardData.put("queueNumber", "");
                dashboardData.put("position", 0);
                dashboardData.put("estimatedWaitTime", 0);
                dashboardData.put("queueStatus", "INACTIVE");
            }

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

    @GetMapping("/queue/status")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getQueueStatus(Principal principal) {
        try {
            Optional<User> userOpt = userService.findByUsername(principal.getName());
            if (!userOpt.isPresent()) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Collections.singletonMap("error", "User not found"));
            }
            
            User user = userOpt.get();
            Optional<Queue> activeQueue = user.getQueues().stream()
                .filter(q -> q.getStatus() == QueueStatus.PENDING || q.getStatus() == QueueStatus.PROCESSED)
                .findFirst();

            Map<String, Object> response = new HashMap<>();
            if (activeQueue.isPresent()) {
                Queue queue = activeQueue.get();
                response.put("active", true);
                response.put("queueNumber", queue.getQueueNumber());
                response.put("position", queue.getPosition());
                response.put("waitTime", queue.getEstimatedWaitTime());
            } else {
                response.put("active", false);
            }

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Collections.singletonMap("error", e.getMessage()));
        }
    }
} 