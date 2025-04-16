<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tuition Payment - School Payment Kiosk</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f2f5;
            padding: 20px;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        .header h1 {
            color: #333;
            margin-bottom: 10px;
        }
        .header p {
            color: #666;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
        }
        .input-field {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 5px;
            font-size: 1em;
            transition: border-color 0.2s;
        }
        .input-field:focus {
            outline: none;
            border-color: #2196F3;
        }
        .required {
            color: #e74c3c;
            margin-left: 3px;
        }
        .back-btn {
            background: none;
            border: none;
            color: #2196F3;
            cursor: pointer;
            font-size: 1em;
            display: flex;
            align-items: center;
            gap: 5px;
            margin-bottom: 20px;
        }
        .back-btn:hover {
            color: #1976D2;
        }
        .submit-btn {
            width: 100%;
            padding: 12px;
            background: #2196F3;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 1em;
            cursor: pointer;
            transition: background 0.2s;
            margin-top: 20px;
        }
        .submit-btn:hover {
            background: #1976D2;
        }
        .btn-icon {
            margin-right: 8px;
        }
        .input-group {
            position: relative;
            display: flex;
            align-items: center;
        }
        .input-prefix {
            position: absolute;
            left: 12px;
            color: #666;
            font-weight: 500;
        }
        .input-group .input-field {
            padding-left: 30px;
        }
        .form-text {
            font-size: 0.85em;
            color: #666;
            margin-top: 4px;
        }
        .alert {
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .alert-danger {
            background-color: #fee2e2;
            border: 1px solid #fecaca;
            color: #dc2626;
        }
        .alert i {
            font-size: 1.1em;
        }
    </style>
</head>
<body>
    <div class="container">
        <button class="back-btn" onclick="window.history.back()">
            <i class="fas fa-arrow-left"></i> Back to Services
        </button>
        
        <div class="header">
            <h1>Tuition Payment</h1>
            <p>Please fill in the required information</p>
        </div>

        <form id="tuitionForm" action="${pageContext.request.contextPath}/kiosk/payment/tuition/process" method="POST">
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i> ${error}
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
                <small class="form-text text-muted">Default amount: ₱25,000.00</small>
            </div>

            <button type="submit" class="submit-btn">
                <i class="fas fa-check btn-icon"></i>Proceed to Payment
            </button>
        </form>
    </div>
</body>
</html> 