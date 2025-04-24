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

        .back-button {
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

        .back-button:hover {
            background-color: #555;
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
                <span class="detail-value" style="color: #28a745;">PROCESSED</span>
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
            <a href="${pageContext.request.contextPath}/kiosk/payment/${payment.id}/download-receipt" 
               class="download-button" download>
                Download Receipt
            </a>
            <a href="${pageContext.request.contextPath}/kiosk" class="back-button">
                Back to Kiosk
            </a>
        </div>
    </div>

    <script>
        // Automatically trigger receipt download
        window.onload = function() {
            document.querySelector('.download-button').click();
        };
    </script>
</body>
</html> 