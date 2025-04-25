<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.ZoneId" %>
<%@ page import="java.util.Date" %>
<%
    for (com.accounting.model.Queue item : (java.util.List<com.accounting.model.Queue>) request.getAttribute("queueItems")) {
        LocalDateTime createdAt = item.getCreatedAt();
        Date date = Date.from(createdAt.atZone(ZoneId.systemDefault()).toInstant());
        request.setAttribute("formattedCreatedAt_" + item.getId(), date);
        
        LocalDateTime processedAt = item.getProcessedAt();
        if (processedAt != null) {
            Date processedDate = Date.from(processedAt.atZone(ZoneId.systemDefault()).toInstant());
            request.setAttribute("formattedProcessedAt_" + item.getId(), processedDate);
        }
    }
%>

<div class="queue-management">
    <div class="content-header">
        <h1>Queue Management</h1>
        <div class="header-actions">
            <button class="btn btn-primary" onclick="addToQueue()">
                <i class="fas fa-plus"></i> Add to Queue
            </button>
            <button class="btn btn-success" onclick="exportQueue()">
                <i class="fas fa-file-export"></i> Export
            </button>
        </div>
    </div>

    <div class="error-message" id="errorMessage"></div>
    <div class="success-message" id="successMessage"></div>

    <div class="queue-filters">
        <input type="text" id="searchQueue" placeholder="Search queue items..." class="form-control">
        <select id="statusFilter" class="form-control">
            <option value="">All Status</option>
            <option value="PENDING">Pending</option>
            <option value="PROCESSING">Processing</option>
            <option value="COMPLETED">Completed</option>
        </select>
        <select id="priorityFilter" class="form-control">
            <option value="">All Priorities</option>
            <option value="HIGH">High</option>
            <option value="MEDIUM">Medium</option>
            <option value="LOW">Low</option>
        </select>
        <button class="btn btn-primary" onclick="applyFilters()">
            <i class="fas fa-filter"></i> Apply Filters
        </button>
    </div>

    <div class="queue-actions">
        <button class="btn btn-warning" onclick="pauseQueue()">
            <i class="fas fa-pause"></i> Pause Queue
        </button>
        <button class="btn btn-success" onclick="resumeQueue()">
            <i class="fas fa-play"></i> Resume Queue
        </button>
        <button class="btn btn-danger" onclick="clearQueue()">
            <i class="fas fa-trash"></i> Clear Queue
        </button>
    </div>

    <table class="queue-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Queue Number</th>
                <th>Type</th>
                <th>Priority</th>
                <th>Status</th>
                <th>Position</th>
                <th>Created At</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${queueItems}" var="item">
                <tr>
                    <td>${item.id}</td>
                    <td>${item.queueNumber}</td>
                    <td>${item.type}</td>
                    <td>
                        <span class="priority-badge priority-${item.priority.toString().toLowerCase()}">
                            ${item.priority}
                        </span>
                    </td>
                    <td>
                        <span class="status-badge status-${item.status.toString().toLowerCase()}">
                            ${item.status}
                        </span>
                    </td>
                    <td>${item.position}</td>
                    <td><fmt:formatDate value="${formattedCreatedAt_[item.id]}" pattern="MMM dd, yyyy HH:mm"/></td>
                    <td>
                        <button class="btn btn-sm btn-info view-item" data-id="${item.id}">
                            <i class="fas fa-eye"></i>
                        </button>
                        <button class="btn btn-sm btn-warning edit-item" data-id="${item.id}">
                            <i class="fas fa-edit"></i>
                        </button>
                        <button class="btn btn-sm btn-danger remove-item" data-id="${item.id}">
                            <i class="fas fa-trash"></i>
                        </button>
                        <c:if test="${item.status == 'PENDING'}">
                            <button class="btn btn-sm btn-success start-processing" onclick="startProcessing(${item.id})" title="Start Processing">
                                <i class="fas fa-play"></i>
                            </button>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <!-- Pagination -->
    <div class="pagination">
        <button class="btn btn-secondary prev-page" data-page="${currentPage - 1}">
            <i class="fas fa-chevron-left"></i> Previous
        </button>
        <span>Page ${currentPage} of ${totalPages}</span>
        <button class="btn btn-secondary next-page" data-page="${currentPage + 1}">
            Next <i class="fas fa-chevron-right"></i>
        </button>
    </div>
