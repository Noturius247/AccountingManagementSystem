<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Online KIOSK - Payment Selection</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #3498db;
            --success-color: #2ecc71;
            --danger-color: #e74c3c;
            --warning-color: #f39c12;
            --info-color: #17a2b8;
            --dark-color: #2c3e50;
            --light-color: #ecf0f1;
        }

        body {
            background-color: #f5f7fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
        }

        .kiosk-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .header {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            text-align: center;
        }

        .header h1 {
            color: var(--dark-color);
            margin: 0;
        }

        .payment-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .payment-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            text-align: center;
            cursor: pointer;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .payment-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.15);
        }

        .payment-card i {
            font-size: 2.5rem;
            color: var(--primary-color);
            margin-bottom: 15px;
        }

        .payment-card h3 {
            color: var(--dark-color);
            margin: 10px 0;
        }

        .payment-card p {
            color: #666;
            margin-bottom: 15px;
        }

        .btn {
            display: inline-block;
            padding: 10px 20px;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            font-size: 1rem;
            transition: background-color 0.2s ease;
            text-decoration: none;
        }

        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }

        .btn-primary:hover {
            background-color: #2980b9;
        }

        .btn-back {
            background-color: var(--dark-color);
            color: white;
            margin-bottom: 20px;
        }

        .btn-back:hover {
            background-color: #1a252f;
        }

        #mainContent {
            min-height: 400px;
        }
    </style>
</head>
<body>
    <div class="kiosk-container">
        <div class="header">
            <h1>School Payment Kiosk</h1>
            <p>Select a service to proceed</p>
        </div>

        <div id="mainContent">
            <!-- Dynamic Payment Items -->
            <div class="payment-grid">
                <c:forEach items="${paymentItems}" var="item">
                    <div class="payment-card" onclick='selectService("payment", "${item.id}")'>
                        <i class="${item.icon}"></i>
                        <h3>${item.name}</h3>
                        <p>${item.description}</p>
                        <button class="btn btn-primary">Select</button>
                    </div>
                </c:forEach>

                <!-- Queue Status Card -->
                <div class="payment-card" onclick="selectService('queue')">
                    <i class="fas fa-users"></i>
                    <h3>Queue Status</h3>
                    <p>Check your queue number and waiting time</p>
                    <button class="btn btn-primary">Check Status</button>
                </div>

                <!-- Help Card -->
                <div class="payment-card" onclick="selectService('help')">
                    <i class="fas fa-question-circle"></i>
                    <h3>Help</h3>
                    <p>Get assistance with your payment</p>
                    <button class="btn btn-primary">Get Help</button>
                </div>
            </div>

            <!-- Search Section -->
            <div class="search-section">
                <form action="${pageContext.request.contextPath}/kiosk/search" method="GET" class="search-form">
                    <input type="text" name="query" placeholder="Search payments..." class="search-input">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-search"></i> Search
                    </button>
                </form>
            </div>
        </div>
    </div>

    <script>
        function selectService(type, id = null) {
            const baseUrl = '${pageContext.request.contextPath}/kiosk';
            
            switch(type) {
                case 'payment':
                    if (id !== null) {
                        window.location.href = `${baseUrl}/payment/${id}`;
                    }
                    break;
                case 'queue':
                    // First check if there's an existing queue number in session/local storage
                    const queueNumber = localStorage.getItem('queueNumber');
                    if (queueNumber) {
                        window.location.href = `${baseUrl}/queue/status?number=${queueNumber}`;
                    } else {
                        window.location.href = `${baseUrl}/queue`;
                    }
                    break;
                case 'help':
                    window.location.href = `${baseUrl}/help`;
                    break;
            }
        }

        // Function to handle queue number generation
        async function generateQueueNumber(paymentItemId) {
            try {
                const response = await fetch(`${pageContext.request.contextPath}/kiosk/queue/new?paymentItemId=${paymentItemId}`);
                const data = await response.json();
                if (data.queueNumber) {
                    localStorage.setItem('queueNumber', data.queueNumber);
                    window.location.href = `${pageContext.request.contextPath}/kiosk/queue/status?number=${data.queueNumber}`;
                }
            } catch (error) {
                console.error('Error generating queue number:', error);
                alert('Failed to generate queue number. Please try again.');
            }
        }

        // Function to check queue status
        async function checkQueueStatus(queueNumber) {
            try {
                const response = await fetch(`${pageContext.request.contextPath}/kiosk/queue-status?number=${queueNumber}`);
                const data = await response.json();
                return data;
            } catch (error) {
                console.error('Error checking queue status:', error);
                return null;
            }
        }

        // Function to return to main kiosk page
        function returnToMain() {
            window.location.href = '${pageContext.request.contextPath}/kiosk';
        }

        // Initialize the page
        document.addEventListener('DOMContentLoaded', function() {
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
    </script>
</body>
</html> 