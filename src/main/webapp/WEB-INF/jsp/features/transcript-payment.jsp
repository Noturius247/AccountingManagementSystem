<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="context-path" content="${pageContext.request.contextPath}">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <title>Transcript Payment</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/payment-forms.css">
</head>
<body>
    <div class="payment-form-container">
        <div class="payment-form-header">
            <h1 class="payment-form-title">Transcript Payment</h1>
        </div>

        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>

        <form class="payment-form" action="${pageContext.request.contextPath}/kiosk/payment/transcript/process" method="post">
            <div class="form-group">
                <label for="studentId">Student ID</label>
                <input type="text" id="studentId" name="studentId" value="${studentId}" required>
                <div id="studentInfo" class="info-text"></div>
            </div>

            <div class="form-group">
                <label for="program">Program</label>
                <input type="text" id="program" name="program" readonly>
            </div>

            <div class="form-group">
                <label for="yearLevel">Year Level</label>
                <input type="text" id="yearLevel" name="yearLevel" readonly>
            </div>

            <div class="form-group">
                <label for="section">Section</label>
                <input type="text" id="section" name="section" readonly>
            </div>

            <div class="form-group">
                <label for="copies">Number of Copies</label>
                <input type="number" id="copies" name="copies" value="${copies}" min="1" max="10" required>
                <small class="help-text">Maximum of 10 copies per request</small>
            </div>

            <div class="form-group">
                <label for="purpose">Purpose</label>
                <select id="purpose" name="purpose" required>
                    <option value="">Select Purpose</option>
                    <option value="EMPLOYMENT">Employment</option>
                    <option value="FURTHER_STUDIES">Further Studies</option>
                    <option value="BOARD_EXAM">Board Examination</option>
                    <option value="SCHOLARSHIP">Scholarship Application</option>
                    <option value="PERSONAL">Personal Use</option>
                </select>
            </div>

            <div class="form-group">
                <label for="deliveryMethod">Delivery Method</label>
                <select id="deliveryMethod" name="deliveryMethod" required>
                    <option value="">Select Delivery Method</option>
                    <option value="PICKUP">Personal Pick-up</option>
                    <option value="COURIER">Courier Delivery</option>
                    <option value="EXPRESS">Express Delivery</option>
                </select>
            </div>

            <div class="form-group amount-group">
                <label for="amount">Total Amount</label>
                <input type="number" id="amount" name="amount" value="${amount}" step="0.01" min="0" required readonly>
            </div>

            <button type="submit" class="btn-submit">Proceed to Payment</button>
        </form>

        <a href="${pageContext.request.contextPath}/kiosk" class="back-link">← Back to Kiosk</a>
    </div>

    <script src="${pageContext.request.contextPath}/static/js/payment-autofill.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize student verification with autofill
            initStudentVerification({
                academicYear: false,
                semester: false,
                program: true,
                section: true,
                yearLevel: true,
                onVerificationSuccess: function(data) {
                    // Additional custom logic if needed
                    calculateTotal();
                }
            });

            // Calculate total when any option changes
            document.getElementById('copies').addEventListener('change', calculateTotal);
            document.getElementById('deliveryMethod').addEventListener('change', calculateTotal);
        });

        function calculateTotal() {
            const copies = parseInt(document.getElementById('copies').value) || 0;
            const deliveryMethod = document.getElementById('deliveryMethod').value;
            const basePrice = 200; // Base price per copy
            let total = 0;

            // Calculate base total for copies
            total = copies * basePrice;

            // Add delivery fee
            switch(deliveryMethod) {
                case 'PICKUP':
                    // No additional fee
                    break;
                case 'COURIER':
                    total += 150; // Regular courier fee
                    break;
                case 'EXPRESS':
                    total += 300; // Express delivery fee
                    break;
            }

            document.getElementById('amount').value = total;
        }
    </script>
</body>
</html> 