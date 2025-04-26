<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Bootstrap Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
<!-- Custom CSS -->
<link href="${pageContext.request.contextPath}/static/css/main.css" rel="stylesheet">

<header class="header">
    <!-- Top Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="bi bi-calculator me-2"></i>Accounting System
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                    aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <sec:authorize access="isAuthenticated()">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/">
                                <i class="bi bi-speedometer2 me-1"></i> Dashboard
                            </a>
                        </li>
                        <sec:authorize access="hasRole('USER')">
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
                                <li><a class="dropdown-item" href="#" data-dynamic>Payment reminder</a></li>
                                <li><a class="dropdown-item" href="#" data-dynamic>Document status update</a></li>
                                <li><a class="dropdown-item" href="#" data-dynamic>System update</a></li>
                            </ul>
                        </li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button"
                               data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="bi bi-person-circle me-1"></i>
                                <sec:authentication property="name" />
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/user/profile" data-dynamic>
                                        <i class="bi bi-person me-2"></i>Profile
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/user/settings" data-dynamic>
                                        <i class="bi bi-gear me-2"></i>Settings
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <form id="logoutForm" action="${pageContext.request.contextPath}/logout" method="post" class="d-inline w-100">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <button type="submit" class="dropdown-item text-danger w-100" onclick="handleLogout(event)">
                                            <i class="bi bi-box-arrow-right me-2"></i>Logout
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

<style>
    /* Only keep essential styles that are specific to this header */
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

    /* Loading state styles */
    #main-content.loading {
        opacity: 0.6;
        pointer-events: none;
    }

    #main-content.loading::after {
        content: '';
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        width: 40px;
        height: 40px;
        border: 4px solid #f3f3f3;
        border-top: 4px solid var(--primary-color);
        border-radius: 50%;
        animation: spin 1s linear infinite;
    }

    @keyframes spin {
        0% { transform: translate(-50%, -50%) rotate(0deg); }
        100% { transform: translate(-50%, -50%) rotate(360deg); }
    }
</style>

<!-- Bootstrap Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
    // Simple dropdown initialization
    document.addEventListener('DOMContentLoaded', function() {
        // Handle dashboard link specifically
        const dashboardLink = document.getElementById('dashboardLink');
        if (dashboardLink) {
            dashboardLink.addEventListener('click', function(e) {
                // If we're already on the dashboard, just prevent the default action
                if (window.location.pathname.includes('/accounting/user/dashboard')) {
                    e.preventDefault();
                    return;
                }
            });
        }

        // Initialize all dropdowns
        var dropdowns = document.querySelectorAll('.dropdown-toggle');
        dropdowns.forEach(function(dropdown) {
            dropdown.addEventListener('click', function(e) {
                e.preventDefault();
                var menu = this.nextElementSibling;
                menu.classList.toggle('show');
            });
        });

        // Close dropdowns when clicking outside
        document.addEventListener('click', function(e) {
            if (!e.target.matches('.dropdown-toggle')) {
                var dropdowns = document.querySelectorAll('.dropdown-menu');
                dropdowns.forEach(function(dropdown) {
                    dropdown.classList.remove('show');
                });
            }
        });

        // Handle dynamic content loading
        document.querySelectorAll('a[data-dynamic]').forEach(link => {
            console.log('Found dynamic link:', link.href);
            link.addEventListener('click', function(e) {
                e.preventDefault();
                console.log('Dynamic link clicked:', this.href);
                
                const url = this.getAttribute('href');
                console.log('Loading URL:', url);
                
                // If this is the dashboard link and we're already on the dashboard, do nothing
                if (url.includes('/accounting/user/dashboard') && window.location.pathname.includes('/accounting/user/dashboard')) {
                    e.stopPropagation();
                    return false;
                }
                
                // If we're already on this page, just prevent the default action
                if (window.location.pathname === url) {
                    return;
                }
                
                // Show loading state
                const mainContent = document.getElementById('main-content');
                if (mainContent) {
                    mainContent.classList.add('loading');
                    console.log('Added loading class to main-content');
                } else {
                    console.warn('main-content element not found');
                }

                // Load content
                fetch(url)
                    .then(response => {
                        console.log('Response status:', response.status);
                        if (!response.ok) {
                            throw new Error('Network response was not ok');
                        }
                        return response.text();
                    })
                    .then(html => {
                        if (mainContent) {
                            console.log('Updating content');
                            // Create a temporary container
                            const temp = document.createElement('div');
                            temp.innerHTML = html;
                            
                            // Find the main content in the response
                            const newContent = temp.querySelector('#main-content');
                            if (newContent) {
                                mainContent.innerHTML = newContent.innerHTML;
                            } else {
                                mainContent.innerHTML = html;
                            }
                            
                            mainContent.classList.remove('loading');
                            console.log('Content updated successfully');
                        } else {
                            console.error('main-content element not found for update');
                        }
                    })
                    .catch(error => {
                        console.error('Error loading content:', error);
                        if (mainContent) {
                            mainContent.innerHTML = '<div class="alert alert-danger">Failed to load content. Please try again.</div>';
                            mainContent.classList.remove('loading');
                        }
                    });
            });
        });
    });

    // Handle logout
    function handleLogout(event) {
        event.preventDefault();
        document.getElementById('logoutForm').submit();
    }
</script> 