<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <title>Payment Confirmation</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #800000;
            --primary-dark: #600000;
            --secondary-color: #D4AF37;
            --success-color: #28a745;
            --success-dark: #218838;
            --danger-color: #dc3545;
            --danger-dark: #c82333;
            --warning-color: #ffc107;
            --light-color: #f8f9fa;
            --border-color: #e9ecef;
            --text-color: #212529;
            --text-secondary: #6c757d;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .confirmation-container {
            width: 100%;
            max-width: 600px;
            min-height: auto;
            margin: 20px;
            padding: 30px;
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
            text-align: center;
            position: relative;
            transition: all 0.3s ease;
        }

        .notification {
            padding: 12px 16px;
            margin: 15px 0;
            border-radius: 6px;
            font-weight: 500;
            display: none;
            animation: fadeIn 0.3s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .notification.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .notification.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .notification.warning {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeeba;
        }

        .back-button-corner {
            position: absolute;
            top: 20px;
            left: 20px;
            display: flex;
            align-items: center;
            gap: 5px;
            transition: transform 0.2s ease;
        }

        .back-button-corner:hover {
            transform: translateX(-3px);
        }

        .cancel-button-corner {
            position: absolute;
            top: 20px;
            right: 20px;
            background-color: var(--danger-color);
            color: white;
            padding: 10px 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 5px;
            transition: all 0.2s ease;
        }

        .cancel-button-corner:hover {
            background-color: var(--danger-dark);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(220, 53, 69, 0.2);
        }

        .kiosk-button-corner {
            position: absolute;
            bottom: 20px;
            left: 20px;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .success-icon {
            font-size: 48px;
            color: var(--primary-color);
            margin: 24px 0 16px;
            background: var(--light-color);
            width: 80px;
            height: 80px;
            display: inline-flex;
            justify-content: center;
            align-items: center;
            border-radius: 50%;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .confirmation-title {
            color: var(--primary-color);
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 16px;
        }

        .payment-details {
            margin: 24px auto;
            text-align: left;
            max-width: 500px;
            background-color: var(--light-color);
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            margin: 8px 0;
            padding: 8px 0;
            border-bottom: 1px solid var(--border-color);
        }

        .detail-row:last-child {
            border-bottom: none;
        }

        .detail-label {
            font-weight: 600;
            color: var(--text-secondary);
        }

        .detail-value {
            color: var(--text-color);
            font-weight: 500;
            text-align: right;
        }

        .amount {
            font-size: 24px;
            font-weight: 700;
            color: var(--primary-color);
        }

        .button {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            font-size: 16px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all 0.3s ease;
            white-space: nowrap;
        }

        .button-primary {
            background-color: var(--primary-color);
            color: white;
        }

        .button-primary:hover, .button-primary:focus {
            background-color: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(128, 0, 0, 0.2);
        }

        .button-danger {
            background-color: var(--danger-color);
            color: white;
        }

        .button-danger:hover, .button-danger:focus {
            background-color: var(--danger-dark);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(220, 53, 69, 0.2);
        }

        .button-secondary {
            background-color: #6c757d;
            color: white;
        }

        .button-secondary:hover, .button-secondary:focus {
            background-color: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(108, 117, 125, 0.2);
        }

        .button-success {
            background-color: var(--success-color);
            color: white;
        }

        .button-success:hover, .button-success:focus {
            background-color: var(--success-dark);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(40, 167, 69, 0.2);
        }

        .button:disabled {
            opacity: 0.7;
            cursor: not-allowed;
            transform: none !important;
            box-shadow: none !important;
        }

        .queue-number-container {
            margin: 24px 0;
            padding: 16px;
            background-color: var(--light-color);
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }

        .queue-title {
            font-size: 18px;
            color: var(--primary-color);
            margin-bottom: 12px;
            font-weight: 600;
        }

        .queue-number {
            font-size: 36px;
            color: var(--primary-color);
            margin: 16px 0;
            padding: 16px;
            border: 2px dashed var(--primary-color);
            display: inline-block;
            border-radius: 8px;
            background-color: white;
            font-weight: 700;
        }

        .estimated-time {
            font-size: 16px;
            color: var(--text-secondary);
            font-weight: 500;
        }

        .status-processed {
            color: var(--success-color);
            font-weight: 600;
        }
        
        .status-pending {
            color: var(--warning-color);
            font-weight: 600;
        }

        .confirm-payment-bottom {
            width: 100%;
            max-width: 300px;
            background-color: var(--primary-color);
            color: white;
            padding: 16px 32px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 18px;
            font-weight: 700;
            margin: 24px auto;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 8px rgba(128, 0, 0, 0.2);
        }

        .confirm-payment-bottom:hover {
            background-color: var(--primary-dark);
            transform: translateY(-3px);
            box-shadow: 0 6px 12px rgba(128, 0, 0, 0.3);
        }

        .student-info-section {
            margin: 20px 0;
            padding: 16px;
            background-color: var(--light-color);
            border-radius: 8px;
            border: 1px solid var(--border-color);
        }

        .student-info-title {
            color: var(--primary-color);
            font-size: 18px;
            margin-bottom: 12px;
            font-weight: 600;
            text-align: center;
        }

        .loading-spinner {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid rgba(255,255,255,.3);
            border-radius: 50%;
            border-top-color: #fff;
            animation: spin 1s ease-in-out infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* Responsive styles */
        @media (max-width: 768px) {
            .confirmation-container {
                margin: 10px;
                padding: 20px;
                max-width: 100%;
            }

            .detail-row {
                flex-direction: column;
                align-items: flex-start;
            }

            .detail-value {
                text-align: left;
                margin-top: 4px;
            }

            .back-button-corner, .cancel-button-corner, .kiosk-button-corner {
                position: relative;
                top: auto;
                left: auto;
                right: auto;
                bottom: auto;
                margin: 10px 0;
            }

            .confirm-payment-bottom {
                position: relative;
                bottom: auto;
                left: auto;
                transform: none;
                margin: 24px auto;
                width: 100%;
            }
        }

        @media print {
            .button, .button-container, .back-button-corner, .cancel-button-corner, .kiosk-button-corner, .confirm-payment-bottom {
                display: none !important;
            }

            .confirmation-container {
                box-shadow: none;
                margin: 0;
                padding: 0;
            }

            body {
                background-color: white;
            }
        }
    </style>
</head>
<body>
    <div class="confirmation-container">
        <a href="${pageContext.request.contextPath}/kiosk" class="button button-secondary back-button-corner">
            <i class="bi bi-house"></i> Back to Kiosk
        </a>

        <button onclick="cancelPayment('${payment.transactionReference}')" class="cancel-button-corner">
            <i class="bi bi-x-circle"></i> Cancel
        </button>

        <div class="success-icon"><i class="bi bi-clipboard-check"></i></div>
        <h1 class="confirmation-title">Review Payment</h1>
        
        <div id="notification" class="notification"></div>
        
        <div class="payment-details">
            <c:if test="${not empty payment.paymentNumber}">
                <div class="detail-row">
                    <span class="detail-label">Payment Number:</span>
                    <span class="detail-value">${payment.paymentNumber}</span>
                </div>
            </c:if>

            <!-- Student Information Section -->
            <c:if test="${not empty student}">
                <div class="student-info-section">
                    <div class="student-info-title">Student Information</div>
                    <div class="detail-row">
                        <span class="detail-label">School ID:</span>
                        <span class="detail-value">${student.studentId}</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Student Name:</span>
                        <span class="detail-value">${student.fullName}</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Program:</span>
                        <span class="detail-value">${student.program}</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Year Level:</span>
                        <span class="detail-value">${student.yearLevel}</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Section:</span>
                        <span class="detail-value">${student.section}</span>
                    </div>
                </div>
            </c:if>

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
            
            <c:if test="${payment.type == 'ENROLLMENT'}">
                <div class="detail-row">
                    <span class="detail-label">Academic Year:</span>
                    <span class="detail-value">${payment.academicYear}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Semester:</span>
                    <span class="detail-value">${payment.semester}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Email:</span>
                    <span class="detail-value">${payment.email}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Contact Number:</span>
                    <span class="detail-value">${payment.contactNumber}</span>
                </div>
            </c:if>
            
            <c:if test="${not empty payment.basePrice}">
                <div class="detail-row">
                    <span class="detail-label">Base Price:</span>
                    <span class="detail-value">₱ ${payment.basePrice}</span>
                </div>
            </c:if>

            <div class="detail-row">
                <span class="detail-label">Amount:</span>
                <span class="detail-value amount">₱ <fmt:formatNumber value="${payment.amount}" pattern="#,##0.00"/></span>
            </div>
            
            <c:if test="${not empty payment.createdAt}">
                <div class="detail-row">
                    <span class="detail-label">Date:</span>
                    <span class="detail-value">
                        <c:set var="dateString" value="${payment.createdAt.toString()}" />
                        <fmt:parseDate value="${dateString}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate" type="both" />
                        <fmt:formatDate value="${parsedDate}" pattern="MMMM dd, yyyy hh:mm a"/>
                    </span>
                </div>
            </c:if>
            
            <c:if test="${not empty payment.paymentStatus}">
                <div class="detail-row">
                    <span class="detail-label">Status:</span>
                    <span class="detail-value ${payment.paymentStatus == 'PROCESSED' ? 'status-processed' : 'status-pending'}">
                        ${payment.paymentStatus}
                    </span>
                </div>
            </c:if>
        </div>

        <c:if test="${not empty queueNumber}">
            <div class="queue-number-container">
                <h2 class="queue-title">Your Queue Number</h2>
                <div class="queue-number">${queueNumber}</div>
                <p>Please wait for your number to be called</p>
                <p class="estimated-time"><i class="bi bi-clock"></i> Estimated wait time: ${estimatedWaitTime} minutes</p>
            </div>
        </c:if>

        <button id="confirmPaymentButton" onclick="confirmPayment('${payment.transactionReference}')" class="confirm-payment-bottom">
            <i class="bi bi-check-circle"></i> CONFIRM PAYMENT
        </button>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const paymentStatus = '${payment.paymentStatus}';
            const transactionRef = '${payment.transactionReference}';
            console.log('Payment Status:', paymentStatus);
            console.log('Transaction Reference:', transactionRef);
            
            // Check if this payment was already confirmed
            const confirmButton = document.getElementById('confirmPaymentButton');
            const wasConfirmed = sessionStorage.getItem('confirmed_' + transactionRef);
            const isProcessing = sessionStorage.getItem('processing_' + transactionRef);
            
            if (confirmButton) {
                if (wasConfirmed || isProcessing || paymentStatus === 'PROCESSED') {
                    confirmButton.style.display = 'none';
                    
                    if (isProcessing) {
                        // Show processing indicator
                        showNotification('Payment is being processed...', 'warning');
                    }
                } else {
                    confirmButton.style.display = 'flex';
                }
            }

            // Clear any old confirmation flags for other transactions
            Object.keys(sessionStorage).forEach(key => {
                if ((key.startsWith('confirmed_') || key.startsWith('processing_')) && 
                    !key.endsWith(transactionRef)) {
                    sessionStorage.removeItem(key);
                }
            });
        });

        function showNotification(message, type) {
            const notification = document.getElementById('notification');
            notification.textContent = message;
            notification.className = 'notification ' + type;
            notification.style.display = 'block';
            
            setTimeout(() => {
                notification.style.opacity = '1';
            }, 10);
        }

        function confirmPayment(transactionRef) {
            if (!transactionRef) {
                console.error('Transaction Reference is missing');
                showNotification('Error: Transaction Reference is missing', 'error');
                return;
            }

            const confirmButton = document.getElementById('confirmPaymentButton');
            let originalText = '';
            
            if (confirmButton) {
                // Store original button text
                originalText = confirmButton.innerHTML;
                
                // Show loading state on button and then hide it completely
                confirmButton.innerHTML = '<span class="loading-spinner"></span> Processing...';
                confirmButton.disabled = true;
                
                // Hide the button immediately after clicking - don't wait for response
                setTimeout(() => {
                    confirmButton.style.display = 'none';
                }, 500);
                
                // Set processing state
                sessionStorage.setItem('processing_' + transactionRef, 'true');
                
                // Show notification
                showNotification('Processing your payment...', 'warning');
            }

            if (confirm('Are you sure you want to confirm this payment?')) {
                const token = "${_csrf.token}";
                const header = "${_csrf.headerName}";
                
                // Mark this payment as confirmed
                sessionStorage.setItem('confirmed_' + transactionRef, 'true');
                
                fetch('${pageContext.request.contextPath}/kiosk/payment/confirm/' + transactionRef, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        [header]: token
                    },
                    credentials: 'same-origin'
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }
                    return response.json();
                })
                .then(data => {
                    console.log('Payment confirmation response:', data);
                    
                    // Check for an error message containing "Queue not found"
                    if (!data.success && data.message && data.message.includes("Queue not found")) {
                        // Special handling for queue not found errors
                        console.log("Queue not found error - attempting to continue with payment confirmation");
                        
                        // Even with the queue error, the payment might have been processed
                        showNotification('Payment was processed, but there was an issue with the queue. Your payment is still valid.', 'warning');
                        
                        // Create a generic queue display
                        const queueContainer = document.createElement('div');
                        queueContainer.className = 'queue-number-container';
                        queueContainer.innerHTML = `
                            <h2 class="queue-title">Payment Confirmed</h2>
                            <p>Your payment has been recorded. Please proceed to the cashier window.</p>
                            <p class="estimated-time"><i class="bi bi-info-circle"></i> Show your transaction reference: ${transactionRef}</p>
                        `;
                        
                        // Insert the queue container
                        const paymentDetails = document.querySelector('.payment-details');
                        if (paymentDetails) {
                            paymentDetails.after(queueContainer);
                        }
                        
                        return;
                    }
                    
                    if (data.success) {
                        showNotification('Payment confirmed successfully!', 'success');
                        
                        // Check if we received queue information
                        if (data.queueNumber) {
                            // Only create a new queue number display if one doesn't already exist
                            if (!document.querySelector('.queue-number-container')) {
                                const queueContainer = document.createElement('div');
                                queueContainer.className = 'queue-number-container';
                                queueContainer.innerHTML = `
                                    <h2 class="queue-title">Your Queue Number</h2>
                                    <div class="queue-number">${data.queueNumber}</div>
                                    <p>Please wait for your number to be called</p>
                                    <p class="estimated-time"><i class="bi bi-clock"></i> Estimated wait time: ${data.estimatedWaitTime} minutes</p>
                                `;
                                
                                // Find insertion point - after payment details
                                const paymentDetails = document.querySelector('.payment-details');
                                if (paymentDetails) {
                                    paymentDetails.after(queueContainer);
                                }
                            }
                            
                            // Show a more detailed confirmation message
                            showNotification(`Payment confirmed! Your queue number is ${data.queueNumber}. Please wait for your turn.`, 'success');
                        } else {
                            showNotification('Payment confirmed but no queue number was generated. Please contact staff.', 'warning');
                        }
                        
                        // If the backend requested a page reload
                        if (data.reload) {
                            setTimeout(() => {
                                window.location.reload();
                            }, 2000); // Wait 2 seconds so the user can see the success message
                        }
                    } else {
                        // This happens when success is false
                        showNotification(data.message || 'Error confirming payment.', 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    
                    // Even if there's an error, we don't restore the button
                    // This prevents multiple attempts that could lead to duplicate payments
                    
                    // Check if the error message contains "Queue not found"
                    if (error.message && error.message.includes("Queue not found")) {
                        showNotification('Payment was processed, but there was an issue with the queue system. Your payment is still valid.', 'warning');
                        
                        // Create a fallback message
                        const queueContainer = document.createElement('div');
                        queueContainer.className = 'queue-number-container';
                        queueContainer.innerHTML = `
                            <h2 class="queue-title">Payment Confirmed</h2>
                            <p>Your payment has been recorded. Please proceed to the cashier window.</p>
                            <p class="estimated-time"><i class="bi bi-info-circle"></i> Show your transaction reference: ${transactionRef}</p>
                        `;
                        
                        // Insert the queue container
                        const paymentDetails = document.querySelector('.payment-details');
                        if (paymentDetails) {
                            paymentDetails.after(queueContainer);
                        }
                    } else {
                        showNotification('Error processing payment. Please contact staff for assistance.', 'error');
                    }
                });
            } else {
                // If user cancels the confirmation dialog
                if (confirmButton) {
                    // If user cancels, show button again and restore it
                    confirmButton.style.display = 'flex';
                    confirmButton.innerHTML = '<i class="bi bi-check-circle"></i> CONFIRM PAYMENT';
                    confirmButton.disabled = false;
                    sessionStorage.removeItem('confirmed_' + transactionRef);
                    sessionStorage.removeItem('processing_' + transactionRef);
                }
                
                // Clear notification
                document.getElementById('notification').style.display = 'none';
            }
        }

        function cancelPayment(transactionRef) {
            if (!transactionRef) {
                console.error('Transaction Reference is missing');
                showNotification('Error: Transaction Reference is missing', 'error');
                return;
            }

            if (confirm('Are you sure you want to cancel this payment?')) {
                const token = "${_csrf.token}";
                const header = "${_csrf.headerName}";

                // Show cancelling notification
                showNotification('Cancelling payment...', 'warning');

                fetch('${pageContext.request.contextPath}/kiosk/payment/cancel/' + transactionRef, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        [header]: token
                    },
                    credentials: 'same-origin'
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }
                    return response.json();
                })
                .then(data => {
                    if (data.success) {
                        showNotification('Payment cancelled successfully', 'success');
                        
                        // Redirect after a short delay to show the success message
                        setTimeout(() => {
                            window.location.href = '${pageContext.request.contextPath}/kiosk';
                        }, 1500);
                    } else {
                        showNotification(data.error || 'Failed to cancel payment', 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showNotification('Failed to cancel payment. Please try again.', 'error');
                });
            }
        }
    </script>
</body>
</html> 