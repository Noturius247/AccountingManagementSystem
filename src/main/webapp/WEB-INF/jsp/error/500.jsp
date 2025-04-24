<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Internal Server Error - Accounting Management System</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/static/css/main.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow-sm">
                    <div class="card-body text-center py-5">
                        <i class="bi bi-exclamation-triangle text-danger" style="font-size: 4rem;"></i>
                        <h2 class="mt-4">Internal Server Error</h2>
                        <p class="text-muted mb-4">
                            Sorry, something went wrong on our end. We're working to fix the issue.
                        </p>
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger mb-4">
                                ${errorMessage}
                            </div>
                        </c:if>
                        <div class="d-grid gap-2 d-sm-flex justify-content-sm-center">
                            <button onclick="window.history.back()" class="btn btn-outline-secondary me-sm-2">
                                <i class="bi bi-arrow-left"></i> Go Back
                            </button>
                            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary">
                                <i class="bi bi-house"></i> Go to Dashboard
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Technical Details (Only shown in development) -->
                <c:if test="${not empty pageContext.errorData.throwable}">
                    <div class="card mt-4">
                        <div class="card-header">
                            <h5 class="mb-0">Technical Details</h5>
                        </div>
                        <div class="card-body">
                            <pre class="mb-0"><code>${pageContext.errorData.throwable.message}</code></pre>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 