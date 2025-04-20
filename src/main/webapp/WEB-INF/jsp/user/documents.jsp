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
    <%@ include file="../includes/user-header.jsp" %>

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
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Documents</h5>
                        <div class="d-flex gap-2">
                            <div class="input-group" style="width: 300px;">
                                <input type="text" class="form-control" id="searchInput" placeholder="Search documents...">
                                <button class="btn btn-outline-secondary" type="button" id="searchButton">
                                    <i class="bi bi-search"></i>
                                </button>
                            </div>
                            <div class="btn-group">
                                <button type="button" class="btn btn-outline-primary" id="exportButton">
                                    <i class="bi bi-download"></i> Export
                                </button>
                                <button type="button" class="btn btn-outline-danger" id="bulkDeleteButton" disabled>
                                    <i class="bi bi-trash"></i> Delete Selected
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" id="selectAll">
                                            </div>
                                        </th>
                                        <th>
                                            <a href="#" class="text-decoration-none" data-sort="fileName">
                                                File Name <i class="bi bi-arrow-down-up"></i>
                                            </a>
                                        </th>
                                        <th>
                                            <a href="#" class="text-decoration-none" data-sort="type">
                                                Type <i class="bi bi-arrow-down-up"></i>
                                            </a>
                                        </th>
                                        <th>
                                            <a href="#" class="text-decoration-none" data-sort="size">
                                                Size <i class="bi bi-arrow-down-up"></i>
                                            </a>
                                        </th>
                                        <th>
                                            <a href="#" class="text-decoration-none" data-sort="status">
                                                Status <i class="bi bi-arrow-down-up"></i>
                                            </a>
                                        </th>
                                        <th>
                                            <a href="#" class="text-decoration-none" data-sort="uploadedAt">
                                                Upload Date <i class="bi bi-arrow-down-up"></i>
                                            </a>
                                        </th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="documentsTableBody">
                                    <c:forEach items="${documents}" var="document">
                                        <tr>
                                            <td>
                                                <div class="form-check">
                                                    <input class="form-check-input document-checkbox" type="checkbox" 
                                                           value="${document.id}">
                                                </div>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <i class="bi bi-file-earmark-text me-2"></i>
                                                    <span>${document.fileName}</span>
                                                </div>
                                            </td>
                                            <td>${document.type}</td>
                                            <td>${document.size}</td>
                                            <td>
                                                <span class="badge bg-${document.status == 'ACTIVE' ? 'success' : 'warning'}">
                                                    ${document.status}
                                                </span>
                                            </td>
                                            <td>${document.uploadedAt}</td>
                                            <td>
                                                <div class="btn-group">
                                                    <button type="button" class="btn btn-sm btn-outline-primary" 
                                                            onclick="viewDocument(${document.id})">
                                                        <i class="bi bi-eye"></i>
                                                    </button>
                                                    <button type="button" class="btn btn-sm btn-outline-success"
                                                            onclick="window.location.href='${pageContext.request.contextPath}/user/documents/${document.id}/download'">
                                                        <i class="bi bi-download"></i>
                                                    </button>
                                                    <button type="button" class="btn btn-sm btn-outline-danger"
                                                            onclick="deleteDocument(${document.id})">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        <div class="d-flex justify-content-between align-items-center mt-3">
                            <div class="text-muted">
                                Showing <span id="showingCount">0</span> of <span id="totalCount">0</span> documents
                            </div>
                            <nav>
                                <ul class="pagination mb-0">
                                    <li class="page-item disabled">
                                        <a class="page-link" href="#" tabindex="-1">Previous</a>
                                    </li>
                                    <li class="page-item active"><a class="page-link" href="#">1</a></li>
                                    <li class="page-item"><a class="page-link" href="#">2</a></li>
                                    <li class="page-item"><a class="page-link" href="#">3</a></li>
                                    <li class="page-item">
                                        <a class="page-link" href="#">Next</a>
                                </li>
                            </ul>
                        </nav>
                        </div>
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
                    <form id="uploadForm" enctype="multipart/form-data">
                        <div class="mb-3">
                            <label for="documentFile" class="form-label">Select File</label>
                            <input type="file" class="form-control" id="documentFile" name="file" required>
                            <div class="form-text">Maximum file size: 10MB</div>
                        </div>
                        <div class="mb-3">
                            <label for="documentType" class="form-label">Document Type</label>
                            <select class="form-select" id="documentType" name="type" required>
                                <option value="">Select type</option>
                                <option value="RECEIPT">Receipt</option>
                                <option value="INVOICE">Invoice</option>
                                <option value="CERTIFICATE">Certificate</option>
                                <option value="OTHER">Other</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="documentDescription" class="form-label">Description</label>
                            <textarea class="form-control" id="documentDescription" name="description" rows="3"></textarea>
                        </div>
                        <div class="progress mb-3 d-none" id="uploadProgress">
                            <div class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" style="width: 0%"></div>
                        </div>
                        <div id="uploadError" class="alert alert-danger d-none"></div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="uploadButton">Upload</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Document View Modal -->
    <div class="modal fade" id="viewModal" tabindex="-1" aria-labelledby="viewModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="viewModalLabel">Document Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
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
                                    <th>Size:</th>
                                    <td id="viewSize"></td>
                                </tr>
                                <tr>
                                    <th>Status:</th>
                                    <td id="viewStatus"></td>
                                </tr>
                                <tr>
                                    <th>Upload Date:</th>
                                    <td id="viewUploadDate"></td>
                                </tr>
                            </table>
                        </div>
                        <div class="col-md-6">
                            <h6>Description</h6>
                            <p id="viewDescription"></p>
                        </div>
                    </div>
                    <div class="mt-3">
                        <h6>Preview</h6>
                        <div id="documentPreview" class="text-center">
                            <img id="previewImage" class="img-fluid" style="max-height: 400px;">
                            <div id="previewPlaceholder" class="p-5 border rounded">
                                <i class="bi bi-file-earmark-text display-1"></i>
                                <p class="mt-2">Preview not available</p>
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

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteModalLabel">Confirm Delete</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete this document? This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" id="confirmDelete">Delete</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Add JavaScript for functionality -->
    <script>
        // Upload functionality
        document.getElementById('uploadButton').addEventListener('click', function() {
            const form = document.getElementById('uploadForm');
            const formData = new FormData(form);
            const progressBar = document.getElementById('uploadProgress');
            const errorDiv = document.getElementById('uploadError');
            
            progressBar.classList.remove('d-none');
            errorDiv.classList.add('d-none');
            
            fetch('${pageContext.request.contextPath}/user/documents/upload', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    errorDiv.textContent = data.message;
                    errorDiv.classList.remove('d-none');
                }
            })
            .catch(error => {
                errorDiv.textContent = 'An error occurred during upload.';
                errorDiv.classList.remove('d-none');
            })
            .finally(() => {
                progressBar.classList.add('d-none');
            });
        });

        // View document functionality
        function viewDocument(id) {
            fetch(`\${pageContext.request.contextPath}/user/documents/\${id}`)
                .then(response => response.json())
                .then(data => {
                    document.getElementById('viewFileName').textContent = data.fileName;
                    document.getElementById('viewType').textContent = data.type;
                    document.getElementById('viewSize').textContent = formatFileSize(data.size);
                    document.getElementById('viewStatus').textContent = data.status;
                    document.getElementById('viewUploadDate').textContent = new Date(data.uploadedAt).toLocaleString();
                    document.getElementById('viewDescription').textContent = data.description || 'No description';
                    document.getElementById('downloadButton').href = `\${pageContext.request.contextPath}/user/documents/\${id}/download`;
                    
                    // Show preview if it's an image
                    const previewImage = document.getElementById('previewImage');
                    const previewPlaceholder = document.getElementById('previewPlaceholder');
                    if (data.contentType.startsWith('image/')) {
                        previewImage.src = `data:\${data.contentType};base64,\${data.content}`;
                        previewImage.classList.remove('d-none');
                        previewPlaceholder.classList.add('d-none');
                    } else {
                        previewImage.classList.add('d-none');
                        previewPlaceholder.classList.remove('d-none');
                    }
                    
                    new bootstrap.Modal(document.getElementById('viewModal')).show();
                });
        }

        // Delete functionality
        let documentToDelete = null;
        
        function deleteDocument(id) {
            documentToDelete = id;
            new bootstrap.Modal(document.getElementById('deleteModal')).show();
        }
        
        document.getElementById('confirmDelete').addEventListener('click', function() {
            if (documentToDelete) {
                fetch(`\${pageContext.request.contextPath}/user/documents/\${documentToDelete}`, {
                    method: 'DELETE'
                })
                .then(response => {
                    if (response.ok) {
                        location.reload();
                    } else {
                        alert('Failed to delete document');
                    }
                });
            }
        });

        // Helper function to format file size
        function formatFileSize(bytes) {
            if (bytes === 0) return '0 Bytes';
            const k = 1024;
            const sizes = ['Bytes', 'KB', 'MB', 'GB'];
            const i = Math.floor(Math.log(bytes) / Math.log(k));
            return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
        }

        // Search functionality
        const searchInput = document.getElementById('searchInput');
        const searchButton = document.getElementById('searchButton');
        const documentsTableBody = document.getElementById('documentsTableBody');
        const rows = documentsTableBody.getElementsByTagName('tr');

        function performSearch() {
            const searchTerm = searchInput.value.toLowerCase();
            let visibleCount = 0;

            Array.from(rows).forEach(row => {
                const text = row.textContent.toLowerCase();
                const isVisible = text.includes(searchTerm);
                row.style.display = isVisible ? '' : 'none';
                if (isVisible) visibleCount++;
            });

            document.getElementById('showingCount').textContent = visibleCount;
        }

        searchInput.addEventListener('input', performSearch);
        searchButton.addEventListener('click', performSearch);

        // Bulk selection
        const selectAll = document.getElementById('selectAll');
        const documentCheckboxes = document.getElementsByClassName('document-checkbox');
        const bulkDeleteButton = document.getElementById('bulkDeleteButton');

        selectAll.addEventListener('change', function() {
            Array.from(documentCheckboxes).forEach(checkbox => {
                checkbox.checked = this.checked;
            });
            updateBulkDeleteButton();
        });

        Array.from(documentCheckboxes).forEach(checkbox => {
            checkbox.addEventListener('change', updateBulkDeleteButton);
        });

        function updateBulkDeleteButton() {
            const checkedCount = Array.from(documentCheckboxes).filter(cb => cb.checked).length;
            bulkDeleteButton.disabled = checkedCount === 0;
        }

        // Sort functionality
        const sortLinks = document.querySelectorAll('th a[data-sort]');
        let currentSort = { column: null, direction: 'asc' };

        sortLinks.forEach(link => {
            link.addEventListener('click', function(e) {
                e.preventDefault();
                const column = this.dataset.sort;
                const direction = currentSort.column === column && currentSort.direction === 'asc' ? 'desc' : 'asc';
                
                // Update sort indicators
                sortLinks.forEach(l => l.querySelector('i').className = 'bi bi-arrow-down-up');
                this.querySelector('i').className = `bi bi-arrow-${direction == 'asc' ? 'up' : 'down'}`;
                
                currentSort = { column, direction };
                sortTable();
            });
        });

        function sortTable() {
            const rows = Array.from(documentsTableBody.getElementsByTagName('tr'));
            const columnIndex = Array.from(document.querySelectorAll('th a[data-sort]'))
                .findIndex(th => th.dataset.sort === currentSort.column);
            
            rows.sort((a, b) => {
                const aValue = a.cells[columnIndex + 1].textContent.trim();
                const bValue = b.cells[columnIndex + 1].textContent.trim();
                
                if (currentSort.column === 'size') {
                    return currentSort.direction === 'asc' 
                        ? parseFileSize(aValue) - parseFileSize(bValue)
                        : parseFileSize(bValue) - parseFileSize(aValue);
                } else if (currentSort.column === 'uploadedAt') {
                    return currentSort.direction === 'asc'
                        ? new Date(aValue) - new Date(bValue)
                        : new Date(bValue) - new Date(aValue);
                } else {
                    return currentSort.direction === 'asc'
                        ? aValue.localeCompare(bValue)
                        : bValue.localeCompare(aValue);
                }
            });

            rows.forEach(row => documentsTableBody.appendChild(row));
        }

        function parseFileSize(size) {
            const units = { 'B': 1, 'KB': 1024, 'MB': 1024 * 1024, 'GB': 1024 * 1024 * 1024 };
            const match = size.match(/^(\d+(?:\.\d+)?)\s*(B|KB|MB|GB)$/i);
            return match ? parseFloat(match[1]) * units[match[2].toUpperCase()] : 0;
        }

        // Export functionality
        document.getElementById('exportButton').addEventListener('click', function() {
            const rows = Array.from(documentsTableBody.getElementsByTagName('tr'))
                .filter(row => row.style.display !== 'none');
            
            const csv = [
                ['File Name', 'Type', 'Size', 'Status', 'Upload Date'],
                ...rows.map(row => [
                    row.cells[1].textContent.trim(),
                    row.cells[2].textContent.trim(),
                    row.cells[3].textContent.trim(),
                    row.cells[4].textContent.trim(),
                    row.cells[5].textContent.trim()
                ])
            ].map(row => row.join(',')).join('\n');

            const blob = new Blob([csv], { type: 'text/csv' });
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = 'documents.csv';
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            window.URL.revokeObjectURL(url);
        });

        // Bulk delete functionality
        document.getElementById('bulkDeleteButton').addEventListener('click', function() {
            const selectedIds = Array.from(documentCheckboxes)
                .filter(cb => cb.checked)
                .map(cb => cb.value);

            if (confirm(`Are you sure you want to delete ${selectedIds.length} selected documents?`)) {
                Promise.all(selectedIds.map(id => 
                    fetch(`\${pageContext.request.contextPath}/user/documents/\${id}`, {
                        method: 'DELETE'
                    })
                )).then(() => location.reload());
            }
        });

        // Initialize counts
        document.getElementById('showingCount').textContent = rows.length;
        document.getElementById('totalCount').textContent = rows.length;
    </script>

    <!-- Add Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 