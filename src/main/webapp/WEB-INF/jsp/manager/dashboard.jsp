<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manager Dashboard - Accounting Management System</title>
    <link rel="stylesheet" href="../../css/main.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom JavaScript -->
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <style>
        :root {
            --primary-color: #3498db;
            --success-color: #2ecc71;
            --danger-color: #e74c3c;
            --warning-color: #f39c12;
            --info-color: #17a2b8;
            --dark-color: #2c3e50;
            --light-color: #ecf0f1;
        }

        body {
            background-color: #f5f7fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .manager-dashboard {
            padding: 20px;
            max-width: 1400px;
            margin: 0 auto;
        }

        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .dashboard-header h1 {
            color: var(--dark-color);
            margin: 0;
        }

        .notification-bell {
            position: relative;
            cursor: pointer;
            font-size: 24px;
            color: var(--dark-color);
        }

        .notification-count {
            position: absolute;
            top: -8px;
            right: -8px;
            background: var(--danger-color);
            color: white;
            border-radius: 50%;
            padding: 2px 6px;
            font-size: 12px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: transform 0.3s, box-shadow 0.3s;
            position: relative;
            overflow: hidden;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.15);
        }

        .stat-card h3 {
            margin: 0 0 10px 0;
            color: var(--dark-color);
            font-size: 16px;
            font-weight: 500;
        }

        .stat-card .value {
            font-size: 28px;
            font-weight: bold;
            color: var(--primary-color);
            margin-bottom: 10px;
        }

        .stat-card .trend {
            display: flex;
            align-items: center;
            font-size: 14px;
            color: var(--success-color);
        }

        .stat-card .trend.down {
            color: var(--danger-color);
        }

        .manager-section {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .section-header h2 {
            margin: 0;
            color: var(--dark-color);
            font-size: 20px;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
        }

        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .btn:hover {
            opacity: 0.9;
        }

        .btn-primary {
            background: var(--primary-color);
            color: white;
        }

        .btn-success {
            background: var(--success-color);
            color: white;
        }

        .btn-danger {
            background: var(--danger-color);
            color: white;
        }

        .btn-warning {
            background: var(--warning-color);
            color: white;
        }

        .btn-info {
            background: var(--info-color);
            color: white;
        }

        .search-section {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .search-section input, .search-section select {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            min-width: 200px;
        }

        .search-section input:focus, .search-section select:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 2px rgba(52,152,219,0.2);
        }

        .table-container {
            overflow-x: auto;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        .table th, .table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .table th {
            background-color: #f8f9fa;
            font-weight: 600;
            color: var(--dark-color);
        }

        .table tr:hover {
            background-color: #f8f9fa;
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
            display: inline-block;
        }

        .status-pending {
            background: #fff3cd;
            color: #856404;
        }

        .status-approved {
            background: #d4edda;
            color: #155724;
        }

        .status-rejected {
            background: #f8d7da;
            color: #721c24;
        }

        .queue-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }

        .queue-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .queue-card h3 {
            margin: 0 0 15px 0;
            color: var(--dark-color);
        }

        .queue-number {
            font-size: 32px;
            font-weight: bold;
            color: var(--primary-color);
            text-align: center;
            margin: 15px 0;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
        }

        .queue-info {
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }

        .queue-info p {
            margin: 5px 0;
            color: #666;
        }

        .notification-panel {
            position: fixed;
            top: 0;
            right: -400px;
            width: 400px;
            height: 100vh;
            background: white;
            box-shadow: -2px 0 10px rgba(0,0,0,0.1);
            transition: right 0.3s;
            z-index: 1000;
        }

        .notification-panel.active {
            right: 0;
        }

        .notification-header {
            padding: 20px;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .notification-list {
            padding: 20px;
            max-height: calc(100vh - 100px);
            overflow-y: auto;
        }

        .notification-item {
            padding: 15px;
            border-bottom: 1px solid #eee;
            cursor: pointer;
            transition: background 0.3s;
        }

        .notification-item:hover {
            background: #f8f9fa;
        }

        .notification-item.unread {
            background: #f0f7ff;
        }

        .notification-time {
            font-size: 12px;
            color: #999;
            margin-top: 5px;
        }

        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(255,255,255,0.8);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 2000;
            display: none;
        }

        .loading-spinner {
            width: 50px;
            height: 50px;
            border: 5px solid #f3f3f3;
            border-top: 5px solid var(--primary-color);
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 10px 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            display: none;
        }

        .success-message {
            background: #d4edda;
            color: #155724;
            padding: 10px 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            display: none;
        }

        .progress {
            height: 20px;
            background-color: #f3f3f3;
            border-radius: 10px;
            overflow: hidden;
        }

        .progress-bar {
            height: 100%;
            background-color: #4CAF50;
            transition: width 0.3s;
        }

        .progress-bar.bg-success {
            background-color: #2ecc71;
        }

        .progress-bar.bg-warning {
            background-color: #f39c12;
        }

        .progress-bar.bg-danger {
            background-color: #e74c3c;
        }

        .chart-container {
            position: relative;
            height: 300px;
            margin-bottom: 1rem;
        }

        .task-list {
            max-height: 400px;
            overflow-y: auto;
        }

        .task-item {
            padding: 15px;
            border-bottom: 1px solid #eee;
            transition: background-color 0.3s;
        }

        .task-item:hover {
            background-color: #f8f9fa;
        }

        .task-item.completed {
            background-color: #f8f9fa;
            opacity: 0.7;
        }

        .task-priority {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }

        .priority-high {
            background-color: #f8d7da;
            color: #721c24;
        }

        .priority-medium {
            background-color: #fff3cd;
            color: #856404;
        }

        .priority-low {
            background-color: #d4edda;
            color: #155724;
        }

        .team-member {
            display: flex;
            align-items: center;
            padding: 10px;
            border-bottom: 1px solid #eee;
        }

        .team-member:last-child {
            border-bottom: none;
        }

        .member-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 15px;
            background-color: #e9ecef;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            color: #495057;
        }

        .member-info {
            flex: 1;
        }

        .member-name {
            font-weight: 500;
            margin-bottom: 2px;
        }

        .member-role {
            font-size: 12px;
            color: #6c757d;
        }

        .member-status {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            margin-left: 10px;
        }

        .status-online {
            background-color: #28a745;
        }

        .status-offline {
            background-color: #dc3545;
        }

        .status-away {
            background-color: #ffc107;
        }

        .notification-badge {
            position: absolute;
            top: -8px;
            right: -8px;
            background: var(--danger-color);
            color: white;
            border-radius: 50%;
            padding: 2px 6px;
            font-size: 12px;
        }

        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
        }

        .quick-action-btn {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: transform 0.3s, box-shadow 0.3s;
            text-decoration: none;
            color: var(--dark-color);
        }

        .quick-action-btn:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.15);
            color: var(--primary-color);
        }

        .quick-action-btn i {
            font-size: 24px;
            margin-bottom: 10px;
        }

        .quick-action-btn span {
            font-size: 14px;
            text-align: center;
        }
    </style>
