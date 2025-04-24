<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enrollment Payment - Accounting System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/static/css/main.css" rel="stylesheet" type="text/css">
</head>
<body>
    <div class="container">
        <div class="payment-form">
            <h2 class="text-center mb-4">New Student Enrollment Payment</h2>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>
            
            <form id="enrollmentForm" action="${pageContext.request.contextPath}/kiosk/payment/enrollment/process" method="post">
                <div class="mb-3">
                    <label for="fullName" class="form-label">Full Name</label>
                    <input type="text" class="form-control" id="fullName" name="fullName" required>
                </div>

                <div class="mb-3">
                    <label for="email" class="form-label">Email Address</label>
                    <input type="email" class="form-control" id="email" name="email" required>
                </div>

                <div class="mb-3">
                    <label for="contactNumber" class="form-label">Contact Number</label>
                    <input type="tel" class="form-control" id="contactNumber" name="contactNumber" required>
                </div>

                <div class="mb-3">
                    <label for="program" class="form-label">Intended Program</label>
                    <select class="form-control" id="program" name="program" required>
                        <option value="">Select Program</option>
                        <option value="BSCS">BS Computer Science</option>
                        <option value="BSIT">BS Information Technology</option>
                        <option value="BSIS">BS Information Systems</option>
                        <option value="BSCE">BS Computer Engineering</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="academicYear" class="form-label">Academic Year</label>
                    <select class="form-control" id="academicYear" name="academicYear" required>
                        <option value="">Select Academic Year</option>
                        <option value="2024-2025">2024-2025</option>
                        <option value="2025-2026">2025-2026</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="semester" class="form-label">Semester</label>
                    <select class="form-control" id="semester" name="semester" required>
                        <option value="">Select Semester</option>
                        <option value="FIRST">First Semester</option>
                        <option value="SECOND">Second Semester</option>
                        <option value="SUMMER">Summer</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="amount" class="form-label">Enrollment Fee</label>
                    <input type="number" class="form-control" id="amount" name="amount" value="25000.00" readonly>
                    <small class="text-muted">Standard enrollment fee for new students</small>
                </div>

                <div class="alert alert-info">
                    <i class="bi bi-info-circle"></i>
                    <small>Note: After successful payment, you will receive a reference number for your enrollment registration.</small>
                </div>

                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-primary">Process Payment</button>
                    <a href="${pageContext.request.contextPath}/kiosk" class="btn btn-secondary">Back to Kiosk</a>
                </div>
            </form>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 