package com.accounting.service.impl;

import com.accounting.service.PaymentGatewayService;
import com.accounting.model.Payment;
import com.accounting.model.enums.PaymentStatus;
import com.accounting.repository.PaymentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.math.BigDecimal;
import java.util.Map;
import java.util.HashMap;
import java.time.LocalDateTime;
import java.util.UUID;

@Service
@Transactional
public class PaymentGatewayServiceImpl implements PaymentGatewayService {
    private static final Logger logger = LoggerFactory.getLogger(PaymentGatewayServiceImpl.class);

    private final PaymentRepository paymentRepository;

    @Autowired
    public PaymentGatewayServiceImpl(PaymentRepository paymentRepository) {
        this.paymentRepository = paymentRepository;
    }

    @Override
    public Payment processPayment(Payment payment) {
        try {
            // Generate unique transaction ID
            payment.setTransactionId(UUID.randomUUID().toString());
            payment.setPaymentStatus(PaymentStatus.PENDING);
            payment.setCreatedAt(LocalDateTime.now());
            
            // Process payment through gateway (simulated)
            boolean success = simulatePaymentProcessing(payment);
            
            if (success) {
                payment.setPaymentStatus(PaymentStatus.COMPLETED);
                payment.setProcessedAt(LocalDateTime.now());
            } else {
                payment.setPaymentStatus(PaymentStatus.FAILED);
            }
            
            return paymentRepository.save(payment);
        } catch (Exception e) {
            logger.error("Error processing payment", e);
            payment.setPaymentStatus(PaymentStatus.FAILED);
            return paymentRepository.save(payment);
        }
    }

    @Override
    public PaymentStatus verifyPayment(String transactionId) {
        try {
            Payment payment = paymentRepository.findByTransactionId(transactionId)
                .orElseThrow(() -> new RuntimeException("Payment not found"));
            return payment.getPaymentStatus();
        } catch (Exception e) {
            logger.error("Error verifying payment", e);
            return PaymentStatus.FAILED;
        }
    }

    @Override
    public Payment refundPayment(String transactionId, BigDecimal amount) {
        try {
            Payment originalPayment = paymentRepository.findByTransactionId(transactionId)
                .orElseThrow(() -> new RuntimeException("Payment not found"));
            
            Payment refund = new Payment();
            refund.setTransactionId(UUID.randomUUID().toString());
            refund.setAmount(amount.negate());
            refund.setDescription("Refund for " + originalPayment.getDescription());
            refund.setPaymentStatus(PaymentStatus.PENDING);
            refund.setCreatedAt(LocalDateTime.now());
            
            boolean success = simulatePaymentProcessing(refund);
            if (success) {
                refund.setPaymentStatus(PaymentStatus.COMPLETED);
                refund.setProcessedAt(LocalDateTime.now());
            } else {
                refund.setPaymentStatus(PaymentStatus.FAILED);
            }
            
            return paymentRepository.save(refund);
        } catch (Exception e) {
            logger.error("Error processing refund", e);
            throw new RuntimeException("Failed to process refund", e);
        }
    }

    @Override
    public Payment schedulePayment(Payment payment, String schedule) {
        try {
            payment.setTransactionId(UUID.randomUUID().toString());
            payment.setPaymentStatus(PaymentStatus.SCHEDULED);
            payment.setSchedule(schedule);
            payment.setCreatedAt(LocalDateTime.now());
            return paymentRepository.save(payment);
        } catch (Exception e) {
            logger.error("Error scheduling payment", e);
            throw new RuntimeException("Failed to schedule payment", e);
        }
    }

    @Override
    public boolean cancelScheduledPayment(String scheduleId) {
        try {
            Payment payment = paymentRepository.findByScheduleId(scheduleId)
                .orElseThrow(() -> new RuntimeException("Scheduled payment not found"));
            
            payment.setPaymentStatus(PaymentStatus.CANCELLED);
            paymentRepository.save(payment);
            return true;
        } catch (Exception e) {
            logger.error("Error cancelling scheduled payment", e);
            return false;
        }
    }

    @Override
    public Map<String, String> getGatewayConfig() {
        Map<String, String> config = new HashMap<>();
        config.put("apiKey", "your_api_key");
        config.put("merchantId", "your_merchant_id");
        config.put("endpoint", "https://api.paymentgateway.com");
        return config;
    }

    @Override
    public void handleWebhook(String payload) {
        try {
            // Parse webhook payload
            // Update payment status
            // Send notifications
            logger.info("Received webhook: {}", payload);
        } catch (Exception e) {
            logger.error("Error handling webhook", e);
        }
    }

    private boolean simulatePaymentProcessing(Payment payment) {
        // Simulate payment processing
        try {
            Thread.sleep(1000); // Simulate network delay
            return Math.random() > 0.1; // 90% success rate
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            return false;
        }
    }
} 