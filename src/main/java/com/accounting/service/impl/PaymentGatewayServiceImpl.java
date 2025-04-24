package com.accounting.service.impl;

import com.accounting.service.PaymentGatewayService;
import com.accounting.model.Payment;
import com.accounting.model.enums.PaymentStatus;
import com.accounting.repository.PaymentRepository;
import com.accounting.service.PdfService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.math.BigDecimal;
import java.util.Map;
import java.util.HashMap;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

@Service
@Transactional
public class PaymentGatewayServiceImpl implements PaymentGatewayService {
    private static final Logger logger = LoggerFactory.getLogger(PaymentGatewayServiceImpl.class);

    private final PaymentRepository paymentRepository;
    private final PdfService pdfService;

    @Autowired
    public PaymentGatewayServiceImpl(PaymentRepository paymentRepository, PdfService pdfService) {
        this.paymentRepository = paymentRepository;
        this.pdfService = pdfService;
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
                payment.setPaymentStatus(PaymentStatus.PROCESSED);
                payment.setProcessedAt(LocalDateTime.now());
                
                // Generate and print receipt
                String receiptContent = generateReceiptContent(payment);
                byte[] pdfReceipt = pdfService.generatePdf(receiptContent);
                printReceipt(pdfReceipt); // This will handle the actual printing
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
                refund.setPaymentStatus(PaymentStatus.PROCESSED);
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
            payment.setPaymentStatus(PaymentStatus.PENDING);
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
            
            payment.setPaymentStatus(PaymentStatus.FAILED);
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

    private String generateReceiptContent(Payment payment) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        StringBuilder receipt = new StringBuilder();
        
        receipt.append("=================================\n");
        receipt.append("         PAYMENT RECEIPT         \n");
        receipt.append("=================================\n\n");
        
        receipt.append("Transaction ID: ").append(payment.getTransactionId()).append("\n");
        receipt.append("Date: ").append(payment.getProcessedAt().format(formatter)).append("\n");
        receipt.append("Payment Number: ").append(payment.getPaymentNumber()).append("\n");
        receipt.append("Description: ").append(payment.getDescription()).append("\n\n");
        
        receipt.append("Amount: PHP ").append(String.format("%,.2f", payment.getAmount())).append("\n");
        if (payment.getTaxAmount().compareTo(BigDecimal.ZERO) > 0) {
            receipt.append("Tax: PHP ").append(String.format("%,.2f", payment.getTaxAmount())).append("\n");
        }
        receipt.append("Payment Method: ").append(payment.getPaymentMethod()).append("\n");
        receipt.append("Status: ").append(payment.getPaymentStatus()).append("\n\n");
        
        if (payment.getQueueNumber() != null) {
            receipt.append("Queue Number: ").append(payment.getQueueNumber()).append("\n");
        }
        
        receipt.append("=================================\n");
        receipt.append("Thank you for your payment!\n");
        receipt.append("This is your official receipt.\n");
        receipt.append("=================================");
        
        return receipt.toString();
    }

    private void printReceipt(byte[] pdfReceipt) {
        try {
            // Here you would implement the actual printing logic
            // This could involve sending to a thermal printer or regular printer
            // For now, we'll just log that we're printing
            logger.info("Printing receipt...");
            
            // TODO: Implement actual printer integration
            // Example: Use Java Print Service
            // PrintService printService = PrintServiceLookup.lookupDefaultPrintService();
            // if (printService != null) {
            //     DocPrintJob job = printService.createPrintJob();
            //     Doc doc = new SimpleDoc(pdfReceipt, DocFlavor.BYTE_ARRAY.AUTOSENSE, null);
            //     job.print(doc, null);
            // }
        } catch (Exception e) {
            logger.error("Error printing receipt", e);
            // Don't throw the exception as printing failure shouldn't affect payment processing
        }
    }
} 