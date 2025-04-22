document.addEventListener('DOMContentLoaded', function() {
    // Handle dynamic content loading for dashboard
    const dashboardLink = document.querySelector('a[href*="/accounting/user/dashboard"]');
    if (dashboardLink) {
        dashboardLink.addEventListener('click', function(e) {
            // If we're already on the dashboard page, just prevent the default action
            if (window.location.pathname.includes('/accounting/user/dashboard')) {
                e.preventDefault();
                return;
            }
            // Otherwise, let the normal navigation happen
        });
    }
});

function loadUserDashboardContent() {
    console.log('Loading user dashboard content...');
    const mainContent = document.getElementById('main-content');
    if (!mainContent) {
        console.error('Main content container not found');
        return;
    }

    // Show loading indicator
    mainContent.innerHTML = '<div class="text-center"><div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div></div>';

    fetch('/accounting/user/dashboard/data', {
        headers: {
            'X-Requested-With': 'XMLHttpRequest',
            'Accept': 'application/json'
        }
    })
    .then(response => {
        if (!response.ok) {
            return response.json().then(data => {
                throw new Error(data.error || `HTTP error! status: ${response.status}`);
            });
        }
        return response.json();
    })
    .then(data => {
        if (data.error) {
            throw new Error(data.error);
        }
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
            <div class="row mt-4">
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Current Balance</h5>
                        </div>
                        <div class="card-body">
                            <h3 class="text-primary">$${data.currentBalance || 0}</h3>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Queue Status</h5>
                        </div>
                        <div class="card-body">
                            <p>Position: <span class="badge bg-primary" id="queuePosition">${data.queuePosition || 0}</span></p>
                            <p>Estimated Wait Time: <span class="badge bg-info" id="estimatedWaitTime">${data.estimatedWaitTime || 0} min</span></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    `;
    
    // Update the main content
    mainContent.innerHTML = dashboardHTML;
    
    // Update queue status section
    updateQueueStatusSection(data);
    
    // Initialize components
    initializeDashboardComponents();
    
    // Update page title
    document.title = 'User Dashboard - Accounting Management System';
    console.log('Dashboard content updated successfully');
}

function updateQueueStatusSection(data) {
    const queueStatusSection = document.getElementById('queueStatusSection');
    const queueNumber = document.getElementById('queueNumber');
    const queuePosition = document.getElementById('queuePosition');
    const estimatedWaitTime = document.getElementById('estimatedWaitTime');
    
    if (data.queueNumber && data.queueNumber.length > 0) {
        // Show queue status section
        queueStatusSection.style.display = 'block';
        
        // Update queue number, position and wait time
        queueNumber.textContent = data.queueNumber;
        queuePosition.textContent = `Position: ${data.position}`;
        estimatedWaitTime.textContent = `Estimated Wait: ${data.estimatedWaitTime} min`;
        
        // Add flashing effect
        queueStatusSection.classList.add('flashing');
        
        // Remove flashing effect after 2 seconds
        setTimeout(() => {
            queueStatusSection.classList.remove('flashing');
        }, 2000);
    } else {
        // Hide queue status section if not in queue
        queueStatusSection.style.display = 'none';
    }
}

// Add CSS for flashing effect
const style = document.createElement('style');
style.textContent = `
    @keyframes flash {
        0% { background-color: #0d6efd; }
        50% { background-color: #0dcaf0; }
        100% { background-color: #0d6efd; }
    }
    
    .flashing {
        animation: flash 1s ease-in-out;
    }
`;
document.head.appendChild(style);

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

// Initialize dashboard when the page loads
document.addEventListener('DOMContentLoaded', function() {
    loadUserDashboardContent();
    
    // Set up periodic refresh (every 30 seconds)
    setInterval(loadUserDashboardContent, 30000);
}); 