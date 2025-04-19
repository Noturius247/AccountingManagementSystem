<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="admin-content">
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2">Transaction Management</h1>
        <div class="btn-toolbar mb-2 mb-md-0">
            <button type="button" class="btn btn-primary" onclick="exportTransactions()">
                <i class="bi bi-download"></i> Export
            </button>
        </div>
    </div>

    <!-- Search and Filter Section -->
    <div class="row mb-3">
        <div class="col-md-4">
            <div class="input-group">
                <input type="text" id="transactionSearch" class="form-control" placeholder="Search transactions..." onkeyup="searchTransactions()">
                <button class="btn btn-outline-secondary" type="button">
                    <i class="bi bi-search"></i>
                </button>
            </div>
        </div>
        <div class="col-md-2">
            <select id="statusFilter" class="form-select" onchange="filterTransactions()">
                <option value="">All Status</option>
                <option value="PENDING">Pending</option>
                <option value="COMPLETED">Completed</option>
                <option value="FAILED">Failed</option>
            </select>
        </div>
        <div class="col-md-2">
            <select id="typeFilter" class="form-select" onchange="filterTransactions()">
                <option value="">All Types</option>
                <option value="TUITION">Tuition</option>
                <option value="MISCELLANEOUS">Miscellaneous</option>
                <option value="LIBRARY">Library</option>
                <option value="LABORATORY">Laboratory</option>
            </select>
        </div>
        <div class="col-md-4">
            <div class="input-group">
                <input type="date" id="startDate" class="form-control">
                <span class="input-group-text">to</span>
                <input type="date" id="endDate" class="form-control">
                <button class="btn btn-outline-secondary" type="button" onclick="filterByDate()">
                    <i class="bi bi-calendar"></i>
                </button>
            </div>
        </div>
    </div>

    <!-- Transactions Table -->
    <div class="card shadow">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>User</th>
                            <th>Type</th>
                            <th>Amount</th>
                            <th>Status</th>
                            <th>Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="transactionTableBody">
                        <c:forEach items="${transactions}" var="transaction">
                            <tr>
                                <td>${transaction.id}</td>
                                <td>${transaction.user.username}</td>
                                <td>${transaction.type}</td>
                                <td><fmt:formatNumber value="${transaction.amount}" type="currency"/></td>
                                <td>
                                    <span class="badge bg-${transaction.status == 'COMPLETED' ? 'success' : 
                                                              transaction.status == 'PENDING' ? 'warning' : 'danger'}">
                                        ${transaction.status}
                                    </span>
                                </td>
                                <td><fmt:formatDate value="${transaction.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                                <td>
                                    <button class="btn btn-sm btn-primary" onclick="viewTransaction('${transaction.id}')">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                    <button class="btn btn-sm btn-warning" onclick="editTransaction('${transaction.id}')">
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

    <!-- Pagination -->
    <nav aria-label="Page navigation" class="mt-3">
        <ul class="pagination justify-content-center">
            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                <a class="page-link" href="#" onclick="prevPage()">Previous</a>
            </li>
            <c:forEach begin="1" end="${totalPages}" var="i">
                <li class="page-item ${currentPage == i ? 'active' : ''}">
                    <a class="page-link" href="#" onclick="goToPage(${i})">${i}</a>
                </li>
            </c:forEach>
            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                <a class="page-link" href="#" onclick="nextPage()">Next</a>
            </li>
        </ul>
    </nav>
</div>

<!-- View Transaction Modal -->
<div class="modal fade" id="viewTransactionModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Transaction Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-6">
                        <h6>Transaction Information</h6>
                        <table class="table table-sm">
                            <tr>
                                <th>ID:</th>
                                <td id="viewTransactionId"></td>
                            </tr>
                            <tr>
                                <th>Type:</th>
                                <td id="viewTransactionType"></td>
                            </tr>
                            <tr>
                                <th>Amount:</th>
                                <td id="viewTransactionAmount"></td>
                            </tr>
                            <tr>
                                <th>Status:</th>
                                <td id="viewTransactionStatus"></td>
                            </tr>
                            <tr>
                                <th>Date:</th>
                                <td id="viewTransactionDate"></td>
                            </tr>
                        </table>
                    </div>
                    <div class="col-md-6">
                        <h6>User Information</h6>
                        <table class="table table-sm">
                            <tr>
                                <th>Username:</th>
                                <td id="viewTransactionUsername"></td>
                            </tr>
                            <tr>
                                <th>Email:</th>
                                <td id="viewTransactionEmail"></td>
                            </tr>
                            <tr>
                                <th>Role:</th>
                                <td id="viewTransactionRole"></td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function viewTransaction(id) {
        fetch(`${pageContext.request.contextPath}/admin/transactions/${id}`)
            .then(response => response.json())
            .then(transaction => {
                document.getElementById('viewTransactionId').textContent = transaction.id;
                document.getElementById('viewTransactionType').textContent = transaction.type;
                document.getElementById('viewTransactionAmount').textContent = 
                    new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(transaction.amount);
                document.getElementById('viewTransactionStatus').textContent = transaction.status;
                document.getElementById('viewTransactionDate').textContent = 
                    new Date(transaction.createdAt).toLocaleString();
                document.getElementById('viewTransactionUsername').textContent = transaction.user.username;
                document.getElementById('viewTransactionEmail').textContent = transaction.user.email;
                document.getElementById('viewTransactionRole').textContent = transaction.user.role;

                const modal = new bootstrap.Modal(document.getElementById('viewTransactionModal'));
                modal.show();
            });
    }

    function exportTransactions() {
        const format = 'CSV';
        const startDate = document.getElementById('startDate').value;
        const endDate = document.getElementById('endDate').value;
        
        window.location.href = `${pageContext.request.contextPath}/admin/transactions/export?format=${format}&startDate=${startDate}&endDate=${endDate}`;
    }

    function goToPage(page) {
        window.location.href = `${pageContext.request.contextPath}/admin/transactions?page=${page}`;
    }
</script> 