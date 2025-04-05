package com.accounting.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/receipt-check")
public class ReceiptCheckServlet extends BaseServlet {
    private static final long serialVersionUID = 1L;
    
    // Mock receipt data
    private static final Map<String, Receipt> receiptDatabase = new HashMap<>();
    
    static {
        // Initialize mock receipts
        Receipt r1 = new Receipt("RCP001", 1000.00, "COMPLETED", LocalDateTime.now().minusDays(1));
        r1.setPaymentMethod("CREDIT_CARD");
        r1.setDescription("Monthly Service Payment");
        receiptDatabase.put(r1.getReceiptNumber(), r1);
        
        Receipt r2 = new Receipt("RCP002", 500.00, "COMPLETED", LocalDateTime.now().minusHours(5));
        r2.setPaymentMethod("CASH");
        r2.setDescription("Consultation Fee");
        receiptDatabase.put(r2.getReceiptNumber(), r2);
        
        Receipt r3 = new Receipt("RCP003", 750.00, "PENDING", LocalDateTime.now());
        r3.setPaymentMethod("BANK_TRANSFER");
        r3.setDescription("Software License");
        receiptDatabase.put(r3.getReceiptNumber(), r3);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String receiptNumber = request.getParameter("receipt");
        
        if (receiptNumber != null && !receiptNumber.trim().isEmpty()) {
            Receipt receipt = receiptDatabase.get(receiptNumber);
            request.setAttribute("receipt", receipt);
            request.setAttribute("found", receipt != null);
        }
        
        request.setAttribute("pageTitle", "Receipt Verification");
        forwardToJsp(request, response, "/jsp/receipt-check.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("verify".equals(action)) {
            String receiptNumber = request.getParameter("receipt");
            Receipt receipt = receiptDatabase.get(receiptNumber);
            
            if (receipt != null) {
                receipt.setVerified(true);
                receipt.setVerificationTime(LocalDateTime.now());
                request.setAttribute("success", "Receipt verified successfully");
            } else {
                request.setAttribute("error", "Receipt not found");
            }
        }
        
        doGet(request, response);
    }
    
    // Inner class for receipts
    private static class Receipt {
        private String receiptNumber;
        private double amount;
        private String status;
        private LocalDateTime timestamp;
        private String paymentMethod;
        private String description;
        private boolean verified;
        private LocalDateTime verificationTime;
        
        public Receipt(String receiptNumber, double amount, String status, LocalDateTime timestamp) {
            this.receiptNumber = receiptNumber;
            this.amount = amount;
            this.status = status;
            this.timestamp = timestamp;
            this.verified = false;
        }
        
        public String getReceiptNumber() { return receiptNumber; }
        public double getAmount() { return amount; }
        public String getStatus() { return status; }
        public LocalDateTime getTimestamp() { return timestamp; }
        public String getPaymentMethod() { return paymentMethod; }
        public String getDescription() { return description; }
        public boolean isVerified() { return verified; }
        public LocalDateTime getVerificationTime() { return verificationTime; }
        
        public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
        public void setDescription(String description) { this.description = description; }
        public void setVerified(boolean verified) { this.verified = verified; }
        public void setVerificationTime(LocalDateTime time) { this.verificationTime = time; }
    }
} 