</div>

<!-- Add/Edit Queue Item Modal -->
<div class="modal fade" id="queueItemModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">Add Queue Item</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="queueItemForm">
                    <input type="hidden" id="itemId">
                    <div class="mb-3">
                        <label for="itemName" class="form-label">Item Name</label>
                        <input type="text" class="form-control" id="itemName" required>
                    </div>
                    <div class="mb-3">
                        <label for="itemPriority" class="form-label">Priority</label>
                        <select class="form-control" id="itemPriority" required>
                            <option value="HIGH">High</option>
                            <option value="MEDIUM">Medium</option>
                            <option value="LOW">Low</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="itemDescription" class="form-label">Description</label>
                        <textarea class="form-control" id="itemDescription" rows="3"></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" onclick="saveQueueItem()">Save</button>
            </div>
        </div>
    </div>
</div>

<!-- View Queue Item Modal -->
<div class="modal fade" id="viewItemModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Queue Item Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <h6>Item Name</h6>
                    <p id="viewItemName"></p>
                </div>
                <div class="mb-3">
                    <h6>Priority</h6>
                    <p id="viewItemPriority"></p>
                </div>
                <div class="mb-3">
                    <h6>Status</h6>
                    <p id="viewItemStatus"></p>
                </div>
                <div class="mb-3">
                    <h6>Description</h6>
                    <p id="viewItemDescription"></p>
                </div>
                <div class="mb-3">
                    <h6>Added By</h6>
                    <p id="viewItemAddedBy"></p>
                </div>
                <div class="mb-3">
                    <h6>Added Date</h6>
                    <p id="viewItemAddedDate"></p>
                </div>
                <div class="mb-3">
                    <h6>Processed Date</h6>
                    <p id="viewItemProcessedDate"></p>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<script>
    // Move all the JavaScript functions here
    function showMessage(message, isError = false) {
        const messageDiv = document.getElementById(isError ? 'errorMessage' : 'successMessage');
        messageDiv.textContent = message;
        messageDiv.style.display = 'block';
        setTimeout(() => {
            messageDiv.style.display = 'none';
        }, 5000);
    }

    function addToQueue() {
        document.getElementById('modalTitle').textContent = 'Add Queue Item';
        document.getElementById('itemId').value = '';
        document.getElementById('queueItemForm').reset();
        new bootstrap.Modal(document.getElementById('queueItemModal')).show();
    }

    function editItem(itemId) {
        document.getElementById('modalTitle').textContent = 'Edit Queue Item';
        document.getElementById('itemId').value = itemId;
        
        fetch(`/manager/queue/items/${itemId}`)
            .then(response => response.json())
            .then(item => {
                document.getElementById('itemName').value = item.name;
                document.getElementById('itemPriority').value = item.priority;
                document.getElementById('itemDescription').value = item.description;
                new bootstrap.Modal(document.getElementById('queueItemModal')).show();
            })
            .catch(error => {
                showMessage('Error loading item details', true);
            });
    }

    function removeItem(itemId) {
        if (confirm('Are you sure you want to remove this item from the queue?')) {
            fetch(`/manager/queue/items/${itemId}`, {
                method: 'DELETE'
            })
            .then(response => {
                if (response.ok) {
                    showMessage('Item removed successfully');
                    location.reload();
                } else {
                    throw new Error('Failed to remove item');
                }
            })
            .catch(error => {
                showMessage('Error removing item', true);
            });
        }
    }

    function viewItem(itemId) {
        fetch(`/manager/queue/items/${itemId}`)
            .then(response => response.json())
            .then(item => {
                document.getElementById('viewItemName').textContent = item.name;
                document.getElementById('viewItemPriority').textContent = item.priority;
                document.getElementById('viewItemStatus').textContent = item.status;
                document.getElementById('viewItemDescription').textContent = item.description;
                document.getElementById('viewItemAddedBy').textContent = item.addedBy;
                document.getElementById('viewItemAddedDate').textContent = item.createdAt;
                document.getElementById('viewItemProcessedDate').textContent = item.processedAt ? 
                    item.processedAt : 'Not processed yet';
                new bootstrap.Modal(document.getElementById('viewItemModal')).show();
            })
            .catch(error => {
                showMessage('Error loading item details', true);
            });
    }

    function saveQueueItem() {
        const formData = {
            id: document.getElementById('itemId').value,
            name: document.getElementById('itemName').value,
            priority: document.getElementById('itemPriority').value,
            description: document.getElementById('itemDescription').value
        };

        const url = formData.id ? `/manager/queue/items/${formData.id}` : '/manager/queue/items';
        const method = formData.id ? 'PUT' : 'POST';

        fetch(url, {
            method: method,
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(formData)
        })
        .then(response => {
            if (response.ok) {
                showMessage('Item saved successfully');
                bootstrap.Modal.getInstance(document.getElementById('queueItemModal')).hide();
                location.reload();
            } else {
                throw new Error('Failed to save item');
            }
        })
        .catch(error => {
            showMessage('Error saving item', true);
        });
    }

    function pauseQueue() {
        if (confirm('Are you sure you want to pause the queue?')) {
            fetch('/manager/queue/pause', {
                method: 'POST'
            })
            .then(response => {
                if (response.ok) {
                    showMessage('Queue paused successfully');
                    location.reload();
                } else {
                    throw new Error('Failed to pause queue');
                }
            })
            .catch(error => {
                showMessage('Error pausing queue', true);
            });
        }
    }

    function resumeQueue() {
        fetch('/manager/queue/resume', {
            method: 'POST'
        })
        .then(response => {
            if (response.ok) {
                showMessage('Queue resumed successfully');
                location.reload();
            } else {
                throw new Error('Failed to resume queue');
            }
        })
        .catch(error => {
            showMessage('Error resuming queue', true);
        });
    }

    function clearQueue() {
        if (confirm('Are you sure you want to clear the queue? This action cannot be undone.')) {
            fetch('/manager/queue/clear', {
                method: 'POST'
            })
            .then(response => {
                if (response.ok) {
                    showMessage('Queue cleared successfully');
                    location.reload();
                } else {
                    throw new Error('Failed to clear queue');
                }
            })
            .catch(error => {
                showMessage('Error clearing queue', true);
            });
        }
    }

    function startProcessing(itemId) {
        if (confirm('Are you sure you want to start processing this queue item?')) {
            $.ajax({
                url: '${pageContext.request.contextPath}/manager/queue/start/' + itemId,
                type: 'POST',
                success: function(response) {
                    if (response.success) {
                        showMessage('Processing started successfully');
                        refreshQueueTable();
                    } else {
                        showMessage(response.message || 'Failed to start processing', true);
                    }
                },
                error: function() {
                    showMessage('An error occurred while starting the process', true);
                }
            });
        }
    }

    function applyFilters() {
        const search = document.getElementById('searchQueue').value;
        const status = document.getElementById('statusFilter').value;
        const priority = document.getElementById('priorityFilter').value;
        
        const params = new URLSearchParams();
        if (search) params.append('search', search);
        if (status) params.append('status', status);
        if (priority) params.append('priority', priority);
        
        window.location.href = `/manager/queue?${params.toString()}`;
    }

    function changePage(page) {
        const params = new URLSearchParams(window.location.search);
        params.set('page', page);
        window.location.href = `/manager/queue?${params.toString()}`;
    }

    function exportQueue() {
        const params = new URLSearchParams(window.location.search);
        window.location.href = `/manager/queue/export?${params.toString()}`;
    }

    // Add event listeners after the content is loaded
    document.addEventListener('DOMContentLoaded', function() {
        // View item buttons
        document.querySelectorAll('.view-item').forEach(button => {
            button.addEventListener('click', function() {
                viewItem(this.dataset.id);
            });
        });

        // Edit item buttons
        document.querySelectorAll('.edit-item').forEach(button => {
            button.addEventListener('click', function() {
                editItem(this.dataset.id);
            });
        });

        // Remove item buttons
        document.querySelectorAll('.remove-item').forEach(button => {
            button.addEventListener('click', function() {
                removeItem(this.dataset.id);
            });
        });

        // Pagination buttons
        document.querySelectorAll('.prev-page, .next-page').forEach(button => {
            button.addEventListener('click', function() {
                changePage(this.dataset.page);
            });
        });
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/manager_dashboard.js"></script>
</body>
</html> 