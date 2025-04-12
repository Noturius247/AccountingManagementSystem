<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Accounting Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .login-container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 400px;
            margin: 20px;
        }
        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .login-header h1 {
            color: #2c3e50;
            margin: 0;
            font-size: 28px;
        }
        .login-header p {
            color: #7f8c8d;
            margin: 10px 0 0;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #2c3e50;
            font-weight: 500;
        }
        .form-control {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            transition: border-color 0.3s;
        }
        .form-control:focus {
            border-color: #3498db;
            outline: none;
            box-shadow: 0 0 5px rgba(52,152,219,0.3);
        }
        .btn-login {
            width: 100%;
            padding: 12px;
            background: #3498db;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.3s;
        }
        .btn-login:hover {
            background: #2980b9;
        }
        .login-footer {
            text-align: center;
            margin-top: 20px;
            color: #7f8c8d;
        }
        .login-footer a {
            color: #3498db;
            text-decoration: none;
        }
        .login-footer a:hover {
            text-decoration: underline;
        }
        .error-message {
            color: #e74c3c;
            background: #fde8e8;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
            display: none;
        }
        .password-toggle {
            position: relative;
        }
        .password-toggle .toggle-icon {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #7f8c8d;
        }
        .remember-me {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }
        .remember-me input {
            margin-right: 8px;
        }
        .forgot-password {
            text-align: right;
            margin-bottom: 20px;
        }
        .forgot-password a {
            color: #3498db;
            text-decoration: none;
            font-size: 14px;
        }
        .forgot-password a:hover {
            text-decoration: underline;
        }
        .loading {
            display: none;
            text-align: center;
            margin-top: 10px;
        }
        .loading:after {
            content: '.';
            animation: dots 1s steps(5, end) infinite;
        }
        @keyframes dots {
            0%, 20% { content: '.'; }
            40% { content: '..'; }
            60% { content: '...'; }
            80%, 100% { content: ''; }
        }
        .spinner {
            width: 20px;
            height: 20px;
            border: 2px solid #f3f3f3;
            border-top: 2px solid #3498db;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin: 10px auto;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        .password-input {
            position: relative;
            display: flex;
            align-items: center;
        }
        .toggle-password {
            position: absolute;
            right: 10px;
            background: none;
            border: none;
            cursor: pointer;
            color: #666;
        }
        .toggle-password:hover {
            color: #333;
        }
        .alert {
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 4px;
        }
        .alert-danger {
            background-color: #f8d7da;
            border-color: #f5c6cb;
            color: #721c24;
        }
        .alert-success {
            background-color: #d4edda;
            border-color: #c3e6cb;
            color: #155724;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <h1>Accounting Management System</h1>
            <p>Please sign in to continue</p>
        </div>

        <c:if test="${param.error != null}">
            <div class="alert alert-danger" id="errorMessage">
                Invalid username or password
            </div>
        </c:if>
        <c:if test="${param.logout != null}">
            <div class="alert alert-success">
                You have been logged out successfully
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post" onsubmit="return handleSubmit(event);">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" class="form-control" required>
            </div>
            
            <div class="form-group">
                <label for="password">Password</label>
                <div class="password-input">
                    <input type="password" id="password" name="password" class="form-control" required>
                    <button type="button" onclick="togglePassword()" class="toggle-password">
                        <i class="fas fa-eye"></i>
                    </button>
                </div>
            </div>
            
            <div class="form-group">
                <label>
                    <input type="checkbox" name="remember-me"> Remember me
                </label>
            </div>

            <div class="form-group">
                <button type="submit" id="loginButton" class="btn btn-primary">Sign In</button>
                <div id="loadingIndicator" style="display: none;">
                    <div class="spinner"></div>
                </div>
            </div>
            
            <div class="links">
                <a href="${pageContext.request.contextPath}/forgot-password">Forgot Password?</a>
                <a href="${pageContext.request.contextPath}/register">Register</a>
            </div>
        </form>

        <div class="login-footer">
            Don't have an account? <a href="${pageContext.request.contextPath}/register">Register here</a>
        </div>
    </div>

    <script>
        function togglePassword() {
            const passwordInput = document.getElementById('password');
            passwordInput.type = passwordInput.type === 'password' ? 'text' : 'password';
        }

        function handleSubmit(event) {
            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value;
            const errorMessage = document.getElementById('errorMessage');
            const loadingIndicator = document.getElementById('loadingIndicator');
            const loginButton = document.getElementById('loginButton');

            errorMessage.style.display = 'none';
            
            if (!username) {
                errorMessage.textContent = 'Please enter your username';
                errorMessage.style.display = 'block';
                return false;
            }

            if (!password) {
                errorMessage.textContent = 'Please enter your password';
                errorMessage.style.display = 'block';
                return false;
            }

            // Show loading state
            loadingIndicator.style.display = 'block';
            loginButton.disabled = true;
            loginButton.textContent = 'Signing in...';

            return true;
        }

        // Clear error message when user starts typing
        document.getElementById('username').addEventListener('input', () => {
            document.getElementById('errorMessage').style.display = 'none';
        });

        document.getElementById('password').addEventListener('input', () => {
            document.getElementById('errorMessage').style.display = 'none';
        });

        // Check for error message from server
        const errorParam = new URLSearchParams(window.location.search).get('error');
        if (errorParam) {
            document.getElementById('errorMessage').textContent = decodeURIComponent(errorParam);
            document.getElementById('errorMessage').style.display = 'block';
        }
    </script>
</body>
</html> 