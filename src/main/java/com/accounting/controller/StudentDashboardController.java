package com.accounting.controller;

import com.accounting.model.Student;
import com.accounting.model.Transaction;
import com.accounting.model.Document;
import com.accounting.service.StudentService;
import com.accounting.service.TransactionService;
import com.accounting.service.DocumentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;

@Controller
@RequestMapping("/student")
public class StudentDashboardController {

    private final StudentService studentService;
    private final TransactionService transactionService;
    private final DocumentService documentService;

    @Autowired
    public StudentDashboardController(
            StudentService studentService,
            TransactionService transactionService,
            DocumentService documentService) {
        this.studentService = studentService;
        this.transactionService = transactionService;
        this.documentService = documentService;
    }

    @GetMapping("/dashboard")
    public String showDashboard(Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();
        
        // Get student information
        Student student = studentService.findByUsername(username);
        if (student == null || student.getRegistrationStatus() == null || 
            !student.getRegistrationStatus().equals("COMPLETED")) {
            return "redirect:/student-registration";
        }

        // Add student information to model
        model.addAttribute("studentName", student.getFullName());
        model.addAttribute("studentId", student.getStudentId());
        model.addAttribute("registrationStatus", student.getRegistrationStatus());
        model.addAttribute("program", student.getProgram());
        model.addAttribute("yearLevel", student.getYearLevel());
        model.addAttribute("academicYear", student.getAcademicYear());
        model.addAttribute("semester", student.getSemester());

        // Get financial information
        double currentBalance = transactionService.getCurrentBalance(student.getId());
        double lastPayment = transactionService.getLastPaymentAmount(student.getId());
        String dueDate = transactionService.getNextDueDate(student.getId());
        
        model.addAttribute("currentBalance", String.format("%.2f", currentBalance));
        model.addAttribute("lastPayment", String.format("%.2f", lastPayment));
        model.addAttribute("dueDate", dueDate);

        // Get document information
        List<Document> documents = documentService.getStudentDocuments(student.getId());
        model.addAttribute("documentCount", documents.size());
        if (!documents.isEmpty()) {
            String lastUpdate = documents.get(0).getUpdatedAt()
                .format(DateTimeFormatter.ofPattern("MMM dd, yyyy"));
            model.addAttribute("lastDocumentUpdate", lastUpdate);
        }

        // Get recent activities
        List<Map<String, String>> recentActivities = getRecentActivities(student.getId());
        model.addAttribute("recentActivities", recentActivities);

        return "student/dashboard";
    }

    private List<Map<String, String>> getRecentActivities(Long studentId) {
        List<Map<String, String>> activities = new ArrayList<>();
        
        // Get recent transactions
        List<Transaction> recentTransactions = transactionService.getRecentTransactions(studentId, 5);
        for (Transaction transaction : recentTransactions) {
            Map<String, String> activity = new HashMap<>();
            activity.put("description", "Payment of ₱" + String.format("%.2f", transaction.getAmount()));
            activity.put("timestamp", transaction.getCreatedAt()
                .format(DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm")));
            activities.add(activity);
        }

        // Get recent document updates
        List<Document> recentDocuments = documentService.getRecentDocuments(studentId, 5);
        for (Document document : recentDocuments) {
            Map<String, String> activity = new HashMap<>();
            activity.put("description", "New document: " + document.getTitle());
            activity.put("timestamp", document.getUpdatedAt()
                .format(DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm")));
            activities.add(activity);
        }

        // Sort activities by timestamp (most recent first)
        activities.sort((a, b) -> {
            LocalDateTime timeA = LocalDateTime.parse(a.get("timestamp"), 
                DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm"));
            LocalDateTime timeB = LocalDateTime.parse(b.get("timestamp"), 
                DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm"));
            return timeB.compareTo(timeA);
        });

        return activities;
    }
} 