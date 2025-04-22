package com.accounting.service.impl;

import com.accounting.model.Payment;
import com.accounting.model.User;
import com.accounting.model.enums.PaymentStatus;
import com.accounting.repository.PaymentRepository;
import com.accounting.repository.UserRepository;
import com.accounting.service.PaymentService;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.math.BigDecimal;
import java.sql.Date;

@Service
public class PaymentServiceImpl implements PaymentService {
    private static final Logger logger = LoggerFactory.getLogger(PaymentServiceImpl.class);
    private final PaymentRepository paymentRepository;
    private final UserRepository userRepository;

    @Autowired
    public PaymentServiceImpl(PaymentRepository paymentRepository, UserRepository userRepository) {
        this.paymentRepository = paymentRepository;
        this.userRepository = userRepository;
    }

    @Override
    @Transactional
    public Payment createPayment(Payment payment) {
        logger.debug("Creating new payment: {}", payment);
        validatePayment(payment);
        if (payment.getUser() == null) {
            throw new IllegalArgumentException("User is required for payment");
        }
        payment.setCreatedAt(LocalDateTime.now());
        return paymentRepository.save(payment);
    }

    @Override
    @Transactional
    public Payment processPayment(Payment payment) {
        logger.debug("Processing payment: {}", payment);
        payment.setPaymentStatus(PaymentStatus.PENDING);
        payment.setProcessedAt(LocalDateTime.now());
        return paymentRepository.save(payment);
    }

    @Override
    @Transactional
    public Payment completePayment(Long paymentId) {
        Payment payment = paymentRepository.findById(paymentId)
            .orElseThrow(() -> new RuntimeException("Payment not found"));
        payment.setPaymentStatus(PaymentStatus.COMPLETED);
        payment.setUpdatedAt(LocalDateTime.now());
        return paymentRepository.save(payment);
    }

    @Override
    @Transactional
    public Payment cancelPayment(Long paymentId) {
        Payment payment = paymentRepository.findById(paymentId)
            .orElseThrow(() -> new RuntimeException("Payment not found"));
        payment.setPaymentStatus(PaymentStatus.FAILED);
        payment.setUpdatedAt(LocalDateTime.now());
        return paymentRepository.save(payment);
    }

    @Override
    public Payment getPayment(Long paymentId) {
        return paymentRepository.findById(paymentId)
            .orElseThrow(() -> new RuntimeException("Payment not found"));
    }

    @Override
    public List<Payment> getAllPayments() {
        return paymentRepository.findAll();
    }

    @Override
    public List<Payment> getPaymentsByStatus(PaymentStatus status) {
        return paymentRepository.findByStatus(status);
    }

    @Override
    public List<Payment> getPaymentsByUser(String username) {
        User user = userRepository.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        return paymentRepository.findByUserOrderByCreatedAtDesc(user);
    }

    @Override
    public List<Payment> getPaymentsByDescription(String description) {
        return paymentRepository.findByDescriptionContaining(description);
    }

    @Override
    public List<Payment> getPaymentsByAmount(Double minAmount, Double maxAmount) {
        if (minAmount == null || maxAmount == null) {
            throw new IllegalArgumentException("Amount range cannot be null");
        }
        if (minAmount > maxAmount) {
            throw new IllegalArgumentException("Minimum amount must be less than maximum amount");
        }
        return paymentRepository.findByAmountBetweenOrderByCreatedAtDesc(minAmount, maxAmount);
    }

    @Override
    public boolean validatePayment(Payment payment) {
        if (payment.getAmount() == null || payment.getAmount().signum() <= 0) {
            return false;
        }
        if (payment.getPaymentMethod() == null || payment.getPaymentMethod().trim().isEmpty()) {
            return false;
        }
        return true;
    }

