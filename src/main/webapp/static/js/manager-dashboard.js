// Get the application context path from meta tag
const contextPath = document.querySelector('meta[name="contextPath"]')?.getAttribute('content') || '';

document.addEventListener('DOMContentLoaded', function() {
    // Handle dynamic content loading for manager dashboard
    const dashboardLink = document.querySelector('a[href*="/manager/dashboard"]');
    if (dashboardLink) {
        dashboardLink.addEventListener('click', function(e) {
            // If we're already on the dashboard page, just prevent the default action
            if (window.location.pathname.includes('/manager/dashboard')) {
                e.preventDefault();
                return;
            }
            // Otherwise, let the normal navigation happen
        });
    }

    // Add event listener for transaction links in header and sidebar
    document.addEventListener('click', function(e) {
        const transactionLink = e.target.closest('a[href*="/manager/transactions"], button[onclick*="viewAllTransactions"]');
        if (transactionLink) {
            e.preventDefault();
            viewAllTransactions();
        }
    });

    // Initialize transactions if we're on the transactions page
    if (window.location.pathname.includes('/manager/transactions')) {
        initializeTransactionComponents();
    }

    // Initialize tooltips
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
});

function loadManagerDashboardContent() {
    const mainContent = document.getElementById('main-content');
    if (!mainContent) return;

    // Show loading indicator
    mainContent.innerHTML = '<div class="text-center"><div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div></div>';

    // Fetch manager dashboard content with AJAX header
    fetch('/manager/dashboard', {
        headers: {
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
        .then(response => response.text())
        .then(html => {
            // Create a temporary container to parse the HTML
            const temp = document.createElement('div');
            temp.innerHTML = html;
            
            // Extract only the dashboard content, excluding the header
            const dashboardContent = temp.querySelector('#dashboard-content');
            if (dashboardContent) {
                // Update only the dashboard content section
                const existingDashboardContent = document.querySelector('#dashboard-content');
                if (existingDashboardContent) {
                    existingDashboardContent.innerHTML = dashboardContent.innerHTML;
                    
                    // Reinitialize any necessary JavaScript components
                    initializeManagerDashboardComponents();
                    
                    // Update the page title
                    document.title = 'Manager Dashboard - Accounting Management System';
                }
            }
        })
        .catch(error => {
            console.error('Error loading manager dashboard:', error);
            mainContent.innerHTML = '<div class="alert alert-danger">Failed to load manager dashboard content. Please try again.</div>';
        });
}

function initializeManagerDashboardComponents() {
    // Reinitialize any necessary components after loading
    // For example, charts, tooltips, etc.
    if (typeof Chart !== 'undefined') {
        // Reinitialize charts if they exist
        const charts = document.querySelectorAll('canvas');
        charts.forEach(canvas => {
            const chart = Chart.getChart(canvas);
            if (chart) {
                chart.update();
            }
        });
    }

    // Reinitialize tooltips
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });

    // Initialize manager-specific components
    initializeManagerCharts();
    initializeManagerTables();
}

function initializeManagerCharts() {
    // Manager-specific chart initialization
    const managerCharts = document.querySelectorAll('.manager-chart');
    managerCharts.forEach(chartElement => {
        const chartType = chartElement.dataset.chartType;
        const chartData = JSON.parse(chartElement.dataset.chartData);
        
        new Chart(chartElement, {
            type: chartType,
            data: chartData,
            options: {
                responsive: true,
                maintainAspectRatio: false
            }
        });
    });
}

function initializeManagerTables() {
    // Manager-specific table initialization
    const managerTables = document.querySelectorAll('.manager-table');
    managerTables.forEach(table => {
        if (typeof $.fn.DataTable !== 'undefined') {
            $(table).DataTable({
                responsive: true,
                pageLength: 10,
                order: [[0, 'desc']]
            });
        }
    });
}

// Notification handling
function toggleNotifications() {
    const panel = document.getElementById('notificationPanel');
    panel.classList.toggle('active');
}

function markAsRead(notificationId) {
    fetch(`${contextPath}/api/notifications/${notificationId}/read`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            [window.dashboardData.csrfHeader]: window.dashboardData.csrfToken
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            const notification = document.querySelector(`[data-notification-id="${notificationId}"]`);
            if (notification) {
                notification.classList.remove('unread');
                updateUnreadCount();
            }
        }
    })
    .catch(error => console.error('Error marking notification as read:', error));
}

