<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Queue Status - Accounting Management System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/static/css/main.css" rel="stylesheet">
    <style>
        .queue-container {
            max-width: 600px;
            margin: 50px auto;
            padding: var(--spacing-lg);
            background: white;
            border-radius: var(--border-radius-md);
            box-shadow: var(--shadow-md);
            text-align: center;
            border: 1px solid var(--border-color);
        }

        .queue-header {
            margin-bottom: var(--spacing-lg);
        }

        .queue-header h1 {
            color: var(--primary-color);
            font-size: 2em;
            margin-bottom: var(--spacing-sm);
        }

        .your-number {
            font-size: 72px;
            font-weight: bold;
            color: var(--primary-color);
            margin: var(--spacing-lg) 0;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.1);
            transition: var(--transition-base);
        }

        .queue-info {
            margin: var(--spacing-md) 0;
            padding: var(--spacing-md);
            background: var(--light-color);
            border-radius: var(--border-radius-sm);
            border-left: 4px solid var(--primary-color);
        }

        .queue-info p {
            margin: var(--spacing-xs) 0;
            color: var(--dark-color);
        }

        .estimated-time {
            font-size: 1.2em;
            color: var(--dark-color);
            margin: var(--spacing-md) 0;
            padding: var(--spacing-sm);
            background: var(--light-color);
            border-radius: var(--border-radius-sm);
        }

        .current-serving {
            margin-top: var(--spacing-lg);
            padding: var(--spacing-md);
            background: var(--light-color);
            border-radius: var(--border-radius-sm);
            border: 1px solid var(--border-color);
        }

        .current-serving h3 {
            color: var(--primary-color);
            margin-bottom: var(--spacing-md);
        }

        .current-number {
            font-size: 48px;
            font-weight: bold;
            color: var(--secondary-color);
            margin: var(--spacing-md) 0;
            transition: var(--transition-base);
        }

        .status-indicator {
            display: inline-block;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            margin-right: var(--spacing-sm);
        }

        .status-active {
            background-color: var(--success-color);
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); opacity: 1; }
            50% { transform: scale(1.2); opacity: 0.8; }
            100% { transform: scale(1); opacity: 1; }
        }

        .queue-actions {
            margin-top: var(--spacing-lg);
        }

        .update-status {
            font-size: 0.9em;
            color: var(--medium-gray);
            margin-top: var(--spacing-sm);
        }

        .progress-bar-container {
            width: 100%;
            height: 6px;
            background: var(--light-color);
            border-radius: var(--border-radius-sm);
            margin: var(--spacing-md) 0;
            overflow: hidden;
        }

        .progress-bar {
            height: 100%;
            background: var(--primary-color);
            width: 0%;
            transition: width 0.5s ease;
        }
    </style>
</head>
<body>
    <div class="queue-container">
        <div class="queue-header">
            <h1>Queue Status</h1>
            <div class="status-indicator status-active"></div>
            <span>Live Updates Active</span>
        </div>
        
        <div class="your-number" id="yourNumber">#${queueNumber}</div>
        
        <div class="progress-bar-container">
            <div class="progress-bar" id="progressBar"></div>
        </div>
        
        <div class="queue-info">
            <p><i class="bi bi-info-circle"></i> <strong>Service:</strong> ${queueType}</p>
            <p><i class="bi bi-calendar"></i> <strong>Date:</strong> ${queueDate}</p>
            <p><i class="bi bi-clock"></i> <strong>Time:</strong> ${queueTime}</p>
        </div>
        
        <div class="estimated-time">
            <i class="bi bi-hourglass-split"></i>
            Estimated waiting time: <span id="estimatedTime">${estimatedTime}</span> minutes
        </div>
        
        <div class="current-serving">
            <h3><i class="bi bi-bell"></i> Now Serving</h3>
            <div class="current-number" id="currentNumber">#${currentQueue}</div>
            <p>People ahead of you: <span id="peopleAhead">0</span></p>
        </div>
        
        <div class="queue-actions">
            <button class="btn btn-primary" onclick="window.location.href='${pageContext.request.contextPath}/kiosk'">
                <i class="bi bi-house"></i> Return to Kiosk
            </button>
        </div>
        
        <p class="update-status">Last updated: <span id="lastUpdate">Just now</span></p>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        let lastCurrentNumber = '<c:out value="${currentQueue}"/>';
        
        // Function to update queue status
        async function updateQueueStatus() {
            try {
                const response = await fetch('<c:url value="/kiosk/queue/status/"/>' + '<c:out value="${queueNumber}"/>');
                const data = await response.json();
                
                // Update current number with animation if changed
                if (data.currentNumber !== lastCurrentNumber) {
                    animateNumberChange('currentNumber', lastCurrentNumber, data.currentNumber);
                    lastCurrentNumber = data.currentNumber;
                }
                
                // Update other information
                document.getElementById('estimatedTime').textContent = data.estimatedTime;
                document.getElementById('peopleAhead').textContent = data.peopleAhead;
                
                // Update progress bar
                updateProgressBar(data.progress);
                
                // Update last update time
                document.getElementById('lastUpdate').textContent = new Date().toLocaleTimeString();
                
                // Check if it's your turn
                if (data.currentNumber === '<c:out value="${queueNumber}"/>') {
                    notifyUser();
                }
                
            } catch (error) {
                console.error('Error updating queue status:', error);
            }
        }
        
        // Function to animate number changes
        function animateNumberChange(elementId, oldValue, newValue) {
            const element = document.getElementById(elementId);
            element.style.transform = 'scale(1.1)';
            element.style.color = 'var(--secondary-color)';
            
            setTimeout(() => {
                element.textContent = '#' + newValue;
                element.style.transform = 'scale(1)';
                element.style.color = '';
            }, 300);
        }
        
        // Function to update progress bar
        function updateProgressBar(progress) {
            const progressBar = document.getElementById('progressBar');
            progressBar.style.width = progress + '%';
        }
        
        // Function to notify user when it's their turn
        function notifyUser() {
            // Check if notifications are supported and permitted
            if ("Notification" in window && Notification.permission === "granted") {
                new Notification("It's Your Turn!", {
                    body: "Please proceed to the counter.",
                    icon: "${pageContext.request.contextPath}/static/images/logo.png"
                });
            }
            
            // Visual notification
            document.querySelector('.queue-container').style.animation = 'highlight 2s infinite';
        }
        
        // Request notification permission on page load
        document.addEventListener('DOMContentLoaded', function() {
            if ("Notification" in window && Notification.permission !== "granted") {
                Notification.requestPermission();
            }
        });
        
        // Start periodic updates
        updateQueueStatus(); // Initial update
        setInterval(updateQueueStatus, 5000); // Update every 5 seconds
    </script>
</body>
</html> 