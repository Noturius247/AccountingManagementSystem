<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Accounting Management System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css">
    <style>
        :root {
            --primary-color: #800000; /* Maroon */
            --primary-dark: #600000;
            --secondary-color: #D4AF37; /* Gold */
            --secondary-light: #F4CF67;
            --text-color: #333333;
            --light-gray: #f8f9fa;
            --medium-gray: #6c757d;
            --border-color: #dee2e6;
            --error-color: #dc3545;
            --success-color: #198754;
        }
        
        body {
            background: linear-gradient(135deg, var(--primary-color) 0%, #A52A2A 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: var(--text-color);
        }
        
        .login-container {
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 450px;
            margin: 20px;
            position: relative;
            overflow: hidden;
            border: 1px solid var(--secondary-color);
        }
        
        .login-container::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
        }
        
        .login-header {
            text-align: center;
            margin-bottom: 35px;
            position: relative;
        }
        
        .login-header h1 {
            color: var(--primary-color);
            margin: 0;
            font-size: 28px;
            font-weight: 600;
        }
        
        .login-header .logo {
            margin-bottom: 20px;
            font-size: 48px;
            color: var(--secondary-color);
            background: var(--primary-color);
            width: 80px;
            height: 80px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        }
        
        .login-header p {
            color: var(--medium-gray);
            margin: 10px 0 0;
            font-size: 16px;
        }
        
        .form-group {
            margin-bottom: 24px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: var(--text-color);
            font-weight: 500;
            font-size: 15px;
        }
        
        .input-group {
            position: relative;
        }
        
        .input-icon {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--medium-gray);
        }
        
        .form-control {
            width: 100%;
            padding: 12px 12px 12px 40px;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            font-size: 16px;
            transition: all 0.3s;
            box-sizing: border-box;
        }
        
        .form-control:focus {
            border-color: var(--primary-color);
            outline: none;
            box-shadow: 0 0 0 3px rgba(128, 0, 0, 0.15);
        }
        
        .btn-login {
            width: 100%;
            padding: 14px;
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.3s;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
        }
        
        .btn-login:hover {
            background: var(--primary-dark);
        }
        
        .btn-login:disabled {
            background: var(--medium-gray);
            cursor: not-allowed;
        }
        
        .login-footer {
            text-align: center;
            margin-top: 25px;
            color: var(--medium-gray);
            font-size: 15px;
        }
        
        .login-footer a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
        }
        
        .login-footer a:hover {
            text-decoration: underline;
        }
        
        .alert {
            padding: 14px;
            margin-bottom: 20px;
            border-radius: 6px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .alert-danger {
            background-color: #f8d7da;
            border-left: 4px solid var(--error-color);
            color: #721c24;
        }
        
        .alert-success {
            background-color: #d1e7dd;
            border-left: 4px solid var(--success-color);
            color: #0f5132;
        }
        
        .password-input {
            position: relative;
        }
        
        .toggle-password {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            cursor: pointer;
            color: var(--medium-gray);
            padding: 0;
            font-size: 16px;
        }
        
        .toggle-password:hover {
            color: var(--text-color);
        }
        
        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 20px;
        }
        
        .checkbox-group input[type="checkbox"] {
            width: 18px;
            height: 18px;
            accent-color: var(--primary-color);
        }
        
        .links {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
            font-size: 14px;
        }
        
        .links a {
            color: var(--primary-color);
            text-decoration: none;
        }
        
        .links a:hover {
            text-decoration: underline;
        }
        
        .spinner {
            width: 20px;
            height: 20px;
            border: 2px solid rgba(255,255,255,0.3);
            border-radius: 50%;
            border-top-color: #fff;
            animation: spin 0.8s linear infinite;
        }
        
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
        
        .system-info {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid var(--border-color);
            font-size: 13px;
            color: var(--medium-gray);
        }
        
        .accounting-graphic {
            display: flex;
            justify-content: center;
            margin-bottom: 25px;
        }
        
        .accounting-icon-group {
            display: flex;
            gap: 15px;
        }
        
        .accounting-icon {
            width: 40px;
            height: 40px;
            background: #FFF8E1;
            border: 1px solid var(--secondary-color);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--secondary-color);
            font-size: 20px;
        }
        
        .page-decoration {
            position: absolute;
            width: 200px;
            height: 200px;
            background: radial-gradient(circle, var(--secondary-light) 0%, transparent 70%);
            opacity: 0.1;
            z-index: -1;
        }
        
        .decoration-1 {
            top: -100px;
            right: -100px;
        }
        
        .decoration-2 {
            bottom: -100px;
            left: -100px;
        }

        /* Kiosk Access Button */
        .kiosk-access {
            position: fixed;
            bottom: 20px;
            left: 20px;
            background: var(--secondary-color);
            color: var(--primary-color);
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
            transition: all 0.3s ease;
            z-index: 1000;
            cursor: pointer;
            border: 2px solid var(--primary-color);
        }

        .kiosk-access:hover {
            background: var(--secondary-light);
            transform: scale(1.1);
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.3);
        }

        .kiosk-access i {
            font-size: 24px;
        }

        .kiosk-access .tooltip {
            position: absolute;
            right: 60px;
            background: var(--secondary-color);
            color: var(--primary-color);
            padding: 8px 12px;
            border-radius: 4px;
            font-size: 14px;
            white-space: nowrap;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
            border: 1px solid var(--primary-color);
            font-weight: 500;
        }

        .kiosk-access:hover .tooltip {
            opacity: 1;
            visibility: visible;
            right: 70px;
        }
    </style>
