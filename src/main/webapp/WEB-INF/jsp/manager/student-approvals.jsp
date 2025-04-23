<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Approvals - Manager Dashboard</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/static/css/main.css" rel="stylesheet">
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="../includes/manager-header.jsp" />

    <div class="container-fluid">
        <div class="row">
            <main class="col-md-12 ms-sm-auto px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Student Registration Approvals</h1>
                </div>

                <!-- Success Message -->
                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Error Message -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Pending Students Table -->
                <div class="card">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Student ID</th>
                                        <th>Full Name</th>
                                        <th>Program</th>
                                        <th>Year Level</th>
                                        <th>Academic Year</th>
                                        <th>Semester</th>
                                        <th>Registration Date</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${pendingStudents}" var="student">
                                        <tr>
                                            <td>${student.studentId}</td>
                                            <td>${student.fullName}</td>
                                            <td>${student.program}</td>
                                            <td>${student.yearLevel}</td>
                                            <td>${student.academicYear}</td>
                                            <td>${student.semester}</td>
                                            <td><fmt:formatDate value="${student.createdAt}" pattern="MMM dd, yyyy HH:mm" /></td>
                                            <td>
                                                <button class="btn btn-sm btn-success" onclick="approveStudent(${student.id})">
                                                    <i class="bi bi-check-circle"></i> Approve
                                                </button>
                                                <button class="btn btn-sm btn-danger" onclick="showRejectModal(${student.id})">
                                                    <i class="bi bi-x-circle"></i> Reject
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty pendingStudents}">
                                        <tr>
                                            <td colspan="8" class="text-center py-4">
                                                <div class="text-muted">
                                                    <i class="bi bi-inbox fs-4 d-block mb-2"></i>
                                                    No pending student registrations
                                                </div>
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Reject Modal -->
    <div class="modal fade" id="rejectModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Reject Student Registration</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="rejectForm" method="POST">
                        <div class="mb-3">
                            <label for="reason" class="form-label">Reason for Rejection</label>
                            <textarea class="form-control" id="reason" name="reason" rows="3" required></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" onclick="rejectStudent()">Reject</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        let selectedStudentId = null;
        const rejectModal = new bootstrap.Modal(document.getElementById('rejectModal'));

        function approveStudent(studentId) {
            if (confirm('Are you sure you want to approve this student registration?')) {
                fetch(`${pageContext.request.contextPath}/manager/student-approvals/${studentId}/approve`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        '${_csrf.headerName}': '${_csrf.token}'
                    }
                }).then(response => {
                    if (response.ok) {
                        window.location.reload();
                    } else {
                        alert('Failed to approve student registration');
                    }
                });
            }
        }

        function showRejectModal(studentId) {
            selectedStudentId = studentId;
            rejectModal.show();
        }

        function rejectStudent() {
            const reason = document.getElementById('reason').value;
            if (!reason) {
                alert('Please provide a reason for rejection');
                return;
            }

            const formData = new FormData();
            formData.append('reason', reason);

            fetch(`${pageContext.request.contextPath}/manager/student-approvals/${selectedStudentId}/reject`, {
                method: 'POST',
                body: formData,
                headers: {
                    '${_csrf.headerName}': '${_csrf.token}'
                }
            }).then(response => {
                if (response.ok) {
                    window.location.reload();
                } else {
                    alert('Failed to reject student registration');
                }
            });
        }
    </script>
</body>
</html> 