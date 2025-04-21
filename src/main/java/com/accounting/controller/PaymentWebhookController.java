package com.accounting.controller;

import com.accounting.service.PaymentGatewayService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@RestController
@RequestMapping("/api/payments/webhook")
public class PaymentWebhookController {
    private static final Logger logger = LoggerFactory.getLogger(PaymentWebhookController.class);

    private final PaymentGatewayService paymentGatewayService;

    @Autowired
    public PaymentWebhookController(PaymentGatewayService paymentGatewayService) {
        this.paymentGatewayService = paymentGatewayService;
    }

    @PostMapping
    public ResponseEntity<String> handleWebhook(@RequestBody String payload, 
                                              @RequestHeader("X-Signature") String signature) {
        try {
            // Verify webhook signature
            if (!verifySignature(payload, signature)) {
                return ResponseEntity.badRequest().body("Invalid signature");
            }

            // Process webhook
            paymentGatewayService.handleWebhook(payload);
            
            return ResponseEntity.ok("Webhook processed successfully");
        } catch (Exception e) {
            logger.error("Error processing webhook", e);
            return ResponseEntity.internalServerError().body("Error processing webhook");
        }
    }

    private boolean verifySignature(String payload, String signature) {
        // Implement signature verification logic
        // This is a placeholder - you should implement proper signature verification
        return true;
    }
} 