package com.accounting.controller;

import com.accounting.model.Student;
import com.accounting.service.StudentService;
import com.accounting.service.EmailService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

import jakarta.persistence.EntityNotFoundException;

@Controller
@RequestMapping("/manager/students")
@PreAuthorize("hasRole('MANAGER')")
public class ManagerStudentController {

    private static final Logger logger = LoggerFactory.getLogger(ManagerStudentController.class);
    private final StudentService studentService;
    private final EmailService emailService;

    @Autowired
    public ManagerStudentController(StudentService studentService, EmailService emailService) {
        this.studentService = studentService;
        this.emailService = emailService;
    }

    @GetMapping("/pending")
    public String showPendingRegistrations(Model model) {
        try {
            List<Student> pendingStudents = studentService.findByRegistrationStatus(Student.RegistrationStatus.PENDING);
            model.addAttribute("pendingStudents", pendingStudents);
            return "manager/pending-registrations";
        } catch (Exception e) {
            logger.error("Error loading pending registrations: {}", e.getMessage(), e);
            model.addAttribute("error", "Failed to load pending registrations");
            return "manager/pending-registrations";
        }
    }

    @PostMapping("/approve/{id}")
    public String approveRegistration(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            Student student = studentService.findById(id);
            student.setRegistrationStatus(Student.RegistrationStatus.APPROVED);
            studentService.save(student);
            
            emailService.sendRegistrationApprovedEmail(
                student.getUser().getEmail(),
                student.getFullName(),
                student.getStudentId()
            );
            
            redirectAttributes.addFlashAttribute("success", "Student registration approved successfully");
        } catch (EntityNotFoundException e) {
            logger.error("Student not found: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("error", "Student not found");
        } catch (Exception e) {
            logger.error("Error approving registration: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("error", "Failed to approve registration");
        }
        return "redirect:/manager/students/pending";
    }

    @PostMapping("/reject/{id}")
    public String rejectRegistration(@PathVariable Long id, @RequestParam String reason, RedirectAttributes redirectAttributes) {
        try {
            Student student = studentService.findById(id);
            student.setRegistrationStatus(Student.RegistrationStatus.REJECTED);
            studentService.save(student);
            
            emailService.sendRegistrationRejectedEmail(
                student.getUser().getEmail(),
                student.getFullName(),
                student.getStudentId(),
                reason
            );
            
            redirectAttributes.addFlashAttribute("success", "Student registration rejected successfully");
        } catch (EntityNotFoundException e) {
            logger.error("Student not found: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("error", "Student not found");
        } catch (Exception e) {
            logger.error("Error rejecting registration: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("error", "Failed to reject registration");
        }
        return "redirect:/manager/students/pending";
    }
} 