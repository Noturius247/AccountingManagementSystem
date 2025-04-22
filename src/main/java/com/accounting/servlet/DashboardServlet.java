package com.accounting.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.accounting.model.Transaction;
import com.accounting.model.Notification;
import com.accounting.service.TransactionService;
import com.accounting.service.NotificationService;
import com.accounting.service.PaymentService;
import com.accounting.service.DocumentService;
import com.fasterxml.jackson.databind.ObjectMapper;

@Component
@WebServlet("/accounting/user/dashboard")
public class DashboardServlet extends BaseServlet {
    private static final long serialVersionUID = 1L;
    
    @Autowired
    private TransactionService transactionService;
    
    @Autowired
    private NotificationService notificationService;
    
    @Autowired
    private PaymentService paymentService;
    
    @Autowired
    private DocumentService documentService;
    
    private static final Logger logger = LoggerFactory.getLogger(DashboardServlet.class);
    
    @Override
    public void init() throws ServletException {
        super.init();
        SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processRequest(request, response);
        
        try {
            // Get dashboard statistics
            Map<String, Object> stats = new HashMap<>();
            stats.put("totalTransactions", transactionService.getTodayTransactionCount());
            stats.put("totalPayments", paymentService.getPendingPaymentsCount());
            stats.put("totalDocuments", documentService.getTotalDocumentsCount());
            stats.put("activeQueues", transactionService.getActiveQueueCount());
            
            // Set response type to JSON
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            // Convert stats to JSON and write to response
            ObjectMapper mapper = new ObjectMapper();
            String json = mapper.writeValueAsString(stats);
            
            if (json == null || json.isEmpty()) {
                throw new RuntimeException("Empty response generated");
            }
            
            response.getWriter().write(json);
            
        } catch (Exception e) {
            logger.error("Error processing dashboard request", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            Map<String, String> error = new HashMap<>();
            error.put("error", "Failed to load dashboard data");
            error.put("errorDetails", e.getMessage());
            new ObjectMapper().writeValue(response.getWriter(), error);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
} 