<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!-- Sidebar -->
<div class="sidebar col-md-3 col-lg-2">
    <div class="d-flex flex-column p-3">
        <a href="/" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-white text-decoration-none">
            <span class="fs-4">Admin Panel</span>
        </a>
        <hr>
        <ul class="nav nav-pills flex-column mb-auto">
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link active" data-section="dashboard">
                    <i class="bi bi-speedometer2"></i>
                    Dashboard
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/users" class="nav-link" data-section="users">
                    <i class="bi bi-people"></i>
                    Users
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/transactions" class="nav-link" data-section="transactions">
                    <i class="bi bi-cash-stack"></i>
                    Transactions
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/queue" class="nav-link" data-section="queue">
                    <i class="bi bi-clock-history"></i>
                    Queue
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/reports" class="nav-link" data-section="reports">
                    <i class="bi bi-file-earmark-text"></i>
                    Reports
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/settings" class="nav-link" data-section="settings">
                    <i class="bi bi-gear"></i>
                    Settings
                </a>
            </li>
            <li class="mt-auto">
                <form action="${pageContext.request.contextPath}/logout" method="post" class="nav-item" id="logoutForm">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <button type="submit" class="nav-link text-danger w-100 border-0 bg-transparent" id="logoutButton">
                        <i class="bi bi-box-arrow-right"></i>
                        Logout
                    </button>
                </form>
            </li>
        </ul>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const logoutForm = document.getElementById('logoutForm');
        const logoutButton = document.getElementById('logoutButton');
        
        if (logoutButton) {
            logoutButton.addEventListener('click', function(e) {
                e.preventDefault();
                if (confirm('Are you sure you want to logout?')) {
                    logoutForm.submit();
                }
            });
        }
    });
</script>

<style>
    /* Sidebar styles */
    .sidebar {
        background: var(--primary-color);
        color: white;
        height: 100vh;
        position: fixed;
        top: 0;
        left: 0;
        z-index: 1000;
        transition: all 0.3s ease;
        width: 250px;
        padding-top: 56px; /* Height of the header */
    }

    .main-content {
        margin-left: 250px;
        padding: 20px;
        min-height: calc(100vh - 56px);
        margin-top: 56px; /* Height of the header */
    }

    .sidebar .nav-link {
        color: rgba(255, 255, 255, 0.8);
        padding: 0.75rem 1rem;
        border-radius: 0.5rem;
        margin-bottom: 0.5rem;
        transition: all 0.2s ease;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .sidebar .nav-link:hover {
        color: white;
        background: rgba(255, 255, 255, 0.1);
    }

    .sidebar .nav-link.active {
        color: white;
        background: rgba(255, 255, 255, 0.2);
    }

    .sidebar .nav-link i {
        width: 1.5rem;
        text-align: center;
    }

    /* Ensure the sidebar doesn't overlap with the header */
    @media (max-width: 768px) {
        .sidebar {
            width: 100%;
            transform: translateX(-100%);
        }
        
        .sidebar.active {
            transform: translateX(0);
        }
        
        .main-content {
            margin-left: 0;
        }
    }
</style> 