function markAllAsRead() {
    fetch(`${contextPath}/api/notifications/mark-all-read`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            [window.dashboardData.csrfHeader]: window.dashboardData.csrfToken
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            document.querySelectorAll('.notification-item.unread').forEach(item => {
                item.classList.remove('unread');
            });
            updateUnreadCount();
        }
    })
    .catch(error => console.error('Error marking all notifications as read:', error));
}

function updateUnreadCount() {
    const unreadCount = document.querySelectorAll('.notification-item.unread').length;
    const countElement = document.getElementById('notificationCount');
    if (countElement) {
        countElement.textContent = unreadCount;
        countElement.style.display = unreadCount > 0 ? 'block' : 'none';
    }
}

// Initialize charts when the document is ready
document.addEventListener('DOMContentLoaded', function() {
    // Revenue Chart
    const revenueCtx = document.getElementById('revenueChart')?.getContext('2d');
    if (revenueCtx) {
        new Chart(revenueCtx, {
            type: 'line',
            data: {
                labels: window.dashboardData.revenueLabels || [],
                datasets: [{
                    label: 'Revenue',
                    data: window.dashboardData.revenueData || [],
                    borderColor: '#3498db',
                    tension: 0.4,
                    fill: false
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return '$' + value.toLocaleString();
                            }
                        }
                    }
                }
            }
        });
    }

    // Activity Chart
    const activityCtx = document.getElementById('activityChart')?.getContext('2d');
    if (activityCtx) {
        new Chart(activityCtx, {
            type: 'bar',
            data: {
                labels: window.dashboardData.departmentLabels || [],
                datasets: [{
                    label: 'Activity Score',
                    data: window.dashboardData.departmentData || [],
                    backgroundColor: '#2ecc71'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 100
                    }
                }
            }
        });
    }
});

function viewAllTransactions() {
    const mainContent = document.getElementById('main-content');
    if (!mainContent) return;

    // Show loading indicator
    mainContent.innerHTML = `
        <div class="d-flex justify-content-center align-items-center" style="min-height: 400px;">
            <div class="text-center">
                <div class="spinner-border text-maroon mb-3" role="status" style="width: 3rem; height: 3rem;">
                    <span class="visually-hidden">Loading...</span>
                </div>
                <p class="text-muted">Loading Transactions...</p>
            </div>
        </div>
    `;

    // Fetch transactions content
    fetch(`${contextPath}/manager/transactions`, {
        headers: {
            'X-Requested-With': 'XMLHttpRequest',
            'Accept': 'text/html'
        }
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.text();
    })
    .then(html => {
        // Create a temporary container
        const temp = document.createElement('div');
        temp.innerHTML = html;

        // Find the transaction content in the response
        const newContent = temp.querySelector('#transaction-content');
        if (newContent) {
            mainContent.innerHTML = `
                <div id="transaction-content">
                    ${newContent.innerHTML}
                </div>
            `;
        } else {
            throw new Error('Could not find transaction content in response');
        }
        
        // Initialize transaction-specific components
        initializeTransactionComponents();
        
        // Update browser URL without page reload
        const title = 'Transactions - Manager Dashboard';
        window.history.pushState({}, title, `${contextPath}/manager/transactions`);
        document.title = title;

        // Update transaction statistics
        updateTransactionStatistics();
    })
    .catch(error => {
        console.error('Error loading transactions:', error);
        mainContent.innerHTML = `
            <div class="alert alert-danger mx-3 mt-3">
                <i class="fas fa-exclamation-circle me-2"></i>
                Failed to load transactions. Please try again.
            </div>
        `;
    });
}

