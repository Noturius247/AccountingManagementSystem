<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<header class="navbar navbar-expand-lg" style="background: var(--primary-color);">
    <div class="container-fluid">
        <!-- Brand/Logo -->
        <a class="navbar-brand text-light" href="<c:url value='/manager/dashboard' />">
            <i class="bi bi-graph-up me-2"></i>Manager Dashboard
        </a>

        <!-- Toggle button for mobile -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#managerNavbar">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Navigation Links -->
        <div class="collapse navbar-collapse" id="managerNavbar">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link text-light" href="<c:url value='/manager/dashboard' />">
                        <i class="bi bi-house-door me-1"></i> Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-light" href="<c:url value='/manager/queue' />">
                        <i class="bi bi-list me-1"></i> Queue
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-light" href="<c:url value='/manager/transactions' />">
                        <i class="bi bi-arrow-left-right me-1"></i> Transactions
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-light" href="<c:url value='/manager/reports' />">
                        <i class="bi bi-bar-chart me-1"></i> Reports
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-light" href="<c:url value='/manager/settings' />">
                        <i class="bi bi-gear me-1"></i> Settings
                    </a>
                </li>
            </ul>

            <!-- User Menu -->
            <ul class="navbar-nav">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle text-light" href="#" id="userDropdown" role="button" 
                       data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-person-circle me-1"></i>
                        <sec:authentication property="principal.username" />
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                        <li>
                            <a class="dropdown-item" href="<c:url value='/manager/profile' />">
                                <i class="bi bi-person me-1"></i> Profile
                            </a>
                        </li>
                        <li>
                            <a class="dropdown-item" href="<c:url value='/manager/settings' />">
                                <i class="bi bi-gear me-1"></i> Settings
                            </a>
                        </li>
                        <li><hr class="dropdown-divider"></li>
                        <li>
                            <form action="<c:url value='/logout' />" method="post" class="d-inline">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <button type="submit" class="dropdown-item">
                                    <i class="bi bi-box-arrow-right me-1"></i> Logout
                                </button>
                            </form>
                        </li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</header>

<!-- Loading Overlay -->
<div id="loadingOverlay" class="loading-overlay" style="display: none;">
    <div class="spinner-border" style="color: var(--primary-color);" role="status">
        <span class="visually-hidden">Loading...</span>
    </div>
</div>

<!-- Error Message -->
<div id="errorMessage" class="alert alert-danger" style="display: none;"></div>

<!-- Success Message -->
<div id="successMessage" class="alert alert-success" style="display: none;"></div> 