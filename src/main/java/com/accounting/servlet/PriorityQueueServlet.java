package com.accounting.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.PriorityQueue;

@WebServlet("/priority-queue")
public class PriorityQueueServlet extends BaseServlet {
    private static final long serialVersionUID = 1L;
    
    // Mock priority queue
    private static final PriorityQueue<QueueItem> priorityQueue = new PriorityQueue<>(
        Comparator.comparing(QueueItem::getPriority).reversed()
            .thenComparing(QueueItem::getTimestamp)
    );
    
    static {
        // Initialize mock queue items
        priorityQueue.add(new QueueItem("P001", "HIGH", "Urgent Payment Processing", 5000.0));
        priorityQueue.add(new QueueItem("P002", "MEDIUM", "Invoice Verification", 2500.0));
        priorityQueue.add(new QueueItem("P003", "LOW", "Report Generation", 0.0));
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("next".equals(action)) {
            QueueItem nextItem = priorityQueue.poll();
            request.setAttribute("currentItem", nextItem);
        }
        
        List<QueueItem> queueItems = new ArrayList<>(priorityQueue);
        request.setAttribute("pageTitle", "Priority Queue");
        request.setAttribute("queueItems", queueItems);
        forwardToJsp(request, response, "/jsp/priority-queue.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            String id = "P" + String.format("%03d", priorityQueue.size() + 1);
            String priority = request.getParameter("priority");
            String description = request.getParameter("description");
            Double amount = Double.parseDouble(request.getParameter("amount"));
            
            priorityQueue.add(new QueueItem(id, priority, description, amount));
            request.setAttribute("success", "Item added to queue");
        }
        
        response.sendRedirect(request.getContextPath() + "/priority-queue");
    }
    
    // Inner class for queue items
    private static class QueueItem {
        private String id;
        private String priority;
        private String description;
        private Double amount;
        private LocalDateTime timestamp;
        
        public QueueItem(String id, String priority, String description, Double amount) {
            this.id = id;
            this.priority = priority;
            this.description = description;
            this.amount = amount;
            this.timestamp = LocalDateTime.now();
        }
        
        public String getId() { return id; }
        public String getPriority() { return priority; }
        public String getDescription() { return description; }
        public Double getAmount() { return amount; }
        public LocalDateTime getTimestamp() { return timestamp; }
    }
} 