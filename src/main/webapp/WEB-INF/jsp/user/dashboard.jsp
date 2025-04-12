<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Dashboard - Accounting Management System</title>
    <link rel="stylesheet" href="../../css/main.css">
    <style>
        .user-dashboard {
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
        .user-section {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .user-section h2 {
            margin-top: 0;
            color: #333;
        }
        .table {
            width: 100%;
            border-collapse: collapse;
        }
        .table th, .table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        .table th {
            background-color: #f8f9fa;
            font-weight: bold;
        }
        .btn-action {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 5px;
        }
        .btn-pay {
            background: #28a745;
            color: white;
        }
        .btn-view {
            background: #17a2b8;
            color: white;
        }
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        .action-card {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            text-align: center;
            cursor: pointer;
            transition: transform 0.2s;
        }
        .action-card:hover {
            transform: translateY(-5px);
        }
        .action-card h3 {
            margin-top: 0;
            color: #333;
        }
        .action-card i {
            font-size: 24px;
            color: #007bff;
            margin-bottom: 10px;
        }
        .status-pending {
            color: #ffc107;
        }
        .status-completed {
            color: #28a745;
        }
        .status-failed {
            color: #dc3545;
        }
    </style>
</head>
<body>
    <%@ include file="../includes/header.jsp" %>
    
    <div class="user-dashboard">
        <h1>Welcome, ${user.username}!</h1>
        
        <div class="stats-grid">
            <div class="stat-card">
                <h3>Pending Payments</h3>
                <div class="value">${pendingPayments}</div>
            </div>
            <div class="stat-card">
                <h3>Total Paid</h3>
                <div class="value">$${totalPaid}</div>
            </div>
            <div class="stat-card">
                <h3>Queue Position</h3>
                <div class="value">#${queuePosition}</div>
            </div>
        </div>

        <div class="user-section">
            <h2>Recent Payments</h2>
            <table class="table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Amount</th>
                        <th>Type</th>
                        <th>Status</th>
                        <th>Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${recentPayments}" var="payment">
                        <tr>
                            <td>${payment.id}</td>
                            <td>$${payment.amount}</td>
                            <td>${payment.type}</td>
                            <td class="status-${payment.status.toLowerCase()}">${payment.status}</td>
                            <td>${payment.createdAt}</td>
                            <td>
                                <c:if test="${payment.status == 'PENDING'}">
                                    <button class="btn-action btn-pay" onclick="payNow('${payment.id}')">Pay Now</button>
                                </c:if>
                                <button class="btn-action btn-view" onclick="viewReceipt('${payment.id}')">View Receipt</button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <div class="quick-actions">
            <div class="action-card" onclick="window.location.href='${pageContext.request.contextPath}/user/payment'">
                <i>💳</i>
                <h3>Make Payment</h3>
                <p>Pay your pending fees</p>
            </div>
            <div class="action-card" onclick="window.location.href='${pageContext.request.contextPath}/user/receipts'">
                <i>📄</i>
                <h3>View Receipts</h3>
                <p>View your payment history</p>
            </div>
            <div class="action-card" onclick="window.location.href='${pageContext.request.contextPath}/user/profile'">
                <i>👤</i>
                <h3>Update Profile</h3>
                <p>Manage your account details</p>
            </div>
        </div>
    </div>

    <%@ include file="../includes/footer.jsp" %>
    
    <script>
        function payNow(paymentId) {
            window.location.href = '${pageContext.request.contextPath}/user/payment/' + paymentId;
        }

        function viewReceipt(paymentId) {
            window.location.href = '${pageContext.request.contextPath}/user/receipt/' + paymentId;
        }
    </script>
</body>
</html> 