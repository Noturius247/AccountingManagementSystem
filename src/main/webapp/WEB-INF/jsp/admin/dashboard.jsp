<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!-- @jsx-ignore -->
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Accounting Management System</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/static/css/main.css" rel="stylesheet">
    
    <style>
        /* Only dashboard-specific styles that are not in main.css */
        .admin-dashboard {
            padding: 2rem;
            max-width: 1400px;
            margin: 0 auto;
        }

        .chart-container {
            height: 300px;
            margin-bottom: 2rem;
        }

        .notification-badge {
            background: var(--danger-color);
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
            border-bottom: 1px solid var(--border-color);
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
            background: var(--light-color);
            color: var(--text-color);
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .tab-button.active {
            background: var(--primary-color);
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

        /* Main content area */
        .main-content {
            margin-left: 250px;
            padding: 2rem;
            transition: all 0.3s ease;
        }

        /* Top navigation bar */
        .top-nav {
            background: white;
            padding: 1rem 2rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            position: sticky;
            top: 0;
            z-index: 999;
        }

        .top-nav .nav-item {
            margin-left: 1rem;
        }

        .top-nav .nav-link {
            color: var(--text-color);
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            transition: all 0.2s ease;
        }

        .top-nav .nav-link:hover {
            background: var(--light-color);
        }

        .top-nav .dropdown-menu {
            border: none;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .top-nav .notification-badge {
            position: absolute;
            top: -5px;
            right: -5px;
        }
    </style>
</head>
<body>
    <%@ include file="../includes/admin-sidebar.jsp" %>

    <!-- Main Content -->
    <div class="main-content">
        <div class="content-header">
            <h1 id="page-title">Dashboard</h1>
            <div class="header-actions" id="dashboard-actions">
                <button class="btn btn-primary" onclick="exportDashboardData()">
                    <i class="fas fa-download"></i> Export
                </button>
                <button class="btn btn-secondary" onclick="refreshDashboard()">
                    <i class="fas fa-sync"></i> Refresh
                </button>
            </div>
        </div>

        <!-- Content Sections -->
        <div id="content-sections">
            <!-- Dashboard Section -->
            <div id="dashboard-section" class="content-section">
                <div class="dashboard-stats">
                    <div class="stat-card">
                        <h3>Total Users</h3>
                        <p>${not empty totalUsers ? totalUsers : 0}</p>
                    </div>
                    <div class="stat-card">
                        <h3>Active Users</h3>
                        <p>${not empty activeUsers ? activeUsers : 0}</p>
                    </div>
                    <div class="stat-card">
                        <h3>Total Revenue</h3>
                        <p>$${not empty totalRevenue ? totalRevenue : '0.00'}</p>
                    </div>
                    <div class="stat-card">
                        <h3>Pending Queues</h3>
                        <p>${not empty pendingQueues ? pendingQueues : 0}</p>
                    </div>
                </div>

                <div class="dashboard-charts">
                    <div class="chart-container">
                        <h3>Transaction Volume</h3>
                        <canvas id="transactionVolumeChart"></canvas>
                    </div>
                    <div class="chart-container">
                        <h3>Queue Status</h3>
                        <canvas id="queueStatusChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- Users Section -->
            <div id="users-section" class="content-section" style="display: none;">
                <%@ include file="users.jsp" %>
            </div>

            <!-- Transactions Section -->
            <div id="transactions-section" class="content-section" style="display: none;">
                <%@ include file="transactions.jsp" %>
            </div>

            <!-- Queue Section -->
            <div id="queue-section" class="content-section" style="display: none;">
                <%@ include file="queue.jsp" %>
            </div>

            <!-- Reports Section -->
            <div id="reports-section" class="content-section" style="display: none;">
                <%@ include file="reports.jsp" %>
            </div>

            <!-- Settings Section -->
            <div id="settings-section" class="content-section" style="display: none;">
                <%@ include file="settings.jsp" %>
            </div>
        </div>
    </div>

    <!-- Add User Modal -->
    <div class="modal fade" id="addUserModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="addUserForm">
                        <div class="form-group">
                            <label class="form-label">Username</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-user"></i></span>
                                <input type="text" class="form-control" name="username" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Email</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                                <input type="email" class="form-control" name="email" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Password</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                <input type="password" class="form-control" name="password" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Role</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-user-tag"></i></span>
                                <select class="form-select" name="role" required>
                                    <option value="USER">User</option>
                                    <option value="MANAGER">Manager</option>
                                    <option value="ADMIN">Admin</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" name="enabled" checked>
                                <label class="form-check-label">Active Account</label>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="submitAddUser()">Add User</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Upgrade User Role Modal -->
    <div class="modal fade" id="upgradeUserModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Upgrade User Role</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="upgradeUserForm">
                        <input type="hidden" id="upgradeUsername" name="username">
                        <div class="form-group">
                            <label class="form-label">Current Role</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-user-tag"></i></span>
                                <input type="text" class="form-control" id="currentRole" readonly>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">New Role</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-level-up-alt"></i></span>
                                <select class="form-select" id="newRole" name="role" required>
                                    <option value="STUDENT">Student</option>
                                    <option value="MANAGER">Manager</option>
                                    <option value="ADMIN">Admin</option>
                                </select>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="submitUpgradeUser()">Upgrade Role</button>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="../includes/footer.jsp" %>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const sidebarLinks = document.querySelectorAll('.sidebar .nav-link');
            const mainContent = document.querySelector('.main-content');
            
            // Handle section navigation (existing functionality)
            sidebarLinks.forEach(link => {
                link.addEventListener('click', function(e) {
                    e.preventDefault();
                    
                    // Remove active class from all links
                    sidebarLinks.forEach(l => l.classList.remove('active'));
                    
                    // Add active class to clicked link
                    this.classList.add('active');
                    
                    const sectionToShow = this.getAttribute('data-section');
                    
                    if (sectionToShow) {
                        // Hide all sections
                        const sections = document.querySelectorAll('.content-section');
                        sections.forEach(section => {
                            section.style.display = 'none';
                        });
                        
                        // Show the selected section
                        const targetSection = document.getElementById(sectionToShow + '-section');
                        if (targetSection) {
                            targetSection.style.display = 'block';
                            document.getElementById('page-title').textContent = 
                                sectionToShow.charAt(0).toUpperCase() + sectionToShow.slice(1) + ' Management';
                        }
                        
                        // Update URL without page reload
                        const newUrl = this.getAttribute('href');
                        window.history.pushState({}, '', newUrl);
                    }
                });
            });

            // Function to load JSP content
            function loadJspContent(page) {
                // Show loading state
                mainContent.innerHTML = '<div class="text-center p-5"><div class="spinner-border" role="status"><span class="visually-hidden">Loading...</span></div></div>';
                
                // Fetch the JSP content
                fetch(`${pageContext.request.contextPath}/admin/content/${page}`)
                    .then(response => response.text())
                    .then(html => {
                        mainContent.innerHTML = html;
                        // Initialize any scripts that the loaded content might need
                        executeScripts(mainContent);
                    })
                    .catch(error => {
                        mainContent.innerHTML = `
                            <div class="alert alert-danger" role="alert">
                                Failed to load content. Please try again.
                            </div>
                        `;
                        console.error('Error loading content:', error);
                    });
            }

            // Function to execute scripts in dynamically loaded content
            function executeScripts(element) {
                const scripts = element.getElementsByTagName("script");
                for (let i = 0; i < scripts.length; i++) {
                    const script = scripts[i];
                    const scriptClone = document.createElement('script');
                    scriptClone.text = script.innerHTML;
                    for (let j = 0; j < script.attributes.length; j++) {
                        const attr = script.attributes[j];
                        scriptClone.setAttribute(attr.name, attr.value);
                    }
                    script.parentNode.replaceChild(scriptClone, script);
                }
            }

            // Initialize charts with null-safe data
            initializeCharts();
            showCurrentSection();
        });

        function showAddUserModal() {
            const modal = new bootstrap.Modal(document.getElementById('addUserModal'));
            modal.show();
        }

        function submitAddUser() {
            const form = document.getElementById('addUserForm');
            const formData = new FormData(form);
            const userData = {
                username: formData.get('username'),
                email: formData.get('email'),
                password: formData.get('password'),
                role: formData.get('role'),
                enabled: formData.get('enabled') === 'on'
            };

            fetch(`${pageContext.request.contextPath}/admin/users`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(userData)
            })
            .then(response => {
                if (response.ok) {
                    window.location.reload();
                } else {
                    throw new Error('Failed to add user');
                }
            })
            .catch(error => {
                alert(error.message);
            });
        }

        function showUpgradeModal(username, currentRole) {
            document.getElementById('upgradeUsername').value = username;
            document.getElementById('currentRole').value = currentRole;
            
            // Remove current role from options
            const roleSelect = document.getElementById('newRole');
            Array.from(roleSelect.options).forEach(option => {
                if (option.value === currentRole) {
                    option.disabled = true;
                } else {
                    option.disabled = false;
                }
            });
            
            const modal = new bootstrap.Modal(document.getElementById('upgradeUserModal'));
            modal.show();
        }

        function submitUpgradeUser() {
            const username = document.getElementById('upgradeUsername').value;
            const newRole = document.getElementById('newRole').value;

            fetch(`${pageContext.request.contextPath}/admin/users/${username}/upgrade`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ role: newRole })
            })
            .then(response => {
                if (response.ok) {
                    window.location.reload();
                } else {
                    throw new Error('Failed to upgrade user role');
                }
            })
            .catch(error => {
                alert(error.message);
            });
        }

        function searchUsers() {
            const searchText = document.getElementById('userSearch').value.toLowerCase();
            const typeFilter = document.getElementById('roleFilter').value;
            const statusFilter = document.getElementById('statusFilter').value;
            
            const rows = document.querySelectorAll('#userTableBody tr');
            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                const type = row.cells[2].textContent.trim();
                const status = row.cells[3].textContent.trim();
                
                const matchesSearch = text.includes(searchText);
                const matchesType = !typeFilter || type === typeFilter;
                const matchesStatus = !statusFilter || status === statusFilter;
                
                row.style.display = matchesSearch && matchesType && matchesStatus ? '' : 'none';
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

        // Initialize charts with null-safe data
        function initializeCharts() {
            // Transaction Volume Chart
            const transactionCtx = document.getElementById('transactionVolumeChart');
            if (transactionCtx) {
                new Chart(transactionCtx, {
                    type: 'line',
                    data: {
                        labels: ${not empty transactionLabels ? transactionLabels : '[]'},
                        datasets: [{
                            label: 'Transactions',
                            data: ${not empty transactionData ? transactionData : '[]'},
                            borderColor: '#4e73df',
                            backgroundColor: 'rgba(78, 115, 223, 0.05)',
                            fill: true
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false
                    }
                });
            }

            // Queue Status Chart
            const queueCtx = document.getElementById('queueStatusChart');
            if (queueCtx) {
                new Chart(queueCtx, {
                    type: 'doughnut',
                    data: {
                        labels: ${not empty queueLabels ? queueLabels : '[]'},
                        datasets: [{
                            data: ${not empty queueData ? queueData : '[]'},
                            backgroundColor: ['#4e73df', '#1cc88a', '#36b9cc']
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false
                    }
                });
            }
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

        // Function to show the appropriate section based on the current URL
        function showCurrentSection() {
            const path = window.location.pathname;
            const sections = document.querySelectorAll('.content-section');
            
            // Hide all sections first
            sections.forEach(section => section.style.display = 'none');
            
            // Show the appropriate section based on the URL
            if (path.includes('/admin/users')) {
                document.getElementById('users-section').style.display = 'block';
                document.getElementById('page-title').textContent = 'Users Management';
            } else if (path.includes('/admin/transactions')) {
                document.getElementById('transactions-section').style.display = 'block';
                document.getElementById('page-title').textContent = 'Transactions Management';
            } else if (path.includes('/admin/queue')) {
                document.getElementById('queue-section').style.display = 'block';
                document.getElementById('page-title').textContent = 'Queue Management';
            } else if (path.includes('/admin/reports')) {
                document.getElementById('reports-section').style.display = 'block';
                document.getElementById('page-title').textContent = 'Reports Management';
            } else if (path.includes('/admin/settings')) {
                document.getElementById('settings-section').style.display = 'block';
                document.getElementById('page-title').textContent = 'Settings Management';
            } else {
                document.getElementById('dashboard-section').style.display = 'block';
                document.getElementById('page-title').textContent = 'Dashboard';
            }
        }
    </script>
</body>
</html> 