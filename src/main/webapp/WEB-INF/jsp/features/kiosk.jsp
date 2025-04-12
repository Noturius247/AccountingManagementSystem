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
            <div class="payment-grid">
                <div class="payment-card" onclick="selectService('tuition')">
                    <i class="fas fa-graduation-cap"></i>
                    <h3>Tuition Payment</h3>
                    <p>Pay your tuition fees</p>
                    <button class="btn btn-primary">Select</button>
                </div>

                <div class="payment-card" onclick="selectService('library')">
                    <i class="fas fa-book"></i>
                    <h3>Library Fees</h3>
                    <p>Pay library and resource fees</p>
                    <button class="btn btn-primary">Select</button>
                </div>

                <div class="payment-card" onclick="selectService('lab')">
                    <i class="fas fa-flask"></i>
                    <h3>Laboratory Fees</h3>
                    <p>Pay laboratory fees</p>
                    <button class="btn btn-primary">Select</button>
                </div>

                <div class="payment-card" onclick="selectService('misc')">
                    <i class="fas fa-file-invoice"></i>
                    <h3>Miscellaneous</h3>
                    <p>Other payments</p>
                    <button class="btn btn-primary">Select</button>
                </div>

                <div class="payment-card" onclick="selectService('queue')">
                    <i class="fas fa-users"></i>
                    <h3>Queue Status</h3>
                    <p>Check your queue number</p>
                    <button class="btn btn-primary">Check</button>
                </div>

                <div class="payment-card" onclick="selectService('help')">
                    <i class="fas fa-question-circle"></i>
                    <h3>Help</h3>
                    <p>Get assistance</p>
                    <button class="btn btn-primary">Help</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        function selectService(service) {
            const baseUrl = '${pageContext.request.contextPath}/kiosk';
            
            switch(service) {
                case 'tuition':
                    window.location.href = `${baseUrl}/payment/1`;
                    break;
                case 'library':
                    window.location.href = `${baseUrl}/payment/2`;
                    break;
                case 'lab':
                    window.location.href = `${baseUrl}/payment/3`;
                    break;
                case 'misc':
                    window.location.href = `${baseUrl}/payment/4`;
                    break;
                case 'queue':
                    window.location.href = `${baseUrl}/queue`;
                    break;
                case 'help':
                    window.location.href = `${baseUrl}/help`;
                    break;
            }
        }

        // Function to return to main kiosk page
        function returnToMain() {
            window.location.href = '${pageContext.request.contextPath}/kiosk';
        }

        // Add event listener for back button if it exists
        document.addEventListener('DOMContentLoaded', function() {
            const backButton = document.querySelector('.btn-back');
            if (backButton) {
                backButton.addEventListener('click', returnToMain);
            }
        });
    </script>
</body>
</html> 