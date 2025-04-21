<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    :root {
        --primary-color: #800000; /* Maroon color */
        --primary-dark: #600000;
        --danger-color: #dc3545;
        --shadow-md: 0 4px 6px rgba(0, 0, 0, 0.1);
        --border-radius-sm: 4px;
    }

    .admin-sidebar {
        width: 250px;
        height: 100vh;
        position: fixed;
        left: 0;
        top: 0;
        background: #800000;
        color: white;
        transition: all 0.3s ease;
        z-index: 1030;
        box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
        overflow-y: auto;
    }

    .admin-sidebar.collapsed {
        transform: translateX(-100%);
    }

    .sidebar-header {
        padding: 1.5rem;
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        position: sticky;
        top: 0;
        background: inherit;
        z-index: 2;
    }

    .sidebar-header h3 {
        margin: 0;
        font-size: 1.25rem;
        font-weight: 600;
        color: white;
    }

    .nav-menu {
        list-style: none;
        padding: 0;
        margin: 0;
        position: relative;
        z-index: 1;
    }

    .nav-link {
        display: flex;
        align-items: center;
        padding: 0.75rem 1.5rem;
        color: rgba(255, 255, 255, 0.8);
        text-decoration: none;
        transition: all 0.3s ease;
        position: relative;
    }

    .nav-link:hover {
        background: rgba(255, 255, 255, 0.1);
        color: white;
    }

    .nav-link.active {
        background: rgba(255, 255, 255, 0.2);
        color: white;
    }

    .nav-link i {
        margin-right: 1rem;
        width: 20px;
        text-align: center;
    }

    .nav-link .badge {
        position: absolute;
        right: 1rem;
        background: #dc3545; /* Fallback for --danger-color */
        color: white;
        padding: 0.25rem 0.5rem;
        border-radius: 9999px;
        font-size: 0.75rem;
        font-weight: 500;
    }

    .menu-toggle {
        display: none;
        position: fixed;
        top: 1rem;
        left: 1rem;
        z-index: 1031;
        background: #800000;
        color: white;
        border: none;
        padding: 0.75rem;
        border-radius: 4px;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
    }

    .menu-toggle:hover {
        background: #600000;
    }

    /* Mobile styles */
    @media (max-width: 768px) {
        .menu-toggle {
            display: block;
            position: fixed;
            top: 0.5rem;
            left: 0.5rem;
        }

        .admin-sidebar {
            transform: translateX(-100%);
            top: 0;
            padding-top: 4rem;
        }

        .admin-sidebar.show {
            transform: translateX(0);
        }

        .sidebar-header {
            position: fixed;
            top: 0;
            left: 0;
            width: 250px;
            background: #800000;
            z-index: 1032;
        }

        .nav-menu {
            padding-top: 1rem;
        }

        /* Adjust main content for mobile */
        .main-content {
            margin-left: 0;
            padding-top: 4rem;
            width: 100%;
            min-height: 100vh;
        }

        /* Add overlay when sidebar is shown */
        .sidebar-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.5);
            z-index: 1029;
        }

        .admin-sidebar.show + .sidebar-overlay {
            display: block;
        }

        body {
            padding-top: 0;
        }
    }

    /* Ensure main content doesn't overlap sidebar */
    .main-content {
        margin-left: 250px;
        padding: 2rem;
        transition: margin-left 0.3s ease;
    }

    @media (max-width: 768px) {
        .main-content {
            margin-left: 0;
            padding: 1rem;
        }
    }
</style>

<button class="menu-toggle" id="menuToggle">
    <i class="fas fa-bars"></i>
</button>

