package com.accounting.controller;

import com.accounting.model.Queue;
import com.accounting.service.QueueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/queues")
public class QueueController {

    @Autowired
    private QueueService queueService;

    @PostMapping
    public ResponseEntity<Queue> createQueue(@RequestParam String username) {
        return ResponseEntity.ok(queueService.createQueue(username));
    }

    @GetMapping("/user/{username}")
    public ResponseEntity<Queue> getQueueByUsername(@PathVariable String username) {
        Queue queue = queueService.getQueueByUsername(username);
        return queue != null ? ResponseEntity.ok(queue) : ResponseEntity.notFound().build();
    }

    @GetMapping("/status/{status}")
    public ResponseEntity<List<Queue>> getQueuesByStatus(@PathVariable String status) {
        return ResponseEntity.ok(queueService.getQueuesByStatus(status));
    }

    @PutMapping("/{queueId}/status")
    public ResponseEntity<Queue> updateQueueStatus(@PathVariable Long queueId, @RequestParam String status) {
        Queue queue = queueService.updateQueueStatus(queueId, status);
        return queue != null ? ResponseEntity.ok(queue) : ResponseEntity.notFound().build();
    }

    @DeleteMapping("/user/{username}")
    public ResponseEntity<Void> deleteQueue(@PathVariable String username) {
        queueService.deleteQueue(username);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/next")
    public ResponseEntity<Queue> getNextInQueue() {
        Queue queue = queueService.getNextInQueue();
        return queue != null ? ResponseEntity.ok(queue) : ResponseEntity.notFound().build();
    }

    @PostMapping("/process-next")
    public ResponseEntity<Void> processNextInQueue() {
        queueService.processNextInQueue();
        return ResponseEntity.ok().build();
    }

    @GetMapping("/position/{username}")
    public ResponseEntity<Integer> getQueuePosition(@PathVariable String username) {
        return ResponseEntity.ok(queueService.getQueuePosition(username));
    }

    @GetMapping("/stats")
    public ResponseEntity<Map<String, Object>> getQueueStatistics() {
        return ResponseEntity.ok(queueService.getQueueStatistics());
    }

    @GetMapping("/current")
    public ResponseEntity<Map<String, Object>> getCurrentQueueDetails() {
        return ResponseEntity.ok(queueService.getCurrentQueueDetails());
    }

    @GetMapping("/info/{username}")
    public ResponseEntity<Map<String, Object>> getQueueInfoByUsername(@PathVariable String username) {
        return ResponseEntity.ok(queueService.getQueueInfoByUsername(username));
    }

    @GetMapping("/wait-time/{queueNumber}")
    public ResponseEntity<Long> getEstimatedWaitTime(@PathVariable String queueNumber) {
        return ResponseEntity.ok(queueService.getEstimatedWaitTime(queueNumber));
    }
} 