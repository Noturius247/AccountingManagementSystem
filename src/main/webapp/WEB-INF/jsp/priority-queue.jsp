<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .priority-queue {
            padding: 20px;
        }
        
        .queue-stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .stat-card h3 {
            margin: 0 0 10px 0;
            color: #333;
        }
        
        .stat-card .count {
            font-size: 24px;
            font-weight: bold;
            color: #2196F3;
        }
        
        .stat-card .wait-time {
            font-size: 14px;
            color: #666;
            margin-top: 5px;
        }
        
        .queue-sections {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }
        
        .queue-section {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .queue-section h2 {
            margin: 0 0 15px 0;
            padding-bottom: 10px;
            border-bottom: 2px solid #eee;
        }
        
        .queue-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .queue-item {
            padding: 10px;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .queue-item:last-child {
            border-bottom: none;
        }
        
        .queue-item .number {
            font-weight: bold;
            color: #2196F3;
        }
        
        .queue-item .description {
            color: #666;
            font-size: 14px;
        }
        
        .queue-item .actions {
            display: flex;
            gap: 5px;
        }
        
        .btn {
            padding: 5px 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
        }
        
        .btn-primary {
            background: #2196F3;
            color: white;
        }
        
        .btn-danger {
            background: #f44336;
            color: white;
        }
        
        .btn-warning {
            background: #ff9800;
            color: white;
        }
        
        .current-item {
            background: #e3f2fd;
            border-left: 4px solid #2196F3;
        }
        
        .priority-high {
            border-left: 4px solid #f44336;
        }
        
        .priority-medium {
            border-left: 4px solid #ff9800;
        }
        
        .priority-low {
            border-left: 4px solid #4CAF50;
        }
    </style>
</head>
<body>
    <div class="priority-queue">
        <h1>${pageTitle}</h1>
        
        <div class="queue-stats">
            <div class="stat-card">
                <h3>High Priority</h3>
                <div class="count">${priorityCounts.HIGH}</div>
                <div class="wait-time">Avg. Wait: <fmt:formatNumber value="${avgWaitTimeHigh}" pattern="0.0"/> min</div>
            </div>
            <div class="stat-card">
                <h3>Medium Priority</h3>
                <div class="count">${priorityCounts.MEDIUM}</div>
                <div class="wait-time">Avg. Wait: <fmt:formatNumber value="${avgWaitTimeMedium}" pattern="0.0"/> min</div>
            </div>
            <div class="stat-card">
                <h3>Low Priority</h3>
                <div class="count">${priorityCounts.LOW}</div>
                <div class="wait-time">Avg. Wait: <fmt:formatNumber value="${avgWaitTimeLow}" pattern="0.0"/> min</div>
            </div>
        </div>
        
        <div class="queue-sections">
            <div class="queue-section">
                <h2>High Priority</h2>
                <ul class="queue-list">
                    <c:forEach items="${highPriorityQueues}" var="queue">
                        <li class="queue-item priority-high ${queue.queueNumber == currentItem.queueNumber ? 'current-item' : ''}">
                            <div>
                                <div class="number">${queue.queueNumber}</div>
                                <div class="description">${queue.description}</div>
                            </div>
                            <div class="actions">
                                <button class="btn btn-warning" onclick="updatePriority('${queue.queueNumber}', 'MEDIUM')">↓</button>
                                <button class="btn btn-danger" onclick="removeFromQueue('${queue.queueNumber}')">×</button>
                            </div>
                        </li>
                    </c:forEach>
                </ul>
            </div>
            
            <div class="queue-section">
                <h2>Medium Priority</h2>
                <ul class="queue-list">
                    <c:forEach items="${mediumPriorityQueues}" var="queue">
                        <li class="queue-item priority-medium ${queue.queueNumber == currentItem.queueNumber ? 'current-item' : ''}">
                            <div>
                                <div class="number">${queue.queueNumber}</div>
                                <div class="description">${queue.description}</div>
                            </div>
                            <div class="actions">
                                <button class="btn btn-primary" onclick="updatePriority('${queue.queueNumber}', 'HIGH')">↑</button>
                                <button class="btn btn-warning" onclick="updatePriority('${queue.queueNumber}', 'LOW')">↓</button>
                                <button class="btn btn-danger" onclick="removeFromQueue('${queue.queueNumber}')">×</button>
                            </div>
                        </li>
                    </c:forEach>
                </ul>
            </div>
            
            <div class="queue-section">
                <h2>Low Priority</h2>
                <ul class="queue-list">
                    <c:forEach items="${lowPriorityQueues}" var="queue">
                        <li class="queue-item priority-low ${queue.queueNumber == currentItem.queueNumber ? 'current-item' : ''}">
                            <div>
                                <div class="number">${queue.queueNumber}</div>
                                <div class="description">${queue.description}</div>
                            </div>
                            <div class="actions">
                                <button class="btn btn-warning" onclick="updatePriority('${queue.queueNumber}', 'MEDIUM')">↑</button>
                                <button class="btn btn-danger" onclick="removeFromQueue('${queue.queueNumber}')">×</button>
                            </div>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </div>
    </div>
    
    <script>
        function updatePriority(queueNumber, newPriority) {
            fetch('${pageContext.request.contextPath}/priority-queue', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `action=update&queueNumber=${queueNumber}&priority=${newPriority}`
            })
            .then(response => {
                if (response.ok) {
                    location.reload();
                } else {
                    alert('Failed to update priority');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('An error occurred while updating priority');
            });
        }
        
        function removeFromQueue(queueNumber) {
            if (confirm('Are you sure you want to remove this item from the queue?')) {
                fetch('${pageContext.request.contextPath}/priority-queue', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: `action=remove&queueNumber=${queueNumber}`
                })
                .then(response => {
                    if (response.ok) {
                        location.reload();
                    } else {
                        alert('Failed to remove item');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('An error occurred while removing the item');
                });
            }
        }
        
        // Auto-refresh every 30 seconds
        setInterval(() => {
            location.reload();
        }, 30000);
    </script>
</body>
</html> 