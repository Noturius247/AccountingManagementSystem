// Manager Main JavaScript file for the application

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

    // Load initial manager dashboard content
    if (window.location.pathname.includes('/manager')) {
        loadManagerDashboardContent();
    }

    // Handle dynamic navigation for manager
    document.querySelectorAll('a[data-dynamic]').forEach(function(link) {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const url = this.getAttribute('href');
            loadManagerContent(url);
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

function loadManagerDashboardContent() {
    const mainContent = document.getElementById('main-content');
    if (mainContent && !mainContent.innerHTML.trim()) {
        loadManagerContent('/manager/dashboard');
    }
}

function loadManagerContent(url) {
    const mainContent = document.getElementById('main-content');
    
    if (mainContent) {
        mainContent.classList.add('loading');
        
        fetch(url)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.text();
            })
            .then(html => {
                mainContent.innerHTML = html;
                mainContent.classList.remove('loading');
                
                // Update active state in navigation
                document.querySelectorAll('.nav-link, .sidebar a').forEach(navLink => {
                    navLink.classList.remove('active');
                    if (navLink.getAttribute('href') === url) {
                        navLink.classList.add('active');
                    }
                });
                
                // Update browser history
                history.pushState(null, '', url);
                
                // Reinitialize Bootstrap components
                initializeManagerBootstrapComponents();
            })
            .catch(error => {
                console.error('Error:', error);
                mainContent.classList.remove('loading');
                showManagerErrorMessage('Failed to load content. Please try again.');
            });
    }
}

function initializeManagerBootstrapComponents() {
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

function showManagerErrorMessage(message) {
    const alertDiv = document.createElement('div');
    alertDiv.className = 'alert alert-danger alert-dismissible fade show';
    alertDiv.setAttribute('role', 'alert');
    alertDiv.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    `;
    document.querySelector('.container-fluid').insertBefore(alertDiv, document.querySelector('.container-fluid').firstChild);
} 