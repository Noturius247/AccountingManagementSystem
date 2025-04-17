<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Laboratory Fee Payment - Accounting System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/static/css/main.css" rel="stylesheet" type="text/css">
</head>
<body>
    <div class="container">
        <div class="payment-form">
            <h2 class="text-center mb-4">Laboratory Fee Payment</h2>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>
            
            <form id="paymentForm" action="${pageContext.request.contextPath}/kiosk/payment/lab/process" method="post">
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
                        <option value="">Select Laboratory</option>
                        <option value="Computer">Computer Laboratory</option>
                        <option value="Science">Science Laboratory</option>
                        <option value="Chemistry">Chemistry Laboratory</option>
                        <option value="Physics">Physics Laboratory</option>
                    </select>
                </div>
                
                <div class="mb-3">
                    <label for="amount" class="form-label">Amount</label>
                    <input type="number" class="form-control" id="amount" name="amount" value="1500.00" step="0.01" required readonly>
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

        document.getElementById('labType').addEventListener('change', function() {
            const labType = this.value;
            let amount = 1500.00;
            
            switch(labType) {
                case 'Computer':
                    amount = 2000.00;
                    break;
                case 'Science':
                    amount = 1500.00;
                    break;
                case 'Chemistry':
                    amount = 1800.00;
                    break;
                case 'Physics':
                    amount = 1700.00;
                    break;
            }
            
            document.getElementById('amount').value = amount.toFixed(2);
        });
    </script>
</body>
</html> 