<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!-- @jsx-ignore -->
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Accounting Management System</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/static/css/main.css" rel="stylesheet">
    
    <style>
        /* Only dashboard-specific styles that are not in main.css */
        .admin-dashboard {
            padding: 2rem;
            max-width: 1400px;
            margin: 0 auto;
        }

        .chart-container {
            height: 300px;
            margin-bottom: 2rem;
        }

        .notification-badge {
            background: var(--danger-color);
            color: white;
            padding: 0.25rem 0.5rem;
            border-radius: 9999px;
            font-size: 0.75rem;
        }

        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 500;
        }

        .status-pending { background: #fef3c7; color: #92400e; }
        .status-completed { background: #dcfce7; color: #166534; }
        .status-failed { background: #fee2e2; color: #b91c1c; }
        .status-processing { background: #dbeafe; color: #1e40af; }

        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .notification-list {
            max-height: 300px;
            overflow-y: auto;
        }

        .notification-item {
            padding: 1rem;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .notification-item:last-child {
            border-bottom: none;
        }

        .tab-container {
            margin-bottom: 1.5rem;
        }

        .tab-buttons {
            display: flex;
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .tab-button {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 8px;
            background: var(--light-color);
            color: var(--text-color);
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .tab-button.active {
            background: var(--primary-color);
            color: white;
        }

        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
        }

        .chart-legend {
            display: flex;
            gap: 1rem;
            margin-top: 1rem;
            flex-wrap: wrap;
        }

        .legend-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .legend-color {
            width: 12px;
            height: 12px;
            border-radius: 3px;
        }

        /* Sidebar styles */
        .sidebar {
            background: var(--primary-color);
            color: white;
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            z-index: 1000;
            transition: all 0.3s ease;
        }

        .sidebar .nav-link {
            color: rgba(255, 255, 255, 0.8);
            padding: 0.75rem 1rem;
            border-radius: 0.5rem;
            margin-bottom: 0.5rem;
            transition: all 0.2s ease;
        }

        .sidebar .nav-link:hover {
            color: white;
            background: rgba(255, 255, 255, 0.1);
        }

        .sidebar .nav-link.active {
            color: white;
            background: rgba(255, 255, 255, 0.2);
        }

        .sidebar .nav-link i {
            width: 1.5rem;
            text-align: center;
        }

        /* Main content area */
        .main-content {
            margin-left: 250px;
            padding: 2rem;
            transition: all 0.3s ease;
        }

        /* Top navigation bar */
        .top-nav {
            background: white;
            padding: 1rem 2rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            position: sticky;
            top: 0;
            z-index: 999;
        }

        .top-nav .nav-item {
            margin-left: 1rem;
        }

        .top-nav .nav-link {
            color: var(--text-color);
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            transition: all 0.2s ease;
        }

        .top-nav .nav-link:hover {
            background: var(--light-color);
        }

        .top-nav .dropdown-menu {
            border: none;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .top-nav .notification-badge {
            position: absolute;
            top: -5px;
            right: -5px;
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar col-md-3 col-lg-2">
        <div class="d-flex flex-column p-3">
            <a href="/" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-white text-decoration-none">
                <span class="fs-4">Admin Panel</span>
            </a>
            <hr>
            <ul class="nav nav-pills flex-column mb-auto">
                <li class="nav-item">
                    <a href="#" class="nav-link active">
                        <i class="bi bi-speedometer2"></i>
                        Dashboard
                    </a>
                </li>
                <li>
                    <a href="#" class="nav-link">
                        <i class="bi bi-people"></i>
                        Users
                    </a>
                </li>
                <li>
                    <a href="#" class="nav-link">
                        <i class="bi bi-cash-stack"></i>
                        Transactions
                    </a>
                </li>
                <li>
                    <a href="#" class="nav-link">
                        <i class="bi bi-clock-history"></i>
                        Queue
                    </a>
                </li>
                <li>
                    <a href="#" class="nav-link">
                        <i class="bi bi-file-earmark-text"></i>
                        Reports
                    </a>
                </li>
                <li>
                    <a href="#" class="nav-link">
                        <i class="bi bi-gear"></i>
                        Settings
                    </a>
                </li>
                <li class="mt-auto">
                    <form action="${pageContext.request.contextPath}/logout" method="post" class="nav-item">
                        <button type="submit" class="nav-link text-danger w-100 border-0 bg-transparent">
                            <i class="bi bi-box-arrow-right"></i>
                            Logout
                        </button>
                    </form>
                </li>
            </ul>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Top Navigation -->
        <nav class="top-nav">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="h4 mb-0">Dashboard Overview</h1>
                </div>
                <div class="d-flex align-items-center">
                    <div class="btn-group me-3">
                        <button type="button" class="btn btn-sm btn-outline-secondary">
                            <i class="bi bi-download"></i> Export
                        </button>
                        <button type="button" class="btn btn-sm btn-outline-secondary">
                            <i class="bi bi-printer"></i> Print
                        </button>
                    </div>
                    <div class="dropdown me-3">
                        <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                            <i class="bi bi-calendar"></i> This week
                        </button>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="#">Today</a></li>
                            <li><a class="dropdown-item" href="#">This week</a></li>
                            <li><a class="dropdown-item" href="#">This month</a></li>
                            <li><a class="dropdown-item" href="#">This year</a></li>
                        </ul>
                    </div>
                    <div class="dropdown">
                        <a href="#" class="nav-link position-relative" data-bs-toggle="dropdown">
                            <i class="bi bi-bell"></i>
                            <span class="notification-badge">3</span>
                        </a>
                        <div class="dropdown-menu dropdown-menu-end">
                            <h6 class="dropdown-header">Notifications</h6>
                            <div class="notification-list">
                                <a href="#" class="dropdown-item">
                                    <div class="d-flex align-items-center">
                                        <div class="flex-shrink-0">
                                            <i class="bi bi-check-circle-fill text-success"></i>
                                        </div>
                                        <div class="flex-grow-1 ms-3">
                                            <p class="mb-0">New transaction completed</p>
                                            <small class="text-muted">2 minutes ago</small>
                                        </div>
                                    </div>
                                </a>
                                <a href="#" class="dropdown-item">
                                    <div class="d-flex align-items-center">
                                        <div class="flex-shrink-0">
                                            <i class="bi bi-exclamation-circle-fill text-warning"></i>
                                        </div>
                                        <div class="flex-grow-1 ms-3">
                                            <p class="mb-0">System maintenance scheduled</p>
                                            <small class="text-muted">1 hour ago</small>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="dropdown ms-3">
                        <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown">
                            <i class="bi bi-person-circle"></i>
                            Admin
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="#"><i class="bi bi-person me-2"></i>Profile</a></li>
                            <li><a class="dropdown-item" href="#"><i class="bi bi-gear me-2"></i>Settings</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li>
                                <form action="${pageContext.request.contextPath}/logout" method="post">
                                    <button type="submit" class="dropdown-item">
                                        <i class="bi bi-box-arrow-right me-2"></i>Logout
                                    </button>
                                </form>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </nav>

        <!-- Dashboard Content -->
        <div class="admin-dashboard">
            <!-- Top Navigation -->
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Dashboard Overview</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <div class="btn-group me-2">
                        <button type="button" class="btn btn-sm btn-outline-secondary">Export</button>
                        <button type="button" class="btn btn-sm btn-outline-secondary">Print</button>
                    </div>
                    <button type="button" class="btn btn-sm btn-outline-secondary dropdown-toggle">
                        <i class="bi bi-calendar"></i>
                        This week
                    </button>
                </div>
            </div>

            <!-- Statistics Cards -->
            <div class="dashboard-stats">
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="bi bi-people-fill"></i>
                    </div>
                    <div class="stat-info">
                        <h3>${totalUsers}</h3>
                        <p>Total Users</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="bi bi-person-check-fill"></i>
                    </div>
                    <div class="stat-info">
                        <h3>${activeUsers}</h3>
                        <p>Active Users</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="bi bi-cash-stack"></i>
                    </div>
                    <div class="stat-info">
                        <h3><fmt:formatNumber value="${totalRevenue}" type="currency"/></h3>
                        <p>Total Revenue</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="bi bi-clock-history"></i>
                    </div>
                    <div class="stat-info">
                        <h3>${pendingQueues}</h3>
                        <p>Pending Queues</p>
                    </div>
                </div>
            </div>

            <!-- Charts Row -->
            <div class="row">
                <!-- Transaction Chart -->
                <div class="col-xl-8 col-lg-7">
                    <div class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">Transaction Overview</h6>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <canvas id="transactionChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Queue Status -->
                <div class="col-xl-4 col-lg-5">
                    <div class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">Queue Status</h6>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <canvas id="queueChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Transactions and Users -->
            <div class="row">
                <!-- Recent Transactions -->
                <div class="col-lg-8 mb-4">
                    <div class="card shadow">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">Recent Transactions</h6>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-bordered">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>User</th>
                                            <th>Amount</th>
                                            <th>Status</th>
                                            <th>Date</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${recentTransactions}" var="transaction">
                                            <tr>
                                                <td>${transaction.id}</td>
                                                <td>${transaction.user.username}</td>
                                                <td><fmt:formatNumber value="${transaction.amount}" type="currency"/></td>
                                                <td>
                                                    <span class="badge bg-${transaction.status == 'COMPLETED' ? 'success' : 
                                                                          transaction.status == 'PENDING' ? 'warning' : 'danger'}">
                                                        ${transaction.status}
                                                    </span>
                                                </td>
                                                <td><fmt:formatDate value="${transaction.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Users -->
                <div class="col-lg-4 mb-4">
                    <div class="card shadow">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">Recent Users</h6>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-bordered">
                                    <thead>
                                        <tr>
                                            <th>Username</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${users}" var="user">
                                            <tr>
                                                <td>${user.username}</td>
                                                <td>
                                                    <span class="badge bg-${user.enabled ? 'success' : 'danger'}">
                                                        ${user.enabled ? 'Active' : 'Inactive'}
                                                    </span>
                                                </td>
                                                <td>
                                                    <button class="btn btn-sm btn-primary">
                                                        <i class="bi bi-eye"></i>
                                                    </button>
                                                    <button class="btn btn-sm btn-warning">
                                                        <i class="bi bi-pencil"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Documents and Payments Section -->
            <div class="row mt-4">
                <!-- Documents Overview -->
                <div class="col-lg-6 mb-4">
                    <div class="card shadow">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">Documents Overview</h6>
                        </div>
                        <div class="card-body">
                            <div class="dashboard-stats">
                                <div class="stat-card">
                                    <div class="stat-icon">
                                        <i class="bi bi-file-earmark-text"></i>
                                    </div>
                                    <div class="stat-info">
                                        <h3>${totalDocuments}</h3>
                                        <p>Total Documents</p>
                                    </div>
                                </div>
                                <div class="stat-card">
                                    <div class="stat-icon">
                                        <i class="bi bi-file-earmark-check"></i>
                                    </div>
                                    <div class="stat-info">
                                        <h3>${verifiedDocuments}</h3>
                                        <p>Verified</p>
                                    </div>
                                </div>
                            </div>
                            <div class="table-responsive mt-3">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Document</th>
                                            <th>User</th>
                                            <th>Status</th>
                                            <th>Date</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${recentDocuments}" var="document">
                                            <tr>
                                                <td>${document.fileName}</td>
                                                <td>${document.user.username}</td>
                                                <td>
                                                    <span class="badge bg-${document.status == 'VERIFIED' ? 'success' : 
                                                                          document.status == 'PENDING' ? 'warning' : 'danger'}">
                                                        ${document.status}
                                                    </span>
                                                </td>
                                                <td><fmt:formatDate value="${document.uploadedAt}" pattern="yyyy-MM-dd"/></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Payments Overview -->
                <div class="col-lg-6 mb-4">
                    <div class="card shadow">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">Payments Overview</h6>
                        </div>
                        <div class="card-body">
                            <div class="dashboard-stats">
                                <div class="stat-card">
                                    <div class="stat-icon">
                                        <i class="bi bi-cash-stack"></i>
                                    </div>
                                    <div class="stat-info">
                                        <h3><fmt:formatNumber value="${totalPayments}" type="currency"/></h3>
                                        <p>Total Payments</p>
                                    </div>
                                </div>
                                <div class="stat-card">
                                    <div class="stat-icon">
                                        <i class="bi bi-clock-history"></i>
                                    </div>
                                    <div class="stat-info">
                                        <h3>${pendingPayments}</h3>
                                        <p>Pending</p>
                                    </div>
                                </div>
                            </div>
                            <div class="table-responsive mt-3">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Payment ID</th>
                                            <th>User</th>
                                            <th>Amount</th>
                                            <th>Status</th>
                                            <th>Date</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${recentPayments}" var="payment">
                                            <tr>
                                                <td>${payment.id}</td>
                                                <td>${payment.user.username}</td>
                                                <td><fmt:formatNumber value="${payment.amount}" type="currency"/></td>
                                                <td>
                                                    <span class="badge bg-${payment.status == 'COMPLETED' ? 'success' : 
                                                                          payment.status == 'PENDING' ? 'warning' : 'danger'}">
                                                        ${payment.status}
                                                    </span>
                                                </td>
                                                <td><fmt:formatDate value="${payment.createdAt}" pattern="yyyy-MM-dd"/></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit User Modal -->
    <div id="editUserModal" class="modal">
        <div class="modal-content">
            <h2>Edit User</h2>
            <form id="editUserForm">
                <input type="hidden" id="editUsername">
                <div>
                    <label>Email:</label>
                    <input type="email" id="editEmail" required>
                </div>
                <div>
                    <label>Role:</label>
                    <select id="editRole" required>
                        <option value="USER">User</option>
                        <option value="MANAGER">Manager</option>
                        <option value="ADMIN">Admin</option>
                    </select>
                </div>
                <div>
                    <label>Status:</label>
                    <select id="editStatus" required>
                        <option value="true">Active</option>
                        <option value="false">Inactive</option>
                    </select>
                </div>
                <button type="submit">Save Changes</button>
                <button type="button" onclick="closeModal()">Cancel</button>
            </form>
        </div>
    </div>

    <!-- Edit Transaction Modal -->
    <div id="editTransactionModal" class="modal">
        <div class="modal-content">
            <h2>Edit Transaction</h2>
            <form id="editTransactionForm">
                <input type="hidden" id="editTransactionId">
                <div>
                    <label>Priority:</label>
                    <select id="editPriority" required>
                        <option value="LOW">Low</option>
                        <option value="MEDIUM">Medium</option>
                        <option value="HIGH">High</option>
                        <option value="URGENT">Urgent</option>
                    </select>
                </div>
                <div>
                    <label>Status:</label>
                    <select id="editTransactionStatus" required>
                        <option value="PENDING">Pending</option>
                        <option value="COMPLETED">Completed</option>
                        <option value="FAILED">Failed</option>
                    </select>
                </div>
                <button type="submit">Save Changes</button>
                <button type="button" onclick="closeTransactionModal()">Cancel</button>
            </form>
        </div>
    </div>

    <!-- Add User Modal -->
    <div id="addUserModal" class="modal">
        <!-- Add user form structure -->
    </div>

    <!-- Process Queue Modal -->
    <div id="processQueueModal" class="modal">
        <!-- Process queue form structure -->
    </div>

    <!-- Export Options Modal -->
    <div id="exportModal" class="modal">
        <!-- Export options form structure -->
    </div>

    <%@ include file="../includes/footer.jsp" %>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <script>
        function searchUsers() {
            const searchText = document.getElementById('userSearch').value.toLowerCase();
            const rows = document.querySelectorAll('#userTableBody tr');
            rows.forEach(row => {
                const username = row.cells[0].textContent.toLowerCase();
                const email = row.cells[1].textContent.toLowerCase();
                if (username.includes(searchText) || email.includes(searchText)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        function filterUsers() {
            const role = document.getElementById('roleFilter').value;
            const status = document.getElementById('statusFilter').value;
            const rows = document.querySelectorAll('#userTableBody tr');
            rows.forEach(row => {
                const userRole = row.cells[2].textContent;
                const userStatus = row.cells[3].textContent;
                if (!role || userRole === role) {
                    if (!status || userStatus === status) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                } else {
                    row.style.display = 'none';
                }
            });
        }

        function editUser(username) {
            document.getElementById('editUserModal').style.display = 'block';
            document.getElementById('editUsername').value = username;
            // Fetch user details and populate form
            fetch(`${pageContext.request.contextPath}/admin/user/` + username)
                .then(response => response.json())
                .then(user => {
                    document.getElementById('editEmail').value = user.email;
                    document.getElementById('editRole').value = user.role;
                    document.getElementById('editStatus').value = user.enabled;
                });
        }

        function deleteUser(username) {
            if (confirm('Are you sure you want to delete this user?')) {
                fetch(`${pageContext.request.contextPath}/admin/user/` + username, {
                    method: 'DELETE'
                }).then(() => {
                    window.location.reload();
                });
            }
        }

        function closeModal() {
            document.getElementById('editUserModal').style.display = 'none';
        }

        function prevPage() {
            if (<c:out value="${currentPage}"/> > 1) {
                window.location.href = '<c:out value="${pageContext.request.contextPath}"/>/admin/dashboard?page=<c:out value="${currentPage - 1}"/>';
            }
        }

        function nextPage() {
            var currentPage = <c:out value="${currentPage}"/>;
            var totalPages = <c:out value="${totalPages}"/>;
            if (currentPage < totalPages) {
                window.location.href = '<c:out value="${pageContext.request.contextPath}"/>/admin/dashboard?page=' + (currentPage + 1);
            }
        }

        document.getElementById('editUserForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const username = document.getElementById('editUsername').value;
            const userData = {
                email: document.getElementById('editEmail').value,
                role: document.getElementById('editRole').value,
                enabled: document.getElementById('editStatus').value === 'true'
            };
            
            fetch(`${pageContext.request.contextPath}/admin/user/` + username, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(userData)
            }).then(() => {
                window.location.reload();
            });
        });

        function editTransaction(id) {
            document.getElementById('editTransactionModal').style.display = 'block';
            document.getElementById('editTransactionId').value = id;
            // Fetch transaction details and populate form
            fetch(`${pageContext.request.contextPath}/admin/transaction/` + id)
                .then(response => response.json())
                .then(transaction => {
                    document.getElementById('editPriority').value = transaction.priority;
                    document.getElementById('editTransactionStatus').value = transaction.status;
                });
        }

        function closeTransactionModal() {
            document.getElementById('editTransactionModal').style.display = 'none';
        }

        document.getElementById('editTransactionForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const id = document.getElementById('editTransactionId').value;
            const transactionData = {
                priority: document.getElementById('editPriority').value,
                status: document.getElementById('editTransactionStatus').value
            };
            
            fetch(`${pageContext.request.contextPath}/admin/transaction/` + id, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(transactionData)
            }).then(() => {
                window.location.reload();
            });
        });

        function processQueue(queueId) {
            fetch(`${pageContext.request.contextPath}/admin/queue/${queueId}/process`, {
                method: 'POST'
            }).then(() => {
                window.location.reload();
            });
        }

        function cancelQueue(queueId) {
            if (confirm('Are you sure you want to cancel this queue?')) {
                fetch(`${pageContext.request.contextPath}/admin/queue/${queueId}/cancel`, {
                    method: 'POST'
                }).then(() => {
                    window.location.reload();
                });
            }
        }

        // Chart data from server
        const chartData = {
            transaction: {
                labels: JSON.parse('${transactionLabels}'),
                data: JSON.parse('${transactionData}')
            },
            queue: {
                labels: JSON.parse('${queueLabels}'),
                data: JSON.parse('${queueData}')
            }
        };

        function initializeCharts() {
            // Transaction Chart
            const transactionCtx = document.getElementById('transactionChart').getContext('2d');
            new Chart(transactionCtx, {
                type: 'line',
                data: {
                    labels: chartData.transaction.labels,
                    datasets: [{
                        label: 'Transactions',
                        data: chartData.transaction.data,
                        borderColor: '#4e73df',
                        backgroundColor: 'rgba(78, 115, 223, 0.05)',
                        pointRadius: 3,
                        pointBackgroundColor: '#4e73df',
                        pointBorderColor: '#4e73df',
                        pointHoverRadius: 3,
                        pointHoverBackgroundColor: '#4e73df',
                        pointHoverBorderColor: '#4e73df',
                        pointHitRadius: 10,
                        pointBorderWidth: 2,
                        fill: true
                    }]
                },
                options: {
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });

            // Queue Chart
            const queueCtx = document.getElementById('queueChart').getContext('2d');
            new Chart(queueCtx, {
                type: 'doughnut',
                data: {
                    labels: chartData.queue.labels,
                    datasets: [{
                        data: chartData.queue.data,
                        backgroundColor: ['#4e73df', '#1cc88a', '#36b9cc'],
                        hoverBackgroundColor: ['#2e59d9', '#17a673', '#2c9faf'],
                        hoverBorderColor: "rgba(234, 236, 244, 1)",
                    }]
                },
                options: {
                    maintainAspectRatio: false,
                    cutout: '80%',
                    plugins: {
                        legend: {
                            display: true,
                            position: 'bottom'
                        }
                    }
                }
            });
        }

        function switchTab(tabName) {
            document.querySelectorAll('.tab-button').forEach(btn => btn.classList.remove('active'));
            document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));
            
            document.querySelector(`[data-tab="${tabName}"]`).classList.add('active');
            document.getElementById(`${tabName}Content`).classList.add('active');
            
            // Load data based on selected tab
            loadTabData(tabName);
        }

        function exportTransactions() {
            const format = document.getElementById('exportFormat').value;
            const startDate = document.getElementById('startDate').value;
            const endDate = document.getElementById('endDate').value;
            
            window.location.href = `${pageContext.request.contextPath}/admin/transactions/export?format=${format}&startDate=${startDate}&endDate=${endDate}`;
        }

        document.addEventListener('DOMContentLoaded', function() {
            initializeCharts();
            // Set up real-time updates
            setInterval(updateDashboard, 30000); // Update every 30 seconds
        });

        function updateDashboard() {
            fetch(`${pageContext.request.contextPath}/admin/dashboard/stats`)
                .then(response => response.json())
                .then(data => {
                    // Update statistics
                    updateStats(data);
                    // Update charts
                    updateCharts(data);
                    // Update notifications
                    updateNotifications(data);
                });
        }
    </script>
</body>
</html> 