package com.accounting.service;

import com.accounting.model.Payment;
import com.accounting.model.enums.PaymentStatus;
import java.math.BigDecimal;
import java.util.Map;

public interface PaymentGatewayService {
    /**
     * Process a payment through the payment gateway
     */
    Payment processPayment(Payment payment);
    
    /**
     * Verify payment status
     */
    PaymentStatus verifyPayment(String transactionId);
    
    /**
     * Refund a payment
     */
    Payment refundPayment(String transactionId, BigDecimal amount);
    
    /**
     * Schedule a recurring payment
     */
    Payment schedulePayment(Payment payment, String schedule);
    
    /**
     * Cancel a scheduled payment
     */
    boolean cancelScheduledPayment(String scheduleId);
    
    /**
     * Get payment gateway configuration
     */
    Map<String, String> getGatewayConfig();
    
    /**
     * Handle payment webhook
     */
    void handleWebhook(String payload);
} 