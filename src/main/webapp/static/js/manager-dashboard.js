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