<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="t" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - Accounting Management System</title>
    
    <!-- CSS Dependencies -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/main.css" rel="stylesheet">
    
    <!-- JavaScript Dependencies -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <style>
        :root {
            --primary-color: #3498db;
            --secondary-color: #2ecc71;
            --success-color: #2ecc71;
            --danger-color: #e74c3c;
            --warning-color: #f39c12;
            --info-color: #17a2b8;
            --dark-color: #2c3e50;
            --light-color: #ecf0f1;
            --border-color: #dee2e6;
            --text-color: #212529;
            --shadow-sm: 0 2px 4px rgba(0,0,0,0.1);
            --shadow-md: 0 4px 6px rgba(0,0,0,0.1);
            --shadow-lg: 0 10px 15px rgba(0,0,0,0.1);
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: #f5f5f5;
        }

        #main-content {
            transition: opacity 0.3s ease-in-out;
            min-height: calc(100vh - 120px);
            padding: 2rem 0;
        }

        .loading {
            opacity: 0.6;
            pointer-events: none;
        }

        .loading::after {
            content: '';
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 40px;
            height: 40px;
            border: 4px solid #f3f3f3;
            border-top: 4px solid var(--primary-color);
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: translate(-50%, -50%) rotate(0deg); }
            100% { transform: translate(-50%, -50%) rotate(360deg); }
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

        .registration-card {
            background: white;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 15px;
            border-left: 4px solid var(--warning-color);
        }

        .registration-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .student-details {
            margin-bottom: 15px;
        }

        .student-details p {
            margin: 5px 0;
            color: var(--dark-color);
        }

        .registration-actions {
            display: flex;
            gap: 10px;
        }

        .registration-table {
            margin-top: 2rem;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        .table-responsive {
            border-radius: 8px;
            overflow: hidden;
        }
        .action-buttons {
            display: flex;
            gap: 0.5rem;
        }
        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 4px;
            font-weight: 500;
        }
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }

        /* Dashboard Layout */
        .dashboard-container {
            padding: 1.5rem;
            background-color: #f8f9fc;
        }

        /* Stats Cards */
        .card {
            margin-bottom: 1.5rem;
            border: none;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
        }

        .card-header {
            background-color: #f8f9fc;
            border-bottom: 1px solid #e3e6f0;
        }

        .border-left-primary {
            border-left: 0.25rem solid #4e73df !important;
        }

        .border-left-success {
            border-left: 0.25rem solid #1cc88a !important;
        }

        .border-left-warning {
            border-left: 0.25rem solid #f6c23e !important;
        }

        .border-left-info {
            border-left: 0.25rem solid #36b9cc !important;
        }

        /* Text Styles */
        .text-xs {
            font-size: .7rem;
        }

        .text-primary {
            color: #4e73df !important;
        }

        .text-success {
            color: #1cc88a !important;
        }

        .text-warning {
            color: #f6c23e !important;
        }

        .text-info {
            color: #36b9cc !important;
        }

        /* Table Styles */
        .table-responsive {
            border-radius: 0.35rem;
            overflow: hidden;
        }

        .table {
            margin-bottom: 0;
        }

        .table thead th {
            background-color: #f8f9fc;
            border-top: none;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.8rem;
            color: #4e73df;
        }

        .table td {
            vertical-align: middle;
        }

        /* Badge Styles */
        .badge {
            padding: 0.5rem 0.75rem;
            font-size: 0.75rem;
            font-weight: 600;
            border-radius: 0.35rem;
        }

        .bg-warning {
            background-color: #f6c23e !important;
            color: #fff;
        }

        .bg-success {
            background-color: #1cc88a !important;
            color: #fff;
        }

        .bg-danger {
            background-color: #e74a3b !important;
            color: #fff;
        }

        /* Button Styles */
        .btn-group {
            display: flex;
            gap: 0.5rem;
        }

        .btn-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
            line-height: 1.5;
            border-radius: 0.2rem;
        }

        .btn-success {
            background-color: #1cc88a;
            border-color: #1cc88a;
        }

        .btn-danger {
            background-color: #e74a3b;
            border-color: #e74a3b;
        }

        /* Modal Styles */
        .modal-content {
            border-radius: 0.35rem;
            border: none;
        }

        .modal-header {
            background-color: #4e73df;
            color: white;
            border-top-left-radius: 0.35rem;
            border-top-right-radius: 0.35rem;
        }

        .modal-footer {
            border-top: 1px solid #e3e6f0;
        }

        /* Custom Dashboard Header */
        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .dashboard-header h1 {
            color: #5a5c69;
            font-size: 1.75rem;
            font-weight: 400;
            margin: 0;
        }

        .dashboard-actions {
            display: flex;
            gap: 1rem;
        }

        /* Utility Classes */
        .shadow {
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15) !important;
        }

        .font-weight-bold {
            font-weight: 700 !important;
        }

        .mb-4 {
            margin-bottom: 1.5rem !important;
        }

        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .dashboard-container {
                padding: 1rem;
            }

            .dashboard-header {
                flex-direction: column;
                gap: 1rem;
                text-align: center;
            }

            .card {
                margin-bottom: 1rem;
            }
        }

        .progress-width-dynamic {
            width: var(--progress-width);
        }
    </style>
