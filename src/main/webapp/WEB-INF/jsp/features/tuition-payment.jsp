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
    <title>Tuition Payment</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/payment-forms.css">
    <style>
        .loading {
            margin: 5px 0;
            color: #666;
        }
        .error-message {
            color: #dc3545;
            margin: 5px 0;
            padding: 5px;
            border-radius: 4px;
        }
        .info-text {
            margin: 10px 0;
            padding: 10px;
            border-radius: 4px;
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
        }
        .info-text.success {
            background-color: #d4edda;
            border-color: #c3e6cb;
            color: #155724;
        }
        .student-info-container {
            margin-bottom: 20px;
        }
        .hidden-input {
            display: none;
        }
    </style>
</head>
<body>
    <div class="payment-form-container">
        <div class="payment-form-header">
            <h1 class="payment-form-title">Tuition Payment</h1>
        </div>

        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>

        <form class="payment-form" action="${pageContext.request.contextPath}/kiosk/payment/tuition/process" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            
            <div class="form-group">
                <label for="studentId">Student ID</label>
                <input type="text" id="studentId" name="studentId" value="${studentId}" required 
                    pattern="^\d{4}-[A-Z]{3}\d{3}$" 
                    placeholder="e.g., 2023-ABC123"
                    title="Please enter a valid Student ID (e.g., 2023-ABC123)">
            </div>

            <div class="student-info-container">
                <div id="studentInfo" class="info-text"></div>
            </div>

            <!-- Hidden inputs to store student data -->
            <input type="hidden" id="studentName" name="studentName">
            <input type="hidden" id="program" name="program">
            <input type="hidden" id="yearLevel" name="yearLevel">
            <input type="hidden" id="section" name="section">

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

            <div class="form-group amount-group">
                <label for="amount">Amount</label>
                <input type="number" id="amount" name="amount" value="${amount}" step="0.01" min="0" required>
            </div>

            <div class="form-group">
                <label for="notes">Notes (Optional)</label>
                <input type="text" id="notes" name="notes" value="${notes}">
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
                yearLevel: true,
                onVerificationSuccess: function(data) {
                    // Set hidden input values
                    document.getElementById('studentName').value = data.fullName || '';
                    document.getElementById('program').value = data.program || '';
                    document.getElementById('yearLevel').value = data.yearLevel || '';
                    document.getElementById('section').value = data.section || '';
                    
                    // Set academic year and semester if available
                    if (data.academicYear) {
                        document.getElementById('academicYear').value = data.academicYear;
                    }
                    if (data.semester) {
                        document.getElementById('semester').value = data.semester;
                    }
                    
                    console.log('Student verification successful:', data);
                },
                onReset: function() {
                    // Reset all hidden inputs
                    document.getElementById('studentName').value = '';
                    document.getElementById('program').value = '';
                    document.getElementById('yearLevel').value = '';
                    document.getElementById('section').value = '';
                    
                    // Reset selects
                    document.getElementById('academicYear').value = '';
                    document.getElementById('semester').value = '';
                    
                    console.log('Form reset');
                }
            });
        });
    </script>
</body>
</html> 