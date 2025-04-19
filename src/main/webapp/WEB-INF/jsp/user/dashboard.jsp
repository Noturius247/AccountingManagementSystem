<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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
    <%@ include file="../includes/header.jsp" %>

    <div class="container-fluid">
        <div class="row">
            <!-- Main Content -->
            <main class="col-md-12 ms-sm-auto px-md-4">
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
                            <a href="${pageContext.request.contextPath}/student-registration" class="btn btn-primary">
                                <i class="bi bi-person-plus me-1"></i> Register as Student
                            </a>
                        </div>
                    </div>
                </c:if>

                <!-- Statistics Cards -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="stat-card">
                            <div class="stat-icon">
                                <i class="bi bi-receipt text-primary"></i>
                            </div>
                            <div class="stat-info">
                                <h5 class="text-muted mb-2">Total Transactions</h5>
                                <h2 class="mb-0">${statistics.totalTransactions}</h2>
                                <p class="text-muted mb-0">This month</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card">
                            <div class="stat-icon">
                                <i class="bi bi-clock-history text-warning"></i>
                            </div>
                            <div class="stat-info">
                                <h5 class="text-muted mb-2">Pending Payments</h5>
                                <h2 class="mb-0">${statistics.pendingPayments}</h2>
                                <p class="text-muted mb-0">Require attention</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card">
                            <div class="stat-icon">
                                <i class="bi bi-cash-stack text-success"></i>
                            </div>
                            <div class="stat-info">
                                <h5 class="text-muted mb-2">Total Amount</h5>
                                <h2 class="mb-0"><fmt:formatNumber value="${statistics.totalAmount}" type="currency"/></h2>
                                <p class="text-muted mb-0">This month</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card">
                            <div class="stat-icon">
                                <i class="bi bi-file-earmark-text text-info"></i>
                            </div>
                            <div class="stat-info">
                                <h5 class="text-muted mb-2">Documents</h5>
                                <h2 class="mb-0">${statistics.totalDocuments}</h2>
                                <p class="text-muted mb-0">Uploaded files</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Transactions -->
                <div class="card shadow mb-4">
                    <div class="card-header py-3 d-flex justify-content-between align-items-center">
                        <h6 class="m-0 font-weight-bold text-primary">Recent Transactions</h6>
                        <a href="${pageContext.request.contextPath}/user/transactions" class="btn btn-sm btn-primary">
                            View All
                        </a>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
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
                                            <td>
                                                <c:set var="dateStr" value="${transaction.createdAt}" />
                                                <c:choose>
                                                    <c:when test="${not empty dateStr}">
                                                        ${fn:substring(dateStr, 0, 10)}
                                                    </c:when>
                                                    <c:otherwise>
                                                        N/A
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${transaction.type}</td>
                                            <td><fmt:formatNumber value="${transaction.amount}" type="currency"/></td>
                                            <td>
                                                <span class="status-badge status-${fn:toLowerCase(transaction.status)}">
                                                    ${transaction.status}
                                                </span>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/user/transactions/${transaction.id}" 
                                                   class="btn btn-sm btn-outline-primary">
                                                    <i class="bi bi-eye"></i> View
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="row mb-4">
                    <div class="col-md-4">
                        <div class="action-card">
                            <h5 class="card-title">Make a Payment</h5>
                            <p class="card-text text-muted">Pay your pending bills and invoices</p>
                            <a href="${pageContext.request.contextPath}/user/payments/new" class="btn btn-primary">
                                <i class="bi bi-credit-card"></i> Pay Now
                            </a>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="action-card">
                            <h5 class="card-title">Upload Document</h5>
                            <p class="card-text text-muted">Submit required documents and receipts</p>
                            <a href="${pageContext.request.contextPath}/user/documents/upload" class="btn btn-primary">
                                <i class="bi bi-upload"></i> Upload
                            </a>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="action-card">
                            <h5 class="card-title">View Reports</h5>
                            <p class="card-text text-muted">Access your transaction history and reports</p>
                            <a href="${pageContext.request.contextPath}/user/reports" class="btn btn-primary">
                                <i class="bi bi-file-earmark-text"></i> View Reports
                            </a>
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