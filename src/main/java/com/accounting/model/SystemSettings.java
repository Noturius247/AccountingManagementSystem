package com.accounting.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class SystemSettings {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
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