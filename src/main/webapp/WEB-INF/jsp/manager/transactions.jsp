<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <meta name="contextPath" content="${pageContext.request.contextPath}"/>
    <title>Transactions - Manager Dashboard</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/static/css/main.css" rel="stylesheet">
    <style>
        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 4px;
            font-weight: 500;
        }
        .status-pending {
            background-color: #ffd700;
            color: #000;
        }
        .status-completed {
            background-color: #28a745;
            color: #fff;
        }
        .status-failed {
            background-color: #dc3545;
            color: #fff;
        }
        .transaction-table th {
            background-color: #800000;
            color: white;
        }
        .transaction-table {
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="../includes/manager-header.jsp" />

    <div class="container-fluid">
        <div class="row">
            <main class="col-md-12 ms-sm-auto px-md-4" id="main-content">
                <div id="transaction-content">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Transaction Management</h1>
                        <div class="btn-toolbar mb-2 mb-md-0">
                            <div class="btn-group me-2">
                                <select class="form-select" id="statusFilter" onchange="filterByStatus(this.value)">
                                    <option value="ALL" ${param.status == 'ALL' ? 'selected' : ''}>All Transactions</option>
                                    <option value="PENDING" ${param.status == 'PENDING' || empty param.status ? 'selected' : ''}>Pending</option>
                                    <option value="COMPLETED" ${param.status == 'COMPLETED' ? 'selected' : ''}>Completed</option>
                                    <option value="FAILED" ${param.status == 'FAILED' ? 'selected' : ''}>Failed</option>
                                </select>
                            </div>
                            <div class="btn-group">
                                <button class="btn btn-warning" type="button" onclick="resetQueue()">
                                    <i class="bi bi-arrow-repeat"></i> Reset Queue
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Filters -->
                    <div class="card mb-4">
                        <div class="card-body">
                            <form id="filterForm" class="row g-3">
                                <div class="col-md-3">
                                    <label class="form-label">Start Date</label>
                                    <input type="date" class="form-control" id="startDate" name="startDate">
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">End Date</label>
                                    <input type="date" class="form-control" id="endDate" name="endDate">
                                </div>
                                <div class="col-md-2">
                                    <label class="form-label">Amount Range</label>
                                    <select class="form-select" id="amountRange" name="amountRange">
                                        <option value="">All</option>
                                        <option value="0-1000">₱0 - ₱1,000</option>
                                        <option value="1000-5000">₱1,000 - ₱5,000</option>
                                        <option value="5000+">₱5,000+</option>
                                    </select>
                                </div>
                                <div class="col-md-2 d-flex align-items-end">
                                    <button type="submit" class="btn btn-primary me-2">Filter</button>
                                    <button type="button" class="btn btn-secondary" onclick="resetFilters()">Reset</button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Bulk Actions -->
                    <div class="row mb-3">
                        <div class="col">
                            <button class="btn btn-success me-2" onclick="bulkApprove()">
                                <i class="bi bi-check-circle"></i> Approve Selected
                            </button>
                            <button class="btn btn-danger me-2" onclick="bulkReject()">
                                <i class="bi bi-x-circle"></i> Reject Selected
                            </button>
                        </div>
                    </div>

                    <!-- Transactions Table -->
                    <div class="card">
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-striped" id="transactionTable">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Transaction #</th>
                                            <th>Date</th>
                                            <th>Amount</th>
                                            <th>Type</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${transactions}" var="transaction">
                                            <tr>
                                                <td>${transaction.id}</td>
                                                <td>${transaction.transactionNumber}</td>
                                                <td>
                                                    <fmt:parseDate value="${transaction.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                    <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd HH:mm" />
                                                </td>
                                                <td>${transaction.currency} ${transaction.amount}</td>
                                                <td>${transaction.type}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${transaction.status == 'PENDING'}">
                                                            <span class="badge status-badge status-pending">PENDING</span>
                                                        </c:when>
                                                        <c:when test="${transaction.status == 'COMPLETED'}">
                                                            <span class="badge status-badge status-completed">COMPLETED</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge status-badge status-failed">FAILED</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <button class="btn btn-sm btn-primary" onclick="viewTransaction('${transaction.id}')">View</button>
                                                    <c:if test="${transaction.status == 'PENDING'}">
                                                        <button class="btn btn-sm btn-success" onclick="approveTransaction('${transaction.id}')">Approve</button>
                                                        <button class="btn btn-sm btn-danger" onclick="rejectTransaction('${transaction.id}')">Reject</button>
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
            </main>
        </div>
    </div>

    <!-- Transaction Details Modal -->
    <div class="modal fade" id="transactionModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Transaction Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="transactionDetails">
                    <!-- Transaction details will be loaded here -->
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom JavaScript -->
    <script src="${pageContext.request.contextPath}/static/js/manager-dashboard.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            updateTransactionStatistics();
            initializeTransactionComponents();
        });

        function filterByStatus(status) {
            window.location.href = '${pageContext.request.contextPath}/manager/transactions?status=' + status;
        }

        function resetFilters() {
            document.getElementById('filterForm').reset();
            document.getElementById('filterForm').submit();
        }

        function resetQueue() {
            if (confirm('Are you sure you want to reset the transaction queue? This action cannot be undone.')) {
                fetch(`${pageContext.request.contextPath}/manager/transactions/reset-queue`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        [document.querySelector("meta[name='_csrf_header']").content]: document.querySelector("meta[name='_csrf']").content
                    }
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        window.location.reload();
                    } else {
                        alert(data.message || 'Failed to reset queue');
                    }
                });
            }
        }

        function viewTransaction(id) {
            fetch(`${pageContext.request.contextPath}/manager/transactions/${id}`)
                .then(response => response.json())
                .then(transaction => {
                    const details = document.getElementById('transactionDetails');
                    details.innerHTML = `
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>ID:</strong> \${transaction.id}</p>
                                <p><strong>Date:</strong> \${transaction.createdAt}</p>
                                <p><strong>User:</strong> \${transaction.user ? transaction.user.username : 'N/A'}</p>
                                <p><strong>Amount:</strong> ₱\${transaction.amount.toFixed(2)}</p>
                            </div>
                            <div class="col-md-6">
                                <p><strong>Status:</strong> \${transaction.status}</p>
                                <p><strong>Description:</strong> \${transaction.notes || 'N/A'}</p>
                                <p><strong>Payment Method:</strong> \${transaction.paymentMethod}</p>
                                <p><strong>Reference:</strong> \${transaction.reference || 'N/A'}</p>
                            </div>
                        </div>
                    `;
                    new bootstrap.Modal(document.getElementById('transactionModal')).show();
                });
        }

        function approveTransaction(id) {
            if (confirm('Are you sure you want to approve this transaction?')) {
                fetch(`${pageContext.request.contextPath}/manager/transactions/${id}/approve`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        [document.querySelector("meta[name='_csrf_header']").content]: document.querySelector("meta[name='_csrf']").content
                    }
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        window.location.reload();
                    } else {
                        alert(data.message || 'Failed to approve transaction');
                    }
                });
            }
        }

        function rejectTransaction(id) {
            if (confirm('Are you sure you want to reject this transaction?')) {
                fetch(`${pageContext.request.contextPath}/manager/transactions/${id}/reject`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        [document.querySelector("meta[name='_csrf_header']").content]: document.querySelector("meta[name='_csrf']").content
                    }
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        window.location.reload();
                    } else {
                        alert(data.message || 'Failed to reject transaction');
                    }
                });
            }
        }

        function bulkApprove() {
            const selected = Array.from(document.querySelectorAll('.transaction-checkbox:checked')).map(cb => cb.value);
            if (selected.length === 0) {
                alert('Please select transactions to approve');
                return;
            }
            if (confirm(`Are you sure you want to approve ${selected.length} transactions?`)) {
                Promise.all(selected.map(id => 
                    fetch(`${pageContext.request.contextPath}/manager/transactions/${id}/approve`, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            [document.querySelector("meta[name='_csrf_header']").content]: document.querySelector("meta[name='_csrf']").content
                        }
                    })
                )).then(() => window.location.reload());
            }
        }

        function bulkReject() {
            const selected = Array.from(document.querySelectorAll('.transaction-checkbox:checked')).map(cb => cb.value);
            if (selected.length === 0) {
                alert('Please select transactions to reject');
                return;
            }
            if (confirm(`Are you sure you want to reject ${selected.length} transactions?`)) {
                Promise.all(selected.map(id => 
                    fetch(`${pageContext.request.contextPath}/manager/transactions/${id}/reject`, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            [document.querySelector("meta[name='_csrf_header']").content]: document.querySelector("meta[name='_csrf']").content
                        }
                    })
                )).then(() => window.location.reload());
            }
        }
    </script>
</body>
</html> 