<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${param.title} - Manager Dashboard</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link href="<c:url value='/resources/css/manager.css' />" rel="stylesheet">
    
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JavaScript -->
    <script src="<c:url value='/resources/js/manager.js' />"></script>
</head>
<body>
    <div class="wrapper">
        <!-- Sidebar -->
        <nav id="sidebar" class="bg-dark">
            <div class="sidebar-header">
                <h3>Manager Dashboard</h3>
            </div>

            <ul class="list-unstyled components">
                <li class="active">
                    <a href="<c:url value='/manager/dashboard' />">
                        <i class="fas fa-home"></i> Dashboard
                    </a>
                </li>
                <li>
                    <a href="<c:url value='/manager/queue' />">
                        <i class="fas fa-list"></i> Queue Management
                    </a>
                </li>
                <li>
                    <a href="<c:url value='/manager/transactions' />">
                        <i class="fas fa-exchange-alt"></i> Transactions
                    </a>
                </li>
                <li>
                    <a href="<c:url value='/manager/reports' />">
                        <i class="fas fa-chart-bar"></i> Reports
                    </a>
                </li>
                <li>
                    <a href="<c:url value='/manager/settings' />">
                        <i class="fas fa-cog"></i> Settings
                    </a>
                </li>
            </ul>
        </nav>

        <!-- Page Content -->
        <div id="content">
            <!-- Top Navigation -->
            <nav class="navbar navbar-expand-lg navbar-light bg-light">
                <div class="container-fluid">
                    <button type="button" id="sidebarCollapse" class="btn btn-dark">
                        <i class="fas fa-bars"></i>
                    </button>
                    
                    <div class="ms-auto">
                        <ul class="navbar-nav">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                                    <i class="fas fa-user"></i> Manager
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <li><a class="dropdown-item" href="<c:url value='/manager/profile' />">Profile</a></li>
                                    <li><a class="dropdown-item" href="<c:url value='/manager/settings' />">Settings</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li>
                                        <form action="<c:url value='/logout' />" method="post">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                            <button type="submit" class="dropdown-item">Logout</button>
                                        </form>
                                    </li>
                                </ul>
                            </li>
                        </ul>
                    </div>
                </div>
            </nav>

            <!-- Main Content -->
            <div class="container-fluid">
                <jsp:include page="${param.content}" />
            </div>
        </div>
    </div>

    <script>
        $(document).ready(function() {
            $('#sidebarCollapse').on('click', function() {
                $('#sidebar').toggleClass('active');
            });
        });
    </script>
</body>
</html> 