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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.util.Map;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.*;
import com.accounting.model.Student;
import com.accounting.service.StudentService;
import com.accounting.service.EmailService;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.http.ResponseEntity;

@Controller
@RequestMapping("/manager")
@PreAuthorize("hasRole('MANAGER')")
public class ManagerController {
    private static final Logger log = LoggerFactory.getLogger(ManagerController.class);
    private static final int TIMEOUT_SECONDS = 10;

    @Autowired
    private ManagerDashboardService managerDashboardService;

    @Autowired
    private QueueService queueService;

    @Autowired
    private TransactionService transactionService;

    @Autowired
    private StudentService studentService;

    @Autowired
    private EmailService emailService;

    @GetMapping("/dashboard")
    @Transactional(readOnly = true)
    public String dashboard(Model model) {
        try {
            // Create executor service for parallel execution
            ExecutorService executor = Executors.newFixedThreadPool(4);

            // Create futures for parallel data loading
            Future<Map<String, Object>> statisticsFuture = executor.submit(() -> 
                managerDashboardService.getDashboardStatistics());
            
            Future<List<Map<String, Object>>> tasksFuture = executor.submit(() ->
                managerDashboardService.getRecentTasks());
            
            Future<List<Map<String, Object>>> teamMembersFuture = executor.submit(() ->
                managerDashboardService.getTeamMembers());
                
            Future<List<Map<String, Object>>> systemAlertsFuture = executor.submit(() ->
                managerDashboardService.getSystemAlerts());

            // Get results with timeout
            try {
                Map<String, Object> statistics = statisticsFuture.get(TIMEOUT_SECONDS, TimeUnit.SECONDS);
                List<Map<String, Object>> recentTasks = tasksFuture.get(TIMEOUT_SECONDS, TimeUnit.SECONDS);
                List<Map<String, Object>> teamMembers = teamMembersFuture.get(TIMEOUT_SECONDS, TimeUnit.SECONDS);
                List<Map<String, Object>> systemAlerts = systemAlertsFuture.get(TIMEOUT_SECONDS, TimeUnit.SECONDS);

                // Add all attributes to the model
                model.addAttribute("statistics", statistics);
                model.addAttribute("recentTasks", recentTasks);
                model.addAttribute("teamMembers", teamMembers);
                model.addAttribute("systemAlerts", systemAlerts);
                model.addAttribute("totalRevenue", statistics.get("totalRevenue"));
                model.addAttribute("revenueGrowth", statistics.get("revenueGrowth"));
                model.addAttribute("pendingApprovals", statistics.get("pendingCount"));
                model.addAttribute("activeUsers", statistics.get("activeUsers"));
                
                // Add student registration data
                List<Student> allStudents = studentService.findAll();
                model.addAttribute("students", allStudents);
                model.addAttribute("pendingCount", studentService.countByRegistrationStatus(Student.RegistrationStatus.PENDING));
                model.addAttribute("approvedCount", studentService.countByRegistrationStatus(Student.RegistrationStatus.APPROVED));
                model.addAttribute("rejectedCount", studentService.countByRegistrationStatus(Student.RegistrationStatus.REJECTED));
                
                // Load additional data
                CompletableFuture.runAsync(() -> {
                    try {
                        model.addAttribute("systemHealth", managerDashboardService.getSystemHealth());
                        model.addAttribute("recentTransactions", managerDashboardService.getRecentTransactions());
                        model.addAttribute("kioskStatus", managerDashboardService.getKioskStatus());
                    } catch (Exception e) {
                        log.error("Error loading additional dashboard data", e);
                    }
                });

                // Add current queue data
                Queue currentQueue = queueService.getCurrentQueue();
                if (currentQueue != null && currentQueue.getUser() != null) {
                    User user = currentQueue.getUser();
                    // Load essential user data only
                    Hibernate.initialize(user.getNotificationSettings());
                }
                model.addAttribute("currentQueue", currentQueue);

            } catch (TimeoutException e) {
                log.error("Timeout while loading dashboard data", e);
                model.addAttribute("error", "Dashboard data loading timeout. Please try refreshing the page.");
            } catch (Exception e) {
                log.error("Error while loading dashboard data", e);
                model.addAttribute("error", "Failed to load dashboard data: " + e.getMessage());
            } finally {
                executor.shutdown();
            }

            return "manager/dashboard";
        } catch (Exception e) {
            log.error("Critical error in dashboard", e);
            model.addAttribute("error", "A critical error occurred. Please try again later.");
            return "manager/dashboard";
        }
    }

