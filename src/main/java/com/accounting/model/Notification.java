package com.accounting.model;

import java.util.Date;
import lombok.Data;

@Data
public class Notification {
    private Long id;
    private String title;
    private String message;
    private String type;
    private Date time;
    private boolean read;
    private Long userId;
    private String priority;
    private String category;
    private String actionUrl;
    private String icon;
    private String source;
    private String sourceId;
    private Date expiryDate;
    private boolean isDismissible;
    private String backgroundColor;
    
    public Notification() {
        this.time = new Date();
        this.read = false;
        this.isDismissible = true;
    }
    
    public void setType(String type) {
        this.type = type;
        updateStyle();
    }
    
    public void setPriority(String priority) {
        this.priority = priority;
        updateStyle();
    }
    
    private void updateStyle() {
        // Set type-based styles
        if (type != null) {
            switch (type.toLowerCase()) {
                case "success":
                    this.backgroundColor = "#d4edda";
                    this.icon = "fas fa-check-circle";
                    break;
                case "warning":
                    this.backgroundColor = "#fff3cd";
                    this.icon = "fas fa-exclamation-triangle";
                    break;
                case "error":
                    this.backgroundColor = "#f8d7da";
                    this.icon = "fas fa-times-circle";
                    break;
                case "info":
                    this.backgroundColor = "#d1ecf1";
                    this.icon = "fas fa-info-circle";
                    break;
                default:
                    this.backgroundColor = "#e9ecef";
                    this.icon = "fas fa-bell";
            }
        }
        
        // Override background color based on priority
        if (priority != null) {
            switch (priority.toLowerCase()) {
                case "high":
                    this.backgroundColor = "#ffebee";
                    break;
                case "medium":
                    this.backgroundColor = "#fff3e0";
                    break;
                case "low":
                    this.backgroundColor = "#e8f5e9";
                    break;
            }
        }
    }
    
    public boolean isExpired() {
        if (expiryDate != null) {
            return new Date().after(expiryDate);
        }
        return false;
    }
    
    public String getFormattedTime() {
        if (time == null) return "";
        
        long diffInMillis = new Date().getTime() - time.getTime();
        long diffInMinutes = diffInMillis / (60 * 1000);
        
        if (diffInMinutes < 1) {
            return "Just now";
        } else if (diffInMinutes < 60) {
            return diffInMinutes + " minutes ago";
        } else if (diffInMinutes < 1440) {
            return (diffInMinutes / 60) + " hours ago";
        } else {
            return (diffInMinutes / 1440) + " days ago";
        }
    }
    
    public String getNotificationStyle() {
        return String.format("background-color: %s;", backgroundColor);
    }
} 