function updateTransactionStatistics() {
    fetch(`${contextPath}/manager/transaction-statistics`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(data => {
        // Update statistics in the UI
        document.getElementById('total-transactions').textContent = data.totalTransactions || 0;
        document.getElementById('pending-transactions').textContent = data.pendingTransactions || 0;
        document.getElementById('completed-transactions').textContent = data.completedTransactions || 0;
        document.getElementById('failed-transactions').textContent = data.failedTransactions || 0;
    })
    .catch(error => {
        console.error('Error updating transaction statistics:', error);
        showAlert('error', 'Failed to update transaction statistics');
    });
}

function initializeTransactionComponents() {
    // Initialize datepickers, filters, etc.
    const filterForm = document.getElementById('filterForm');
    if (filterForm) {
        filterForm.addEventListener('submit', function(e) {
            e.preventDefault();
            applyFilters();
        });
    }

    // Fetch initial queue data
    fetchQueueDetails();
    
    // Initialize processing times
    initializeProcessingTimes();
}

function applyFilters() {
    const startDate = document.getElementById('startDate').value;
    const endDate = document.getElementById('endDate').value;
    const amountRange = document.getElementById('amountRange').value;
    
    let url = `${contextPath}/manager/transactions?`;
    if (startDate) url += `&startDate=${startDate}`;
    if (endDate) url += `&endDate=${endDate}`;
    if (amountRange) url += `&amountRange=${amountRange}`;
    
    loadTransactions(url);
}

function resetFilters() {
    document.getElementById('filterForm').reset();
    loadTransactions(`${contextPath}/manager/transactions`);
}

function loadTransactions(url) {
    const mainContent = document.getElementById('main-content');
    if (!mainContent) return;

    // Show loading indicator
    mainContent.innerHTML = `
        <div class="d-flex justify-content-center align-items-center" style="min-height: 400px;">
            <div class="text-center">
                <div class="spinner-border text-maroon mb-3" role="status" style="width: 3rem; height: 3rem;">
                    <span class="visually-hidden">Loading...</span>
                </div>
                <p class="text-muted">Loading Transactions...</p>
            </div>
        </div>
    `;

    // Fetch transactions content
    fetch(url, {
        headers: {
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
    .then(response => response.text())
    .then(html => {
        const parser = new DOMParser();
        const doc = parser.parseFromString(html, 'text/html');
        const transactionContent = doc.getElementById('transaction-content');
        
        if (transactionContent) {
            const currentContent = document.getElementById('transaction-content');
            if (currentContent) {
                currentContent.innerHTML = transactionContent.innerHTML;
            } else {
                mainContent.innerHTML = transactionContent.outerHTML;
            }
            
            // Initialize components after content update
            initializeTransactionComponents();
            
            // Update transaction statistics
            updateTransactionStatistics();
        } else {
            showAlert('error', 'Failed to load transaction content');
        }
    })
    .catch(error => {
        console.error('Error loading transactions:', error);
        showAlert('error', 'Failed to load transactions. Please try again.');
    });
}

function filterByStatus(status) {
    const baseUrl = `${contextPath}/manager/transactions`;
    const url = status ? `${baseUrl}?status=${status}` : baseUrl;
    loadTransactions(url);
}

function showAlert(type, message) {
    const alertDiv = document.createElement('div');
    alertDiv.className = `alert alert-${type} alert-dismissible fade show`;
    alertDiv.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    `;
    const container = document.querySelector('.container-fluid');
    if (container) {
        container.insertBefore(alertDiv, container.firstChild);
        setTimeout(() => alertDiv.remove(), 5000);
    }
}

// Queue Management Functions
function updateQueueStatus(queueId, status) {
    if (status === 'PROCESSING') {
        // Check if there's already a processing queue
        const processingQueues = document.querySelectorAll('.status-processing');
        if (processingQueues.length > 0) {
            showAlert('warning', 'Another queue is already being processed. Please complete or cancel it first.');
            return;
        }
    }

    if (confirm('Are you sure you want to update the queue status to ' + status + '?')) {
        const csrfHeader = document.querySelector("meta[name='_csrf_header']").content;
        const csrfToken = document.querySelector("meta[name='_csrf']").content;
        
        fetch(`${contextPath}/manager/transactions/queue/${queueId}/status`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                [csrfHeader]: csrfToken
            },
            body: JSON.stringify({ status: status })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // If status was changed to PROCESSING, disable all other "Start Processing" buttons
                if (status === 'PROCESSING') {
                    document.querySelectorAll('.start-processing').forEach(button => {
                        button.disabled = true;
                    });
                }
                // If status was changed from PROCESSING, enable all "Start Processing" buttons
                else if (status === 'COMPLETED' || status === 'CANCELLED') {
                    document.querySelectorAll('.start-processing').forEach(button => {
                        button.disabled = false;
                    });
                }
                fetchQueueDetails();
                showAlert('success', data.message);
            } else {
                showAlert('error', data.error || 'Failed to update queue status');
            }
        })
        .catch(error => {
            console.error('Error updating queue status:', error);
            showAlert('error', 'Failed to update queue status');
        });
    }
}

function fetchQueueDetails(params = {}) {
    const queryString = new URLSearchParams(params).toString();
    fetch(`${contextPath}/manager/transactions/queue?${queryString}`)
        .then(response => response.json())
        .then(data => {
            updateQueueTable(data.queues);
            if (document.getElementById('currentPosition')) {
                document.getElementById('currentPosition').textContent = data.currentPosition;
            }
            if (document.getElementById('totalQueues')) {
                document.getElementById('totalQueues').textContent = data.totalQueues;
            }
        })
        .catch(error => {
            console.error('Error fetching queue details:', error);
            showAlert('error', 'Failed to fetch queue details');
        });
}

function updateQueueTable(queues) {
    // Update Processing Table
    const processingTbody = document.querySelector('#processingTable tbody');
    if (processingTbody) {
        processingTbody.innerHTML = '';
        // Filter only PROCESSING queues
        queues.filter(queue => queue.status === 'PROCESSING').forEach(queue => {
            const tr = document.createElement('tr');
            tr.innerHTML = `
                <td>${queue.queueNumber}</td>
                <td>${queue.studentId || 'N/A'}</td>
                <td>${queue.user ? queue.user.username : 'N/A'}</td>
                <td>${queue.type || 'N/A'}</td>
                <td>${formatCurrency(queue.amount)}</td>
                <td>
                    <span class="processing-time" data-start="${queue.processedAt}">
                        Calculating...
                    </span>
                </td>
                <td>
                    <div class="btn-group">
                        <button class="btn btn-sm btn-success" onclick="updateQueueStatus('${queue.id}', 'COMPLETED')">
                            <i class="bi bi-check-circle"></i> Complete
                        </button>
                        <button class="btn btn-sm btn-danger" onclick="updateQueueStatus('${queue.id}', 'CANCELLED')">
                            <i class="bi bi-x-circle"></i> Cancel
                        </button>
                    </div>
                </td>
            `;
            processingTbody.appendChild(tr);
        });
    }

    // Update Queue Table (only PENDING items)
    const queueTbody = document.querySelector('#queueTableBody');
    if (queueTbody) {
        queueTbody.innerHTML = '';
        // Filter only PENDING queues
        queues.filter(queue => queue.status === 'PENDING').forEach(queue => {
            const tr = document.createElement('tr');
            tr.innerHTML = `
                <td>${queue.queueNumber}</td>
                <td>${queue.studentId || 'N/A'}</td>
                <td>${queue.position}</td>
                <td>${queue.estimatedWaitTime} mins</td>
                <td>
                    <span class="badge queue-status status-pending">
                        ${queue.status}
                    </span>
                </td>
                <td>
                    <div class="btn-group">
                        <button class="btn btn-sm btn-primary start-processing" 
                                onclick="updateQueueStatus('${queue.id}', 'PROCESSING')"
                                ${hasProcessingQueue(queues) ? 'disabled' : ''}>
                            <i class="bi bi-play-fill"></i> Start Processing
                        </button>
                    </div>
                </td>
            `;
            queueTbody.appendChild(tr);
        });
    }
    
    // Initialize processing times for new items
    initializeProcessingTimes();
}

// Helper function to check if there's any processing queue
function hasProcessingQueue(queues) {
    return queues.some(queue => queue.status === 'PROCESSING');
}

function formatCurrency(amount) {
    return new Intl.NumberFormat('en-PH', {
        style: 'currency',
        currency: 'PHP'
    }).format(amount || 0);
}

function searchQueue() {
    const queueNumber = document.getElementById('queueSearch').value;
    fetchQueueDetails({ queueNumber: queueNumber });
}

function filterByQueueStatus(status) {
    fetchQueueDetails({ status: status });
}

function initializeProcessingTimes() {
    const processingTimes = document.querySelectorAll('.processing-time');
    processingTimes.forEach(timeSpan => {
        const startTime = new Date(timeSpan.dataset.start);
        
        // Update the time every second
        const updateTime = () => {
            const now = new Date();
            const diff = now - startTime;
            const minutes = Math.floor(diff / 60000);
            const seconds = Math.floor((diff % 60000) / 1000);
            timeSpan.textContent = `${minutes}m ${seconds}s`;
        };
        
        updateTime(); // Initial update
        setInterval(updateTime, 1000); // Update every second
    });
}

// Add auto-refresh for queue data
setInterval(fetchQueueDetails, 30000); // Refresh every 30 seconds 