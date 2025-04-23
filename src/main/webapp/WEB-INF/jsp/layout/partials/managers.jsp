<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="managers-content" id="dashboard-content">
    <h1>Manager Management</h1>
    
    <div class="manager-actions">
        <button class="btn-add-manager" data-bs-toggle="modal" data-bs-target="#addManagerModal">Add New Manager</button>
        <div class="search-box">
            <input type="text" id="managerSearch" placeholder="Search managers..." class="form-control">
            <select id="managerStatus" class="form-select">
                <option value="">All Status</option>
                <option value="ACTIVE">Active</option>
                <option value="INACTIVE">Inactive</option>
            </select>
        </div>
    </div>

    <div class="manager-stats">
        <canvas class="manager-chart" data-chart-type="bar" data-chart-data='${chartData.managersByDepartment}'></canvas>
    </div>

    <table class="manager-table">
        <thead>
            <tr>
                <th>Name</th>
                <th>Email</th>
                <th>Department</th>
                <th>Status</th>
                <th>Assigned Students</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${managers}" var="manager">
                <tr>
                    <td>${manager.name}</td>
                    <td>${manager.email}</td>
                    <td>${manager.department}</td>
                    <td>
                        <span class="status-badge ${manager.status.toLowerCase()}">${manager.status}</span>
                    </td>
                    <td>${manager.assignedStudentsCount}</td>
                    <td>
                        <button class="btn-edit" data-manager-id="${manager.id}" data-bs-toggle="tooltip" title="Edit Manager">
                            <i class="fas fa-edit"></i>
                        </button>
                        <button class="btn-assign" data-manager-id="${manager.id}" data-bs-toggle="tooltip" title="Assign Students">
                            <i class="fas fa-user-plus"></i>
                        </button>
                        <button class="btn-delete" data-manager-id="${manager.id}" data-bs-toggle="tooltip" title="Delete Manager">
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
            <button class="page-btn" data-page="${currentPage - 1}">Previous</button>
        </c:if>
        <span>Page ${currentPage} of ${totalPages}</span>
        <c:if test="${currentPage < totalPages}">
            <button class="page-btn" data-page="${currentPage + 1}">Next</button>
        </c:if>
    </div>
</div>

<!-- Add Manager Modal -->
<div class="modal fade" id="addManagerModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Add New Manager</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="addManagerForm">
                    <!-- Form fields will be added here -->
                </form>
            </div>
        </div>
    </div>
</div>

<script src="<c:url value='/static/js/manager-managers.js'/>"></script> 