<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="<c:url value='/resources/css/admin.css'/>">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="<c:url value='/static/js/main.js'/>"></script>
</head>
<body>
    <div class="admin-container">
        <!-- Sidebar Navigation -->
        <div class="sidebar">
            <div class="logo">
                <h2>Admin Panel</h2>
            </div>
            <nav>
                <ul>
                    <li><a href="/admin/dashboard" data-dynamic="true">Dashboard</a></li>
                    <li><a href="/admin/users" data-dynamic="true">Users</a></li>
                    <li><a href="/admin/managers" data-dynamic="true">Managers</a></li>
                    <li><a href="/admin/transactions" data-dynamic="true">Transactions</a></li>
                    <li><a href="/admin/students" data-dynamic="true">Students</a></li>
                </ul>
            </nav>
        </div>

        <!-- Main Content Area -->
        <div class="main-content">
            <div id="main-content">
                <!-- Content will be loaded here via dynamic navigation -->
            </div>
        </div>
    </div>
</body>
</html> 