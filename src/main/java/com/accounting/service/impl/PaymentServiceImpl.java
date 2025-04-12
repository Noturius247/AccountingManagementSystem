package com.accounting.service.impl;

import com.accounting.model.Payment;
import com.accounting.model.enums.PaymentStatus;
import com.accounting.repository.PaymentRepository;
import com.accounting.service.PaymentService;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Optional;
import java.util.Date;
import java.util.Calendar;
import java.util.Currency;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Service
@RequiredArgsConstructor
@Transactional
public class PaymentServiceImpl implements PaymentService {
    private static final Logger logger = LoggerFactory.getLogger(PaymentServiceImpl.class);
    private final PaymentRepository paymentRepository;

    @Override
    @Transactional
    public Payment createPayment(Payment payment) {
        logger.debug("Creating new payment: {}", payment);
        validatePayment(payment);
        payment.setCreatedAt(LocalDateTime.now());
        return paymentRepository.save(payment);
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
        return paymentRepository.save(payment);
    }

    @Override
    @Transactional
    public void deletePayment(Long id) {
        logger.debug("Deleting payment with id: {}", id);
        if (id == null) {
            throw new IllegalArgumentException("Payment ID cannot be null");
        }
        if (!paymentRepository.existsById(id)) {
            throw new RuntimeException("Payment not found with id: " + id);
        }
        paymentRepository.deleteById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public Payment getPaymentById(Long id) {
        logger.debug("Getting payment by id: {}", id);
        if (id == null) {
            throw new IllegalArgumentException("Payment ID cannot be null");
        }
        return paymentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Payment not found with id: " + id));
    }

    @Override
    @Transactional(readOnly = true)
    public List<Payment> getPaymentsByUser(String username) {
        logger.debug("Getting payments for user: {}", username);
        if (!StringUtils.hasText(username)) {
            throw new IllegalArgumentException("Username cannot be empty");
        }
        return paymentRepository.findByUserUsernameOrderByCreatedAtDesc(username);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Payment> getPaymentsByStatus(String status) {
        logger.debug("Getting payments by status: {}", status);
        if (!StringUtils.hasText(status)) {
            throw new IllegalArgumentException("Status cannot be empty");
        }
        return paymentRepository.findByStatusOrderByCreatedAtDesc(PaymentStatus.valueOf(status));
    }

    @Override
    @Transactional(readOnly = true)
    public List<Payment> getPaymentsByType(String type) {
        logger.debug("Getting payments by type: {}", type);
        if (!StringUtils.hasText(type)) {
            throw new IllegalArgumentException("Type cannot be empty");
        }
        return paymentRepository.findByTypeOrderByCreatedAtDesc(type);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Payment> getPaymentsByDescription(String description) {
        logger.debug("Getting payments by description containing: {}", description);
        if (!StringUtils.hasText(description)) {
            throw new IllegalArgumentException("Description cannot be empty");
        }
        return paymentRepository.findByDescriptionContainingIgnoreCaseOrderByCreatedAtDesc(description);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Payment> getPaymentsByAmount(Double minAmount, Double maxAmount) {
        logger.debug("Getting payments with amount between {} and {}", minAmount, maxAmount);
        if (minAmount == null || maxAmount == null) {
            throw new IllegalArgumentException("Amount range cannot be null");
        }
        if (minAmount > maxAmount) {
            throw new IllegalArgumentException("Minimum amount must be less than maximum amount");
        }
        return paymentRepository.findByAmountBetweenOrderByCreatedAtDesc(minAmount, maxAmount);
    }

    @Override
    @Transactional(readOnly = true)
    public long getPaymentCount() {
        logger.debug("Getting total payment count");
        return paymentRepository.count();
    }

    @Override
    @Transactional(readOnly = true)
    public long getPaymentCountByUser(String username) {
        logger.debug("Getting payment count for user: {}", username);
        if (!StringUtils.hasText(username)) {
            throw new IllegalArgumentException("Username cannot be empty");
        }
        return paymentRepository.countByUserUsername(username);
    }

    @Override
    @Transactional(readOnly = true)
    public long getPaymentCountByStatus(String status) {
        logger.debug("Getting payment count by status: {}", status);
        if (!StringUtils.hasText(status)) {
            throw new IllegalArgumentException("Status cannot be empty");
        }
        return paymentRepository.countByStatus(PaymentStatus.valueOf(status));
    }

    @Override
    @Transactional(readOnly = true)
    public long getPaymentCountByType(String type) {
        logger.debug("Getting payment count by type: {}", type);
        if (!StringUtils.hasText(type)) {
            throw new IllegalArgumentException("Type cannot be empty");
        }
        return paymentRepository.countByType(type);
    }

    @Override
    @Transactional(readOnly = true)
    public double getPaymentAmount() {
        logger.debug("Getting total payment amount");
        return paymentRepository.sumAmount().orElse(BigDecimal.ZERO).doubleValue();
    }

    @Override
    @Transactional(readOnly = true)
    public double getPaymentAmountByUser(String username) {
        logger.debug("Getting total payment amount for user: {}", username);
        if (!StringUtils.hasText(username)) {
            throw new IllegalArgumentException("Username cannot be empty");
        }
        return paymentRepository.sumAmountByUserUsername(username).doubleValue();
    }

    @Override
    @Transactional(readOnly = true)
    public double getPaymentAmountByStatus(String status) {
        logger.debug("Getting total payment amount by status: {}", status);
        if (!StringUtils.hasText(status)) {
            throw new IllegalArgumentException("Status cannot be empty");
        }
        return paymentRepository.sumAmountByStatus(PaymentStatus.valueOf(status)).orElse(0.0);
    }

    @Override
    @Transactional(readOnly = true)
    public double getPaymentAmountByType(String type) {
        logger.debug("Getting total payment amount by type: {}", type);
        if (!StringUtils.hasText(type)) {
            throw new IllegalArgumentException("Type cannot be empty");
        }
        return paymentRepository.sumAmountByType(type).orElse(0.0);
    }

    @Override
    @Transactional
    public Payment processPayment(Payment payment) {
        logger.debug("Processing payment: {}", payment);
        payment.setProcessedAt(LocalDateTime.now());
        payment.setStatus(PaymentStatus.PROCESSED);
        return paymentRepository.save(payment);
    }

    @Override
    @Transactional(readOnly = true)
    public Payment getPaymentByQueueNumber(String queueNumber) {
        logger.debug("Getting payment by queue number: {}", queueNumber);
        return paymentRepository.findByQueueNumber(queueNumber)
                .orElseThrow(() -> new RuntimeException("Payment not found"));
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getPaymentStatistics() {
        logger.debug("Getting payment statistics");
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalPayments", paymentRepository.count());
        stats.put("totalAmount", paymentRepository.sumAmount());
        stats.put("pendingPayments", paymentRepository.countByStatus(PaymentStatus.PENDING));
        stats.put("completedPayments", paymentRepository.countByStatus(PaymentStatus.PROCESSED));
        stats.put("failedPayments", paymentRepository.countByStatus(PaymentStatus.FAILED));
        return stats;
    }

    @Override
    @Transactional(readOnly = true)
    public BigDecimal getTotalAmountByDateRange(String startDate, String endDate) {
        logger.debug("Getting total amount by date range: {} to {}", startDate, endDate);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        try {
            Date start = sdf.parse(startDate);
            Date end = sdf.parse(endDate);
            return paymentRepository.sumTotalAmountByDateRange(start, end);
        } catch (ParseException e) {
            throw new RuntimeException("Invalid date format", e);
        }
    }

    @Override
    @Transactional
    public void cancelPayment(Long paymentId) {
        logger.debug("Cancelling payment with id: {}", paymentId);
        Payment payment = paymentRepository.findById(paymentId)
                .orElseThrow(() -> new RuntimeException("Payment not found"));
        payment.setStatus(PaymentStatus.FAILED);
        paymentRepository.save(payment);
    }

    @Override
    @Transactional
    public void refundPayment(Long paymentId) {
        logger.debug("Refunding payment with id: {}", paymentId);
        Payment payment = paymentRepository.findById(paymentId)
                .orElseThrow(() -> new RuntimeException("Payment not found"));
        payment.setStatus(PaymentStatus.REFUNDED);
        paymentRepository.save(payment);
    }

    @Override
    @Transactional
    public Payment updatePaymentStatus(Long paymentId, String status) {
        logger.debug("Updating payment status with id: {} to {}", paymentId, status);
        Payment payment = paymentRepository.findById(paymentId)
                .orElseThrow(() -> new RuntimeException("Payment not found"));
        payment.setStatus(PaymentStatus.valueOf(status));
        return paymentRepository.save(payment);
    }

    private void validatePayment(Payment payment) {
        if (payment == null) {
            throw new IllegalArgumentException("Payment cannot be null");
        }
        if (payment.getType() == null) {
            throw new IllegalArgumentException("Payment type cannot be null");
        }
        if (payment.getStatus() == null) {
            throw new IllegalArgumentException("Payment status cannot be null");
        }
        if (payment.getAmount() == null || payment.getAmount().compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Payment amount must be greater than 0");
        }
        if (payment.getUserUsername() == null) {
            throw new IllegalArgumentException("Payment user cannot be null");
        }
    }
} 