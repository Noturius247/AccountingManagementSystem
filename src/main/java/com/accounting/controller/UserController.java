package com.accounting.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
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
import jakarta.servlet.http.HttpServletRequest;

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
    @Transactional(readOnly = true)
    public String dashboard(Model model, Authentication authentication, HttpServletRequest request) {
        String username = authentication.getName();
        
        // Get user with initialized collections
        User user = userService.findByUsernameWithCollections(username);
        
        // Check if user is a student
        boolean isStudent = false;
        Student student = null;
        try {
            student = studentService.findByUsername(username);
            isStudent = student != null;
            if (isStudent) {
                user.setStudent(true);
                // Convert Student.RegistrationStatus to User.RegistrationStatus using the string value
                RegistrationStatus status = RegistrationStatus.valueOf(student.getRegistrationStatus().toString());
                user.setRegistrationStatus(status);
                // Add student object to model
                model.addAttribute("student", student);
            }
        } catch (EntityNotFoundException e) {
            // User is not a student, which is fine
            isStudent = false;
            user.setStudent(false);
        }
        
        // Add user to model
        model.addAttribute("user", user);
        
        // Add dashboard statistics
        model.addAttribute("stats", userDashboardService.getDashboardStatistics());
        
        // Add recent transactions
        model.addAttribute("recentTransactions", userDashboardService.getRecentTransactions());
        
        // Add user notifications
        model.addAttribute("notifications", userDashboardService.getUserNotifications());
        
        // Add user documents
        model.addAttribute("documents", userDashboardService.getUserDocuments());
        
        // Add current balance
        model.addAttribute("currentBalance", userDashboardService.getCurrentBalance(username));
        
        // Add pending payments count
        model.addAttribute("pendingPaymentsCount", userDashboardService.getPendingPaymentsCount(username));
        
        // Add queue position
        model.addAttribute("queuePosition", userDashboardService.getQueuePosition(username));
        
        // Add estimated wait time
        model.addAttribute("estimatedWaitTime", userDashboardService.getEstimatedWaitTime(username));
        
        // Add recent payments
        model.addAttribute("recentPayments", userDashboardService.getRecentPayments(username));
        
        // Add recent documents
        model.addAttribute("recentDocuments", userDashboardService.getRecentDocuments(username));

        // Check if this is an AJAX request
        String requestedWith = request.getHeader("X-Requested-With");
        boolean isAjax = "XMLHttpRequest".equals(requestedWith);
        
        if (isAjax) {
            // Return only the dashboard content for AJAX requests
            return "user/dashboard :: #dashboard-content";
        } else {
            // Return the full page for normal requests
            return "user/dashboard";
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