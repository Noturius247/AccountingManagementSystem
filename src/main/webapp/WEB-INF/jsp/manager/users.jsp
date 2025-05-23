<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - Manager Dashboard</title>
    <link rel="stylesheet" href="../../css/main.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        .user-management {
            padding: 20px;
            max-width: 1400px;
            margin: 0 auto;
        }

        .user-filters {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .user-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .user-table th, .user-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        .user-table th {
            background-color: #f8f9fa;
            font-weight: 600;
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }

        .status-active {
            background-color: #d4edda;
            color: #155724;
        }

        .status-inactive {
            background-color: #f8d7da;
            color: #721c24;
        }

        .role-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            background-color: #e9ecef;
            color: #495057;
        }

        .bulk-actions {
            margin-bottom: 20px;
            display: flex;
            gap: 10px;
        }
    </style>

    <script>
        // Utility Functions
        const utils = {
            showLoading() {
                document.getElementById('loadingOverlay').style.display = 'flex';
            },
            
            hideLoading() {
                document.getElementById('loadingOverlay').style.display = 'none';
            },
            
            showSuccess(message) {
                const successDiv = document.getElementById('successMessage');
                successDiv.textContent = message;
                successDiv.style.display = 'block';
                setTimeout(() => successDiv.style.display = 'none', 3000);
            },
            
            showError(message) {
                const errorDiv = document.getElementById('errorMessage');
                errorDiv.textContent = message;
                errorDiv.style.display = 'block';
                setTimeout(() => errorDiv.style.display = 'none', 3000);
            }
        };

        // User Management Functions
        function addUser() {
            // Open add user modal
            // Implementation needed
        }

        function editUser(userId) {
            // Open edit user modal
            // Implementation needed
        }

        function deleteUser(userId) {
            if (confirm('Are you sure you want to delete this user?')) {
                utils.showLoading();
                fetch(`${pageContext.request.contextPath}/manager/users/${userId}/delete`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        '${_csrf.headerName}': '${_csrf.token}'
                    }
                })
                .then(response => {
                    if (response.ok) {
                        utils.showSuccess('User deleted successfully');
                        setTimeout(() => location.reload(), 1500);
                    } else {
                        throw new Error('Failed to delete user');
                    }
                })
                .catch(error => {
                    utils.showError('Error: ' + error.message);
                })
                .finally(() => utils.hideLoading());
            }
        }

        function viewUser(userId) {
            window.location.href = `${pageContext.request.contextPath}/manager/users/${userId}`;
        }

        function applyFilters() {
            const search = document.getElementById('searchUser').value;
            const role = document.getElementById('roleFilter').value;
            const status = document.getElementById('statusFilter').value;
            
            const rows = document.querySelectorAll('.user-table tbody tr');
            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                const roleCell = row.querySelector('.role-badge').textContent;
                const statusCell = row.querySelector('.status-badge').textContent;
                
                const matchesSearch = text.includes(search.toLowerCase());
                const matchesRole = !role || roleCell === role;
                const matchesStatus = !status || statusCell === status;
                
                row.style.display = matchesSearch && matchesRole && matchesStatus ? '' : 'none';
            });
        }

        function applyBulkAction() {
            const action = document.getElementById('bulkAction').value;
            const selectedUsers = Array.from(document.querySelectorAll('.user-checkbox:checked'))
                .map(checkbox => checkbox.value);
            
            if (selectedUsers.length === 0) {
                utils.showError('Please select at least one user');
                return;
            }

            utils.showLoading();
            fetch(`${pageContext.request.contextPath}/manager/users/bulk-action`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    '${_csrf.headerName}': '${_csrf.token}'
                },
                body: JSON.stringify({
                    action: action,
                    userIds: selectedUsers
                })
            })
            .then(response => {
                if (response.ok) {
                    utils.showSuccess('Bulk action completed successfully');
                    setTimeout(() => location.reload(), 1500);
                } else {
                    throw new Error('Failed to perform bulk action');
                }
            })
            .catch(error => {
                utils.showError('Error: ' + error.message);
            })
            .finally(() => utils.hideLoading());
        }

        function changePage(page) {
            window.location.href = `${pageContext.request.contextPath}/manager/users?page=${page}`;
        }

        // Initialize everything when the DOM is loaded
        document.addEventListener('DOMContentLoaded', () => {
            // Select all checkbox functionality
            document.getElementById('selectAll').addEventListener('change', function() {
                const checkboxes = document.querySelectorAll('.user-checkbox');
                checkboxes.forEach(checkbox => checkbox.checked = this.checked);
            });

            // Add search input listener
            document.getElementById('searchUser').addEventListener('input', applyFilters);
            
            // Add filter change listeners
            document.getElementById('roleFilter').addEventListener('change', applyFilters);
            document.getElementById('statusFilter').addEventListener('change', applyFilters);
        });
    </script>
