<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Registration Success</title>
    <link rel="stylesheet" href="/css/styles.css">
</head>
<body>
    <div class="container">
        <div class="success-message">
            <h2>Registration Successful!</h2>
            <p>Your Student ID is: <strong>${studentId}</strong></p>
            <p>Please keep this ID safe as you will need it for all student-related transactions.</p>
            
            <div class="actions">
                <a href="${pageContext.request.contextPath}/user/dashboard" class="btn btn-primary">Go to Dashboard</a>
                <a href="${pageContext.request.contextPath}/kiosk" class="btn btn-secondary">Go to Kiosk</a>
            </div>
        </div>
    </div>
</body>
</html> 