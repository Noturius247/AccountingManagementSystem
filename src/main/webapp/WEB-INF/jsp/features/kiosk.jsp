<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>School Payment Kiosk</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/static/css/main.css" rel="stylesheet" type="text/css">
    <style>
        .kiosk-header {
            background: white;
            border-radius: var(--border-radius-md);
            box-shadow: var(--shadow-sm);
            padding: var(--spacing-lg);
            margin-bottom: var(--spacing-lg);
            text-align: center;
        }

        .kiosk-header h1 {
            color: var(--primary-color);
            margin-bottom: var(--spacing-sm);
            font-size: 2em;
        }

        .kiosk-header p {
            color: var(--dark-color);
            margin-bottom: var(--spacing-md);
        }

        .search-box {
            display: flex;
            gap: var(--spacing-sm);
            max-width: 600px;
            margin: 0 auto;
        }

        .search-input {
            flex: 1;
            padding: var(--spacing-sm);
            border: 2px solid var(--border-color);
            border-radius: var(--border-radius-sm);
            font-size: var(--font-size-base);
            transition: var(--transition-base);
        }

        .search-input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(128, 0, 0, 0.25);
        }

        .kiosk-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: var(--spacing-md);
            padding: var(--spacing-md);
        }

        .kiosk-card {
            background: white;
            border-radius: var(--border-radius-md);
            padding: var(--spacing-lg);
            text-align: center;
            box-shadow: var(--shadow-sm);
            transition: var(--transition-base);
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }

        .kiosk-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-md);
        }

        .kiosk-card i {
            font-size: 2.5em;
            margin-bottom: var(--spacing-md);
            color: var(--primary-color);
            transition: var(--transition-base);
        }

        .kiosk-card:hover i {
            transform: scale(1.1);
            color: var(--secondary-color);
        }

        .kiosk-card h2 {
            color: var(--primary-color);
            font-size: 1.5em;
            margin-bottom: var(--spacing-sm);
        }

        .kiosk-card p {
            color: var(--dark-color);
            margin-bottom: var(--spacing-md);
        }

        .kiosk-footer {
            position: fixed;
            bottom: 0;
            left: 0;
            right: 0;
            background: var(--primary-color);
            padding: var(--spacing-md);
            box-shadow: 0 -2px 10px rgba(0,0,0,0.1);
        }

        .footer-content {
            display: flex;
            justify-content: space-around;
            align-items: center;
            max-width: 800px;
            margin: 0 auto;
        }

        .footer-link {
            display: flex;
            flex-direction: column;
            align-items: center;
            color: white;
            text-decoration: none;
            transition: var(--transition-base);
            padding: var(--spacing-sm);
        }

        .footer-link:hover {
            color: var(--secondary-color);
            transform: translateY(-3px);
        }

        .footer-link i {
            font-size: 1.5em;
            margin-bottom: var(--spacing-xs);
        }

        .footer-link span {
            font-size: 0.8em;
            font-weight: 500;
        }
    </style>
