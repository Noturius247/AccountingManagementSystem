package com.accounting.service.impl;

import com.accounting.service.EmailService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailServiceImpl implements EmailService {

    private final JavaMailSender mailSender;
    private final String fromEmail;

    public EmailServiceImpl(JavaMailSender mailSender, @Value("${spring.mail.username}") String fromEmail) {
        this.mailSender = mailSender;
        this.fromEmail = fromEmail;
    }

    @Override
    public void sendRegistrationPendingEmail(String to, String studentName, String studentId) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom(fromEmail);
        message.setTo(to);
        message.setSubject("Student Registration Pending");
        message.setText(String.format(
            "Dear %s,\n\n" +
            "Your student registration (ID: %s) has been received and is pending admin approval.\n\n" +
            "We will notify you once your registration has been processed.\n\n" +
            "Best regards,\n" +
            "Accounting Management System",
            studentName, studentId
        ));
        mailSender.send(message);
    }

    @Override
    public void sendRegistrationApprovedEmail(String to, String studentName, String studentId) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom(fromEmail);
        message.setTo(to);
        message.setSubject("Student Registration Approved");
        message.setText(String.format(
            "Dear %s,\n\n" +
            "Your student registration (ID: %s) has been approved.\n\n" +
            "You can now access all student services through your dashboard.\n\n" +
            "Best regards,\n" +
            "Accounting Management System",
            studentName, studentId
        ));
        mailSender.send(message);
    }

    @Override
    public void sendRegistrationRejectedEmail(String to, String studentName, String studentId, String reason) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom(fromEmail);
        message.setTo(to);
        message.setSubject("Student Registration Rejected");
        message.setText(String.format(
            "Dear %s,\n\n" +
            "Your student registration (ID: %s) has been rejected.\n\n" +
            "Reason: %s\n\n" +
            "Please contact the administration if you have any questions.\n\n" +
            "Best regards,\n" +
            "Accounting Management System",
            studentName, studentId, reason
        ));
        mailSender.send(message);
    }
} 