<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm");
    pageContext.setAttribute("dateFormatter", dateFormatter);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manager Payments - Accounting Management System</title>
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

        .manager-payments {
            padding: 20px;
            max-width: 1400px;
            margin: 0 auto;
        }

        .payments-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .payments-header h1 {
            color: var(--dark-color);
            margin: 0;
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

        .table-container {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .table {
            width: 100%;
            border-collapse: collapse;
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

        .status-completed {
            background: #d4edda;
            color: #155724;
        }

        .status-failed {
            background: #f8d7da;
            color: #721c24;
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
    </style>
</head>
<body>
    <%@ include file="../includes/manager-header.jsp" %>
    
    <div class="manager-payments">
        <div class="payments-header">
            <h1>Payment Management</h1>
            <div class="action-buttons">
                <button class="btn btn-primary" onclick="exportPayments()">
                    <i class="fas fa-download"></i> Export
                </button>
            </div>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <h3>Total Payments</h3>
                <div class="value">${statistics.totalPayments}</div>
                <p class="text-muted">All time</p>
            </div>
            <div class="stat-card">
                <h3>Pending Payments</h3>
                <div class="value">${statistics.pendingPayments}</div>
                <p class="text-muted">Require attention</p>
            </div>
            <div class="stat-card">
                <h3>Total Amount</h3>
                <div class="value">
                    <fmt:formatNumber value="${statistics.totalAmount.orElse(0)}" type="currency"/>
                </div>
                <p class="text-muted">This month</p>
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
                <option value="PROCESSED">Processed</option>
                <option value="FAILED">Failed</option>
            </select>
        </div>

        <div class="table-container">
            <div class="table-responsive">
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
                        <c:forEach items="${payments}" var="payment">
                            <tr>
                                <td>${payment.id}</td>
                                <td>${payment.user.username}</td>
                                <td><fmt:formatNumber value="${payment.amount}" type="currency"/></td>
                                <td>${fn:toLowerCase(fn:replace(payment.type, '_', ' '))}</td>
                                <td>
                                    <span class="status-badge status-${fn:toLowerCase(payment.paymentStatus)}">
                                        ${payment.paymentStatus}
                                    </span>
                                </td>
                                <td>${payment.createdAt.format(dateFormatter)}</td>
                                <td>
                                    <c:if test="${payment.paymentStatus.name() == 'PENDING'}">
                                        <button class="btn btn-success" onclick="approvePayment('${payment.id}')">
                                            <i class="fas fa-check"></i> Approve
                                        </button>
                                        <button class="btn btn-danger" onclick="rejectPayment('${payment.id}')">
                                            <i class="fas fa-times"></i> Reject
                                        </button>
                                    </c:if>
                                    <a href="${pageContext.request.contextPath}/manager/payments/${payment.id}" 
                                       class="btn btn-primary">
                                        <i class="fas fa-eye"></i> View
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
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

        function filterPayments() {
            searchPayments();
        }

        function refreshPayments() {
            fetch(`${pageContext.request.contextPath}/manager/payments`, {
                method: 'GET',
                headers: {
                    'Accept': 'text/html'
                }
            })
            .then(response => {
                if (response.ok) {
                    return response.text();
                }
                throw new Error('Network response was not ok');
            })
            .then(html => {
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, 'text/html');
                const newTableBody = doc.querySelector('#paymentTableBody');
                if (newTableBody) {
                    document.querySelector('#paymentTableBody').innerHTML = newTableBody.innerHTML;
                }
            })
            .catch(error => {
                console.error('Error refreshing payments:', error);
                alert('Error refreshing payments. Please try again.');
            });
        }

        function approvePayment(paymentId) {
            if (confirm('Are you sure you want to approve this payment?')) {
                fetch(`${pageContext.request.contextPath}/manager/payments/${paymentId}/approve`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    }
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        refreshPayments();
                    } else {
                        alert(data.message || 'Failed to approve payment');
                    }
                })
                .catch(error => {
                    console.error('Error approving payment:', error);
                    alert('Error approving payment. Please try again.');
                });
            }
        }

        function rejectPayment(paymentId) {
            if (confirm('Are you sure you want to reject this payment?')) {
                fetch(`${pageContext.request.contextPath}/manager/payments/${paymentId}/reject`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    }
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        refreshPayments();
                    } else {
                        alert(data.message || 'Failed to reject payment');
                    }
                })
                .catch(error => {
                    console.error('Error rejecting payment:', error);
                    alert('Error rejecting payment. Please try again.');
                });
            }
        }

        function exportPayments() {
            window.location.href = `${pageContext.request.contextPath}/manager/payments/export`;
        }
    </script>
</body>
</html> 