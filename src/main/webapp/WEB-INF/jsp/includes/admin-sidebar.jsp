<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!-- Sidebar -->
<div class="sidebar col-md-3 col-lg-2 d-md-block bg-light collapse">
    <div class="position-sticky pt-3">
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link ${pageContext.request.requestURI.endsWith('/admin/dashboard') ? 'active' : ''}" 
                   href="${pageContext.request.contextPath}/admin/dashboard" data-dynamic>
                    <i class="bi bi-speedometer2 me-2"></i>
                    Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${pageContext.request.requestURI.endsWith('/admin/users') ? 'active' : ''}" 
                   href="${pageContext.request.contextPath}/admin/users" data-dynamic>
                    <i class="bi bi-people me-2"></i>
                    Users
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${pageContext.request.requestURI.endsWith('/admin/student-management') ? 'active' : ''}" 
                   href="${pageContext.request.contextPath}/admin/student-management" data-dynamic>
                    <i class="bi bi-mortarboard me-2"></i>
                    Students
                    <c:if test="${not empty pendingStudentsCount}">
                        <span class="badge bg-danger rounded-pill ms-2">${pendingStudentsCount}</span>
                    </c:if>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${pageContext.request.requestURI.endsWith('/admin/transactions') ? 'active' : ''}" 
                   href="${pageContext.request.contextPath}/admin/transactions" data-dynamic>
                    <i class="bi bi-cash-stack me-2"></i>
                    Transactions
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${pageContext.request.requestURI.endsWith('/admin/queue') ? 'active' : ''}" 
                   href="${pageContext.request.contextPath}/admin/queue" data-dynamic>
                    <i class="bi bi-list-ul me-2"></i>
                    Queue
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${pageContext.request.requestURI.endsWith('/admin/reports') ? 'active' : ''}" 
                   href="${pageContext.request.contextPath}/admin/reports" data-dynamic>
                    <i class="bi bi-file-earmark-text me-2"></i>
                    Reports
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${pageContext.request.requestURI.endsWith('/admin/settings') ? 'active' : ''}" 
                   href="${pageContext.request.contextPath}/admin/settings" data-dynamic>
                    <i class="bi bi-gear me-2"></i>
                    Settings
                </a>
            </li>
        </ul>
    </div>
</div>

<style>
    .sidebar {
        position: fixed;
        top: 0;
        bottom: 0;
        left: 0;
        z-index: 100;
        padding: 48px 0 0;
        box-shadow: var(--shadow-sm);
    }

    .sidebar .nav-link {
        font-weight: 500;
        color: var(--text-color);
        padding: 0.75rem 1rem;
        border-radius: 0.25rem;
        margin: 0.25rem 0;
    }

    .sidebar .nav-link:hover {
        color: var(--primary-color);
        background-color: rgba(0, 0, 0, 0.05);
    }

    .sidebar .nav-link.active {
        color: var(--primary-color);
        background-color: rgba(0, 0, 0, 0.05);
    }

    .sidebar .nav-link i {
        margin-right: 0.5rem;
    }

    @media (max-width: 767.98px) {
        .sidebar {
            position: static;
            height: auto;
            padding: 0;
        }
    }
</style> 