<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>

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
        .status-processing {
            background-color: #17a2b8;
            color: #fff;
        }
        .status-completed {
            background-color: #28a745;
            color: #fff;
        }
        .status-cancelled {
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
                    <div class="container-fluid px-4">
                        <h1 class="mt-4">Transaction Management</h1>
                        <ol class="breadcrumb mb-4">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/manager/dashboard">Dashboard</a></li>
                            <li class="breadcrumb-item active">Transactions</li>
                        </ol>

                        <!-- Transaction Statistics -->
                        <div class="row">
                            <div class="col-xl-3 col-md-6">
                                <div class="card bg-primary text-white mb-4">
                                    <div class="card-body">
                                        Total Transactions
                                        <h2 class="mb-0" id="total-transactions">${totalTransactions}</h2>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-3 col-md-6">
                                <div class="card bg-warning text-white mb-4">
                                    <div class="card-body">
                                        Pending Transactions
                                        <h2 class="mb-0" id="pending-transactions">${pendingTransactions}</h2>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-3 col-md-6">
                                <div class="card bg-success text-white mb-4">
                                    <div class="card-body">
                                        Completed Transactions
                                        <h2 class="mb-0" id="completed-transactions">${completedTransactions}</h2>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-3 col-md-6">
                                <div class="card bg-danger text-white mb-4">
                                    <div class="card-body">
                                        Failed Transactions
                                        <h2 class="mb-0" id="failed-transactions">${failedTransactions}</h2>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Processing Table -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <h5 class="mb-0">Currently Processing</h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover" id="processingTable">
                                        <thead>
                                            <tr>
                                                <th>Queue #</th>
                                                <th>Student ID</th>
                                                <th>Payment #</th>
                                                <th>Account Name</th>
                                                <th>Transaction Type</th>
                                                <th>Amount</th>
                                                <th>Processing Time</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${queues}" var="queue">
                                                <c:if test="${queue.status eq 'PROCESSING'}">
                                                    <tr>
                                                        <td>${queue.queueNumber}</td>
                                                        <td>${queue.studentId}</td>
                                                        <td>${queue.paymentNumber}</td>
                                                        <td>${queue.user.username}</td>
                                                        <td>${queue.type}</td>
                                                        <td>
                                                            <fmt:formatNumber value="${queue.amount}" type="currency" currencySymbol="₱"/>
                                                        </td>
                                                        <td>
                                                            <span class="processing-time" data-start="${queue.processedAt}">
                                                                Calculating...
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <div class="btn-group">
                                                                <button class="btn btn-sm btn-success" onclick="updateQueueStatus('${queue.id}', 'COMPLETED')">
                                                                    <i class="bi bi-check-circle"></i> Complete
                                                                </button>
                                                                <button class="btn btn-sm btn-danger" onclick="updateQueueStatus('${queue.id}', 'CANCELLED')">
                                                                    <i class="bi bi-x-circle"></i> Cancel
                                                                </button>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:if>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!-- Queue Management Section -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <h5 class="mb-0">Queue Management</h5>
                            </div>
                            <div class="card-body">
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <div class="input-group">
                                            <input type="text" class="form-control" id="queueSearch" placeholder="Search Queue Number...">
                                            <button class="btn btn-primary" type="button" onclick="searchQueue()">
                                                <i class="bi bi-search"></i> Search
                                            </button>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <select class="form-select" id="queueStatusFilter" onchange="filterByQueueStatus(this.value)">
                                            <option value="">All Statuses</option>
                                            <option value="PENDING">Pending</option>
                                            <option value="PROCESSING">Processing</option>
                                            <option value="COMPLETED">Completed</option>
                                            <option value="CANCELLED">Cancelled</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="table-responsive">
                                    <table class="table table-hover" id="queueTable">
                                        <thead>
                                            <tr>
                                                <th>Queue #</th>
                                                <th>Student ID</th>
                                                <th>Position</th>
                                                <th>Wait Time</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody id="queueTableBody">
                                            <c:set var="hasProcessingQueue" value="false" />
                                            <c:forEach items="${queues}" var="queue">
                                                <c:if test="${queue.status eq 'PROCESSING'}">
                                                    <c:set var="hasProcessingQueue" value="true" />
                                                </c:if>
                                            </c:forEach>
                                            
                                            <c:forEach items="${queues}" var="queue">
                                                <c:if test="${queue.status ne 'PROCESSING'}">
                                                <tr>
                                                    <td>${queue.queueNumber}</td>
                                                    <td>${queue.studentId}</td>
                                                    <td>${queue.position}</td>
                                                    <td>${queue.estimatedWaitTime} mins</td>
                                                    <td>
                                                        <span class="badge queue-status status-${fn:toLowerCase(queue.status)}">
                                                            ${queue.status}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group">
                                                                <c:if test="${queue.status eq 'PENDING'}">
                                                                    <button class="btn btn-sm btn-primary start-processing" 
                                                                            onclick="updateQueueStatus('${queue.id}', 'PROCESSING')"
                                                                            ${hasProcessingQueue ? 'disabled' : ''}>
                                                                        <i class="bi bi-play-fill"></i> Start Processing
                                                                    </button>
                                                                </c:if>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:if>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!-- Transaction History Section -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <h5 class="mb-0">Transaction History</h5>
                            </div>
                            <div class="card-body">
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <div class="input-group">
                                            <input type="text" class="form-control" id="transactionSearch" placeholder="Search Transaction Number...">
                                            <button class="btn btn-primary" type="button" onclick="searchTransaction()">
                                                <i class="bi bi-search"></i> Search
                                            </button>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <select class="form-select" id="transactionStatusFilter" onchange="filterByTransactionStatus(this.value)">
                                            <option value="">All Statuses</option>
                                            <option value="PENDING">Pending</option>
                                            <option value="COMPLETED">Completed</option>
                                            <option value="CANCELLED">Cancelled</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="table-responsive">
                                    <table class="table table-hover" id="transactionHistoryTable">
                                        <thead>
                                            <tr>
                                                <th>Transaction #</th>
                                                <th>Student ID</th>
                                                <th>Date</th>
                                                <th>Amount</th>
                                                <th>Type</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody id="transactionHistoryTableBody">
                                            <c:forEach items="${transactions}" var="transaction">
                                                <tr>
                                                    <td>${transaction.transactionNumber}</td>
                                                    <td>${transaction.studentId}</td>
                                                    <td>
                                                        <fmt:parseDate value="${transaction.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                        <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd HH:mm:ss" />
                                                    </td>
                                                    <td>
                                                        <fmt:formatNumber value="${transaction.amount}" type="currency" currencySymbol="₱"/>
                                                    </td>
                                                    <td>${transaction.type}</td>
                                                    <td>
                                                        <span class="badge queue-status status-${fn:toLowerCase(transaction.status)}">
                                                            ${transaction.status}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group">
                                                            <button class="btn btn-sm btn-info" onclick="viewTransactionDetails('${transaction.id}')">
                                                                <i class="bi bi-eye"></i> View
                                                            </button>
                                                            <c:if test="${transaction.status eq 'PENDING'}">
                                                                <button class="btn btn-sm btn-success" onclick="approveTransaction('${transaction.id}')">
                                                                    <i class="bi bi-check-circle"></i> Approve
                                                                    </button>
                                                                <button class="btn btn-sm btn-danger" onclick="rejectTransaction('${transaction.id}')">
                                                                    <i class="bi bi-x-circle"></i> Reject
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

                        <!-- Filters -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <i class="fas fa-filter me-1"></i>
                                Transaction Filters
                            </div>
                            <div class="card-body">
                                <form id="filterForm" class="row g-3">
                                    <div class="col-md-3">
                                        <label for="startDate" class="form-label">Start Date</label>
                                        <input type="date" class="form-control" id="startDate" name="startDate">
                                    </div>
                                    <div class="col-md-3">
                                        <label for="endDate" class="form-label">End Date</label>
                                        <input type="date" class="form-control" id="endDate" name="endDate">
                                    </div>
                                    <div class="col-md-3">
                                        <label for="amountRange" class="form-label">Amount Range</label>
                                        <select class="form-select" id="amountRange" name="amountRange">
                                            <option value="">All</option>
                                            <option value="0-1000">$0 - $1,000</option>
                                            <option value="1000-5000">$1,000 - $5,000</option>
                                            <option value="5000-10000">$5,000 - $10,000</option>
                                            <option value="10000+">$10,000+</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3 d-flex align-items-end">
                                        <button type="submit" class="btn btn-primary me-2">Apply Filters</button>
                                        <button type="button" class="btn btn-secondary" onclick="resetFilters()">Reset</button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- Transaction Status Tabs -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <ul class="nav nav-tabs card-header-tabs">
                                    <li class="nav-item">
                                        <a class="nav-link active" href="#" onclick="filterByStatus('')">All</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" href="#" onclick="filterByStatus('PENDING')">Pending</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" href="#" onclick="filterByStatus('PROCESSING')">Processing</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" href="#" onclick="filterByStatus('COMPLETED')">Completed</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" href="#" onclick="filterByStatus('FAILED')">Failed</a>
                                    </li>
                                </ul>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-bordered table-striped">
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
                                                    <td><fmt:parseDate value="${transaction.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                    <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                                                    <td>${transaction.currency} <fmt:formatNumber value="${transaction.amount}" pattern="#,##0.00"/></td>
                                                    <td>${transaction.type}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${transaction.status.toString() eq 'PENDING'}">
                                                                <span class="badge status-badge status-pending">${transaction.status}</span>
                                                            </c:when>
                                                            <c:when test="${transaction.status.toString() eq 'PROCESSING'}">
                                                                <span class="badge status-badge status-processing">${transaction.status}</span>
                                                            </c:when>
                                                            <c:when test="${transaction.status.toString() eq 'COMPLETED'}">
                                                                <span class="badge status-badge status-completed">${transaction.status}</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge status-badge status-cancelled">${transaction.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <button class="btn btn-sm btn-primary" onclick="viewTransactionDetails('${transaction.id}')">
                                                            <i class="fas fa-eye"></i> View
                                                        </button>
                                                        <c:if test="${transaction.status == 'PENDING'}">
                                                            <button class="btn btn-sm btn-success" onclick="processTransaction('${transaction.id}')">
                                                                <i class="fas fa-check"></i> Process
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
                                                <td><fmt:parseDate value="${transaction.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                <td>
                                                    <fmt:parseDate value="${transaction.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                    <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd HH:mm" />
                                                </td>
                                                <td>${transaction.currency} <fmt:formatNumber value="${transaction.amount}" pattern="#,##0.00"/></td>
                                                <td>${transaction.type}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${transaction.status.toString() eq 'PENDING'}">
                                                            <span class="badge status-badge status-pending">${transaction.status}</span>
                                                        </c:when>
                                                        <c:when test="${transaction.status.toString() eq 'PROCESSING'}">
                                                            <span class="badge status-badge status-processing">${transaction.status}</span>
                                                        </c:when>
                                                        <c:when test="${transaction.status.toString() eq 'COMPLETED'}">
                                                            <span class="badge status-badge status-completed">${transaction.status}</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge status-badge status-cancelled">${transaction.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <button class="btn btn-sm btn-primary" onclick="viewTransactionDetails('${transaction.id}')">View</button>
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
    <script type="text/javascript">
        document.addEventListener('DOMContentLoaded', function() {
            updateTransactionStatistics();
            initializeTransactionComponents();
            fetchQueueDetails();
            initializeProcessingTimes();
        });

        function initializeProcessingTimes() {
            // Update processing times every second
            setInterval(updateProcessingTimes, 1000);
            updateProcessingTimes();
        }

        function updateProcessingTimes() {
            document.querySelectorAll('.processing-time').forEach(timeSpan => {
                const startTime = new Date(timeSpan.dataset.start);
                const now = new Date();
                const diffInSeconds = Math.floor((now - startTime) / 1000);
                
                const hours = Math.floor(diffInSeconds / 3600);
                const minutes = Math.floor((diffInSeconds % 3600) / 60);
                const seconds = diffInSeconds % 60;
                
                const timeString = [
                    hours.toString().padStart(2, '0'),
                    minutes.toString().padStart(2, '0'),
                    seconds.toString().padStart(2, '0')
                ].join(':');
                
                timeSpan.textContent = timeString;
            });
        }

        function filterByStatus(status) {
            $.ajax({
                url: '${pageContext.request.contextPath}/manager/transactions',
                data: { status: status },
                success: function(response) {
                    // Find and update the transaction table content
                    const tempDiv = document.createElement('div');
                    tempDiv.innerHTML = response;
                    const newContent = tempDiv.querySelector('#transaction-content');
                    if (newContent) {
                        document.querySelector('#transaction-content').innerHTML = newContent.innerHTML;
                    }
                    updateTransactionStatistics();
                },
                error: function(xhr, status, error) {
                    console.error('Error filtering transactions:', error);
                    alert('Failed to filter transactions. Please try again.');
                }
            });
        }

        function resetFilters() {
            document.getElementById('filterForm').reset();
            $.ajax({
                url: '${pageContext.request.contextPath}/manager/transactions',
                success: function(response) {
                    // Extract the table content from the response and update
                    const tempDiv = document.createElement('div');
                    tempDiv.innerHTML = response;
                    const newTableBody = tempDiv.querySelector('#transactionTable tbody');
                    if (newTableBody) {
                        document.querySelector('#transactionTable tbody').innerHTML = newTableBody.innerHTML;
                    }
                    updateTransactionStatistics();
                },
                error: function(xhr, status, error) {
                    console.error('Error resetting filters:', error);
                    alert('Failed to reset filters. Please try again.');
                }
            });
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

        function viewTransactionDetails(id) {
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

        function searchQueue() {
            const queueNumber = document.getElementById('queueSearch').value;
            fetchQueueDetails({ queueNumber: queueNumber });
        }

        function filterByQueueStatus(status) {
            fetchQueueDetails({ status: status });
        }

        function fetchQueueDetails(params = {}) {
            const queryString = new URLSearchParams(params).toString();
            fetch(`${pageContext.request.contextPath}/manager/transactions/queue?${queryString}`)
                .then(response => response.json())
                .then(data => {
                    updateQueueTable(data.queues);
                    document.getElementById('currentPosition').textContent = data.currentPosition;
                    document.getElementById('totalQueues').textContent = data.totalQueues;
                })
                .catch(error => {
                    console.error('Error fetching queue details:', error);
                    showAlert('error', 'Failed to fetch queue details');
                });
        }

        function updateQueueTable(queues) {
            // Update Processing Table
            const processingTbody = document.querySelector('#processingTable tbody');
            if (processingTbody) {
                processingTbody.innerHTML = '';
                queues.filter(queue => queue.status === 'PROCESSING').forEach(queue => {
                    const tr = document.createElement('tr');
                    tr.innerHTML = `
                        <td>\${queue.queueNumber}</td>
                        <td>\${queue.studentId}</td>
                        <td>\${queue.paymentNumber}</td>
                        <td>\${queue.user.username}</td>
                        <td>\${queue.type}</td>
                        <td>\${formatCurrency(queue.amount)}</td>
                        <td>
                            <span class="processing-time" data-start="\${queue.processedAt}">
                                Calculating...
                            </span>
                        </td>
                        <td>
                            <div class="btn-group">
                                <button class="btn btn-sm btn-success" onclick="updateQueueStatus('\${queue.id}', 'COMPLETED')">
                                    <i class="bi bi-check-circle"></i> Complete
                                </button>
                                <button class="btn btn-sm btn-danger" onclick="updateQueueStatus('\${queue.id}', 'CANCELLED')">
                                    <i class="bi bi-x-circle"></i> Cancel
                                </button>
                            </div>
                        </td>
                    `;
                    processingTbody.appendChild(tr);
                });
            }

            // Update Queue Table
            const queueTbody = document.getElementById('queueTableBody');
            if (queueTbody) {
                queueTbody.innerHTML = '';
            queues.forEach(queue => {
                    if (queue.status !== 'PROCESSING') {  // Don't show processing items in main queue table
                const tr = document.createElement('tr');
                tr.innerHTML = `
                    <td>\${queue.queueNumber}</td>
                    <td>\${queue.studentId}</td>
                    <td>\${queue.position}</td>
                    <td>\${queue.estimatedWaitTime} mins</td>
                    <td>
                        <span class="badge queue-status status-\${queue.status.toLowerCase()}">
                            \${queue.status}
                        </span>
                    </td>
                    <td>
                        <div class="btn-group">
                            \${getQueueActions(queue)}
                        </div>
                    </td>
                `;
                        queueTbody.appendChild(tr);
                    }
                });
            }
            
            // Initialize processing times for new items
            initializeProcessingTimes();
        }

        function formatCurrency(amount) {
            return new Intl.NumberFormat('en-PH', {
                style: 'currency',
                currency: 'PHP'
            }).format(amount || 0);
        }

        function getQueueActions(queue) {
            if (queue.status === 'PENDING') {
                return `<button class="btn btn-sm btn-primary" onclick="updateQueueStatus('\${queue.id}', 'PROCESSING')">
                            Start Processing
                        </button>`;
            } else if (queue.status === 'PROCESSING') {
                return `<button class="btn btn-sm btn-success" onclick="updateQueueStatus('\${queue.id}', 'COMPLETED')">
                            Complete
                        </button>
                        <button class="btn btn-sm btn-danger" onclick="updateQueueStatus('\${queue.id}', 'CANCELLED')">
                            Cancel
                        </button>`;
            }
            return '';
        }

        function updateQueueStatus(id, status) {
            if (status === 'PROCESSING') {
                // Check if there's already a processing queue
                const processingQueues = document.querySelectorAll('.status-processing');
                if (processingQueues.length > 0) {
                    alert('Another queue is already being processed. Please complete or cancel it first.');
                    return;
                }
            }

            if (confirm('Are you sure you want to update the queue status to ' + status + '?')) {
                const csrfHeader = document.querySelector("meta[name='_csrf_header']").content;
                const csrfToken = document.querySelector("meta[name='_csrf']").content;
                
                fetch('${pageContext.request.contextPath}/manager/transactions/queue/' + id + '/status', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json',
                        [csrfHeader]: csrfToken
                    },
                    body: JSON.stringify({ 
                        status: status,
                        _csrf: csrfToken 
                    })
                })
                .then(response => {
                    if (!response.ok) {
                        return response.text().then(text => {
                            throw new Error(text || 'Failed to update queue status');
                        });
                    }
                    return response.json();
                })
                .then(data => {
                    if (data.success) {
                        // If status was changed to PROCESSING, disable all other "Start Processing" buttons
                        if (status === 'PROCESSING') {
                            document.querySelectorAll('.start-processing').forEach(button => {
                                button.disabled = true;
                            });
                        }
                        // If status was changed from PROCESSING, enable all "Start Processing" buttons
                        else if (status === 'COMPLETED' || status === 'CANCELLED') {
                            document.querySelectorAll('.start-processing').forEach(button => {
                                button.disabled = false;
                            });
                        }
                        showAlert('success', 'Queue status updated successfully');
                        setTimeout(() => window.location.reload(), 1000); // Refresh after 1 second
                    } else {
                        showAlert('error', data.message || 'Failed to update queue status');
                    }
                })
                .catch(error => {
                    console.error('Error updating queue status:', error);
                    showAlert('error', error.message || 'Failed to update queue status');
                });
            }
        }

        function showAlert(type, message) {
            const alertDiv = document.createElement('div');
            alertDiv.className = 'alert alert-' + type + ' alert-dismissible fade show';
            alertDiv.innerHTML = message + 
                '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>';
            const container = document.querySelector('.container-fluid');
            container.insertBefore(alertDiv, container.firstChild);
            setTimeout(() => alertDiv.remove(), 5000);
        }
    </script>
</body>
</html> 