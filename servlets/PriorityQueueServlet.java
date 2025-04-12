package com.accounting.servlet;

import com.accounting.model.Queue;
import com.accounting.model.enums.Priority;
import com.accounting.model.enums.QueueStatus;
import com.accounting.service.QueueService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/priority-queue")
@Component
public class PriorityQueueServlet extends BaseServlet {
    private static final long serialVersionUID = 1L;
    
    @Autowired
    private QueueService queueService;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("next".equals(action)) {
            Queue nextItem = queueService.getNextQueue();
            if (nextItem != null) {
                request.setAttribute("currentItem", nextItem);
            }
        }
        
        // Get queues by priority
        List<Queue> highPriorityQueues = queueService.getQueuesByPriority(Priority.HIGH.toString());
        List<Queue> mediumPriorityQueues = queueService.getQueuesByPriority(Priority.MEDIUM.toString());
        List<Queue> lowPriorityQueues = queueService.getQueuesByPriority(Priority.LOW.toString());
        
        // Get queue statistics
        Map<String, Long> priorityCounts = queueService.getQueueCountByPriority();
        double avgWaitTimeHigh = queueService.getAverageWaitTimeByPriority(Priority.HIGH.toString());
        double avgWaitTimeMedium = queueService.getAverageWaitTimeByPriority(Priority.MEDIUM.toString());
        double avgWaitTimeLow = queueService.getAverageWaitTimeByPriority(Priority.LOW.toString());
        
        request.setAttribute("highPriorityQueues", highPriorityQueues);
        request.setAttribute("mediumPriorityQueues", mediumPriorityQueues);
        request.setAttribute("lowPriorityQueues", lowPriorityQueues);
        request.setAttribute("priorityCounts", priorityCounts);
        request.setAttribute("avgWaitTimeHigh", avgWaitTimeHigh);
        request.setAttribute("avgWaitTimeMedium", avgWaitTimeMedium);
        request.setAttribute("avgWaitTimeLow", avgWaitTimeLow);
        
        request.setAttribute("pageTitle", "Priority Queue Management");
        forwardToJsp(request, response, "/jsp/priority-queue.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            String queueNumber = request.getParameter("queueNumber");
            String priority = request.getParameter("priority");
            String description = request.getParameter("description");
            
            Queue queue = new Queue();
            queue.setQueueNumber(queueNumber);
            queue.setPriority(Priority.valueOf(priority));
            queue.setDescription(description);
            queue.setStatus(QueueStatus.WAITING);
            queue.setCreatedAt(LocalDateTime.now());
            
            queueService.addToQueue(queue);
            request.setAttribute("success", "Item added to priority queue");
        } else if ("update".equals(action)) {
            String queueNumber = request.getParameter("queueNumber");
            String newPriority = request.getParameter("priority");
            
            Queue queue = queueService.getQueueByQueueNumber(queueNumber);
            if (queue != null) {
                queue.setPriority(Priority.valueOf(newPriority));
                queueService.updateQueue(queue);
                request.setAttribute("success", "Priority updated successfully");
            } else {
                request.setAttribute("error", "Queue not found");
            }
        } else if ("remove".equals(action)) {
            String queueNumber = request.getParameter("queueNumber");
            queueService.removeFromQueue(queueNumber);
            request.setAttribute("success", "Item removed from queue");
        }
        
        response.sendRedirect(request.getContextPath() + "/priority-queue");
    }
}
