package com.accounting.service;

import com.accounting.model.SystemSettings;
import java.util.List;
import java.util.Map;

public interface SystemSettingsService {
    SystemSettings getSetting(String key);
    SystemSettings updateSetting(String key, String value);
    List<SystemSettings> getAllSettings();
    Map<String, String> getSettingsMap();
    void deleteSetting(String key);
    void updateSettings(Map<String, String> settings);
} 