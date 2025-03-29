package com.accounting.controller;

import com.accounting.service.PaymentQueueService;
import com.accounting.model.PaymentQueue;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/payment-queue")
public class PaymentQueueController {

    @Autowired
    private PaymentQueueService paymentQueueService;

    @PostMapping("/generate-number")
    public ResponseEntity<?> generatePriorityNumber(@RequestBody PaymentQueue request) {
        return ResponseEntity.ok(paymentQueueService.generatePriorityNumber(request));
    }

    @GetMapping("/current-status")
    public ResponseEntity<?> getCurrentStatus() {
        return ResponseEntity.ok(paymentQueueService.getCurrentStatus());
    }

    @GetMapping("/next-number")
    public ResponseEntity<?> getNextNumber() {
        return ResponseEntity.ok(paymentQueueService.getNextNumber());
    }

    @GetMapping("/queue-status")
    public ResponseEntity<?> getQueueStatus() {
        return ResponseEntity.ok(paymentQueueService.getQueueStatus());
    }

    @PutMapping("/update-status/{number}")
    public ResponseEntity<?> updateQueueStatus(@PathVariable String number) {
        return ResponseEntity.ok(paymentQueueService.updateQueueStatus(number));
    }

    @GetMapping("/estimated-wait-time")
    public ResponseEntity<?> getEstimatedWaitTime() {
        return ResponseEntity.ok(paymentQueueService.getEstimatedWaitTime());
    }

    @PostMapping("/select-payment-type")
    public ResponseEntity<?> selectPaymentType(@RequestBody PaymentQueue request) {
        return ResponseEntity.ok(paymentQueueService.selectPaymentType(request));
    }
} 