<nav class="admin-sidebar" id="adminSidebar">
    <div class="sidebar-header">
        <h3>Admin Panel</h3>
    </div>
    <ul class="nav-menu">
        <li>
            <a href="<c:url value='/admin/dashboard'/>" 
               class="nav-link ${pageContext.request.requestURI.endsWith('/admin/dashboard') ? 'active' : ''}">
                <i class="fas fa-tachometer-alt"></i>
                <span>Dashboard</span>
            </a>
        </li>
        <li>
            <a href="<c:url value='/admin/users'/>" 
               class="nav-link ${pageContext.request.requestURI.endsWith('/admin/users') ? 'active' : ''}">
                <i class="fas fa-users"></i>
                <span>Users</span>
            </a>
        </li>
        <li>
            <a href="<c:url value='/admin/managers'/>" 
               class="nav-link ${pageContext.request.requestURI.endsWith('/admin/managers') ? 'active' : ''}">
                <i class="fas fa-user-tie"></i>
                <span>Managers</span>
            </a>
        </li>
        <li>
            <a href="<c:url value='/admin/students'/>" 
               class="nav-link ${pageContext.request.requestURI.endsWith('/admin/students') ? 'active' : ''}">
                <i class="fas fa-user-graduate"></i>
                <span>Students</span>
                <c:if test="${not empty pendingStudentsCount}">
                    <span class="badge">${pendingStudentsCount}</span>
                </c:if>
            </a>
        </li>
        <li>
            <a href="<c:url value='/admin/transactions'/>" 
               class="nav-link ${pageContext.request.requestURI.endsWith('/admin/transactions') ? 'active' : ''}">
                <i class="fas fa-exchange-alt"></i>
                <span>Transactions</span>
            </a>
        </li>
        <li>
            <a href="<c:url value='/admin/queue'/>" 
               class="nav-link ${pageContext.request.requestURI.endsWith('/admin/queue') ? 'active' : ''}">
                <i class="fas fa-list-ul"></i>
                <span>Queue</span>
            </a>
        </li>
        <li>
            <a href="<c:url value='/admin/reports'/>" 
               class="nav-link ${pageContext.request.requestURI.endsWith('/admin/reports') ? 'active' : ''}">
                <i class="fas fa-file-alt"></i>
                <span>Reports</span>
            </a>
        </li>
        <li>
            <a href="<c:url value='/admin/settings'/>" 
               class="nav-link ${pageContext.request.requestURI.endsWith('/admin/settings') ? 'active' : ''}">
                <i class="fas fa-cog"></i>
                <span>Settings</span>
            </a>
        </li>
    </ul>
</nav>

<div class="sidebar-overlay" id="sidebarOverlay"></div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const menuToggle = document.getElementById('menuToggle');
    const sidebar = document.getElementById('adminSidebar');
    const overlay = document.getElementById('sidebarOverlay');
    
    // Load sidebar state from localStorage
    const sidebarState = localStorage.getItem('sidebarState');
    if (sidebarState === 'collapsed') {
        sidebar.classList.add('collapsed');
    }
    
    function toggleSidebar() {
        sidebar.classList.toggle('show');
        document.body.style.overflow = sidebar.classList.contains('show') ? 'hidden' : '';
    }
    
    if (menuToggle && sidebar) {
        menuToggle.addEventListener('click', function(e) {
            e.stopPropagation();
            toggleSidebar();
        });
    }

    // Close sidebar when clicking overlay
    if (overlay) {
        overlay.addEventListener('click', function() {
            toggleSidebar();
        });
    }

    // Close sidebar when clicking outside on mobile
    document.addEventListener('click', function(e) {
        if (window.innerWidth <= 768) {
            if (!sidebar.contains(e.target) && !menuToggle.contains(e.target) && sidebar.classList.contains('show')) {
                toggleSidebar();
            }
        }
    });

    // Update active link based on current URL
    const currentPath = window.location.pathname;
    const navLinks = document.querySelectorAll('.nav-link');
    navLinks.forEach(link => {
        if (currentPath.includes(link.getAttribute('href'))) {
            link.classList.add('active');
        } else {
            link.classList.remove('active');
        }
    });
});
</script> 