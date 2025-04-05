package com.accounting.service;

import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.ConcurrentLinkedQueue;

@Service
public class QueueService {
    
    private final Queue<Map<String, Object>> queueEntries = new ConcurrentLinkedQueue<>();
    private int lastNumber = 0;
    
    // Initialize with some mock data
    public QueueService() {
        createMockQueueEntries();
    }
    
    private void createMockQueueEntries() {
        createQueueEntry("A123", 1L); // Tuition Payment
        createQueueEntry("A124", 2L); // Library Fee
        createQueueEntry("A125", 3L); // Lab Fee
        createQueueEntry("A126", 4L); // ID Replacement
    }
    
    public String generateQueueNumber() {
        lastNumber++;
        return String.format("A%03d", lastNumber);
    }
    
    public void createQueueEntry(String queueNumber, Long paymentItemId) {
        Map<String, Object> entry = new HashMap<>();
        entry.put("number", queueNumber);
        entry.put("paymentItemId", paymentItemId);
        entry.put("status", "WAITING");
        entry.put("timestamp", LocalDateTime.now());
        entry.put("estimatedWaitTime", calculateEstimatedWaitTime());
        
        queueEntries.offer(entry);
    }
    
    public Map<String, Object> getQueueInfo(String number) {
        return queueEntries.stream()
                .filter(entry -> entry.get("number").equals(number))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("Queue number not found"));
    }
    
    public int getEstimatedWaitTime(String number) {
        int position = getQueuePosition(number);
        return position * 5; // Assume 5 minutes per transaction
    }
    
    public int getQueuePosition(String number) {
        int position = 1;
        for (Map<String, Object> entry : queueEntries) {
            if (entry.get("number").equals(number)) {
                return position;
            }
            position++;
        }
        return -1;
    }
    
    private int calculateEstimatedWaitTime() {
        return queueEntries.size() * 5; // 5 minutes per transaction
    }
    
    public List<Map<String, Object>> getCurrentQueue() {
        return new ArrayList<>(queueEntries);
    }
    
    public Map<String, Object> getCurrentQueueDetails() {
        Map<String, Object> details = new HashMap<>();
        details.put("currentSize", queueEntries.size());
        details.put("averageWaitTime", calculateAverageWaitTime());
        details.put("nextNumber", queueEntries.peek() != null ? 
                queueEntries.peek().get("number") : null);
        return details;
    }
    
    private int calculateAverageWaitTime() {
        return queueEntries.isEmpty() ? 0 : queueEntries.size() * 5;
    }
    
    public String processNextInQueue() {
        Map<String, Object> next = queueEntries.poll();
        if (next != null) {
            next.put("status", "PROCESSING");
            return next.get("number").toString();
        }
        return null;
    }
} 