<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Laboratory Fee Payment</title>
    <style>
        .payment-form {
            max-width: 500px;
            margin: 0 auto;
            padding: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
        }
        input[type="text"],
        input[type="number"],
        select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        button {
            background-color: #4CAF50;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        button:hover {
            background-color: #45a049;
        }
        .error {
            color: red;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <div class="payment-form">
        <h2>Laboratory Fee Payment</h2>
        
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        
        <form action="/accounting/kiosk/payment/lab/process" method="post">
            <div class="form-group">
                <label for="studentId">Student ID:</label>
                <input type="text" id="studentId" name="studentId" required>
            </div>
            
            <div class="form-group">
                <label for="studentName">Student Name:</label>
                <input type="text" id="studentName" name="studentName" required>
            </div>
            
            <div class="form-group">
                <label for="labType">Laboratory Type:</label>
                <select id="labType" name="labType" required>
                    <option value="">Select Laboratory</option>
                    <option value="Computer">Computer Laboratory</option>
                    <option value="Science">Science Laboratory</option>
                    <option value="Chemistry">Chemistry Laboratory</option>
                    <option value="Physics">Physics Laboratory</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="amount">Amount:</label>
                <input type="number" id="amount" name="amount" value="1500.00" step="0.01" required>
            </div>
            
            <button type="submit">Process Payment</button>
        </form>
    </div>
</body>
</html> 