// Main JavaScript file for the user application

document.addEventListener('DOMContentLoaded', function() {
    // Initialize tooltips
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });

    // Initialize popovers
    var popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'));
    var popoverList = popoverTriggerList.map(function (popoverTriggerEl) {
        return new bootstrap.Popover(popoverTriggerEl);
    });

    // Load initial dashboard content if we're on the user page
    if (window.location.pathname.includes('/user')) {
        loadUserDashboardContent();
    }

    // Handle dynamic navigation
    document.querySelectorAll('a[data-dynamic]').forEach(function(link) {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const url = this.getAttribute('href');
            loadUserContent(url);
        });
    });

    // Handle notification dismissals
    document.querySelectorAll('.alert-dismissible .btn-close').forEach(function(button) {
        button.addEventListener('click', function() {
            this.closest('.alert').remove();
        });
    });

    // Auto-hide alerts after 5 seconds
    document.querySelectorAll('.alert:not(.alert-dismissible)').forEach(function(alert) {
        setTimeout(function() {
            alert.remove();
        }, 5000);
    });
});

function loadUserDashboardContent() {
    const mainContent = document.getElementById('main-content');
    if (!mainContent) {
        console.error('Main content container not found');
        return;
    }

    // Show loading indicator
    mainContent.innerHTML = '<div class="text-center"><div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div></div>';

    // Fetch dashboard content with AJAX header
    console.log('Initiating fetch request to http://localhost:8080/accounting/user/dashboard...');
    fetch('http://localhost:8080/accounting/user/dashboard', {
        headers: {
            'X-Requested-With': 'XMLHttpRequest',
            'Accept': 'application/json'
        }
    })
    .then(response => {
        console.log('Received response:', response.status, response.statusText);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
    })
    .then(data => {
        console.log('Received JSON data:', data);
        updateDashboardContent(data);
    })
    .catch(error => {
        console.error('Error loading dashboard:', error);
        mainContent.innerHTML = `
            <div class="alert alert-danger">
                <h4 class="alert-heading">Failed to load dashboard</h4>
                <p>${error.message}</p>
                <button onclick="loadUserDashboardContent()" class="btn btn-primary mt-2">Retry</button>
            </div>
        `;
    });
}

function loadUserContent(url) {
    if (url === '/accounting/user/dashboard') {
        loadUserDashboardContent();
    } else {
        // Handle other user content loading
        console.log('Loading user content:', url);
    }
}

function updateDashboardContent(data) {
    console.log('Updating dashboard content with data:', data);
    const mainContent = document.getElementById('main-content');
    
    // Create the dashboard content HTML
    const dashboardHTML = `
        <div id="dashboard-content">
            <div class="row">
                <div class="col-md-3">
                    <div class="stat-card">
                        <h5>Total Transactions</h5>
                        <h3>${data.totalTransactions || 0}</h3>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <h5>Total Payments</h5>
                        <h3>${data.totalPayments || 0}</h3>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <h5>Total Documents</h5>
                        <h3>${data.totalDocuments || 0}</h3>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <h5>Active Queues</h5>
                        <h3>${data.activeQueues || 0}</h3>
                    </div>
                </div>
            </div>
        </div>
    `;
    
    // Update the main content
    mainContent.innerHTML = dashboardHTML;
    
    // Initialize components
    initializeDashboardComponents();
    
    // Update page title
    document.title = 'User Dashboard - Accounting Management System';
    console.log('Dashboard content updated successfully');
}

function initializeDashboardComponents() {
    console.log('Starting dashboard components initialization...');
    // Reinitialize any necessary components after loading
    if (typeof Chart !== 'undefined') {
        console.log('Reinitializing charts...');
        const charts = document.querySelectorAll('canvas');
        charts.forEach(canvas => {
            const chart = Chart.getChart(canvas);
            if (chart) {
                chart.update();
            }
        });
    }

    // Reinitialize tooltips
    console.log('Reinitializing tooltips...');
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
    console.log('Dashboard components initialized successfully');
}

function initializeUserBootstrapComponents() {
    // Reinitialize tooltips
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });

    // Reinitialize popovers
    var popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'));
    popoverTriggerList.map(function (popoverTriggerEl) {
        return new bootstrap.Popover(popoverTriggerEl);
    });
}

function showUserErrorMessage(message) {
    const alertDiv = document.createElement('div');
    alertDiv.className = 'alert alert-danger alert-dismissible fade show';
    alertDiv.setAttribute('role', 'alert');
    alertDiv.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    `;
    document.querySelector('.container-fluid').insertBefore(alertDiv, document.querySelector('.container-fluid').firstChild);
} 