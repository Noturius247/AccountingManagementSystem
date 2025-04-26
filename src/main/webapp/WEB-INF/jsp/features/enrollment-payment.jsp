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
    <title>Enrollment Payment</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/payment-forms.css">
</head>
<body>
    <div class="payment-form-container">
        <div class="payment-form-header">
            <h1 class="payment-form-title">New Student Enrollment</h1>
        </div>

        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>

        <form class="payment-form" >
            <div class="form-group">
                <label for="fullName">Full Name</label>
                <input type="text" id="fullName" name="fullName" value="${fullName}" required 
                    placeholder="Enter your full name">
            </div>

            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" value="${email}" required 
                    placeholder="Enter your email address">
            </div>

            <div class="form-group">
                <label for="contactNumber">Contact Number</label>
                <input type="tel" id="contactNumber" name="contactNumber" value="${contactNumber}" required 
                    placeholder="Enter your contact number"
                    pattern="[0-9]{11}"
                    title="Please enter a valid 11-digit phone number">
            </div>

            <div class="form-group">
                <label for="program">Program</label>
                <select id="program" name="program" required>
                    <option value="">Select Program</option>
                    <option value="BSCS">Bachelor of Science in Computer Science</option>
                    <option value="BSIT">Bachelor of Science in Information Technology</option>
                    <option value="BSIS">Bachelor of Science in Information Systems</option>
                    <option value="BSCE">Bachelor of Science in Computer Engineering</option>
                </select>
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
                    <option value="1ST">First Semester</option>
                    <option value="2ND">Second Semester</option>
                    <option value="SUMMER">Summer</option>
                </select>
            </div>

            <div class="form-group amount-group">
                <label for="amount">Enrollment Fee</label>
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
            // Populate academic years
            const currentYear = new Date().getFullYear();
            const academicYearSelect = document.getElementById('academicYear');
            
            for(let i = 0; i < 2; i++) {
                const year = currentYear + i;
                const option = document.createElement('option');
                option.value = year + '-' + (year + 1);
                option.textContent = year + '-' + (year + 1);
                academicYearSelect.appendChild(option);
            }

            // Set enrollment fee based on program
            const programSelect = document.getElementById('program');
            programSelect.addEventListener('change', calculateEnrollmentFee);
        });

        function calculateEnrollmentFee() {
            const program = document.getElementById('program').value;
            let fee = 0;

            switch(program) {
                case 'BSCS':
                case 'BSIT':
                case 'BSIS':
                    fee = 3000;
                    break;
                case 'BSCE':
                    fee = 3500;
                    break;
                default:
                    fee = 3000;
            }

            document.getElementById('amount').value = fee;
        }
    </script>
</body>
</html> 