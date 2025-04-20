<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
    <title>Transaction Management - Accounting System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/main.css" rel="stylesheet">
    <style>
        .transaction-card {
            transition: all 0.3s ease;
            border: none;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
        }
        
        .transaction-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.25);
        }

        .analytics-card {
            height: 100%;
        }

        .chart-container {
            position: relative;
            height: 300px;
            margin-bottom: 1rem;
        }

        .filter-section {
            background-color: #f8f9fc;
            padding: 1rem;
            border-radius: 0.5rem;
            margin-bottom: 1rem;
        }

        .date-range-picker {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .transaction-type-badge {
            padding: 0.5em 1em;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .status-badge {
            padding: 0.5em 1em;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .amount-positive {
            color: #1cc88a;
        }

        .amount-negative {
            color: #e74a3b;
        }

        .export-options {
            display: flex;
            gap: 0.5rem;
        }

        .advanced-filters {
            display: none;
            margin-top: 1rem;
            padding: 1rem;
            background-color: #f8f9fc;
            border-radius: 0.5rem;
        }

        .advanced-filters.show {
            display: block;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <!-- Success Message -->
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="row">
            <!-- Include Admin Sidebar -->
            <%@ include file="../includes/admin-sidebar.jsp" %>
            
            <!-- Main Content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="container-fluid px-4">
                    <!-- Header Section with Stats -->
                    <div class="row mb-4 mt-4">
                        <div class="col-xl-3 col-md-6">
                            <div class="card border-left-primary shadow h-100 py-2">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Total Revenue</div>
                                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                                <fmt:formatNumber value="${totalRevenue}" type="currency"/>
                                            </div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="bi bi-cash-stack fa-2x text-gray-300"></i>
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
                                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Completed Transactions</div>
                                            <div class="h5 mb-0 font-weight-bold text-gray-800">${completedCount}</div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="bi bi-check-circle fa-2x text-gray-300"></i>
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
                                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Pending Transactions</div>
                                            <div class="h5 mb-0 font-weight-bold text-gray-800">${pendingCount}</div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="bi bi-clock-history fa-2x text-gray-300"></i>
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
                                            <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Average Transaction</div>
                                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                                <fmt:formatNumber value="${averageTransaction}" type="currency"/>
                                            </div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="bi bi-graph-up fa-2x text-gray-300"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Analytics Section -->
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <div class="card analytics-card">
                                <div class="card-header">
                                    <h6 class="m-0 font-weight-bold text-primary">Revenue Trend</h6>
                                </div>
                                <div class="card-body">
                                    <div class="chart-container">
                                        <canvas id="revenueChart"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card analytics-card">
                                <div class="card-header">
                                    <h6 class="m-0 font-weight-bold text-primary">Transaction Types</h6>
                                </div>
                                <div class="card-body">
                                    <div class="chart-container">
                                        <canvas id="transactionTypesChart"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Search and Filter Section -->
                    <div class="card shadow mb-4">
                        <div class="card-header py-3 d-flex justify-content-between align-items-center">
                            <h6 class="m-0 font-weight-bold text-primary">Transaction Management</h6>
                            <div class="export-options">
                                <button class="btn btn-outline-primary btn-sm" onclick="exportTransactions('csv')">
                                    <i class="bi bi-file-earmark-excel"></i> Export CSV
                                </button>
                                <button class="btn btn-outline-primary btn-sm" onclick="exportTransactions('pdf')">
                                    <i class="bi bi-file-earmark-pdf"></i> Export PDF
                                </button>
                            </div>
                        </div>
                        <div class="card-body">
                            <form class="row g-3" id="searchForm" method="get">
                                <!-- Basic Filters -->
                                <div class="col-md-3">
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="bi bi-search"></i></span>
                                        <input type="text" class="form-control" name="search" value="${param.search}"
                                               placeholder="Search transactions...">
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <select class="form-select" name="type">
                                        <option value="">All Types</option>
                                        <option value="PAYMENT" ${param.type == 'PAYMENT' ? 'selected' : ''}>Payment</option>
                                        <option value="REFUND" ${param.type == 'REFUND' ? 'selected' : ''}>Refund</option>
                                        <option value="ADJUSTMENT" ${param.type == 'ADJUSTMENT' ? 'selected' : ''}>Adjustment</option>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <select class="form-select" name="status">
                                        <option value="">All Status</option>
                                        <option value="PENDING" ${param.status == 'PENDING' ? 'selected' : ''}>Pending</option>
                                        <option value="COMPLETED" ${param.status == 'COMPLETED' ? 'selected' : ''}>Completed</option>
                                        <option value="FAILED" ${param.status == 'FAILED' ? 'selected' : ''}>Failed</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <div class="date-range-picker">
                                        <input type="date" class="form-control" name="startDate" value="${param.startDate}">
                                        <span>to</span>
                                        <input type="date" class="form-control" name="endDate" value="${param.endDate}">
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <button type="button" class="btn btn-outline-secondary w-100" onclick="toggleAdvancedFilters()">
                                        <i class="bi bi-funnel"></i> Advanced Filters
                                    </button>
                                </div>

                                <!-- Advanced Filters -->
                                <div class="advanced-filters" id="advancedFilters">
                                    <div class="row g-3">
                                        <div class="col-md-3">
                                            <select class="form-select" name="paymentMethod">
                                                <option value="">All Payment Methods</option>
                                                <option value="CASH" ${param.paymentMethod == 'CASH' ? 'selected' : ''}>Cash</option>
                                                <option value="CARD" ${param.paymentMethod == 'CARD' ? 'selected' : ''}>Card</option>
                                                <option value="BANK_TRANSFER" ${param.paymentMethod == 'BANK_TRANSFER' ? 'selected' : ''}>Bank Transfer</option>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <input type="number" class="form-control" name="minAmount" value="${param.minAmount}"
                                                   placeholder="Min Amount">
                                        </div>
                                        <div class="col-md-3">
                                            <input type="number" class="form-control" name="maxAmount" value="${param.maxAmount}"
                                                   placeholder="Max Amount">
                                        </div>
                                        <div class="col-md-3">
                                            <select class="form-select" name="processedBy">
                                                <option value="">All Processors</option>
                                                <c:forEach items="${processors}" var="processor">
                                                    <option value="${processor.id}" ${param.processedBy == processor.id ? 'selected' : ''}>
                                                        ${processor.name}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-12 text-end">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-search"></i> Search
                                    </button>
                                    <button type="button" class="btn btn-outline-secondary" onclick="resetFilters()">
                                        <i class="bi bi-x-lg"></i> Reset
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Transactions Table -->
                    <div class="card shadow mb-4">
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Transaction ID</th>
                                            <th>Date</th>
                                            <th>Type</th>
                                            <th>Description</th>
                                            <th>Amount</th>
                                            <th>Status</th>
                                            <th>Processed By</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${transactions}" var="transaction">
                                            <tr>
                                                <td>${transaction.id}</td>
                                                <td><fmt:formatDate value="${transaction.date}" pattern="MMM dd, yyyy HH:mm"/></td>
                                                <td>
                                                    <span class="transaction-type-badge bg-info">
                                                        ${transaction.type}
                                                    </span>
                                                </td>
                                                <td>${transaction.description}</td>
                                                <td class="${transaction.amount >= 0 ? 'amount-positive' : 'amount-negative'}">
                                                    <fmt:formatNumber value="${transaction.amount}" type="currency"/>
                                                </td>
                                                <td>
                                                    <span class="status-badge ${transaction.status == 'COMPLETED' ? 'bg-success' : 
                                                                          transaction.status == 'PENDING' ? 'bg-warning' : 'bg-danger'}">
                                                        ${transaction.status}
                                                    </span>
                                                </td>
                                                <td>${transaction.processedBy}</td>
                                                <td>
                                                    <div class="btn-group">
                                                        <button class="btn btn-sm btn-info" onclick="viewTransactionDetails('${transaction.id}')">
                                                            <i class="bi bi-eye"></i>
                                                        </button>
                                                        <c:if test="${transaction.status == 'PENDING'}">
                                                            <button class="btn btn-sm btn-success" onclick="approveTransaction('${transaction.id}')">
                                                                <i class="bi bi-check-lg"></i>
                                                            </button>
                                                            <button class="btn btn-sm btn-danger" onclick="rejectTransaction('${transaction.id}')">
                                                                <i class="bi bi-x-lg"></i>
                                                            </button>
                                                        </c:if>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Pagination -->
                    <nav aria-label="Page navigation" class="mt-4">
                        <ul class="pagination justify-content-center">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage - 1}&search=${param.search}&type=${param.type}&status=${param.status}&startDate=${param.startDate}&endDate=${param.endDate}" tabindex="-1">
                                    <i class="bi bi-chevron-left"></i> Previous
                                </a>
                            </li>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}&search=${param.search}&type=${param.type}&status=${param.status}&startDate=${param.startDate}&endDate=${param.endDate}">${i}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage + 1}&search=${param.search}&type=${param.type}&status=${param.status}&startDate=${param.startDate}&endDate=${param.endDate}">
                                    Next <i class="bi bi-chevron-right"></i>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </main>
        </div>
    </div>

    <!-- Transaction Details Modal -->
    <div class="modal fade" id="transactionDetailsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Transaction Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div id="transactionDetailsContent">
                        <!-- Transaction details will be loaded here -->
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        // Initialize charts
        document.addEventListener('DOMContentLoaded', function() {
            // Revenue Chart
            const revenueCtx = document.getElementById('revenueChart').getContext('2d');
            new Chart(revenueCtx, {
                type: 'line',
                data: {
                    labels: ${revenueLabels},
                    datasets: [{
                        label: 'Revenue',
                        data: ${revenueData},
                        borderColor: 'rgb(75, 192, 192)',
                        tension: 0.1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false
                }
            });

            // Transaction Types Chart
            const typesCtx = document.getElementById('transactionTypesChart').getContext('2d');
            new Chart(typesCtx, {
                type: 'doughnut',
                data: {
                    labels: ${transactionTypeLabels},
                    datasets: [{
                        data: ${transactionTypeData},
                        backgroundColor: [
                            'rgb(75, 192, 192)',
                            'rgb(255, 99, 132)',
                            'rgb(255, 205, 86)'
                        ]
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false
                }
            });
        });

        function toggleAdvancedFilters() {
            const filters = document.getElementById('advancedFilters');
            filters.classList.toggle('show');
        }

        function resetFilters() {
            document.getElementById('searchForm').reset();
            document.getElementById('advancedFilters').classList.remove('show');
            document.getElementById('searchForm').submit();
        }

        function viewTransactionDetails(transactionId) {
            const modal = new bootstrap.Modal(document.getElementById('transactionDetailsModal'));
            const content = document.getElementById('transactionDetailsContent');
            
            // Show loading state
            content.innerHTML = '<div class="text-center"><div class="spinner-border" role="status"></div></div>';
            modal.show();

            // Fetch transaction details
            fetch(`${pageContext.request.contextPath}/admin/transactions/${transactionId}/details`)
                .then(response => response.json())
                .then(data => {
                    content.innerHTML = `
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>Transaction ID:</strong> ${data.id}</p>
                                <p><strong>Date:</strong> ${new Date(data.date).toLocaleString()}</p>
                                <p><strong>Type:</strong> ${data.type}</p>
                                <p><strong>Status:</strong> ${data.status}</p>
                            </div>
                            <div class="col-md-6">
                                <p><strong>Amount:</strong> ${data.amount}</p>
                                <p><strong>Payment Method:</strong> ${data.paymentMethod}</p>
                                <p><strong>Processed By:</strong> ${data.processedBy}</p>
                                <p><strong>Reference Number:</strong> ${data.referenceNumber}</p>
                            </div>
                        </div>
                        <div class="mt-3">
                            <h6>Description</h6>
                            <p>${data.description}</p>
                        </div>
                        <div class="mt-3">
                            <h6>Notes</h6>
                            <p>${data.notes || 'No notes available'}</p>
                        </div>
                    `;
                })
                .catch(error => {
                    content.innerHTML = `
                        <div class="alert alert-danger">
                            Failed to load transaction details: ${error.message}
                        </div>
                    `;
                });
        }

        function approveTransaction(transactionId) {
            if (confirm('Are you sure you want to approve this transaction?')) {
                fetch(`${pageContext.request.contextPath}/admin/transactions/${transactionId}/approve`, {
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

        function rejectTransaction(transactionId) {
            if (confirm('Are you sure you want to reject this transaction?')) {
                fetch(`${pageContext.request.contextPath}/admin/transactions/${transactionId}/reject`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    }
                })
                .then(response => {
                    if (response.ok) {
                        location.reload();
                    } else {
                        throw new Error('Failed to reject transaction');
                    }
                })
                .catch(error => {
                    alert(error.message);
                });
            }
        }

        function exportTransactions(format) {
            const params = new URLSearchParams(window.location.search);
            window.location.href = `${pageContext.request.contextPath}/admin/transactions/export?format=${format}&${params.toString()}`;
        }
    </script>
</body>
</html> 