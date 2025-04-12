<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Queue Status - Kiosk System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
</head>
<body>
    <div class="queue-status-container">
        <h1>Queue Status</h1>
        <div class="status-info">
            <h2>Your Queue Number</h2>
            <div class="queue-number">${queueInfo.queueNumber}</div>
            <div class="queue-details">
                <p>Position: ${queueInfo.position}</p>
                <p>Estimated Wait Time: ${estimatedWaitTime} minutes</p>
                <p>Status: ${queueInfo.status}</p>
            </div>
        </div>
        <div class="actions">
            <a href="${pageContext.request.contextPath}/kiosk" class="btn btn-primary">Back to Kiosk</a>
            <button onclick="printTicket()" class="btn btn-secondary">Print Ticket</button>
        </div>
    </div>
    <script>
        function printTicket() {
            window.print();
        }
    </script>
</body>
</html> 