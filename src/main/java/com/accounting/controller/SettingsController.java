package com.accounting.controller;

import com.accounting.model.SystemSettings;
import com.accounting.service.AdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/settings")
public class SettingsController {

    @Autowired
    private AdminService adminService;

    @GetMapping
    public ResponseEntity<SystemSettings> getSettings() {
        return ResponseEntity.ok(adminService.getSystemSettings());
    }

    @PutMapping
    public ResponseEntity<SystemSettings> updateSettings(@RequestBody SystemSettings settings) {
        return ResponseEntity.ok(adminService.updateSystemSettings(settings));
    }

    @GetMapping("/{key}")
    public ResponseEntity<Object> getSetting(@PathVariable String key) {
        Object value = adminService.getSetting(key);
        return value != null ? ResponseEntity.ok(value) : ResponseEntity.notFound().build();
    }

    @PutMapping("/{key}")
    public ResponseEntity<Void> updateSetting(
            @PathVariable String key,
            @RequestBody Object value) {
        adminService.updateSetting(key, value);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/all")
    public ResponseEntity<Map<String, Object>> getAllSettings() {
        return ResponseEntity.ok(adminService.getAllSettings());
    }

    @PostMapping("/reset")
    public ResponseEntity<Void> resetSettings() {
        adminService.resetSettings();
        return ResponseEntity.ok().build();
    }
} 