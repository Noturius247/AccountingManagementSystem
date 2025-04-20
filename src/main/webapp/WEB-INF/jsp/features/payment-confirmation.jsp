<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment Confirmation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .confirmation-container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 2rem;
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        .confirmation-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        .confirmation-icon {
            font-size: 4rem;
            color: #28a745;
            margin-bottom: 1rem;
        }
        .payment-details {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 8px;
            margin-bottom: 2rem;
        }
        .detail-row {
            display: flex;
            justify-content: space-between;
            padding: 0.5rem 0;
            border-bottom: 1px solid #dee2e6;
        }
        .detail-row:last-child {
            border-bottom: none;
        }
        .detail-label {
            font-weight: 600;
            color: #6c757d;
        }
        .detail-value {
            font-weight: 500;
        }
        .action-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 2rem;
        }
        .btn-print {
            background: #17a2b8;
            color: white;
        }
        .btn-queue {
            background: #6c757d;
            color: white;
        }
    </style>
</head>
<body>
    <div class="confirmation-container">
        <div class="confirmation-header">
            <i class="bi bi-check-circle-fill confirmation-icon"></i>
            <h2>Payment Successful!</h2>
            <p class="text-muted">Your payment has been processed successfully</p>
        </div>

        <div class="payment-details">
            <div class="detail-row">
                <span class="detail-label">Transaction Reference:</span>
                <span class="detail-value">${payment.transactionReference}</span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Amount:</span>
                <span class="detail-value"><fmt:formatNumber value="${payment.amount}" type="currency"/></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Description:</span>
                <span class="detail-value">${payment.description}</span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Payment Method:</span>
                <span class="detail-value">${payment.paymentMethod}</span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Date:</span>
                <span class="detail-value"><fmt:formatDate value="${payment.createdAt}" pattern="MMM dd, yyyy HH:mm"/></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Queue Number:</span>
                <span class="detail-value">${queueNumber}</span>
            </div>
        </div>

        <div class="action-buttons">
            <button onclick="window.print()" class="btn btn-print">
                <i class="bi bi-printer"></i> Print Receipt
            </button>
            <a href="/kiosk/queue/status?number=${queueNumber}" class="btn btn-queue">
                <i class="bi bi-clock"></i> Check Queue Status
            </a>
            <c:if test="${payment.paymentStatus.name() == 'PENDING'}">
                <button onclick="cancelPayment('${payment.id}')" class="btn btn-danger">
                    <i class="bi bi-x-circle"></i> Cancel Payment
                </button>
            </c:if>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function cancelPayment(paymentId) {
            if (confirm('Are you sure you want to cancel this payment?')) {
                fetch(`/kiosk/payment/cancel/${paymentId}`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    }
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert(data.message);
                        window.location.href = '/kiosk';
                    } else {
                        alert(data.error || 'Failed to cancel payment');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('An error occurred while cancelling the payment');
                });
            }
        }
    </script>
</body>
</html> 