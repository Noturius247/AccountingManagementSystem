package com.accounting.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import com.accounting.model.Transaction;
import com.accounting.model.Notification;
import com.accounting.service.TransactionService;
import com.accounting.service.NotificationService;

@WebServlet("/dashboard")
public class DashboardServlet extends BaseServlet {
    private static final long serialVersionUID = 1L;
    
    @Autowired
    private TransactionService transactionService;
    
    @Autowired
    private NotificationService notificationService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processRequest(request, response);
        
        // Set page title
        request.setAttribute("pageTitle", "Dashboard");
        
        
        request.setAttribute("activeQueueCount", transactionService.getActiveQueueCount());
        request.setAttribute("lastUpdateTime", new Date());
        request.setAttribute("todayTransactions", transactionService.getTodayTransactionCount());
        request.setAttribute("todayTotal", transactionService.getTodayTotalAmount());
        request.setAttribute("pendingApprovals", transactionService.getPendingApprovalCount());
        request.setAttribute("highPriorityCount", transactionService.getHighPriorityCount());
        request.setAttribute("activeUsers", transactionService.getActiveUserCount());
        request.setAttribute("onlineUsers", transactionService.getOnlineUserCount());
        
        // Get recent transactions
        List<Transaction> recentTransactions = transactionService.getRecentTransactions(10);
        request.setAttribute("recentTransactions", recentTransactions);
        
        // Get system notifications
        List<Notification> notifications = notificationService.getSystemNotifications();
        request.setAttribute("notifications", notifications);
        
        // Forward to dashboard JSP
        forwardToJsp(request, response, "/jsp/dashboard.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
} 