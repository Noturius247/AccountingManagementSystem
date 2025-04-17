<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title} - Accounting System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/static/css/main.css" rel="stylesheet" type="text/css">
</head>
<body>
    <div class="container">
        <div class="payment-form">
            <h2 class="text-center mb-4">Chemistry Laboratory Fee Payment</h2>
            
            <form id="paymentForm" method="post" action="${pageContext.request.contextPath}/kiosk/payment/chemistry/process">
                <div class="mb-3">
                    <label for="studentId" class="form-label">Student ID</label>
                    <input type="text" class="form-control" id="studentId" name="studentId" required>
                </div>

                <div class="mb-3">
                    <label for="studentName" class="form-label">Student Name</label>
                    <input type="text" class="form-control" id="studentName" name="studentName" readonly>
                </div>

                <div class="mb-3">
                    <label for="labType" class="form-label">Laboratory Type</label>
                    <select class="form-control" id="labType" name="labType" required>
                        <option value="">Select Laboratory Type</option>
                        <option value="ORGANIC">Organic Chemistry Lab</option>
                        <option value="INORGANIC">Inorganic Chemistry Lab</option>
                        <option value="ANALYTICAL">Analytical Chemistry Lab</option>
                        <option value="PHYSICAL">Physical Chemistry Lab</option>
                    </select>
                </div>
                
                <div class="mb-3">
                    <label for="semester" class="form-label">Semester</label>
                    <select class="form-control" id="semester" name="semester" required>
                        <option value="">Select Semester</option>
                        <option value="1">First Semester</option>
                        <option value="2">Second Semester</option>
                        <option value="3">Summer</option>
                    </select>
                </div>
                
                <div class="mb-3">
                    <label for="academicYear" class="form-label">Academic Year</label>
                    <input type="text" class="form-control" id="academicYear" name="academicYear" 
                           placeholder="e.g., 2023-2024" required>
                </div>

                <div class="mb-3">
                    <label for="amount" class="form-label">Amount</label>
                    <input type="number" class="form-control" id="amount" name="amount" 
                           value="1500.00" step="0.01" required readonly>
                </div>

                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-primary">Process Payment</button>
                    <a href="${pageContext.request.contextPath}/kiosk" class="btn btn-secondary">Back to Kiosk</a>
                </div>
            </form>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.getElementById('studentId').addEventListener('change', function() {
            const studentId = this.value;
            fetch('${pageContext.request.contextPath}/kiosk/verify-student?studentId=' + studentId)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        document.getElementById('studentName').value = data.studentName;
                    } else {
                        alert(data.error);
                        document.getElementById('studentId').value = '';
                        document.getElementById('studentName').value = '';
                    }
                })
                .catch(error => console.error('Error:', error));
        });
    </script>
</body>
</html> 