    @Override
    public Map<String, Object> getPaymentStatistics() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalPayments", paymentRepository.count());
        stats.put("totalAmount", paymentRepository.sumAmount());
        stats.put("pendingPayments", paymentRepository.countByStatus(PaymentStatus.PENDING));
        stats.put("processedPayments", paymentRepository.countByStatus(PaymentStatus.COMPLETED));
        stats.put("failedPayments", paymentRepository.countByStatus(PaymentStatus.FAILED));
        return stats;
    }

    @Override
    @Transactional
    public Payment updatePayment(Payment payment) {
        logger.debug("Updating payment: {}", payment);
        validatePayment(payment);
        if (payment.getId() == null) {
            throw new IllegalArgumentException("Payment ID cannot be null for update");
        }
        if (!paymentRepository.existsById(payment.getId())) {
            throw new RuntimeException("Payment not found with id: " + payment.getId());
        }
        payment.setUpdatedAt(LocalDateTime.now());
        return paymentRepository.save(payment);
    }

    @Override
    public double getPaymentAmountByStatus(String status) {
        return paymentRepository.sumAmountByStatus(PaymentStatus.valueOf(status))
            .orElse(BigDecimal.ZERO)
            .doubleValue();
    }

    @Override
    public long getPaymentCountByUser(String username) {
        User user = userRepository.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        return paymentRepository.countByUser(user);
    }

    @Override
    public double getPaymentAmountByUser(String username) {
        User user = userRepository.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        return paymentRepository.sumAmountByUser(user)
            .orElse(BigDecimal.ZERO)
            .doubleValue();
    }

    @Override
    public Payment getPaymentByQueueNumber(String queueNumber) {
        return paymentRepository.findByQueueNumber(queueNumber)
            .orElseThrow(() -> new RuntimeException("Payment not found"));
    }

    @Override
    public long getPaymentCountByStatus(String status) {
        return paymentRepository.countByStatus(PaymentStatus.valueOf(status));
    }

    @Override
    public List<Payment> getPaymentsByType(String type) {
        return paymentRepository.findByTypeOrderByCreatedAtDesc(type);
    }

    @Override
    @Transactional
    public void deletePayment(Long id) {
        if (!paymentRepository.existsById(id)) {
            throw new RuntimeException("Payment not found with id: " + id);
        }
        paymentRepository.deleteById(id);
    }

    @Override
    public long getPaymentCount() {
        return paymentRepository.count();
    }

    @Override
    public double getPaymentAmount() {
        return paymentRepository.sumAmount()
            .orElse(BigDecimal.ZERO)
            .doubleValue();
    }

    @Override
    public double getPaymentAmountByType(String type) {
        return paymentRepository.sumAmountByType(type)
            .orElse(BigDecimal.ZERO)
            .doubleValue();
    }

    @Override
    public long getPaymentCountByType(String type) {
        return paymentRepository.countByType(type);
    }

    @Override
    public BigDecimal getTotalAmountByDateRange(String startDate, String endDate) {
        return paymentRepository.sumTotalAmountByDateRange(
            Date.valueOf(startDate),
            Date.valueOf(endDate)
        );
    }

    @Override
    @Transactional(readOnly = true)
    public Payment getPaymentById(Long id) {
        return paymentRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Payment not found"));
    }

    @Override
    @Transactional
    public Payment approvePayment(Long id) {
        Payment payment = paymentRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Payment not found"));
        payment.setPaymentStatus(PaymentStatus.COMPLETED);
        payment.setUpdatedAt(LocalDateTime.now());
        return paymentRepository.save(payment);
    }

    @Override
    @Transactional
    public Payment rejectPayment(Long id) {
        Payment payment = paymentRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Payment not found"));
        payment.setPaymentStatus(PaymentStatus.FAILED);
        payment.setUpdatedAt(LocalDateTime.now());
        return paymentRepository.save(payment);
    }

    @Override
    public long getPendingPaymentsCount() {
        return paymentRepository.countByStatus(PaymentStatus.PENDING);
    }
}