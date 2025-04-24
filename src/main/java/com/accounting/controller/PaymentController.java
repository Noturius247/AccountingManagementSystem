package com.accounting.controller;

import com.accounting.model.Payment;
import com.accounting.model.Student;
import com.accounting.model.enums.PaymentStatus;
import com.accounting.model.enums.PaymentType;
import com.accounting.service.PaymentService;
import com.accounting.service.QueueService;
import com.accounting.service.StudentService;
import com.accounting.service.TransactionService;
import jakarta.persistence.EntityNotFoundException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.ui.Model;
import java.math.BigDecimal;

@Controller
@RequestMapping("/payments")
public class PaymentController {

    private final StudentService studentService;
    private final TransactionService transactionService;
    private final PaymentService paymentService;
    private final QueueService queueService;
    private static final Logger logger = LoggerFactory.getLogger(PaymentController.class);

    @Autowired
    public PaymentController(StudentService studentService, TransactionService transactionService, PaymentService paymentService, QueueService queueService) {
        this.studentService = studentService;
        this.transactionService = transactionService;
        this.paymentService = paymentService;
        this.queueService = queueService;
    }

    @GetMapping
    public String redirectToKiosk(RedirectAttributes redirectAttributes) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        
        // Check if user has ROLE_STUDENT
        boolean isStudent = authentication.getAuthorities().stream()
            .anyMatch(a -> a.getAuthority().equals("ROLE_STUDENT"));
            
        if (!isStudent) {
            // If not a student, redirect to enrollment payment
            return "redirect:/kiosk/payment/enrollment";
        }
        
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

    @PostMapping("/transcript/process")
    public String processTranscriptPayment(
            @RequestParam String studentId,
            @RequestParam Integer copies,
            @RequestParam String purpose,
            Model model) {
        try {
            Student student = studentService.findById(Long.parseLong(studentId));
            if (student == null) {
                throw new EntityNotFoundException("Student ID not found. Please register first.");
            }

            // Calculate total amount
            BigDecimal basePrice = new BigDecimal("200.00");
            BigDecimal totalAmount = basePrice.multiply(new BigDecimal(copies));

            // Create payment through service
            Payment payment = paymentService.createPayment(Payment.builder()
                .description("Transcript Request - " + copies + " copies (" + purpose + ")")
                .amount(totalAmount)
                .paymentStatus(PaymentStatus.PENDING)
                .type(PaymentType.CASH)
                .user(student.getUser())
                .paymentMethod("KIOSK")
                .transactionReference("TOR-" + System.currentTimeMillis())
                .notes("Transcript request details")
                .copies(copies)
                .purpose(purpose)
                .basePrice(basePrice)
                .build());
            
            Payment processedPayment = paymentService.processPayment(payment);
            if (processedPayment == null) {
                throw new RuntimeException("Failed to process payment");
            }
            
            String queueNumber = queueService.generateQueueNumber();
            if (queueNumber == null || queueNumber.trim().isEmpty()) {
                throw new RuntimeException("Failed to generate queue number");
            }
            
            try {
                queueService.createQueueEntry(queueNumber, processedPayment.getId());
            } catch (Exception e) {
                logger.error("Failed to create queue entry: {}", e.getMessage());
            }
            
            model.addAttribute("payment", processedPayment);
            model.addAttribute("queueNumber", queueNumber);
            model.addAttribute("student", student);
            
            return "features/payment-confirmation";
        } catch (Exception e) {
            model.addAttribute("error", "Failed to process payment: " + e.getMessage());
            model.addAttribute("studentId", studentId);
            model.addAttribute("copies", copies);
            model.addAttribute("purpose", purpose);
            return "features/transcript-payment";
        }
    }
} 