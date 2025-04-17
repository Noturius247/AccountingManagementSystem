<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Documents</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/main.css" rel="stylesheet">
</head>
<body>
    <%@ include file="/WEB-INF/jsp/includes/header.jsp" %>

    <div class="container-fluid">
        <div class="row">
            <main class="col-md-12 ms-sm-auto px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">My Documents</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#uploadModal">
                            <i class="bi bi-upload"></i> Upload Document
                        </button>
                    </div>
                </div>

                <!-- Quick Stats -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="card stat-card">
                            <div class="card-body">
                                <h5 class="card-title">Total Documents</h5>
                                <h2 class="card-text">${statistics.totalDocuments}</h2>
                                <p class="text-muted">All time</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card stat-card">
                            <div class="card-body">
                                <h5 class="card-title">Pending Review</h5>
                                <h2 class="card-text">${statistics.pendingDocuments}</h2>
                                <p class="text-muted">Awaiting approval</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card stat-card">
                            <div class="card-body">
                                <h5 class="card-title">Approved</h5>
                                <h2 class="card-text">${statistics.approvedDocuments}</h2>
                                <p class="text-muted">Successfully verified</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card stat-card">
                            <div class="card-body">
                                <h5 class="card-title">Rejected</h5>
                                <h2 class="card-text">${statistics.rejectedDocuments}</h2>
                                <p class="text-muted">Requires attention</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Filters -->
                <div class="card mb-4">
                    <div class="card-body">
                        <form id="filterForm" class="row g-3">
                            <div class="col-md-3">
                                <label for="startDate" class="form-label">Start Date</label>
                                <input type="date" class="form-control" id="startDate" name="startDate">
                            </div>
                            <div class="col-md-3">
                                <label for="endDate" class="form-label">End Date</label>
                                <input type="date" class="form-control" id="endDate" name="endDate">
                            </div>
                            <div class="col-md-3">
                                <label for="status" class="form-label">Status</label>
                                <select class="form-select" id="status" name="status">
                                    <option value="">All</option>
                                    <option value="PENDING">Pending</option>
                                    <option value="APPROVED">Approved</option>
                                    <option value="REJECTED">Rejected</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label for="type" class="form-label">Document Type</label>
                                <select class="form-select" id="type" name="type">
                                    <option value="">All</option>
                                    <option value="RECEIPT">Receipt</option>
                                    <option value="INVOICE">Invoice</option>
                                    <option value="CERTIFICATE">Certificate</option>
                                    <option value="OTHER">Other</option>
                                </select>
                            </div>
                            <div class="col-12">
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-filter"></i> Apply Filters
                                </button>
                                <button type="reset" class="btn btn-secondary">
                                    <i class="bi bi-x-circle"></i> Clear
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Documents Table -->
                <div class="card">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Upload Date</th>
                                        <th>Document Name</th>
                                        <th>Type</th>
                                        <th>Size</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${documents}" var="document">
                                        <tr>
                                            <td>${fn:substring(document.uploadedAt, 0, 10)}</td>
                                            <td>${document.fileName}</td>
                                            <td>${document.type}</td>
                                            <td>${document.fileSize}</td>
                                            <td>
                                                <span class="badge bg-${document.status == 'APPROVED' ? 'success' : 
                                                                        document.status == 'PENDING' ? 'warning' : 
                                                                        'danger'}">
                                                    ${document.status}
                                                </span>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/user/documents/${document.id}/download" 
                                                   class="btn btn-sm btn-outline-primary">
                                                    <i class="bi bi-download"></i> Download
                                                </a>
                                                <a href="${pageContext.request.contextPath}/user/documents/${document.id}" 
                                                   class="btn btn-sm btn-outline-secondary">
                                                    <i class="bi bi-eye"></i> View
                                                </a>
                                                <c:if test="${document.status == 'PENDING'}">
                                                    <button class="btn btn-sm btn-outline-danger" 
                                                            onclick="deleteDocument(${document.id})">
                                                        <i class="bi bi-trash"></i> Delete
                                                    </button>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <nav aria-label="Document pagination" class="mt-4">
                            <ul class="pagination justify-content-center">
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${currentPage - 1}">Previous</a>
                                </li>
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link" href="?page=${i}">${i}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${currentPage + 1}">Next</a>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Upload Modal -->
    <div class="modal fade" id="uploadModal" tabindex="-1" aria-labelledby="uploadModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="uploadModalLabel">Upload New Document</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="uploadForm" action="${pageContext.request.contextPath}/user/documents/upload" 
                          method="post" enctype="multipart/form-data">
                        <div class="mb-3">
                            <label for="documentType" class="form-label">Document Type</label>
                            <select class="form-select" id="documentType" name="type" required>
                                <option value="RECEIPT">Receipt</option>
                                <option value="INVOICE">Invoice</option>
                                <option value="CERTIFICATE">Certificate</option>
                                <option value="OTHER">Other</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="documentFile" class="form-label">Select File</label>
                            <input class="form-control" type="file" id="documentFile" name="file" required>
                        </div>
                        <div class="mb-3">
                            <label for="description" class="form-label">Description</label>
                            <textarea class="form-control" id="description" name="description" rows="3"></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" form="uploadForm" class="btn btn-primary">Upload</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function deleteDocument(documentId) {
            if (confirm('Are you sure you want to delete this document?')) {
                fetch('${pageContext.request.contextPath}/user/documents/' + documentId, {
                    method: 'DELETE'
                })
                .then(response => {
                    if (response.ok) {
                        window.location.reload();
                    } else {
                        alert('Failed to delete document');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('An error occurred while deleting the document');
                });
            }
        }
    </script>
</body>
</html> 