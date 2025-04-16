<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${title} - Accounting System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .payment-form {
            max-width: 600px;
            margin: 2rem auto;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .error-message {
            color: #dc3545;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="payment-form">
            <h2 class="text-center mb-4">${title}</h2>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger error-message">
                    ${error}
                </div>
            </c:if>

            <form id="paymentForm" method="post" action="${actionUrl}">
                <div class="mb-3">
                    <label for="studentId" class="form-label">Student ID</label>
                    <input type="text" class="form-control" id="studentId" name="studentId" required>
                </div>

                <div class="mb-3">
                    <label for="studentName" class="form-label">Student Name</label>
                    <input type="text" class="form-control" id="studentName" name="studentName" readonly>
                </div>

                ${additionalFields}

                <div class="mb-3">
                    <label for="amount" class="form-label">Amount</label>
                    <input type="number" class="form-control" id="amount" name="amount" step="0.01" value="${amount}" required>
                </div>

                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-primary">Process Payment</button>
                    <a href="${pageContext.request.contextPath}/kiosk" class="btn btn-secondary">Back to Kiosk</a>
                </div>
            </form>
        </div>
    </div>

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