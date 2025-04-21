<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - Admin Panel</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
    <!-- Include Sidebar -->
    <%@ include file="partials/sidebar.jsp" %>

    <!-- Main Content -->
    <div class="main-content">
        <div class="container-fluid px-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="h3 mb-0">User Management</h1>
                <div class="d-flex gap-2">
                    <button class="btn btn-primary" onclick="showAddUserModal()">
                        <i class="bi bi-plus-lg"></i> Add User
                    </button>
                    <div class="dropdown">
                        <button class="btn btn-secondary dropdown-toggle" type="button" id="bulkActionsDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="bi bi-list"></i> Bulk Actions
                        </button>
                        <ul class="dropdown-menu" aria-labelledby="bulkActionsDropdown">
                            <li><a class="dropdown-item" href="#" onclick="bulkEnableUsers()"><i class="bi bi-check-circle"></i> Enable Selected</a></li>
                            <li><a class="dropdown-item" href="#" onclick="bulkDisableUsers()"><i class="bi bi-x-circle"></i> Disable Selected</a></li>
                            <li><a class="dropdown-item" href="#" onclick="bulkDeleteUsers()"><i class="bi bi-trash"></i> Delete Selected</a></li>
                            <li><a class="dropdown-item" href="#" onclick="bulkExportUsers()"><i class="bi bi-download"></i> Export Selected</a></li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- Filters -->
            <div class="card mb-4">
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-3">
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-search"></i></span>
                                <input type="text" class="form-control" id="userSearch" placeholder="Search users...">
                            </div>
                        </div>
                        <div class="col-md-2">
                            <select class="form-select" id="roleFilter">
                                <option value="">All Roles</option>
                                <option value="ROLE_USER">User</option>
                                <option value="ROLE_MANAGER">Manager</option>
                                <option value="ROLE_ADMIN">Admin</option>
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
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-calendar"></i></span>
                                <input type="date" class="form-control" id="dateFilter">
                            </div>
                        </div>
                        <div class="col-md-2">
                            <button class="btn btn-outline-secondary w-100" onclick="resetFilters()">
                                <i class="bi bi-x-circle"></i> Reset
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Users Table -->
            <div class="card">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th width="40">
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
                                    <th width="120">Actions</th>
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
                                            <span class="badge bg-${user.role == 'ADMIN' ? 'danger' : user.role == 'MANAGER' ? 'warning' : 'info'}">
                                                ${user.role}
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge ${user.enabled ? 'bg-success' : 'bg-danger'}">
                                                ${user.enabled ? 'Active' : 'Inactive'}
                                            </span>
                                        </td>
                                        <td>
                                            <c:if test="${not empty user.lastActivity}">
                                                ${user.lastActivity.toString().substring(0, 19).replace('T', ' ')}
                                            </c:if>
                                            <c:if test="${empty user.lastActivity}">
                                                <span class="text-muted">Never</span>
                                            </c:if>
                                        </td>
                                        <td>
                                            <c:if test="${not empty user.createdAt}">
                                                ${user.createdAt.toString().substring(0, 10)}
                                            </c:if>
                                        </td>
                                        <td>
                                            <div class="btn-group btn-group-sm">
                                                <button class="btn btn-outline-primary" onclick="viewUserHistory('${user.id}')" title="View History">
                                                    <i class="bi bi-clock-history"></i>
                                                </button>
                                                <button class="btn btn-outline-info" onclick="editUser('${user.id}')" title="Edit">
                                                    <i class="bi bi-pencil"></i>
                                                </button>
                                                <button class="btn btn-outline-danger" onclick="deleteUser('${user.id}')" title="Delete">
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
                    <form id="addUserForm" class="needs-validation" novalidate>
                        <div class="mb-3">
                            <label class="form-label">Username</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-person"></i></span>
                                <input type="text" class="form-control" name="username" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                <input type="email" class="form-control" name="email" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Password</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-lock"></i></span>
                                <input type="password" class="form-control" name="password" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Role</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-shield"></i></span>
                                <select class="form-select" name="role" required>
                                    <option value="ROLE_USER">User</option>
                                    <option value="ROLE_MANAGER">Manager</option>
                                    <option value="ROLE_ADMIN">Admin</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" name="enabled" checked>
                            <label class="form-check-label">Active Account</label>
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

    <!-- User History Modal -->
    <div class="modal fade" id="userHistoryModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">User Activity History</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="timeline" id="userHistoryContent">
                        <!-- History items will be loaded here -->
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
    function formatTimestamp(timestamp) {
        return new Date(timestamp).toLocaleString();
    }

    $(document).ready(function() {
        // Initialize tooltips
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl)
        });

        // Initialize select all checkbox
        $('#selectAllUsers').change(function() {
            $('.user-checkbox').prop('checked', $(this).prop('checked'));
        });

        // Initialize filters
        $('#userSearch, #roleFilter, #statusFilter, #dateFilter').on('input change', filterUsers);

        // Handle sidebar visibility
        const menuToggle = document.getElementById('menuToggle');
        const adminSidebar = document.getElementById('adminSidebar');
        
        if (menuToggle && adminSidebar) {
            menuToggle.addEventListener('click', function() {
                adminSidebar.classList.toggle('show');
            });

            // Show sidebar by default on desktop
            if (window.innerWidth > 768) {
                adminSidebar.classList.add('show');
            }

            // Handle window resize
            window.addEventListener('resize', function() {
                if (window.innerWidth > 768) {
                    adminSidebar.classList.add('show');
                }
            });
        }
    });

    function filterUsers() {
        const searchText = $('#userSearch').val().toLowerCase();
        const roleFilter = $('#roleFilter').val();
        const statusFilter = $('#statusFilter').val();
        const dateFilter = $('#dateFilter').val();

        $('tbody tr').each(function() {
            const $row = $(this);
            const username = $row.find('td:eq(1)').text().toLowerCase();
            const email = $row.find('td:eq(2)').text().toLowerCase();
            const role = $row.find('td:eq(3)').text().trim();
            const status = $row.find('td:eq(4)').text().trim();
            const created = $row.find('td:eq(6)').text().trim();

            const matchesSearch = username.includes(searchText) || email.includes(searchText);
            const matchesRole = !roleFilter || role === roleFilter;
            const matchesStatus = !statusFilter || 
                (statusFilter === 'true' && status === 'Active') || 
                (statusFilter === 'false' && status === 'Inactive');
            const matchesDate = !dateFilter || created.includes(dateFilter);

            $row.toggle(matchesSearch && matchesRole && matchesStatus && matchesDate);
        });
    }

    function resetFilters() {
        $('#userSearch').val('');
        $('#roleFilter').val('');
        $('#statusFilter').val('');
        $('#dateFilter').val('');
        filterUsers();
    }

    function showAddUserModal() {
        $('#addUserForm')[0].reset();
        new bootstrap.Modal($('#addUserModal')).show();
    }

    function submitAddUser() {
        const form = $('#addUserForm');
        if (!form[0].checkValidity()) {
            form[0].reportValidity();
            return;
        }

        const formData = new FormData(form[0]);
        const data = Object.fromEntries(formData.entries());
        
        $.ajax({
            url: '${pageContext.request.contextPath}/admin/users/add',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(data),
            success: function(response) {
                location.reload();
            },
            error: function(xhr) {
                alert('Error adding user: ' + xhr.responseText);
            }
        });
    }

    function viewUserHistory(userId) {
        const modal = new bootstrap.Modal($('#userHistoryModal'));
        const content = $('#userHistoryContent');
        
        content.html('<div class="text-center"><div class="spinner-border" role="status"></div></div>');
        modal.show();

        $.get('${pageContext.request.contextPath}/admin/users/' + userId + '/history')
            .done(function(data) {
                content.html(data.map(event => {
                    const date = new Date(event.timestamp);
                    const formattedDate = date.toLocaleString();
                    return `
                    <div class="timeline-item">
                        <div class="timeline-marker"></div>
                        <div class="timeline-content">
                            <div class="timeline-date">${formattedDate}</div>
                            <div class="timeline-action">\${event.action}</div>
                            <div class="timeline-details">\${event.details}</div>
                        </div>
                    </div>
                `}).join(''));
            })
            .fail(function(xhr) {
                content.html(`
                    <div class="alert alert-danger">
                        Failed to load user history: \${xhr.responseText}
                    </div>
                `);
            });
    }

    function editUser(userId) {
        window.location.href = '${pageContext.request.contextPath}/admin/users/' + userId + '/edit';
    }

    function deleteUser(userId) {
        if (!confirm('Are you sure you want to delete this user? This action cannot be undone.')) {
            return;
        }

        $.ajax({
            url: '${pageContext.request.contextPath}/admin/users/' + userId,
            type: 'DELETE',
            success: function() {
                location.reload();
            },
            error: function(xhr) {
                alert('Error deleting user: ' + xhr.responseText);
            }
        });
    }

    function bulkEnableUsers() {
        const selectedUsers = getSelectedUsers();
        if (selectedUsers.length === 0) {
            alert('Please select at least one user');
            return;
        }

        if (confirm(`Enable ${selectedUsers.length} selected user(s)?`)) {
            $.ajax({
                url: '${pageContext.request.contextPath}/admin/users/bulk-enable',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(selectedUsers),
                success: function() {
                    location.reload();
                },
                error: function(xhr) {
                    alert('Error enabling users: ' + xhr.responseText);
                }
            });
        }
    }

    function bulkDisableUsers() {
        const selectedUsers = getSelectedUsers();
        if (selectedUsers.length === 0) {
            alert('Please select at least one user');
            return;
        }

        if (confirm(`Disable ${selectedUsers.length} selected user(s)?`)) {
            $.ajax({
                url: '${pageContext.request.contextPath}/admin/users/bulk-disable',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(selectedUsers),
                success: function() {
                    location.reload();
                },
                error: function(xhr) {
                    alert('Error disabling users: ' + xhr.responseText);
                }
            });
        }
    }

    function bulkDeleteUsers() {
        const selectedUsers = getSelectedUsers();
        if (selectedUsers.length === 0) {
            alert('Please select at least one user');
            return;
        }

        if (confirm(`Delete ${selectedUsers.length} selected user(s)? This action cannot be undone.`)) {
            $.ajax({
                url: '${pageContext.request.contextPath}/admin/users/bulk-delete',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(selectedUsers),
                success: function() {
                    location.reload();
                },
                error: function(xhr) {
                    alert('Error deleting users: ' + xhr.responseText);
                }
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

    function getSelectedUsers() {
        return $('.user-checkbox:checked').map(function() {
            return $(this).val();
        }).get();
    }
    </script>

    <style>
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
        background-color: var(--border-color);
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
        background: var(--light-color);
        padding: 1rem;
        border-radius: 0.5rem;
        box-shadow: var(--shadow-sm);
    }

    .timeline-date {
        font-size: 0.875rem;
        color: var(--text-muted);
        margin-bottom: 0.5rem;
    }

    .timeline-action {
        font-weight: 500;
        margin-bottom: 0.5rem;
    }

    .timeline-details {
        font-size: 0.875rem;
        color: var(--text-color);
    }

    .table td {
        vertical-align: middle;
    }

    .btn-group-sm > .btn {
        padding: 0.25rem 0.5rem;
    }

    .badge {
        font-weight: 500;
    }
    </style>
</body>
</html>