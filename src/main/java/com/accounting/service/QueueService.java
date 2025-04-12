package com.accounting.service;

import com.accounting.model.Queue;
import java.util.List;
import java.util.Map;
import java.time.LocalDateTime;
import java.util.Optional;

public interface QueueService {
    Queue createQueue(String username);
    Queue createQueue(Queue queue);
    Queue getQueueByUsername(String username);
    List<Queue> getQueuesByStatus(String status);
    Queue updateQueueStatus(Long queueId, String status);
    void deleteQueue(String username);
    Queue getQueueById(Long id);
    List<Queue> getQueuesByUser(String username);
    
    Queue getNextQueue();
    double getAverageWaitTime();
    double getAverageWaitTimeByStatus(String status);
    long getQueueCountByStatus(String status);
    List<Queue> getActiveQueues();
    long getQueueCount();
    double getAverageWaitTimeByType(String type);
    double getAverageWaitTimeByPriority(String priority);
    
    Queue getNextInQueue();
    void processNextInQueue();
    Map<String, Object> getQueueStatistics();
    
    // Queue info methods
    Map<String, Object> getCurrentQueueDetails();
    Map<String, Object> getQueueInfoByUsername(String username);
    String generateQueueNumber();
    String getNextQueueNumber();
    Queue createQueueEntry(String username, Long serviceId);
    Map<String, Object> getQueueInfo(String queueNumber);
    long getEstimatedWaitTime(String queueNumber);
    List<Queue> getQueuesByType(String type);
    List<Queue> getQueuesByPriority(String priority);
    List<Queue> getQueuesByDescription(String description);
    List<Queue> getQueuesByEstimatedWaitTime(Integer minWaitTime, Integer maxWaitTime);
    List<Queue> getQueuesByProcessedAt(LocalDateTime startDate, LocalDateTime endDate);
    long getQueueCountByType(String type);
    long getQueueCountByPriority(String priority);
    Map<String, Long> getQueueCountByPriorityMap();
    
    Queue getCurrentQueue();
    long getAverageProcessingTime();
    List<Queue> getRecentQueues(int limit);
    void cancelQueue(String queueNumber);
    void completeQueue(Long queueId);
    void skipQueue(Long queueId);
    void transferQueue(Long queueId, String newUsername);

    // Queue position and status methods
    int getQueuePosition(String queueNumber);
    int calculateEstimatedWaitTime(String queueNumber);
    Optional<Queue> findByQueueNumber(String queueNumber);

    // Notification methods
    void notifyQueueStatus(Long queueId, String status);
    void notifyQueuePosition(Long queueId, int position);
    void notifyQueueCompletion(Long queueId);
    void notifyQueueCancellation(Long queueId);
    void notifyQueueTransfer(Long queueId, String newUsername);
    void notifyQueueSkip(Long queueId);
    void notifyQueueError(Long queueId, String error);
    void notifyQueueWarning(Long queueId, String warning);
    void notifyQueueInfo(Long queueId, String info);
    void notifyQueueSuccess(Long queueId, String message);
    void notifyQueueFailure(Long queueId, String message);
    void notifyQueueTimeout(Long queueId);
    void notifyQueueRetry(Long queueId);
    void notifyQueueResume(Long queueId);
    void notifyQueuePause(Long queueId);
    void notifyQueueStop(Long queueId);
    void notifyQueueStart(Long queueId);
    void notifyQueueEnd(Long queueId);
    void notifyQueueUpdate(Long queueId);
    void notifyQueueDelete(Long queueId);
    void notifyQueueTransferComplete(Long queueId, String newUsername);
    void notifyQueueTransferFailed(Long queueId, String newUsername);
    void notifyQueueTransferPending(Long queueId, String newUsername);
    void notifyQueueTransferCancelled(Long queueId, String newUsername);
    void notifyQueueTransferAccepted(Long queueId, String newUsername);
    void notifyQueueTransferRejected(Long queueId, String newUsername);
    void notifyQueueTransferExpired(Long queueId, String newUsername);
    void notifyQueueTransferTimeout(Long queueId, String newUsername);
    void notifyQueueTransferError(Long queueId, String newUsername);
    void notifyQueueTransferWarning(Long queueId, String newUsername);
    void notifyQueueTransferInfo(Long queueId, String newUsername);
    void notifyQueueTransferSuccess(Long queueId, String newUsername);
    void notifyQueueTransferFailure(Long queueId, String newUsername);
    void notifyQueueTransferRetry(Long queueId, String newUsername);
    void notifyQueueTransferResume(Long queueId, String newUsername);
    void notifyQueueTransferPause(Long queueId, String newUsername);
    void notifyQueueTransferStop(Long queueId, String newUsername);
    void notifyQueueTransferStart(Long queueId, String newUsername);
    void notifyQueueTransferEnd(Long queueId, String newUsername);
    void notifyQueueTransferUpdate(Long queueId, String newUsername);
    void notifyQueueTransferDelete(Long queueId, String newUsername);
    void notifyQueueTransferCreate(Long queueId, String newUsername);
} 