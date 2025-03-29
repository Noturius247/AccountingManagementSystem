<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Accounting Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 0;
        }
        .register-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            padding: 2rem;
            width: 100%;
            max-width: 500px;
        }
        .register-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        .register-header i {
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
        .btn-register {
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
        .btn-register:hover {
            background: #667eea;
            transform: translateY(-2px);
        }
        .login-link {
            text-align: center;
            margin-top: 1.5rem;
        }
        .login-link a {
            color: #764ba2;
            text-decoration: none;
        }
        .login-link a:hover {
            color: #667eea;
            text-decoration: underline;
        }
        .alert {
            display: none;
            margin-bottom: 1rem;
        }
        .password-requirements {
            font-size: 0.85rem;
            color: #666;
            margin-top: 0.5rem;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-header">
            <i class="fas fa-user-plus"></i>
            <h2>Create Account</h2>
            <p class="text-muted">Join our accounting management system</p>
        </div>
        
        <div class="alert alert-danger" id="errorAlert" role="alert">
            Please fill in all required fields correctly
        </div>

        <form id="registerForm" onsubmit="return handleRegister(event)">
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="firstName" class="form-label">First Name</label>
                    <input type="text" class="form-control" id="firstName" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label for="lastName" class="form-label">Last Name</label>
                    <input type="text" class="form-control" id="lastName" required>
                </div>
            </div>
            
            <div class="mb-3">
                <label for="email" class="form-label">Email Address</label>
                <input type="email" class="form-control" id="email" required>
            </div>
            
            <div class="mb-3">
                <label for="username" class="form-label">Username</label>
                <input type="text" class="form-control" id="username" required>
            </div>
            
            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" id="password" required>
                <div class="password-requirements">
                    Password must be at least 8 characters long and contain at least one number
                </div>
            </div>
            
            <div class="mb-3">
                <label for="confirmPassword" class="form-label">Confirm Password</label>
                <input type="password" class="form-control" id="confirmPassword" required>
            </div>
            
            <div class="mb-3 form-check">
                <input type="checkbox" class="form-check-input" id="terms" required>
                <label class="form-check-label" for="terms">
                    I agree to the <a href="#" class="text-primary">Terms of Service</a> and <a href="#" class="text-primary">Privacy Policy</a>
                </label>
            </div>
            
            <button type="submit" class="btn btn-register">Create Account</button>
        </form>

        <div class="login-link">
            <p>Already have an account? <a href="login">Login here</a></p>
        </div>
    </div>

    <script>
        function handleRegister(event) {
            event.preventDefault();
            
            const firstName = document.getElementById('firstName').value;
            const lastName = document.getElementById('lastName').value;
            const email = document.getElementById('email').value;
            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const terms = document.getElementById('terms').checked;
            const errorAlert = document.getElementById('errorAlert');

            // Basic validation
            if (!firstName || !lastName || !email || !username || !password || !confirmPassword || !terms) {
                errorAlert.textContent = 'Please fill in all required fields';
                errorAlert.style.display = 'block';
                return false;
            }

            if (password !== confirmPassword) {
                errorAlert.textContent = 'Passwords do not match';
                errorAlert.style.display = 'block';
                return false;
            }

            if (password.length < 8 || !/\d/.test(password)) {
                errorAlert.textContent = 'Password must be at least 8 characters long and contain at least one number';
                errorAlert.style.display = 'block';
                return false;
            }

            // For demo purposes, store in localStorage
            const userData = {
                firstName,
                lastName,
                email,
                username,
                password // In a real app, this would be hashed
            };

            // Store user data
            localStorage.setItem('user_' + username, JSON.stringify(userData));
            
            // Redirect to login page
            window.location.href = 'login';
            return false;
        }

        // Password match validation
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const password = document.getElementById('password').value;
            const confirmPassword = this.value;
            const errorAlert = document.getElementById('errorAlert');
            
            if (password !== confirmPassword) {
                errorAlert.textContent = 'Passwords do not match';
                errorAlert.style.display = 'block';
            } else {
                errorAlert.style.display = 'none';
            }
        });
    </script>
</body>
</html> 