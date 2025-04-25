package com.accounting.service.impl;

import com.accounting.model.Transaction;
import com.accounting.model.User;
import com.accounting.model.enums.TransactionStatus;
import com.accounting.model.enums.TransactionType;
import com.accounting.repository.TransactionRepository;
import com.accounting.service.TransactionService;
import jakarta.persistence.EntityNotFoundException;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@Transactional
@Slf4j
public class TransactionServiceImpl extends BaseServiceImpl<Transaction> implements TransactionService {

    private static final Logger logger = LoggerFactory.getLogger(TransactionServiceImpl.class);
    private final TransactionRepository transactionRepository;

    public TransactionServiceImpl(TransactionRepository transactionRepository) {
        this.transactionRepository = transactionRepository;
    }

    @Override
    protected JpaRepository<Transaction, Long> getRepository() {
        return transactionRepository;
    }

    @Override
    protected Class<Transaction> getEntityClass() {
        return Transaction.class;
    }

    @Override
    protected void updateEntityFields(Transaction existing, Transaction updated) {
        existing.setTransactionNumber(updated.getTransactionNumber());
        existing.setAmount(updated.getAmount() != null ? updated.getAmount().toString() : null);
        existing.setStatus(updated.getStatus());
        existing.setType(updated.getType());
        existing.setCategory(updated.getCategory());
        existing.setSubCategory(updated.getSubCategory());
        existing.setCurrency(updated.getCurrency());
        existing.setTaxAmount(updated.getTaxAmount() != null ? updated.getTaxAmount().toString() : null);
        existing.setNotes(updated.getNotes());
        existing.setRecurringFrequency(updated.getRecurringFrequency());
        existing.setNextDueDate(updated.getNextDueDate());
        existing.setUser(updated.getUser());
    }

    @Override
    public void validate(Transaction transaction) {
        if (transaction == null) {
            throw new IllegalArgumentException("Transaction cannot be null");
        }
        if (transaction.getAmount() == null || transaction.getAmount().compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Transaction amount must be greater than zero");
        }
        if (transaction.getStatus() == null) {
            throw new IllegalArgumentException("Transaction status cannot be null");
        }
        if (transaction.getType() == null) {
            throw new IllegalArgumentException("Transaction type cannot be null");
        }
        if (transaction.getUser() == null) {
            throw new IllegalArgumentException("Transaction must be associated with a user");
        }
    }

    @Override
    @Transactional(readOnly = true)
    public int getActiveQueueCount() {
        return Math.toIntExact(transactionRepository.countByStatus(TransactionStatus.PENDING));
    }

    @Override
    @Transactional(readOnly = true)
    public int getCompletedQueueCount() {
        return Math.toIntExact(transactionRepository.countByStatus(TransactionStatus.COMPLETED));
    }

    @Override
    @Transactional(readOnly = true)
    public int getFailedQueueCount() {
        return Math.toIntExact(transactionRepository.countByStatus(TransactionStatus.FAILED));
    }

    @Override
    @Transactional(readOnly = true)
    public int getCancelledQueueCount() {
        return Math.toIntExact(transactionRepository.countByStatus(TransactionStatus.CANCELLED));
    }

    @Override
    @Transactional(readOnly = true)
    public BigDecimal getTotalRevenue() {
        return transactionRepository.sumAmountByStatus(TransactionStatus.COMPLETED).orElse(BigDecimal.ZERO);
    }

    @Override
    @Transactional(readOnly = true)
    public int getTotalTransactions() {
        return Math.toIntExact(transactionRepository.countByStatus(TransactionStatus.COMPLETED));
    }

    @Override
    @Transactional(readOnly = true)
    public int getTotalPendingTransactions() {
        return Math.toIntExact(transactionRepository.countByStatus(TransactionStatus.PENDING));
    }

    @Override
    @Transactional(readOnly = true)
    public int getTotalFailedTransactions() {
        return Math.toIntExact(transactionRepository.countByStatus(TransactionStatus.FAILED));
    }

