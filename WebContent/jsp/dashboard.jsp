<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="includes/header.jsp" %>

<!-- Dashboard Content -->
<div class="row">
    <!-- Quick Stats -->
    <div class="col-md-3 mb-4">
        <div class="card bg-primary text-white">
            <div class="card-body">
                <h5 class="card-title">Active Queue</h5>
                <h2 class="card-text">${activeQueueCount}</h2>
                <p class="card-text"><small>Last updated: ${lastUpdateTime}</small></p>
            </div>
        </div>
    </div>
    <div class="col-md-3 mb-4">
        <div class="card bg-success text-white">
            <div class="card-body">
                <h5 class="card-title">Today's Transactions</h5>
                <h2 class="card-text">${todayTransactions}</h2>
                <p class="card-text"><small>Total: ${todayTotal}</small></p>
            </div>
        </div>
    </div>
    <div class="col-md-3 mb-4">
        <div class="card bg-warning text-dark">
            <div class="card-body">
                <h5 class="card-title">Pending Approvals</h5>
                <h2 class="card-text">${pendingApprovals}</h2>
                <p class="card-text"><small>High priority: ${highPriorityCount}</small></p>
            </div>
        </div>
    </div>
    <div class="col-md-3 mb-4">
        <div class="card bg-info text-white">
            <div class="card-body">
                <h5 class="card-title">Active Users</h5>
                <h2 class="card-text">${activeUsers}</h2>
                <p class="card-text"><small>Online: ${onlineUsers}</small></p>
            </div>
        </div>
    </div>
</div>

<!-- Recent Transactions -->
<div class="row mb-4">
    <div class="col-12">
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0">Recent Transactions</h5>
                <button class="btn btn-primary btn-sm" onclick="AMS.showLoading()">
                    <i class="fas fa-sync"></i> Refresh
                </button>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover" id="transactionsTable">
                        <thead>
                            <tr>
                                <th>Transaction ID</th>
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
                                    <td>${transaction.date}</td>
                                    <td>${transaction.type}</td>
                                    <td>${transaction.amount}</td>
                                    <td>
                                        <span class="badge bg-${transaction.statusColor}">
                                            ${transaction.status}
                                        </span>
                                    </td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary" 
                                                data-bs-toggle="tooltip" 
                                                title="View Details">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <button class="btn btn-sm btn-outline-danger" 
                                                data-bs-toggle="tooltip" 
                                                title="Cancel Transaction">
                                            <i class="fas fa-times"></i>
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

<!-- Quick Actions -->
<div class="row">
    <div class="col-md-6 mb-4">
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">Quick Actions</h5>
            </div>
            <div class="card-body">
                <div class="d-grid gap-2">
                    <button class="btn btn-primary" onclick="location.href='${pageContext.request.contextPath}/kiosk'">
                        <i class="fas fa-desktop"></i> Open KIOSK
                    </button>
                    <button class="btn btn-success" onclick="location.href='${pageContext.request.contextPath}/queue/new'">
                        <i class="fas fa-plus"></i> New Queue
                    </button>
                    <button class="btn btn-info" onclick="location.href='${pageContext.request.contextPath}/reports'">
                        <i class="fas fa-chart-bar"></i> Generate Report
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <div class="col-md-6 mb-4">
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">System Notifications</h5>
            </div>
            <div class="card-body">
                <div class="list-group">
                    <c:forEach items="${notifications}" var="notification">
                        <a href="#" class="list-group-item list-group-item-action">
                            <div class="d-flex w-100 justify-content-between">
                                <h6 class="mb-1">${notification.title}</h6>
                                <small>${notification.time}</small>
                            </div>
                            <p class="mb-1">${notification.message}</p>
                        </a>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Initialize JavaScript -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Initialize tooltips
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
    
    // Make table responsive
    AMS.makeTableResponsive('transactionsTable');
    
    // Example of form validation
    const form = document.getElementById('transactionForm');
    if (form) {
        form.addEventListener('submit', function(e) {
            if (!AMS.validateForm('transactionForm')) {
                e.preventDefault();
                AMS.showAlert('danger', 'Please fill in all required fields');
            }
        });
    }
});
</script>

<%@ include file="includes/footer.jsp" %>
