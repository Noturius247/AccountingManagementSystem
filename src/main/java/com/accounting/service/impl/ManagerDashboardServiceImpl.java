package com.accounting.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.accounting.service.ManagerDashboardService;
import com.accounting.repository.TransactionRepository;
import com.accounting.repository.KioskRepository;
import com.accounting.repository.UserRepository;
import com.accounting.model.Kiosk;
import com.accounting.model.Transaction;
import com.accounting.model.enums.TransactionStatus;

import java.util.HashMap;
import java.util.Map;
import java.util.List;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import java.time.LocalDateTime;
import java.time.LocalDate;

@Service
public class ManagerDashboardServiceImpl implements ManagerDashboardService {

    @Autowired
    private TransactionRepository transactionRepository;
    
    @Autowired
    private KioskRepository kioskRepository;
    
    @Autowired
    private UserRepository userRepository;

    @Override
    public Map<String, Object> getDashboardStatistics() {
        Map<String, Object> statistics = new HashMap<>();
        statistics.put("activeUsers", getActiveUsersCount());
        statistics.put("activeKiosks", getActiveKiosksCount());
        statistics.put("todaysTransactions", getTodaysTransactionsCount());
        statistics.put("currentQueue", getCurrentQueueCount());
        return statistics;
    }

    @Override
    public List<Kiosk> getKioskStatus() {
        return kioskRepository.findAll();
    }

    @Override
    public List<Transaction> getRecentTransactions() {
        return transactionRepository.findAll(
            PageRequest.of(0, 5, Sort.by(Sort.Direction.DESC, "createdAt"))
        ).getContent();
    }

    @Override
    public int getActiveUsersCount() {
        LocalDateTime lastHour = LocalDateTime.now().minusHours(1);
        return (int) userRepository.countByLastActivityAfter(lastHour);
    }

    @Override
    public int getActiveKiosksCount() {
        return (int) kioskRepository.countByStatus("ONLINE");
    }

    @Override
    public int getTodaysTransactionsCount() {
        LocalDateTime startOfDay = LocalDate.now().atStartOfDay();
        LocalDateTime endOfDay = LocalDate.now().plusDays(1).atStartOfDay();
        return (int) transactionRepository.countByCreatedAtBetween(startOfDay, endOfDay);
    }

    @Override
    public int getCurrentQueueCount() {
        return (int) transactionRepository.countByStatus(TransactionStatus.PENDING);
    }
} 