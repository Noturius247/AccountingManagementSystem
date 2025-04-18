// Main JavaScript file for the application

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