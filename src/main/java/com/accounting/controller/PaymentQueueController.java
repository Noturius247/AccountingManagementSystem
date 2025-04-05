package com.accounting.controller;

import com.accounting.model.PaymentQueue;
import com.accounting.service.PaymentQueueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/queue")
public class PaymentQueueController {

    private final PaymentQueueService paymentQueueService;

    @Autowired
    public PaymentQueueController(PaymentQueueService paymentQueueService) {
        this.paymentQueueService = paymentQueueService;
    }

    @GetMapping
    public ResponseEntity<List<PaymentQueue>> getAllQueues() {
        return ResponseEntity.ok(paymentQueueService.getAllQueues());
    }

    @GetMapping("/{queueNumber}")
    public ResponseEntity<PaymentQueue> getQueueItem(@PathVariable String queueNumber) {
        PaymentQueue queue = paymentQueueService.getQueueItem(queueNumber);
        return queue != null ? ResponseEntity.ok(queue) : ResponseEntity.notFound().build();
    }

    @PostMapping
    public ResponseEntity<PaymentQueue> addToQueue(@RequestBody PaymentQueue payment) {
        return ResponseEntity.ok(paymentQueueService.addToQueue(payment));
    }

    @PutMapping("/{queueNumber}/status")
    public ResponseEntity<PaymentQueue> updateStatus(
            @PathVariable String queueNumber,
            @RequestParam String status) {
        PaymentQueue updated = paymentQueueService.updateQueueStatus(queueNumber, status);
        return updated != null ? ResponseEntity.ok(updated) : ResponseEntity.notFound().build();
    }

    @DeleteMapping("/{queueNumber}")
    public ResponseEntity<Void> removeFromQueue(@PathVariable String queueNumber) {
        paymentQueueService.removeFromQueue(queueNumber);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/status/{status}")
    public ResponseEntity<List<PaymentQueue>> getQueuesByStatus(@PathVariable String status) {
        return ResponseEntity.ok(paymentQueueService.getQueuesByStatus(status));
    }

    @GetMapping("/stats/active")
    public ResponseEntity<Integer> getActiveQueueCount() {
        return ResponseEntity.ok(paymentQueueService.getActiveQueueCount());
    }

    @GetMapping("/stats/total-amount")
    public ResponseEntity<Double> getTotalQueueAmount() {
        return ResponseEntity.ok(paymentQueueService.getTotalQueueAmount());
    }

    @GetMapping("/payment-types")
    public ResponseEntity<List<String>> getPaymentTypes() {
        return ResponseEntity.ok(paymentQueueService.getPaymentTypes());
    }
} 