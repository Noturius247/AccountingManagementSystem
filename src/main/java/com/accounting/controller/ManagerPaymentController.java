package com.accounting.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.accounting.service.PaymentService;
import com.accounting.model.Payment;
import com.accounting.model.enums.PaymentStatus;
import com.accounting.repository.PaymentRepository;
import java.util.List;
import java.io.PrintWriter;
import java.io.IOException;
import java.time.format.DateTimeFormatter;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import jakarta.servlet.http.HttpServletResponse;
import org.hibernate.Hibernate;
import java.util.HashMap;
import java.util.Map;
import org.springframework.http.HttpStatus;

@Controller
@RequestMapping("/manager/payments")
@PreAuthorize("hasRole('MANAGER')")
public class ManagerPaymentController {

    private final PaymentService paymentService;
    private final PaymentRepository paymentRepository;

    @Autowired
    public ManagerPaymentController(PaymentService paymentService, PaymentRepository paymentRepository) {
        this.paymentService = paymentService;
        this.paymentRepository = paymentRepository;
    }

    @GetMapping
    public String viewPayments(Model model) {
        List<Payment> payments = paymentRepository.findAllWithUser();
        // Initialize notificationSettings for each payment's user
        for (Payment payment : payments) {
            if (payment.getUser() != null) {
                Hibernate.initialize(payment.getUser().getNotificationSettings());
            }
        }
        model.addAttribute("payments", payments);
        model.addAttribute("statistics", paymentService.getPaymentStatistics());
        return "manager/payments";
    }

    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Map<String, Object> getPaymentsJson() {
        List<Payment> payments = paymentRepository.findAllWithUser();
        Map<String, Object> response = new HashMap<>();
        response.put("payments", payments);
        response.put("statistics", paymentService.getPaymentStatistics());
        return response;
    }

    @GetMapping("/{id}")
    public String viewPaymentDetails(@PathVariable Long id, Model model) {
        Payment payment = paymentRepository.findByIdWithUser(id)
            .orElseThrow(() -> new RuntimeException("Payment not found"));
        // Initialize notificationSettings for the payment's user
        if (payment.getUser() != null) {
            Hibernate.initialize(payment.getUser().getNotificationSettings());
        }
        model.addAttribute("payment", payment);
        return "manager/payment-details";
    }

    @PostMapping("/{id}/approve")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> approvePayment(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        try {
            paymentService.approvePayment(id);
            response.put("success", true);
            response.put("message", "Payment approved successfully");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Failed to approve payment: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    @PostMapping("/{id}/reject")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> rejectPayment(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        try {
            paymentService.rejectPayment(id);
            response.put("success", true);
            response.put("message", "Payment rejected successfully");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Failed to reject payment: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    @GetMapping("/export")
    public void exportPayments(HttpServletResponse response) throws IOException {
        // Set response headers for CSV download
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=payments.csv");
        
        // Get all payments
        List<Payment> payments = paymentRepository.findAllWithUser();
        
        // Create CSV writer
        try (PrintWriter writer = response.getWriter()) {
            // Write CSV header
            writer.println("ID,User,Amount,Type,Status,Date,Description");
            
            // Write payment data
            for (Payment payment : payments) {
                writer.println(String.format("%d,%s,%s,%s,%s,%s,%s",
                    payment.getId(),
                    payment.getUser().getUsername(),
                    payment.getAmount(),
                    payment.getType(),
                    payment.getPaymentStatus(),
                    payment.getCreatedAt().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")),
                    payment.getDescription()
                ));
            }
        }
    }
} 