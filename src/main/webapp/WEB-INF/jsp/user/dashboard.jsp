<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Dashboard - Accounting Management System</title>
    
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
        .user-dashboard {
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
    <%@ include file="../includes/user-header.jsp" %>

    <div class="container-fluid">
        <div class="row">
            <!-- Main Content -->
            <main class="col-md-12 ms-sm-auto px-md-4">
                <!-- Main Content Section -->
                <div id="dashboard-content">
                    <!-- Welcome Section -->
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Welcome, ${user.firstName}!</h1>
                        <div class="btn-toolbar mb-2 mb-md-0">
                            <div class="btn-group me-2">
                                <button type="button" class="btn btn-sm btn-outline-secondary">Export</button>
                                <button type="button" class="btn btn-sm btn-outline-secondary">Print</button>
                            </div>
                        </div>
                    </div>

                    <!-- Student Registration Section -->
                    <c:if test="${not user.student}">
                        <div class="alert alert-info mb-4">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h4 class="alert-heading">Complete Your Student Registration</h4>
                                    <p class="mb-0">To access student services and features, please complete your student registration.</p>
                                </div>
                                <a href="${pageContext.request.contextPath}/student-registration" class="btn btn-primary" data-dynamic>
                                    <i class="bi bi-person-plus me-1"></i> Register as Student
                                </a>
                            </div>
                        </div>
                    </c:if>

                    <!-- Statistics Cards -->
                    <div class="row row-cols-1 row-cols-md-4 g-4 mb-4">
                        <div class="col">
                            <div class="card h-100 border-primary">
                                <div class="card-body">
                                    <h5 class="card-title text-primary">Current Balance</h5>
                                    <p class="card-text display-6">$${currentBalance}</p>
                                </div>
                            </div>
                        </div>
                        <div class="col">
                            <div class="card h-100 border-warning">
                                <div class="card-body">
                                    <h5 class="card-title text-warning">Pending Payments</h5>
                                    <p class="card-text display-6">${pendingPaymentsCount}</p>
                                </div>
                            </div>
                        </div>
                        <div class="col">
                            <div class="card h-100 border-success">
                                <div class="card-body">
                                    <h5 class="card-title text-success">Documents</h5>
                                    <p class="card-text display-6">${fn:length(documents)}</p>
                                </div>
                            </div>
                        </div>
                        <div class="col">
                            <div class="card h-100 border-info">
                                <div class="card-body">
                                    <h5 class="card-title text-info">Notifications</h5>
                                    <p class="card-text display-6">${fn:length(notifications)}</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Transactions -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <i class="bi bi-clock-history me-1"></i> Recent Transactions
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-striped table-hover">
                                    <thead>
                                        <tr>
                                            <th>Date</th>
                                            <th>Transaction ID</th>
                                            <th>Description</th>
                                            <th>Amount</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${recentTransactions}" var="transaction">
                                            <tr>
                                                <td>${fn:substring(transaction.createdAt, 0, 10)}</td>
                                                <td>${transaction.id}</td>
                                                <td>${transaction.notes}</td>
                                                <td>$${transaction.amount}</td>
                                                <td>
                                                    <span class="badge bg-${transaction.status == 'COMPLETED' ? 'success' : 'warning'}">
                                                        ${transaction.status}
                                                    </span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                            <div class="text-end">
                                <a href="${pageContext.request.contextPath}/user/transactions" class="btn btn-primary btn-sm" data-dynamic>
                                    View All Transactions
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Documents -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <i class="bi bi-file-earmark-text me-1"></i> Recent Documents
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-striped table-hover">
                                    <thead>
                                        <tr>
                                            <th>Date</th>
                                            <th>Document Name</th>
                                            <th>Type</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${documents}" var="document" end="4">
                                            <tr>
                                                <td>${fn:substring(document.uploadDate, 0, 10)}</td>
                                                <td>${document.name}</td>
                                                <td>${document.type}</td>
                                                <td>
                                                    <span class="badge bg-${document.status == 'APPROVED' ? 'success' : 'warning'}">
                                                        ${document.status}
                                                    </span>
                                                </td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/user/documents/${document.id}" 
                                                       class="btn btn-primary btn-sm" data-dynamic>
                                                        <i class="bi bi-eye"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                            <div class="text-end">
                                <a href="${pageContext.request.contextPath}/user/documents" class="btn btn-primary btn-sm" data-dynamic>
                                    View All Documents
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 