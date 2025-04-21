<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="dashboard-content">
    <h1>Dashboard Overview</h1>
    
    <div class="stats-grid">
        <div class="stat-card">
            <h3>Total Users</h3>
            <p>${stats.totalUsers}</p>
        </div>
        <div class="stat-card">
            <h3>Total Transactions</h3>
            <p>${stats.totalTransactions}</p>
        </div>
        <div class="stat-card">
            <h3>Total Revenue</h3>
            <p>${stats.totalRevenue}</p>
        </div>
        <div class="stat-card">
            <h3>Pending Transactions</h3>
            <p>${stats.pendingTransactions}</p>
        </div>
    </div>

    <div class="recent-activities">
        <h2>Recent Activities</h2>
        <table class="activity-table">
            <thead>
                <tr>
                    <th>Time</th>
                    <th>Activity</th>
                    <th>User</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${recentActivities}" var="activity">
                    <tr>
                        <td>${activity.time}</td>
                        <td>${activity.description}</td>
                        <td>${activity.user}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div> 