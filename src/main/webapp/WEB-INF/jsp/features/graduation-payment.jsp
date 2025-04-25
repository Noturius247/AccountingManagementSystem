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
    <title>Graduation Payment</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/payment-forms.css">
    <script src="${pageContext.request.contextPath}/static/js/payment-autofill.js"></script>
</head>
<body>
    <div class="payment-form-container">
        <div class="payment-form-header">
            <h1 class="payment-form-title">Graduation Payment</h1>
        </div>

        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>

        <form class="payment-form" action="${pageContext.request.contextPath}/kiosk/payment/graduation/process" method="post">
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
                <label for="graduationType">Graduation Type</label>
                <select id="graduationType" name="graduationType" required>
                    <option value="">Select Graduation Type</option>
                    <option value="REGULAR">Regular Graduation</option>
                    <option value="SUMMER">Summer Graduation</option>
                    <option value="SPECIAL">Special Graduation</option>
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
                    // Set initial amount based on graduation type if selected
                    const graduationType = document.getElementById('graduationType').value;
                    if (graduationType) {
                        calculateAmount(graduationType);
                    }
                }
            });

            // Calculate amount when graduation type changes
            document.getElementById('graduationType').addEventListener('change', function() {
                calculateAmount(this.value);
            });
        });

        function calculateAmount(graduationType) {
            let amount = 0;
            switch(graduationType) {
                case 'REGULAR':
                    amount = 3000;
                    break;
                case 'SUMMER':
                    amount = 3500;
                    break;
                case 'SPECIAL':
                    amount = 4000;
                    break;
            }
            document.getElementById('amount').value = amount;
        }
    </script>
</body>
</html> 