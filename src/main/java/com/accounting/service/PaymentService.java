package com.accounting.service;

import com.accounting.model.Payment;
import com.accounting.model.enums.PaymentStatus;
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
    List<Payment> getPaymentsByStatus(PaymentStatus status);
    Map<String, Object> getPaymentStatistics();
    BigDecimal getTotalAmountByDateRange(String startDate, String endDate);
    Payment completePayment(Long paymentId);
    Payment cancelPayment(Long paymentId);
    Payment getPayment(Long paymentId);
    List<Payment> getAllPayments();
    boolean validatePayment(Payment payment);
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
    Payment approvePayment(Long id);
    Payment rejectPayment(Long id);
    long getPendingPaymentsCount();
    Payment getPaymentByTransactionReference(String transactionReference);
} 