</head>
<body>
    <%@ include file="../includes/manager-header.jsp" %>

    <div class="container-fluid">
        <div class="row">
            <main class="col-md-12 ms-sm-auto px-md-4">
                <div id="main-content">
                    <!-- Dashboard Content -->
                    <div class="manager-dashboard">
                        <div class="dashboard-header">
                            <h1>Manager Dashboard</h1>
                            <div class="notification-bell">
                                <i class="bi bi-bell"></i>
                                <c:if test="${pendingCount > 0}">
                                    <span class="notification-count">${pendingCount}</span>
                                </c:if>
                            </div>
                        </div>

                        <div class="error-message" id="errorMessage"></div>
                        <div class="success-message" id="successMessage"></div>
                        
                        <div class="stats-grid">
                            <div class="stat-card">
                                <h3>Total Revenue</h3>
                                <div class="value">$${totalRevenue}</div>
                                <div class="trend ${revenueGrowth != null && revenueGrowth >= 0 ? '' : 'down'}">
                                    <i class="fas fa-${revenueGrowth != null && revenueGrowth >= 0 ? 'arrow-up' : 'arrow-down'}"></i>
                                    ${revenueGrowth != null ? Math.abs(revenueGrowth) : 0}% from last month
                                </div>
                            </div>
                            <div class="stat-card">
                                <h3>Pending Approvals</h3>
                                <div class="value">${pendingApprovals}</div>
                            </div>
                            <div class="stat-card">
                                <h3>Active Users</h3>
                                <div class="value">${activeUsers}</div>
                                <div class="trend">
                                    <i class="fas fa-arrow-up"></i>
                                    ${userGrowth}% increase
                                </div>
                            </div>
                            <div class="stat-card">
                                <h3>System Health</h3>
                                <div class="value">${systemHealth}%</div>
                                <div class="progress">
                                    <div class="progress-bar progress-width-dynamic" role="progressbar" data-width="${systemHealth}"></div>
                                </div>
                            </div>
                            <div class="stat-card">
                                <h3>Pending Registrations</h3>
                                <div class="value">${pendingCount}</div>
                                <div class="trend">
                                    <i class="bi bi-people"></i>
                                    <span>Students Awaiting Approval</span>
                                </div>
                                <a href="${pageContext.request.contextPath}/manager/student-approvals?status=PENDING" class="btn btn-primary mt-3">
                                    View All Pending Registrations
                                </a>
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
                                                            <td>
                                                                ${fn:replace(transaction.createdAt.toString(), 'T', ' ')}
                                                            </td>
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

                        <!-- Statistics Cards -->
                        <div class="row mb-4">
                            <div class="col-xl-3 col-md-6">
                                <div class="card border-left-primary shadow h-100 py-2">
                                    <div class="card-body">
                                        <div class="row no-gutters align-items-center">
                                            <div class="col mr-2">
                                                <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Total Transactions</div>
                                                <div class="h5 mb-0 font-weight-bold text-gray-800">12% from last month</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-xl-3 col-md-6">
                                <div class="card border-left-warning shadow h-100 py-2">
                                    <div class="card-body">
                                        <div class="row no-gutters align-items-center">
                                            <div class="col mr-2">
                                                <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Pending Approvals</div>
                                                <div class="h5 mb-0 font-weight-bold text-gray-800">${pendingCount}</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-xl-3 col-md-6">
                                <div class="card border-left-success shadow h-100 py-2">
                                    <div class="card-body">
                                        <div class="row no-gutters align-items-center">
                                            <div class="col mr-2">
                                                <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Active Users</div>
                                                <div class="h5 mb-0 font-weight-bold text-gray-800">8% from yesterday</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-xl-3 col-md-6">
                                <div class="card border-left-info shadow h-100 py-2">
                                    <div class="card-body">
                                        <div class="row no-gutters align-items-center">
                                            <div class="col mr-2">
                                                <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Revenue</div>
                                                <div class="h5 mb-0 font-weight-bold text-gray-800">15% from last month</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Recent Transactions Section -->
                        <div class="card shadow mb-4">
                            <div class="card-header py-3 d-flex justify-content-between align-items-center">
                                <h6 class="m-0 font-weight-bold text-primary">Recent Transactions</h6>
                                <div>
                                    <button class="btn btn-primary btn-sm" onclick="viewAllTransactions()">View All</button>
                                    <button class="btn btn-warning btn-sm ml-2" onclick="showFilter()">Filter</button>
                                </div>
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
                                                    <td>
                                                        ${fn:replace(transaction.createdAt.toString(), 'T', ' ')}
                                                    </td>
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

                        <!-- Student Registration Card -->
                        <div class="card shadow mb-4">
                            <div class="card-header py-3 d-flex justify-content-between align-items-center bg-primary text-white">
                                <h6 class="m-0 font-weight-bold">Student Registrations</h6>
                                <div>
                                    <span class="badge bg-warning me-2">Pending: ${pendingCount}</span>
                                    <span class="badge bg-success me-2">Approved: ${approvedCount}</span>
                                    <span class="badge bg-danger">Rejected: ${rejectedCount}</span>
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Student ID</th>
                                                <th>Full Name</th>
                                                <th>Program</th>
                                                <th>Year Level</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${students}" var="student">
                                                <tr>
                                                    <td>${student.studentId}</td>
                                                    <td>${student.fullName}</td>
                                                    <td>${student.program}</td>
                                                    <td>${student.yearLevel}</td>
                                                    <td>
                                                        <span class="badge ${student.registrationStatus == 'APPROVED' ? 'bg-success' : 
                                                                          student.registrationStatus == 'PENDING' ? 'bg-warning' : 'bg-danger'}">
                                                            ${student.registrationStatus}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group">
                                                            <a href="${pageContext.request.contextPath}/manager/student-approvals/${student.id}" 
                                                               class="btn btn-sm btn-outline-primary">
                                                                <i class="bi bi-eye"></i> View
                                                            </a>
                                                            <c:choose>
                                                                <c:when test="${student.registrationStatus == 'PENDING'}">
                                                                    <button type="button" 
                                                                            class="btn btn-sm btn-outline-success"
                                                                            onclick="approveStudent('${student.id}')">
                                                                        <i class="bi bi-check"></i> Approve
                                                                    </button>
                                                                    <button type="button" 
                                                                            class="btn btn-sm btn-outline-danger"
                                                                            onclick="rejectStudent('${student.id}')">
                                                                        <i class="bi bi-x"></i> Reject
                                                                    </button>
                                                                </c:when>
                                                                <c:when test="${student.registrationStatus == 'APPROVED'}">
                                                                    <button type="button" 
                                                                            class="btn btn-sm btn-outline-warning"
                                                                            onclick="revokeApproval('${student.id}')">
                                                                        <i class="bi bi-arrow-counterclockwise"></i> Revoke
                                                                    </button>
                                                                </c:when>
                                                            </c:choose>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty students}">
                                                <tr>
                                                    <td colspan="6" class="text-center">
                                                        <div class="p-3">
                                                            <i class="bi bi-inbox fs-4 d-block mb-2"></i>
                                                            <p class="text-muted">No students found</p>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!-- Reject Modal -->
                        <div class="modal fade" id="rejectModal" tabindex="-1">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">Reject Registration</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                    </div>
                                    <form id="rejectForm" action="" method="post">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <div class="modal-body">
                                            <div class="mb-3">
                                                <label for="rejectReason" class="form-label">Reason for Rejection</label>
                                                <textarea class="form-control" id="rejectReason" name="reason" rows="3" required></textarea>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                            <button type="submit" class="btn btn-danger">Reject</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <script>
                            function showRejectForm(studentId) {
                                const modal = new bootstrap.Modal(document.getElementById('rejectModal'));
                                const form = document.getElementById('rejectForm');
                                form.action = '${pageContext.request.contextPath}/manager/student-approvals/' + studentId + '/reject';
                                modal.show();
                            }

                            function approveStudent(studentId) {
                                if (confirm('Are you sure you want to approve this student registration?')) {
                                    fetch(`${pageContext.request.contextPath}/manager/student-approvals/${studentId}/approve`, {
                                        method: 'POST',
                                        headers: {
                                            'Content-Type': 'application/json',
                                            '${_csrf.headerName}': '${_csrf.token}'
                                        }
                                    })
                                    .then(response => {
                                        if (response.ok) {
                                            window.location.reload();
                                        } else {
                                            alert('Failed to approve student registration');
                                        }
                                    });
                                }
                            }

                            function rejectStudent(studentId) {
                                showRejectForm(studentId);
                            }

                            function revokeApproval(studentId) {
                                if (confirm('Are you sure you want to revoke this student\'s approval?')) {
                                    fetch(`${pageContext.request.contextPath}/manager/student-approvals/${studentId}/revoke`, {
                                        method: 'POST',
                                        headers: {
                                            'Content-Type': 'application/json',
                                            '${_csrf.headerName}': '${_csrf.token}'
                                        }
                                    })
                                    .then(response => {
                                        if (response.ok) {
                                            window.location.reload();
                                        } else {
                                            alert('Failed to revoke student approval');
                                        }
                                    });
                                }
                            }
                        </script>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <%@ include file="../includes/footer.jsp" %>

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

    <script>
    // Define context path for use in JavaScript
    const contextPath = '${pageContext.request.contextPath}';
    
    // Pass server-side variables to JavaScript
    window.dashboardData = {
        revenueLabels: '${revenueLabels != null ? revenueLabels : "[]"}',
        revenueData: '${revenueData != null ? revenueData : "[]"}',
        departmentLabels: ['Accounting', 'Sales', 'HR', 'Operations', 'IT'],
        departmentData: [85, 72, 90, 68, 95],
        csrfToken: '${_csrf.token}',
        csrfHeader: '${_csrf.headerName}'
    };
    </script>
    <script src="${pageContext.request.contextPath}/static/js/manager-dashboard.js"></script>
    <script>
        $(document).ready(function() {
            // Initialize Bootstrap components
            initializeBootstrapComponents();
            
            function initializeBootstrapComponents() {
                // Initialize tooltips
                var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                tooltipTriggerList.map(function (tooltipTriggerEl) {
                    return new bootstrap.Tooltip(tooltipTriggerEl);
                });

                // Initialize popovers
                var popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'));
                popoverTriggerList.map(function (popoverTriggerEl) {
                    return new bootstrap.Popover(popoverTriggerEl);
                });

                // Initialize dropdowns
                var dropdownTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="dropdown"]'));
                dropdownTriggerList.map(function (dropdownTriggerEl) {
                    return new bootstrap.Dropdown(dropdownTriggerEl);
                });
            }
        });
    </script>
</body>
</html> 