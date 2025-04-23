<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pending Student Registrations - Manager Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .registration-card {
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            background: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .registration-card:hover {
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }

        .student-info {
            margin-bottom: 1rem;
        }

        .action-buttons {
            display: flex;
            gap: 0.5rem;
        }

        .reject-form {
            display: none;
            margin-top: 1rem;
            padding: 1rem;
            background: #f8f9fa;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <div class="container py-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Pending Student Registrations</h1>
            <a href="${pageContext.request.contextPath}/manager/dashboard" class="btn btn-secondary">
                <i class="bi bi-arrow-left"></i> Back to Dashboard
            </a>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <i class="bi bi-exclamation-circle"></i> ${error}
            </div>
        </c:if>

        <c:if test="${not empty success}">
            <div class="alert alert-success">
                <i class="bi bi-check-circle"></i> ${success}
            </div>
        </c:if>

        <c:if test="${empty pendingStudents}">
            <div class="alert alert-info">
                <i class="bi bi-info-circle"></i> No pending student registrations.
            </div>
        </c:if>

        <c:forEach items="${pendingStudents}" var="student">
            <div class="registration-card">
                <div class="student-info">
                    <h4>${student.fullName}</h4>
                    <p class="text-muted">Student ID: ${student.studentId}</p>
                    <p><strong>Program:</strong> ${student.program}</p>
                    <p><strong>Year Level:</strong> ${student.yearLevel}</p>
                    <p><strong>Academic Year:</strong> ${student.academicYear}</p>
                    <p><strong>Semester:</strong> ${student.semester}</p>
                </div>

                <div class="action-buttons">
                    <form action="${pageContext.request.contextPath}/manager/students/approve/${student.id}" method="post" style="display: inline;">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <button type="submit" class="btn btn-success">
                            <i class="bi bi-check-circle"></i> Approve
                        </button>
                    </form>
                    <button type="button" class="btn btn-danger" onclick="showRejectForm(${student.id})">
                        <i class="bi bi-x-circle"></i> Reject
                    </button>
                </div>

                <div id="rejectForm${student.id}" class="reject-form">
                    <form action="${pageContext.request.contextPath}/manager/students/reject/${student.id}" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <div class="mb-3">
                            <label for="reason${student.id}" class="form-label">Reason for Rejection</label>
                            <textarea class="form-control" id="reason${student.id}" name="reason" rows="3" required></textarea>
                        </div>
                        <button type="submit" class="btn btn-danger">
                            <i class="bi bi-x-circle"></i> Confirm Rejection
                        </button>
                        <button type="button" class="btn btn-secondary" onclick="hideRejectForm(${student.id})">
                            Cancel
                        </button>
                    </form>
                </div>
            </div>
        </c:forEach>
    </div>

    <script>
        function showRejectForm(studentId) {
            document.getElementById('rejectForm' + studentId).style.display = 'block';
        }

        function hideRejectForm(studentId) {
            document.getElementById('rejectForm' + studentId).style.display = 'none';
        }
    </script>
</body>
</html> 