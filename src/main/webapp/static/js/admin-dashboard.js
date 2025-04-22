// Admin Dashboard JavaScript file

document.addEventListener('DOMContentLoaded', function() {
    // Handle dynamic content loading for admin dashboard
    const adminDashboardLink = document.querySelector('a[href*="/admin/dashboard"]');
    if (adminDashboardLink) {
        adminDashboardLink.addEventListener('click', function(e) {
            // If we're already on the admin dashboard page, just prevent the default action
            if (window.location.pathname.includes('/admin/dashboard')) {
                e.preventDefault();
                return;
            }
            // Otherwise, let the normal navigation happen
        });
    }
});

function loadAdminDashboardContent() {
    const mainContent = document.getElementById('main-content');
    if (!mainContent) return;

    // Show loading indicator
    mainContent.innerHTML = '<div class="text-center"><div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div></div>';

    // Fetch admin dashboard content with AJAX header
    fetch('/admin/dashboard', {
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
                    initializeAdminDashboardComponents();
                    
                    // Update the page title
                    document.title = 'Admin Dashboard - Accounting Management System';
                }
            }
        })
        .catch(error => {
            console.error('Error loading admin dashboard:', error);
            mainContent.innerHTML = '<div class="alert alert-danger">Failed to load admin dashboard content. Please try again.</div>';
        });
}

function initializeAdminDashboardComponents() {
    // Reinitialize any necessary components after loading
    // For example, charts, tooltips, etc.
    if (typeof Chart !== 'undefined') {
        // Reinitialize charts if they exist
        const adminCharts = document.querySelectorAll('.admin-chart');
        adminCharts.forEach(canvas => {
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

    // Initialize admin-specific components
    initializeAdminCharts();
    initializeAdminTables();
}

function initializeAdminCharts() {
    // Admin-specific chart initialization
    const adminCharts = document.querySelectorAll('.admin-chart');
    adminCharts.forEach(chartElement => {
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

function initializeAdminTables() {
    // Admin-specific table initialization
    const adminTables = document.querySelectorAll('.admin-table');
    adminTables.forEach(table => {
        if (typeof $.fn.DataTable !== 'undefined') {
            $(table).DataTable({
                responsive: true,
                pageLength: 10,
                order: [[0, 'desc']]
            });
        }
    });
} 