    @GetMapping("/transactions")
    public String viewTransactions(Model model) {
        try {
            model.addAttribute("transactions", transactionService.getAllTransactions());
            return "manager/transactions";
        } catch (Exception e) {
            log.error("Error loading transactions", e);
            model.addAttribute("error", "Failed to load transactions: " + e.getMessage());
            return "manager/transactions";
        }
    }

    @GetMapping("/transactions/{id}")
    @ResponseBody
    public Transaction getTransaction(@PathVariable Long id) {
        try {
            return transactionService.getTransactionByIdWithUser(id);
        } catch (Exception e) {
            log.error("Error loading transaction {}", id, e);
            throw e;
        }
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

    @GetMapping("/student-approvals")
    public String viewPendingStudents(@RequestParam(required = false) String status, Model model) {
        try {
            List<Student> students;
            if (status == null || status.equals("PENDING")) {
                students = studentService.findByRegistrationStatus(Student.RegistrationStatus.PENDING);
            } else if (status.equals("ALL")) {
                students = studentService.findAll();
            } else {
                students = studentService.findByRegistrationStatus(Student.RegistrationStatus.valueOf(status));
            }
            model.addAttribute("students", students);
            
            // Add counts for different statuses
            model.addAttribute("pendingCount", 
                studentService.countByRegistrationStatus(Student.RegistrationStatus.PENDING));
            model.addAttribute("approvedCount", 
                studentService.countByRegistrationStatus(Student.RegistrationStatus.APPROVED));
            model.addAttribute("rejectedCount", 
                studentService.countByRegistrationStatus(Student.RegistrationStatus.REJECTED));
            
            return "manager/student-approvals";
        } catch (Exception e) {
            log.error("Error loading students", e);
            model.addAttribute("error", "Failed to load students");
            return "manager/student-approvals";
        }
    }

    @PostMapping("/student-approvals/{id}/approve")
    @Transactional
    public String approveStudent(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            Student student = studentService.findById(id);
            if (student == null) {
                throw new IllegalArgumentException("Student not found");
            }
            
            studentService.approveStudent(id);
            
            // Send approval email
            emailService.sendRegistrationApprovedEmail(
                student.getUser().getEmail(),
                student.getFullName(),
                student.getStudentId()
            );
            
            redirectAttributes.addFlashAttribute("success", "Student registration approved successfully");
        } catch (Exception e) {
            log.error("Error approving student registration", e);
            redirectAttributes.addFlashAttribute("error", "Failed to approve student registration: " + e.getMessage());
        }
        return "redirect:/manager/student-approvals";
    }

    @PostMapping("/student-approvals/{id}/reject")
    @Transactional
    public String rejectStudent(
            @PathVariable Long id,
            @RequestParam String reason,
            RedirectAttributes redirectAttributes) {
        try {
            Student student = studentService.findById(id);
            if (student == null) {
                throw new IllegalArgumentException("Student not found");
            }
            
            student.setRegistrationStatus(Student.RegistrationStatus.REJECTED);
            studentService.save(student);
            
            // Send rejection email
            emailService.sendRegistrationRejectedEmail(
                student.getUser().getEmail(),
                student.getFullName(),
                student.getStudentId(),
                reason
            );
            
            redirectAttributes.addFlashAttribute("success", "Student registration rejected successfully");
        } catch (Exception e) {
            log.error("Error rejecting student registration", e);
            redirectAttributes.addFlashAttribute("error", "Failed to reject student registration: " + e.getMessage());
        }
        return "redirect:/manager/student-approvals";
    }

    @PostMapping("/student-approvals/{id}/revoke")
    @Transactional
    public ResponseEntity<?> revokeApproval(@PathVariable Long id) {
        try {
            studentService.revokeApproval(id);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            log.error("Error revoking student approval", e);
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/student-approvals/{id}")
    @Transactional(readOnly = true)
    public String viewStudent(@PathVariable Long id, Model model) {
        try {
            Student student = studentService.findById(id);
            if (student == null) {
                throw new IllegalArgumentException("Student not found");
            }
            
            // Initialize the user to ensure it's loaded
            student.getUser().getEmail(); // This will force loading of the User entity
            
            model.addAttribute("student", student);
            return "manager/student-details";
        } catch (Exception e) {
            log.error("Error viewing student details", e);
            model.addAttribute("error", "Failed to load student details");
            return "redirect:/manager/student-approvals";
        }
    }
} 