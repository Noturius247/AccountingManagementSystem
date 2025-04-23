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