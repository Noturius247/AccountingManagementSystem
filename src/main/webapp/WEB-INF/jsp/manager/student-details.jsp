<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm:ss");
    request.setAttribute("dateFormatter", dateFormatter);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Details - Manager Dashboard</title>
    
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
                    <h1 class="h2">Student Details</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/manager/student-approvals" class="btn btn-sm btn-outline-secondary">
                            <i class="bi bi-arrow-left"></i> Back to List
                        </a>
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

                <div class="card">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h3 class="card-title">Personal Information</h3>
                                <table class="table table-borderless">
                                    <tr>
                                        <th width="30%">Full Name:</th>
                                        <td>${student.fullName}</td>
                                    </tr>
                                    <tr>
                                        <th>Student ID:</th>
                                        <td>${student.studentId}</td>
                                    </tr>
                                    <tr>
                                        <th>Email:</th>
                                        <td>${student.user.email}</td>
                                    </tr>
                                    <tr>
                                        <th>Phone Number:</th>
                                        <td>${student.user.phoneNumber}</td>
                                    </tr>
                                    <tr>
                                        <th>Address:</th>
                                        <td>${student.user.address}</td>
                                    </tr>
                                </table>
                            </div>
                            <div class="col-md-6">
                                <h3 class="card-title">Academic Information</h3>
                                <table class="table table-borderless">
                                    <tr>
                                        <th width="30%">Program:</th>
                                        <td>${student.program}</td>
                                    </tr>
                                    <tr>
                                        <th>Year Level:</th>
                                        <td>${student.yearLevel}</td>
                                    </tr>
                                    <tr>
                                        <th>Academic Year:</th>
                                        <td>${student.academicYear}</td>
                                    </tr>
                                    <tr>
                                        <th>Semester:</th>
                                        <td>${student.semester}</td>
                                    </tr>
                                    <tr>
                                        <th>Registration Status:</th>
                                        <td>
                                            <span class="badge ${student.registrationStatus == 'APPROVED' ? 'bg-success' : 
                                                              student.registrationStatus == 'PENDING' ? 'bg-warning' : 'bg-danger'}">
                                                ${student.registrationStatus}
                                            </span>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>

                        <div class="row mt-4">
                            <div class="col-md-12">
                                <h3 class="card-title">Registration Timeline</h3>
                                <table class="table table-borderless">
                                    <tr>
                                        <th width="15%">Registration Date:</th>
                                        <td>${student.createdAt != null ? student.createdAt.format(dateFormatter) : 'N/A'}</td>
                                    </tr>
                                    <tr>
                                        <th>Last Updated:</th>
                                        <td>${student.updatedAt != null ? student.updatedAt.format(dateFormatter) : 'N/A'}</td>
                                    </tr>
                                </table>
                            </div>
                        </div>

                        <div class="row mt-4">
                            <div class="col-md-12">
                                <div class="d-flex justify-content-end gap-2">
                                    <c:choose>
                                        <c:when test="${student.registrationStatus == 'PENDING'}">
                                            <button class="btn btn-success" onclick="approveStudent('${student.id}')">
                                                <i class="bi bi-check-circle"></i> Approve Registration
                                            </button>
                                            <button class="btn btn-danger" onclick="showRejectModal('${student.id}')">
                                                <i class="bi bi-x-circle"></i> Reject Registration
                                            </button>
                                        </c:when>
                                        <c:when test="${student.registrationStatus == 'APPROVED'}">
                                            <button class="btn btn-sm btn-warning" onclick="revokeApproval('${student.id}')">
                                                <i class="bi bi-arrow-counterclockwise"></i> Revoke
                                            </button>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </div>
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