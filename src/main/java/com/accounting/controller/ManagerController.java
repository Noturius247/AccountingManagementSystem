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
import jakarta.servlet.http.HttpServletRequest;
import com.accounting.model.enums.TransactionStatus;
import com.accounting.model.enums.QueueStatus;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ContentDisposition;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import com.accounting.service.UserService;
import java.util.Collections;
import java.util.Optional;

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

    @Autowired
    private UserService userService;

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

                try {
                    // Add current queue data
                    Queue currentQueue = queueService.getCurrentQueue();
                    if (currentQueue != null && currentQueue.getUserUsername() != null) {
                        // Get user by username instead of direct access
                        userService.findByUsername(currentQueue.getUserUsername())
                            .ifPresent(user -> {
                                try {
                                    // Load essential user data only
                                    Hibernate.initialize(user.getNotificationSettings());
                                } catch (Exception e) {
                                    log.warn("Failed to initialize user notification settings", e);
                                }
                            });
                    }
                    model.addAttribute("currentQueue", currentQueue);
                } catch (Exception e) {
                    log.error("Error loading current queue data", e);
                    model.addAttribute("currentQueue", null);
                }

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
    public String transactions(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(required = false) String amountRange,
            Model model,
            HttpServletRequest request) {
        try {
            List<Transaction> transactions;
            
            // Apply filters if present
            if (status != null || startDate != null || endDate != null || amountRange != null) {
                transactions = transactionService.findTransactionsWithFilters(status, startDate, endDate, amountRange);
            } else {
                transactions = transactionService.getAllTransactions();
            }
            
            model.addAttribute("transactions", transactions);
            
            // Add transaction statistics with consistent naming
            model.addAttribute("totalTransactions", transactionService.getTotalTransactions());
            model.addAttribute("pendingTransactions", transactionService.getTotalPendingTransactions());
            model.addAttribute("completedTransactions", transactionService.getCompletedQueueCount());
            model.addAttribute("failedTransactions", transactionService.getTotalFailedTransactions());
            
            // Add queue data
            List<Queue> queues = queueService.findAllOrderedByPosition();
            model.addAttribute("queues", queues);
            model.addAttribute("hasProcessingQueue", queueService.hasProcessingQueue());
            
            if (isAjaxRequest(request)) {
                return "manager/transactions";
            }
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

    @GetMapping("/transaction-statistics")
    @PreAuthorize("hasRole('MANAGER')")
    @ResponseBody
    public Map<String, Object> getTransactionStatistics() {
        Map<String, Object> statistics = new HashMap<>();
        try {
            statistics.put("totalTransactions", transactionService.getTotalTransactions());
            statistics.put("pendingTransactions", transactionService.getTotalPendingTransactions());
            statistics.put("completedTransactions", transactionService.getCompletedQueueCount());
            statistics.put("failedTransactions", transactionService.getTotalFailedTransactions());
        } catch (Exception e) {
            log.error("Error fetching transaction statistics", e);
            statistics.put("error", "Failed to fetch statistics");
        }
        return statistics;
    }

    @GetMapping("/transactions/export")
    public ResponseEntity<byte[]> exportTransactions(
            @RequestParam String format,
                                 @RequestParam(required = false) String startDate,
                                 @RequestParam(required = false) String endDate) {
        try {
            byte[] content = transactionService.exportTransactions(format, startDate, endDate);
            String filename = "transactions_" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
            
            HttpHeaders headers = new HttpHeaders();
            headers.setContentDisposition(ContentDisposition.builder("attachment")
                .filename(filename + "." + format.toLowerCase())
                .build());
                
            switch (format.toLowerCase()) {
                case "pdf":
                    headers.setContentType(MediaType.APPLICATION_PDF);
                    break;
                case "excel":
                    headers.setContentType(MediaType.parseMediaType("application/vnd.ms-excel"));
                    break;
                case "csv":
                    headers.setContentType(MediaType.parseMediaType("text/csv"));
                    break;
                default:
                    throw new IllegalArgumentException("Unsupported format: " + format);
            }
            
            return new ResponseEntity<>(content, headers, HttpStatus.OK);
        } catch (Exception e) {
            log.error("Error exporting transactions", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PostMapping("/transactions/bulk-approve")
    @ResponseBody
    public Map<String, Object> bulkApprove(@RequestBody List<Long> transactionIds) {
        Map<String, Object> response = new HashMap<>();
        try {
            transactionService.bulkUpdateStatus(transactionIds, TransactionStatus.COMPLETED);
            response.put("success", true);
            response.put("message", "Transactions approved successfully");
        } catch (Exception e) {
            log.error("Error in bulk approve", e);
            response.put("success", false);
            response.put("message", "Failed to approve transactions: " + e.getMessage());
        }
        return response;
    }

    @PostMapping("/transactions/bulk-reject")
    @ResponseBody
    public Map<String, Object> bulkReject(@RequestBody List<Long> transactionIds) {
        Map<String, Object> response = new HashMap<>();
        try {
            transactionService.bulkUpdateStatus(transactionIds, TransactionStatus.FAILED);
            response.put("success", true);
            response.put("message", "Transactions rejected successfully");
        } catch (Exception e) {
            log.error("Error in bulk reject", e);
            response.put("success", false);
            response.put("message", "Failed to reject transactions: " + e.getMessage());
        }
        return response;
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

    @GetMapping("/transactions/queue")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getQueueDetails(
            @RequestParam(required = false) String queueNumber,
            @RequestParam(required = false) String status) {
        try {
            Map<String, Object> response = new HashMap<>();
            List<Queue> queues;
            
            if (queueNumber != null && !queueNumber.trim().isEmpty()) {
                // Search by queue number
                Optional<Queue> queue = queueService.findByQueueNumber(queueNumber);
                queues = queue.map(Collections::singletonList).orElse(Collections.emptyList());
            } else if (status != null) {
                // Filter by status
                queues = queueService.findByStatus(QueueStatus.valueOf(status.toUpperCase()));
            } else {
                // Get all queues ordered by position
                queues = queueService.findAllOrderedByPosition();
            }
            
            // Enrich processing queues with transaction details
            queues.stream()
                .filter(queue -> queue.getStatus() == QueueStatus.PROCESSING)
                .forEach(queue -> {
                    Transaction transaction = transactionService.findById(queue.getPaymentId());
                    if (transaction != null) {
                        // Update only the queue status based on transaction status
                        queue.setStatus(QueueStatus.valueOf(transaction.getStatus().name()));
                    }
                });
            
            response.put("queues", queues);
            response.put("totalQueues", queues.size());
            response.put("currentPosition", queueService.getCurrentPosition());
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Error fetching queue details", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Collections.singletonMap("error", "Failed to fetch queue details: " + e.getMessage()));
        }
    }

    @PostMapping("/transactions/queue/next")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> moveToNextQueue() {
        try {
            Queue nextQueue = queueService.moveToNextQueue();
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("queue", nextQueue);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Error moving to next queue", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Collections.singletonMap("error", "Failed to move to next queue: " + e.getMessage()));
        }
    }

    @PostMapping("/transactions/queue/previous")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> moveToPreviousQueue() {
        try {
            Queue previousQueue = queueService.moveToPreviousQueue();
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("queue", previousQueue);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Error moving to previous queue", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Collections.singletonMap("error", "Failed to move to previous queue: " + e.getMessage()));
        }
    }

    @PostMapping("/transactions/queue/{queueNumber}/jump")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> jumpToQueue(@PathVariable String queueNumber) {
        try {
            Queue queue = queueService.jumpToQueue(queueNumber);
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("queue", queue);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Error jumping to queue", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Collections.singletonMap("error", "Failed to jump to queue: " + e.getMessage()));
        }
    }

    @PostMapping("/transactions/queue/{queueId}/status")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateQueueStatus(
            @PathVariable Long queueId,
            @RequestBody Map<String, String> payload) {
        try {
            String status = payload.get("status");
            if (status == null) {
                return ResponseEntity.badRequest()
                    .body(Collections.singletonMap("error", "Status is required"));
            }

            // Validate the status
            try {
                QueueStatus.valueOf(status);
            } catch (IllegalArgumentException e) {
                return ResponseEntity.badRequest()
                    .body(Collections.singletonMap("error", "Invalid status value: " + status));
            }

            // Check if there's already a processing queue when trying to set status to PROCESSING
            if (status.equals("PROCESSING") && queueService.hasProcessingQueue()) {
                return ResponseEntity.badRequest()
                    .body(Collections.singletonMap("error", "Another queue is already being processed"));
            }

            // Update the queue status
            Queue updatedQueue = queueService.handleProcessingQueue(queueId);
            if (updatedQueue == null) {
                return ResponseEntity.notFound()
                    .build();
            }
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("queue", updatedQueue);
            response.put("message", "Queue status updated successfully");
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Error updating queue status for queue ID: " + queueId, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Collections.singletonMap("error", "Failed to update queue status: " + e.getMessage()));
        }
    }

    private boolean isAjaxRequest(HttpServletRequest request) {
        return "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
    }
} 