package com.accounting.service;

import com.accounting.model.Payment;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

public interface PaymentService {
    Payment createPayment(Payment payment);
    Payment updatePayment(Payment payment);
    void deletePayment(Long id);
    Payment getPaymentById(Long id);
    List<Payment> getPaymentsByUser(String username);
    Payment processPayment(Payment payment);
    Payment getPaymentByQueueNumber(String queueNumber);
    List<Payment> getPaymentsByStatus(String status);
    Map<String, Object> getPaymentStatistics();
    BigDecimal getTotalAmountByDateRange(String startDate, String endDate);
    void cancelPayment(Long paymentId);
    void refundPayment(Long paymentId);
    Payment updatePaymentStatus(Long paymentId, String status);
    List<Payment> getPaymentsByType(String type);
    List<Payment> getPaymentsByDescription(String description);
    List<Payment> getPaymentsByAmount(Double minAmount, Double maxAmount);
    long getPaymentCount();
    long getPaymentCountByUser(String username);
    long getPaymentCountByStatus(String status);
    long getPaymentCountByType(String type);
    double getPaymentAmount();
    double getPaymentAmountByUser(String username);
    double getPaymentAmountByStatus(String status);
    double getPaymentAmountByType(String type);
} 