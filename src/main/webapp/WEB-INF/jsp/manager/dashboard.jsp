<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manager Dashboard - Accounting Management System</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/static/css/main.css" rel="stylesheet">
    
    <style>
        /* Dashboard-specific styles */
        .manager-dashboard {
            padding: 2rem;
            max-width: 1200px;
            margin: 0 auto;
        }

        .chart-container {
            height: 300px;
            margin-bottom: 2rem;
        }

        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 500;
        }

        .status-pending { background: var(--warning-bg); color: var(--warning-text); }
        .status-completed { background: var(--success-bg); color: var(--success-text); }
        .status-failed { background: var(--danger-bg); color: var(--danger-text); }
        .status-processing { background: var(--info-bg); color: var(--info-text); }

        .stat-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius);
            padding: 1.5rem;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .action-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius);
            padding: 1.5rem;
            margin-bottom: 1rem;
            transition: transform 0.2s ease;
        }

        .action-card:hover {
            transform: translateY(-2px);
        }

        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .btn-primary:hover {
            background-color: var(--primary-dark);
            border-color: var(--primary-dark);
        }

        .table {
            --bs-table-hover-bg: var(--hover-bg);
        }
    </style>
</head>
<body>
    <%@ include file="../includes/manager-header.jsp" %>

    <div class="container-fluid">
        <div id="main-content">
            <!-- Main Content Section -->
            <div id="dashboard-content">
                <!-- Welcome Section -->
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Manager Dashboard</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2">
                            <button type="button" class="btn btn-primary" onclick="refreshDashboard()">
                                <i class="bi bi-arrow-clockwise me-1"></i> Refresh
                            </button>
                            <button type="button" class="btn btn-sm btn-outline-secondary" onclick="exportReport()">
                                <i class="bi bi-download me-1"></i> Export Report
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Statistics Cards -->
                <div class="row row-cols-1 row-cols-md-4 g-4 mb-4">
                    <div class="col">
                        <div class="card h-100 border-primary">
                            <div class="card-body">
                                <h5 class="card-title text-primary">Total Transactions</h5>
                                <p class="card-text display-6">${totalTransactions}</p>
                                <div class="trend">
                                    <i class="bi bi-arrow-up text-success"></i> 12% from last month
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col">
                        <div class="card h-100 border-warning">
                            <div class="card-body">
                                <h5 class="card-title text-warning">Pending Approvals</h5>
                                <p class="card-text display-6">${pendingApprovals}</p>
                                <div class="trend">
                                    <i class="bi bi-arrow-down text-danger"></i> 5% from last week
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col">
                        <div class="card h-100 border-success">
                            <div class="card-body">
                                <h5 class="card-title text-success">Active Users</h5>
                                <p class="card-text display-6">${activeUsers}</p>
                                <div class="trend">
                                    <i class="bi bi-arrow-up text-success"></i> 8% from yesterday
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col">
                        <div class="card h-100 border-info">
                            <div class="card-body">
                                <h5 class="card-title text-info">Revenue</h5>
                                <p class="card-text display-6"><fmt:formatNumber value="${revenue}" type="currency"/></p>
                                <div class="trend">
                                    <i class="bi bi-arrow-up text-success"></i> 15% from last month
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Transactions Section -->
                <div class="card mb-4">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Recent Transactions</h5>
                        <div class="btn-group">
                            <button class="btn btn-primary btn-sm">
                                <i class="bi bi-eye me-1"></i> View All
                            </button>
                            <button class="btn btn-secondary btn-sm">
                                <i class="bi bi-funnel me-1"></i> Filter
                            </button>
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
                                                <fmt:parseDate value="${transaction.createdAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate" />
                                                <fmt:formatDate value="${parsedDate}" pattern="MMM,dd,yyyy" />
                                            </td>
                                            <td>${transaction.type}</td>
                                            <td><fmt:formatNumber value="${transaction.amount}" type="currency"/></td>
                                            <td>
                                                <span class="badge ${transaction.status == 'COMPLETED' ? 'bg-success' : 'bg-warning'}">
                                                    ${transaction.status}
                                                </span>
                                            </td>
                                            <td>
                                                <button class="btn btn-sm btn-action btn-info" onclick="viewDetails(${transaction.id})" title="View Details">
                                                    <i class="bi bi-eye"></i>
                                                </button>
                                                <button class="btn btn-sm btn-action btn-primary" onclick="editTransaction(${transaction.id})" title="Edit">
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
    </div>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom JavaScript -->
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html> 