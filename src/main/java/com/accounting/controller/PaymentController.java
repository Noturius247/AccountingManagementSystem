package com.accounting.controller;

import com.accounting.model.Student;
import com.accounting.service.StudentService;
import com.accounting.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/payments")
public class PaymentController {

    private final StudentService studentService;
    private final TransactionService transactionService;

    @Autowired
    public PaymentController(StudentService studentService, TransactionService transactionService) {
        this.studentService = studentService;
        this.transactionService = transactionService;
    }

    @GetMapping
    public String redirectToKiosk(RedirectAttributes redirectAttributes) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();
        
        // Get student information
        Student student = studentService.findByUsername(username);
        if (student == null) {
            return "redirect:/login";
        }

        // Add student information and return URL
        redirectAttributes.addFlashAttribute("studentId", student.getStudentId());
        redirectAttributes.addFlashAttribute("returnUrl", "/student/dashboard");
        redirectAttributes.addFlashAttribute("returnLabel", "Return to Student Dashboard");
        
        return "redirect:/kiosk";
    }
} 