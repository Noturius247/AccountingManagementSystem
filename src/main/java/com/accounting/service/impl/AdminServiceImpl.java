package com.accounting.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.accounting.service.AdminService;
import com.accounting.model.PaymentQueue;
import com.accounting.model.SystemSettings;
import com.accounting.repository.PaymentQueueRepository;
import com.accounting.repository.TransactionRepository;
import com.accounting.repository.SystemSettingsRepository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class AdminServiceImpl implements AdminService {

    @Autowired
    private PaymentQueueRepository paymentQueueRepository;
    
    @Autowired
    private TransactionRepository transactionRepository;
    
    @Autowired
    private SystemSettingsRepository systemSettingsRepository;

    @Override
    public List<PaymentQueue> getPendingPayments() {
        return paymentQueueRepository.findByStatus("PENDING");
    }

    @Override
    public Map<String, Object> getDailyReport() {
        Map<String, Object> report = new HashMap<>();
        LocalDateTime startOfDay = LocalDate.now().atStartOfDay();
        LocalDateTime endOfDay = startOfDay.plusDays(1);

        report.put("totalTransactions", transactionRepository.countByCreatedAtBetween(startOfDay, endOfDay));
        report.put("totalAmount", transactionRepository.sumAmountByCreatedAtBetween(startOfDay, endOfDay));
        report.put("pendingPayments", paymentQueueRepository.countByStatus("PENDING"));
        
        return report;
    }

    @Override
    public Map<String, Object> getMonthlyReport() {
        Map<String, Object> report = new HashMap<>();
        LocalDateTime startOfMonth = LocalDate.now().withDayOfMonth(1).atStartOfDay();
        LocalDateTime endOfMonth = startOfMonth.plusMonths(1);

        report.put("totalTransactions", transactionRepository.countByCreatedAtBetween(startOfMonth, endOfMonth));
        report.put("totalAmount", transactionRepository.sumAmountByCreatedAtBetween(startOfMonth, endOfMonth));
        report.put("averageDailyTransactions", transactionRepository.getAverageDailyTransactions(startOfMonth, endOfMonth));
        
        return report;
    }

    @Override
    public boolean verifyReceipt(String receiptNumber) {
        if (receiptNumber == null || receiptNumber.trim().isEmpty()) {
            return false;
        }
        return transactionRepository.existsByReceiptId(receiptNumber);
    }

    @Override
    public SystemSettings getSystemSettings() {
        return systemSettingsRepository.findAll().stream()
                .findFirst()
                .orElse(new SystemSettings());
    }

    @Override
    public void updateSetting(String key, Object value) {
        SystemSettings setting = systemSettingsRepository.findByKey(key)
                .orElse(new SystemSettings());
        setting.setKey(key);
        setting.setValue(value.toString());
        setting.setLastModified(LocalDateTime.now());
        systemSettingsRepository.save(setting);
    }

    @Override
    public Map<String, Object> getAllSettings() {
        return systemSettingsRepository.findAll().stream()
                .collect(Collectors.toMap(
                    SystemSettings::getKey,
                    SystemSettings::getValue
                ));
    }

    @Override
    public SystemSettings updateSystemSettings(SystemSettings settings) {
        settings.setLastModified(LocalDateTime.now());
        return systemSettingsRepository.save(settings);
    }

    @Override
    public void resetSettings() {
        systemSettingsRepository.deleteAll();
        
        // Insert default settings
        SystemSettings[] defaults = {
            createSetting("system.name", "Accounting Management System", "Name of the system"),
            createSetting("system.version", "1.0.0", "Current system version"),
            createSetting("system.maintenance", "false", "System maintenance mode"),
            createSetting("system.timezone", "UTC", "System timezone"),
            createSetting("system.currency", "USD", "Default system currency"),
            createSetting("system.queue.max_wait_time", "30", "Maximum wait time in minutes"),
            createSetting("system.notification.enabled", "true", "Enable system notifications"),
            createSetting("system.payment.methods", "CASH,CREDIT_CARD,BANK_TRANSFER", "Available payment methods")
        };
        
        for (SystemSettings setting : defaults) {
            systemSettingsRepository.save(setting);
        }
    }
    
    private SystemSettings createSetting(String key, String value, String description) {
        SystemSettings setting = new SystemSettings();
        setting.setKey(key);
        setting.setValue(value);
        setting.setDescription(description);
        setting.setCreatedAt(LocalDateTime.now());
        setting.setLastModified(LocalDateTime.now());
        return setting;
    }

    @Override
    public Object getSetting(String key) {
        return systemSettingsRepository.findByKey(key)
                .map(SystemSettings::getValue)
                .orElse(null);
    }
} 