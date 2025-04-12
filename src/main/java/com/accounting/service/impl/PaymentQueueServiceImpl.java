package com.accounting.service.impl;

import com.accounting.model.PaymentQueue;
import com.accounting.repository.PaymentQueueRepository;
import com.accounting.service.PaymentQueueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.stream.Collectors;
import java.util.Optional;

@Service
public class PaymentQueueServiceImpl implements PaymentQueueService {
    private final PaymentQueueRepository paymentQueueRepository;

    @Autowired
    public PaymentQueueServiceImpl(PaymentQueueRepository paymentQueueRepository) {
        this.paymentQueueRepository = paymentQueueRepository;
    }

    @Override
    public PaymentQueue addToQueue(PaymentQueue payment) {
        return paymentQueueRepository.save(payment);
    }

    @Override
    public void addToQueue(String username, BigDecimal amount, String description) {
        PaymentQueue payment = new PaymentQueue();
        payment.setUsername(username);
        payment.setAmount(amount);
        payment.setDescription(description);
        payment.setStatus("PENDING");
        payment.setPaymentType("REGULAR");
        paymentQueueRepository.save(payment);
    }

    @Override
    public PaymentQueue getQueueItem(String queueNumber) {
        return paymentQueueRepository.findByQueueNumber(queueNumber).orElse(null);
    }

    @Override
    public List<PaymentQueue> getAllQueues() {
        return paymentQueueRepository.findAll();
    }

    @Override
    public PaymentQueue updateQueueStatus(String queueNumber, String status) {
        Optional<PaymentQueue> queueOpt = paymentQueueRepository.findByQueueNumber(queueNumber);
        if (queueOpt.isPresent()) {
            PaymentQueue queue = queueOpt.get();
            queue.setStatus(status);
            return paymentQueueRepository.save(queue);
        }
        return null;
    }

    @Override
    public void removeFromQueue(String queueNumber) {
        paymentQueueRepository.deleteByQueueNumber(queueNumber);
    }

    @Override
    public List<PaymentQueue> getQueuesByStatus(String status) {
        return paymentQueueRepository.findByStatus(status);
    }

    @Override
    public int getQueueSize() {
        return (int) paymentQueueRepository.count();
    }

    @Override
    public int getActiveQueueCount() {
        return (int) (paymentQueueRepository.countByStatus("PENDING") + paymentQueueRepository.countByStatus("PROCESSING"));
    }

