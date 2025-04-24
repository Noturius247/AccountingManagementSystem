<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Kiosk Queue Status</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css">
    <style>
        .queue-status-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 80vh;
            text-align: center;
            padding: 20px;
        }
        
        .now-serving {
            font-size: 32px;
            color: #333;
            margin-bottom: 30px;
            text-transform: uppercase;
            font-weight: bold;
        }
        
        .queue-number {
            font-size: 96px;
            font-weight: bold;
            color: #800000; /* Maroon color */
            padding: 40px;
            border-radius: 15px;
            background-color: #fff;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            margin: 20px 0;
            min-width: 400px;
            border: 4px solid #800000;
        }
        
        .queue-message {
            font-size: 24px;
            color: #666;
            margin-top: 20px;
        }
        
        .refresh-button {
            margin-top: 30px;
            padding: 12px 24px;
            font-size: 18px;
            background-color: #800000;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
            display: none; /* Hide the refresh button since we have auto-refresh */
        }
        
        .refresh-button:hover {
            background-color: #600000;
        }
        
        /* Animation for number changes */
        @keyframes numberUpdate {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }
        
        .number-updated {
            animation: numberUpdate 0.5s ease-in-out;
        }

        .back-button {
            position: fixed;
            bottom: 30px;
            left: 30px;
            padding: 15px 30px;
            font-size: 18px;
            background-color: #800000;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .back-button:hover {
            background-color: #600000;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
    </style>
</head>
<body>
    <div class="queue-status-container">
        <h1 class="now-serving">Now Serving</h1>
        <div class="queue-number" id="queueNumber">
            ${currentProcessingNumber}
        </div>
        <p class="queue-message">Please wait for your number to be called</p>
    </div>

    <a href="${pageContext.request.contextPath}/kiosk" class="back-button">Back to Kiosk</a>

    <script>
        function updateQueueNumber() {
            fetch('${pageContext.request.contextPath}/kiosk/queue/status', {
                headers: {
                    'Accept': 'text/html'
                }
            })
            .then(response => response.text())
            .then(html => {
                // Create a temporary element to parse the HTML
                const temp = document.createElement('div');
                temp.innerHTML = html;
                
                // Find the queue number in the parsed HTML
                const newNumber = temp.querySelector('#queueNumber').innerText.trim();
                const currentNumber = document.getElementById('queueNumber').innerText.trim();
                
                // Update only if the number has changed
                if (newNumber !== currentNumber) {
                    const queueElement = document.getElementById('queueNumber');
                    queueElement.classList.add('number-updated');
                    queueElement.innerText = newNumber;
                    setTimeout(() => queueElement.classList.remove('number-updated'), 500);
                }
            })
            .catch(error => console.error('Error updating queue:', error));
        }

        // Update every 2 seconds
        setInterval(updateQueueNumber, 2000);
    </script>
</body>
</html> 