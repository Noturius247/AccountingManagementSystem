<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Accounting Management System</title>
    <link rel="stylesheet" href="../css/main.css">
    <style>
        .dashboard-container {
            padding: 20px;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .stat-card h3 {
            margin-top: 0;
            color: #666;
        }
        .stat-card .value {
            font-size: 24px;
            font-weight: bold;
            color: #007bff;
        }
        .recent-activity {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .activity-list {
            list-style: none;
            padding: 0;
        }
        .activity-item {
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        .activity-item:last-child {
            border-bottom: none;
        }
    </style>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="dashboard-container">
        <h1>Dashboard</h1>
        
        <div class="stats-grid">
            <div class="stat-card">
                <h3>Total Transactions</h3>
                <div class="value">${totalTransactions}</div>
            </div>
            <div class="stat-card">
                <h3>Pending Payments</h3>
                <div class="value">${pendingPayments}</div>
            </div>
            <div class="stat-card">
                <h3>Active Users</h3>
                <div class="value">${activeUsers}</div>
            </div>
        </div>

        <div class="recent-activity">
            <h2>Recent Activity</h2>
            <ul class="activity-list">
                <c:forEach items="${recentActivities}" var="activity">
                    <li class="activity-item">
                        ${activity.description} - ${activity.createdAt}
                    </li>
                </c:forEach>
            </ul>
        </div>
    </div>

    <%@ include file="includes/footer.jsp" %>
</body>
</html> 