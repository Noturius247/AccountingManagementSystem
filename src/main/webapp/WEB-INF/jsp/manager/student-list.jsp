<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student List - Manager Dashboard</title>
    
    <!-- CSS Dependencies -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 4px;
            font-weight: 500;
        }
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }
        .status-approved {
            background-color: #d4edda;
            color: #155724;
        }
        .status-rejected {
            background-color: #f8d7da;
            color: #721c24;
        }
        .filter-card {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }
    </style>
</head>
<body>
    <%@ include file="../includes/manager-header.jsp" %>

    <div class="container-fluid py-4">
        <div class="row">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h1 class="h3">Student List</h1>
                    <div class="status-counts">
                        <span class="badge bg-warning me-2">Pending: ${pendingCount}</span>
                        <span class="badge bg-success me-2">Approved: ${approvedCount}</span>
                        <span class="badge bg-danger">Rejected: ${rejectedCount}</span>
                    </div>
                </div>

                <!-- Filters -->
                <div class="filter-card">
                    <form action="${pageContext.request.contextPath}/manager/student-approvals" method="get" class="row g-3">
                        <div class="col-md-3">
                            <input type="text" class="form-control" name="search" value="${currentSearch}" 
                                   placeholder="Search by name or ID...">
                        </div>
                        <div class="col-md-3">
                            <select class="form-select" name="status">
                                <option value="">All Statuses</option>
                                <option value="PENDING" ${currentStatus == 'PENDING' ? 'selected' : ''}>Pending</option>
                                <option value="APPROVED" ${currentStatus == 'APPROVED' ? 'selected' : ''}>Approved</option>
                                <option value="REJECTED" ${currentStatus == 'REJECTED' ? 'selected' : ''}>Rejected</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <select class="form-select" name="program">
                                <option value="">All Programs</option>
                                <option value="BSCS" ${currentProgram == 'BSCS' ? 'selected' : ''}>BS Computer Science</option>
                                <option value="BSIT" ${currentProgram == 'BSIT' ? 'selected' : ''}>BS Information Technology</option>
                                <option value="BSIS" ${currentProgram == 'BSIS' ? 'selected' : ''}>BS Information Systems</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="bi bi-search"></i> Search
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Student List Table -->
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
                                        <th>Status</th>
                                        <th>Registration Date</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${students.content}" var="student">
                                        <tr>
                                            <td>${student.studentId}</td>
                                            <td>${student.fullName}</td>
                                            <td>${student.program}</td>
                                            <td>${student.yearLevel}</td>
                                            <td>
                                                <span class="status-badge status-${fn:toLowerCase(student.registrationStatus)}">
                                                    ${student.registrationStatus}
                                                </span>
                                            </td>
                                            <td>
                                                ${student.createdAt.format(java.time.format.DateTimeFormatter.ofPattern('MMM dd, yyyy'))}
                                            </td>
                                            <td>
                                                <div class="btn-group">
                                                    <a href="${pageContext.request.contextPath}/manager/student-approvals/${student.id}" 
                                                       class="btn btn-sm btn-outline-primary">
                                                        <i class="bi bi-eye"></i> View
                                                    </a>
                                                    <c:choose>
                                                        <c:when test="${student.registrationStatus == 'PENDING'}">
                                                            <button type="button" 
                                                                    class="btn btn-sm btn-outline-success"
                                                                    onclick="approveStudent('${student.id}')">
                                                                <i class="bi bi-check"></i> Approve
                                                            </button>
                                                            <button type="button" 
                                                                    class="btn btn-sm btn-outline-danger"
                                                                    onclick="rejectStudent('${student.id}')">
                                                                <i class="bi bi-x"></i> Reject
                                                            </button>
                                                        </c:when>
                                                        <c:when test="${student.registrationStatus == 'APPROVED'}">
                                                            <button type="button" 
                                                                    class="btn btn-sm btn-outline-warning"
                                                                    onclick="revokeApproval('${student.id}')">
                                                                <i class="bi bi-arrow-counterclockwise"></i> Revoke
                                                            </button>
                                                        </c:when>
                                                    </c:choose>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <c:if test="${students.totalPages > 1}">
                            <nav aria-label="Page navigation" class="mt-4">
                                <ul class="pagination justify-content-center">
                                    <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                                        <a class="page-link" href="?page=${currentPage - 1}&search=${currentSearch}&status=${currentStatus}&program=${currentProgram}">Previous</a>
                                    </li>
                                    <c:forEach begin="0" end="${students.totalPages - 1}" var="i">
                                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                                            <a class="page-link" href="?page=${i}&search=${currentSearch}&status=${currentStatus}&program=${currentProgram}">${i + 1}</a>
                                        </li>
                                    </c:forEach>
                                    <li class="page-item ${currentPage + 1 == students.totalPages ? 'disabled' : ''}">
                                        <a class="page-link" href="?page=${currentPage + 1}&search=${currentSearch}&status=${currentStatus}&program=${currentProgram}">Next</a>
                                    </li>
                                </ul>
                            </nav>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Reject Modal -->
    <div class="modal fade" id="rejectModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Reject Registration</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="rejectForm" method="POST">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="rejectReason" class="form-label">Reason for Rejection</label>
                            <textarea class="form-control" id="rejectReason" name="reason" rows="3" required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-danger" onclick="rejectStudent()">Reject</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- JavaScript Dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function showRejectForm(studentId) {
            const modal = new bootstrap.Modal(document.getElementById('rejectModal'));
            const form = document.getElementById('rejectForm');
            form.action = '${pageContext.request.contextPath}/manager/student-approvals/' + studentId + '/reject';
            modal.show();
        }

        function approveStudent(studentId) {
            if (confirm('Are you sure you want to approve this student registration?')) {
                fetch(`${pageContext.request.contextPath}/manager/student-approvals/${studentId}/approve`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        '${_csrf.headerName}': '${_csrf.token}'
                    }
                })
                .then(response => {
                    if (response.ok) {
                        window.location.reload();
                    } else {
                        alert('Failed to approve student registration');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('An error occurred while processing your request');
                });
            }
        }

        function rejectStudent(studentId) {
            if (confirm('Are you sure you want to reject this student registration?')) {
                fetch(`${pageContext.request.contextPath}/manager/student-approvals/${studentId}/reject`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        '${_csrf.headerName}': '${_csrf.token}'
                    }
                })
                .then(response => {
                    if (response.ok) {
                        window.location.reload();
                    } else {
                        alert('Failed to reject student registration');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('An error occurred while processing your request');
                });
            }
        }

        function revokeApproval(studentId) {
            if (confirm('Are you sure you want to revoke this student\'s approval?')) {
                fetch(`${pageContext.request.contextPath}/manager/student-approvals/${studentId}/revoke`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        '${_csrf.headerName}': '${_csrf.token}'
                    }
                })
                .then(response => {
                    if (response.ok) {
                        window.location.reload();
                    } else {
                        alert('Failed to revoke student approval');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('An error occurred while processing your request');
                });
            }
        }
    </script>
</body>
</html> 