<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="admin-users">
    <div class="content-header">
        <h1>User Management</h1>
        <div class="header-actions">
            <button class="btn btn-primary" onclick="showAddUserModal()">
                <i class="bi bi-plus-lg"></i> Add User
            </button>
            <div class="dropdown">
                <button class="btn btn-secondary dropdown-toggle" type="button" id="bulkActionsDropdown" data-bs-toggle="dropdown">
                    <i class="bi bi-check2-square"></i> Bulk Actions
                </button>
                <ul class="dropdown-menu">
                    <li><a class="dropdown-item" href="#" onclick="bulkEnableUsers()">Enable Selected</a></li>
                    <li><a class="dropdown-item" href="#" onclick="bulkDisableUsers()">Disable Selected</a></li>
                    <li><a class="dropdown-item" href="#" onclick="bulkDeleteUsers()">Delete Selected</a></li>
                    <li><a class="dropdown-item" href="#" onclick="bulkExportUsers()">Export Selected</a></li>
                </ul>
            </div>
        </div>
    </div>

    <!-- Filters and Search -->
    <div class="card mb-4">
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-3">
                    <input type="text" class="form-control" id="userSearch" placeholder="Search users...">
                </div>
                <div class="col-md-2">
                    <select class="form-select" id="roleFilter">
                        <option value="">All Roles</option>
                        <option value="USER">User</option>
                        <option value="MANAGER">Manager</option>
                        <option value="ADMIN">Admin</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <select class="form-select" id="statusFilter">
                        <option value="">All Status</option>
                        <option value="true">Active</option>
                        <option value="false">Inactive</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <input type="date" class="form-control" id="dateFilter" placeholder="Filter by date">
                </div>
                <div class="col-md-2">
                    <button class="btn btn-outline-secondary w-100" onclick="resetFilters()">
                        <i class="bi bi-x-lg"></i> Reset
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Users Table -->
    <div class="card">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="selectAllUsers">
                                </div>
                            </th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Last Login</th>
                            <th>Created</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${users}" var="user">
                            <tr>
                                <td>
                                    <div class="form-check">
                                        <input class="form-check-input user-checkbox" type="checkbox" value="${user.id}">
                                    </div>
                                </td>
                                <td>${user.username}</td>
                                <td>${user.email}</td>
                                <td>
                                    <span class="badge bg-info">${user.role}</span>
                                </td>
                                <td>
                                    <span class="badge ${user.enabled ? 'bg-success' : 'bg-danger'}">
                                        ${user.enabled ? 'Active' : 'Inactive'}
                                    </span>
                                </td>
                                <td>
                                    <c:if test="${not empty user.lastActivity}">
                                        <fmt:formatDate value="${user.lastActivity}" pattern="MMM dd, yyyy HH:mm"/>
                                    </c:if>
                                    <c:if test="${empty user.lastActivity}">
                                        Never
                                    </c:if>
                                </td>
                                <td>
                                    <c:if test="${not empty user.createdAt}">
                                        <fmt:formatDate value="${user.createdAt}" pattern="MMM dd, yyyy"/>
                                    </c:if>
                                    <c:if test="${empty user.createdAt}">
                                        N/A
                                    </c:if>
                                </td>
                                <td>
                                    <div class="btn-group">
                                        <button class="btn btn-sm btn-primary" onclick="viewUserHistory('${user.id}')">
                                            <i class="bi bi-clock-history"></i>
                                        </button>
                                        <button class="btn btn-sm btn-info" onclick="editUser('${user.id}')">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                                        <button class="btn btn-sm btn-danger" onclick="deleteUser('${user.id}')">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- User History Modal -->
    <div class="modal fade" id="userHistoryModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">User Activity History</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="timeline">
                        <div id="userHistoryContent">
                            <!-- History items will be loaded here -->
                        </div>
                    </div>
                </div>
            </div>
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
                            <span class="input-group-text"><i class="bi bi-person"></i></span>
                            <input type="text" class="form-control" name="username" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Email</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                            <input type="email" class="form-control" name="email" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Password</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-lock"></i></span>
                            <input type="password" class="form-control" name="password" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Role</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-person-badge"></i></span>
                            <select class="form-select" name="role" required>
                                <option value="ROLE_USER">User</option>
                                <option value="ROLE_MANAGER">Manager</option>
                                <option value="ROLE_ADMIN">Admin</option>
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
                            <span class="input-group-text"><i class="bi bi-person-badge"></i></span>
                            <input type="text" class="form-control" id="currentRole" readonly>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">New Role</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-arrow-up-circle"></i></span>
                            <select class="form-select" id="newRole" name="role" required>
                                <option value="ROLE_USER">User</option>
                                <option value="ROLE_MANAGER">Manager</option>
                                <option value="ROLE_ADMIN">Admin</option>
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

