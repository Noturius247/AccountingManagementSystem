<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Accounting Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            padding: 2rem;
            width: 100%;
            max-width: 400px;
        }
        .login-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        .login-header i {
            font-size: 3rem;
            color: #764ba2;
            margin-bottom: 1rem;
        }
        .form-control {
            border-radius: 8px;
            padding: 0.8rem;
            border: 1px solid #ddd;
            margin-bottom: 1rem;
        }
        .form-control:focus {
            border-color: #764ba2;
            box-shadow: 0 0 0 0.2rem rgba(118, 75, 162, 0.25);
        }
        .btn-login {
            background: #764ba2;
            border: none;
            border-radius: 8px;
            padding: 0.8rem;
            width: 100%;
            color: white;
            font-weight: 600;
            margin-top: 1rem;
            transition: all 0.3s ease;
        }
        .btn-login:hover {
            background: #667eea;
            transform: translateY(-2px);
        }
        .register-link {
            text-align: center;
            margin-top: 1.5rem;
        }
        .register-link a {
            color: #764ba2;
            text-decoration: none;
        }
        .register-link a:hover {
            color: #667eea;
            text-decoration: underline;
        }
        .alert {
            display: none;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <i class="fas fa-user-circle"></i>
            <h2>Welcome Back</h2>
            <p class="text-muted">Please login to your account</p>
        </div>
        
        <div class="alert alert-danger" id="errorAlert" role="alert">
            Invalid username or password
        </div>

        <form id="loginForm" onsubmit="return handleLogin(event)">
            <div class="mb-3">
                <label for="username" class="form-label">Username</label>
                <input type="text" class="form-control" id="username" required>
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" id="password" required>
            </div>
            <div class="mb-3 form-check">
                <input type="checkbox" class="form-check-input" id="rememberMe">
                <label class="form-check-label" for="rememberMe">Remember me</label>
            </div>
            <button type="submit" class="btn btn-login">Login</button>
        </form>

        <div class="register-link">
            <p>Don't have an account? <a href="register">Register here</a></p>
        </div>
    </div>

    <script>
        function handleLogin(event) {
            event.preventDefault();
            
            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;
            const rememberMe = document.getElementById('rememberMe').checked;
            const errorAlert = document.getElementById('errorAlert');

            // For demo purposes, accept any username/password
            if (username && password) {
                // Store in localStorage if remember me is checked
                if (rememberMe) {
                    localStorage.setItem('username', username);
                    localStorage.setItem('rememberMe', 'true');
                } else {
                    localStorage.removeItem('username');
                    localStorage.removeItem('rememberMe');
                }
                
                // Redirect to dashboard (we'll create this later)
                window.location.href = 'dashboard';
                return false;
            } else {
                errorAlert.style.display = 'block';
                return false;
            }
        }

        // Check for remembered username on page load
        window.onload = function() {
            const rememberedUsername = localStorage.getItem('username');
            const rememberMe = localStorage.getItem('rememberMe');
            
            if (rememberedUsername && rememberMe === 'true') {
                document.getElementById('username').value = rememberedUsername;
                document.getElementById('rememberMe').checked = true;
            }
        }
    </script>
</body>
</html> 