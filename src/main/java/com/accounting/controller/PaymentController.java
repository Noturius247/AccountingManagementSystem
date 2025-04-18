package com.accounting.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import com.accounting.service.PaymentService;
import com.accounting.model.Payment;
import com.accounting.model.enums.PaymentStatus;
import com.accounting.repository.PaymentRepository;
import java.util.List;

@Controller
@RequestMapping("/user/payments")
public class PaymentController {

    private final PaymentService paymentService;
    private final PaymentRepository paymentRepository;

    @Autowired
    public PaymentController(PaymentService paymentService, PaymentRepository paymentRepository) {
        this.paymentService = paymentService;
        this.paymentRepository = paymentRepository;
    }

    @GetMapping
    public String viewPayments(Model model) {
        List<Payment> payments = paymentRepository.findAllWithUser();
        model.addAttribute("payments", payments);
        model.addAttribute("statistics", paymentService.getPaymentStatistics());
        return "user/payments";
    }
} 