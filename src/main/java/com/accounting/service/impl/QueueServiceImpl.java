package com.accounting.service.impl;

import com.accounting.model.Queue;
import com.accounting.model.User;
import com.accounting.model.enums.QueueStatus;
import com.accounting.model.enums.Priority;
import com.accounting.repository.QueueRepository;
import com.accounting.service.NotificationService;
import com.accounting.service.QueueService;
import jakarta.persistence.EntityNotFoundException;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.HashMap;
import java.util.stream.Collectors;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Stream;
import java.util.Currency;
import java.util.Properties;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import org.springframework.beans.factory.annotation.Autowired;

@Service
@Transactional
@Slf4j
public class QueueServiceImpl implements QueueService {

    private static final Logger logger = LoggerFactory.getLogger(QueueServiceImpl.class);
    private final QueueRepository queueRepository;
    private final NotificationService notificationService;
    private final Random random = new Random();

    public QueueServiceImpl(QueueRepository queueRepository, NotificationService notificationService) {
        this.queueRepository = queueRepository;
        this.notificationService = notificationService;
    }

    @Override
    @Transactional
    public Queue createQueue(String username) {
        Queue queue = new Queue();
        queue.setUserUsername(username);
        queue.setQueueNumber(getNextQueueNumber());
        queue.setCreatedAt(LocalDateTime.now());
        queue.setStatus(QueueStatus.WAITING);
        queue.setPosition(getNextPosition());
        return queueRepository.save(queue);
    }

    @Override
    @Transactional
    public Queue createQueue(Queue queue) {
        queue.setCreatedAt(LocalDateTime.now());
        queue.setStatus(QueueStatus.WAITING);
        queue.setPosition(getNextPosition());
        return queueRepository.save(queue);
    }

    @Override
    @Transactional
    public Queue updateQueueStatus(Long id, String status) {
        Queue queue = getQueueById(id);
        queue.setStatus(QueueStatus.valueOf(status));
        if (queue.getStatus() == QueueStatus.COMPLETED) {
            queue.setProcessedAt(LocalDateTime.now());
        }
        return queueRepository.save(queue);
    }

    @Override
    @Transactional(readOnly = true)
    public Queue getQueueById(Long id) {
        return queueRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Queue not found with id: " + id));
    }

