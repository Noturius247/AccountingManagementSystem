<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>School Payment Kiosk</title>
    <!-- Font Awesome 6 CSS via CDN -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f2f5;
            padding: 20px;
        }
        .header {
            max-width: 1200px;
            margin: 0 auto 20px;
            text-align: center;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .header h1 {
            color: #333;
            margin-bottom: 10px;
            font-size: 2em;
        }
        .header p {
            color: #666;
            margin-bottom: 20px;
        }
        .search-box {
            display: flex;
            gap: 10px;
            max-width: 600px;
            margin: 0 auto;
        }
        .search-input {
            flex: 1;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 5px;
            font-size: 1em;
            transition: border-color 0.2s;
        }
        .search-input:focus {
            outline: none;
            border-color: #2196F3;
        }
        .search-btn {
            background: #2196F3;
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1em;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: background 0.2s;
        }
        .search-btn:hover {
            background: #1976D2;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            padding: 20px;
        }
        .card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }
        .card::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: #2196F3;
            transform: scaleX(0);
            transition: transform 0.3s ease;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 12px rgba(33, 150, 243, 0.2);
        }
        .card:hover::after {
            transform: scaleX(1);
        }
        .card i {
            font-size: 2.5em;
            margin-bottom: 15px;
            color: #2196F3;
            transition: transform 0.3s ease;
        }
        .card:hover i {
            transform: scale(1.1);
        }
        .card h2 {
            color: #333;
            font-size: 1.5em;
            margin-bottom: 10px;
        }
        .card p {
            color: #666;
            margin-bottom: 15px;
        }
        .footer {
            position: fixed;
            bottom: 0;
            left: 0;
            right: 0;
            background: #333;
            padding: 10px;
            text-align: center;
        }
        .footer-icons {
            color: white;
            font-size: 1.5em;
            margin: 0 10px;
            text-decoration: none;
        }
        .footer-icons:hover {
            color: #2196F3;
        }
    </style>
</head>
<body>
    <!-- Header with Search -->
    <div class="header">
        <h1>School Payment Kiosk</h1>
        <p>Select a service to proceed</p>
        <!-- Debug info - hidden in production -->
        <div style="display: none;" id="debugInfo">
            Context Path: ${pageContext.request.contextPath}
        </div>
        <div class="search-box">
            <input type="text" class="search-input" placeholder="Search payments...">
            <button class="search-btn">
                <i class="fas fa-search"></i>
                Search
            </button>
        </div>
    </div>

    <div class="container">
        <!-- First Semester Tuition -->
        <div class="card" onclick="selectService('payment', 'tuition')">
            <i class="fas fa-graduation-cap"></i>
            <h2>Tuition</h2>
            <p>Regular term tuition payment</p>
        </div>

        <!-- Library Access Fee -->
        <div class="card" onclick="selectService('payment', 'library')">
            <i class="fas fa-book-reader"></i>
            <h2>Library Access Fee</h2>
            <p>Semester library access</p>
        </div>

        <!-- Chemistry Lab Fee -->
        <div class="card" onclick="selectService('payment', 'lab')">
            <i class="fas fa-flask"></i>
            <h2>Chemistry Lab Fee</h2>
            <p>Laboratory equipment and materials</p>
        </div>

        <!-- Student ID Replacement -->
        <div class="card" onclick="selectService('payment', 'id')">
            <i class="fas fa-id-card"></i>
            <h2>Student ID Replacement</h2>
            <p>Lost ID replacement fee</p>
        </div>

        <!-- Graduation Fee -->
        <div class="card" onclick="selectService('payment', 'graduation')">
            <i class="fas fa-user-graduate"></i>
            <h2>Graduation Fee</h2>
            <p>Graduation ceremony and documents</p>
        </div>

        <!-- Transcript Request -->
        <div class="card" onclick="selectService('payment', 'transcript')">
            <i class="fas fa-file-alt"></i>
            <h2>Transcript Request</h2>
            <p>Official transcript processing</p>
        </div>

        <!-- Queue Status -->
        <div class="card" onclick="selectService('queue')">
            <i class="fas fa-users"></i>
            <h2>Queue Status</h2>
            <p>Check your queue number and waiting time</p>
        </div>

        <!-- Help -->
        <div class="card" onclick="selectService('help')">
            <i class="fas fa-question-circle"></i>
            <h2>Help</h2>
            <p>Get assistance with your payment</p>
        </div>
    </div>

    <footer class="footer">
        <a href="#" class="footer-icons"><i class="fas fa-home"></i></a>
        <a href="#" class="footer-icons"><i class="fas fa-cog"></i></a>
    </footer>

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
    </script>
</body>
</html> 