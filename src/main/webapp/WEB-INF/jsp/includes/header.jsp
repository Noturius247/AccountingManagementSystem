<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<header class="header">
    <!-- Top Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="bi bi-bank me-2"></i>
                Accounting System
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                    aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <sec:authorize access="isAuthenticated()">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                                <i class="bi bi-speedometer2 me-1"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/transactions">
                                <i class="bi bi-credit-card me-1"></i> Transactions
                            </a>
                        </li>
                        <sec:authorize access="hasRole('MANAGER')">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/manager/payments">
                                    <i class="bi bi-cash-stack me-1"></i> Payments
                                </a>
                            </li>
                        </sec:authorize>
                        <sec:authorize access="hasRole('USER')">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/user/payments">
                                    <i class="bi bi-cash-stack me-1"></i> Payments
                                </a>
                            </li>
                        </sec:authorize>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/user/documents">
                                <i class="bi bi-file-earmark-text me-1"></i> Documents
                            </a>
                        </li>
                        <sec:authorize access="hasRole('ADMIN')">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin">
                                    <i class="bi bi-gear me-1"></i> Admin
                                </a>
                            </li>
                        </sec:authorize>
                    </sec:authorize>
                </ul>
                
                <ul class="navbar-nav">
                    <sec:authorize access="isAuthenticated()">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="notificationsDropdown" role="button"
                               data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="bi bi-bell me-1"></i>
                                <span class="notification-badge">3</span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="notificationsDropdown">
                                <li><h6 class="dropdown-header">Notifications</h6></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="#">New payment received</a></li>
                                <li><a class="dropdown-item" href="#">Document approved</a></li>
                                <li><a class="dropdown-item" href="#">System update</a></li>
                            </ul>
                        </li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button"
                               data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="bi bi-person-circle me-1"></i>
                                <sec:authentication property="principal.username" />
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                                    <i class="bi bi-person me-2"></i> Profile
                                </a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/settings">
                                    <i class="bi bi-gear me-2"></i> Settings
                                </a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <form action="${pageContext.request.contextPath}/logout" method="post" class="dropdown-item">
                                        <button type="submit" class="btn btn-link text-danger p-0">
                                            <i class="bi bi-box-arrow-right me-2"></i> Logout
                                        </button>
                                    </form>
                                </li>
                            </ul>
                        </li>
                    </sec:authorize>
                    <sec:authorize access="!isAuthenticated()">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/login">
                                <i class="bi bi-box-arrow-in-right me-1"></i> Login
                            </a>
                        </li>
                    </sec:authorize>
                </ul>
            </div>
        </div>
    </nav>
</header>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle}</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/static/css/main.css" rel="stylesheet">
</head>
<body>
    <!-- Main Content Container -->
    <div class="container-fluid mt-4"> 

<style>
    .navbar {
        background-color: var(--primary-color);
        box-shadow: var(--shadow-sm);
    }

    .navbar-brand {
        color: var(--secondary-color) !important;
        font-weight: 600;
    }

    .nav-link {
        color: rgba(255, 255, 255, 0.85) !important;
        transition: color 0.2s ease;
    }

    .nav-link:hover, .nav-link:focus {
        color: var(--secondary-color) !important;
    }

    .nav-link.active {
        color: var(--secondary-color) !important;
        font-weight: 500;
    }

    .notification-badge {
        position: absolute;
        top: 0;
        right: 0;
        background: var(--danger-color);
        color: white;
        border-radius: 50%;
        padding: 0.25rem 0.5rem;
        font-size: 0.75rem;
        font-weight: 600;
    }

    .dropdown-menu {
        border: 1px solid var(--border-color);
        box-shadow: var(--shadow-md);
    }

    .dropdown-item {
        color: var(--text-color);
        transition: all 0.2s ease;
    }

    .dropdown-item:hover {
        background-color: var(--hover-bg);
        color: var(--primary-color);
    }

    .dropdown-item i {
        color: var(--primary-color);
    }

    .btn-link {
        text-decoration: none;
        width: 100%;
        text-align: left;
    }

    .btn-link:hover {
        background: none;
        color: var(--danger-color) !important;
    }
</style> 