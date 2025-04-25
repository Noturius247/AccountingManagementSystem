// Manager Dashboard JavaScript

document.addEventListener('DOMContentLoaded', function() {
    // Initialize based on current route
    const currentPath = window.location.pathname;
    
    // Common initialization for all manager pages
    initializeCommonComponents();
    
    // Route-specific initialization
    if (currentPath.includes('/manager/dashboard')) {
        initializeManagerDashboard();
    } else if (currentPath.includes('/manager/transactions')) {
        initializeTransactions();
    } else if (currentPath.includes('/manager/documents')) {
        initializeDocuments();
    } else if (currentPath.includes('/manager/reports')) {
        initializeReports();
    } else if (currentPath.includes('/manager/queue')) {
        initializeQueue();
    } else if (currentPath.includes('/manager/settings')) {
        initializeSettings();
    } else if (currentPath.includes('/manager/users')) {
        initializeUsers();
    } else if (currentPath.includes('/manager/payments')) {
        initializePayments();
    }
});

// Common Components
function initializeCommonComponents() {
    // Initialize tooltips
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });

    // Initialize popovers
    const popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'));
    popoverTriggerList.map(function (popoverTriggerEl) {
        return new bootstrap.Popover(popoverTriggerEl);
    });

    // Common utility functions
    window.utils = {
        showLoading: function() {
            const overlay = document.createElement('div');
            overlay.id = 'loadingOverlay';
            overlay.style.cssText = 'position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(255,255,255,0.8); display: flex; justify-content: center; align-items: center; z-index: 9999;';
            overlay.innerHTML = '<div class="spinner-border text-primary" role="status"><span class="sr-only">Loading...</span></div>';
            document.body.appendChild(overlay);
        },
        
        hideLoading: function() {
            const overlay = document.getElementById('loadingOverlay');
            if (overlay) {
                overlay.remove();
            }
        },
        
        showSuccess: function(message) {
            const toast = document.createElement('div');
            toast.className = 'alert alert-success alert-dismissible fade show position-fixed';
            toast.style.cssText = 'top: 20px; right: 20px; z-index: 9999;';
            toast.innerHTML = `
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            `;
            document.body.appendChild(toast);
            setTimeout(() => toast.remove(), 3000);
        },
        
        showError: function(message) {
            const toast = document.createElement('div');
            toast.className = 'alert alert-danger alert-dismissible fade show position-fixed';
            toast.style.cssText = 'top: 20px; right: 20px; z-index: 9999;';
            toast.innerHTML = `
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            `;
            document.body.appendChild(toast);
            setTimeout(() => toast.remove(), 5000);
        }
    };
}

// Loading state management
const loadingState = {
    timeouts: {},
    showLoading: function(elementId) {
        const element = document.getElementById(elementId);
        if (element) {
            element.classList.add('loading');
            // Set a timeout to show error if loading takes too long
            this.timeouts[elementId] = setTimeout(() => {
                this.showError(elementId, 'Loading timeout. Please refresh the page.');
            }, 30000); // 30 seconds timeout
        }
    },
    hideLoading: function(elementId) {
        const element = document.getElementById(elementId);
        if (element) {
            element.classList.remove('loading');
            // Clear timeout if it exists
            if (this.timeouts[elementId]) {
                clearTimeout(this.timeouts[elementId]);
                delete this.timeouts[elementId];
            }
        }
    },
    showError: function(elementId, message) {
        const element = document.getElementById(elementId);
        if (element) {
            element.classList.remove('loading');
            element.innerHTML = `
                <div class="alert alert-danger">
                    <h4 class="alert-heading">Error</h4>
                    <p>${message}</p>
                    <button class="btn btn-outline-danger btn-sm mt-2" onclick="location.reload()">
                        <i class="bi bi-arrow-clockwise"></i> Refresh Page
                    </button>
                </div>
            `;
        }
    }
};

