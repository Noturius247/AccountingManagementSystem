<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <title>Payment Confirmation</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css">
    <style>
        .confirmation-container {
            max-width: 600px;
            min-height: 800px;
            margin: 40px auto;
            padding: 30px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            text-align: center;
            position: relative;
        }

        .back-button-corner {
            position: absolute;
            top: 20px;
            left: 20px;
        }

        .kiosk-button-corner {
            position: absolute;
            bottom: 20px;
            left: 20px;
        }

        .action-buttons {
            margin-top: 30px;
            margin-bottom: 100px;
            display: flex;
            gap: 15px;
            justify-content: center;
        }

        .success-icon {
            font-size: 64px;
            color: #800000;
            margin-bottom: 20px;
            margin-top: 40px;
        }

        .confirmation-title {
            color: #800000;
            font-size: 24px;
            margin-bottom: 20px;
        }

        .payment-details {
            margin: 30px auto;
            text-align: left;
            max-width: 500px;
            margin-bottom: 180px;
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

        .confirm-payment-bottom {
            position: absolute;
            bottom: 100px;
            left: 50%;
            transform: translateX(-50%);
            background-color: #800000;
            color: white;
            padding: 24px 48px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-size: 18px;
            font-weight: bold;
            transition: background-color 0.3s;
            height: auto;
            line-height: 1;
        }

        .confirm-payment-bottom:hover {
            background-color: #600000;
        }

        .student-info-section {
            margin: 20px 0;
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 5px;
            border: 1px solid #e9ecef;
        }

        .student-info-title {
            color: #800000;
            font-size: 18px;
            margin-bottom: 15px;
            font-weight: bold;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="confirmation-container">
        <a href="javascript:history.back()" class="back-button back-button-corner">
            Back
        </a>

        <div class="success-icon">📋</div>
        <h1 class="confirmation-title">Review Payment</h1>
        
        <div class="payment-details">
            <c:if test="${not empty payment.paymentNumber && payment.paymentStatus != 'PENDING'}">
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
            
            <c:if test="${payment.type.name() == 'ENROLLMENT'}">
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
                <span class="detail-value amount">₱<fmt:formatNumber value="${payment.amount}" pattern="#,##0.00"/></span>
            </div>
            
            <c:if test="${not empty payment.createdAt && payment.paymentStatus != 'PENDING'}">
                <div class="detail-row">
                    <span class="detail-label">Date:</span>
                    <span class="detail-value">
                        <fmt:formatDate value="${payment.createdAt}" pattern="MMMM dd, yyyy hh:mm a"/>
                    </span>
                </div>
            </c:if>
            
            <c:if test="${payment.paymentStatus != 'PENDING'}">
                <div class="detail-row">
                    <span class="detail-label">Status:</span>
                    <span class="detail-value ${payment.paymentStatus == 'PROCESSED' ? 'status-processed' : 'status-pending'}">
                        ${payment.paymentStatus}
                    </span>
                </div>
            </c:if>
        </div>

        <c:if test="${not empty queueNumber}">
            <div>
                <h2>Your Queue Number</h2>
                <div class="queue-number">${queueNumber}</div>
                <p>Please wait for your number to be called</p>
            </div>
        </c:if>

        <a href="${pageContext.request.contextPath}/kiosk" class="home-button kiosk-button-corner">
            Back to Kiosk
        </a>

        <%-- Debug payment status --%>
        <%-- <div>Debug - Payment Status: ${payment.paymentStatus}</div> --%>

        <button onclick="confirmPayment('${payment.transactionReference}')" class="confirm-payment-bottom">
            CONFIRM PAYMENT
        </button>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Check if payment is processed
            const paymentStatus = '${payment.paymentStatus}';
            const transactionRef = '${payment.transactionReference}';
            console.log('Payment Status:', paymentStatus); // Debug log
            console.log('Transaction Reference:', transactionRef); // Debug log
            
            if (paymentStatus === 'PROCESSED') {
                // Hide confirm button if payment is processed
                const confirmButton = document.querySelector('.confirm-payment-bottom');
                if (confirmButton) {
                    confirmButton.style.display = 'none';
                }
                
                // Trigger receipt download
                window.location.href = '${pageContext.request.contextPath}/kiosk/payment/' + transactionRef + '/download-receipt';
                
                // Show success message
                setTimeout(function() {
                    alert('Your receipt has been downloaded. Please keep it for your records.');
                }, 1000);
            }
        });

        function confirmPayment(transactionRef) {
            if (!transactionRef) {
                console.error('Transaction Reference is missing');
                alert('Error: Transaction Reference is missing');
                return;
            }

            // Show loading indicator
            const confirmButton = document.querySelector('.confirm-payment-bottom');
            if (confirmButton) {
                confirmButton.disabled = true;
                confirmButton.textContent = 'Processing...';
            }

            if (confirm('Are you sure you want to confirm this payment?')) {
                const token = "${_csrf.token}";
                const header = "${_csrf.headerName}";
                
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
                    console.log('Payment confirmation response:', data); // Debug log
                    
                    if (data.success) {
                        // Create notification
                        const amount = document.querySelector('.amount').textContent.replace('₱', '').trim();
                        fetch('${pageContext.request.contextPath}/notifications', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json',
                                [header]: token
                            },
                            body: JSON.stringify({
                                transactionRef: transactionRef,
                                amount: parseFloat(amount.replace(/,/g, '')),
                                status: 'PENDING'
                            })
                        });

                        // Update payment status section
                        const statusContainer = document.createElement('div');
                        statusContainer.className = 'detail-row';
                        statusContainer.innerHTML = `
                            <span class="detail-label">Status:</span>
                            <span class="detail-value status-pending">PENDING</span>
                        `;
                        
                        // Find the amount row to insert the status after it
                        const amountRow = document.querySelector('.detail-row:has(.amount)');
                        if (amountRow) {
                            amountRow.after(statusContainer);
                        }
                        
                        // Add queue number if provided
                        if (data.queueNumber) {
                            const queueDiv = document.createElement('div');
                            queueDiv.className = 'queue-info';
                            queueDiv.innerHTML = `
                                <h2>Your Queue Number</h2>
                                <div class="queue-number">${data.queueNumber}</div>
                                <p>Please wait for your number to be called</p>
                                <p class="estimated-time">Estimated wait time: ${data.estimatedWaitTime} minutes</p>
                            `;
                            document.querySelector('.payment-details').after(queueDiv);
                        }
                        
                        // Hide confirm button
                        if (confirmButton) {
                            confirmButton.style.display = 'none';
                        }
                        
                        // Show success message with queue information
                        const message = `Payment confirmed and pending manager approval.\n\nYour queue number is: ${data.queueNumber}\nEstimated wait time: ${data.estimatedWaitTime} minutes\n\nYour receipt will be available after approval.`;
                        alert(message);
                        
                        // Refresh the page after a short delay to show updated status
                        setTimeout(() => {
                            window.location.reload();
                        }, 2000);
                    } else {
                        // Re-enable button on error
                        if (confirmButton) {
                            confirmButton.disabled = false;
                            confirmButton.textContent = 'CONFIRM PAYMENT';
                        }
                        alert(data.error || 'Failed to confirm payment');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    // Re-enable button on error
                    if (confirmButton) {
                        confirmButton.disabled = false;
                        confirmButton.textContent = 'CONFIRM PAYMENT';
                    }
                    alert('Failed to confirm payment. Please try again.');
                });
            } else {
                // Re-enable button if confirmation was cancelled
                if (confirmButton) {
                    confirmButton.disabled = false;
                    confirmButton.textContent = 'CONFIRM PAYMENT';
                }
            }
        }

        function cancelPayment(transactionRef) {
            if (confirm('Are you sure you want to cancel this payment?')) {
                fetch('${pageContext.request.contextPath}/kiosk/payment/cancel/' + transactionRef, {
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
    </script>
</body>
</html> 