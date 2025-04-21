<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="managers-content">
    <h1>Manager Management</h1>
    
    <div class="manager-actions">
        <button class="btn-add-manager">Add New Manager</button>
        <div class="search-box">
            <input type="text" id="managerSearch" placeholder="Search managers...">
            <select id="managerStatus">
                <option value="">All Status</option>
                <option value="ACTIVE">Active</option>
                <option value="INACTIVE">Inactive</option>
            </select>
        </div>
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
                        <button class="btn-edit" data-manager-id="${manager.id}">Edit</button>
                        <button class="btn-assign" data-manager-id="${manager.id}">Assign Students</button>
                        <button class="btn-delete" data-manager-id="${manager.id}">Delete</button>
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

<script>
    $(document).ready(function() {
        // Handle manager search
        $('#managerSearch, #managerStatus').on('change', function() {
            const searchTerm = $('#managerSearch').val();
            const status = $('#managerStatus').val();
            $.ajax({
                url: '/admin/managers/search',
                data: { 
                    term: searchTerm,
                    status: status
                },
                success: function(response) {
                    $('.manager-table tbody').html(response);
                }
            });
        });

        // Handle edit button click
        $('.btn-edit').click(function() {
            const managerId = $(this).data('manager-id');
            // Implement edit functionality
        });

        // Handle assign students button click
        $('.btn-assign').click(function() {
            const managerId = $(this).data('manager-id');
            // Implement assign students functionality
        });

        // Handle delete button click
        $('.btn-delete').click(function() {
            const managerId = $(this).data('manager-id');
            if (confirm('Are you sure you want to delete this manager?')) {
                // Implement delete functionality
            }
        });

        // Handle pagination
        $('.page-btn').click(function() {
            const page = $(this).data('page');
            loadContent('managers', page);
        });
    });
</script> 