    @Override
    @Transactional(readOnly = true)
    public int getTodayTransactionCount() {
        LocalDateTime startOfDay = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0).withNano(0);
        LocalDateTime endOfDay = startOfDay.plusDays(1);
        return Math.toIntExact(transactionRepository.countByCreatedAtBetween(startOfDay, endOfDay));
    }

    @Override
    @Transactional(readOnly = true)
    public double getTodayTotalAmount() {
        logger.debug("Getting total amount for today's transactions");
        LocalDateTime startOfDay = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0).withNano(0);
        LocalDateTime endOfDay = startOfDay.plusDays(1);
        BigDecimal amount = transactionRepository.sumAmountByCreatedAtBetween(startOfDay, endOfDay);
        return amount != null ? amount.doubleValue() : 0.0;
    }

    @Override
    @Transactional(readOnly = true)
    public int getPendingApprovalCount() {
        return Math.toIntExact(transactionRepository.countByStatus(TransactionStatus.PENDING));
    }

    @Override
    @Transactional(readOnly = true)
    public int getActiveUserCount() {
        return Math.toIntExact(transactionRepository.countByStatus(TransactionStatus.PENDING));
    }

    @Override
    @Transactional(readOnly = true)
    public int getOnlineUserCount() {
        return Math.toIntExact(transactionRepository.countByStatus(TransactionStatus.PENDING));
    }

    @Override
    @Transactional(readOnly = true)
    public List<Transaction> getRecentTransactions(int limit) {
        return transactionRepository.findTop10ByOrderByCreatedAtDesc()
                .stream()
                .filter(tx -> tx.getCreatedAt() != null)
                .limit(limit)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<Transaction> getDailyTransactions() {
        LocalDateTime startOfDay = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0).withNano(0);
        LocalDateTime endOfDay = startOfDay.plusDays(1);
        return transactionRepository.findByCreatedAtBetween(startOfDay, endOfDay);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Transaction> getTransactionsByDateRange(String start, String end) {
        LocalDateTime startDate = LocalDateTime.parse(start);
        LocalDateTime endDate = LocalDateTime.parse(end);
        return transactionRepository.findByCreatedAtBetween(startDate, endDate);
    }

    @Override
    @Transactional
    public Transaction createTransaction(Transaction transaction) {
        logger.debug("Creating new transaction: {}", transaction);
        validate(transaction);
        transaction.setCreatedAt(LocalDateTime.now());
        transaction.setStatus(TransactionStatus.PENDING);
        return transactionRepository.save(transaction);
    }

    @Override
    @Transactional(readOnly = true)
    public Transaction getTransactionById(Long id) {
        logger.debug("Getting transaction by id: {}", id);
        if (id == null) {
            throw new IllegalArgumentException("Transaction ID cannot be null");
        }
        return transactionRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Transaction not found with id: " + id));
    }

    @Override
    @Transactional
    public Transaction updateTransactionStatus(Long id, String status) {
        Transaction transaction = getTransactionById(id);
        transaction.setStatus(TransactionStatus.valueOf(status));
        return transactionRepository.save(transaction);
    }

    @Override
    @Transactional
    public void deleteTransaction(Long id) {
        logger.debug("Deleting transaction with id: {}", id);
        if (id == null) {
            throw new IllegalArgumentException("Transaction ID cannot be null");
        }
        if (!transactionRepository.existsById(id)) {
            throw new RuntimeException("Transaction not found with id: " + id);
        }
        transactionRepository.deleteById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Transaction> getAllTransactions() {
        return transactionRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public Transaction getTransaction(Long id) {
        return getTransactionById(id);
    }

    @Override
    @Transactional
    public Transaction updateTransaction(Transaction transaction) {
        logger.debug("Updating transaction: {}", transaction);
        validate(transaction);
        if (transaction.getId() == null) {
            throw new IllegalArgumentException("Transaction ID cannot be null for update");
        }
        if (!transactionRepository.existsById(transaction.getId())) {
            throw new RuntimeException("Transaction not found with id: " + transaction.getId());
        }
        return transactionRepository.save(transaction);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Transaction> getTransactionsByUser(String username) {
        logger.debug("Getting transactions for user: {}", username);
        if (!StringUtils.hasText(username)) {
            throw new IllegalArgumentException("Username cannot be empty");
        }
        return transactionRepository.findByUserUsernameOrderByCreatedAtDesc(username);
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getTransactionStatistics() {
        Map<String, Object> statistics = new HashMap<>();
        statistics.put("totalTransactions", getTotalTransactions());
        statistics.put("todayCount", getTodayTransactionCount());
        statistics.put("todayAmount", getTodayTotalAmount());
        statistics.put("pendingCount", getPendingApprovalCount());
        return statistics;
    }

    @Override
    @Transactional(readOnly = true)
    public BigDecimal getTotalAmount(String query) {
        // Implement based on your specific query requirements
        return BigDecimal.ZERO;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Transaction> getTransactionsByStatus(String status) {
        logger.debug("Getting transactions by status: {}", status);
        if (!StringUtils.hasText(status)) {
            throw new IllegalArgumentException("Status cannot be empty");
        }
        return transactionRepository.findByStatusOrderByCreatedAtDesc(TransactionStatus.valueOf(status.toUpperCase()));
    }

    @Override
    @Transactional(readOnly = true)
    public List<Transaction> getTransactionsByType(String type) {
        logger.debug("Getting transactions by type: {}", type);
        if (!StringUtils.hasText(type)) {
            throw new IllegalArgumentException("Type cannot be empty");
        }
        return transactionRepository.findByTypeOrderByCreatedAtDesc(TransactionType.valueOf(type));
    }

    @Override
    @Transactional(readOnly = true)
    public List<Transaction> getTransactionsByNotes(String notes) {
        logger.debug("Getting transactions by notes containing: {}", notes);
        if (!StringUtils.hasText(notes)) {
            throw new IllegalArgumentException("Notes cannot be empty");
        }
        return transactionRepository.findByNotesContainingIgnoreCaseOrderByCreatedAtDesc(notes);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Transaction> getTransactionsByAmount(Double minAmount, Double maxAmount) {
        BigDecimal min = minAmount != null ? BigDecimal.valueOf(minAmount) : BigDecimal.ZERO;
        BigDecimal max = maxAmount != null ? BigDecimal.valueOf(maxAmount) : BigDecimal.valueOf(Double.MAX_VALUE);
        return transactionRepository.findByAmountBetweenOrderByCreatedAtDesc(min, max);
    }

    @Override
    @Transactional(readOnly = true)
    public long getTransactionCount() {
        return transactionRepository.count();
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Long> getTransactionCountByType() {
        Map<String, Long> countByType = new HashMap<>();
        for (TransactionType type : TransactionType.values()) {
            countByType.put(type.name(), transactionRepository.countByType(type));
        }
        return countByType;
    }

    @Override
    @Transactional(readOnly = true)
    public long getTransactionCountByType(String type) {
        return transactionRepository.countByType(TransactionType.valueOf(type));
    }

    @Override
    @Transactional(readOnly = true)
    public double getTransactionAmount() {
        Optional<BigDecimal> amount = transactionRepository.sumAmount();
        return amount.map(BigDecimal::doubleValue).orElse(0.0);
    }

    @Override
    @Transactional(readOnly = true)
    public double getTransactionAmountByType(String type) {
        Optional<Double> amount = transactionRepository.sumAmountByType(TransactionType.valueOf(type));
        return amount.orElse(0.0);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Transaction> getTransactionsByDateRange(LocalDateTime start, LocalDateTime end) {
        return transactionRepository.findByCreatedAtBetween(start, end);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Object[]> getTransactionCountByTypeAndDateRange(LocalDateTime start, LocalDateTime end) {
        return transactionRepository.countByTypeAndDateRange(start, end);
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Long> getTransactionCountByStatus() {
        Map<String, Long> countByStatus = new HashMap<>();
        for (TransactionStatus status : TransactionStatus.values()) {
            countByStatus.put(status.name(), transactionRepository.countByStatus(status));
        }
        return countByStatus;
    }

    @Override
    @Transactional(readOnly = true)
    public long getTransactionCountByStatus(String status) {
        return transactionRepository.countByStatus(TransactionStatus.valueOf(status));
    }

    @Override
    @Transactional(readOnly = true)
    public long getTransactionCountByUser(String username) {
        return transactionRepository.countByUserUsername(username);
    }

    @Override
    @Transactional(readOnly = true)
    public double getTransactionAmountByUser(String username) {
        Optional<BigDecimal> amount = transactionRepository.sumAmountByUserUsername(username);
        return amount.map(BigDecimal::doubleValue).orElse(0.0);
    }

    @Override
    @Transactional(readOnly = true)
    public double getTransactionAmountByStatus(String status) {
        Optional<BigDecimal> amount = transactionRepository.sumAmountByStatus(TransactionStatus.valueOf(status));
        return amount.map(BigDecimal::doubleValue).orElse(0.0);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Transaction> getTransactionsByUser(Long userId) {
        return transactionRepository.findByUserId(userId);
    }

    @Override
    @Transactional
    public Transaction updateTransaction(Long id, Transaction transaction) {
        Transaction existingTransaction = getTransactionById(id);
        if (existingTransaction != null) {
            transaction.setId(id);
            return transactionRepository.save(transaction);
        }
        return null;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Transaction> getTransactionsByDescription(String description) {
        return getTransactionsByNotes(description);
    }

    @Override
    public Transaction findById(Long id) {
        return transactionRepository.findById(id)
            .orElseThrow(() -> new EntityNotFoundException("Transaction not found with id: " + id));
    }

    @Override
    public List<Transaction> getRecentTransactions(Long userId, int limit) {
        return transactionRepository.findByUserIdOrderByCreatedAtDesc(userId)
            .stream()
            .limit(limit)
            .collect(Collectors.toList());
    }

    @Override
    public List<Transaction> findAll() {
        return transactionRepository.findAll();
    }

    @Override
    public void deleteById(Long id) {
        transactionRepository.deleteById(id);
    }

    @Override
    public String getNextDueDate(Long userId) {
        return transactionRepository.findByUserId(userId)
            .stream()
            .filter(t -> t.getNextDueDate() != null)
            .min(Comparator.comparing(Transaction::getNextDueDate))
            .map(Transaction::getFormattedNextDueDate)
            .orElse(null);
    }

    @Override
    public double getCurrentBalance(Long userId) {
        return transactionRepository.sumAmountByUserId(userId)
            .orElse(BigDecimal.ZERO).doubleValue();
    }

    @Override
    public double getLastPaymentAmount(Long userId) {
        return transactionRepository.findTopByUserIdOrderByCreatedAtDesc(userId)
            .map(Transaction::getAmount)
            .orElse(BigDecimal.ZERO).doubleValue();
    }

    @Override
    public Transaction save(Transaction transaction) {
        return transactionRepository.save(transaction);
    }

    @Override
    public Transaction getTransactionByIdWithUser(Long id) {
        return transactionRepository.findByIdWithUser(id)
                .orElseThrow(() -> new EntityNotFoundException("Transaction not found with id: " + id));
    }

    @Override
    @Transactional(readOnly = true)
    public long getTotalTransactionsByUser(User user) {
        return transactionRepository.countByUserUsername(user.getUsername());
    }

    @Override
    @Transactional(readOnly = true)
    public long getTotalPaymentsByUser(User user) {
        return transactionRepository.countByUserUsernameAndStatus(user.getUsername(), TransactionStatus.COMPLETED);
    }

    @Override
    public List<Transaction> findTransactionsWithFilters(String status, String startDate, String endDate, String amountRange) {
        LocalDateTime start = startDate != null ? LocalDateTime.parse(startDate) : null;
        LocalDateTime end = endDate != null ? LocalDateTime.parse(endDate) : null;
        
        // Parse amount range if provided (format: "min-max")
        BigDecimal minAmount = null;
        BigDecimal maxAmount = null;
        if (amountRange != null && !amountRange.isEmpty()) {
            String[] range = amountRange.split("-");
            if (range.length == 2) {
                minAmount = new BigDecimal(range[0]);
                maxAmount = new BigDecimal(range[1]);
            }
        }
        
        // Build dynamic query based on filters
        return transactionRepository.findTransactionsWithFilters(
            status != null ? TransactionStatus.valueOf(status) : null,
            start,
            end,
            minAmount,
            maxAmount
        );
    }

    @Override
    public byte[] exportTransactions(String format, String startDate, String endDate) throws Exception {
        LocalDateTime start = startDate != null ? LocalDateTime.parse(startDate) : null;
        LocalDateTime end = endDate != null ? LocalDateTime.parse(endDate) : null;
        
        List<Transaction> transactions = transactionRepository.findByCreatedAtBetween(start, end);
        
        if ("csv".equalsIgnoreCase(format)) {
            return exportToCSV(transactions);
        } else if ("excel".equalsIgnoreCase(format)) {
            return exportToExcel(transactions);
        } else {
            throw new IllegalArgumentException("Unsupported export format: " + format);
        }
    }

    @Override
    public void bulkUpdateStatus(List<Long> transactionIds, TransactionStatus newStatus) {
        List<Transaction> transactions = transactionRepository.findAllById(transactionIds);
        for (Transaction transaction : transactions) {
            transaction.setStatus(newStatus);
            transaction.setUpdatedAt(LocalDateTime.now());
        }
        transactionRepository.saveAll(transactions);
    }

    private byte[] exportToCSV(List<Transaction> transactions) {
        StringBuilder csv = new StringBuilder();
        csv.append("ID,Date,Amount,Status,Notes\n");
        
        for (Transaction t : transactions) {
            csv.append(String.format("%d,%s,%.2f,%s,%s\n",
                t.getId(),
                t.getCreatedAt(),
                t.getAmount(),
                t.getStatus(),
                t.getNotes() != null ? t.getNotes().replace(",", ";") : ""
            ));
        }
        
        return csv.toString().getBytes();
    }

    private byte[] exportToExcel(List<Transaction> transactions) throws Exception {
        // Implementation using Apache POI or similar library
        // This is a placeholder - actual implementation would depend on the Excel library being used
        throw new UnsupportedOperationException("Excel export not yet implemented");
    }
} 