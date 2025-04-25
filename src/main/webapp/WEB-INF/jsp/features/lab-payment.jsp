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
    <title>Laboratory Payment</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/payment-forms.css">
    <script src="${pageContext.request.contextPath}/static/js/payment-autofill.js"></script>
</head>
<body>
    <div class="payment-form-container">
        <div class="payment-form-header">
            <h1 class="payment-form-title">Laboratory Payment</h1>
        </div>

        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>

        <form class="payment-form" action="${pageContext.request.contextPath}/kiosk/payment/lab/process" method="post">
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
                    <label for="section">Section</label>
                    <input type="text" id="section" name="section" readonly>
                </div>
            </div>

            <div class="form-group">
                <label for="academicYear">Academic Year</label>
                <select id="academicYear" name="academicYear" required>
                    <option value="">Select Academic Year</option>
                </select>
            </div>

            <div class="form-group">
                <label for="semester">Semester</label>
                <select id="semester" name="semester" required>
                    <option value="">Select Semester</option>
                    <option value="FIRST">First Semester</option>
                    <option value="SECOND">Second Semester</option>
                    <option value="SUMMER">Summer</option>
                </select>
            </div>

            <div class="form-group">
                <label for="labType">Laboratory Type</label>
                <select id="labType" name="labType" required>
                    <option value="">Select Laboratory Type</option>
                    <option value="PHYSICS">Physics Laboratory</option>
                    <option value="BIOLOGY">Biology Laboratory</option>
                    <option value="COMPUTER">Computer Laboratory</option>
                    <option value="ENGINEERING">Engineering Laboratory</option>
                    <option value="ELECTRONICS">Electronics Laboratory</option>
                </select>
            </div>

            <div class="form-group">
                <label for="equipment">Equipment Package</label>
                <select id="equipment" name="equipment" required>
                    <option value="">Select Equipment Package</option>
                    <option value="BASIC">Basic Equipment Set</option>
                    <option value="ADVANCED">Advanced Equipment Set</option>
                    <option value="SPECIALIZED">Specialized Equipment Set</option>
                    <option value="NONE">No Equipment Needed</option>
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
                academicYear: true,
                semester: true,
                program: true,
                section: true,
                onVerificationSuccess: function(data) {
                    calculateLabFee();
                }
            });

            // Calculate fee when lab type or equipment changes
            document.getElementById('labType').addEventListener('change', calculateLabFee);
            document.getElementById('equipment').addEventListener('change', calculateLabFee);
        });

        function calculateLabFee() {
            const labType = document.getElementById('labType').value;
            const equipment = document.getElementById('equipment').value;
            let baseFee = 0;
            let equipmentFee = 0;

            // Lab type fees
            switch(labType) {
                case 'PHYSICS':
                    baseFee = 2000;
                    break;
                case 'BIOLOGY':
                    baseFee = 2500;
                    break;
                case 'COMPUTER':
                    baseFee = 1500;
                    break;
                case 'ENGINEERING':
                    baseFee = 3000;
                    break;
                case 'ELECTRONICS':
                    baseFee = 2500;
                    break;
            }

            // Equipment fees
            switch(equipment) {
                case 'BASIC':
                    equipmentFee = 500;
                    break;
                case 'ADVANCED':
                    equipmentFee = 1000;
                    break;
                case 'SPECIALIZED':
                    equipmentFee = 1500;
                    break;
                case 'NONE':
                    equipmentFee = 0;
                    break;
            }

            const totalFee = baseFee + equipmentFee;
            document.getElementById('amount').value = totalFee;
        }
    </script>
</body>
</html> 