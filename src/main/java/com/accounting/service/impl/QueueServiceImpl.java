package com.accounting.service.impl;

import com.accounting.model.Queue;
import com.accounting.model.QueuePosition;
import com.accounting.model.User;
import com.accounting.model.enums.QueueStatus;
import com.accounting.model.enums.ReceiptPreference;
import com.accounting.model.enums.DocumentType;
import com.accounting.model.enums.DocumentStatus;
import com.accounting.repository.QueueRepository;
import com.accounting.service.NotificationService;
import com.accounting.service.QueueService;
import com.accounting.service.EmailService;
import com.accounting.service.PdfService;
import com.accounting.service.PrinterService;
import com.accounting.model.Document;
import com.accounting.repository.DocumentRepository;
import com.accounting.repository.StudentRepository;
import com.accounting.model.Student;
import com.accounting.service.StudentService;
import com.accounting.exception.ResourceNotFoundException;
import java.util.Arrays;
import lombok.RequiredArgsConstructor;
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
import java.util.UUID;
import com.accounting.model.Payment;
import com.accounting.repository.PaymentRepository;
import lombok.RequiredArgsConstructor;
import com.accounting.repository.UserRepository;
import com.accounting.model.enums.PaymentType;
import java.util.concurrent.atomic.AtomicInteger;

@Service
@Transactional
@Slf4j
public class QueueServiceImpl implements QueueService {

    private static final Logger logger = LoggerFactory.getLogger(QueueServiceImpl.class);
    private final QueueRepository queueRepository;
    private final UserRepository userRepository;
    private final StudentRepository studentRepository;
    private final PaymentRepository paymentRepository;
    private final EmailService emailService;
    private final PdfService pdfService;
    private final NotificationService notificationService;
    private final PrinterService printerService;
    private final DocumentRepository documentRepository;
    private final StudentService studentService;
    private final Random random = new Random();
    private AtomicInteger currentPosition = new AtomicInteger(0);

    @Autowired
    public QueueServiceImpl(QueueRepository queueRepository,
                          UserRepository userRepository,
                          StudentRepository studentRepository,
                          PaymentRepository paymentRepository,
                          EmailService emailService,
                          PdfService pdfService,
                          NotificationService notificationService,
                          PrinterService printerService,
                          DocumentRepository documentRepository,
                          StudentService studentService) {
        this.queueRepository = queueRepository;
        this.userRepository = userRepository;
        this.studentRepository = studentRepository;
        this.paymentRepository = paymentRepository;
        this.emailService = emailService;
        this.pdfService = pdfService;
        this.notificationService = notificationService;
        this.printerService = printerService;
        this.documentRepository = documentRepository;
        this.studentService = studentService;
    }