// Dashboard Page
function initializeManagerDashboard() {
    try {
        // Initialize charts if they exist
        if (typeof Chart !== 'undefined') {
            initializeManagerCharts();
        }

        // Initialize real-time updates
        initializeRealTimeUpdates();

        // Initialize dashboard actions
        initializeManagerActions();

        // Show success message if present
        const successMessage = document.getElementById('successMessage');
        if (successMessage && successMessage.textContent.trim()) {
            setTimeout(() => {
                successMessage.style.display = 'none';
            }, 5000);
        }

        // Show error message if present
        const errorMessage = document.getElementById('errorMessage');
        if (errorMessage && errorMessage.textContent.trim()) {
            const closeButton = document.createElement('button');
            closeButton.className = 'btn-close';
            closeButton.onclick = () => errorMessage.style.display = 'none';
            errorMessage.appendChild(closeButton);
        }
    } catch (error) {
        console.error('Error initializing manager dashboard:', error);
        loadingState.showError('main-content', 'Failed to initialize dashboard. Please refresh the page.');
    }
}

// Real-time updates
function initializeRealTimeUpdates() {
    const updateInterval = 30000; // 30 seconds
    let updateTimer;

    function updateDashboardStats() {
        fetch('/manager/dashboard/stats', {
            headers: {
                'X-Requested-With': 'XMLHttpRequest'
            }
        })
        .then(response => {
            if (!response.ok) throw new Error('Network response was not ok');
            return response.json();
        })
        .then(data => {
            // Update statistics
            Object.keys(data).forEach(key => {
                const element = document.querySelector(`[data-stat="${key}"]`);
                if (element) {
                    element.textContent = data[key];
                    element.classList.add('updated');
                    setTimeout(() => element.classList.remove('updated'), 1000);
                }
            });
        })
        .catch(error => {
            console.error('Error updating dashboard stats:', error);
            // Don't show error UI for background updates
        });
    }

    // Start periodic updates
    updateTimer = setInterval(updateDashboardStats, updateInterval);

    // Cleanup on page leave
    window.addEventListener('beforeunload', () => {
        if (updateTimer) clearInterval(updateTimer);
    });
}

// Chart initialization
function initializeManagerCharts() {
    const charts = {};
    const chartElements = document.querySelectorAll('.manager-chart');
    
    chartElements.forEach(element => {
        try {
            const chartType = element.dataset.chartType;
            const chartData = JSON.parse(element.dataset.chartData);
            
            charts[element.id] = new Chart(element, {
                type: chartType,
                data: chartData,
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    animation: {
                        duration: 1000
                    },
                    plugins: {
                        legend: {
                            position: 'bottom'
                        },
                        tooltip: {
                            mode: 'index',
                            intersect: false
                        }
                    }
                }
            });
        } catch (error) {
            console.error(`Error initializing chart ${element.id}:`, error);
            element.insertAdjacentHTML('afterend', 
                '<div class="alert alert-warning">Failed to load chart</div>'
            );
        }
    });

    return charts;
}

// Manager actions initialization
function initializeManagerActions() {
    // Handle report generation
    document.querySelectorAll('.generate-report-btn').forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            const reportType = this.dataset.reportType;
            generateReport(reportType);
        });
    });

    // Handle approval actions
    document.querySelectorAll('.approval-action').forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            const actionType = this.dataset.action;
            const itemId = this.dataset.id;
            handleApprovalAction(actionType, itemId);
        });
    });
}

function generateReport(reportType) {
    console.log(`Generating ${reportType} report...`);
    // Show loading spinner
    const reportSection = document.querySelector(`#${reportType}-report-section`);
    if (reportSection) {
        reportSection.innerHTML = '<div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div>';
        
        // Simulate API call for report generation
        setTimeout(() => {
            reportSection.innerHTML = '<div class="alert alert-success">Report generated successfully! <a href="#" class="alert-link">Download</a></div>';
        }, 1500);
    }
}

