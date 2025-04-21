<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="users-content">
    <h1>User Management</h1>
    
    <div class="user-actions">
        <button class="btn-add-user">Add New User</button>
        <div class="search-box">
            <input type="text" id="userSearch" placeholder="Search users...">
        </div>
    </div>

    <table class="user-table">
        <thead>
            <tr>
                <th>Username</th>
                <th>Email</th>
                <th>Role</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${users}" var="user">
                <tr>
                    <td>${user.username}</td>
                    <td>${user.email}</td>
                    <td>${user.role}</td>
                    <td>${user.status}</td>
                    <td>
                        <button class="btn-edit" data-user-id="${user.id}">Edit</button>
                        <button class="btn-delete" data-user-id="${user.id}">Delete</button>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<script>
    $(document).ready(function() {
        // Handle user search
        $('#userSearch').on('input', function() {
            const searchTerm = $(this).val();
            $.ajax({
                url: '/admin/users/search',
                data: { term: searchTerm },
                success: function(response) {
                    $('.user-table tbody').html(response);
                }
            });
        });

        // Handle edit button click
        $('.btn-edit').click(function() {
            const userId = $(this).data('user-id');
            // Implement edit functionality
        });

        // Handle delete button click
        $('.btn-delete').click(function() {
            const userId = $(this).data('user-id');
            // Implement delete functionality
        });
    });
</script> 