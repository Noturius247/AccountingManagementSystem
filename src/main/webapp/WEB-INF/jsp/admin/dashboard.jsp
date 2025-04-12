<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- @jsx-ignore -->
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Accounting Management System</title>
    <link rel="stylesheet" href="../../css/main.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', sans-serif;
        }

        body {
            background-color: #f5f7fa;
            color: #1a1f36;
        }

        .admin-dashboard {
            padding: 2rem;
            max-width: 1400px;
            margin: 0 auto;
        }

        h1 {
            font-size: 2rem;
            font-weight: 600;
            margin-bottom: 2rem;
            color: #1a1f36;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: #ffffff;
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
        }

        .stat-card h3 {
            font-size: 0.875rem;
            font-weight: 500;
            color: #6b7280;
            margin-bottom: 0.5rem;
        }

        .stat-card .value {
            font-size: 1.875rem;
            font-weight: 600;
            color: #2563eb;
        }

        .admin-section {
            background: #ffffff;
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            margin-bottom: 2rem;
        }

        .admin-section h2 {
            font-size: 1.25rem;
            font-weight: 600;
            color: #1a1f36;
            margin-bottom: 1.5rem;
        }

        .search-section {
            display: flex;
            gap: 1rem;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
        }

        .search-section input,
        .search-section select {
            padding: 0.75rem 1rem;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            font-size: 0.875rem;
            flex: 1;
            min-width: 200px;
            outline: none;
            transition: border-color 0.2s ease;
        }

        .search-section input:focus,
        .search-section select:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-bottom: 1rem;
        }

        .table th,
        .table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #e5e7eb;
        }

        .table th {
            background-color: #f8fafc;
            font-weight: 500;
            color: #6b7280;
            font-size: 0.875rem;
        }

        .table tr:last-child td {
            border-bottom: none;
        }

        .btn-action {
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            font-size: 0.875rem;
            transition: all 0.2s ease;
        }

        .btn-edit {
            background: #fef3c7;
            color: #92400e;
        }

        .btn-edit:hover {
            background: #fde68a;
        }

        .btn-delete {
            background: #fee2e2;
            color: #b91c1c;
        }

        .btn-delete:hover {
            background: #fecaca;
        }

        .pagination {
            display: flex;
            justify-content: center;
            gap: 0.75rem;
            margin-top: 1.5rem;
        }

        .pagination button {
            padding: 0.5rem 1rem;
            border: 1px solid #e5e7eb;
            border-radius: 6px;
            background: #ffffff;
            color: #4b5563;
            font-weight: 500;
            font-size: 0.875rem;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .pagination button:hover:not(:disabled) {
            background: #f3f4f6;
            border-color: #d1d5db;
        }

        .pagination button:disabled {
            background: #f3f4f6;
            color: #9ca3af;
            cursor: not-allowed;
        }

        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(4px);
            z-index: 1000;
        }

        .modal-content {
            background: #ffffff;
            margin: 5% auto;
            padding: 2rem;
            width: 90%;
            max-width: 500px;
            border-radius: 12px;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
        }

        .modal-content h2 {
            margin-bottom: 1.5rem;
            font-size: 1.5rem;
            font-weight: 600;
        }

        .modal-content form > div {
            margin-bottom: 1.5rem;
        }

        .modal-content label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: #374151;
        }

        .modal-content input,
        .modal-content select {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            font-size: 0.875rem;
            transition: all 0.2s ease;
        }

        .modal-content input:focus,
        .modal-content select:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
            outline: none;
        }

        .modal-content button[type="submit"] {
            background: #2563eb;
            color: white;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.2s ease;
        }

        .modal-content button[type="submit"]:hover {
            background: #1d4ed8;
        }

        .modal-content button[type="button"] {
            background: #f3f4f6;
            color: #4b5563;
            padding: 0.75rem 1.5rem;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            margin-left: 0.75rem;
            transition: all 0.2s ease;
        }

        .modal-content button[type="button"]:hover {
            background: #e5e7eb;
        }

        @media (max-width: 768px) {
            .admin-dashboard {
                padding: 1rem;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .search-section {
                flex-direction: column;
            }

            .search-section input,
            .search-section select {
                width: 100%;
            }

            .table {
                display: block;
                overflow-x: auto;
                white-space: nowrap;
            }
        }

        .chart-container {
            height: 300px;
            margin-bottom: 2rem;
        }
        
        .notification-badge {
            background: #ef4444;
            color: white;
            padding: 0.25rem 0.5rem;
            border-radius: 9999px;
            font-size: 0.75rem;
        }

        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 500;
        }

        .status-pending { background: #fef3c7; color: #92400e; }
        .status-completed { background: #dcfce7; color: #166534; }
        .status-failed { background: #fee2e2; color: #b91c1c; }
        .status-processing { background: #dbeafe; color: #1e40af; }

        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .notification-list {
            max-height: 300px;
            overflow-y: auto;
        }

        .notification-item {
            padding: 1rem;
            border-bottom: 1px solid #e5e7eb;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .notification-item:last-child {
            border-bottom: none;
        }

        .tab-container {
            margin-bottom: 1.5rem;
        }

        .tab-buttons {
            display: flex;
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .tab-button {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 8px;
            background: #f3f4f6;
            color: #4b5563;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .tab-button.active {
            background: #2563eb;
            color: white;
        }

        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
        }

        .chart-legend {
            display: flex;
            gap: 1rem;
            margin-top: 1rem;
            flex-wrap: wrap;
        }

        .legend-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .legend-color {
            width: 12px;
            height: 12px;
            border-radius: 3px;
        }
    </style>
</head>
<body>
    <%@ include file="../includes/header.jsp" %>
    
    <div class="admin-dashboard">
        <h1>Admin Dashboard</h1>
        
        <div class="stats-grid">
            <div class="stat-card">
                <h3>Total Users</h3>
                <div class="value">${totalUsers}</div>
            </div>
            <div class="stat-card">
                <h3>Active Users</h3>
                <div class="value">${activeUsers}</div>
            </div>
            <div class="stat-card">
                <h3>Total Revenue</h3>
                <div class="value">$${totalRevenue}</div>
            </div>
            <div class="stat-card">
                <h3>Pending Queues</h3>
                <div class="value">${pendingQueues}</div>
            </div>
            <div class="stat-card">
                <h3>Today's Transactions</h3>
                <div class="value">${todayTransactions}</div>
            </div>
            <div class="stat-card">
                <h3>Average Wait Time</h3>
                <div class="value">${averageWaitTime} min</div>
            </div>
        </div>

        <div class="admin-section">
            <h2>Analytics Overview</h2>
            <div class="dashboard-grid">
                <div class="chart-container" id="transactionChart">
                    <!-- Transaction Chart will be rendered here -->
                </div>
                <div class="chart-container" id="queueChart">
                    <!-- Queue Chart will be rendered here -->
                </div>
            </div>
        </div>

        <div class="admin-section">
            <h2>Queue Management</h2>
            <div class="search-section">
                <input type="text" id="queueSearch" placeholder="Search queues...">
                <select id="queueStatusFilter">
                    <option value="">All Status</option>
                    <option value="WAITING">Waiting</option>
                    <option value="PROCESSING">Processing</option>
                    <option value="COMPLETED">Completed</option>
                    <option value="CANCELLED">Cancelled</option>
                </select>
                <select id="queuePriorityFilter">
                    <option value="">All Priorities</option>
                    <option value="LOW">Low</option>
                    <option value="MEDIUM">Medium</option>
                    <option value="HIGH">High</option>
                    <option value="URGENT">Urgent</option>
                </select>
            </div>
            <table class="table">
                <thead>
                    <tr>
                        <th>Queue Number</th>
                        <th>User</th>
                        <th>Status</th>
                        <th>Priority</th>
                        <th>Wait Time</th>
                        <th>Created At</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="queueTableBody">
                    <c:forEach items="${queues}" var="queue">
                        <tr>
                            <td>${queue.queueNumber}</td>
                            <td>${queue.userUsername}</td>
                            <td><span class="status-badge status-${queue.status.toLowerCase()}">${queue.status}</span></td>
                            <td>${queue.priority}</td>
                            <td>${queue.estimatedWaitTime} min</td>
                            <td>${queue.createdAt}</td>
                            <td>
                                <button class="btn-action btn-edit" onclick="processQueue('${queue.id}')">Process</button>
                                <button class="btn-action btn-delete" onclick="cancelQueue('${queue.id}')">Cancel</button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <div class="admin-section">
            <h2>User Management</h2>
            <div class="search-section">
                <input type="text" id="userSearch" placeholder="Search users..." onkeyup="searchUsers()">
                <select id="roleFilter" onchange="filterUsers()">
                    <option value="">All Roles</option>
                    <option value="USER">User</option>
                    <option value="MANAGER">Manager</option>
                    <option value="ADMIN">Admin</option>
                </select>
                <select id="statusFilter" onchange="filterUsers()">
                    <option value="">All Status</option>
                    <option value="true">Active</option>
                    <option value="false">Inactive</option>
                </select>
                <button class="btn-action" onclick="showAddUserModal()">Add New User</button>
            </div>
            <table class="table">
                <thead>
                    <tr>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="userTableBody">
                    <c:forEach items="${users}" var="user">
                        <tr>
                            <td>${user.username}</td>
                            <td>${user.email}</td>
                            <td>${user.role}</td>
                            <td>${user.enabled ? 'Active' : 'Inactive'}</td>
                            <td>
                                <button class="btn-action btn-edit" onclick="editUser('${user.username}')">Edit</button>
                                <button class="btn-action btn-delete" onclick="deleteUser('${user.username}')">Delete</button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <div class="pagination">
                <button onclick="prevPage()" ${currentPage == 1 ? 'disabled' : ''}>Previous</button>
                <span>Page ${currentPage} of ${totalPages}</span>
                <button onclick="nextPage()" ${currentPage == totalPages ? 'disabled' : ''}>Next</button>
            </div>
        </div>

        <div class="admin-section">
            <h2>Transaction Management</h2>
            <div class="tab-container">
                <div class="tab-buttons">
                    <button class="tab-button active" onclick="switchTab('recent')">Recent</button>
                    <button class="tab-button" onclick="switchTab('pending')">Pending</button>
                    <button class="tab-button" onclick="switchTab('completed')">Completed</button>
                    <button class="tab-button" onclick="switchTab('failed')">Failed</button>
                </div>
                <div class="search-section">
                    <input type="text" id="transactionSearch" placeholder="Search transactions...">
                    <input type="date" id="startDate">
                    <input type="date" id="endDate">
                    <select id="transactionTypeFilter">
                        <option value="">All Types</option>
                        <option value="PAYMENT">Payment</option>
                        <option value="REFUND">Refund</option>
                        <option value="ADJUSTMENT">Adjustment</option>
                    </select>
                    <button class="btn-action" onclick="exportTransactions()">Export</button>
                </div>
            </div>
            <table class="table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>User</th>
                        <th>Amount</th>
                        <th>Type</th>
                        <th>Priority</th>
                        <th>Status</th>
                        <th>Date</th>
                    </tr>
                </thead>
                <tbody id="transactionTableBody">
                    <c:forEach items="${recentTransactions}" var="transaction">
                        <tr>
                            <td>${transaction.id}</td>
                            <td>${transaction.user.username}</td>
                            <td>$${transaction.amount}</td>
                            <td>${transaction.type}</td>
                            <td>${transaction.priority}</td>
                            <td>${transaction.status}</td>
                            <td>${transaction.createdAt}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <div class="admin-section">
            <h2>Notification Center</h2>
            <div class="notification-list">
                <c:forEach items="${notifications}" var="notification">
                    <div class="notification-item">
                        <span class="notification-badge">${notification.type}</span>
                        <div>
                            <p>${notification.message}</p>
                            <small>${notification.createdAt}</small>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <!-- Edit User Modal -->
    <div id="editUserModal" class="modal">
        <div class="modal-content">
            <h2>Edit User</h2>
            <form id="editUserForm">
                <input type="hidden" id="editUsername">
                <div>
                    <label>Email:</label>
                    <input type="email" id="editEmail" required>
                </div>
                <div>
                    <label>Role:</label>
                    <select id="editRole" required>
                        <option value="USER">User</option>
                        <option value="MANAGER">Manager</option>
                        <option value="ADMIN">Admin</option>
                    </select>
                </div>
                <div>
                    <label>Status:</label>
                    <select id="editStatus" required>
                        <option value="true">Active</option>
                        <option value="false">Inactive</option>
                    </select>
                </div>
                <button type="submit">Save Changes</button>
                <button type="button" onclick="closeModal()">Cancel</button>
            </form>
        </div>
    </div>

    <!-- Edit Transaction Modal -->
    <div id="editTransactionModal" class="modal">
        <div class="modal-content">
            <h2>Edit Transaction</h2>
            <form id="editTransactionForm">
                <input type="hidden" id="editTransactionId">
                <div>
                    <label>Priority:</label>
                    <select id="editPriority" required>
                        <option value="LOW">Low</option>
                        <option value="MEDIUM">Medium</option>
                        <option value="HIGH">High</option>
                        <option value="URGENT">Urgent</option>
                    </select>
                </div>
                <div>
                    <label>Status:</label>
                    <select id="editTransactionStatus" required>
                        <option value="PENDING">Pending</option>
                        <option value="COMPLETED">Completed</option>
                        <option value="FAILED">Failed</option>
                    </select>
                </div>
                <button type="submit">Save Changes</button>
                <button type="button" onclick="closeTransactionModal()">Cancel</button>
            </form>
        </div>
    </div>

    <!-- Add User Modal -->
    <div id="addUserModal" class="modal">
        <!-- Add user form structure -->
    </div>

    <!-- Process Queue Modal -->
    <div id="processQueueModal" class="modal">
        <!-- Process queue form structure -->
    </div>

    <!-- Export Options Modal -->
    <div id="exportModal" class="modal">
        <!-- Export options form structure -->
    </div>

    <%@ include file="../includes/footer.jsp" %>
    
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <script>
        function searchUsers() {
            const searchText = document.getElementById('userSearch').value.toLowerCase();
            const rows = document.querySelectorAll('#userTableBody tr');
            rows.forEach(row => {
                const username = row.cells[0].textContent.toLowerCase();
                const email = row.cells[1].textContent.toLowerCase();
                if (username.includes(searchText) || email.includes(searchText)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        function filterUsers() {
            const role = document.getElementById('roleFilter').value;
            const status = document.getElementById('statusFilter').value;
            const rows = document.querySelectorAll('#userTableBody tr');
            rows.forEach(row => {
                const userRole = row.cells[2].textContent;
                const userStatus = row.cells[3].textContent;
                if (!role || userRole === role) {
                    if (!status || userStatus === status) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                } else {
                    row.style.display = 'none';
                }
            });
        }

        function editUser(username) {
            document.getElementById('editUserModal').style.display = 'block';
            document.getElementById('editUsername').value = username;
            // Fetch user details and populate form
            fetch(`${pageContext.request.contextPath}/admin/user/` + username)
                .then(response => response.json())
                .then(user => {
                    document.getElementById('editEmail').value = user.email;
                    document.getElementById('editRole').value = user.role;
                    document.getElementById('editStatus').value = user.enabled;
                });
        }

        function deleteUser(username) {
            if (confirm('Are you sure you want to delete this user?')) {
                fetch(`${pageContext.request.contextPath}/admin/user/` + username, {
                    method: 'DELETE'
                }).then(() => {
                    window.location.reload();
                });
            }
        }

        function closeModal() {
            document.getElementById('editUserModal').style.display = 'none';
        }

        function prevPage() {
            if (<c:out value="${currentPage}"/> > 1) {
                window.location.href = '<c:out value="${pageContext.request.contextPath}"/>/admin/dashboard?page=<c:out value="${currentPage - 1}"/>';
            }
        }

        function nextPage() {
            var currentPage = <c:out value="${currentPage}"/>;
            var totalPages = <c:out value="${totalPages}"/>;
            if (currentPage < totalPages) {
                window.location.href = '<c:out value="${pageContext.request.contextPath}"/>/admin/dashboard?page=' + (currentPage + 1);
            }
        }

        document.getElementById('editUserForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const username = document.getElementById('editUsername').value;
            const userData = {
                email: document.getElementById('editEmail').value,
                role: document.getElementById('editRole').value,
                enabled: document.getElementById('editStatus').value === 'true'
            };
            
            fetch(`${pageContext.request.contextPath}/admin/user/` + username, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(userData)
            }).then(() => {
                window.location.reload();
            });
        });

        function editTransaction(id) {
            document.getElementById('editTransactionModal').style.display = 'block';
            document.getElementById('editTransactionId').value = id;
            // Fetch transaction details and populate form
            fetch(`${pageContext.request.contextPath}/admin/transaction/` + id)
                .then(response => response.json())
                .then(transaction => {
                    document.getElementById('editPriority').value = transaction.priority;
                    document.getElementById('editTransactionStatus').value = transaction.status;
                });
        }

        function closeTransactionModal() {
            document.getElementById('editTransactionModal').style.display = 'none';
        }

        document.getElementById('editTransactionForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const id = document.getElementById('editTransactionId').value;
            const transactionData = {
                priority: document.getElementById('editPriority').value,
                status: document.getElementById('editTransactionStatus').value
            };
            
            fetch(`${pageContext.request.contextPath}/admin/transaction/` + id, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(transactionData)
            }).then(() => {
                window.location.reload();
            });
        });

        function processQueue(queueId) {
            fetch(`${pageContext.request.contextPath}/admin/queue/${queueId}/process`, {
                method: 'POST'
            }).then(() => {
                window.location.reload();
            });
        }

        function cancelQueue(queueId) {
            if (confirm('Are you sure you want to cancel this queue?')) {
                fetch(`${pageContext.request.contextPath}/admin/queue/${queueId}/cancel`, {
                    method: 'POST'
                }).then(() => {
                    window.location.reload();
                });
            }
        }

        // Chart data from server
        const chartData = {
            transaction: {
                labels: JSON.parse('${transactionLabels}'),
                data: JSON.parse('${transactionData}')
            },
            queue: {
                labels: JSON.parse('${queueLabels}'),
                data: JSON.parse('${queueData}')
            }
        };

        function initializeCharts() {
            // Transaction Chart
            const transactionCtx = document.getElementById('transactionChart').getContext('2d');
            new Chart(transactionCtx, {
                type: 'line',
                data: {
                    labels: chartData.transaction.labels,
                    datasets: [{
                        label: 'Transactions',
                        data: chartData.transaction.data,
                        borderColor: '#2563eb'
                    }]
                }
            });

            // Queue Chart
            const queueCtx = document.getElementById('queueChart').getContext('2d');
            new Chart(queueCtx, {
                type: 'pie',
                data: {
                    labels: chartData.queue.labels,
                    datasets: [{
                        data: chartData.queue.data,
                        backgroundColor: ['#fef3c7', '#dbeafe', '#dcfce7', '#fee2e2']
                    }]
                }
            });
        }

        function switchTab(tabName) {
            document.querySelectorAll('.tab-button').forEach(btn => btn.classList.remove('active'));
            document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));
            
            document.querySelector(`[data-tab="${tabName}"]`).classList.add('active');
            document.getElementById(`${tabName}Content`).classList.add('active');
            
            // Load data based on selected tab
            loadTabData(tabName);
        }

        function exportTransactions() {
            const format = document.getElementById('exportFormat').value;
            const startDate = document.getElementById('startDate').value;
            const endDate = document.getElementById('endDate').value;
            
            window.location.href = `${pageContext.request.contextPath}/admin/transactions/export?format=${format}&startDate=${startDate}&endDate=${endDate}`;
        }

        document.addEventListener('DOMContentLoaded', function() {
            initializeCharts();
            // Set up real-time updates
            setInterval(updateDashboard, 30000); // Update every 30 seconds
        });

        function updateDashboard() {
            fetch(`${pageContext.request.contextPath}/admin/dashboard/stats`)
                .then(response => response.json())
                .then(data => {
                    // Update statistics
                    updateStats(data);
                    // Update charts
                    updateCharts(data);
                    // Update notifications
                    updateNotifications(data);
                });
        }
    </script>
</body>
</html> 