function handleApprovalAction(actionType, itemId) {
    console.log(`Performing ${actionType} action on item ${itemId}`);
    
    // Show confirmation modal
    const confirmModal = new bootstrap.Modal(document.getElementById('confirmActionModal'));
    document.getElementById('confirmActionBtn').setAttribute('data-action', actionType);
    document.getElementById('confirmActionBtn').setAttribute('data-id', itemId);
    
    const actionText = actionType === 'approve' ? 'approve' : 'reject';
    document.getElementById('confirmActionText').textContent = `Are you sure you want to ${actionText} this item?`;
    
    confirmModal.show();
    
    // Add event listener for confirmation
    document.getElementById('confirmActionBtn').addEventListener('click', function() {
        const action = this.getAttribute('data-action');
        const id = this.getAttribute('data-id');
        
        // Simulate API call
        fetch(`/api/manager/approvals/${id}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: JSON.stringify({ action: action })
        })
        .then(response => response.json())
        .then(data => {
            confirmModal.hide();
            if (data.success) {
                // Remove the item from the list
                document.querySelector(`tr[data-id="${id}"]`).remove();
                
                // Show success message
                const alertDiv = document.createElement('div');
                alertDiv.className = 'alert alert-success alert-dismissible fade show';
                alertDiv.setAttribute('role', 'alert');
                alertDiv.innerHTML = `
                    Item ${action}d successfully!
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                `;
                document.querySelector('.container-fluid').insertBefore(alertDiv, document.querySelector('.container-fluid').firstChild);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            confirmModal.hide();
            
            // Show error message
            const alertDiv = document.createElement('div');
            alertDiv.className = 'alert alert-danger alert-dismissible fade show';
            alertDiv.setAttribute('role', 'alert');
            alertDiv.innerHTML = `
                Failed to process the request. Please try again.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            `;
            document.querySelector('.container-fluid').insertBefore(alertDiv, document.querySelector('.container-fluid').firstChild);
        });
    }, { once: true });
}

// Transactions Page
function initializeTransactions() {
    // Initialize transaction filters
    const filterForm = document.getElementById('filterForm');
    if (filterForm) {
        filterForm.addEventListener('submit', function(e) {
            e.preventDefault();
            applyTransactionFilters();
        });
    }

    // Initialize bulk actions
    const bulkActionButtons = document.querySelectorAll('.bulk-action-btn');
    bulkActionButtons.forEach(button => {
        button.addEventListener('click', function() {
            const action = this.dataset.action;
            handleBulkAction(action);
        });
    });

    // Update statistics
    updateTransactionStatistics();
}

// Documents Page
function initializeDocuments() {
    // Initialize document upload
    const uploadForm = document.getElementById('documentUploadForm');
    if (uploadForm) {
        uploadForm.addEventListener('submit', handleDocumentUpload);
    }

    // Initialize document filters
    const filterForm = document.getElementById('filterForm');
    if (filterForm) {
        filterForm.addEventListener('submit', function(e) {
            e.preventDefault();
            applyDocumentFilters();
        });
    }

    // Initialize document preview
    initializeDocumentPreviews();
}

// Reports Page
function initializeReports() {
    // Initialize report generation
    const reportForm = document.getElementById('reportFilters');
    if (reportForm) {
        reportForm.addEventListener('submit', function(e) {
            e.preventDefault();
            generateReport();
        });
    }

    // Initialize date range picker if present
    initializeDateRangePicker();
}

// Queue Page
function initializeQueue() {
    const queueStatusFilter = document.getElementById('queueStatusFilter');
    if (queueStatusFilter) {
        queueStatusFilter.innerHTML = `
            <option value="">All Statuses</option>
            <option value="PENDING">Pending</option>
            <option value="PROCESSING">Processing</option>
            <option value="COMPLETED">Completed</option>
            <option value="CANCELLED">Cancelled</option>
        `;
    }

    // Update queue status badges
    const queueStatuses = document.querySelectorAll('.queue-status');
    queueStatuses.forEach(status => {
        const statusText = status.textContent.trim();
        status.classList.remove('status-pending', 'status-processed', 'status-failed', 'status-refunded');
        switch(statusText) {
            case 'PENDING':
                status.classList.add('status-pending');
                break;
            case 'PROCESSING':
                status.classList.add('status-processing');
                break;
            case 'COMPLETED':
                status.classList.add('status-completed');
                break;
            case 'CANCELLED':
                status.classList.add('status-cancelled');
                break;
        }
    });

    // Initialize queue actions
    const queueActions = document.querySelectorAll('.queue-action');
    queueActions.forEach(action => {
        action.addEventListener('click', function() {
            const actionType = this.dataset.action;
            const itemId = this.dataset.id;
            handleQueueAction(actionType, itemId);
        });
    });

    // Initialize queue filters
    const filterForm = document.getElementById('filterForm');
    if (filterForm) {
        filterForm.addEventListener('submit', function(e) {
            e.preventDefault();
            applyQueueFilters();
        });
    }
}

// Settings Page
function initializeSettings() {
    // Initialize settings form
    const settingsForm = document.getElementById('systemConfigForm');
    if (settingsForm) {
        settingsForm.addEventListener('submit', function(e) {
            e.preventDefault();
            saveSettings();
        });
    }

    // Initialize integration settings
    initializeIntegrationSettings();
}

// Users Page
function initializeUsers() {
    // Initialize user filters
    const filterForm = document.getElementById('filterForm');
    if (filterForm) {
        filterForm.addEventListener('submit', function(e) {
            e.preventDefault();
            applyUserFilters();
        });
    }

    // Initialize bulk actions
    const bulkActionButtons = document.querySelectorAll('.bulk-action-btn');
    bulkActionButtons.forEach(button => {
        button.addEventListener('click', function() {
            const action = this.dataset.action;
            handleUserBulkAction(action);
        });
    });
}

// Payments Page
function initializePayments() {
    // Initialize payment filters
    const filterForm = document.getElementById('filterForm');
    if (filterForm) {
        filterForm.addEventListener('submit', function(e) {
            e.preventDefault();
            applyPaymentFilters();
        });
    }

    // Initialize payment actions
    const paymentActions = document.querySelectorAll('.payment-action');
    paymentActions.forEach(action => {
        action.addEventListener('click', function() {
            const actionType = this.dataset.action;
            const paymentId = this.dataset.id;
            handlePaymentAction(actionType, paymentId);
        });
    });

    // Update payment statistics
    updatePaymentStatistics();
}

// Export functions for use in HTML
window.managerDashboard = {
    loadingState,
    initializeManagerDashboard,
    generateReport: function(type) {
        loadingState.showLoading('report-section');
        fetch(`/manager/reports/generate/${type}`, {
            method: 'POST',
            headers: {
                'X-CSRF-TOKEN': window.dashboardData.csrfToken,
                'Content-Type': 'application/json'
            }
        })
        .then(response => {
            if (!response.ok) throw new Error('Failed to generate report');
            return response.blob();
        })
        .then(blob => {
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = `${type}_report.pdf`;
            document.body.appendChild(a);
            a.click();
            window.URL.revokeObjectURL(url);
            loadingState.hideLoading('report-section');
        })
        .catch(error => {
            console.error('Error generating report:', error);
            loadingState.showError('report-section', 'Failed to generate report. Please try again.');
        });
    },
    handleApprovalAction: function(action, id) {
        const section = `approval-${id}`;
        loadingState.showLoading(section);
        fetch(`/manager/approvals/${action}/${id}`, {
            method: 'POST',
            headers: {
                'X-CSRF-TOKEN': window.dashboardData.csrfToken
            }
        })
        .then(response => {
            if (!response.ok) throw new Error('Failed to process approval');
            return response.json();
        })
        .then(data => {
            loadingState.hideLoading(section);
            location.reload();
        })
        .catch(error => {
            console.error('Error handling approval:', error);
            loadingState.showError(section, 'Failed to process approval. Please try again.');
        });
    }
};

function updateQueueStatus(queueId, newStatus) {
    const validStatuses = ['PENDING', 'PROCESSING', 'COMPLETED', 'CANCELLED'];
    if (!validStatuses.includes(newStatus)) {
        utils.showError('Invalid queue status');
        return;
    }

    fetch(`/manager/queue/${queueId}/status`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]').content
        },
        body: JSON.stringify({ status: newStatus })
    })
    .then(response => {
        if (!response.ok) throw new Error('Failed to update queue status');
        return response.json();
    })
    .then(data => {
        utils.showSuccess('Queue status updated successfully');
        // Refresh queue table or update specific row
        refreshQueueTable();
    })
    .catch(error => {
        utils.showError('Error updating queue status: ' + error.message);
    });
}
