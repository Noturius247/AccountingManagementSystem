<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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

        /* Main content area */
        .main-content {
            margin-left: 250px;
            padding: 2rem;
            transition: margin-left 0.3s ease;
            min-height: 100vh;
            background: #fff;
            position: relative;
        }

        .content-header {
            margin-bottom: 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        /* Content sections */
        .content-section {
            display: none;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .content-section.active {
            display: block;
            opacity: 1;
        }

        /* Responsive sidebar behavior */
        @media (max-width: 768px) {
            .sidebar {
                width: 250px;
                transform: translateX(-100%);
                transition: transform 0.3s ease-in-out;
                position: fixed;
                top: 0;
                left: 0;
                height: 100vh;
                z-index: 1040;
                box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
            }
            
            .sidebar.show {
                transform: translateX(0);
            }
            
            .main-content {
                margin-left: 0;
                width: 100%;
                padding: 1rem;
                transition: margin-left 0.3s ease-in-out;
            }
            
            body.sidebar-visible .main-content {
                margin-left: 0;
            }

            .content-section {
                margin-top: 1rem;
            }
        }

        /* Table styles */
        .table {
            width: 100%;
            margin-bottom: 1rem;
            background-color: transparent;
            border-collapse: collapse;
        }

        .table th,
        .table td {
            padding: 0.75rem;
            vertical-align: middle;
            border-top: 1px solid #dee2e6;
        }

        .table thead th {
            vertical-align: bottom;
            border-bottom: 2px solid #dee2e6;
            background-color: #f8f9fa;
        }

        .table tbody tr:hover {
            background-color: rgba(0, 0, 0, 0.075);
        }

        /* Card styles */
        .card {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin-bottom: 1.5rem;
        }

        .card-header {
            padding: 1rem 1.5rem;
            background: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
            border-radius: 8px 8px 0 0;
        }

        .card-body {
            padding: 1.5rem;
        }

        /* Form controls */
        .form-control {
            border-radius: 4px;
            border: 1px solid #ced4da;
            padding: 0.375rem 0.75rem;
        }

        .form-control:focus {
            border-color: #80bdff;
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
        }

        /* Button styles */
        .btn {
            padding: 0.375rem 0.75rem;
            border-radius: 4px;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .btn-primary:hover {
            background-color: var(--primary-dark);
            border-color: var(--primary-dark);
        }

        /* Status badges */
        .badge {
            padding: 0.35em 0.65em;
            font-size: 0.75em;
            font-weight: 500;
            border-radius: 4px;
        }

        .bg-success {
            background-color: #28a745 !important;
        }

        .bg-danger {
            background-color: #dc3545 !important;
        }

        /* Search and filter controls */
        .search-box {
            margin-bottom: 1rem;
        }

        .filter-controls {
            display: flex;
            gap: 1rem;
            margin-bottom: 1rem;
        }

        /* Pagination */
        .pagination {
            margin: 1rem 0 0;
            justify-content: center;
        }

        .page-link {
            padding: 0.375rem 0.75rem;
            color: var(--primary-color);
            background-color: #fff;
            border: 1px solid #dee2e6;
        }

        .page-item.active .page-link {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        /* Modal styles */
        .modal-content {
            border-radius: 8px;
            border: none;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .modal-header {
            border-bottom: 1px solid #dee2e6;
            background: #f8f9fa;
            border-radius: 8px 8px 0 0;
        }

        .modal-footer {
            border-top: 1px solid #dee2e6;
            background: #f8f9fa;
            border-radius: 0 0 8px 8px;
        }

        /* Loading spinner */
        .loading-spinner {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 200px;
            width: 100%;
        }

        .loading-spinner::after {
            content: '';
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

        .monitor-card {
            padding: 1rem;
            border-radius: 0.5rem;
            background-color: var(--light-color);
        }

        .monitor-card h6 {
            margin-bottom: 0.5rem;
            color: var(--text-color);
        }

        .activity-timeline {
            position: relative;
            padding-left: 1rem;
        }

        .timeline-item {
            position: relative;
            padding-bottom: 1rem;
        }

        .timeline-marker {
            position: absolute;
            left: -0.5rem;
            top: 0.5rem;
            width: 1rem;
            height: 1rem;
            border-radius: 50%;
        }

        .timeline-marker.info {
            background-color: var(--info-color);
        }

        .timeline-marker.warning {
            background-color: var(--warning-color);
        }

        .timeline-marker.error {
            background-color: var(--danger-color);
        }

        .timeline-content {
            padding-left: 1rem;
        }

        .metrics-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
        }

        .metric-card {
            padding: 1rem;
            border-radius: 0.5rem;
            background-color: var(--light-color);
        }

        .metric-value {
            font-size: 1.5rem;
            font-weight: 600;
            margin: 0.5rem 0;
        }

        .metric-trend {
            display: flex;
            align-items: center;
            font-size: 0.875rem;
        }

        .metric-trend.up {
            color: var(--success-color);
        }

        .metric-trend.down {
            color: var(--danger-color);
        }

        /* Progress width classes */
        [class^="progress-width-"] {
            width: 0%;
            transition: width 0.3s ease;
        }
        .progress-width-0 { width: 0%; }
        .progress-width-1 { width: 1%; }
        .progress-width-2 { width: 2%; }
        /* ... and so on up to 100% */
        .progress-width-100 { width: 100%; }
    </style>
</head>
<body>
    <%@ include file="../includes/admin-sidebar.jsp" %>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Add Sidebar Toggle Button -->
        <button id="sidebarToggle" class="btn btn-link d-md-none position-fixed" style="top: 10px; left: 10px; z-index: 1050;">
            <i class="bi bi-list fs-4"></i>
        </button>
        
        <div class="content-header">
            <h1 id="page-title">Dashboard</h1>
            <div class="header-actions" id="dashboard-actions">
                <button class="btn btn-primary" onclick="exportDashboardData()">
                    <i class="bi bi-download"></i> Export
                </button>
                <button class="btn btn-secondary" onclick="refreshDashboard()">
                    <i class="bi bi-arrow-clockwise"></i> Refresh
                </button>
            </div>
        </div>

        <div class="admin-dashboard">
            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">
                    ${error}
                </div>
            </c:if>

            <div class="row">
                <!-- Statistics Cards -->
                <div class="col-md-3">
                    <div class="stat-card">
                        <h3>Total Users</h3>
                        <p>${not empty totalUsers ? totalUsers : 0}</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <h3>Active Users</h3>
                        <p>${not empty activeUsers ? activeUsers : 0}</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <h3>Total Revenue</h3>
                        <p><fmt:formatNumber value="${not empty totalRevenue ? totalRevenue : 0}" type="currency"/></p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <h3>Pending Queues</h3>
                        <p>${not empty pendingQueues ? pendingQueues : 0}</p>
                    </div>
                </div>
            </div>

            <div class="row mt-4">
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header">
                            <h5>Recent Transactions</h5>
                        </div>
                        <div class="card-body">
                            <canvas id="transactionChart"></canvas>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header">
                            <h5>Queue Statistics</h5>
                        </div>
                        <div class="card-body">
                            <canvas id="queueChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row mt-4">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h5>User Management</h5>
                        </div>
                        <div class="card-body">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Username</th>
                                        <th>Email</th>
                                        <th>Role</th>
                                        <th>Created</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${users}" var="user">
                                        <tr>
                                            <td>${user.username}</td>
                                            <td>${user.email}</td>
                                            <td>${user.role}</td>
                                            <td>${fn:substring(user.createdAt.toString(), 0, 10)}</td>
                                            <td>
                                                <span class="badge ${user.enabled ? 'bg-success' : 'bg-danger'}">
                                                    ${user.enabled ? 'Active' : 'Inactive'}
                                                </span>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/admin/users/${user.id}" 
                                                   class="btn btn-sm btn-primary">View</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                            
                            <c:if test="${totalPages > 1}">
                                <nav>
                                    <ul class="pagination justify-content-center">
                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                <a class="page-link" href="?page=${i}&size=${size}">${i}</a>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </nav>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Real-time Monitoring Section -->
            <div class="row mb-4">
                <div class="col-md-12">
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5>System Health Monitor</h5>
                            <div class="monitor-status">
                                <span class="badge bg-success">Live</span>
                                <small class="text-muted ms-2">Last updated: <span id="lastUpdate">Just now</span></small>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-3">
                                    <div class="monitor-card">
                                        <h6>CPU Usage</h6>
                                        <div class="progress">
                                            <div class="progress-bar" role="progressbar" class="progress-width-${cpuUsage}"></div>
                                        </div>
                                        <small class="text-muted">${cpuUsage}%</small>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="monitor-card">
                                        <h6>Memory Usage</h6>
                                        <div class="progress">
                                            <div class="progress-bar" role="progressbar" class="progress-width-${memoryUsage}"></div>
                                        </div>
                                        <small class="text-muted">${memoryUsage}%</small>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="monitor-card">
                                        <h6>Disk Space</h6>
                                        <div class="progress">
                                            <div class="progress-bar" role="progressbar" class="progress-width-${diskUsage}"></div>
                                        </div>
                                        <small class="text-muted">${diskUsage}%</small>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="monitor-card">
                                        <h6>Active Sessions</h6>
                                        <div class="d-flex align-items-center">
                                            <span class="h4 mb-0">${activeSessions}</span>
                                            <small class="text-muted ms-2">/ ${maxSessions} max</small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Advanced Analytics Section -->
            <div class="row mb-4">
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header">
                            <h5>User Activity Analytics</h5>
                        </div>
                        <div class="card-body">
                            <canvas id="userActivityChart"></canvas>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header">
                            <h5>Transaction Analytics</h5>
                        </div>
                        <div class="card-body">
                            <canvas id="transactionChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Activity Section -->
            <div class="row">
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header">
                            <h5>Recent System Events</h5>
                        </div>
                        <div class="card-body">
                            <div class="activity-timeline">
                                <c:forEach items="${recentEvents}" var="event">
                                    <div class="timeline-item">
                                        <div class="timeline-marker ${event.type}"></div>
                                        <div class="timeline-content">
                                            <h6>${event.title}</h6>
                                            <p class="mb-0">${event.description}</p>
                                            <small class="text-muted">
                                                <fmt:formatDate value="${event.timestamp}" pattern="MMM dd, yyyy HH:mm:ss"/>
                                            </small>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header">
                            <h5>Performance Metrics</h5>
                        </div>
                        <div class="card-body">
                            <div class="metrics-grid">
                                <div class="metric-card">
                                    <h6>Response Time</h6>
                                    <p class="metric-value">${avgResponseTime}ms</p>
                                    <div class="metric-trend ${responseTimeTrend != null && responseTimeTrend >= 0 ? 'up' : 'down'}">
                                        <i class="bi bi-arrow-${responseTimeTrend != null && responseTimeTrend >= 0 ? 'up' : 'down'}"></i>
                                        <span>${responseTimeTrend != null && responseTimeTrend != 0 ? Math.abs(responseTimeTrend) : 0}%</span>
                                    </div>
                                </div>
                                <div class="metric-card">
                                    <h6>Error Rate</h6>
                                    <p class="metric-value">${errorRate}%</p>
                                    <div class="metric-trend ${errorRateTrend != null && errorRateTrend >= 0 ? 'up' : 'down'}">
                                        <i class="bi bi-arrow-${errorRateTrend != null && errorRateTrend >= 0 ? 'up' : 'down'}"></i>
                                        <span>${errorRateTrend != null && errorRateTrend != 0 ? Math.abs(errorRateTrend) : 0}%</span>
                                    </div>
                                </div>
                                <div class="metric-card">
                                    <h6>Throughput</h6>
                                    <p class="metric-value">${throughput}/s</p>
                                    <div class="metric-trend ${throughputTrend != null && throughputTrend >= 0 ? 'up' : 'down'}">
                                        <i class="bi bi-arrow-${throughputTrend != null && throughputTrend >= 0 ? 'up' : 'down'}"></i>
                                        <span>${throughputTrend != null && throughputTrend != 0 ? Math.abs(throughputTrend) : 0}%</span>
                                    </div>
                                </div>
                                <div class="metric-card">
                                    <h6>Uptime</h6>
                                    <p class="metric-value">${uptime}%</p>
                                    <div class="progress">
                                        <div class="progress-bar" role="progressbar" class="progress-width-${uptime}"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Add User Modal -->
    <div class="modal fade" id="addUserModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="addUserForm">
                        <div class="form-group">
                            <label class="form-label">Username</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-user"></i></span>
                                <input type="text" class="form-control" name="username" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Email</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                                <input type="email" class="form-control" name="email" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Password</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                <input type="password" class="form-control" name="password" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Role</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-user-tag"></i></span>
                                <select class="form-select" name="role" required>
                                    <option value="USER">User</option>
                                    <option value="MANAGER">Manager</option>
                                    <option value="ADMIN">Admin</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" name="enabled" checked>
                                <label class="form-check-label">Active Account</label>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="submitAddUser()">Add User</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Upgrade User Role Modal -->
    <div class="modal fade" id="upgradeUserModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Upgrade User Role</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="upgradeUserForm">
                        <input type="hidden" id="upgradeUsername" name="username">
                        <div class="form-group">
                            <label class="form-label">Current Role</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-user-tag"></i></span>
                                <input type="text" class="form-control" id="currentRole" readonly>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">New Role</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-level-up-alt"></i></span>
                                <select class="form-select" id="newRole" name="role" required>
                                    <option value="STUDENT">Student</option>
                                    <option value="MANAGER">Manager</option>
                                    <option value="ADMIN">Admin</option>
                                </select>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="submitUpgradeUser()">Upgrade Role</button>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="../includes/footer.jsp" %>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <script>
        // Page state management
        const pageState = {
            currentSection: 'dashboard',
            sidebarVisible: true,
            loadedSections: new Set(['dashboard'])
        };

        // Initialize on page load
        document.addEventListener('DOMContentLoaded', function() {
            initializePage();
            showCurrentSection();
        });

        function initializePage() {
            const sidebarLinks = document.querySelectorAll('.sidebar-link');
            const sidebarToggle = document.getElementById('sidebarToggle');
            
            // Setup sidebar link handlers
            sidebarLinks.forEach(link => {
                link.addEventListener('click', function(e) {
                    e.preventDefault();
                    const section = this.getAttribute('data-section');
                    switchSection(section);
                    updateActiveLink(this);
                });
            });

            // Setup sidebar toggle for mobile
            if (sidebarToggle) {
                sidebarToggle.addEventListener('click', toggleSidebar);
            }

            // Handle clicks outside sidebar on mobile
            document.addEventListener('click', function(e) {
                if (window.innerWidth <= 768) {
                    const sidebar = document.querySelector('.sidebar');
                    const sidebarToggle = document.getElementById('sidebarToggle');
                    
                    if (!sidebar.contains(e.target) && 
                        !sidebarToggle.contains(e.target) && 
                        sidebar.classList.contains('show')) {
                        toggleSidebar();
                    }
                }
            });

            // Handle window resize
            window.addEventListener('resize', function() {
                if (window.innerWidth > 768) {
                    const sidebar = document.querySelector('.sidebar');
                    sidebar.classList.remove('show');
                    document.body.classList.remove('sidebar-visible');
                }
            });
        }

        function switchSection(section) {
            // Hide all sections
            document.querySelectorAll('.content-section').forEach(s => {
                s.classList.remove('active');
            });

            // Show selected section
            const targetSection = document.getElementById(`${section}-section`);
            if (targetSection) {
                targetSection.classList.add('active');
                document.getElementById('page-title').textContent = 
                    section.charAt(0).toUpperCase() + section.slice(1) + ' Management';
                
                // Update URL without page reload
                const newUrl = `${window.location.pathname}#${section}`;
                window.history.pushState({}, '', newUrl);
                
                // Update state
                pageState.currentSection = section;
                
                // Initialize section if needed
                if (!pageState.loadedSections.has(section)) {
                    initializeSection(section);
                    pageState.loadedSections.add(section);
                }
            }
        }

        function updateActiveLink(clickedLink) {
            document.querySelectorAll('.sidebar-link').forEach(link => {
                link.classList.remove('active');
            });
            clickedLink.classList.add('active');
        }

        function toggleSidebar() {
            const sidebar = document.querySelector('.sidebar');
            const mainContent = document.querySelector('.main-content');
            
            sidebar.classList.toggle('show');
            document.body.classList.toggle('sidebar-visible');
            
            pageState.sidebarVisible = sidebar.classList.contains('show');
            mainContent.style.marginLeft = pageState.sidebarVisible ? '250px' : '0';
        }

        function showCurrentSection() {
            const hash = window.location.hash.slice(1) || 'dashboard';
            const section = hash || pageState.currentSection;
            const sidebarLink = document.querySelector(`[data-section="${section}"]`);
            
            if (sidebarLink) {
                switchSection(section);
                updateActiveLink(sidebarLink);
            }
        }

        // Section-specific initializations
        function initializeSection(section) {
            switch(section) {
                case 'dashboard':
                    initializeCharts();
                    break;
                case 'users':
                    initializeUserManagement();
                    break;
                case 'transactions':
                    initializeTransactions();
                    break;
                case 'queue':
                    initializeQueue();
                    break;
                case 'student':
                    initializeStudentManagement();
                    break;
                case 'reports':
                    initializeReports();
                    break;
                case 'settings':
                    initializeSettings();
                    break;
            }
        }

        function initializeCharts() {
            if (!pageState.loadedSections.has('dashboard')) {
                const transactionChart = document.getElementById('transactionChart');
                const queueChart = document.getElementById('queueChart');
                
                if (transactionChart) {
                    new Chart(transactionChart, {
                        type: 'line',
                        data: {
                            labels: JSON.parse('${transactionLabels}'),
                            datasets: [{
                                label: 'Transactions',
                                data: JSON.parse('${transactionData}'),
                                borderColor: 'rgb(75, 192, 192)',
                                tension: 0.1
                            }]
                        }
                    });
                }
                
                if (queueChart) {
                    new Chart(queueChart, {
                        type: 'bar',
                        data: {
                            labels: JSON.parse('${queueLabels}'),
                            datasets: [{
                                label: 'Queues',
                                data: JSON.parse('${queueData}'),
                                backgroundColor: 'rgba(54, 162, 235, 0.5)'
                            }]
                        }
                    });
                }
            }
        }

        function initializeUserManagement() {
            // Initialize user-specific features
            const userSearch = document.getElementById('userSearch');
            const roleFilter = document.getElementById('roleFilter');
            const statusFilter = document.getElementById('statusFilter');
            
            if (userSearch) userSearch.addEventListener('input', searchUsers);
            if (roleFilter) roleFilter.addEventListener('change', filterUsers);
            if (statusFilter) statusFilter.addEventListener('change', filterUsers);
        }

        function initializeTransactions() {
            // Initialize transaction-specific features
            const dateRange = document.getElementById('transactionDateRange');
            if (dateRange) {
                dateRange.addEventListener('change', function() {
                    loadTransactions(this.value);
                });
            }
        }

        function initializeQueue() {
            // Initialize queue-specific features
            const queueRefresh = document.getElementById('queueRefresh');
            if (queueRefresh) {
                queueRefresh.addEventListener('click', function() {
                    loadQueueData();
                });
            }
        }

        function initializeStudentManagement() {
            // Initialize student-specific features
            const studentSearch = document.getElementById('studentSearch');
            if (studentSearch) {
                studentSearch.addEventListener('input', searchStudents);
            }
        }

        function initializeReports() {
            // Initialize reports-specific features
            const reportType = document.getElementById('reportType');
            if (reportType) {
                reportType.addEventListener('change', updateReportOptions);
            }
        }

        function initializeSettings() {
            // Initialize settings-specific features
            const settingsForms = document.querySelectorAll('.settings-form');
            settingsForms.forEach(form => {
                form.addEventListener('submit', function(e) {
                    e.preventDefault();
                    saveSettings(this);
                });
            });
        }

        // Utility functions
        function showLoadingSpinner(element) {
            element.innerHTML = '<div class="loading-spinner"></div>';
        }

        function handleError(element, error) {
            element.innerHTML = `
                <div class="alert alert-danger">
                    ${error.message}
                    <button onclick="retryOperation()" class="btn btn-link">Retry</button>
                </div>
            `;
        }

        function executeScripts(element) {
            const scripts = element.getElementsByTagName("script");
            for (let i = 0; i < scripts.length; i++) {
                const script = scripts[i];
                const scriptClone = document.createElement('script');
                scriptClone.text = script.innerHTML;
                script.parentNode.replaceChild(scriptClone, script);
            }
        }

        // Export this function for external use
        window.refreshDashboard = function() {
            const currentSection = pageState.currentSection;
            switchSection(currentSection);
        };

        // Initialize charts
        document.addEventListener('DOMContentLoaded', function() {
            // User Activity Chart
            const userActivityCtx = document.getElementById('userActivityChart').getContext('2d');
            new Chart(userActivityCtx, {
                type: 'line',
                data: {
                    labels: JSON.parse('${userActivityLabels}'),
                    datasets: [{
                        label: 'Active Users',
                        data: JSON.parse('${userActivityData}'),
                        borderColor: 'rgb(75, 192, 192)',
                        tension: 0.1
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'top',
                        }
                    }
                }
            });

            // Transaction Chart
            const transactionCtx = document.getElementById('transactionChart').getContext('2d');
            new Chart(transactionCtx, {
                type: 'bar',
                data: {
                    labels: JSON.parse('${transactionLabels}'),
                    datasets: [{
                        label: 'Transactions',
                        data: JSON.parse('${transactionData}'),
                        backgroundColor: 'rgba(54, 162, 235, 0.5)'
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'top',
                        }
                    }
                }
            });
        });

        // Real-time updates
        function updateDashboard() {
            fetch('${pageContext.request.contextPath}/admin/dashboard/status')
                .then(response => response.json())
                .then(data => {
                    updateSystemHealth(data);
                    updateCharts(data);
                    document.getElementById('lastUpdate').textContent = 'Just now';
                });
        }

        // Set up periodic updates
        setInterval(updateDashboard, 30000); // Update every 30 seconds

        function refreshDashboard() {
            location.reload();
        }

        function exportReport() {
            window.location.href = '${pageContext.request.contextPath}/admin/dashboard/export';
        }
    </script>
</body>
</html> 