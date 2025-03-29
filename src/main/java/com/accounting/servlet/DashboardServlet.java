package com.accounting.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.accounting.model.Transaction;
import com.accounting.model.Notification;
import com.accounting.service.TransactionService;
import com.accounting.service.NotificationService;

@WebServlet("/dashboard")
public class DashboardServlet extends BaseServlet {
    private static final long serialVersionUID = 1L;
    
    private TransactionService transactionService;
    private NotificationService notificationService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        transactionService = new TransactionService();
        notificationService = new NotificationService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processRequest(request, response);
        
        // Set page title
        request.setAttribute("pageTitle", "Dashboard");
        
        // Set dashboard statistics
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
        List<Notification> notifications = notificationService.getRecentNotifications(5);
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