<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment Confirmation</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css">
    <style>
        .confirmation-container {
            max-width: 600px;
            margin: 40px auto;
            padding: 30px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .success-icon {
            font-size: 64px;
            color: #28a745;
            margin-bottom: 20px;
        }

        .confirmation-title {
            color: #28a745;
            font-size: 24px;
            margin-bottom: 20px;
        }

        .payment-details {
            margin: 30px 0;
            text-align: left;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            margin: 10px 0;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }

        .detail-label {
            font-weight: bold;
            color: #666;
        }

        .detail-value {
            color: #333;
        }

        .amount {
            font-size: 24px;
            color: #800000;
            font-weight: bold;
        }

        .button-container {
            margin-top: 30px;
            display: flex;
            gap: 15px;
            justify-content: center;
        }

        .download-button {
            background-color: #800000;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-size: 16px;
            transition: background-color 0.3s;
        }

        .download-button:hover {
            background-color: #600000;
        }

        .cancel-button {
            background-color: #dc3545;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-size: 16px;
            transition: background-color 0.3s;
        }

        .cancel-button:hover {
            background-color: #c82333;
        }

        .home-button {
            background-color: #666;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-size: 16px;
            transition: background-color 0.3s;
        }

        .home-button:hover {
            background-color: #555;
        }

        .back-button {
            background-color: #007bff;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-size: 16px;
            transition: background-color 0.3s;
        }

        .back-button:hover {
            background-color: #0056b3;
        }

        .queue-number {
            font-size: 36px;
            color: #800000;
            margin: 20px 0;
            padding: 15px;
            border: 2px dashed #800000;
            display: inline-block;
            border-radius: 5px;
        }

        @media print {
            .button-container {
                display: none;
            }
        }

        .confirm-button {
            background-color: #28a745;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-size: 16px;
            transition: background-color 0.3s;
        }

        .confirm-button:hover {
            background-color: #218838;
        }

        .status-processed {
            color: #28a745;
        }
        
        .status-pending {
            color: #ffc107;
        }
    </style>
</head>
<body>
    <div class="confirmation-container">
        <div class="success-icon">✓</div>
        <h1 class="confirmation-title">Payment Successful!</h1>
        
        <div class="payment-details">
            <div class="detail-row">
                <span class="detail-label">Payment Number:</span>
                <span class="detail-value">${payment.paymentNumber}</span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Description:</span>
                <span class="detail-value">${payment.description}</span>
            </div>
            
            <c:if test="${not empty payment.copies}">
                <div class="detail-row">
                    <span class="detail-label">Number of Copies:</span>
                    <span class="detail-value">${payment.copies}</span>
                </div>
            </c:if>
            
            <c:if test="${not empty payment.purpose}">
                <div class="detail-row">
                    <span class="detail-label">Purpose:</span>
                    <span class="detail-value">${payment.purpose}</span>
                </div>
            </c:if>
            
            <c:if test="${not empty payment.basePrice}">
                <div class="detail-row">
                    <span class="detail-label">Base Price:</span>
                    <span class="detail-value">₱ ${payment.basePrice}</span>
                </div>
            </c:if>

            <div class="detail-row">
                <span class="detail-label">Date:</span>
                <span class="detail-value">
                    <fmt:formatDate value="${payment.processedAt}" pattern="MMM dd, yyyy HH:mm:ss"/>
                </span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Amount:</span>
                <span class="detail-value amount">₱ ${payment.formattedAmount}</span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Status:</span>
                <span class="detail-value" data-field="status" class="${payment.paymentStatus == 'PROCESSED' ? 'status-processed' : 'status-pending'}">
                    ${payment.paymentStatus}
                </span>
            </div>
        </div>

        <c:if test="${not empty queueNumber}">
            <div>
                <h2>Your Queue Number</h2>
                <div class="queue-number">${queueNumber}</div>
                <p>Please wait for your number to be called</p>
            </div>
        </c:if>

        <div class="button-container">
            <c:if test="${payment.paymentStatus == 'PENDING'}">
                <button onclick="confirmPayment('${payment.id}')" class="confirm-button">
                    Confirm Payment
                </button>
                <button onclick="cancelPayment('${payment.id}')" class="cancel-button">
                    Cancel Payment
                </button>
            </c:if>
            <a href="javascript:history.back()" class="back-button">
                Back
            </a>
            <a href="${pageContext.request.contextPath}/kiosk" class="home-button">
                Back to Kiosk
            </a>
        </div>
    </div>

    <script>
        function confirmPayment(paymentId) {
            if (confirm('Are you sure you want to confirm this payment?')) {
                fetch('${pageContext.request.contextPath}/kiosk/payment/confirm/' + paymentId, {
                    method: 'POST'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Update status to PROCESSED
                        document.querySelector('.detail-value[data-field="status"]').textContent = 'PROCESSED';
                        document.querySelector('.detail-value[data-field="status"]').classList.add('status-processed');
                        
                        // Add queue number if provided
                        if (data.queueNumber) {
                            const queueDiv = document.createElement('div');
                            queueDiv.innerHTML = `
                                <div>
                                    <h2>Your Queue Number</h2>
                                    <div class="queue-number">${data.queueNumber}</div>
                                    <p>Please wait for your number to be called</p>
                                </div>
                            `;
                            document.querySelector('.payment-details').after(queueDiv);
                        }
                        
                        // Hide confirm button
                        document.querySelector('.confirm-button').style.display = 'none';
                        document.querySelector('.cancel-button').style.display = 'none';
                        
                        alert('Payment confirmed successfully');
                    } else {
                        alert(data.error || 'Failed to confirm payment');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Failed to confirm payment');
                });
            }
        }

        function cancelPayment(paymentId) {
            if (confirm('Are you sure you want to cancel this payment?')) {
                fetch('${pageContext.request.contextPath}/kiosk/payment/cancel/' + paymentId, {
                    method: 'POST'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('Payment cancelled successfully');
                        window.location.href = '${pageContext.request.contextPath}/kiosk';
                    } else {
                        alert(data.error || 'Failed to cancel payment');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Failed to cancel payment');
                });
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            // Check if payment is processed
            const paymentStatus = '${payment.paymentStatus}';
            const paymentId = '${payment.id}';
            
            if (paymentStatus === 'PROCESSED') {
                // Trigger receipt download
                window.location.href = '${pageContext.request.contextPath}/kiosk/payment/' + paymentId + '/download-receipt';
                
                // Show success message
                setTimeout(function() {
                    alert('Your receipt has been downloaded. Please keep it for your records.');
                }, 1000);
            }
        });
    </script>
</body>
</html> 