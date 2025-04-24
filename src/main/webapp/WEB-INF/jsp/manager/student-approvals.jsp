<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>
<%!
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
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
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2">
                            <select class="form-select" id="statusFilter" onchange="filterByStatus(this.value)">
                                <option value="PENDING" ${param.status == 'PENDING' || empty param.status ? 'selected' : ''}>Pending</option>
                                <option value="APPROVED" ${param.status == 'APPROVED' ? 'selected' : ''}>Approved</option>
                                <option value="REJECTED" ${param.status == 'REJECTED' ? 'selected' : ''}>Rejected</option>
                                <option value="ALL" ${param.status == 'ALL' ? 'selected' : ''}>All</option>
                            </select>
                        </div>
                    </div>
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
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${students}" var="student">
                                        <tr>
                                            <td>${student.studentId}</td>
                                            <td>${student.fullName}</td>
                                            <td>${student.program}</td>
                                            <td>${student.yearLevel}</td>
                                            <td>${student.academicYear}</td>
                                            <td>${student.semester}</td>
                                            <td>
                                                <c:if test="${not empty student.createdAt}">
                                                    <fmt:parseDate value="${student.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both"/>
                                                    <fmt:formatDate value="${parsedDate}" pattern="MMM dd, yyyy HH:mm"/>
                                                </c:if>
                                            </td>
                                            <td>
                                                <span class="badge ${student.registrationStatus == 'APPROVED' ? 'bg-success' : 
                                                                  student.registrationStatus == 'PENDING' ? 'bg-warning' : 'bg-danger'}">
                                                    ${student.registrationStatus}
                                                </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${student.registrationStatus == 'PENDING'}">
                                                        <a href="${pageContext.request.contextPath}/manager/student-approvals/${student.id}" class="btn btn-sm btn-info me-1">
                                                            <i class="bi bi-eye"></i> View
                                                        </a>
                                                        <button class="btn btn-sm btn-success" onclick='approveStudent("${student.id}")'>
                                                            <i class="bi bi-check-circle"></i> Approve
                                                        </button>
                                                        <button class="btn btn-sm btn-danger" onclick='showRejectModal("${student.id}")'>
                                                            <i class="bi bi-x-circle"></i> Reject
                                                        </button>
                                                    </c:when>
                                                    <c:when test="${student.registrationStatus == 'APPROVED'}">
                                                        <a href="${pageContext.request.contextPath}/manager/student-approvals/${student.id}" class="btn btn-sm btn-info me-1">
                                                            <i class="bi bi-eye"></i> View
                                                        </a>
                                                        <button class="btn btn-sm btn-warning" onclick="revokeApproval('${student.id}')">
                                                            <i class="bi bi-arrow-counterclockwise"></i> Revoke
                                                        </button>
                                                    </c:when>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty students}">
                                        <tr>
                                            <td colspan="9" class="text-center py-4">
                                                <div class="text-muted">
                                                    <i class="bi bi-inbox fs-4 d-block mb-2"></i>
                                                    No students found
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

        function buildUrl(studentId, action) {
            if (!studentId || !action) {
                console.error('Both studentId and action are required for buildUrl');
                return null;
            }
            
            // Get the context path and ensure it starts with a slash
            const contextPath = '${pageContext.request.contextPath}'.replace(/^\/+|\/+$/g, '');
            
            // Clean up the studentId by removing any potential slashes
            studentId = studentId.toString().replace(/[^\d]/g, '');
            
            // Construct the URL parts, ensuring each part is clean of leading/trailing slashes
            const parts = [
                contextPath,
                'manager',
                'student-approvals',
                studentId,
                action
            ].filter(Boolean).map(part => part.toString().replace(/^\/+|\/+$/g, ''));
            
            // Join all parts with a single slash
            return '/' + parts.join('/');
        }

        function approveStudent(studentId) {
            if (!studentId || !confirm('Are you sure you want to approve this student registration?')) {
                return;
            }

            const url = buildUrl(studentId, 'approve');
            if (!url) {
                alert('Invalid URL construction');
                return;
            }

            console.log('Sending approval request to:', url); // Debug log

            const csrfToken = document.querySelector("meta[name='_csrf']").getAttribute("content");
            const csrfHeader = document.querySelector("meta[name='_csrf_header']").getAttribute("content");

            fetch(url, {
                method: 'POST',
                headers: {
                    [csrfHeader]: csrfToken
                }
            })
            .then(response => {
                if (!response.ok) {
                    return response.text().then(text => {
                        try {
                            const error = JSON.parse(text);
                            throw new Error(error.message || 'Failed to approve student registration');
                        } catch (e) {
                            throw new Error('Failed to approve student registration');
                        }
                    });
                }
                window.location.href = '${pageContext.request.contextPath}/manager/student-approvals';
            })
            .catch(error => {
                console.error('Error:', error);
                alert(error.message || 'Failed to approve student registration. Please try again.');
            });
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

            const url = buildUrl(selectedStudentId, 'reject');
            if (!url) {
                alert('Invalid URL construction');
                return;
            }

            const csrfToken = document.querySelector("meta[name='_csrf']").getAttribute("content");
            const csrfHeader = document.querySelector("meta[name='_csrf_header']").getAttribute("content");
            const formData = new FormData();
            formData.append('reason', reason);

            fetch(url, {
                method: 'POST',
                body: formData,
                headers: {
                    [csrfHeader]: csrfToken
                }
            })
            .then(response => {
                if (!response.ok) {
                    return response.text().then(text => {
                        try {
                            const error = JSON.parse(text);
                            throw new Error(error.message || 'Failed to reject student registration');
                        } catch (e) {
                            throw new Error('Failed to reject student registration');
                        }
                    });
                }
                window.location.reload();
            })
            .catch(error => {
                console.error('Error:', error);
                alert(error.message || 'Failed to reject student registration. Please try again.');
            });
        }

        function revokeApproval(studentId) {
            if (!studentId || !confirm('Are you sure you want to revoke this student\'s approval?')) {
                return;
            }

            const url = buildUrl(studentId, 'revoke');
            if (!url) {
                alert('Invalid URL construction');
                return;
            }

            const csrfToken = document.querySelector("meta[name='_csrf']").getAttribute("content");
            const csrfHeader = document.querySelector("meta[name='_csrf_header']").getAttribute("content");

            fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    [csrfHeader]: csrfToken
                }
            })
            .then(response => {
                if (!response.ok) {
                    return response.text().then(text => {
                        try {
                            const error = JSON.parse(text);
                            throw new Error(error.message || 'Failed to revoke approval');
                        } catch (e) {
                            throw new Error('Failed to revoke approval');
                        }
                    });
                }
                window.location.reload();
            })
            .catch(error => {
                console.error('Error:', error);
                alert(error.message || 'Failed to revoke approval. Please try again.');
            });
        }

        function filterByStatus(status) {
            window.location.href = '${pageContext.request.contextPath}/manager/student-approvals?status=' + status;
        }
    </script>
</body>
</html> 