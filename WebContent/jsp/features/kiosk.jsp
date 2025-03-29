<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Online KIOSK - Payment Selection</title>
    <link rel="stylesheet" href="../css/features/kiosk.css">
</head>
<body>
    <div class="kiosk-container">
        <header>
            <h1>Online KIOSK</h1>
            <div class="user-info">
                <span id="currentUser">Welcome, Guest</span>
            </div>
        </header>

        <main>
            <div class="payment-options">
                <h2>Select Payment Type</h2>
                <div class="payment-grid">
                    <div class="payment-card" data-type="tuition">
                        <h3>Tuition Fee</h3>
                        <p>Pay your tuition fees</p>
                    </div>
                    <div class="payment-card" data-type="miscellaneous">
                        <h3>Miscellaneous</h3>
                        <p>Other school fees</p>
                    </div>
                    <div class="payment-card" data-type="library">
                        <h3>Library Fee</h3>
                        <p>Library related payments</p>
                    </div>
                    <div class="payment-card" data-type="laboratory">
                        <h3>Laboratory Fee</h3>
                        <p>Lab equipment and materials</p>
                    </div>
                </div>
            </div>

            <div class="payment-details" style="display: none;">
                <h2>Payment Details</h2>
                <form id="paymentForm">
                    <div class="form-group">
                        <label for="amount">Amount:</label>
                        <input type="number" id="amount" name="amount" required>
                    </div>
                    <div class="form-group">
                        <label for="reference">Reference Number:</label>
                        <input type="text" id="reference" name="reference" required>
                    </div>
                    <div class="form-group">
                        <label for="description">Description:</label>
                        <textarea id="description" name="description" required></textarea>
                    </div>
                    <div class="button-group">
                        <button type="submit" class="btn-primary">Proceed to Payment</button>
                        <button type="button" class="btn-secondary" onclick="cancelPayment()">Cancel</button>
                    </div>
                </form>
            </div>
        </main>

        <footer>
            <p>Need help? <a href="../jsp/features/faq.jsp">View FAQs</a></p>
        </footer>
    </div>

    <script src="../js/features/kiosk.js"></script>
</body>
</html> 