    @Override
    public BigDecimal getTotalQueueAmount() {
        return paymentQueueRepository.findAll().stream()
                .map(PaymentQueue::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    @Override
    public List<String> getPaymentTypes() {
        return paymentQueueRepository.findAll().stream()
                .map(PaymentQueue::getPaymentType)
                .distinct()
                .collect(Collectors.toList());
    }

    @Override
    public void processNextPayment() {
        List<PaymentQueue> pendingPayments = paymentQueueRepository.findByStatusOrderByCreatedAtAsc("PENDING");
        if (!pendingPayments.isEmpty()) {
            PaymentQueue nextPayment = pendingPayments.get(0);
            nextPayment.setStatus("PROCESSING");
            paymentQueueRepository.save(nextPayment);
        }
    }

    @Override
    public List<Map<String, Object>> getQueueStatus() {
        return paymentQueueRepository.findAll().stream()
                .map(queue -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("queueNumber", queue.getQueueNumber());
                    map.put("status", queue.getStatus());
                    map.put("amount", queue.getAmount());
                    map.put("paymentType", queue.getPaymentType());
                    map.put("createdAt", queue.getCreatedAt());
                    return map;
                })
                .collect(Collectors.toList());
    }

    @Override
    public BigDecimal getTotalPendingAmount() {
        return paymentQueueRepository.findByStatus("PENDING").stream()
                .map(PaymentQueue::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    @Override
    public BigDecimal getAveragePaymentAmount() {
        List<PaymentQueue> allPayments = paymentQueueRepository.findAll();
        if (allPayments.isEmpty()) {
            return BigDecimal.ZERO;
        }
        BigDecimal total = allPayments.stream()
                .map(PaymentQueue::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        return total.divide(new BigDecimal(allPayments.size()), 2, BigDecimal.ROUND_HALF_UP);
    }

    @Override
    public BigDecimal getMinPaymentAmount() {
        return paymentQueueRepository.findAll().stream()
                .map(PaymentQueue::getAmount)
                .min(BigDecimal::compareTo)
                .orElse(BigDecimal.ZERO);
    }

    @Override
    public BigDecimal getMaxPaymentAmount() {
        return paymentQueueRepository.findAll().stream()
                .map(PaymentQueue::getAmount)
                .max(BigDecimal::compareTo)
                .orElse(BigDecimal.ZERO);
    }

    @Override
    public BigDecimal getTotalProcessedAmount() {
        return paymentQueueRepository.findByStatus("COMPLETED").stream()
                .map(PaymentQueue::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    @Override
    public BigDecimal calculateTotalAmount(String username) {
        return paymentQueueRepository.findAll().stream()
                .filter(q -> q.getUsername().equals(username))
                .map(PaymentQueue::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    @Override
    public BigDecimal calculatePendingAmount(String username) {
        return paymentQueueRepository.findByStatus("PENDING").stream()
                .filter(q -> q.getUsername().equals(username))
                .map(PaymentQueue::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    @Override
    public BigDecimal calculatePaidAmount(String username) {
        return paymentQueueRepository.findByStatus("COMPLETED").stream()
                .filter(q -> q.getUsername().equals(username))
                .map(PaymentQueue::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    @Override
    public BigDecimal calculateOverdueAmount(String username) {
        return paymentQueueRepository.findByStatus("OVERDUE").stream()
                .filter(q -> q.getUsername().equals(username))
                .map(PaymentQueue::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    @Override
    public BigDecimal calculateRefundAmount(String username) {
        return paymentQueueRepository.findByStatus("REFUNDED").stream()
                .filter(q -> q.getUsername().equals(username))
                .map(PaymentQueue::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    @Override
    public List<Map<String, Object>> getPaymentHistory(String username) {
        return paymentQueueRepository.findAll().stream()
                .filter(q -> q.getUsername().equals(username))
                .map(queue -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("queueNumber", queue.getQueueNumber());
                    map.put("status", queue.getStatus());
                    map.put("amount", queue.getAmount());
                    map.put("paymentType", queue.getPaymentType());
                    map.put("createdAt", queue.getCreatedAt());
                    return map;
                })
                .collect(Collectors.toList());
    }

    @Override
    public Map<String, Object> getPaymentDetails(String username) {
        Optional<PaymentQueue> paymentOpt = paymentQueueRepository.findByUsername(username);
        if (paymentOpt.isPresent()) {
            PaymentQueue payment = paymentOpt.get();
            Map<String, Object> map = new HashMap<>();
            map.put("queueNumber", payment.getQueueNumber());
            map.put("status", payment.getStatus());
            map.put("amount", payment.getAmount());
            map.put("paymentType", payment.getPaymentType());
            map.put("createdAt", payment.getCreatedAt());
            return map;
        }
        return new HashMap<>();
    }

    @Override
    public void processPayment(String username, BigDecimal amount) {
        PaymentQueue payment = new PaymentQueue();
        payment.setUsername(username);
        payment.setAmount(amount);
        payment.setStatus("PROCESSING");
        payment.setPaymentType("REGULAR");
        paymentQueueRepository.save(payment);
    }

    @Override
    public void refundPayment(String username, BigDecimal amount) {
        PaymentQueue payment = new PaymentQueue();
        payment.setUsername(username);
        payment.setAmount(amount);
        payment.setStatus("REFUNDED");
        payment.setPaymentType("REFUND");
        paymentQueueRepository.save(payment);
    }

    @Override
    public void updatePaymentStatus(String username, String status) {
        Optional<PaymentQueue> paymentOpt = paymentQueueRepository.findByUsername(username);
        if (paymentOpt.isPresent()) {
            PaymentQueue payment = paymentOpt.get();
            payment.setStatus(status);
            paymentQueueRepository.save(payment);
        }
    }

    @Override
    public Map<String, Object> getQueueStatistics(String username) {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalAmount", calculateTotalAmount(username));
        stats.put("pendingAmount", calculatePendingAmount(username));
        stats.put("paidAmount", calculatePaidAmount(username));
        stats.put("overdueAmount", calculateOverdueAmount(username));
        stats.put("refundAmount", calculateRefundAmount(username));
        stats.put("paymentHistory", getPaymentHistory(username));
        return stats;
    }
} 