</head>
<body>
    <!-- Header with Search -->
    <div class="kiosk-header">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="mb-0">School Payment Kiosk</h1>
            <c:if test="${not empty pageContext.request.userPrincipal}">
                <a href="${pageContext.request.contextPath}/accounting/user/dashboard" class="btn btn-outline-primary">
                    <i class="bi bi-arrow-left me-1"></i> Return to Dashboard
                </a>
            </c:if>
        </div>
        <p>Select a service to proceed</p>
        <!-- Debug info - hidden in production -->
        <div style="display: none;" id="debugInfo">
            Context Path: ${pageContext.request.contextPath}
        </div>
        <div class="search-box">
            <input type="text" class="search-input" placeholder="Search payments...">
            <button class="btn btn-primary">
                <i class="bi bi-search"></i>
                Search
            </button>
        </div>
    </div>

    <div class="kiosk-container">
        <!-- First Semester Tuition -->
        <div class="kiosk-card" onclick="selectService('payment', 'tuition')">
            <i class="bi bi-mortarboard"></i>
            <h2>Tuition</h2>
            <p>Regular term tuition payment</p>
        </div>

        <!-- Library Access Fee -->
        <div class="kiosk-card" onclick="selectService('payment', 'library')">
            <i class="bi bi-book"></i>
            <h2>Library Access Fee</h2>
            <p>Semester library access</p>
        </div>

        <!-- Chemistry Lab Fee -->
        <div class="kiosk-card" onclick="selectService('payment', 'lab')">
            <i class="bi bi-eyedropper"></i>
            <h2>Chemistry Lab Fee</h2>
            <p>Laboratory equipment and materials</p>
        </div>

        <!-- Student ID Replacement -->
        <div class="kiosk-card" onclick="selectService('payment', 'id')">
            <i class="bi bi-person-badge"></i>
            <h2>Student ID Replacement</h2>
            <p>Lost ID replacement fee</p>
        </div>

        <!-- Graduation Fee -->
        <div class="kiosk-card" onclick="selectService('payment', 'graduation')">
            <i class="bi bi-award"></i>
            <h2>Graduation Fee</h2>
            <p>Graduation ceremony and documents</p>
        </div>

        <!-- Transcript Request -->
        <div class="kiosk-card" onclick="selectService('payment', 'transcript')">
            <i class="bi bi-file-text"></i>
            <h2>Transcript Request</h2>
            <p>Official transcript processing</p>
        </div>

        <!-- Queue Status -->
        <div class="kiosk-card" onclick="selectService('queue')">
            <i class="bi bi-people"></i>
            <h2>Queue Status</h2>
            <p>Check your queue number and waiting time</p>
        </div>

        <!-- Help -->
        <div class="kiosk-card" onclick="selectService('help')">
            <i class="bi bi-question-circle"></i>
            <h2>Help</h2>
            <p>Get assistance with your payment</p>
        </div>
    </div>

    <footer class="kiosk-footer">
        <div class="container">
            <div class="footer-content">
                <a href="${pageContext.request.contextPath}/kiosk" class="footer-link">
                    <i class="bi bi-house-door"></i>
                    <span>Home</span>
                </a>
                <a href="${pageContext.request.contextPath}/kiosk/queue" class="footer-link">
                    <i class="bi bi-people"></i>
                    <span>Check Queue</span>
                </a>
                <a href="${pageContext.request.contextPath}/kiosk/help" class="footer-link">
                    <i class="bi bi-question-circle"></i>
                    <span>Help</span>
                </a>
                <a href="#" onclick="contactStaff()" class="footer-link">
                    <i class="bi bi-headset"></i>
                    <span>Call Staff</span>
                </a>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Store the context path in a variable that will be evaluated by JSP
        var contextPath = '${pageContext.request.contextPath}';
        
        function selectService(type, id = null) {
            switch(type) {
                case 'payment':
                    if (id !== null) {
                        console.log('Navigating to payment:', id);
                        window.location.href = contextPath + '/kiosk/payment/' + id;
                    }
                    break;
                case 'queue':
                    const queueNumber = localStorage.getItem('queueNumber');
                    if (queueNumber) {
                        window.location.href = contextPath + '/kiosk/queue/status?number=' + queueNumber;
                    } else {
                        window.location.href = contextPath + '/kiosk/queue';
                    }
                    break;
                case 'help':
                    window.location.href = contextPath + '/kiosk/help';
                    break;
            }
        }

        // Function to handle queue number generation
        async function generateQueueNumber(paymentItemId) {
            try {
                const response = await fetch(contextPath + '/kiosk/queue/new?paymentItemId=' + paymentItemId);
                const data = await response.json();
                if (data.queueNumber) {
                    localStorage.setItem('queueNumber', data.queueNumber);
                    window.location.href = contextPath + '/kiosk/queue/status?number=' + data.queueNumber;
                }
            } catch (error) {
                console.error('Error generating queue number:', error);
                alert('Failed to generate queue number. Please try again.');
            }
        }

        // Function to check queue status
        async function checkQueueStatus(queueNumber) {
            try {
                const response = await fetch(contextPath + '/kiosk/queue-status?number=' + queueNumber);
                const data = await response.json();
                return data;
            } catch (error) {
                console.error('Error checking queue status:', error);
                return null;
            }
        }

        // Function to return to main kiosk page
        function returnToMain() {
            window.location.href = contextPath + '/kiosk';
        }

        // Initialize the page
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Context Path:', contextPath); // Debug log
            
            // Add back button listener if it exists
            const backButton = document.querySelector('.btn-back');
            if (backButton) {
                backButton.addEventListener('click', returnToMain);
            }

            // Check for existing queue number
            const queueNumber = localStorage.getItem('queueNumber');
            if (queueNumber) {
                checkQueueStatus(queueNumber).then(status => {
                    if (status && status.status !== 'COMPLETED' && status.status !== 'CANCELLED') {
                        // Show notification about existing queue
                        const notification = document.createElement('div');
                        notification.className = 'queue-notification';
                        notification.innerHTML = 
                            '<p>You have an active queue number: ' + queueNumber + '</p>' +
                            '<button onclick="selectService(\'queue\')" class="btn btn-primary">Check Status</button>';
                        document.querySelector('.header').appendChild(notification);
                    }
                });
            }
        });

        function contactStaff() {
            if (confirm('Do you need assistance? A staff member will be notified to help you.')) {
                // Here you would implement the actual staff notification logic
                alert('A staff member has been notified and will assist you shortly.');
                
                // You could make an API call here to notify staff
                fetch('${pageContext.request.contextPath}/kiosk/notify-staff', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        location: 'Kiosk Area',
                        type: 'Assistance Request'
                    })
                }).then(response => {
                    if (!response.ok) {
                        throw new Error('Failed to notify staff');
                    }
                }).catch(error => {
                    console.error('Error:', error);
                    alert('Unable to contact staff at this moment. Please try again.');
                });
            }
        }
    </script>
</body>
</html> 