</head>
<body>
    <%@ include file="../includes/manager-header.jsp" %>
    
    <div class="manager-dashboard">
        <div class="content-header">
            <h1 class="h2">Manager Dashboard</h1>
            <div class="header-actions">
                <button class="btn btn-primary" onclick="refreshDashboard()">
                    <i class="bi bi-arrow-clockwise"></i> Refresh
                </button>
                <button class="btn btn-success" onclick="exportReport()">
                    <i class="bi bi-download"></i> Export Report
                </button>
            </div>
        </div>

        <div class="error-message" id="errorMessage"></div>
        <div class="success-message" id="successMessage"></div>
        
        <div class="stats-grid">
            <div class="stat-card">
                <h3>Total Revenue</h3>
                <div class="value">
                    <fmt:formatNumber value="${totalRevenue}" type="currency"/>
                </div>
                <div class="trend ${revenueTrend != null && revenueTrend >= 0 ? '' : 'down'}">
                    <i class="bi bi-arrow-${revenueTrend != null && revenueTrend >= 0 ? 'up' : 'down'}"></i>
                    <span>${revenueTrend != null ? Math.abs(revenueTrend) : 0}%</span>
                </div>
            </div>
            <div class="stat-card">
                <h3>Pending Approvals</h3>
                <div class="value">${pendingApprovals != null ? pendingApprovals : 0}</div>
                <div class="trend">
                    <i class="bi bi-clock"></i>
                    <span>${pendingApprovals != null ? pendingApprovals : 0} items</span>
                </div>
            </div>
            <div class="stat-card">
                <h3>Active Users</h3>
                <div class="value">${activeUsers != null ? activeUsers : 0}</div>
                <div class="trend ${userTrend != null && userTrend >= 0 ? '' : 'down'}">
                    <i class="bi bi-arrow-${userTrend != null && userTrend >= 0 ? 'up' : 'down'}"></i>
                    <span>${userTrend != null ? Math.abs(userTrend) : 0}%</span>
                </div>
            </div>
            <div class="stat-card">
                <h3>System Health</h3>
                <div class="value">${systemHealth != null ? systemHealth : 0}%</div>
                <div class="progress">
                    <div class="progress-bar ${systemHealth != null && systemHealth >= 80 ? 'bg-success' : systemHealth != null && systemHealth >= 50 ? 'bg-warning' : 'bg-danger'}" 
                         role="progressbar" 
                         data-width="${systemHealth != null ? systemHealth : 0}">
                    </div>
                </div>
            </div>
        </div>

        <div class="row mb-4">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5>Revenue Trend</h5>
                    </div>
                    <div class="card-body">
                        <div class="chart-container">
                            <canvas id="revenueChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5>User Activity</h5>
                    </div>
                    <div class="card-body">
                        <div class="chart-container">
                            <canvas id="activityChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5>Recent Tasks</h5>
                    </div>
                    <div class="card-body">
                        <div class="task-list">
                            <c:forEach items="${recentTasks}" var="task">
                                <div class="task-item ${task.completed ? 'completed' : ''}">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h6 class="mb-1">${task.title}</h6>
                                            <p class="mb-0 text-muted">${task.description}</p>
                                        </div>
                                        <div>
                                            <span class="task-priority priority-${task.priority.toLowerCase()}">
                                                ${task.priority}
                                            </span>
                                            <c:if test="${!task.completed}">
                                                <button class="btn btn-sm btn-success ms-2" onclick="completeTask('${task.id}')">
                                                    <i class="bi bi-check"></i>
                                                </button>
                                            </c:if>
                                        </div>
                                    </div>
                                    <small class="text-muted">
                                        Due: <fmt:formatDate value="${task.dueDate}" pattern="MMM dd, yyyy"/>
                                    </small>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5>Team Members</h5>
                    </div>
                    <div class="card-body">
                        <div class="team-list">
                            <c:forEach items="${teamMembers}" var="member">
                                <div class="team-member">
                                    <div class="member-avatar">
                                        ${member.name.charAt(0)}
                                    </div>
                                    <div class="member-info">
                                        <div class="member-name">${member.name}</div>
                                        <div class="member-role">${member.role}</div>
                                    </div>
                                    <div class="member-status status-${member.status.toLowerCase()}"></div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5>Recent Transactions</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Date</th>
                                        <th>Type</th>
                                        <th>Amount</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${recentTransactions}" var="transaction">
                                        <tr>
                                            <td>${transaction.id}</td>
                                            <td><fmt:formatDate value="${transaction.date}" pattern="MMM dd, yyyy HH:mm"/></td>
                                            <td>${transaction.type}</td>
                                            <td><fmt:formatNumber value="${transaction.amount}" type="currency"/></td>
                                            <td>
                                                <span class="badge ${transaction.status == 'COMPLETED' ? 'bg-success' : 
                                                                          transaction.status == 'PENDING' ? 'bg-warning' : 'bg-danger'}">
                                                    ${transaction.status}
                                                </span>
                                            </td>
                                            <td>
                                                <button class="btn btn-sm btn-info" onclick="viewTransaction('${transaction.id}')">
                                                    <i class="bi bi-eye"></i>
                                                </button>
                                                <c:if test="${transaction.status == 'PENDING'}">
                                                    <button class="btn btn-sm btn-success" onclick="approveTransaction('${transaction.id}')">
                                                        <i class="bi bi-check"></i>
                                                    </button>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5>System Alerts</h5>
                    </div>
                    <div class="card-body">
                        <div class="alert-list">
                            <c:forEach items="${systemAlerts}" var="alert">
                                <div class="alert ${alert.type == 'ERROR' ? 'alert-danger' : 
                                                alert.type == 'WARNING' ? 'alert-warning' : 'alert-info'}">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <strong>${alert.title}</strong>
                                            <p class="mb-0">${alert.message}</p>
                                        </div>
                                        <small><fmt:formatDate value="${alert.timestamp}" pattern="MMM dd, HH:mm"/></small>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="notification-panel" id="notificationPanel">
        <div class="notification-header">
            <h3>Notifications</h3>
            <button class="btn btn-primary" onclick="markAllAsRead()">
                <i class="fas fa-check-double"></i> Mark All as Read
            </button>
        </div>
        <div class="notification-list" id="notificationList">
            <c:forEach items="${notifications}" var="notification">
                <div class="notification-item ${notification.read ? '' : 'unread'}" onclick="markAsRead('${notification.id}')">
                    <div>${notification.message}</div>
                    <div class="notification-time">
                        <fmt:formatDate value="${notification.createdAt}" pattern="MMM dd, yyyy HH:mm"/>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <div class="loading-overlay" id="loadingOverlay">
        <div class="loading-spinner"></div>
    </div>

    <%@ include file="../includes/footer.jsp" %>
    
    <script>
        let notificationPanel = document.getElementById('notificationPanel');
        let loadingOverlay = document.getElementById('loadingOverlay');
        let errorMessage = document.getElementById('errorMessage');
        let successMessage = document.getElementById('successMessage');

        function toggleNotifications() {
            notificationPanel.classList.toggle('active');
        }

        function showLoading() {
            loadingOverlay.style.display = 'flex';
        }

        function hideLoading() {
            loadingOverlay.style.display = 'none';
        }

        function showError(message) {
            errorMessage.textContent = message;
            errorMessage.style.display = 'block';
            setTimeout(() => {
                errorMessage.style.display = 'none';
            }, 5000);
        }

        function showSuccess(message) {
            successMessage.textContent = message;
            successMessage.style.display = 'block';
            setTimeout(() => {
                successMessage.style.display = 'none';
            }, 5000);
        }

        function approvePayment(paymentId) {
            if (confirm('Are you sure you want to approve this payment?')) {
                showLoading();
                fetch(`${pageContext.request.contextPath}/manager/approve/${paymentId}`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    }
                })
                .then(response => {
                    if (response.ok) {
                        showSuccess('Payment approved successfully');
                        refreshPayments();
                    } else {
                        throw new Error('Failed to approve payment');
                    }
                })
                .catch(error => {
                    showError(error.message);
                })
                .finally(() => {
                    hideLoading();
                });
            }
        }
        
        function rejectPayment(paymentId) {
            if (confirm('Are you sure you want to reject this payment?')) {
                showLoading();
                fetch(`${pageContext.request.contextPath}/manager/reject/${paymentId}`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    }
                })
                .then(response => {
                    if (response.ok) {
                        showSuccess('Payment rejected successfully');
                        refreshPayments();
                    } else {
                        throw new Error('Failed to reject payment');
                    }
                })
                .catch(error => {
                    showError(error.message);
                })
                .finally(() => {
                    hideLoading();
                });
            }
        }
        
        function nextQueue() {
            showLoading();
            fetch(`${pageContext.request.contextPath}/manager/next-queue`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                }
            })
            .then(response => {
                if (response.ok) {
                    showSuccess('Queue advanced successfully');
                    refreshQueue();
                } else {
                    throw new Error('Failed to advance queue');
                }
            })
            .catch(error => {
                showError(error.message);
            })
            .finally(() => {
                hideLoading();
            });
        }

        function resetQueue() {
            if (confirm('Are you sure you want to reset the queue? This will clear all waiting users.')) {
                showLoading();
                fetch(`${pageContext.request.contextPath}/manager/reset-queue`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    }
                })
                .then(response => {
                    if (response.ok) {
                        showSuccess('Queue reset successfully');
                        refreshQueue();
                    } else {
                        throw new Error('Failed to reset queue');
                    }
                })
                .catch(error => {
                    showError(error.message);
                })
                .finally(() => {
                    hideLoading();
                });
            }
        }

        function refreshPayments() {
            showLoading();
            fetch(`${pageContext.request.contextPath}/manager/payments`, {
                method: 'GET',
                headers: {
                    'Accept': 'application/json'
                }
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                const tableBody = document.getElementById('paymentTableBody');
                tableBody.innerHTML = ''; // Clear existing rows
                
                data.payments.forEach(payment => {
                    const row = document.createElement('tr');
                    row.innerHTML = `
                        <td>${payment.id}</td>
                        <td>${payment.user.username}</td>
                        <td>$${payment.amount.toFixed(2)}</td>
                        <td>${payment.type}</td>
                        <td>
                            <span class="status-badge status-${payment.paymentStatus.toLowerCase()}">
                                ${payment.paymentStatus}
                            </span>
                        </td>
                        <td><fmt:formatDate value="${payment.createdAt}" pattern="MMM dd, yyyy HH:mm"/></td>
                        <td>
                            <button class="btn btn-success" onclick="approvePayment('${payment.id}')">
                                <i class="fas fa-check"></i> Approve
                            </button>
                            <button class="btn btn-danger" onclick="rejectPayment('${payment.id}')">
                                <i class="fas fa-times"></i> Reject
                            </button>
                        </td>
                    `;
                    tableBody.appendChild(row);
                });
                
                // Update statistics
                document.querySelector('.stat-card:nth-child(1) .value').textContent = data.statistics.totalPayments;
                document.querySelector('.stat-card:nth-child(2) .value').textContent = data.statistics.pendingPayments;
                document.querySelector('.stat-card:nth-child(3) .value').textContent = 
                    `$${data.statistics.totalAmount.toFixed(2)}`;
            })
            .catch(error => {
                console.error('Error refreshing payments:', error);
                showError('Failed to refresh payments. Please try again.');
            })
            .finally(() => {
                hideLoading();
            });
        }

        function refreshQueue() {
            showLoading();
            fetch(`${pageContext.request.contextPath}/manager/queue`, {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json'
                }
            })
            .then(response => response.json())
            .then(data => {
                updateQueueTable(data);
                hideLoading();
            })
            .catch(error => {
                showError('Failed to refresh queue');
                hideLoading();
            });
        }

        function searchPayments() {
            const searchText = document.getElementById('paymentSearch').value.toLowerCase();
            const typeFilter = document.getElementById('paymentTypeFilter').value;
            const statusFilter = document.getElementById('paymentStatusFilter').value;
            
            const rows = document.querySelectorAll('#paymentTableBody tr');
            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                const type = row.cells[3].textContent;
                const status = row.cells[4].textContent.trim();
                
                const matchesSearch = text.includes(searchText);
                const matchesType = !typeFilter || type === typeFilter;
                const matchesStatus = !statusFilter || status === statusFilter;
                
                row.style.display = matchesSearch && matchesType && matchesStatus ? '' : 'none';
            });
        }

        function searchQueue() {
            const searchText = document.getElementById('queueSearch').value.toLowerCase();
            const rows = document.querySelectorAll('#queueTableBody tr');
            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(searchText) ? '' : 'none';
            });
        }

        function markAsRead(notificationId) {
            fetch(`${pageContext.request.contextPath}/manager/notifications/${notificationId}/read`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                }
            })
            .then(response => {
                if (response.ok) {
                    const notification = document.querySelector(`.notification-item[onclick*="${notificationId}"]`);
                    if (notification) {
                        notification.classList.remove('unread');
                    }
                    updateNotificationCount();
                }
            });
        }

        function markAllAsRead() {
            fetch(`${pageContext.request.contextPath}/manager/notifications/read-all`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                }
            })
            .then(response => {
                if (response.ok) {
                    document.querySelectorAll('.notification-item').forEach(item => {
                        item.classList.remove('unread');
                    });
                    updateNotificationCount();
                }
            });
        }

        function updateNotificationCount() {
            const count = document.querySelectorAll('.notification-item.unread').length;
            document.getElementById('notificationCount').textContent = count;
        }

        function exportPayments() {
            showLoading();
            fetch(`${pageContext.request.contextPath}/manager/payments/export`, {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json'
                }
            })
            .then(response => response.blob())
            .then(blob => {
                const url = window.URL.createObjectURL(blob);
                const a = document.createElement('a');
                a.href = url;
                a.download = 'payments-export.csv';
                document.body.appendChild(a);
                a.click();
                window.URL.revokeObjectURL(url);
                a.remove();
            })
            .catch(error => {
                showError('Failed to export payments');
            })
            .finally(() => {
                hideLoading();
            });
        }

        // Initialize charts
        document.addEventListener('DOMContentLoaded', function() {
            // Revenue Chart
            const revenueCtx = document.getElementById('revenueChart').getContext('2d');
            new Chart(revenueCtx, {
                type: 'line',
                data: {
                    labels: JSON.parse('${revenueLabels}'),
                    datasets: [{
                        label: 'Revenue',
                        data: JSON.parse('${revenueData}'),
                        borderColor: 'rgb(75, 192, 192)',
                        tension: 0.1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false
                }
            });

            // Activity Chart
            const activityCtx = document.getElementById('activityChart').getContext('2d');
            new Chart(activityCtx, {
                type: 'bar',
                data: {
                    labels: JSON.parse('${activityLabels}'),
                    datasets: [{
                        label: 'Activity',
                        data: JSON.parse('${activityData}'),
                        backgroundColor: 'rgba(54, 162, 235, 0.5)',
                        borderColor: 'rgb(54, 162, 235)',
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false
                }
            });

            const progressBar = document.querySelector('.progress-bar');
            if (progressBar) {
                progressBar.style.width = progressBar.dataset.width + '%';
            }
        });

        function refreshDashboard() {
            location.reload();
        }

        function exportReport() {
            window.location.href = `${pageContext.request.contextPath}/manager/reports/export`;
        }

        function addNewTask() {
            const modal = new bootstrap.Modal(document.getElementById('addTaskModal'));
            modal.show();
        }

        function saveTask() {
            const form = document.getElementById('taskForm');
            const formData = new FormData(form);

            fetch(`${pageContext.request.contextPath}/manager/tasks`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(Object.fromEntries(formData))
            })
            .then(response => {
                if (response.ok) {
                    location.reload();
                } else {
                    throw new Error('Failed to save task');
                }
            })
            .catch(error => {
                alert(error.message);
            });
        }

        function completeTask(taskId) {
            if (confirm('Are you sure you want to mark this task as completed?')) {
                fetch(`${pageContext.request.contextPath}/manager/tasks/${taskId}/complete`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    }
                })
                .then(response => {
                    if (response.ok) {
                        location.reload();
                    } else {
                        throw new Error('Failed to complete task');
                    }
                })
                .catch(error => {
                    alert(error.message);
                });
            }
        }

        function viewTransaction(transactionId) {
            window.location.href = `${pageContext.request.contextPath}/manager/transactions/${transactionId}`;
        }

        function approveTransaction(transactionId) {
            if (confirm('Are you sure you want to approve this transaction?')) {
                fetch(`${pageContext.request.contextPath}/manager/transactions/${transactionId}/approve`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    }
                })
                .then(response => {
                    if (response.ok) {
                        location.reload();
                    } else {
                        throw new Error('Failed to approve transaction');
                    }
                })
                .catch(error => {
                    alert(error.message);
                });
            }
        }
    </script>
</body>
</html> 