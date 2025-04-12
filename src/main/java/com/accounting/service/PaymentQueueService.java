package com.accounting.service;

import com.accounting.model.PaymentQueue;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

public interface PaymentQueueService {
    PaymentQueue addToQueue(PaymentQueue payment);
    PaymentQueue getQueueItem(String queueNumber);
    List<PaymentQueue> getAllQueues();
    PaymentQueue updateQueueStatus(String queueNumber, String status);
    void removeFromQueue(String queueNumber);
    List<PaymentQueue> getQueuesByStatus(String status);
    int getQueueSize();
    int getActiveQueueCount();
    BigDecimal getTotalQueueAmount();
    List<String> getPaymentTypes();
    
    void addToQueue(String username, BigDecimal amount, String description);
    void processNextPayment();
    List<Map<String, Object>> getQueueStatus();
    BigDecimal getTotalPendingAmount();
    BigDecimal getAveragePaymentAmount();
    BigDecimal getMinPaymentAmount();
    BigDecimal getMaxPaymentAmount();
    BigDecimal getTotalProcessedAmount();
    
    BigDecimal calculateTotalAmount(String username);
    BigDecimal calculatePendingAmount(String username);
    BigDecimal calculatePaidAmount(String username);
    BigDecimal calculateOverdueAmount(String username);
    BigDecimal calculateRefundAmount(String username);
    
    List<Map<String, Object>> getPaymentHistory(String username);
    Map<String, Object> getPaymentDetails(String username);
    void processPayment(String username, BigDecimal amount);
    void refundPayment(String username, BigDecimal amount);
    void updatePaymentStatus(String username, String status);
    
    Map<String, Object> getQueueStatistics(String username);
} 