    private String generateKioskSessionId() {
        return "KSK-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }

    private String generatePublicIdentifier() {
        // Format: PUB-YYYYMMDD-XXXX where XXXX is a random number
        LocalDateTime now = LocalDateTime.now();
        String datePart = now.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String randomPart = String.format("%04d", random.nextInt(10000));
        return "PUB-" + datePart + "-" + randomPart;
    }

    @Override
    @Transactional
    public QueuePosition createPublicQueue(String publicIdentifier, String kioskTerminalId) {
        Queue queue = new Queue();
        queue.setKioskSessionId(generateKioskSessionId());
        queue.setPublicIdentifier(publicIdentifier);
        queue.setKioskTerminalId(kioskTerminalId);
        queue.setQueueNumber(getNextQueueNumber());
        queue.setCreatedAt(LocalDateTime.now());
        queue.setStatus(QueueStatus.PENDING);
        queue.setPosition(getNextPosition());
        queue.setReceiptPreference(ReceiptPreference.DIGITAL);
        Queue savedQueue = queueRepository.save(queue);
        
        // For public users, only return queue number and receipt info
        QueuePosition position = new QueuePosition();
        position.setQueueNumber(savedQueue.getQueueNumber());
        position.setKioskSessionId(savedQueue.getKioskSessionId());
        position.setPublicIdentifier(savedQueue.getPublicIdentifier());
        position.setReceiptPreference(savedQueue.getReceiptPreference());
        
        // Generate and save receipt
        String receiptContent = generateReceiptContent(savedQueue);
        saveReceipt(receiptContent, savedQueue.getQueueNumber());
        
        return position;
    }

    private void saveReceipt(String receiptContent, String queueNumber) {
        try {
            // Save receipt as PDF
            String fileName = "receipt_" + queueNumber + ".pdf";
            pdfService.generatePdf(receiptContent, fileName);
            
            // Store receipt reference in database
            Document receipt = new Document();
            receipt.setFileName(fileName);
            receipt.setDocumentType("RECEIPT");
            receipt.setReferenceNumber(queueNumber);
            documentRepository.save(receipt);
        } catch (Exception e) {
            logger.error("Error saving receipt for queue: " + queueNumber, e);
        }
    }

    @Override
    @Transactional(readOnly = true)
    public QueuePosition getPublicQueueStatus(String publicIdentifier, String kioskSessionId) {
        return queueRepository.findByPublicIdentifierAndKioskSessionId(publicIdentifier, kioskSessionId)
                .map(queue -> {
                    QueuePosition position = convertToQueuePosition(queue);
                    position.setKioskSessionId(queue.getKioskSessionId());
                    position.setPublicIdentifier(queue.getPublicIdentifier());
                    return position;
                })
                .orElse(null);
    }

    @Override
    @Transactional
    public void cancelPublicQueue(String publicIdentifier, String kioskSessionId) {
        queueRepository.findByPublicIdentifierAndKioskSessionId(publicIdentifier, kioskSessionId)
                .ifPresent(queue -> {
                    queue.setStatus(QueueStatus.CANCELLED);
                    queueRepository.save(queue);
                    notifyQueueCancellation(queue.getId());
                });
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isValidPublicQueue(String publicIdentifier, String kioskSessionId) {
        return queueRepository.existsByPublicIdentifierAndKioskSessionId(publicIdentifier, kioskSessionId);
    }

    @Override
    @Transactional
    public void addToQueue(User user) {
        Queue queue = new Queue();
        queue.setUserUsername(user.getUsername());
        queue.setQueueNumber(getNextQueueNumber());
        queue.setCreatedAt(LocalDateTime.now());
        queue.setStatus(QueueStatus.PENDING);
        queue.setPosition(getNextPosition());
        queueRepository.save(queue);
    }

    @Override
    @Transactional
    public void removeFromQueue(User user) {
        queueRepository.findByUserUsername(user.getUsername())
            .ifPresent(queue -> queueRepository.delete(queue));
    }

    @Override
    @Transactional(readOnly = true)
    public QueuePosition getQueueStatus(User user) {
        return queueRepository.findByUserUsername(user.getUsername())
            .map(queue -> new QueuePosition(queue.getPosition(), calculateWaitTime(queue.getQueueNumber())))
            .orElse(null);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isInQueue(User user) {
        return queueRepository.findByUserUsername(user.getUsername()).isPresent();
    }

    @Override
    @Transactional(readOnly = true)
    public int getQueueSize() {
        Long count = queueRepository.countByStatus(QueueStatus.PENDING);
        return count != null ? count.intValue() : 0;
    }

    @Override
    @Transactional(readOnly = true)
    public QueuePosition getCurrentQueuePosition() {
        PageRequest pageRequest = PageRequest.of(0, 1);
        List<Queue> queues = queueRepository.findByStatusOrderedAndLimited(QueueStatus.PENDING, pageRequest);
        return queues.isEmpty() ? null : convertToQueuePosition(queues.get(0));
    }

    @Override
    @Transactional
    public Queue createQueue(Student student) {
        Queue queue = new Queue();
        queue.setStudentId(student.getStudentId());
        queue.setUser(student.getUser());
        queue.setUserUsername(student.getUser().getUsername());
        queue.setStatus(QueueStatus.PENDING);
        queue.setCreatedAt(LocalDateTime.now());
        queue.setUpdatedAt(LocalDateTime.now());
        
        // Generate queue number and session ID
        queue.setQueueNumber(generateQueueNumber());
        queue.setKioskSessionId(generateKioskSessionId());
        queue.setPublicIdentifier(generatePublicIdentifier());
        
        // Set position and estimated wait time
        queue.setPosition(calculatePosition());
        queue.setEstimatedWaitTime(calculateWaitTime(null));
        
        Queue savedQueue = queueRepository.save(queue);
        
        // Generate and send receipt if needed
        if (savedQueue.getReceiptPreference() != null) {
            generateAndSendReceipt(savedQueue.getQueueNumber());
        }
        
        return savedQueue;
    }

    @Override
    @Transactional
    public QueuePosition updateQueueStatus(Long queueId, String status) {
        Queue queue = getQueueEntityById(queueId);
        queue.setStatus(QueueStatus.valueOf(status));
        if (queue.getStatus() == QueueStatus.PENDING) {
            queue.setProcessedAt(LocalDateTime.now());
        }
        Queue savedQueue = queueRepository.save(queue);
        return new QueuePosition(savedQueue.getPosition(), calculateWaitTime(savedQueue.getQueueNumber()));
    }

    @Override
    @Transactional(readOnly = true)
    public QueuePosition getQueueById(Long id) {
        Queue queue = queueRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Queue not found with id: " + id));
        return new QueuePosition(queue.getPosition(), calculateWaitTime(queue.getQueueNumber()));
    }

    @Override
    @Transactional(readOnly = true)
    public List<QueuePosition> getQueuesByUser(String username) {
        return queueRepository.findByUserUsernameOrderByCreatedAtDesc(username).stream()
                .map(queue -> new QueuePosition(queue.getPosition(), calculateWaitTime(queue.getQueueNumber())))
                .toList();
    }

    @Override
    @Transactional(readOnly = true)
    public List<QueuePosition> getQueuesByStatus(String status) {
        return queueRepository.findByStatusOrderByCreatedAtDesc(QueueStatus.valueOf(status)).stream()
                .map(queue -> new QueuePosition(queue.getPosition(), calculateWaitTime(queue.getQueueNumber())))
                .toList();
    }

    @Override
    @Transactional(readOnly = true)
    public QueuePosition getNextQueue() {
        PageRequest pageRequest = PageRequest.of(0, 1);
        List<Queue> queues = queueRepository.findByStatusOrderedAndLimited(QueueStatus.PENDING, pageRequest);
        return queues.isEmpty() ? null : 
            new QueuePosition(queues.get(0).getPosition(), calculateWaitTime(queues.get(0).getQueueNumber()));
    }

    @Override
    @Transactional(readOnly = true)
    public double getAverageWaitTime() {
        Double avgWait = queueRepository.avgWaitTime();
        return avgWait != null ? avgWait : 0.0;
    }

    @Override
    @Transactional(readOnly = true)
    public double getAverageWaitTimeByType(String type) {
        List<Object[]> results = queueRepository.avgWaitTimeByType();
        return results.stream()
            .filter(arr -> type.equals(arr[0]))
            .findFirst()
            .map(arr -> (Double) arr[1])
            .orElse(0.0);
    }

    @Override
    @Transactional(readOnly = true)
    public QueuePosition getQueueByUsername(String username) {
        return queueRepository.findByUserUsername(username)
            .map(this::convertToQueuePosition)
            .orElse(null);
    }

    @Override
    @Transactional(readOnly = true)
    public String getNextQueueNumber() {
        long count = queueRepository.count();
        return String.format("Q%04d", count + 1);
    }

    @Override
    @Transactional(readOnly = true)
    public List<QueuePosition> getQueuesByType(String type) {
        return queueRepository.findByTypeOrderByCreatedAtDesc(PaymentType.valueOf(type)).stream()
            .map(this::convertToQueuePosition)
            .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<QueuePosition> getQueuesByDescription(String description) {
        return queueRepository.findByDescriptionContainingIgnoreCaseOrderByCreatedAtDesc(description).stream()
            .map(this::convertToQueuePosition)
            .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<QueuePosition> getQueuesByEstimatedWaitTime(Integer minWaitTime, Integer maxWaitTime) {
        return queueRepository.findByEstimatedWaitTimeBetweenOrderByCreatedAtDesc(minWaitTime, maxWaitTime).stream()
                .map(this::convertToQueuePosition)
                .toList();
    }

    @Override
    @Transactional(readOnly = true)
    public List<QueuePosition> getQueuesByProcessedAt(LocalDateTime startDate, LocalDateTime endDate) {
        return queueRepository.findByProcessedAtBetweenOrderByCreatedAtDesc(startDate, endDate).stream()
                .map(this::convertToQueuePosition)
                .toList();
    }

    @Override
    @Transactional(readOnly = true)
    public long getQueueCountByType(String type) {
        logger.debug("Getting queue count by type: {}", type);
        if (!StringUtils.hasText(type)) {
            throw new IllegalArgumentException("Type cannot be empty");
        }
        return queueRepository.countByType(PaymentType.valueOf(type));
    }

    @Override
    @Transactional(readOnly = true)
    public long getQueueCountByStatus(String status) {
        return queueRepository.countByStatus(QueueStatus.valueOf(status));
    }

    @Override
    public int getQueuePosition(String queueNumber) {
        Queue queue = queueRepository.findByQueueNumber(queueNumber)
                .orElseThrow(() -> new EntityNotFoundException("Queue not found: " + queueNumber));
        return queue.getPosition();
    }

    @Override
    public int calculateWaitTime(String queueNumber) {
        if (queueNumber == null || queueNumber.isEmpty()) {
            // For new queues, calculate based on total pending queues
            return getQueueSize() * 5;
        }
        
        Queue queue = queueRepository.findByQueueNumber(queueNumber)
                .orElseThrow(() -> new EntityNotFoundException("Queue not found: " + queueNumber));
        
        // Calculate wait time based on position (5 minutes per queue)
        return queue.getPosition() * 5;
    }

    @Override
    public void cancelQueue(String queueNumber) {
        Queue queue = queueRepository.findByQueueNumber(queueNumber)
            .orElseThrow(() -> new EntityNotFoundException("Queue not found: " + queueNumber));
            
        if (queue.getStatus() != QueueStatus.PENDING) {
            throw new IllegalStateException("Cannot cancel a queue that is not in pending status");
        }
        
        queue.setStatus(QueueStatus.CANCELLED);
        queue.setUpdatedAt(LocalDateTime.now());
        queueRepository.save(queue);
        
        // Reorder remaining queue positions
        reorderQueuePositions();
    }

    @Override
    @Transactional(readOnly = true)
    public List<QueuePosition> getRecentQueues(int limit) {
        return queueRepository.findAll(PageRequest.of(0, limit, Sort.by(Sort.Direction.DESC, "createdAt")))
                .getContent().stream()
                .map(this::convertToQueuePosition)
                .toList();
    }

    @Override
    @Transactional(readOnly = true)
    public QueuePosition getNextInQueue() {
        PageRequest pageRequest = PageRequest.of(0, 1);
        List<Queue> queues = queueRepository.findByStatusOrderedAndLimited(QueueStatus.PENDING, pageRequest);
        return queues.isEmpty() ? null : convertToQueuePosition(queues.get(0));
    }

    @Override
    @Transactional
    public void processNextInQueue() {
        // Get pending queues ordered by position
        List<Queue> pendingQueues = queueRepository.findByStatusOrderByPositionAsc(QueueStatus.PENDING);
        
        // Get the next queue (earliest created if multiple with same position)
        Queue nextQueue = pendingQueues.stream()
                .min((q1, q2) -> {
                    int posCompare = q1.getPosition().compareTo(q2.getPosition());
                    return posCompare != 0 ? posCompare : 
                           q1.getCreatedAt().compareTo(q2.getCreatedAt());
                })
                .orElse(null);
                
        if (nextQueue != null) {
            nextQueue.setStatus(QueueStatus.COMPLETED);
            nextQueue.setProcessedAt(LocalDateTime.now());
            queueRepository.save(nextQueue);
            notifyQueueStatus(nextQueue.getId(), QueueStatus.COMPLETED.name());
            
            // Reorder remaining queues
            reorderQueuePositions();
        }
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getQueueStatistics() {
        try {
            Map<String, Object> stats = new HashMap<>();
            stats.put("totalQueues", queueRepository.count());
            stats.put("pendingQueues", queueRepository.countByStatus(QueueStatus.PENDING));
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
        Map<String, Object> details = new HashMap<>();
        PageRequest pageRequest = PageRequest.of(0, 1);
        List<Queue> queues = queueRepository.findByStatusOrderedAndLimited(QueueStatus.PENDING, pageRequest);
        Queue currentQueue = queues.isEmpty() ? null : queues.get(0);
        if (currentQueue != null) {
            details.put("queueNumber", currentQueue.getQueueNumber());
            details.put("position", currentQueue.getPosition());
            details.put("estimatedWaitTime", currentQueue.getEstimatedWaitTime());
            details.put("status", currentQueue.getStatus());
        }
        return details;
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getQueueInfoByUsername(String username) {
        Queue queue = queueRepository.findByUserUsername(username)
                .orElse(null);
        Map<String, Object> info = new HashMap<>();
        if (queue != null) {
            info.put("queueNumber", queue.getQueueNumber());
            info.put("position", queue.getPosition());
            info.put("status", queue.getStatus());
            info.put("estimatedWaitTime", calculateWaitTime(queue.getQueueNumber()));
        }
        return info;
    }

    @Override
    @Transactional
    public QueuePosition createQueueEntry(String username, Long paymentId) {
        Payment payment = paymentRepository.findById(paymentId)
            .orElseThrow(() -> new EntityNotFoundException("Payment not found"));
            
        Student student = studentRepository.findByUsername(username)
            .orElseThrow(() -> new EntityNotFoundException("Student not found"));

        String queueNumber = generateQueueNumber();
        String publicIdentifier = generatePublicIdentifier();

        Queue queue = new Queue();
        queue.setQueueNumber(queueNumber);
        queue.setStudentId(student.getStudentId());
        queue.setUserUsername(username);
        queue.setUser(student.getUser());
        queue.setPublicIdentifier(publicIdentifier);
        queue.setKioskSessionId(generateKioskSessionId());
        queue.setStatus(QueueStatus.PENDING);
        queue.setPosition(calculatePosition());
        queue.setEstimatedWaitTime(calculateWaitTime(null));
        queue.setDescription("Payment processing for " + payment.getDescription());
        queue.setCreatedAt(LocalDateTime.now());
        queue.setUpdatedAt(LocalDateTime.now());
        
        // Set payment related information
        queue.setPaymentId(payment.getId());
        queue.setAmount(payment.getAmount());
        queue.setPaymentNumber(payment.getTransactionReference());
        queue.setStatus(QueueStatus.PENDING);
        queue.setScheduleId(payment.getId().toString());
        
        Queue savedQueue = queueRepository.save(queue);
        
        return new QueuePosition(savedQueue.getPosition(), calculateWaitTime(savedQueue.getQueueNumber()));
    }

    @Override
    @Transactional
    public Map<String, Object> getQueueInfo(String queueNumber) {
        Queue queue = queueRepository.findByQueueNumber(queueNumber)
            .orElseThrow(() -> new EntityNotFoundException("Queue not found"));

        Map<String, Object> queueInfo = new HashMap<>();
        queueInfo.put("queueNumber", queue.getQueueNumber());
        queueInfo.put("status", queue.getStatus());
        queueInfo.put("position", queue.getPosition());
        queueInfo.put("estimatedWaitTime", queue.getEstimatedWaitTime());
        queueInfo.put("createdAt", queue.getCreatedAt());
        queueInfo.put("processedAt", queue.getProcessedAt());
        
        return queueInfo;
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
        PageRequest pageRequest = PageRequest.of(0, 1);
        List<Queue> queues = queueRepository.findByStatusOrderedAndLimited(QueueStatus.PENDING, pageRequest);
        return queues.isEmpty() ? null : queues.get(0);
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
            
            Queue queue = getQueueEntityById(queueId);
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
            
            Queue queue = getQueueEntityById(queueId);
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
            
            Queue queue = getQueueEntityById(queueId);
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

    @Override
    @Transactional
    public Queue createQueue(Payment payment, Student student) {
        Queue queue = new Queue();
        queue.setQueueNumber(generateQueueNumber());
        queue.setStudentId(student.getStudentId());
        queue.setStatus(QueueStatus.PENDING);
        
        // Set payment related information
        queue.setPaymentId(payment.getId());
        queue.setAmount(payment.getAmount());
        queue.setPaymentNumber(payment.getTransactionReference());
        queue.setStatus(QueueStatus.PENDING);
        queue.setScheduleId(payment.getId().toString());
        
        // Set receipt preference
        queue.setReceiptPreference(ReceiptPreference.DIGITAL);
        
        Queue savedQueue = queueRepository.save(queue);
        
        // Send notifications
        notifyQueueCreation(savedQueue.getId());
        
        // If digital receipt is preferred, generate and send it
        if (ReceiptPreference.DIGITAL.equals(queue.getReceiptPreference())) {
            generateAndSendReceipt(savedQueue.getQueueNumber());
        }
        
        return savedQueue;
    }

    @Override
    @Transactional(readOnly = true)
    public double getAverageWaitTimeByStatus(String status) {
        Double avgWait = queueRepository.avgWaitTimeByStatus(QueueStatus.valueOf(status));
        return avgWait != null ? avgWait : 0.0;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Queue> getActiveQueues() {
        return queueRepository.findByStatus(QueueStatus.PENDING);
    }

    @Override
    @Transactional(readOnly = true)
    public long getQueueCount() {
        return queueRepository.count();
    }

    @Override
    @Transactional
    public QueuePosition createQueue(QueuePosition position) {
        Queue queue = new Queue();
        queue.setPosition(getNextPosition());
        queue.setStatus(QueueStatus.PENDING);
        Queue savedQueue = queueRepository.save(queue);
        return new QueuePosition(savedQueue.getPosition(), calculateWaitTime(savedQueue.getQueueNumber()));
    }

    private Integer getNextPosition() {
        return queueRepository.findMaxPosition().orElse(0) + 1;
    }

    @Override
    public Queue createQueueForKiosk(String studentId, String kioskSessionId, String kioskTerminalId, ReceiptPreference receiptPreference) {
        Student student = studentRepository.findByStudentId(studentId)
            .orElseThrow(() -> new EntityNotFoundException("Student not found"));

        Queue queue = new Queue();
        queue.setStudentId(studentId);
        queue.setUser(student.getUser());
        queue.setKioskSessionId(kioskSessionId);
        queue.setKioskTerminalId(kioskTerminalId);
        queue.setReceiptPreference(receiptPreference);
        queue.setStatus(QueueStatus.PENDING);
        queue.setPosition(calculatePosition());
        queue.setCreatedAt(LocalDateTime.now());
        queue.setQueueNumber(generateQueueNumber());
        return queueRepository.save(queue);
    }

    @Override
    public QueuePosition createQueue(String username) {
        User user = userRepository.findByUsername(username)
            .orElseThrow(() -> new EntityNotFoundException("User not found"));

        Queue queue = new Queue();
        queue.setUserUsername(username);
        queue.setUser(user);
        queue.setQueueNumber(generateQueueNumber());
        queue.setStatus(QueueStatus.PENDING);
        queue.setPosition(calculatePosition());
        queue.setCreatedAt(LocalDateTime.now());
        Queue savedQueue = queueRepository.save(queue);
        return new QueuePosition(savedQueue.getPosition(), calculateWaitTime(savedQueue.getQueueNumber()));
    }

    @Override
    @Transactional
    public Queue createQueue(Student student, Long serviceId) {
        Queue queue = new Queue();
        queue.setStudentId(student.getStudentId());
        queue.setUser(student.getUser());
        queue.setUserUsername(student.getUser().getUsername());
        queue.setScheduleId(serviceId.toString());
        queue.setStatus(QueueStatus.PENDING);
        queue.setReceiptPreference(ReceiptPreference.EMAIL);
        queue.setPosition(calculatePosition());
        return queueRepository.save(queue);
    }

    @Override
    public void setReceiptPreference(String queueNumber, ReceiptPreference preference) {
        Queue queue = queueRepository.findByQueueNumber(queueNumber)
                .orElseThrow(() -> new EntityNotFoundException("Queue not found: " + queueNumber));
        queue.setReceiptPreference(preference);
        queue.setUpdatedAt(LocalDateTime.now());
        queueRepository.save(queue);
    }

    @Override
    public void generateAndSendReceipt(String queueNumber) {
        Queue queue = queueRepository.findByQueueNumber(queueNumber)
                .orElseThrow(() -> new EntityNotFoundException("Queue not found: " + queueNumber));

        // Generate receipt content
        String receiptContent = generateReceiptContent(queue);
        byte[] pdfContent = pdfService.generatePdf(receiptContent);

        // Send receipt based on preference
        if (queue.getReceiptPreference() == ReceiptPreference.EMAIL && queue.getUserUsername() != null) {
            emailService.sendEmail(
                queue.getUserUsername(),
                "Queue Receipt - " + queue.getQueueNumber(),
                "Please find your queue receipt attached."
            );
        }
    }

    private String generateReceiptContent(Queue queue) {
        StringBuilder receipt = new StringBuilder();
        receipt.append("Queue Receipt\n");
        receipt.append("=============\n");
        receipt.append("Queue Number: ").append(queue.getQueueNumber()).append("\n");
        receipt.append("Date: ").append(queue.getCreatedAt().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))).append("\n");
        receipt.append("Position: ").append(queue.getPosition()).append("\n");
        receipt.append("Estimated Wait Time: ").append(calculateWaitTime(queue.getQueueNumber())).append(" minutes\n");
        receipt.append("Terminal ID: ").append(queue.getKioskTerminalId()).append("\n");
        receipt.append("\nThank you for using our service!\n");
        
        return receipt.toString();
    }

    private Queue getQueueEntityById(Long id) {
        return queueRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Queue not found with id: " + id));
    }

    private QueuePosition convertToQueuePosition(Queue queue) {
        if (queue == null) {
            return null;
        }
        return new QueuePosition(
            queue.getPosition(),
            calculateWaitTime(queue.getQueueNumber())
        );
    }

    private Integer calculatePosition() {
        // Get all pending queues ordered by position
        List<Queue> pendingQueues = queueRepository.findByStatusOrderByPositionAsc(QueueStatus.PENDING);
        
        // If no pending queues, start with position 1
        if (pendingQueues.isEmpty()) {
            return 1;
        }
        
        // Get the highest position and add 1
        return pendingQueues.stream()
                .mapToInt(Queue::getPosition)
                .max()
                .orElse(0) + 1;
    }

    @Override
    public String generateQueueNumber() {
        // Use a simple sequential format: Q0001, Q0002, etc.
        return getNextQueueNumber();
    }

    @Override
    public Queue updateQueueStatus(Long queueId, QueueStatus newStatus) {
        Queue queue = queueRepository.findById(queueId)
            .orElseThrow(() -> new ResourceNotFoundException("Queue not found with id: " + queueId));
        
        queue.setStatus(newStatus);
        if (newStatus == QueueStatus.PENDING) {
            queue.setProcessedAt(LocalDateTime.now());
        }
        
        return queueRepository.save(queue);
    }

    @Override
    @Transactional
    public void reorderQueuePositions() {
        // Get all pending queues ordered by creation time
        List<Queue> waitingQueues = queueRepository.findByStatusOrderByCreatedAtAsc(QueueStatus.PENDING);
        
        // Reorder positions starting from 1
        int position = 1;
        for (Queue queue : waitingQueues) {
            queue.setPosition(position);
            queue.setEstimatedWaitTime(calculateWaitTime(queue.getQueueNumber()));
            queueRepository.save(queue);
            position++;
        }
        
        // Force a flush to ensure all updates are persisted
        queueRepository.flush();
    }

    private void notifyQueueCreation(Long queueId) {
        try {
            Queue queue = queueRepository.findById(queueId)
                .orElseThrow(() -> new EntityNotFoundException("Queue not found"));
                
            String message = String.format(
                "New queue created: %s for payment processing. Position: %d, Estimated wait time: %d minutes",
                queue.getQueueNumber(),
                queue.getPosition(),
                queue.getEstimatedWaitTime()
            );
            
            notificationService.createNotification(message);
            
            // Send email notification if email is available
            if (queue.getUserUsername() != null) {
                emailService.sendQueueNotification(
                    queue.getUserUsername(),
                    "Queue Creation Confirmation",
                    message
                );
            }
        } catch (Exception e) {
            logger.error("Failed to send queue creation notification", e);
        }
    }

    @Override
    public List<Queue> findByStatus(QueueStatus status) {
        return queueRepository.findByStatusOrderByPositionAsc(status);
    }

    @Override
    public List<Queue> findAllOrderedByPosition() {
        return queueRepository.findByStatusOrderByPositionAsc(QueueStatus.PENDING);
    }

    @Override
    public int getCurrentPosition() {
        return currentPosition.get();
    }

    @Override
    @Transactional
    public Queue moveToNextQueue() {
        List<Queue> waitingQueues = queueRepository.findByStatusOrderByPositionAsc(QueueStatus.PENDING);
        if (waitingQueues.isEmpty()) {
            return null;
        }
        
        int nextPosition = currentPosition.get() + 1;
        if (nextPosition >= waitingQueues.size()) {
            return null;
        }
        
        currentPosition.set(nextPosition);
        return waitingQueues.get(nextPosition);
    }

    @Override
    @Transactional
    public Queue moveToPreviousQueue() {
        List<Queue> waitingQueues = queueRepository.findByStatusOrderByPositionAsc(QueueStatus.PENDING);
        if (waitingQueues.isEmpty()) {
            return null;
        }
        
        int previousPosition = currentPosition.get() - 1;
        if (previousPosition < 0) {
            return null;
        }
        
        currentPosition.set(previousPosition);
        return waitingQueues.get(previousPosition);
    }

    @Override
    @Transactional
    public Queue jumpToQueue(String queueNumber) {
        Optional<Queue> targetQueue = queueRepository.findByQueueNumber(queueNumber);
        if (targetQueue.isEmpty()) {
            return null;
        }
        
        List<Queue> waitingQueues = queueRepository.findByStatusOrderByPositionAsc(QueueStatus.PENDING);
        int targetPosition = waitingQueues.indexOf(targetQueue.get());
        
        if (targetPosition >= 0) {
            currentPosition.set(targetPosition);
            return targetQueue.get();
        }
        
        return null;
    }

    @Override
    @Transactional
    public void resetQueue() {
        currentPosition.set(0);
        List<Queue> waitingQueues = queueRepository.findByStatusOrderByPositionAsc(QueueStatus.PENDING);
        int position = 1;
        
        for (Queue queue : waitingQueues) {
            queue.setPosition(position++);
            queueRepository.save(queue);
        }
    }

    @Override
    public long getEstimatedWaitTime() {
        Double avgWaitTime = queueRepository.avgWaitTime();
        return avgWaitTime != null ? Math.round(avgWaitTime / 60.0) : 0;
    }

    @Override
    public int getTotalQueueSize() {
        return (int) queueRepository.countByStatus(QueueStatus.PENDING);
    }

    @Override
    public boolean isQueueEmpty() {
        return queueRepository.count() == 0;
    }

    @Override
    public boolean hasProcessingQueue() {
        return !queueRepository.findByStatus(QueueStatus.PROCESSING).isEmpty();
    }
} 