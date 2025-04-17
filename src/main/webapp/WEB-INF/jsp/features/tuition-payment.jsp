<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tuition Payment - School Payment Kiosk</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/static/css/main.css" rel="stylesheet">
    <style>
        .container {
            max-width: 800px;
            margin: var(--spacing-lg) auto;
            background: white;
            padding: var(--spacing-lg);
            border-radius: var(--border-radius-md);
            box-shadow: var(--shadow-md);
        }
        .header {
            text-align: center;
            margin-bottom: var(--spacing-lg);
        }
        .header h1 {
            color: var(--primary-color);
            margin-bottom: var(--spacing-sm);
            font-weight: 600;
        }
        .header p {
            color: var(--dark-color);
        }
        .form-group {
            margin-bottom: var(--spacing-md);
        }
        label {
            display: block;
            margin-bottom: var(--spacing-xs);
            color: var(--dark-color);
            font-weight: 500;
        }
        .input-field {
            width: 100%;
            padding: var(--spacing-sm);
            border: 2px solid rgba(0, 0, 0, 0.1);
            border-radius: var(--border-radius-sm);
            font-size: var(--font-size-base);
            transition: var(--transition-base);
        }
        .input-field:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(128, 0, 0, 0.25);
        }
        .required {
            color: var(--danger-color);
            margin-left: 3px;
        }
        .back-btn {
            background: none;
            border: none;
            color: var(--primary-color);
            cursor: pointer;
            font-size: var(--font-size-base);
            display: flex;
            align-items: center;
            gap: var(--spacing-xs);
            margin-bottom: var(--spacing-md);
            transition: var(--transition-base);
        }
        .back-btn:hover {
            color: var(--secondary-color);
        }
        .submit-btn {
            width: 100%;
            padding: var(--spacing-sm);
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: var(--border-radius-sm);
            font-size: var(--font-size-base);
            cursor: pointer;
            transition: var(--transition-base);
            margin-top: var(--spacing-md);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: var(--spacing-xs);
        }
        .submit-btn:hover {
            background: var(--secondary-color);
            color: var(--primary-color);
        }
        .input-group {
            position: relative;
            display: flex;
            align-items: center;
        }
        .input-prefix {
            position: absolute;
            left: var(--spacing-sm);
            color: var(--dark-color);
            font-weight: 500;
        }
        .input-group .input-field {
            padding-left: calc(var(--spacing-sm) * 2);
        }
        .form-text {
            font-size: 0.85em;
            color: var(--dark-color);
            margin-top: var(--spacing-xs);
        }
        .alert {
            padding: var(--spacing-sm);
            border-radius: var(--border-radius-sm);
            margin-bottom: var(--spacing-md);
            display: flex;
            align-items: center;
            gap: var(--spacing-xs);
        }
        .alert-danger {
            background-color: var(--danger-color);
            color: white;
        }
        .alert i {
            font-size: 1.1em;
        }
    </style>
</head>
<body>
    <div class="container">
        <button class="back-btn" onclick="window.history.back()">
            <i class="bi bi-arrow-left"></i> Back to Services
        </button>
        
        <div class="header">
            <h1>Tuition Payment</h1>
            <p>Please fill in the required information</p>
        </div>

        <form id="tuitionForm" action="${pageContext.request.contextPath}/kiosk/payment/tuition/process" method="POST">
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="bi bi-exclamation-circle"></i> ${error}
                </div>
            </c:if>
            
            <div class="form-group">
                <label>Student ID<span class="required">*</span></label>
                <input type="text" class="input-field" name="studentId" required 
                       placeholder="Enter your student ID" value="${studentId}">
            </div>

            <div class="form-group">
                <label>Student Name<span class="required">*</span></label>
                <input type="text" class="input-field" name="studentName" required 
                       placeholder="Enter your full name" value="${studentName}">
            </div>

            <div class="form-group">
                <label>Course/Program<span class="required">*</span></label>
                <input type="text" class="input-field" name="program" required 
                       placeholder="Enter your course or program" value="${program}">
            </div>

            <div class="form-group">
                <label>Year Level<span class="required">*</span></label>
                <input type="number" class="input-field" name="yearLevel" required 
                       min="1" max="5" placeholder="Enter your year level" value="${yearLevel}">
            </div>

            <div class="form-group">
                <label>Semester<span class="required">*</span></label>
                <select class="input-field" name="semester" required>
                    <option value="">Select semester</option>
                    <option value="1" ${semester == 1 ? 'selected' : ''}>First Semester</option>
                    <option value="2" ${semester == 2 ? 'selected' : ''}>Second Semester</option>
                    <option value="3" ${semester == 3 ? 'selected' : ''}>Summer</option>
                </select>
            </div>

            <div class="form-group">
                <label>Academic Year<span class="required">*</span></label>
                <input type="text" class="input-field" name="academicYear" required 
                       placeholder="Example: 2023-2024" value="${academicYear}">
            </div>

            <div class="form-group">
                <label>Payment Amount<span class="required">*</span></label>
                <div class="input-group">
                    <span class="input-prefix">₱</span>
                    <input type="number" class="input-field" name="amount" required 
                           min="0" step="0.01" placeholder="Enter payment amount"
                           value="${empty amount ? '25000.00' : amount}">
                </div>
                <small class="form-text">Default amount: ₱25,000.00</small>
            </div>

            <button type="submit" class="submit-btn">
                <i class="bi bi-check-circle"></i>Proceed to Payment
            </button>
        </form>
    </div>
</body>
</html> 