<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Accounting System</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/static/css/main.css" rel="stylesheet">
</head>
<body>
    <%@ include file="../includes/user-header.jsp" %>

    <div class="container-fluid">
        <div class="row">
            <main class="col-md-12 ms-sm-auto px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">My Profile</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/user/settings" class="btn btn-primary">
                            <i class="bi bi-gear me-1"></i> Settings
                        </a>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-4">
                        <!-- Profile Card -->
                        <div class="card mb-4">
                            <div class="card-body text-center">
                                <div class="mb-3">
                                    <i class="bi bi-person-circle" style="font-size: 4rem; color: var(--primary-color);"></i>
                                </div>
                                <h4 class="card-title">${user.firstName} ${user.lastName}</h4>
                                <p class="text-muted">${user.username}</p>
                                <p class="text-muted">${user.email}</p>
                                <p class="text-muted">
                                    ${fn:substring(user.createdAt.toString(), 0, 10)}
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-8">
                        <!-- Account Information -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <h5 class="card-title mb-0">Account Information</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <p><strong>Username:</strong> ${user.username}</p>
                                        <p><strong>Email:</strong> ${user.email}</p>
                                        <p><strong>Role:</strong> ${user.role}</p>
                                    </div>
                                    <div class="col-md-6">
                                        <p><strong>Account Created:</strong> 
                                            ${fn:substring(user.createdAt.toString(), 0, 10)}
                                        </p>
                                        <p><strong>Last Updated:</strong> 
                                            ${fn:substring(user.updatedAt.toString(), 0, 10)}
                                        </p>
                                        <p><strong>Status:</strong> 
                                            <span class="badge bg-${user.enabled ? 'success' : 'danger'}">
                                                ${user.enabled ? 'Active' : 'Inactive'}
                                            </span>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Student Information -->
                        <c:if test="${user.student}">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">Student Information</h5>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <p><strong>Student ID:</strong> ${user.studentId}</p>
                                            <p><strong>Program:</strong> ${user.program}</p>
                                            <p><strong>Year Level:</strong> ${user.yearLevel}</p>
                                        </div>
                                        <div class="col-md-6">
                                            <p><strong>Academic Year:</strong> ${user.academicYear}</p>
                                            <p><strong>Semester:</strong> ${user.semester}</p>
                                            <p><strong>Registration Status:</strong> 
                                                <span class="badge bg-${user.registrationStatus == 'APPROVED' ? 'success' : 
                                                                        user.registrationStatus == 'PENDING' ? 'warning' : 'danger'}">
                                                    ${user.registrationStatus}
                                                </span>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 