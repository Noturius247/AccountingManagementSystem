<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="dashboard-content">
    <div class="stats-grid">
        <div class="stat-card">
            <h3>Total Users</h3>
            <p>${stats.totalUsers}</p>
        </div>
        <div class="stat-card">
            <h3>Active Students</h3>
            <p>${stats.activeStudents}</p>
        </div>
        <div class="stat-card">
            <h3>Pending Approvals</h3>
            <p>${stats.pendingApprovals}</p>
        </div>
        <div class="stat-card">
            <h3>Total Revenue</h3>
            <p><fmt:formatNumber value="${stats.totalRevenue}" type="currency"/></p>
        </div>
    </div>

    <div class="recent-activities">
        <h2>Recent Activities</h2>
        <table>
            <thead>
                <tr>
                    <th>Type</th>
                    <th>Description</th>
                    <th>Amount</th>
                    <th>Date</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${recentActivities}" var="activity">
                    <tr>
                        <td>${activity.type}</td>
                        <td>${activity.description}</td>
                        <td><fmt:formatNumber value="${activity.amount}" type="currency"/></td>
                        <td>${activity.createdAt}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div> 