</head>
<body>
    <%@ include file="../includes/manager-header.jsp" %>
    
    <div class="user-management">
        <div class="content-header">
            <h1>User Management</h1>
            <div class="header-actions">
                <button class="btn btn-primary" onclick="addUser()">
                    <i class="fas fa-user-plus"></i> Add User
                </button>
                <button class="btn btn-success" onclick="exportUsers()">
                    <i class="fas fa-file-export"></i> Export
                </button>
            </div>
        </div>

        <div class="user-filters">
            <input type="text" id="searchUser" placeholder="Search users..." class="form-control">
            <select id="roleFilter" class="form-control">
                <option value="">All Roles</option>
                <option value="USER">User</option>
                <option value="MANAGER">Manager</option>
                <option value="ADMIN">Admin</option>
            </select>
            <select id="statusFilter" class="form-control">
                <option value="">All Status</option>
                <option value="ACTIVE">Active</option>
                <option value="INACTIVE">Inactive</option>
            </select>
            <button class="btn btn-primary" onclick="applyFilters()">
                <i class="fas fa-filter"></i> Apply Filters
            </button>
        </div>

        <div class="bulk-actions">
            <select id="bulkAction" class="form-control">
                <option value="">Bulk Actions</option>
                <option value="activate">Activate Selected</option>
                <option value="deactivate">Deactivate Selected</option>
                <option value="delete">Delete Selected</option>
            </select>
            <button class="btn btn-secondary" onclick="applyBulkAction()">
                <i class="fas fa-check"></i> Apply
            </button>
        </div>

        <table class="user-table">
            <thead>
                <tr>
                    <th><input type="checkbox" id="selectAll"></th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Status</th>
                    <th>Last Login</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${users}" var="user">
                    <tr>
                        <td><input type="checkbox" class="user-checkbox" value="${user.id}"></td>
                        <td>${user.name}</td>
                        <td>${user.email}</td>
                        <td><span class="role-badge">${user.role}</span></td>
                        <td>
                            <span class="status-badge ${user.active ? 'status-active' : 'status-inactive'}">
                                ${user.active ? 'Active' : 'Inactive'}
                            </span>
                        </td>
                        <td><fmt:formatDate value="${user.lastLogin}" pattern="MMM dd, yyyy HH:mm"/></td>
                        <td>
                            <button class="btn btn-sm btn-info" onclick="viewUser(${user.id})">
                                <i class="fas fa-eye"></i>
                            </button>
                            <button class="btn btn-sm btn-warning" onclick="editUser(${user.id})">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="btn btn-sm btn-danger" onclick="deleteUser(${user.id})">
                                <i class="fas fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <!-- Pagination -->
        <div class="pagination">
            <c:if test="${currentPage > 1}">
                <button class="btn btn-secondary" onclick="changePage(${currentPage - 1})">
                    <i class="fas fa-chevron-left"></i> Previous
                </button>
            </c:if>
            <span>Page ${currentPage} of ${totalPages}</span>
            <c:if test="${currentPage < totalPages}">
                <button class="btn btn-secondary" onclick="changePage(${currentPage + 1})">
                    Next <i class="fas fa-chevron-right"></i>
                </button>
            </c:if>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/manager_dashboard.js"></script>
</body>
</html> 