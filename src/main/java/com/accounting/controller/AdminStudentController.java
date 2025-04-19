package com.accounting.controller;

import com.accounting.model.Student;
import com.accounting.service.StudentService;
import com.accounting.service.EmailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin/students")
@PreAuthorize("hasRole('ADMIN')")
public class AdminStudentController {

    private final StudentService studentService;
    private final EmailService emailService;

    @Autowired
    public AdminStudentController(StudentService studentService, EmailService emailService) {
        this.studentService = studentService;
        this.emailService = emailService;
    }

    @GetMapping("/pending")
    public String showPendingRegistrations(Model model) {
        List<Student> pendingStudents = studentService.findByRegistrationStatus("PENDING");
        model.addAttribute("pendingStudents", pendingStudents);
        return "admin/pending-registrations";
    }

    @PostMapping("/approve/{id}")
    public String approveRegistration(@PathVariable Long id) {
        Student student = studentService.findById(id);
        student.setRegistrationStatus("COMPLETED");
        studentService.save(student);
        
        // Send approval email
        emailService.sendRegistrationApprovedEmail(
            student.getUser().getEmail(),
            student.getFullName(),
            student.getStudentId()
        );
        
        return "redirect:/admin/students/pending";
    }

    @PostMapping("/reject/{id}")
    public String rejectRegistration(@PathVariable Long id, @RequestParam String reason) {
        Student student = studentService.findById(id);
        student.setRegistrationStatus("REJECTED");
        studentService.save(student);
        
        // Send rejection email
        emailService.sendRegistrationRejectedEmail(
            student.getUser().getEmail(),
            student.getFullName(),
            student.getStudentId(),
            reason
        );
        
        return "redirect:/admin/students/pending";
    }
} 