<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    </style>
</head>
<body>
    <%@ include file="../includes/header.jsp" %>
    
    <div class="manager-dashboard">
        <div class="dashboard-header">
            <h1>Manager Dashboard</h1>
            <div class="notification-bell" onclick="toggleNotifications()">
                <i class="fas fa-bell"></i>
                <span class="notification-count" id="notificationCount">${unreadNotifications}</span>
            </div>
        </div>

        <div class="error-message" id="errorMessage"></div>
        <div class="success-message" id="successMessage"></div>
        
        <div class="stats-grid">
            <div class="stat-card">
                <h3>Pending Approvals</h3>
                <div class="value">${pendingApprovals}</div>
                <div class="trend">
                    <i class="fas fa-arrow-up"></i>
                    <span>5% from last week</span>
                </div>
            </div>
            <div class="stat-card">
                <h3>Today's Revenue</h3>
                <div class="value">$<fmt:formatNumber value="${todayRevenue}" type="number" minFractionDigits="2" maxFractionDigits="2"/></div>
                <div class="trend">
                    <i class="fas fa-arrow-up"></i>
                    <span>12% from yesterday</span>
                </div>
            </div>
            <div class="stat-card">
                <h3>Active Queues</h3>
                <div class="value">${activeQueues}</div>
                <div class="trend down">
                    <i class="fas fa-arrow-down"></i>
                    <span>3% from last hour</span>
                </div>
            </div>
        </div>

        <div class="manager-section">
            <div class="section-header">
                <h2>Payment Approvals</h2>
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/manager/payments" class="btn btn-primary">
                        <i class="fas fa-list"></i> View All Payments
                    </a>
                    <button class="btn btn-info" onclick="refreshPayments()">
                        <i class="fas fa-sync-alt"></i> Refresh
                    </button>
                    <button class="btn btn-primary" onclick="exportPayments()">
                        <i class="fas fa-download"></i> Export
                    </button>
                </div>
            </div>
            <div class="search-section">
                <input type="text" id="paymentSearch" placeholder="Search payments..." onkeyup="searchPayments()">
                <select id="paymentTypeFilter" onchange="filterPayments()">
                    <option value="">All Types</option>
                    <option value="TUITION">Tuition</option>
                    <option value="MISCELLANEOUS">Miscellaneous</option>
                    <option value="LIBRARY">Library</option>
                    <option value="LABORATORY">Laboratory</option>
                </select>
                <select id="paymentStatusFilter" onchange="filterPayments()">
                    <option value="">All Statuses</option>
                    <option value="PENDING">Pending</option>
                    <option value="APPROVED">Approved</option>
                    <option value="REJECTED">Rejected</option>
                </select>
            </div>
            <div class="table-container">
                <table class="table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>User</th>
                            <th>Amount</th>
                            <th>Type</th>
                            <th>Status</th>
                            <th>Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="paymentTableBody">
                        <c:forEach items="${pendingPayments}" var="payment">
                            <tr>
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
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="manager-section">
            <div class="section-header">
                <h2>Queue Management</h2>
                <div class="action-buttons">
                    <button class="btn btn-info" onclick="refreshQueue()">
                        <i class="fas fa-sync-alt"></i> Refresh
                    </button>
                    <button class="btn btn-warning" onclick="resetQueue()">
                        <i class="fas fa-redo"></i> Reset
                    </button>
                </div>
            </div>
            <div class="queue-section">
                <div class="queue-card">
                    <h3>Current Queue</h3>
                    <div class="queue-number">#${currentQueue}</div>
                    <button class="btn btn-success" style="width: 100%;" onclick="nextQueue()">
                        <i class="fas fa-forward"></i> Next
                    </button>
                    <div class="queue-info">
                        <p><i class="fas fa-clock"></i> Average Wait Time: 15 minutes</p>
                        <p><i class="fas fa-users"></i> Total in Queue: ${totalInQueue}</p>
                    </div>
                </div>
                <div class="queue-card">
                    <h3>Waiting List</h3>
                    <div class="search-section">
                        <input type="text" id="queueSearch" placeholder="Search users..." onkeyup="searchQueue()">
                    </div>
                    <div class="table-container">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Position</th>
                                    <th>User</th>
                                    <th>Type</th>
                                    <th>Time</th>
                                </tr>
                            </thead>
                            <tbody id="queueTableBody">
                                <c:forEach items="${waitingList}" var="queue">
                                    <tr>
                                        <td>#${queue.position}</td>
                                        <td>${queue.user.username}</td>
                                        <td>${queue.type}</td>
                                        <td><fmt:formatDate value="${queue.createdAt}" pattern="HH:mm"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
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
    </script>
</body>
</html> 