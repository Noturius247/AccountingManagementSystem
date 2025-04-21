package com.accounting.service;

public interface EmailService {
    void sendRegistrationPendingEmail(String to, String studentName, String studentId);
    void sendRegistrationApprovedEmail(String to, String studentName, String studentId);
    void sendRegistrationRejectedEmail(String to, String studentName, String studentId, String reason);
    void sendEmail(String to, String subject, String content);
    void sendReceipt(String emailAddress, String receiptContent);
} 