<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Queue Number - Accounting Management System</title>
    <link rel="stylesheet" href="../../css/main.css">
    <style>
        .queue-container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        .queue-number {
            font-size: 72px;
            font-weight: bold;
            color: #007bff;
            margin: 20px 0;
        }
        .queue-info {
            margin: 20px 0;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 4px;
        }
        .queue-info p {
            margin: 5px 0;
        }
        .btn-primary {
            padding: 10px 20px;
            background: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        .btn-primary:hover {
            background: #0056b3;
        }
        .estimated-time {
            font-size: 18px;
            color: #666;
            margin: 10px 0;
        }
        .current-queue {
            margin-top: 30px;
            padding: 15px;
            background: #e9ecef;
            border-radius: 4px;
        }
        .current-queue h3 {
            margin-top: 0;
            color: #333;
        }
    </style>
</head>
<body>
    <div class="queue-container">
        <h1>Your Queue Number</h1>
        
        <div class="queue-number">#${queueNumber}</div>
        
        <div class="queue-info">
            <p><strong>Type:</strong> ${queueType}</p>
            <p><strong>Date:</strong> ${queueDate}</p>
            <p><strong>Time:</strong> ${queueTime}</p>
        </div>
        
        <div class="estimated-time">
            Estimated waiting time: ${estimatedTime} minutes
        </div>
        
        <div class="current-queue">
            <h3>Currently Serving</h3>
            <div class="queue-number" style="font-size: 36px;">#${currentQueue}</div>
        </div>
        
        <button class="btn-primary" onclick="window.location.href='${pageContext.request.contextPath}/dashboard'">
            Return to Dashboard
        </button>
    </div>
</body>
</html> 