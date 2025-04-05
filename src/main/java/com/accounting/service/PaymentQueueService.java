package com.accounting.service;

import com.accounting.model.PaymentQueue;
import org.springframework.stereotype.Service;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class PaymentQueueService {
    private final Map<String, PaymentQueue> queueMap = new ConcurrentHashMap<>();
    private int queueCounter = 1;

    public PaymentQueueService() {
        // Initialize with some mock data
        createMockData();
    }

    private void createMockData() {
        addToQueue(new PaymentQueue("Q001", "PENDING", "CASH", 1000.0));
        addToQueue(new PaymentQueue("Q002", "PROCESSING", "CREDIT_CARD", 2500.0));
        addToQueue(new PaymentQueue("Q003", "COMPLETED", "BANK_TRANSFER", 1500.0));
        addToQueue(new PaymentQueue("Q004", "PENDING", "CASH", 3000.0));
        addToQueue(new PaymentQueue("Q005", "PENDING", "DEBIT_CARD", 750.0));
    }

    public PaymentQueue addToQueue(PaymentQueue payment) {
        if (payment.getQueueNumber() == null) {
            payment.setQueueNumber(generateQueueNumber());
        }
        queueMap.put(payment.getQueueNumber(), payment);
        return payment;
    }

    public PaymentQueue getQueueItem(String queueNumber) {
        return queueMap.get(queueNumber);
    }

    public List<PaymentQueue> getAllQueues() {
        return new ArrayList<>(queueMap.values());
    }

    public PaymentQueue updateQueueStatus(String queueNumber, String status) {
        PaymentQueue queue = queueMap.get(queueNumber);
        if (queue != null) {
            queue.setStatus(status);
            queueMap.put(queueNumber, queue);
        }
        return queue;
    }

    public void removeFromQueue(String queueNumber) {
        queueMap.remove(queueNumber);
    }

    public List<PaymentQueue> getQueuesByStatus(String status) {
        return queueMap.values().stream()
                .filter(q -> q.getStatus().equals(status))
                .toList();
    }

    public int getQueueSize() {
        return queueMap.size();
    }

    private String generateQueueNumber() {
        return String.format("Q%03d", queueCounter++);
    }

    // Mock statistics methods
    public int getActiveQueueCount() {
        return (int) queueMap.values().stream()
                .filter(q -> q.getStatus().equals("PENDING") || q.getStatus().equals("PROCESSING"))
                .count();
    }

    public double getTotalQueueAmount() {
        return queueMap.values().stream()
                .mapToDouble(PaymentQueue::getAmount)
                .sum();
    }

    public List<String> getPaymentTypes() {
        return queueMap.values().stream()
                .map(PaymentQueue::getPaymentType)
                .distinct()
                .toList();
    }
} 