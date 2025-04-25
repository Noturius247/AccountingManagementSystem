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

        .cancel-button-corner {
            position: absolute;
            top: 20px;
            right: 20px;
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

        .cancel-button-corner:hover {
            background-color: #c82333;
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

        <button onclick="cancelPayment('${payment.transactionReference}')" class="cancel-button-corner">
            Cancel
        </button>

        <div class="success-icon">📋</div>
        <h1 class="confirmation-title">Review Payment</h1>
        
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
            <div>
                <h2>Your Queue Number</h2>
                <div class="queue-number">${queueNumber}</div>
                <p>Please wait for your number to be called</p>
                <p class="estimated-time">Estimated wait time: ${estimatedWaitTime} minutes</p>
            </div>
        </c:if>

        <a href="${pageContext.request.contextPath}/kiosk" class="home-button kiosk-button-corner">
            Back to Kiosk
        </a>

        <%-- Debug payment status --%>
        <%-- <div>Debug - Payment Status: ${payment.paymentStatus}</div> --%>

        <button onclick="confirmPayment('${payment.transactionReference}')" class="confirm-payment-bottom" id="confirmPaymentButton">
            CONFIRM PAYMENT
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
                if (wasConfirmed || isProcessing) {
                    confirmButton.style.display = 'none';
                    
                    if (isProcessing) {
                        // Show processing indicator
                        const processingDiv = document.createElement('div');
                        processingDiv.style.cssText = `
                            position: absolute;
                            bottom: 100px;
                            left: 50%;
                            transform: translateX(-50%);
                            color: #800000;
                            font-size: 18px;
                            font-weight: bold;
                        `;
                        processingDiv.textContent = 'Processing Payment...';
                        confirmButton.parentNode.appendChild(processingDiv);
                    }
                } else {
                    confirmButton.style.display = 'block';
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

        function confirmPayment(transactionRef) {
            if (!transactionRef) {
                console.error('Transaction Reference is missing');
                alert('Error: Transaction Reference is missing');
                return;
            }

            const confirmButton = document.getElementById('confirmPaymentButton');
            if (confirmButton) {
                // Immediately hide and disable the button
                confirmButton.style.display = 'none';
                confirmButton.disabled = true;
                
                // Set processing state
                sessionStorage.setItem('processing_' + transactionRef, 'true');
                
                // Create and show a processing indicator
                const processingDiv = document.createElement('div');
                processingDiv.style.cssText = `
                    position: absolute;
                    bottom: 100px;
                    left: 50%;
                    transform: translateX(-50%);
                    color: #800000;
                    font-size: 18px;
                    font-weight: bold;
                `;
                processingDiv.textContent = 'Processing Payment...';
                confirmButton.parentNode.appendChild(processingDiv);
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
                    
                    if (data.success || data.message) {
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
                        
                        const message = `Payment confirmed and pending manager approval.\n\nYour queue number is: ${data.queueNumber}\nEstimated wait time: ${data.estimatedWaitTime} minutes\n\nYour receipt will be available after approval.`;
                        alert(message);
                        
                        // Keep the button hidden but don't reload the page
                        const processingDiv = document.querySelector('div:last-child');
                        if (processingDiv && processingDiv.textContent === 'Processing Payment...') {
                            processingDiv.remove();
                        }
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    // On error, restore the button
                    if (confirmButton) {
                        confirmButton.style.display = 'block';
                        confirmButton.disabled = false;
                        sessionStorage.removeItem('confirmed_' + transactionRef);
                        sessionStorage.removeItem('processing_' + transactionRef);
                        // Remove processing indicator if it exists
                        const processingDiv = confirmButton.parentNode.querySelector('div:last-child');
                        if (processingDiv) {
                            processingDiv.remove();
                        }
                    }
                });
            } else {
                // If user cancels, restore the button
                if (confirmButton) {
                    confirmButton.style.display = 'block';
                    confirmButton.disabled = false;
                    sessionStorage.removeItem('confirmed_' + transactionRef);
                    sessionStorage.removeItem('processing_' + transactionRef);
                    // Remove processing indicator if it exists
                    const processingDiv = confirmButton.parentNode.querySelector('div:last-child');
                    if (processingDiv) {
                        processingDiv.remove();
                    }
                }
            }
        }

        function cancelPayment(transactionRef) {
            if (!transactionRef) {
                console.error('Transaction Reference is missing');
                alert('Error: Transaction Reference is missing');
                return;
            }

            if (confirm('Are you sure you want to cancel this payment?')) {
                const token = "${_csrf.token}";
                const header = "${_csrf.headerName}";

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
                        alert('Payment cancelled successfully');
                        window.location.href = '${pageContext.request.contextPath}/kiosk';
                    } else {
                        alert(data.error || 'Failed to cancel payment');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Failed to cancel payment. Please try again.');
                });
            }
        }
    </script>
</body>
</html> 