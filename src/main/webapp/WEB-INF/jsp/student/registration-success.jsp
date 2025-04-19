<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registration Success - Accounting System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/static/css/main.css" rel="stylesheet">
    <style>
        .success-container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 2rem;
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            text-align: center;
        }

        .success-icon {
            font-size: 4rem;
            color: var(--success-color);
            margin-bottom: 1.5rem;
        }

        .success-header h1 {
            color: var(--success-color);
            margin-bottom: 1rem;
        }

        .success-header p {
            color: var(--secondary-color);
            margin-bottom: 2rem;
        }

        .student-id-card {
            background: var(--light-color);
            border-radius: 10px;
            padding: 2rem;
            margin: 2rem 0;
            border: 2px solid var(--primary-color);
        }

        .student-id-card h2 {
            color: var(--primary-color);
            margin-bottom: 1rem;
        }

        .student-id {
            font-size: 2rem;
            font-weight: bold;
            color: var(--dark-color);
            background: white;
            padding: 1rem;
            border-radius: 5px;
            margin: 1rem 0;
            display: inline-block;
        }

        .next-steps {
            text-align: left;
            margin: 2rem 0;
        }

        .next-steps h3 {
            color: var(--primary-color);
            margin-bottom: 1rem;
        }

        .step-item {
            display: flex;
            align-items: flex-start;
            margin-bottom: 1rem;
        }

        .step-number {
            background: var(--primary-color);
            color: white;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 1rem;
            flex-shrink: 0;
        }

        .step-content {
            flex-grow: 1;
        }

        .step-content h4 {
            color: var(--dark-color);
            margin-bottom: 0.5rem;
        }

        .step-content p {
            color: var(--secondary-color);
            margin: 0;
        }

        .action-buttons {
            margin-top: 2rem;
        }

        .btn {
            padding: 0.75rem 2rem;
            font-weight: 500;
            margin: 0 0.5rem;
        }

        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .btn-primary:hover {
            background-color: var(--primary-dark);
            border-color: var(--primary-dark);
        }

        .btn-secondary {
            background-color: var(--secondary-color);
            border-color: var(--secondary-color);
        }

        .btn-secondary:hover {
            background-color: var(--secondary-dark);
            border-color: var(--secondary-dark);
        }
    </style>
</head>
<body>
    <div class="success-container">
        <div class="success-icon">
            <i class="bi bi-check-circle-fill"></i>
        </div>
        
        <div class="success-header">
            <h1>Registration Successful!</h1>
            <p>Welcome to the Accounting Management System</p>
        </div>

        <div class="student-id-card">
            <h2>Your Student ID</h2>
            <div class="student-id">${studentId}</div>
            <p class="text-muted">Please keep this ID safe as you will need it for all student-related transactions.</p>
        </div>

        <div class="next-steps">
            <h3>Next Steps</h3>
            
            <div class="step-item">
                <div class="step-number">1</div>
                <div class="step-content">
                    <h4>Access Your Dashboard</h4>
                    <p>View your academic information, payment history, and more</p>
                </div>
            </div>
            
            <div class="step-item">
                <div class="step-number">2</div>
                <div class="step-content">
                    <h4>Visit the Kiosk</h4>
                    <p>Make payments for tuition, library fees, and other services</p>
                </div>
            </div>
            
            <div class="step-item">
                <div class="step-number">3</div>
                <div class="step-content">
                    <h4>Download Documents</h4>
                    <p>Access your receipts, certificates, and other important documents</p>
                </div>
            </div>
        </div>

        <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary">
                <i class="bi bi-speedometer2"></i> Go to Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/kiosk" class="btn btn-secondary">
                <i class="bi bi-display"></i> Visit Kiosk
            </a>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 