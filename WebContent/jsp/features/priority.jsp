<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Priority Number Generator</title>
    <link rel="stylesheet" href="../css/features/priority.css">
</head>
<body>
    <div class="priority-container">
        <header>
            <h1>Priority Number Generator</h1>
            <div class="user-info">
                <span id="currentUser">Welcome, Guest</span>
            </div>
        </header>

        <main>
            <div class="queue-status">
                <div class="current-number">
                    <h2>Current Number</h2>
                    <div class="number-display" id="currentNumber">--</div>
                </div>
                <div class="next-number">
                    <h2>Next Number</h2>
                    <div class="number-display" id="nextNumber">--</div>
                </div>
            </div>

            <div class="queue-info">
                <div class="queue-stats">
                    <div class="stat-item">
                        <h3>Total in Queue</h3>
                        <span id="totalQueue">0</span>
                    </div>
                    <div class="stat-item">
                        <h3>Estimated Wait Time</h3>
                        <span id="waitTime">0 mins</span>
                    </div>
                </div>
            </div>

            <div class="action-buttons">
                <button id="getNumber" class="btn-primary">Get Priority Number</button>
                <button id="checkStatus" class="btn-secondary">Check Status</button>
            </div>

            <div class="number-history">
                <h2>Recent Numbers</h2>
                <div class="history-list" id="numberHistory">
                    <!-- Numbers will be dynamically added here -->
                </div>
            </div>
        </main>

        <footer>
            <p>Need help? <a href="../jsp/features/faq.jsp">View FAQs</a></p>
        </footer>
    </div>

    <script src="../js/features/priority.js"></script>
</body>
</html> 