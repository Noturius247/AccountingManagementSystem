<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
    <title>Student Management - Accounting System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/main.css" rel="stylesheet">
    <style>
        .student-card {
            transition: all 0.3s ease;
            border: none;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
        }
        
        .student-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.25);
        }

        .card.border-left-primary {
            border-left: 0.25rem solid #4e73df !important;
        }
        
        .card.border-left-success {
            border-left: 0.25rem solid #1cc88a !important;
        }
        
        .card.border-left-warning {
            border-left: 0.25rem solid #f6c23e !important;
        }
        
        .card.border-left-danger {
            border-left: 0.25rem solid #e74a3b !important;
        }

        .status-badge {
            padding: 0.5em 1em;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
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

        .student-info p {
            font-size: 0.9rem;
        }

        .student-info i {
            margin-right: 8px;
            width: 20px;
            text-align: center;
        }

        .card-header {
            background-color: #f8f9fc;
            border-bottom: 1px solid #e3e6f0;
        }

        .btn-group .btn {
            margin: 0 2px;
        }

        .input-group-text {
            background-color: transparent;
            border-right: none;
        }

        .input-group .form-control {
            border-left: none;
        }

        .input-group .form-control:focus {
            border-color: #bac8f3;
            box-shadow: none;
        }

        .page-link {
            color: #4e73df;
            padding: 0.5rem 0.75rem;
            margin: 0 3px;
            border-radius: 5px;
        }

        .page-item.active .page-link {
            background-color: #4e73df;
            border-color: #4e73df;
        }

        .card-footer {
            background-color: transparent;
            border-top: 1px solid #e3e6f0;
        }

        .admin-students {
            padding: 2rem;
        }

        .documents-list {
            max-height: 400px;
            overflow-y: auto;
        }

        .document-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem;
            border-bottom: 1px solid #dee2e6;
        }

        .document-item:last-child {
            border-bottom: none;
        }

        .document-info {
            flex: 1;
        }

        .document-actions {
            display: flex;
            gap: 0.5rem;
        }

        .academic-history {
            max-height: 500px;
            overflow-y: auto;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
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

        <div class="row">
            <!-- Include Admin Sidebar -->
            <%@ include file="../includes/admin-sidebar.jsp" %>
            
            <!-- Main Content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <!-- Student Management Content -->
                <div class="container-fluid px-4">
                    <!-- Header Section with Stats -->
                    <div class="row mb-4 mt-4">
                        <div class="col-xl-3 col-md-6">
                            <div class="card border-left-primary shadow h-100 py-2">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Total Students</div>
                                            <div class="h5 mb-0 font-weight-bold text-gray-800">${totalStudents}</div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="bi bi-people fa-2x text-gray-300"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6">
                            <div class="card border-left-warning shadow h-100 py-2">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Pending Registrations</div>
                                            <div class="h5 mb-0 font-weight-bold text-gray-800">${pendingCount}</div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="bi bi-clock-history fa-2x text-gray-300"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6">
                            <div class="card border-left-success shadow h-100 py-2">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Approved Students</div>
                                            <div class="h5 mb-0 font-weight-bold text-gray-800">${approvedCount}</div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="bi bi-check-circle fa-2x text-gray-300"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6">
                            <div class="card border-left-danger shadow h-100 py-2">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="text-xs font-weight-bold text-danger text-uppercase mb-1">Rejected Applications</div>
                                            <div class="h5 mb-0 font-weight-bold text-gray-800">${rejectedCount}</div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="bi bi-x-circle fa-2x text-gray-300"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Search and Filter Section -->
                    <div class="card shadow mb-4">
                        <div class="card-header py-3 d-flex justify-content-between align-items-center">
                            <h6 class="m-0 font-weight-bold text-primary">Student Management</h6>
                            <div class="btn-group">
                                <a href="${pageContext.request.contextPath}/admin/student-management/pending" 
                                   class="btn btn-outline-primary btn-sm ${status == 'PENDING' ? 'active' : ''}">
                                    <i class="bi bi-clock"></i> Pending
                                    <span class="badge bg-primary">${pendingCount}</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/student-management/approved" 
                                   class="btn btn-outline-success btn-sm ${status == 'APPROVED' ? 'active' : ''}">
                                    <i class="bi bi-check-circle"></i> Approved
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/student-management" 
                                   class="btn btn-outline-secondary btn-sm ${empty status ? 'active' : ''}">
                                    <i class="bi bi-list"></i> All
                                </a>
                            </div>
                        </div>
                        <div class="card-body">
                            <form class="row g-3" id="searchForm" method="get">
                                <div class="col-md-4">
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="bi bi-search"></i></span>
                                        <input type="text" class="form-control" name="search" value="${param.search}"
                                               placeholder="Search by name or ID...">
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <select class="form-select" name="status" onchange="this.form.submit()">
                                        <option value="">All Status</option>
                                        <option value="PENDING" ${param.status == 'PENDING' ? 'selected' : ''}>Pending</option>
                                        <option value="APPROVED" ${param.status == 'APPROVED' ? 'selected' : ''}>Approved</option>
                                        <option value="REJECTED" ${param.status == 'REJECTED' ? 'selected' : ''}>Rejected</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <select class="form-select" name="program" onchange="this.form.submit()">
                                        <option value="">All Programs</option>
                                        <option value="BSIT" ${param.program == 'BSIT' ? 'selected' : ''}>BSIT</option>
                                        <option value="BSCS" ${param.program == 'BSCS' ? 'selected' : ''}>BSCS</option>
                                        <option value="BSIS" ${param.program == 'BSIS' ? 'selected' : ''}>BSIS</option>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <button type="submit" class="btn btn-primary w-100">
                                        <i class="bi bi-search"></i> Search
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Students List -->
                    <div class="row">
                        <c:forEach items="${students}" var="student">
                            <div class="col-lg-4 col-md-6 mb-4">
                                <div class="card student-card h-100">
                                    <div class="card-header py-3 d-flex justify-content-between align-items-center">
                                        <h6 class="m-0 font-weight-bold">${student.fullName}</h6>
                                        <span class="status-badge status-${student.registrationStatus.toLowerCase()}">
                                            ${student.registrationStatus}
                                        </span>
                                    </div>
                                    <div class="card-body">
                                        <div class="student-info">
                                            <p class="mb-2">
                                                <i class="bi bi-person-badge text-primary"></i>
                                                <strong>Student ID:</strong> ${student.studentId}
                                            </p>
                                            <p class="mb-2">
                                                <i class="bi bi-mortarboard text-info"></i>
                                                <strong>Program:</strong> ${student.program}
                                            </p>
                                            <p class="mb-2">
                                                <i class="bi bi-calendar3 text-success"></i>
                                                <strong>Academic Year:</strong> ${student.academicYear}
                                            </p>
                                            <p class="mb-0">
                                                <i class="bi bi-clock text-warning"></i>
                                                <strong>Semester:</strong> ${student.semester}
                                            </p>
                                        </div>
                                    </div>
                                    <div class="card-footer bg-transparent">
                                        <div class="action-buttons d-flex justify-content-between">
                                            <c:if test="${student.registrationStatus == 'PENDING'}">
                                                <div class="btn-group">
                                                    <form action="${pageContext.request.contextPath}/admin/student-management/${student.id}/approve" 
                                                          method="post" class="d-inline">
                                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                        <button type="submit" class="btn btn-success btn-sm" 
                                                                onclick="return confirm('Are you sure you want to approve this student?')">
                                                            <i class="bi bi-check-lg"></i> Approve
                                                        </button>
                                                    </form>
                                                    <form action="${pageContext.request.contextPath}/admin/student-management/${student.id}/reject" 
                                                          method="post" class="d-inline ms-2">
                                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                        <button type="submit" class="btn btn-danger btn-sm"
                                                                onclick="return confirm('Are you sure you want to reject this student?')">
                                                            <i class="bi bi-x-lg"></i> Reject
                                                        </button>
                                                    </form>
                                                </div>
                                            </c:if>
                                            <a href="${pageContext.request.contextPath}/admin/student-management/${student.id}" 
                                               class="btn btn-info btn-sm">
                                                <i class="bi bi-eye"></i> View Details
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Pagination -->
                    <nav aria-label="Page navigation" class="mt-4">
                        <ul class="pagination justify-content-center">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage - 1}&search=${param.search}&status=${param.status}&program=${param.program}" tabindex="-1">
                                    <i class="bi bi-chevron-left"></i> Previous
                                </a>
                            </li>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}&search=${param.search}&status=${param.status}&program=${param.program}">${i}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage + 1}&search=${param.search}&status=${param.status}&program=${param.program}">
                                    Next <i class="bi bi-chevron-right"></i>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Enable tooltips
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
            var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl)
            });

            // Auto-submit form on select change
            document.querySelectorAll('select[onchange]').forEach(select => {
                select.addEventListener('change', function() {
                    this.form.submit();
                });
            });
        });
    </script>
</body>
</html> 