<style>
    .admin-users {
        padding: 2rem;
    }

    .timeline {
        position: relative;
        padding: 1rem 0;
    }

    .timeline-item {
        position: relative;
        padding-left: 2rem;
        margin-bottom: 1.5rem;
    }

    .timeline-item::before {
        content: '';
        position: absolute;
        left: 0;
        top: 0;
        width: 1px;
        height: 100%;
        background-color: #dee2e6;
    }

    .timeline-marker {
        position: absolute;
        left: -0.5rem;
        top: 0;
        width: 1rem;
        height: 1rem;
        border-radius: 50%;
        background-color: var(--primary-color);
    }

    .timeline-content {
        background: #f8f9fa;
        padding: 1rem;
        border-radius: 0.5rem;
    }

    .timeline-date {
        font-size: 0.875rem;
        color: #6c757d;
    }

    .timeline-action {
        font-weight: 500;
        margin-bottom: 0.5rem;
    }

    .timeline-details {
        font-size: 0.875rem;
        color: #495057;
    }
</style>

<script>
    // Initialize page
    document.addEventListener('DOMContentLoaded', function() {
        initializeUserManagement();
    });

    function initializeUserManagement() {
        // Initialize select all checkbox
        const selectAll = document.getElementById('selectAllUsers');
        if (selectAll) {
            selectAll.addEventListener('change', function() {
                document.querySelectorAll('.user-checkbox').forEach(checkbox => {
                    checkbox.checked = this.checked;
                });
            });
        }

        // Initialize search and filters
        const searchInput = document.getElementById('userSearch');
        const roleFilter = document.getElementById('roleFilter');
        const statusFilter = document.getElementById('statusFilter');
        const dateFilter = document.getElementById('dateFilter');

        if (searchInput) searchInput.addEventListener('input', filterUsers);
        if (roleFilter) roleFilter.addEventListener('change', filterUsers);
        if (statusFilter) statusFilter.addEventListener('change', filterUsers);
        if (dateFilter) dateFilter.addEventListener('change', filterUsers);
    }

    function filterUsers() {
        const searchText = document.getElementById('userSearch').value.toLowerCase();
        const roleFilter = document.getElementById('roleFilter').value;
        const statusFilter = document.getElementById('statusFilter').value;
        const dateFilter = document.getElementById('dateFilter').value;

        document.querySelectorAll('tbody tr').forEach(row => {
            const username = row.cells[1].textContent.toLowerCase();
            const email = row.cells[2].textContent.toLowerCase();
            const role = row.cells[3].textContent.trim();
            const status = row.cells[4].textContent.trim();
            const createdDate = row.cells[6].textContent.trim();

            const matchesSearch = username.includes(searchText) || email.includes(searchText);
            const matchesRole = !roleFilter || role === roleFilter;
            const matchesStatus = !statusFilter || 
                (statusFilter === 'true' && status === 'Active') || 
                (statusFilter === 'false' && status === 'Inactive');
            const matchesDate = !dateFilter || createdDate.includes(dateFilter);

            row.style.display = matchesSearch && matchesRole && matchesStatus && matchesDate ? '' : 'none';
        });
    }

    function resetFilters() {
        document.getElementById('userSearch').value = '';
        document.getElementById('roleFilter').value = '';
        document.getElementById('statusFilter').value = '';
        document.getElementById('dateFilter').value = '';
        filterUsers();
    }

    // Bulk Actions
    function getSelectedUsers() {
        return Array.from(document.querySelectorAll('input[name="selectedUsers"]:checked'))
            .map(checkbox => checkbox.value);
    }

    function bulkEnableUsers() {
        const selectedUsers = getSelectedUsers();
        if (selectedUsers.length === 0) {
            alert('Please select at least one user');
            return;
        }

        if (confirm(`Are you sure you want to enable ${selectedUsers.length} user(s)?`)) {
            fetch('${pageContext.request.contextPath}/admin/users/bulk-enable', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(selectedUsers)
            })
            .then(response => {
                if (response.ok) {
                    location.reload();
                } else {
                    throw new Error('Failed to enable users');
                }
            })
            .catch(error => {
                alert(error.message);
            });
        }
    }

    function bulkDisableUsers() {
        const selectedUsers = getSelectedUsers();
        if (selectedUsers.length === 0) {
            alert('Please select at least one user');
            return;
        }

        if (confirm(`Are you sure you want to disable ${selectedUsers.length} user(s)?`)) {
            fetch('${pageContext.request.contextPath}/admin/users/bulk-disable', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(selectedUsers)
            })
            .then(response => {
                if (response.ok) {
                    location.reload();
                } else {
                    throw new Error('Failed to disable users');
                }
            })
            .catch(error => {
                alert(error.message);
            });
        }
    }

    function bulkDeleteUsers() {
        const selectedUsers = getSelectedUsers();
        if (selectedUsers.length === 0) {
            alert('Please select at least one user');
            return;
        }

        if (confirm(`Are you sure you want to delete ${selectedUsers.length} user(s)? This action cannot be undone.`)) {
            fetch('${pageContext.request.contextPath}/admin/users/bulk-delete', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(selectedUsers)
            })
            .then(response => {
                if (response.ok) {
                    location.reload();
                } else {
                    throw new Error('Failed to delete users');
                }
            })
            .catch(error => {
                alert(error.message);
            });
        }
    }

    function bulkExportUsers() {
        const selectedUsers = getSelectedUsers();
        if (selectedUsers.length === 0) {
            alert('Please select at least one user');
            return;
        }

        window.location.href = `${pageContext.request.contextPath}/admin/users/export?ids=${selectedUsers.join(',')}`;
    }

    // User History
    function viewUserHistory(userId) {
        const modal = new bootstrap.Modal(document.getElementById('userHistoryModal'));
        const content = document.getElementById('userHistoryContent');
        
        // Show loading state
        content.innerHTML = '<div class="text-center"><div class="spinner-border" role="status"></div></div>';
        modal.show();

        // Fetch user history
        fetch(`${pageContext.request.contextPath}/admin/users/${userId}/history`)
            .then(response => response.json())
            .then(data => {
                content.innerHTML = data.map(event => {
                    const date = new Date(event.timestamp);
                    return `
                    <div class="timeline-item">
                        <div class="timeline-marker"></div>
                        <div class="timeline-content">
                            <div class="timeline-date">
                                ${date.toLocaleString()}
                            </div>
                            <div class="timeline-action">
                                ${event.action}
                            </div>
                            <div class="timeline-details">
                                ${event.details}
                            </div>
                        </div>
                    </div>
                    `;
                }).join('');
            })
            .catch(error => {
                content.innerHTML = `
                    <div class="alert alert-danger">
                        Failed to load user history: ${error.message}
                    </div>
                `;
            });
    }

    // Individual User Actions
    function editUser(userId) {
        window.location.href = `${pageContext.request.contextPath}/admin/users/${userId}/edit`;
    }

    function deleteUser(userId) {
        if (confirm('Are you sure you want to delete this user? This action cannot be undone.')) {
            fetch(`${pageContext.request.contextPath}/admin/users/${userId}`, {
                method: 'DELETE'
            })
            .then(response => {
                if (response.ok) {
                    location.reload();
                } else {
                    throw new Error('Failed to delete user');
                }
            })
            .catch(error => {
                alert(error.message);
            });
        }
    }
</script>