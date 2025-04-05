package com.accounting.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.accounting.service.AdminService;
import com.accounting.model.PaymentQueue;
import com.accounting.model.SystemSettings;
import com.accounting.repository.PaymentQueueRepository;
import com.accounting.repository.TransactionRepository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class AdminServiceImpl implements AdminService {

    @Autowired
    private PaymentQueueRepository paymentQueueRepository;
    
    @Autowired
    private TransactionRepository transactionRepository;

    @Override
    public List<PaymentQueue> getPendingPayments() {
        return paymentQueueRepository.findByStatus("PENDING");
    }

    @Override
    public Map<String, Object> getDailyReport() {
        Map<String, Object> report = new HashMap<>();
        LocalDateTime startOfDay = LocalDate.now().atStartOfDay();
        LocalDateTime endOfDay = startOfDay.plusDays(1);

        report.put("totalTransactions", transactionRepository.countByTimestampBetween(startOfDay, endOfDay));
        report.put("totalAmount", transactionRepository.sumAmountByTimestampBetween(startOfDay, endOfDay));
        report.put("pendingPayments", paymentQueueRepository.countByStatus("PENDING"));
        
        return report;
    }

    @Override
    public Map<String, Object> getMonthlyReport() {
        Map<String, Object> report = new HashMap<>();
        LocalDateTime startOfMonth = LocalDate.now().withDayOfMonth(1).atStartOfDay();
        LocalDateTime endOfMonth = startOfMonth.plusMonths(1);

        report.put("totalTransactions", transactionRepository.countByTimestampBetween(startOfMonth, endOfMonth));
        report.put("totalAmount", transactionRepository.sumAmountByTimestampBetween(startOfMonth, endOfMonth));
        report.put("averageDailyTransactions", transactionRepository.getAverageDailyTransactions(startOfMonth, endOfMonth));
        
        return report;
    }

    @Override
    public boolean verifyReceipt(String receiptNumber) {
        // TODO: Implement receipt verification logic
        // This could involve checking against a database of valid receipts
        // or integrating with an external verification service
        return true;
    }

    @Override
    public SystemSettings getSystemSettings() {
        // TODO: Implement system settings retrieval
        // This could involve loading from a database or configuration file
        return new SystemSettings();
    }
} 