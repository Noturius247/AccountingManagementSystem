package com.accounting.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/accounting/user/payments")
public class UserPaymentController {

    @GetMapping("/new")
    public String newPayment() {
        return "redirect:/accounting/kiosk/payment";
    }
} 