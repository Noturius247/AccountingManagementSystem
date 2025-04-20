<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
    <h1 class="h2">Student Details</h1>
    <div class="btn-toolbar mb-2 mb-md-0">
        <div class="btn-group me-2">
            <div class="action-buttons">
                <a href="mailto:${student.user.email}" class="btn btn-primary">
                    <i class="bi bi-envelope"></i> Send Email
                </a>
                <a href="${pageContext.request.contextPath}/admin/student-management/${student.id}/documents" class="btn btn-info">
                    <i class="bi bi-file-earmark-text"></i> View Documents
                </a>
                <a href="${pageContext.request.contextPath}/admin/student-management/${student.id}/transactions" class="btn btn-success">
                    <i class="bi bi-cash-stack"></i> View Transactions
                </a>
                <c:if test="${student.registrationStatus == 'PENDING'}">
                    <form action="${pageContext.request.contextPath}/admin/student-management/${student.id}/approve" method="post" class="d-inline">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <button type="submit" class="btn btn-success">
                            <i class="bi bi-check-lg"></i> Approve
                        </button>
                    </form>
                    <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#rejectModal">
                        <i class="bi bi-x-lg"></i> Reject
                    </button>
                </c:if>
                <a href="${pageContext.request.contextPath}/admin/student-management" class="btn btn-secondary">
                    <i class="bi bi-arrow-left"></i> Back to List
                </a>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-8">
        <div class="card student-details-card mb-4">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3 class="card-title mb-0">${student.fullName}</h3>
                    <span class="status-badge status-${student.registrationStatus.toLowerCase()}">
                        ${student.registrationStatus}
                    </span>
                </div>

                <div class="detail-row">
                    <div class="row">
                        <div class="col-md-4">
                            <span class="detail-label">Student ID</span>
                        </div>
                        <div class="col-md-8">
                            ${student.studentId}
                        </div>
                    </div>
                </div>

                <div class="detail-row">
                    <div class="row">
                        <div class="col-md-4">
                            <span class="detail-label">Email</span>
                        </div>
                        <div class="col-md-8">
                            ${student.user.email}
                        </div>
                    </div>
                </div>

                <div class="detail-row">
                    <div class="row">
                        <div class="col-md-4">
                            <span class="detail-label">Program</span>
                        </div>
                        <div class="col-md-8">
                            ${student.program}
                        </div>
                    </div>
                </div>

                <div class="detail-row">
                    <div class="row">
                        <div class="col-md-4">
                            <span class="detail-label">Academic Year</span>
                        </div>
                        <div class="col-md-8">
                            ${student.academicYear}
                        </div>
                    </div>
                </div>

                <div class="detail-row">
                    <div class="row">
                        <div class="col-md-4">
                            <span class="detail-label">Semester</span>
                        </div>
                        <div class="col-md-8">
                            ${student.semester}
                        </div>
                    </div>
                </div>

                <div class="detail-row">
                    <div class="row">
                        <div class="col-md-4">
                            <span class="detail-label">Registration Date</span>
                        </div>
                        <div class="col-md-8">
                            <fmt:formatDate value="${student.createdAt}" pattern="MMMM dd, yyyy HH:mm" />
                        </div>
                    </div>
                </div>

                <div class="detail-row">
                    <div class="row">
                        <div class="col-md-4">
                            <span class="detail-label">Last Updated</span>
                        </div>
                        <div class="col-md-8">
                            <fmt:formatDate value="${student.updatedAt}" pattern="MMMM dd, yyyy HH:mm" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-md-4">
        <div class="card student-details-card mb-4">
            <div class="card-body">
                <h5 class="card-title mb-4">Actions</h5>
                <div class="d-grid gap-2">
                    <a href="mailto:${student.user.email}" class="btn btn-outline-primary">
                        <i class="bi bi-envelope"></i> Send Email
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/student-management/${student.id}/documents" class="btn btn-outline-secondary">
                        <i class="bi bi-file-text"></i> View Documents
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/student-management/${student.id}/transactions" class="btn btn-outline-info">
                        <i class="bi bi-cash-stack"></i> View Transactions
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Reject Modal -->
<div class="modal fade" id="rejectModal" tabindex="-1" aria-labelledby="rejectModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="rejectModalLabel">Reject Registration</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/student-management/${student.id}/reject" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="reason" class="form-label">Reason for Rejection</label>
                        <textarea class="form-control" id="reason" name="reason" rows="3" required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-danger">Confirm Rejection</button>
                </div>
            </form>
        </div>
    </div>
</div> 