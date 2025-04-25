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
    <title>Library Payment</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/payment-forms.css">
    <script src="${pageContext.request.contextPath}/static/js/payment-autofill.js"></script>
</head>
<body>
    <div class="payment-form-container">
        <div class="payment-form-header">
            <h1 class="payment-form-title">Library Payment</h1>
        </div>

        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>

        <form class="payment-form" action="${pageContext.request.contextPath}/kiosk/payment/library/process" method="post">
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
                <label for="feeType">Fee Type</label>
                <select id="feeType" name="feeType" required>
                    <option value="">Select Fee Type</option>
                    <option value="OVERDUE">Overdue Book</option>
                    <option value="LOST">Lost Book</option>
                    <option value="DAMAGED">Damaged Book</option>
                    <option value="MEMBERSHIP">Library Membership</option>
                </select>
            </div>

            <div class="form-group">
                <label for="description">Description</label>
                <textarea id="description" name="description" rows="3">${description}</textarea>
                <small class="help-text">Please provide details about the fee (e.g., book title, days overdue)</small>
            </div>

            <div class="form-group amount-group">
                <label for="amount">Amount</label>
                <div class="amount-input">
                    <span class="peso-sign">₱</span>
                    <input type="number" id="amount" name="amount" value="${amount}" step="0.01" min="0" required>
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
                    // Set initial amount based on fee type if selected
                    const feeType = document.getElementById('feeType').value;
                    if (feeType) {
                        setDefaultAmount(feeType);
                    }
                }
            });

            // Set default amount based on fee type
            document.getElementById('feeType').addEventListener('change', function() {
                setDefaultAmount(this.value);
            });
        });

        function setDefaultAmount(feeType) {
            let defaultAmount = 0;

            switch(feeType) {
                case 'OVERDUE':
                    defaultAmount = 50; // Per day
                    break;
                case 'LOST':
                    defaultAmount = 1000; // Base fee for lost book
                    break;
                case 'DAMAGED':
                    defaultAmount = 500; // Base fee for damaged book
                    break;
                case 'MEMBERSHIP':
                    defaultAmount = 200; // Annual membership fee
                    break;
            }

            document.getElementById('amount').value = defaultAmount;
        }
    </script>
</body>
</html> 