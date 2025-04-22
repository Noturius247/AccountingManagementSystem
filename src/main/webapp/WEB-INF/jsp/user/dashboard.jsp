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

        @keyframes flash {
            0% { background-color: #0d6efd; }
            50% { background-color: #0dcaf0; }
            100% { background-color: #0d6efd; }
        }
        
        .flashing {
            animation: flash 1s ease-in-out;
        }
        
        #queueStatusSection .alert {
            transition: all 0.3s ease;
        }
        
        #queueStatusSection.flashing .alert {
            background-color: #0d6efd;
            color: white;
        }
        
        #queueNumber {
            font-weight: bold;
            letter-spacing: 1px;
        }
    </style>
</head>
<body>
    <%@ include file="../includes/user-header.jsp" %>

    <div class="container-fluid">
        <div id="main-content">
            <!-- Main Content Section -->
            <div id="dashboard-content">
                <!-- Welcome Section -->
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Welcome, ${user.firstName}!</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2">
                            <a href="${pageContext.request.contextPath}/kiosk" class="btn btn-primary" target="_blank">
                                <i class="bi bi-display me-1"></i> Access Kiosk
                            </a>
                            <button type="button" class="btn btn-sm btn-outline-secondary">Export</button>
                            <button type="button" class="btn btn-sm btn-outline-secondary">Print</button>
                        </div>
                    </div>
                </div>

                <!-- Debug Info -->
                <div class="d-none">
                    <p>Debug Info:</p>
                    <p>user.student: ${user.student}</p>
                    <p>user.registrationStatus: ${user.registrationStatus}</p>
                    <p>user.registrationStatus type: ${user.registrationStatus.getClass().getName()}</p>
                </div>

                <!-- Student Registration Status Section -->
                <div class="mb-4">
                    <c:choose>
                        <c:when test="${not user.student}">
                            <div class="alert alert-info">
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
                        </c:when>
                        <c:when test="${user.student and user.registrationStatus.name() eq 'PENDING'}">
                            <div class="alert alert-warning alert-dismissible fade show">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h4 class="alert-heading">Registration Pending</h4>
                                        <p class="mb-0">Your student registration is currently pending admin approval. Please wait for confirmation.</p>
                                        <small class="text-muted">Student ID: ${student.studentId}</small>
                                    </div>
                                    <span class="badge bg-warning text-dark px-3 py-2">
                                        <i class="bi bi-clock me-1"></i> Pending Approval
                                    </span>
                                </div>
                            </div>
                        </c:when>
                        <c:when test="${user.student and user.registrationStatus.name() eq 'REJECTED'}">
                            <div class="alert alert-danger alert-dismissible fade show">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h4 class="alert-heading">Registration Rejected</h4>
                                        <p class="mb-0">Your student registration has been rejected. Please contact the admin for more information.</p>
                                        <small class="text-muted">Student ID: ${student.studentId}</small>
                                    </div>
                                    <span class="badge bg-danger px-3 py-2">
                                        <i class="bi bi-x-circle me-1"></i> Rejected
                                    </span>
                                </div>
                            </div>
                        </c:when>
                    </c:choose>
                </div>

                <!-- Queue Status Section -->
                <div id="queueStatusSection" class="mb-4" style="display: none;">
                    <div class="alert alert-info">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h4 class="alert-heading">Queue Status</h4>
                                <p class="mb-0">Your queue number is:</p>
                                <div class="mt-2">
                                    <span class="badge bg-primary me-2" id="queueNumber" style="font-size: 1.2rem; padding: 0.5rem 1rem;">Q-000</span>
                                </div>
                                <div class="mt-2">
                                    <span class="badge bg-warning me-2" id="queuePosition">Position: 0</span>
                                    <span class="badge bg-info" id="estimatedWaitTime">Estimated Wait: 0 min</span>
                                </div>
                            </div>
                            <a href="${pageContext.request.contextPath}/kiosk/queue/status" class="btn btn-outline-primary" target="_blank">
                                <i class="bi bi-eye me-1"></i> View Queue Status
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Statistics Cards -->
                <div class="row row-cols-1 row-cols-md-4 g-4 mb-4">
                    <div class="col">
                        <div class="card h-100 border-primary">
                            <div class="card-body">
                                <h5 class="card-title text-primary">Current Balance</h5>
                                <p class="card-text display-6" id="currentBalance">$${currentBalance}</p>
                            </div>
                        </div>
                    </div>
                    <div class="col">
                        <div class="card h-100 border-warning">
                            <div class="card-body">
                                <h5 class="card-title text-warning">Active Queues</h5>
                                <p class="card-text display-6" id="activeQueues">${dashboardData.activeQueues}</p>
                            </div>
                        </div>
                    </div>
                    <div class="col">
                        <div class="card h-100 border-success">
                            <div class="card-body">
                                <h5 class="card-title text-success">Total Transactions</h5>
                                <p class="card-text display-6" id="totalTransactions">${dashboardData.totalTransactions}</p>
                            </div>
                        </div>
                    </div>
                    <div class="col">
                        <div class="card h-100 border-info">
                            <div class="card-body">
                                <h5 class="card-title text-info">Total Documents</h5>
                                <p class="card-text display-6" id="totalDocuments">${dashboardData.totalDocuments}</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Transactions Table -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Recent Transactions</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover" id="transactionsTable">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Description</th>
                                        <th>Amount</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${recentTransactions}" var="transaction">
                                        <tr>
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
            </div>
        </div>
    </div>

    </div>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- jQuery (required for DataTables) -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <!-- DataTables -->
    <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap5.min.js"></script>
    
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <!-- Custom JavaScript -->
    <script src="${pageContext.request.contextPath}/static/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/dashboard.js"></script>

    <script>
        // Initialize DataTables
        $(document).ready(function() {
            $('#transactionsTable').DataTable({
                responsive: true,
                pageLength: 10,
                order: [[0, 'desc']]
            });
        });

        // Function to update queue status
        function updateQueueStatus() {
            fetch('${pageContext.request.contextPath}/kiosk/queue-status')
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.json();
                })
                .then(data => {
                    const queueStatusSection = document.getElementById('queueStatusSection');
                    if (data.status === 'ACTIVE' && data.position > 0) {
                        // Update queue position and estimated wait time
                        document.getElementById('queuePosition').textContent = `Position: ${data.position}`;
                        document.getElementById('estimatedWaitTime').textContent = `Estimated Wait: ${data.estimatedWaitTime} min`;
                        // Show the queue status section
                        queueStatusSection.style.display = 'block';
                    } else {
                        // Hide the queue status section if not in queue
                        queueStatusSection.style.display = 'none';
                    }
                })
                .catch(error => {
                    console.error('Error updating queue status:', error);
                    // Don't hide the queue status section on error if it was initially visible
                    if (!'${showQueueStatus}') {
                        document.getElementById('queueStatusSection').style.display = 'none';
                    }
                });
        }

        // Update queue status every 30 seconds
        setInterval(updateQueueStatus, 30000);

        // Initial update
        document.addEventListener('DOMContentLoaded', updateQueueStatus);

        // Update when returning from kiosk
        window.addEventListener('focus', updateQueueStatus);
    </script>
</body>
</html> 