</head>
<body>
    <!-- Kiosk Access Button -->
    <a href="${pageContext.request.contextPath}/kiosk" class="kiosk-access">
        <i class="bi bi-display"></i>
        <span class="tooltip">Access Kiosk</span>
    </a>

    <div class="login-container">
        <div class="page-decoration decoration-1"></div>
        <div class="page-decoration decoration-2"></div>
        
        <div class="login-header">
            <div class="logo">
                <i class="fas fa-calculator"></i>
            </div>
            <h1>Accounting Management System</h1>
            <p>Enter your credentials to access the system</p>
        </div>
        
        <div class="accounting-graphic">
            <div class="accounting-icon-group">
                <div class="accounting-icon"><i class="fas fa-chart-pie"></i></div>
                <div class="accounting-icon"><i class="fas fa-file-invoice-dollar"></i></div>
                <div class="accounting-icon"><i class="fas fa-coins"></i></div>
                <div class="accounting-icon"><i class="fas fa-book"></i></div>
            </div>
        </div>

        <c:if test="${param.error != null}">
            <div class="alert alert-danger" id="errorMessage">
                <i class="fas fa-exclamation-circle"></i>
                Invalid username or password
            </div>
        </c:if>
        <c:if test="${param.logout != null}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                You have been logged out successfully
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <div class="form-group">
                <label for="username">Username</label>
                <div class="input-group">
                    <i class="fas fa-user input-icon"></i>
                    <input type="text" id="username" name="username" class="form-control" required>
                </div>
            </div>
            
            <div class="form-group">
                <label for="password">Password</label>
                <div class="password-input">
                    <i class="fas fa-lock input-icon"></i>
                    <input type="password" id="password" name="password" class="form-control" required>
                </div>
            </div>

            <div class="form-group">
                <button type="submit" class="btn-login">
                    <span>Sign In</span>
                </button>
            </div>
        </form>

        <div class="login-footer">
            <p>Don't have an account? <a href="${pageContext.request.contextPath}/register">Register here</a></p>
        </div>
        
        <div class="system-info">
            <p>Accounting Management System v3.5 | © 2025 Your Company</p>
            <p>Secure Enterprise Solution</p>
        </div>
    </div>

    <script>
        function togglePassword() {
            const passwordInput = document.getElementById('password');
            const toggleIcon = document.getElementById('toggleIcon');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                toggleIcon.classList.remove('fa-eye');
                toggleIcon.classList.add('fa-eye-slash');
            } else {
                passwordInput.type = 'password';
                toggleIcon.classList.remove('fa-eye-slash');
                toggleIcon.classList.add('fa-eye');
            }
        }

        function handleSubmit(event) {
            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value;
            const errorMessage = document.getElementById('errorMessage');
            const loadingIndicator = document.getElementById('loadingIndicator');
            const loginButton = document.getElementById('loginButton');
            const loginText = loginButton.querySelector('span');

            // Hide any existing error messages
            if (errorMessage) {
                errorMessage.style.display = 'none';
            }
            
            if (!username) {
                showError('Please enter your username');
                return false;
            }

            if (!password) {
                showError('Please enter your password');
                return false;
            }

            // Show loading state
            loadingIndicator.style.display = 'block';
            loginButton.disabled = true;
            loginText.textContent = 'Signing in...';

            return true;
        }
        
        function showError(message) {
            let errorMessage = document.getElementById('errorMessage');
            
            if (!errorMessage) {
                errorMessage = document.createElement('div');
                errorMessage.id = 'errorMessage';
                errorMessage.className = 'alert alert-danger';
                
                const icon = document.createElement('i');
                icon.className = 'fas fa-exclamation-circle';
                errorMessage.appendChild(icon);
                
                const text = document.createTextNode(' ' + message);
                errorMessage.appendChild(text);
                
                const form = document.querySelector('form');
                form.parentNode.insertBefore(errorMessage, form);
            } else {
                errorMessage.innerHTML = '<i class="fas fa-exclamation-circle"></i> ' + message;
                errorMessage.style.display = 'flex';
            }
        }

        // Clear error message when user starts typing
        document.getElementById('username').addEventListener('input', () => {
            const errorMessage = document.getElementById('errorMessage');
            if (errorMessage) {
                errorMessage.style.display = 'none';
            }
        });

        document.getElementById('password').addEventListener('input', () => {
            const errorMessage = document.getElementById('errorMessage');
            if (errorMessage) {
                errorMessage.style.display = 'none';
            }
        });

        // Check for error message from server
        const errorParam = new URLSearchParams(window.location.search).get('error');
        if (errorParam) {
            showError(decodeURIComponent(errorParam));
        }
    </script>
</body>
</html>