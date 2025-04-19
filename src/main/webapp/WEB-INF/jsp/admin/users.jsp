<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="admin-content">
    <div class="dashboard-header">
        <h1>User Management</h1>
        <div class="action-buttons">
            <button type="button" class="btn btn-primary" onclick="showAddUserModal()">
                <i class="fas fa-user-plus"></i> Add User
            </button>
        </div>
    </div>

    <!-- Search and Filter Section -->
    <div class="search-section">
        <div class="search-box">
            <i class="fas fa-search"></i>
            <input type="text" id="userSearch" placeholder="Search users..." onkeyup="searchUsers()">
        </div>
        <div class="filter-box">
            <select id="roleFilter" class="form-select" onchange="filterUsers()">
                <option value="">All Roles</option>
                <option value="USER">User</option>
                <option value="MANAGER">Manager</option>
                <option value="ADMIN">Admin</option>
            </select>
        </div>
        <div class="filter-box">
            <select id="statusFilter" class="form-select" onchange="filterUsers()">
                <option value="">All Status</option>
                <option value="true">Active</option>
                <option value="false">Inactive</option>
            </select>
        </div>
    </div>

    <!-- Users Table -->
    <div class="card shadow">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Last Activity</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="userTableBody">
                        <c:forEach items="${users}" var="user">
                            <tr>
                                <td>
                                    <div class="user-info">
                                        <div class="user-avatar">
                                            <i class="fas fa-user-circle"></i>
                                        </div>
                                        <div class="user-details">
                                            <span class="username">${user.username}</span>
                                            <span class="user-fullname">${user.firstName} ${user.lastName}</span>
                                        </div>
                                    </div>
                                </td>
                                <td>${user.email}</td>
                                <td>
                                    <span class="role-badge role-${fn:toLowerCase(user.role)}">
                                        ${user.role}
                                    </span>
                                </td>
                                <td>
                                    <span class="status-badge status-${user.enabled ? 'active' : 'inactive'}">
                                        ${user.enabled ? 'Active' : 'Inactive'}
                                    </span>
                                </td>
                                <td>
                                    <c:if test="${not empty user.lastActivity}">
                                        <span class="last-activity">
                                            <i class="fas fa-clock"></i>
                                            ${fn:substring(user.lastActivity.toString(), 0, 16)}
                                        </span>
                                    </c:if>
                                    <c:if test="${empty user.lastActivity}">
                                        <span class="last-activity never">
                                            <i class="fas fa-clock"></i>
                                            Never
                                        </span>
                                    </c:if>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <button class="btn btn-sm btn-primary" onclick="editUser('${user.username}')" title="Edit User">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button class="btn btn-sm btn-info" onclick="showUpgradeModal('${user.username}', '${user.role}')" title="Upgrade Role">
                                            <i class="fas fa-level-up-alt"></i>
                                        </button>
                                        <button class="btn btn-sm btn-danger" onclick="deleteUser('${user.username}')" title="Delete User">
                                            <i class="fas fa-trash"></i>
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

    <!-- Pagination -->
    <nav aria-label="Page navigation" class="mt-3">
        <ul class="pagination justify-content-center">
            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                <a class="page-link" href="#" onclick="prevPage()">
                    <i class="fas fa-chevron-left"></i>
                </a>
            </li>
            <c:forEach begin="1" end="${totalPages}" var="i">
                <li class="page-item ${currentPage == i ? 'active' : ''}">
                    <a class="page-link" href="#" onclick="goToPage(${i})">${i}</a>
                </li>
            </c:forEach>
            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                <a class="page-link" href="#" onclick="nextPage()">
                    <i class="fas fa-chevron-right"></i>
                </a>
            </li>
        </ul>
    </nav>
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

<style>
    .user-info {
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .user-avatar {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background: var(--light-color);
        display: flex;
        align-items: center;
        justify-content: center;
        color: var(--primary-color);
        font-size: 20px;
    }

    .user-details {
        display: flex;
        flex-direction: column;
    }

    .username {
        font-weight: 500;
        color: var(--dark-color);
    }

    .user-fullname {
        font-size: 12px;
        color: #666;
    }

    .role-badge {
        padding: 6px 12px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 500;
        display: inline-block;
    }

    .role-user {
        background: #e3f2fd;
        color: #1976d2;
    }

    .role-manager {
        background: #fff3e0;
        color: #f57c00;
    }

    .role-admin {
        background: #fce4ec;
        color: #c2185b;
    }

    .status-badge {
        padding: 6px 12px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 500;
        display: inline-block;
    }

    .status-active {
        background: #e8f5e9;
        color: #2e7d32;
    }

    .status-inactive {
        background: #ffebee;
        color: #c62828;
    }

    .last-activity {
        display: flex;
        align-items: center;
        gap: 5px;
        color: #666;
        font-size: 13px;
    }

    .last-activity i {
        color: var(--primary-color);
    }

    .last-activity.never {
        color: #999;
    }

    .action-buttons {
        display: flex;
        gap: 5px;
    }

    .action-buttons .btn {
        padding: 6px 10px;
    }

    .search-section {
        display: flex;
        gap: 15px;
        margin-bottom: 20px;
        flex-wrap: wrap;
    }

    .search-box {
        position: relative;
        flex: 1;
        min-width: 250px;
    }

    .search-box i {
        position: absolute;
        left: 12px;
        top: 50%;
        transform: translateY(-50%);
        color: #666;
    }

    .search-box input {
        padding-left: 35px;
        width: 100%;
    }

    .filter-box {
        min-width: 200px;
    }

    .form-group {
        margin-bottom: 20px;
    }

    .form-group label {
        margin-bottom: 8px;
        font-weight: 500;
        color: var(--dark-color);
    }

    .input-group-text {
        background: var(--light-color);
        border-color: #ddd;
    }

    .form-check-input:checked {
        background-color: var(--primary-color);
        border-color: var(--primary-color);
    }
</style>

<script>
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

    function goToPage(page) {
        window.location.href = `${pageContext.request.contextPath}/admin/users?page=${page}`;
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
</script> 