    @Override
    @Transactional(readOnly = true)
    public List<Queue> getQueuesByUser(String username) {
        return queueRepository.findByUserUsernameOrderByCreatedAtDesc(username);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Queue> getQueuesByStatus(String status) {
        return queueRepository.findByStatusOrderByCreatedAtDesc(QueueStatus.valueOf(status));
    }

    @Override
    @Transactional(readOnly = true)
    public Queue getNextQueue() {
        return queueRepository.findFirstByStatusOrderByPositionAsc(QueueStatus.WAITING)
                .orElse(null);
    }

    @Override
    @Transactional(readOnly = true)
    public double getAverageWaitTime() {
        Double avgWait = queueRepository.avgWaitTime();
        return avgWait != null ? avgWait : 0.0;
    }

    @Override
    @Transactional(readOnly = true)
    public double getAverageWaitTimeByStatus(String status) {
        Double avgWait = queueRepository.avgWaitTimeByStatus(QueueStatus.valueOf(status));
        return avgWait != null ? avgWait : 0.0;
    }

    @Override
    @Transactional(readOnly = true)
    public long getQueueCountByStatus(String status) {
        return queueRepository.countByStatus(QueueStatus.valueOf(status));
    }

    private int getNextPosition() {
        return queueRepository.findMaxPosition().orElse(0) + 1;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Queue> getActiveQueues() {
        return queueRepository.findByStatus(QueueStatus.WAITING);
    }

    @Override
    @Transactional(readOnly = true)
    public long getQueueCount() {
        return queueRepository.count();
    }

    @Override
    @Transactional(readOnly = true)
    public double getAverageWaitTimeByType(String type) {
        List<Object[]> results = queueRepository.avgWaitTimeByType();
        return results.isEmpty() ? 0.0 : ((Number) results.get(0)[0]).doubleValue();
    }

    @Override
    @Transactional(readOnly = true)
    public double getAverageWaitTimeByPriority(String priority) {
        List<Object[]> results = queueRepository.avgWaitTimeByPriority();
        return results.isEmpty() ? 0.0 : ((Number) results.get(0)[0]).doubleValue();
    }

    @Override
    @Transactional(readOnly = true)
    public Queue getQueueByUsername(String username) {
        return queueRepository.findByUserUsername(username)
                .orElseThrow(() -> new EntityNotFoundException("Queue not found for username: " + username));
    }

    @Override
    @Transactional(readOnly = true)
    public String getNextQueueNumber() {
        return String.format("Q%06d", queueRepository.count() + 1);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Queue> getQueuesByType(String type) {
        logger.debug("Getting queues by type: {}", type);
        if (!StringUtils.hasText(type)) {
            throw new IllegalArgumentException("Type cannot be empty");
        }
        return queueRepository.findByTypeOrderByCreatedAtDesc(type);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Queue> getQueuesByPriority(String priority) {
        logger.debug("Getting queues by priority: {}", priority);
        if (!StringUtils.hasText(priority)) {
            throw new IllegalArgumentException("Priority cannot be empty");
        }
        return queueRepository.findByPriorityOrderByCreatedAtDesc(priority);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Queue> getQueuesByDescription(String description) {
        logger.debug("Getting queues by description containing: {}", description);
        if (!StringUtils.hasText(description)) {
            throw new IllegalArgumentException("Description cannot be empty");
        }
        return queueRepository.findByDescriptionContainingIgnoreCaseOrderByCreatedAtDesc(description);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Queue> getQueuesByEstimatedWaitTime(Integer minWaitTime, Integer maxWaitTime) {
        logger.debug("Getting queues with estimated wait time between {} and {}", minWaitTime, maxWaitTime);
        if (minWaitTime == null || maxWaitTime == null) {
            throw new IllegalArgumentException("Wait time range cannot be null");
        }
        if (minWaitTime > maxWaitTime) {
            throw new IllegalArgumentException("Minimum wait time must be less than maximum wait time");
        }
        return queueRepository.findByEstimatedWaitTimeBetweenOrderByCreatedAtDesc(minWaitTime, maxWaitTime);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Queue> getQueuesByProcessedAt(LocalDateTime startDate, LocalDateTime endDate) {
        logger.debug("Getting queues processed between {} and {}", startDate, endDate);
        if (startDate == null || endDate == null) {
            throw new IllegalArgumentException("Date range cannot be null");
        }
        if (startDate.isAfter(endDate)) {
            throw new IllegalArgumentException("Start date must be before end date");
        }
        return queueRepository.findByProcessedAtBetweenOrderByCreatedAtDesc(startDate, endDate);
    }

    @Override
    @Transactional(readOnly = true)
    public long getQueueCountByType(String type) {
        logger.debug("Getting queue count by type: {}", type);
        if (!StringUtils.hasText(type)) {
            throw new IllegalArgumentException("Type cannot be empty");
        }
        return queueRepository.countByType(type);
    }

    @Override
    @Transactional(readOnly = true)
    public long getQueueCountByPriority(String priority) {
        logger.debug("Getting queue count by priority: {}", priority);
        if (!StringUtils.hasText(priority)) {
            throw new IllegalArgumentException("Priority cannot be empty");
        }
        List<Object[]> counts = queueRepository.countByPriority();
        return counts.stream()
                .filter(arr -> Priority.valueOf(priority).equals(arr[0]))
                .mapToLong(arr -> ((Number) arr[1]).longValue())
                .findFirst()
                .orElse(0L);
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Long> getQueueCountByPriorityMap() {
        logger.debug("Getting queue count by priority");
        List<Object[]> counts = queueRepository.countByPriority();
        Map<String, Long> result = new HashMap<>();
        for (Priority priority : Priority.values()) {
            result.put(priority.toString(), counts.stream()
                    .filter(arr -> priority.equals(arr[0]))
                    .mapToLong(arr -> ((Number) arr[1]).longValue())
                    .findFirst()
                    .orElse(0L));
        }
        return result;
    }

    @Override
    public int getQueuePosition(String queueNumber) {
        List<Queue> waitingList = queueRepository.findByStatusOrderByCreatedAtAsc(QueueStatus.WAITING);
        for (int i = 0; i < waitingList.size(); i++) {
            if (waitingList.get(i).getQueueNumber().equals(queueNumber)) {
                return i + 1; // Return 1-based position
            }
        }
        return -1; // Queue number not found
    }

    @Override
    public int calculateEstimatedWaitTime(String queueNumber) {
        int position = getQueuePosition(queueNumber);
        if (position == -1) {
            return -1;
        }
        
        // Average processing time per queue (in minutes)
        final int AVERAGE_PROCESSING_TIME = 5;
        return position * AVERAGE_PROCESSING_TIME;
    }

    @Override
    public void cancelQueue(String queueNumber) {
        Queue queue = queueRepository.findByQueueNumber(queueNumber)
            .orElseThrow(() -> new EntityNotFoundException("Queue not found: " + queueNumber));
            
        if (queue.getStatus() != QueueStatus.WAITING) {
            throw new IllegalStateException("Cannot cancel a queue that is not in waiting status");
        }
        
        queue.setStatus(QueueStatus.CANCELLED);
        queueRepository.save(queue);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Queue> getRecentQueues(int limit) {
        try {
            if (limit <= 0) {
                throw new IllegalArgumentException("Limit must be greater than 0");
            }
            return queueRepository.findAll(
                PageRequest.of(0, limit, Sort.by(Sort.Direction.DESC, "createdAt"))
            ).getContent();
        } catch (Exception e) {
            logger.error("Error getting recent queues", e);
            throw new RuntimeException("Failed to get recent queues", e);
        }
    }

    @Override
    @Transactional(readOnly = true)
    public Queue getNextInQueue() {
        try {
            return queueRepository.findFirstByStatusOrderByPositionAsc(QueueStatus.WAITING)
                    .orElse(null);
        } catch (Exception e) {
            logger.error("Error getting next in queue", e);
            throw new RuntimeException("Failed to get next in queue", e);
        }
    }

    @Override
    @Transactional
    public void processNextInQueue() {
        try {
            Queue queue = getNextInQueue();
            if (queue != null) {
                queue.setStatus(QueueStatus.PROCESSING);
                queue.setProcessedAt(LocalDateTime.now());
                queueRepository.save(queue);
                notifyQueueStatus(queue.getId(), QueueStatus.PROCESSING.name());
            }
        } catch (Exception e) {
            logger.error("Error processing next in queue", e);
            throw new RuntimeException("Failed to process next in queue", e);
        }
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getQueueStatistics() {
        try {
            Map<String, Object> stats = new HashMap<>();
            stats.put("totalQueues", queueRepository.count());
            stats.put("pendingQueues", queueRepository.countByStatus(QueueStatus.WAITING));
            stats.put("processingQueues", queueRepository.countByStatus(QueueStatus.PROCESSING));
            stats.put("completedQueues", queueRepository.countByStatus(QueueStatus.COMPLETED));
            return stats;
        } catch (Exception e) {
            logger.error("Error getting queue statistics", e);
            throw new RuntimeException("Failed to get queue statistics", e);
        }
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getCurrentQueueDetails() {
        try {
            Queue currentQueue = getNextInQueue();
            Map<String, Object> details = new HashMap<>();
            if (currentQueue != null) {
                details.put("queueNumber", currentQueue.getQueueNumber());
                details.put("position", currentQueue.getPosition());
                details.put("estimatedWaitTime", getEstimatedWaitTime(currentQueue.getQueueNumber()));
            }
            return details;
        } catch (Exception e) {
            logger.error("Error getting current queue details", e);
            throw new RuntimeException("Failed to get current queue details", e);
        }
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getQueueInfoByUsername(String username) {
        try {
            if (!StringUtils.hasText(username)) {
                throw new IllegalArgumentException("Username cannot be empty");
            }
            
            Queue queue = getQueueByUsername(username);
            Map<String, Object> info = new HashMap<>();
            info.put("queueNumber", queue.getQueueNumber());
            info.put("position", queue.getPosition());
            info.put("status", queue.getStatus());
            info.put("estimatedWaitTime", getEstimatedWaitTime(queue.getQueueNumber()));
            return info;
        } catch (Exception e) {
            logger.error("Error getting queue info by username", e);
            throw new RuntimeException("Failed to get queue info by username", e);
        }
    }

    @Override
    @Transactional(readOnly = true)
    public String generateQueueNumber() {
        try {
            return String.format("Q%04d", random.nextInt(10000));
        } catch (Exception e) {
            logger.error("Error generating queue number", e);
            throw new RuntimeException("Failed to generate queue number", e);
        }
    }

    @Override
    @Transactional
    public Queue createQueueEntry(String username, Long serviceId) {
        try {
            if (!StringUtils.hasText(username)) {
                throw new IllegalArgumentException("Username cannot be empty");
            }
            if (serviceId == null) {
                throw new IllegalArgumentException("Service ID cannot be null");
            }
            
            Queue queue = createQueue(username);
            queue.setServiceId(serviceId);
            return queueRepository.save(queue);
        } catch (Exception e) {
            logger.error("Error creating queue entry", e);
            throw new RuntimeException("Failed to create queue entry", e);
        }
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getQueueInfo(String queueNumber) {
        try {
            if (!StringUtils.hasText(queueNumber)) {
                throw new IllegalArgumentException("Queue number cannot be empty");
            }
            
            Queue queue = queueRepository.findByQueueNumber(queueNumber)
                    .orElseThrow(() -> new RuntimeException("Queue not found: " + queueNumber));
                    
            Map<String, Object> info = new HashMap<>();
            info.put("queueNumber", queue.getQueueNumber());
            info.put("position", queue.getPosition());
            info.put("status", queue.getStatus());
            info.put("estimatedWaitTime", getEstimatedWaitTime(queueNumber));
            
            return info;
        } catch (Exception e) {
            logger.error("Error getting queue info", e);
            throw new RuntimeException("Failed to get queue info", e);
        }
    }

    @Override
    @Transactional(readOnly = true)
    public long getEstimatedWaitTime(String queueNumber) {
        try {
            if (!StringUtils.hasText(queueNumber)) {
                throw new IllegalArgumentException("Queue number cannot be empty");
            }
            
            Queue queue = queueRepository.findByQueueNumber(queueNumber)
                    .orElseThrow(() -> new RuntimeException("Queue not found: " + queueNumber));
                    
            int position = queue.getPosition();
            long averageProcessingTime = getAverageProcessingTime();
            
            return position * averageProcessingTime;
        } catch (Exception e) {
            logger.error("Error getting estimated wait time", e);
            throw new RuntimeException("Failed to get estimated wait time", e);
        }
    }

    @Override
    @Transactional(readOnly = true)
    public Queue getCurrentQueue() {
        try {
            // Use a JOIN FETCH to eagerly load the User entity
            return queueRepository.findFirstByStatusOrderByPositionAsc(QueueStatus.WAITING)
                    .orElse(null);
        } catch (Exception e) {
            logger.error("Error getting current queue", e);
            throw new RuntimeException("Failed to get current queue", e);
        }
    }

    @Override
    @Transactional(readOnly = true)
    public long getAverageProcessingTime() {
        try {
            List<Queue> completedQueues = queueRepository.findByStatus(QueueStatus.COMPLETED);
            if (completedQueues.isEmpty()) {
                return 300; // Default 5 minutes
            }
            
            return completedQueues.stream()
                    .mapToLong(q -> q.getUpdatedAt().toEpochSecond(java.time.ZoneOffset.UTC) - 
                                   q.getCreatedAt().toEpochSecond(java.time.ZoneOffset.UTC))
                    .sum() / completedQueues.size();
        } catch (Exception e) {
            logger.error("Error getting average processing time", e);
            throw new RuntimeException("Failed to get average processing time", e);
        }
    }

    @Override
    @Transactional
    public void completeQueue(Long queueId) {
        try {
            if (queueId == null) {
                throw new IllegalArgumentException("Queue ID cannot be null");
            }
            
            Queue queue = getQueueById(queueId);
            queue.setStatus(QueueStatus.COMPLETED);
            queueRepository.save(queue);
            notifyQueueCompletion(queueId);
        } catch (Exception e) {
            logger.error("Error completing queue", e);
            throw new RuntimeException("Failed to complete queue", e);
        }
    }

    @Override
    @Transactional
    public void skipQueue(Long queueId) {
        try {
            if (queueId == null) {
                throw new IllegalArgumentException("Queue ID cannot be null");
            }
            
            Queue queue = getQueueById(queueId);
            queue.setPosition(queue.getPosition() + 1);
            queueRepository.save(queue);
            notifyQueueSkip(queueId);
        } catch (Exception e) {
            logger.error("Error skipping queue", e);
            throw new RuntimeException("Failed to skip queue", e);
        }
    }

    @Override
    @Transactional
    public void transferQueue(Long queueId, String newUsername) {
        try {
            if (queueId == null) {
                throw new IllegalArgumentException("Queue ID cannot be null");
            }
            if (!StringUtils.hasText(newUsername)) {
                throw new IllegalArgumentException("New username cannot be empty");
            }
            
            Queue queue = getQueueById(queueId);
            queue.setUserUsername(newUsername);
            queue.setUpdatedAt(LocalDateTime.now());
            queueRepository.save(queue);
            notifyQueueTransfer(queueId, newUsername);
        } catch (Exception e) {
            logger.error("Error transferring queue", e);
            throw new RuntimeException("Failed to transfer queue", e);
        }
    }

    // Notification methods
    @Override
    public void notifyQueueStatus(Long queueId, String status) {
        try {
            notificationService.createNotification("Queue " + queueId + " status changed to " + status);
        } catch (Exception e) {
            logger.error("Error notifying queue status", e);
        }
    }

    @Override
    public void notifyQueuePosition(Long queueId, int position) {
        try {
            notificationService.createNotification("Queue " + queueId + " position is " + position);
        } catch (Exception e) {
            logger.error("Error notifying queue position", e);
        }
    }

    @Override
    public void notifyQueueCompletion(Long queueId) {
        try {
            notificationService.createNotification("Queue " + queueId + " completed");
        } catch (Exception e) {
            logger.error("Error notifying queue completion", e);
        }
    }

    @Override
    public void notifyQueueCancellation(Long queueId) {
        try {
            notificationService.createNotification("Queue " + queueId + " cancelled");
        } catch (Exception e) {
            logger.error("Error notifying queue cancellation", e);
        }
    }

    @Override
    public void notifyQueueTransfer(Long queueId, String newUsername) {
        try {
            notificationService.createNotification("Queue " + queueId + " transferred to " + newUsername);
        } catch (Exception e) {
            logger.error("Error notifying queue transfer", e);
        }
    }

    @Override
    public void notifyQueueSkip(Long queueId) {
        try {
            notificationService.createNotification("Queue " + queueId + " skipped");
        } catch (Exception e) {
            logger.error("Error notifying queue skip", e);
        }
    }

    @Override
    public void notifyQueueError(Long queueId, String error) {
        try {
            notificationService.createNotification("Error in queue " + queueId + ": " + error);
        } catch (Exception e) {
            logger.error("Error notifying queue error", e);
        }
    }

    @Override
    public void notifyQueueWarning(Long queueId, String warning) {
        try {
            notificationService.createNotification("Warning in queue " + queueId + ": " + warning);
        } catch (Exception e) {
            logger.error("Error notifying queue warning", e);
        }
    }

    @Override
    public void notifyQueueInfo(Long queueId, String info) {
        try {
            notificationService.createNotification("Info for queue " + queueId + ": " + info);
        } catch (Exception e) {
            logger.error("Error notifying queue info", e);
        }
    }

    @Override
    public void notifyQueueSuccess(Long queueId, String message) {
        try {
            notificationService.createNotification("Success in queue " + queueId + ": " + message);
        } catch (Exception e) {
            logger.error("Error notifying queue success", e);
        }
    }

    @Override
    public void notifyQueueFailure(Long queueId, String message) {
        try {
            notificationService.createNotification("Failure in queue " + queueId + ": " + message);
        } catch (Exception e) {
            logger.error("Error notifying queue failure", e);
        }
    }

    @Override
    public void notifyQueueTimeout(Long queueId) {
        try {
            notificationService.createNotification("Queue " + queueId + " timed out");
        } catch (Exception e) {
            logger.error("Error notifying queue timeout", e);
        }
    }

    @Override
    public void notifyQueueRetry(Long queueId) {
        try {
            notificationService.createNotification("Queue " + queueId + " retrying");
        } catch (Exception e) {
            logger.error("Error notifying queue retry", e);
        }
    }

    @Override
    public void notifyQueueResume(Long queueId) {
        try {
            notificationService.createNotification("Queue " + queueId + " resumed");
        } catch (Exception e) {
            logger.error("Error notifying queue resume", e);
        }
    }

    @Override
    public void notifyQueuePause(Long queueId) {
        try {
            notificationService.createNotification("Queue " + queueId + " paused");
        } catch (Exception e) {
            logger.error("Error notifying queue pause", e);
        }
    }

    @Override
    public void notifyQueueStop(Long queueId) {
        try {
            notificationService.createNotification("Queue " + queueId + " stopped");
        } catch (Exception e) {
            logger.error("Error notifying queue stop", e);
        }
    }

    @Override
    public void notifyQueueStart(Long queueId) {
        try {
            notificationService.createNotification("Queue " + queueId + " started");
        } catch (Exception e) {
            logger.error("Error notifying queue start", e);
        }
    }

    @Override
    public void notifyQueueEnd(Long queueId) {
        try {
            notificationService.createNotification("Queue " + queueId + " ended");
        } catch (Exception e) {
            logger.error("Error notifying queue end", e);
        }
    }

    @Override
    public void notifyQueueUpdate(Long queueId) {
        try {
            notificationService.createNotification("Queue " + queueId + " updated");
        } catch (Exception e) {
            logger.error("Error notifying queue update", e);
        }
    }

    @Override
    public void notifyQueueDelete(Long queueId) {
        try {
            notificationService.createNotification("Queue " + queueId + " deleted");
        } catch (Exception e) {
            logger.error("Error notifying queue delete", e);
        }
    }

    @Override
    public void notifyQueueTransferComplete(Long queueId, String newUsername) {
        try {
            notificationService.createNotification("Queue " + queueId + " transfer to " + newUsername + " completed");
        } catch (Exception e) {
            logger.error("Error notifying queue transfer complete", e);
        }
    }

    @Override
    public void notifyQueueTransferFailed(Long queueId, String newUsername) {
        try {
            notificationService.createNotification("Queue " + queueId + " transfer to " + newUsername + " failed");
        } catch (Exception e) {
            logger.error("Error notifying queue transfer failed", e);
        }
    }

    @Override
    public void notifyQueueTransferPending(Long queueId, String newUsername) {
        try {
            notificationService.createNotification("Queue " + queueId + " transfer to " + newUsername + " pending");
        } catch (Exception e) {
            logger.error("Error notifying queue transfer pending", e);
        }
    }

    @Override
    public void notifyQueueTransferCancelled(Long queueId, String newUsername) {
        try {
            notificationService.createNotification("Queue " + queueId + " transfer to " + newUsername + " cancelled");
        } catch (Exception e) {
            logger.error("Error notifying queue transfer cancelled", e);
        }
    }

    @Override
    public void notifyQueueTransferAccepted(Long queueId, String newUsername) {
        try {
            notificationService.createNotification("Queue " + queueId + " transfer to " + newUsername + " accepted");
        } catch (Exception e) {
            logger.error("Error notifying queue transfer accepted", e);
        }
    }

    @Override
    public void notifyQueueTransferRejected(Long queueId, String newUsername) {
        try {
            notificationService.createNotification("Queue " + queueId + " transfer to " + newUsername + " rejected");
        } catch (Exception e) {
            logger.error("Error notifying queue transfer rejected", e);
        }
    }

    @Override
    public void notifyQueueTransferExpired(Long queueId, String newUsername) {
        try {
            notificationService.createNotification("Queue " + queueId + " transfer to " + newUsername + " expired");
        } catch (Exception e) {
            logger.error("Error notifying queue transfer expired", e);
        }
    }

    @Override
    public void notifyQueueTransferTimeout(Long queueId, String newUsername) {
        try {
            notificationService.createNotification("Queue " + queueId + " transfer to " + newUsername + " timed out");
        } catch (Exception e) {
            logger.error("Error notifying queue transfer timeout", e);
        }
    }

    @Override
    public void notifyQueueTransferError(Long queueId, String newUsername) {
        try {
            notificationService.createNotification("Queue " + queueId + " transfer to " + newUsername + " error");
        } catch (Exception e) {
            logger.error("Error notifying queue transfer error", e);
        }
    }

    @Override
    public void notifyQueueTransferWarning(Long queueId, String newUsername) {
        try {
            notificationService.createNotification("Queue " + queueId + " transfer to " + newUsername + " warning");
        } catch (Exception e) {
            logger.error("Error notifying queue transfer warning", e);
        }
    }

    @Override
    public void notifyQueueTransferInfo(Long queueId, String newUsername) {
        try {
            notificationService.createNotification("Queue " + queueId + " transfer to " + newUsername + " info");
        } catch (Exception e) {
            logger.error("Error notifying queue transfer info", e);
        }
    }

    @Override
    public void notifyQueueTransferSuccess(Long queueId, String newUsername) {
        try {
            notificationService.createNotification("Queue " + queueId + " transfer to " + newUsername + " success");
        } catch (Exception e) {
            logger.error("Error notifying queue transfer success", e);
        }
    }

    @Override
    public void notifyQueueTransferFailure(Long queueId, String newUsername) {
        try {
            notificationService.createNotification("Queue " + queueId + " transfer to " + newUsername + " failure");
        } catch (Exception e) {
            logger.error("Error notifying queue transfer failure", e);
        }
    }

    @Override
    public void notifyQueueTransferRetry(Long queueId, String newUsername) {
        try {
            notificationService.createNotification("Queue " + queueId + " transfer to " + newUsername + " retry");
        } catch (Exception e) {
            logger.error("Error notifying queue transfer retry", e);
        }
    }

    @Override
    public void notifyQueueTransferResume(Long queueId, String newUsername) {
        try {
            notificationService.createNotification("Queue " + queueId + " transfer to " + newUsername + " resume");
        } catch (Exception e) {
            logger.error("Error notifying queue transfer resume", e);
        }
    }

    @Override
    public void notifyQueueTransferPause(Long queueId, String newUsername) {
        try {
            notificationService.createNotification("Queue " + queueId + " transfer to " + newUsername + " pause");
        } catch (Exception e) {
            logger.error("Error notifying queue transfer pause", e);
        }
    }

    @Override
    public void notifyQueueTransferStop(Long queueId, String newUsername) {
        try {
            notificationService.createNotification("Queue " + queueId + " transfer to " + newUsername + " stop");
        } catch (Exception e) {
            logger.error("Error notifying queue transfer stop", e);
        }
    }

    @Override
    public void notifyQueueTransferStart(Long queueId, String newUsername) {
        try {
            notificationService.createNotification("Queue " + queueId + " transfer to " + newUsername + " start");
        } catch (Exception e) {
            logger.error("Error notifying queue transfer start", e);
        }
    }

    @Override
    public void notifyQueueTransferEnd(Long queueId, String newUsername) {
        try {
            notificationService.createNotification("Queue " + queueId + " transfer to " + newUsername + " end");
        } catch (Exception e) {
            logger.error("Error notifying queue transfer end", e);
        }
    }

    @Override
    public void notifyQueueTransferUpdate(Long queueId, String newUsername) {
        try {
            notificationService.createNotification("Queue " + queueId + " transfer to " + newUsername + " update");
        } catch (Exception e) {
            logger.error("Error notifying queue transfer update", e);
        }
    }

    @Override
    public void notifyQueueTransferDelete(Long queueId, String newUsername) {
        try {
            notificationService.createNotification("Queue " + queueId + " transfer to " + newUsername + " delete");
        } catch (Exception e) {
            logger.error("Error notifying queue transfer delete", e);
        }
    }

    @Override
    public void notifyQueueTransferCreate(Long queueId, String newUsername) {
        try {
            notificationService.createNotification("Queue " + queueId + " transfer to " + newUsername + " create");
        } catch (Exception e) {
            logger.error("Error notifying queue transfer create", e);
        }
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Queue> findByQueueNumber(String queueNumber) {
        return queueRepository.findByQueueNumber(queueNumber);
    }

    @Override
    @Transactional
    public void deleteQueue(String username) {
        Queue queue = queueRepository.findByUserUsername(username)
                .orElseThrow(() -> new EntityNotFoundException("Queue not found for username: " + username));
        queueRepository.delete(queue);
    }
} 