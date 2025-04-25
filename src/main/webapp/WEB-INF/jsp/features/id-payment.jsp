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
    <title>ID Card Payment</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/payment-forms.css">
    <script src="${pageContext.request.contextPath}/static/js/payment-autofill.js"></script>
</head>
<body>
    <div class="payment-form-container">
        <div class="payment-form-header">
            <h1 class="payment-form-title">ID Card Payment</h1>
        </div>

        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>

        <form class="payment-form" action="${pageContext.request.contextPath}/kiosk/payment/id/process" method="post">
            <div class="form-group">
                <label for="studentId">Student ID</label>
                <input type="text" id="studentId" name="studentId" value="${studentId}" required>
            </div>

            <div id="studentInfo" style="display: none;">
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
            </div>

            <div class="form-group">
                <label for="reason">Reason for ID Request</label>
                <select id="reason" name="reason" required>
                    <option value="">Select Reason</option>
                    <option value="NEW">New Student</option>
                    <option value="LOST">Lost ID</option>
                    <option value="DAMAGED">Damaged ID</option>
                    <option value="RENEWAL">Annual Renewal</option>
                </select>
            </div>

            <div class="form-group amount-group">
                <label for="amount">Amount</label>
                <div class="amount-input">
                    <span class="peso-sign">₱</span>
                    <input type="number" id="amount" name="amount" value="${amount}" step="0.01" min="0" required readonly>
                </div>
            </div>

            <button type="submit" class="btn-submit">Proceed to Payment</button>
        </form>

        <a href="${pageContext.request.contextPath}/kiosk" class="back-link">← Back to Kiosk</a>
    </div>

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
                    // Set initial amount based on reason if selected
                    const reason = document.getElementById('reason').value;
                    if (reason) {
                        calculateAmount(reason);
                    }
                }
            });

            // Calculate amount when reason changes
            document.getElementById('reason').addEventListener('change', function() {
                calculateAmount(this.value);
            });
        });

        function calculateAmount(reason) {
            let amount = 0;
            switch(reason) {
                case 'NEW':
                    amount = 150;
                    break;
                case 'LOST':
                    amount = 200;
                    break;
                case 'DAMAGED':
                    amount = 175;
                    break;
                case 'RENEWAL':
                    amount = 100;
                    break;
            }
            document.getElementById('amount').value = amount;
        }
    </script>
</body>
</html> 