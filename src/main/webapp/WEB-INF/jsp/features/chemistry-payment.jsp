<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="context-path" content="${pageContext.request.contextPath}">
    <title>Chemistry Laboratory Payment</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/payment-forms.css">
</head>
<body>
    <div class="payment-form-container">
        <div class="payment-form-header">
            <h1 class="payment-form-title">Chemistry Laboratory Payment</h1>
        </div>

        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>

        <form class="payment-form" action="${pageContext.request.contextPath}/kiosk/payment/chemistry/process" method="post">
            <div class="form-group">
                <label for="studentId">Student ID</label>
                <input type="text" id="studentId" name="studentId" value="${studentId}" required>
                <div id="studentInfo" class="info-text"></div>
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
                <label for="section">Section</label>
                <input type="text" id="section" name="section" value="${section}" required>
            </div>

            <div class="form-group">
                <label for="yearLevel">Year Level</label>
                <input type="text" id="yearLevel" name="yearLevel" readonly>
            </div>

            <div class="form-group">
                <label for="program">Program</label>
                <input type="text" id="program" name="program" readonly>
            </div>

            <div class="form-group">
                <label for="labType">Laboratory Type</label>
                <select id="labType" name="labType" required>
                    <option value="">Select Laboratory Type</option>
                    <option value="GENERAL">General Chemistry</option>
                    <option value="ORGANIC">Organic Chemistry</option>
                    <option value="ANALYTICAL">Analytical Chemistry</option>
                    <option value="PHYSICAL">Physical Chemistry</option>
                    <option value="BIOCHEMISTRY">Biochemistry</option>
                </select>
            </div>

            <div class="form-group">
                <label for="equipment">Equipment</label>
                <select id="equipment" name="equipment" required>
                    <option value="">Select Equipment</option>
                    <option value="BASIC">Basic Equipment Set</option>
                    <option value="ADVANCED">Advanced Equipment Set</option>
                    <option value="SPECIALIZED">Specialized Equipment Set</option>
                </select>
            </div>

            <div class="form-group amount-group">
                <label for="amount">Amount</label>
                <input type="number" id="amount" name="amount" value="${amount}" step="0.01" min="0" required readonly>
            </div>

            <button type="submit" class="btn-submit">Proceed to Payment</button>
        </form>

        <a href="${pageContext.request.contextPath}/kiosk" class="back-link">← Back to Kiosk</a>
    </div>

    <script src="${pageContext.request.contextPath}/static/js/payment-autofill.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Populate academic years
            const currentYear = new Date().getFullYear();
            const academicYearSelect = document.getElementById('academicYear');
            
            for(let i = 0; i < 5; i++) {
                const year = currentYear - i;
                const option = document.createElement('option');
                option.value = year + '-' + (year + 1);
                option.textContent = year + '-' + (year + 1);
                academicYearSelect.appendChild(option);
            }

            // Initialize student verification with autofill
            initStudentVerification({
                academicYear: true,
                semester: true,
                program: true,
                section: true,
                onVerificationSuccess: function(data) {
                    // Calculate initial fee if lab type and equipment are selected
                    const labType = document.getElementById('labType').value;
                    const equipment = document.getElementById('equipment').value;
                    if (labType && equipment) {
                        calculateLabFee();
                    }
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
                case 'GENERAL':
                    baseFee = 1500;
                    break;
                case 'ORGANIC':
                    baseFee = 2000;
                    break;
                case 'ANALYTICAL':
                    baseFee = 2500;
                    break;
                case 'PHYSICAL':
                    baseFee = 2000;
                    break;
                case 'BIOCHEMISTRY':
                    baseFee = 3000;
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
            }

            const totalFee = baseFee + equipmentFee;
            document.getElementById('amount').value = totalFee;
        }
    </script>
</body>
</html> 