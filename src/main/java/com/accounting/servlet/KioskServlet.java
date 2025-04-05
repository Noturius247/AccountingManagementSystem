package com.accounting.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.LinkedList;
import java.util.Queue;

@WebServlet("/kiosk")
public class KioskServlet extends BaseServlet {
    private static final long serialVersionUID = 1L;
    
    // Mock kiosk data
    private static final Queue<KioskTicket> ticketQueue = new LinkedList<>();
    private static int currentNumber = 0;
    private static int servedNumber = 0;
    
    static {
        // Initialize mock tickets
        generateTicket("PAYMENT");
        generateTicket("INQUIRY");
        generateTicket("PAYMENT");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("status".equals(action)) {
            request.setAttribute("currentNumber", servedNumber);
            request.setAttribute("nextNumber", currentNumber);
            request.setAttribute("queueSize", ticketQueue.size());
            forwardToJsp(request, response, "/jsp/kiosk-display.jsp");
            return;
        }
        
        request.setAttribute("pageTitle", "Kiosk System");
        forwardToJsp(request, response, "/jsp/kiosk.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("generate".equals(action)) {
            String type = request.getParameter("type");
            KioskTicket ticket = generateTicket(type);
            request.setAttribute("ticket", ticket);
            forwardToJsp(request, response, "/jsp/ticket-print.jsp");
            return;
        }
        
        if ("next".equals(action)) {
            if (!ticketQueue.isEmpty()) {
                KioskTicket next = ticketQueue.poll();
                servedNumber = next.getNumber();
                request.setAttribute("currentTicket", next);
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/kiosk");
    }
    
    private static KioskTicket generateTicket(String type) {
        currentNumber++;
        KioskTicket ticket = new KioskTicket(currentNumber, type);
        ticketQueue.add(ticket);
        return ticket;
    }
    
    // Inner class for kiosk tickets
    private static class KioskTicket {
        private int number;
        private String type;
        private LocalDateTime timestamp;
        private int estimatedWaitTime;
        
        public KioskTicket(int number, String type) {
            this.number = number;
            this.type = type;
            this.timestamp = LocalDateTime.now();
            this.estimatedWaitTime = calculateEstimatedWaitTime();
        }
        
        public int getNumber() { return number; }
        public String getType() { return type; }
        public LocalDateTime getTimestamp() { return timestamp; }
        public int getEstimatedWaitTime() { return estimatedWaitTime; }
        
        private int calculateEstimatedWaitTime() {
            // Mock calculation: 5 minutes per person in queue
            return ticketQueue.size() * 5;
        }
    }
} 