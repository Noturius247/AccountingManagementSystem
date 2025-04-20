<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document Management - Manager Dashboard</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/main.css" rel="stylesheet">
    
    <style>
        .document-card {
            transition: all 0.3s ease;
        }
        .document-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .status-badge {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 12px;
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
        .action-buttons .btn {
            padding: 5px 10px;
            font-size: 12px;
        }
        .document-preview {
            max-height: 200px;
            object-fit: contain;
        }
        .stat-card {
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            background: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .stat-card h3 {
            font-size: 14px;
            color: #666;
            margin-bottom: 10px;
        }
        .stat-card .value {
            font-size: 24px;
            font-weight: bold;
            color: #333;
        }
    </style>
</head>
<body>
    <%@ include file="../includes/manager-header.jsp" %>

    <div class="container-fluid">
        <div class="row">
            <main class="col-md-12 ms-sm-auto px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Document Management</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2">
                            <button type="button" class="btn btn-success" id="bulkApproveBtn" disabled>
                                <i class="bi bi-check-circle"></i> Approve Selected
                            </button>
                            <button type="button" class="btn btn-danger" id="bulkRejectBtn" disabled>
                                <i class="bi bi-x-circle"></i> Reject Selected
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Statistics Cards -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="stat-card">
                            <h3>Total Documents</h3>
                            <div class="value">${statistics.totalDocuments}</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card">
                            <h3>Pending Review</h3>
                            <div class="value">${statistics.pendingDocuments}</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card">
                            <h3>Approved</h3>
                            <div class="value">${statistics.approvedDocuments}</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card">
                            <h3>Rejected</h3>
                            <div class="value">${statistics.rejectedDocuments}</div>
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

                <!-- Documents Grid -->
                <div class="row" id="documentsGrid">
                    <c:forEach items="${documents.content}" var="document">
                        <div class="col-md-4 mb-4">
                            <div class="card document-card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <h5 class="card-title mb-0">${document.fileName}</h5>
                                        <span class="status-badge status-${fn:toLowerCase(document.status)}">
                                            ${document.status}
                                        </span>
                                    </div>
                                    <div class="mb-3">
                                        <p class="text-muted mb-1">
                                            <i class="bi bi-person"></i> ${document.userUsername}
                                        </p>
                                        <p class="text-muted mb-1">
                                            <i class="bi bi-calendar"></i> 
                                            <fmt:formatDate value="${document.uploadedAt}" pattern="MMM dd, yyyy HH:mm"/>
                                        </p>
                                        <p class="text-muted mb-1">
                                            <i class="bi bi-file-earmark-text"></i> ${document.type}
                                        </p>
                                    </div>
                                    <div class="action-buttons d-flex justify-content-between">
                                        <button type="button" class="btn btn-primary btn-sm" 
                                                onclick="viewDocument('${document.id}')">
                                            <i class="bi bi-eye"></i> View
                                        </button>
                                        <button type="button" class="btn btn-success btn-sm" 
                                                onclick="approveDocument('${document.id}')"
                                                ${document.status == 'APPROVED' ? 'disabled' : ''}>
                                            <i class="bi bi-check-circle"></i> Approve
                                        </button>
                                        <button type="button" class="btn btn-danger btn-sm" 
                                                onclick="rejectDocument('${document.id}')"
                                                ${document.status == 'REJECTED' ? 'disabled' : ''}>
                                            <i class="bi bi-x-circle"></i> Reject
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </main>
        </div>
    </div>

    <!-- Document View Modal -->
    <div class="modal fade" id="viewModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Document Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h6>Document Information</h6>
                            <table class="table table-sm">
                                <tr>
                                    <th>File Name:</th>
                                    <td id="viewFileName"></td>
                                </tr>
                                <tr>
                                    <th>Type:</th>
                                    <td id="viewType"></td>
                                </tr>
                                <tr>
                                    <th>Uploaded By:</th>
                                    <td id="viewUser"></td>
                                </tr>
                                <tr>
                                    <th>Upload Date:</th>
                                    <td id="viewUploadDate"></td>
                                </tr>
                                <tr>
                                    <th>Status:</th>
                                    <td id="viewStatus"></td>
                                </tr>
                            </table>
                        </div>
                        <div class="col-md-6">
                            <h6>Preview</h6>
                            <div id="documentPreview" class="text-center">
                                <img id="previewImage" class="img-fluid document-preview">
                                <div id="previewPlaceholder" class="p-5 border rounded">
                                    <i class="bi bi-file-earmark-text display-1"></i>
                                    <p class="mt-2">Preview not available</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <a href="#" class="btn btn-primary" id="downloadButton">Download</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Reject Document Modal -->
    <div class="modal fade" id="rejectModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Reject Document</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="rejectForm">
                        <input type="hidden" id="rejectDocumentId">
                        <div class="mb-3">
                            <label for="rejectReason" class="form-label">Reason for Rejection</label>
                            <textarea class="form-control" id="rejectReason" rows="3"></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" id="confirmReject">Reject Document</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Document selection
        const selectedDocuments = new Set();
        const bulkApproveBtn = document.getElementById('bulkApproveBtn');
        const bulkRejectBtn = document.getElementById('bulkRejectBtn');

        function toggleDocumentSelection(documentId) {
            if (selectedDocuments.has(documentId)) {
                selectedDocuments.delete(documentId);
            } else {
                selectedDocuments.add(documentId);
            }
            updateBulkButtons();
        }

        function updateBulkButtons() {
            const hasSelected = selectedDocuments.size > 0;
            bulkApproveBtn.disabled = !hasSelected;
            bulkRejectBtn.disabled = !hasSelected;
        }

        // Document actions
        function viewDocument(id) {
            fetch(`${pageContext.request.contextPath}/manager/documents/${id}`)
                .then(response => response.json())
                .then(data => {
                    document.getElementById('viewFileName').textContent = data.fileName;
                    document.getElementById('viewType').textContent = data.type;
                    document.getElementById('viewUser').textContent = data.userUsername;
                    document.getElementById('viewUploadDate').textContent = new Date(data.uploadedAt).toLocaleString();
                    document.getElementById('viewStatus').textContent = data.status;
                    document.getElementById('downloadButton').href = `${pageContext.request.contextPath}/manager/documents/${id}/download`;
                    
                    // Show preview if it's an image
                    const previewImage = document.getElementById('previewImage');
                    const previewPlaceholder = document.getElementById('previewPlaceholder');
                    if (data.contentType.startsWith('image/')) {
                        previewImage.src = `data:${data.contentType};base64,${data.content}`;
                        previewImage.classList.remove('d-none');
                        previewPlaceholder.classList.add('d-none');
                    } else {
                        previewImage.classList.add('d-none');
                        previewPlaceholder.classList.remove('d-none');
                    }
                    
                    new bootstrap.Modal(document.getElementById('viewModal')).show();
                });
        }

        function approveDocument(id) {
            fetch(`${pageContext.request.contextPath}/manager/documents/${id}/approve`, {
                method: 'POST'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    alert('Failed to approve document');
                }
            });
        }

        function rejectDocument(id) {
            document.getElementById('rejectDocumentId').value = id;
            new bootstrap.Modal(document.getElementById('rejectModal')).show();
        }

        document.getElementById('confirmReject').addEventListener('click', function() {
            const id = document.getElementById('rejectDocumentId').value;
            const reason = document.getElementById('rejectReason').value;
            
            fetch(`${pageContext.request.contextPath}/manager/documents/${id}/reject`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ reason: reason })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    alert('Failed to reject document');
                }
            });
        });

        // Bulk actions
        bulkApproveBtn.addEventListener('click', function() {
            if (confirm('Are you sure you want to approve the selected documents?')) {
                fetch(`${pageContext.request.contextPath}/manager/documents/bulk-approve`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(Array.from(selectedDocuments))
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        location.reload();
                    } else {
                        alert('Failed to approve documents');
                    }
                });
            }
        });

        bulkRejectBtn.addEventListener('click', function() {
            if (confirm('Are you sure you want to reject the selected documents?')) {
                fetch(`${pageContext.request.contextPath}/manager/documents/bulk-reject`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(Array.from(selectedDocuments))
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        location.reload();
                    } else {
                        alert('Failed to reject documents');
                    }
                });
            }
        });

        // Filter form submission
        document.getElementById('filterForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const formData = new FormData(this);
            const params = new URLSearchParams(formData);
            
            fetch(`${pageContext.request.contextPath}/manager/documents?${params.toString()}`)
                .then(response => response.text())
                .then(html => {
                    document.getElementById('documentsGrid').innerHTML = html;
                });
        });
    </script>
</body>
</html> 