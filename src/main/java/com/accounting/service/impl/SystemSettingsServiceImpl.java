package com.accounting.service.impl;

import com.accounting.model.SystemSettings;
import com.accounting.repository.SystemSettingsRepository;
import com.accounting.service.SystemSettingsService;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Properties;

@Service
public class SystemSettingsServiceImpl implements SystemSettingsService {

    @Autowired
    private SystemSettingsRepository systemSettingsRepository;

    @Override
    @Transactional(readOnly = true)
    public SystemSettings getSetting(String key) {
        return systemSettingsRepository.findByKey(key)
                .orElseThrow(() -> new RuntimeException("Setting not found"));
    }

    @Override
    @Transactional
    public SystemSettings updateSetting(String key, String value) {
        SystemSettings setting = systemSettingsRepository.findByKey(key)
                .orElse(new SystemSettings());
        setting.setKey(key);
        setting.setValue(value);
        setting.setLastModified(LocalDateTime.now());
        return systemSettingsRepository.save(setting);
    }

    @Override
    @Transactional(readOnly = true)
    public List<SystemSettings> getAllSettings() {
        return systemSettingsRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, String> getSettingsMap() {
        return systemSettingsRepository.findAll().stream()
                .collect(Collectors.toMap(
                        SystemSettings::getKey,
                        SystemSettings::getValue
                ));
    }

    @Override
    @Transactional
    public void deleteSetting(String key) {
        systemSettingsRepository.deleteByKey(key);
    }

    @Override
    @Transactional
    public void updateSettings(Map<String, String> settings) {
        settings.forEach(this::updateSetting);
    }
} 