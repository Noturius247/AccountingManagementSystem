package com.accounting.servlet;

import com.accounting.model.Notification;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@WebServlet("/notifications")
public class NotificationServlet extends BaseServlet {
    private static final long serialVersionUID = 1L;
    
    // Mock notifications
    private static final List<Notification> notifications = new ArrayList<>();
    
    static {
        // Initialize mock notifications
        Notification n1 = new Notification();
        n1.setId(1L);
        n1.setTitle("System Update");
        n1.setMessage("System will be updated tonight at 10 PM");
        n1.setType("INFO");
        n1.setPriority("LOW");
        notifications.add(n1);
        
        Notification n2 = new Notification();
        n2.setId(2L);
        n2.setTitle("New Transaction");
        n2.setMessage("New payment received: $1000.00");
        n2.setType("SUCCESS");
        n2.setPriority("HIGH");
        notifications.add(n2);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("markRead".equals(action)) {
            Long notificationId = Long.parseLong(request.getParameter("id"));
            markAsRead(notificationId);
            response.sendRedirect(request.getContextPath() + "/notifications");
            return;
        }
        
        request.setAttribute("pageTitle", "Notifications");
        request.setAttribute("notifications", notifications);
        forwardToJsp(request, response, "/jsp/notifications.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("dismiss".equals(action)) {
            Long notificationId = Long.parseLong(request.getParameter("id"));
            dismissNotification(notificationId);
        }
        
        response.sendRedirect(request.getContextPath() + "/notifications");
    }
    
    private void markAsRead(Long notificationId) {
        notifications.stream()
                .filter(n -> n.getId().equals(notificationId))
                .findFirst()
                .ifPresent(n -> n.setRead(true));
    }
    
    private void dismissNotification(Long notificationId) {
        notifications.removeIf(n -> n.getId().equals(notificationId));
    }
} 