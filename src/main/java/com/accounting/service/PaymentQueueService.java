package com.accounting.service;

import com.accounting.model.PaymentQueue;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

@Service
public class PaymentQueueService {
    
    private final Map<String, PaymentQueue> queueMap = new ConcurrentHashMap<>();
    private final AtomicInteger currentNumber = new AtomicInteger(0);
    private final AtomicInteger nextNumber = new AtomicInteger(1);

    public PaymentQueue generatePriorityNumber(PaymentQueue request) {
        int number = nextNumber.getAndIncrement();
        request.setQueueNumber(String.format("P%03d", number));
        request.setStatus("WAITING");
        queueMap.put(request.getQueueNumber(), request);
        return request;
    }

    public Map<String, Object> getCurrentStatus() {
        return Map.of(
            "currentNumber", currentNumber.get(),
            "nextNumber", nextNumber.get(),
            "totalInQueue", queueMap.size()
        );
    }

    public String getNextNumber() {
        return String.format("P%03d", nextNumber.get());
    }

    public List<PaymentQueue> getQueueStatus() {
        return queueMap.values().stream()
            .sorted((a, b) -> a.getQueueNumber().compareTo(b.getQueueNumber()))
            .toList();
    }

    public PaymentQueue updateQueueStatus(String number) {
        PaymentQueue queue = queueMap.get(number);
        if (queue != null) {
            queue.setStatus("PROCESSING");
            currentNumber.set(Integer.parseInt(number.substring(1)));
            return queue;
        }
        return null;
    }

    public int getEstimatedWaitTime() {
        // Calculate based on average processing time and queue length
        return queueMap.size() * 5; // Assuming 5 minutes per person
    }

    public PaymentQueue selectPaymentType(PaymentQueue request) {
        PaymentQueue queue = queueMap.get(request.getQueueNumber());
        if (queue != null) {
            queue.setPaymentType(request.getPaymentType());
            queue.setAmount(request.getAmount());
            return queue;
        }
        return null;
    }
} 