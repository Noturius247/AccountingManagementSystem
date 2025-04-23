<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="../includes/manager-header.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manager Transaction Management</title>
    <style>
        .transaction-card {
            transition: all 0.3s ease;
        }
        .transaction-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .status-badge {
            font-size: 0.8rem;
            padding: 0.3rem 0.6rem;
        }
        .status-pending { background-color: #ffd700; }
        .status-completed { background-color: #90EE90; }
        .status-failed { background-color: #ffcccb; }
    </style>
</head>
<body>
    <div class="container-fluid py-4">
        <div class="row mb-4">
            <div class="col">
                <h2>Transaction Management</h2>
            </div>
        </div>

        <!-- Statistics Cards -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card bg-primary text-white">
                    <div class="card-body">
                        <h5 class="card-title">Total Transactions</h5>
                        <h3 class="card-text" id="totalTransactions">0</h3>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-warning text-dark">
                    <div class="card-body">
                        <h5 class="card-title">Pending</h5>
                        <h3 class="card-text" id="pendingTransactions">0</h3>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-success text-white">
                    <div class="card-body">
                        <h5 class="card-title">Completed</h5>
                        <h3 class="card-text" id="completedTransactions">0</h3>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-danger text-white">
                    <div class="card-body">
                        <h5 class="card-title">Failed</h5>
                        <h3 class="card-text" id="failedTransactions">0</h3>
                    </div>
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
                        <label class="form-label">Status</label>
                        <select class="form-select" id="status" name="status">
                            <option value="">All</option>
                            <option value="PENDING">Pending</option>
                            <option value="COMPLETED">Completed</option>
                            <option value="FAILED">Failed</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Amount Range</label>
                        <select class="form-select" id="amountRange" name="amountRange">
                            <option value="">All</option>
                            <option value="0-1000">$0 - $1,000</option>
                            <option value="1000-5000">$1,000 - $5,000</option>
                            <option value="5000+">$5,000+</option>
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
                <button class="btn btn-success me-2" onclick="bulkApprove()">Approve Selected</button>
                <button class="btn btn-danger me-2" onclick="bulkReject()">Reject Selected</button>
                <div class="btn-group">
                    <button class="btn btn-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                        Export
                    </button>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="#" onclick="exportTransactions('pdf')">Export as PDF</a></li>
                        <li><a class="dropdown-item" href="#" onclick="exportTransactions('excel')">Export as Excel</a></li>
                        <li><a class="dropdown-item" href="#" onclick="exportTransactions('csv')">Export as CSV</a></li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Transactions Table -->
        <div class="card">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover" id="transactionsTable">
                        <thead>
                            <tr>
                                <th><input type="checkbox" id="selectAll" onclick="toggleSelectAll()"></th>
                                <th>ID</th>
                                <th>Date</th>
                                <th>User</th>
                                <th>Description</th>
                                <th>Amount</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${transactions}" var="transaction">
                                <tr>
                                    <td><input type="checkbox" class="transaction-checkbox" value="${transaction.id}"></td>
                                    <td>${transaction.id}</td>
                                    <td>${transaction.createdAt}</td>
                                    <td>${transaction.user != null ? transaction.user.username : 'N/A'}</td>
                                    <td>${transaction.notes != null ? transaction.notes : 'N/A'}</td>
                                    <td>$<fmt:formatNumber value="${transaction.amount}" pattern="#,##0.00"/></td>
                                    <td>
                                        <span class="badge status-${fn:toLowerCase(transaction.status)}">
                                            ${transaction.status}
                                        </span>
                                    </td>
                                    <td>
                                        <button class="btn btn-sm btn-info me-1" onclick="viewTransaction(${transaction.id})">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <c:if test="${transaction.status == 'PENDING'}">
                                            <button class="btn btn-sm btn-success me-1" onclick="approveTransaction(${transaction.id})">
                                                <i class="fas fa-check"></i>
                                            </button>
                                            <button class="btn btn-sm btn-danger" onclick="rejectTransaction(${transaction.id})">
                                                <i class="fas fa-times"></i>
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

    <jsp:include page="/WEB-INF/jsp/includes/footer.jsp" />

    <script>
        function updateStatistics() {
            const rows = document.querySelectorAll('#transactionsTable tbody tr');
            let total = rows.length;
            let pending = 0, completed = 0, failed = 0;

            rows.forEach(row => {
                const status = row.querySelector('.status-badge').textContent.trim();
                if (status === 'PENDING') pending++;
                else if (status === 'COMPLETED') completed++;
                else if (status === 'FAILED') failed++;
            });

            document.getElementById('totalTransactions').textContent = total;
            document.getElementById('pendingTransactions').textContent = pending;
            document.getElementById('completedTransactions').textContent = completed;
            document.getElementById('failedTransactions').textContent = failed;
        }

        function viewTransaction(id) {
            fetch(`/manager/transactions/${id}`)
                .then(response => response.json())
                .then(transaction => {
                    const details = document.getElementById('transactionDetails');
                    details.innerHTML = `
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>ID:</strong> ${transaction.id}</p>
                                <p><strong>Date:</strong> ${transaction.date}</p>
                                <p><strong>User:</strong> ${transaction.user.username}</p>
                                <p><strong>Amount:</strong> $${transaction.amount.toFixed(2)}</p>
                            </div>
                            <div class="col-md-6">
                                <p><strong>Status:</strong> ${transaction.status}</p>
                                <p><strong>Description:</strong> ${transaction.description}</p>
                                <p><strong>Created By:</strong> ${transaction.createdBy}</p>
                                <p><strong>Last Modified:</strong> ${transaction.lastModified}</p>
                            </div>
                        </div>
                    `;
                    new bootstrap.Modal(document.getElementById('transactionModal')).show();
                });
        }

        function approveTransaction(id) {
            if (confirm('Are you sure you want to approve this transaction?')) {
                fetch(`/manager/transactions/${id}/approve`, { method: 'POST' })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            location.reload();
                        }
                    });
            }
        }

        function rejectTransaction(id) {
            if (confirm('Are you sure you want to reject this transaction?')) {
                fetch(`/manager/transactions/${id}/reject`, { method: 'POST' })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            location.reload();
                        }
                    });
            }
        }

        function bulkApprove() {
            const selected = getSelectedTransactions();
            if (selected.length === 0) {
                alert('Please select transactions to approve');
                return;
            }
            if (confirm(`Are you sure you want to approve ${selected.length} transactions?`)) {
                Promise.all(selected.map(id => 
                    fetch(`/manager/transactions/${id}/approve`, { method: 'POST' })
                )).then(() => location.reload());
            }
        }

        function bulkReject() {
            const selected = getSelectedTransactions();
            if (selected.length === 0) {
                alert('Please select transactions to reject');
                return;
            }
            if (confirm(`Are you sure you want to reject ${selected.length} transactions?`)) {
                Promise.all(selected.map(id => 
                    fetch(`/manager/transactions/${id}/reject`, { method: 'POST' })
                )).then(() => location.reload());
            }
        }

        function getSelectedTransactions() {
            return Array.from(document.querySelectorAll('.transaction-checkbox:checked'))
                .map(checkbox => checkbox.value);
        }

        function toggleSelectAll() {
            const checkboxes = document.querySelectorAll('.transaction-checkbox');
            const selectAll = document.getElementById('selectAll');
            checkboxes.forEach(checkbox => checkbox.checked = selectAll.checked);
        }

        function exportTransactions(format) {
            const startDate = document.getElementById('startDate').value;
            const endDate = document.getElementById('endDate').value;
            window.location.href = `/manager/transactions/export?format=${format}&startDate=${startDate}&endDate=${endDate}`;
        }

        function resetFilters() {
            document.getElementById('filterForm').reset();
            document.getElementById('filterForm').submit();
        }

        // Initialize statistics on page load
        document.addEventListener('DOMContentLoaded', function() {
            updateStatistics();
        });
    </script>
</body>
</html> 