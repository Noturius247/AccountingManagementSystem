<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - Accounting Management System</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/static/css/main.css" rel="stylesheet">
    
    <style>
        :root {
            --primary-color: #2c3e50;
            --secondary-color: #3498db;
            --light-color: #f8f9fa;
            --dark-color: #343a40;
            --success-color: #28a745;
            --danger-color: #dc3545;
            --warning-color: #ffc107;
            --info-color: #17a2b8;
            --border-color: #dee2e6;
            --text-color: #212529;
            --shadow-sm: 0 2px 4px rgba(0,0,0,0.1);
            --shadow-md: 0 4px 6px rgba(0,0,0,0.1);
            --shadow-lg: 0 10px 15px rgba(0,0,0,0.1);
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: #f5f5f5;
        }

        #main-content {
            transition: opacity 0.3s ease-in-out;
            min-height: calc(100vh - 120px);
            padding: 2rem 0;
        }

        .loading {
            opacity: 0.6;
            pointer-events: none;
        }

        .loading::after {
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

        .stat-card {
            background: white;
            border-radius: 10px;
            padding: 1.5rem;
            box-shadow: var(--shadow-sm);
            transition: transform 0.2s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-md);
        }

        .stat-card h3 {
            color: var(--text-color);
            font-size: 1rem;
            margin-bottom: 0.5rem;
        }

        .stat-card p {
            color: var(--primary-color);
            font-size: 1.5rem;
            font-weight: 600;
            margin: 0;
        }

        /* Admin layout specific styles */
        .admin-layout {
            display: flex;
            min-height: 100vh;
        }

        .admin-main {
            flex: 1;
            margin-left: 250px;
            transition: margin-left 0.3s ease;
        }

        .admin-content {
            padding: 2rem;
        }

        @media (max-width: 767.98px) {
            .admin-main {
                margin-left: 0;
            }
        }
    </style>
</head>
<body>
    <%@ include file="../includes/header.jsp" %>

    <sec:authorize access="hasRole('ADMIN')">
        <div class="admin-layout">
            <%@ include file="../includes/admin-sidebar.jsp" %>
            <main class="admin-main">
                <div class="admin-content">
                    <div id="main-content">
                        <jsp:include page="${contentPage}" />
                    </div>
                </div>
            </main>
        </div>
    </sec:authorize>
    <sec:authorize access="!hasRole('ADMIN')">
        <c:choose>
            <c:when test="${pageContext.request.requestURI.contains('/admin/')}">
                <div class="container">
                    <div class="row justify-content-center">
                        <div class="col-md-8 text-center mt-5">
                            <div class="alert alert-danger">
                                <h4><i class="bi bi-shield-lock"></i> Access Denied</h4>
                                <p>You do not have permission to access this page.</p>
                                <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Return to Home</a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="container">
                    <div class="row">
                        <main class="col-md-12">
                            <div id="main-content">
                                <jsp:include page="${contentPage}" />
                            </div>
                        </main>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </sec:authorize>

    <%@ include file="../includes/footer.jsp" %>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JavaScript for Dynamic Content Loading -->
    <script>
        $(document).ready(function() {
            // Handle all navigation links with data-dynamic attribute
            $(document).on('click', 'a[data-dynamic]', function(e) {
                e.preventDefault();
                const url = $(this).attr('href');
                loadContent(url);
            });

            function loadContent(url) {
                // Add loading state
                $('#main-content').addClass('loading');
                
                // Load content
                $.get(url, function(response) {
                    $('#main-content').html(response);
                    
                    // Update URL without page reload
                    history.pushState(null, '', url);
                    
                    // Update active state in sidebar
                    $('.sidebar .nav-link').removeClass('active');
                    $('.sidebar .nav-link[href="' + url + '"]').addClass('active');
                    
                    // Reinitialize Bootstrap components
                    initializeBootstrapComponents();
                    
                    // Trigger a custom event for page-specific initialization
                    $(document).trigger('contentLoaded');
                })
                .fail(function(jqXHR, textStatus, errorThrown) {
                    console.error('Error loading content:', errorThrown);
                    $('#main-content').html(`
                        <div class="alert alert-danger">
                            <h4 class="alert-heading">Error Loading Content</h4>
                            <p>There was an error loading the requested content. Please try again or refresh the page.</p>
                            <hr>
                            <p class="mb-0">Error details: ${errorThrown}</p>
                        </div>
                    `);
                })
                .always(function() {
                    // Remove loading state
                    $('#main-content').removeClass('loading');
                });
            }

            function initializeBootstrapComponents() {
                // Initialize tooltips
                var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                tooltipTriggerList.map(function (tooltipTriggerEl) {
                    return new bootstrap.Tooltip(tooltipTriggerEl);
                });

                // Initialize popovers
                var popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'));
                popoverTriggerList.map(function (popoverTriggerEl) {
                    return new bootstrap.Popover(popoverTriggerEl);
                });

                // Initialize dropdowns
                var dropdownTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="dropdown"]'));
                dropdownTriggerList.map(function (dropdownTriggerEl) {
                    return new bootstrap.Dropdown(dropdownTriggerEl);
                });
            }

            // Handle browser back/forward buttons
            $(window).on('popstate', function(e) {
                if (e.originalEvent.state !== null) {
                    loadContent(window.location.pathname);
                }
            });

            // Initialize page on first load if URL is not homepage
            if (window.location.pathname !== '/' && window.location.pathname !== '') {
                loadContent(window.location.pathname);
            }
        });
    </script>
</body>
</html> 