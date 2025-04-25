package com.accounting.service;

import com.accounting.model.Queue;
import com.accounting.model.QueuePosition;
import com.accounting.model.enums.ReceiptPreference;
import java.util.List;
import java.util.Map;
import java.time.LocalDateTime;
import java.util.Optional;
import com.accounting.model.User;
import com.accounting.model.Payment;
import com.accounting.model.Student;
import com.accounting.model.enums.QueueStatus;

public interface QueueService {
    void addToQueue(User user);
    void removeFromQueue(User user);
    QueuePosition getQueueStatus(User user);
    boolean isInQueue(User user);
    int getQueueSize();
    QueuePosition createQueue(String username);
    QueuePosition createQueue(QueuePosition queue);
    QueuePosition getQueueByUsername(String username);
    List<QueuePosition> getQueuesByStatus(String status);
    QueuePosition updateQueueStatus(Long queueId, String status);
    void deleteQueue(String username);
    QueuePosition getQueueById(Long id);
    List<QueuePosition> getQueuesByUser(String username);
    QueuePosition getNextQueue();
    double getAverageWaitTime();
    double getAverageWaitTimeByStatus(String status);
    long getQueueCountByStatus(String status);
    List<Queue> getActiveQueues();
    long getQueueCount();
    double getAverageWaitTimeByType(String type);
    QueuePosition getNextInQueue();
    void processNextInQueue();
    Map<String, Object> getQueueStatistics();
    Map<String, Object> getCurrentQueueDetails();
    Map<String, Object> getQueueInfoByUsername(String username);
    String generateQueueNumber();
    String getNextQueueNumber();
    QueuePosition createQueueEntry(String username, Long serviceId);
    Map<String, Object> getQueueInfo(String queueNumber);
    long getEstimatedWaitTime(String queueNumber);
    List<QueuePosition> getQueuesByType(String type);
    List<QueuePosition> getQueuesByDescription(String description);
    List<QueuePosition> getQueuesByEstimatedWaitTime(Integer minWaitTime, Integer maxWaitTime);
    List<QueuePosition> getQueuesByProcessedAt(LocalDateTime startDate, LocalDateTime endDate);
    long getQueueCountByType(String type);
    QueuePosition getCurrentQueuePosition();
    long getAverageProcessingTime();
    List<QueuePosition> getRecentQueues(int limit);
    void cancelQueue(String queueNumber);
    void completeQueue(Long queueId);
    void skipQueue(Long queueId);
    void transferQueue(Long queueId, String newUsername);
    int getQueuePosition(String queueNumber);
    Queue getCurrentQueue();
    int calculateWaitTime(String queueNumber);
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
    QueuePosition createPublicQueue(String publicIdentifier, String kioskTerminalId);
    QueuePosition getPublicQueueStatus(String publicIdentifier, String kioskSessionId);
    void cancelPublicQueue(String publicIdentifier, String kioskSessionId);
    boolean isValidPublicQueue(String publicIdentifier, String kioskSessionId);
    void setReceiptPreference(String queueNumber, ReceiptPreference preference);
    void generateAndSendReceipt(String queueNumber);
    Queue createQueue(Payment payment, Student student);
    Queue updateQueueStatus(Long queueId, QueueStatus status);
    Queue createQueue(Student student, Long serviceId);
    Queue createQueue(Student student);
    Queue createQueueForKiosk(String studentId, String kioskSessionId, String kioskTerminalId, ReceiptPreference receiptPreference);
    /**
     * Reorders the positions of all pending queues based on their creation time.
     * This ensures that queue positions are sequential and without gaps.
     */
    void reorderQueuePositions();
    
    Optional<Queue> findByQueueNumber(String queueNumber);
    
    List<Queue> findByStatus(QueueStatus status);
    
    List<Queue> findAllOrderedByPosition();
    
    int getCurrentPosition();
    
    Queue moveToNextQueue();
    
    Queue moveToPreviousQueue();
    
    Queue jumpToQueue(String queueNumber);
    
    void resetQueue();
    
    long getEstimatedWaitTime();
    
    int getTotalQueueSize();
    
    boolean isQueueEmpty();

    /**
     * Check if there is any queue currently in PROCESSING status
     * @return true if there is a queue in PROCESSING status, false otherwise
     */
    boolean hasProcessingQueue();
} 