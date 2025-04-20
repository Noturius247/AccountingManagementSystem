package com.accounting.controller;

import com.accounting.model.Student;
import com.accounting.service.EmailService;
import com.accounting.service.StudentService;
import jakarta.validation.ConstraintViolationException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/student-management")
@PreAuthorize("hasRole('ADMIN')")
public class StudentManagementController {

    private final StudentService studentService;
    private final EmailService emailService;

    @Autowired
    public StudentManagementController(StudentService studentService, EmailService emailService) {
        this.studentService = studentService;
        this.emailService = emailService;
    }

    @GetMapping
    @Transactional(readOnly = true)
    public String listStudents(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "9") int size,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String program,
            @RequestParam(required = false) String search,
            Model model) {
        
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        Page<Student> studentsPage;
        
        if (search != null && !search.isEmpty()) {
            studentsPage = studentService.searchStudents(search, status, program, pageable);
        } else {
            studentsPage = studentService.getStudentsByStatusAndProgram(status, program, pageable);
        }
        
        // Initialize the collections to prevent lazy loading issues
        studentsPage.getContent().forEach(student -> {
            student.getUser().getNotificationSettings().size(); // Initialize notificationSettings
            student.getUser().getNotifications().size(); // Initialize notifications
            student.getUser().getTransactions().size(); // Initialize transactions
            student.getUser().getDocuments().size(); // Initialize documents
        });
        
        model.addAttribute("students", studentsPage.getContent());
        model.addAttribute("currentPage", studentsPage.getNumber());
        model.addAttribute("totalPages", studentsPage.getTotalPages());
        model.addAttribute("totalItems", studentsPage.getTotalElements());
        model.addAttribute("status", status);
        model.addAttribute("program", program);
        model.addAttribute("search", search);
        model.addAttribute("totalStudents", studentService.countByRegistrationStatus(null));
        model.addAttribute("pendingCount", studentService.countByRegistrationStatus("PENDING"));
        model.addAttribute("approvedCount", studentService.countByRegistrationStatus("APPROVED"));
        model.addAttribute("rejectedCount", studentService.countByRegistrationStatus("REJECTED"));
        
        return "admin/students";
    }

    @GetMapping("/pending")
    @Transactional(readOnly = true)
    public String listPendingStudents(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "9") int size,
            Model model) {
        
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        Page<Student> studentsPage = studentService.getStudentsByStatusAndProgram("PENDING", null, pageable);
        
        // Initialize the collections to prevent lazy loading issues
        studentsPage.getContent().forEach(student -> {
            student.getUser().getNotificationSettings().size(); // Initialize notificationSettings
            student.getUser().getNotifications().size(); // Initialize notifications
            student.getUser().getTransactions().size(); // Initialize transactions
            student.getUser().getDocuments().size(); // Initialize documents
        });
        
        model.addAttribute("students", studentsPage.getContent());
        model.addAttribute("currentPage", studentsPage.getNumber());
        model.addAttribute("totalPages", studentsPage.getTotalPages());
        model.addAttribute("totalItems", studentsPage.getTotalElements());
        model.addAttribute("status", "PENDING");
        model.addAttribute("pendingCount", studentService.countByRegistrationStatus("PENDING"));
        
        return "admin/students";
    }

    @GetMapping("/approved")
    @Transactional(readOnly = true)
    public String listApprovedStudents(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "9") int size,
            Model model) {
        
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        Page<Student> studentsPage = studentService.getStudentsByStatusAndProgram("APPROVED", null, pageable);
        
        // Initialize the collections to prevent lazy loading issues
        studentsPage.getContent().forEach(student -> {
            student.getUser().getNotificationSettings().size(); // Initialize notificationSettings
            student.getUser().getNotifications().size(); // Initialize notifications
            student.getUser().getTransactions().size(); // Initialize transactions
            student.getUser().getDocuments().size(); // Initialize documents
        });
        
        model.addAttribute("students", studentsPage.getContent());
        model.addAttribute("currentPage", studentsPage.getNumber());
        model.addAttribute("totalPages", studentsPage.getTotalPages());
        model.addAttribute("totalItems", studentsPage.getTotalElements());
        model.addAttribute("status", "APPROVED");
        model.addAttribute("pendingCount", studentService.countByRegistrationStatus("PENDING"));
        
        return "admin/students";
    }

    @GetMapping("/{id}")
    @Transactional(readOnly = true)
    public String viewStudent(@PathVariable Long id, Model model) {
        Student student = studentService.getStudentById(id);
        
        // Initialize the collections to prevent lazy loading issues
        student.getUser().getNotificationSettings().size(); // Initialize notificationSettings
        student.getUser().getNotifications().size(); // Initialize notifications
        student.getUser().getTransactions().size(); // Initialize transactions
        student.getUser().getDocuments().size(); // Initialize documents
        
        model.addAttribute("student", student);
        model.addAttribute("content", "admin/student-details");
        return "admin/dashboard";
    }

    @PostMapping("/{id}/approve")
    @Transactional
    public String approveStudent(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            Student student = studentService.getStudentById(id);
            studentService.approveStudent(id);
            
            // Send approval email
            emailService.sendRegistrationApprovedEmail(
                student.getUser().getEmail(),
                student.getFullName(),
                student.getStudentId()
            );
            
            redirectAttributes.addFlashAttribute("success", "Student registration approved successfully");
        } catch (IllegalStateException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to approve student registration");
        }
        
        return "redirect:/admin/student-management/pending";
    }

    @PostMapping("/{id}/reject")
    @Transactional
    public String rejectStudent(
            @PathVariable Long id,
            @RequestParam String reason,
            RedirectAttributes redirectAttributes) {
        try {
            Student student = studentService.getStudentById(id);
            studentService.rejectStudent(id);
            
            // Send rejection email
            emailService.sendRegistrationRejectedEmail(
                student.getUser().getEmail(),
                student.getFullName(),
                student.getStudentId(),
                reason
            );
            
            redirectAttributes.addFlashAttribute("success", "Student registration rejected successfully");
        } catch (IllegalStateException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to reject student registration");
        }
        
        return "redirect:/admin/student-management/pending";
    }

    @ExceptionHandler(ConstraintViolationException.class)
    public String handleValidationException(ConstraintViolationException ex, RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute("error", "Validation failed: " + ex.getMessage());
        return "redirect:/admin/student-management";
    }

    @ExceptionHandler(IllegalStateException.class)
    public String handleIllegalStateException(IllegalStateException ex, RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute("error", ex.getMessage());
        return "redirect:/admin/student-management";
    }
} 