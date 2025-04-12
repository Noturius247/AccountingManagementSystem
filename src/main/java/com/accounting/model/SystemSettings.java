package com.accounting.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.time.LocalDateTime;
import jakarta.persistence.Column;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class SystemSettings {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "setting_key", nullable = false, unique = true)
    private String key;
    
    @Column(name = "setting_value", nullable = false)
    private String value;
    
    @Column
    private String description;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime lastModified;
    
    private String companyName;
    private String companyAddress;
    private String contactEmail;
    private String contactPhone;
    
    private boolean enableEmailNotifications;
    private boolean enableSMSNotifications;
    
    private int maxQueueSize;
    private int sessionTimeoutMinutes;
    
    private String currencyCode;
    private String dateFormat;
    private String timeZone;
} 