package com.accounting.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.accounting.service.TransactionService;
import com.accounting.model.Transaction;
import com.accounting.repository.TransactionRepository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;

@Service
public class TransactionServiceImpl implements TransactionService {

    @Autowired
    private TransactionRepository transactionRepository;
    
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    @Override
    public int getActiveQueueCount() {
        return (int) transactionRepository.countByStatus("ACTIVE");
    }

    @Override
    public int getTodayTransactionCount() {
        LocalDateTime startOfDay = LocalDate.now().atStartOfDay();
        LocalDateTime endOfDay = LocalDate.now().atTime(LocalTime.MAX);
        return (int) transactionRepository.countByTimestampBetween(startOfDay, endOfDay);
    }

    @Override
    public double getTodayTotalAmount() {
        LocalDateTime startOfDay = LocalDate.now().atStartOfDay();
        LocalDateTime endOfDay = LocalDate.now().atTime(LocalTime.MAX);
        return transactionRepository.sumAmountByTimestampBetween(startOfDay, endOfDay);
    }

    @Override
    public int getPendingApprovalCount() {
        return (int) transactionRepository.countByStatus("PENDING");
    }

    @Override
    public int getHighPriorityCount() {
        return (int) transactionRepository.countByStatus("HIGH_PRIORITY");
    }

    @Override
    public int getActiveUserCount() {
        // This would typically come from a UserRepository
        // For now, return a mock value
        return 15;
    }

    @Override
    public int getOnlineUserCount() {
        // This would typically come from a SessionRegistry or similar
        // For now, return a mock value
        return 8;
    }

    @Override
    public List<Transaction> getRecentTransactions(int limit) {
        return transactionRepository.findAll(
            PageRequest.of(0, limit, Sort.by(Sort.Direction.DESC, "timestamp"))
        ).getContent();
    }

    @Override
    public List<Transaction> getDailyTransactions() {
        LocalDateTime startOfDay = LocalDate.now().atStartOfDay();
        LocalDateTime endOfDay = LocalDate.now().atTime(LocalTime.MAX);
        return transactionRepository.findByTimestampBetween(startOfDay, endOfDay);
    }

    @Override
    public List<Transaction> getTransactionsByDateRange(String startDate, String endDate) {
        LocalDateTime start = startDate != null ? 
            LocalDate.parse(startDate, DATE_FORMATTER).atStartOfDay() :
            LocalDate.now().atStartOfDay();
            
        LocalDateTime end = endDate != null ?
            LocalDate.parse(endDate, DATE_FORMATTER).atTime(LocalTime.MAX) :
            LocalDate.now().atTime(LocalTime.MAX);
            
        return transactionRepository.findByTimestampBetween(start, end);
    }

    @Override
    public Transaction createTransaction(Transaction transaction) {
        transaction.setCreatedAt(LocalDateTime.now());
        transaction.setUpdatedAt(LocalDateTime.now());
        return transactionRepository.save(transaction);
    }

    @Override
    public Transaction getTransactionById(Long id) {
        return transactionRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Transaction not found"));
    }

    @Override
    public Transaction updateTransactionStatus(Long id, String status) {
        Transaction transaction = getTransactionById(id);
        transaction.setStatus(status);
        transaction.setStatusColor();
        transaction.setUpdatedAt(LocalDateTime.now());
        return transactionRepository.save(transaction);
    }

    @Override
    public void deleteTransaction(Long id) {
        transactionRepository.deleteById(id);
    }
} 