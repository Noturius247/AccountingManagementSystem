<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Accounting Management System</title>
    <link rel="stylesheet" href="../../css/main.css">
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
        .register-container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 500px;
            margin: 20px;
        }
        .register-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .register-header h1 {
            color: #2c3e50;
            margin: 0;
            font-size: 28px;
        }
        .register-header p {
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
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }
        .btn-register {
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
        .btn-register:hover {
            background: #2980b9;
        }
        .register-footer {
            text-align: center;
            margin-top: 20px;
            color: #7f8c8d;
        }
        .register-footer a {
            color: #3498db;
            text-decoration: none;
        }
        .register-footer a:hover {
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
        .password-strength {
            margin-top: 5px;
            height: 5px;
            border-radius: 3px;
            background: #eee;
            overflow: hidden;
        }
        .password-strength-bar {
            height: 100%;
            width: 0;
            transition: width 0.3s, background-color 0.3s;
        }
        .password-strength-weak {
            background-color: #e74c3c;
            width: 25%;
        }
        .password-strength-medium {
            background-color: #f39c12;
            width: 50%;
        }
        .password-strength-good {
            background-color: #2ecc71;
            width: 75%;
        }
        .password-strength-strong {
            background-color: #27ae60;
            width: 100%;
        }
        .password-requirements {
            margin-top: 5px;
            font-size: 12px;
            color: #7f8c8d;
        }
        .requirement {
            display: flex;
            align-items: center;
            margin-bottom: 3px;
        }
        .requirement i {
            margin-right: 5px;
            font-size: 14px;
        }
        .requirement.valid {
            color: #2ecc71;
        }
        .requirement.invalid {
            color: #e74c3c;
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
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-header">
            <h1>Create Account</h1>
            <p>Join our Accounting Management System</p>
        </div>

        <div class="error-message" id="errorMessage"></div>

        <form id="registerForm" action="${pageContext.request.contextPath}/register" method="POST" onsubmit="return handleSubmit(event)">
            <div class="form-row">
                <div class="form-group">
                    <label for="firstName">First Name</label>
                    <input type="text" id="firstName" name="firstName" class="form-control" required 
                           placeholder="Enter your first name">
                </div>
                <div class="form-group">
                    <label for="lastName">Last Name</label>
                    <input type="text" id="lastName" name="lastName" class="form-control" required 
                           placeholder="Enter your last name">
                </div>
            </div>

            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" class="form-control" required 
                       placeholder="Enter your email">
            </div>

            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" class="form-control" required 
                       placeholder="Choose a username">
            </div>

            <div class="form-group password-toggle">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" class="form-control" required 
                       placeholder="Create a password" onkeyup="checkPasswordStrength()">
                <span class="toggle-icon" onclick="togglePassword()">👁️</span>
                <div class="password-strength">
                    <div class="password-strength-bar" id="passwordStrengthBar"></div>
                </div>
                <div class="password-requirements">
                    <div class="requirement" id="lengthReq">
                        <i>✓</i> At least 8 characters
                    </div>
                    <div class="requirement" id="uppercaseReq">
                        <i>✓</i> Contains uppercase letter
                    </div>
                    <div class="requirement" id="lowercaseReq">
                        <i>✓</i> Contains lowercase letter
                    </div>
                    <div class="requirement" id="numberReq">
                        <i>✓</i> Contains number
                    </div>
                    <div class="requirement" id="specialReq">
                        <i>✓</i> Contains special character
                    </div>
                </div>
            </div>

            <div class="form-group password-toggle">
                <label for="confirmPassword">Confirm Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required 
                       placeholder="Confirm your password">
                <span class="toggle-icon" onclick="toggleConfirmPassword()">👁️</span>
            </div>

            <button type="submit" class="btn-register" id="registerButton">Create Account</button>
            <div class="loading" id="loadingIndicator">Creating account</div>
        </form>

        <div class="register-footer">
            Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in here</a>
        </div>
    </div>

    <script>
        function togglePassword() {
            const passwordInput = document.getElementById('password');
            const toggleIcon = document.querySelector('.password-toggle:first-of-type .toggle-icon');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                toggleIcon.textContent = '👁️‍🗨️';
            } else {
                passwordInput.type = 'password';
                toggleIcon.textContent = '👁️';
            }
        }

        function toggleConfirmPassword() {
            const confirmPasswordInput = document.getElementById('confirmPassword');
            const toggleIcon = document.querySelector('.password-toggle:last-of-type .toggle-icon');
            
            if (confirmPasswordInput.type === 'password') {
                confirmPasswordInput.type = 'text';
                toggleIcon.textContent = '👁️‍🗨️';
            } else {
                confirmPasswordInput.type = 'password';
                toggleIcon.textContent = '👁️';
            }
        }

        function checkPasswordStrength() {
            const password = document.getElementById('password').value;
            const strengthBar = document.getElementById('passwordStrengthBar');
            const requirements = {
                length: password.length >= 8,
                uppercase: /[A-Z]/.test(password),
                lowercase: /[a-z]/.test(password),
                number: /[0-9]/.test(password),
                special: /[^A-Za-z0-9]/.test(password)
            };

            // Update requirement indicators
            document.getElementById('lengthReq').className = `requirement ${requirements.length ? 'valid' : 'invalid'}`;
            document.getElementById('uppercaseReq').className = `requirement ${requirements.uppercase ? 'valid' : 'invalid'}`;
            document.getElementById('lowercaseReq').className = `requirement ${requirements.lowercase ? 'valid' : 'invalid'}`;
            document.getElementById('numberReq').className = `requirement ${requirements.number ? 'valid' : 'invalid'}`;
            document.getElementById('specialReq').className = `requirement ${requirements.special ? 'valid' : 'invalid'}`;

            // Calculate strength
            const strength = Object.values(requirements).filter(Boolean).length;
            let strengthClass = '';

            if (strength <= 1) {
                strengthClass = 'password-strength-weak';
            } else if (strength <= 2) {
                strengthClass = 'password-strength-medium';
            } else if (strength <= 4) {
                strengthClass = 'password-strength-good';
            } else {
                strengthClass = 'password-strength-strong';
            }

            strengthBar.className = `password-strength-bar ${strengthClass}`;
        }

        function handleSubmit(event) {
            event.preventDefault();
            
            const form = event.target;
            const errorMessage = document.getElementById('errorMessage');
            const registerButton = document.getElementById('registerButton');
            const loadingIndicator = document.getElementById('loadingIndicator');

            // Validate passwords match
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                errorMessage.textContent = 'Passwords do not match';
                errorMessage.style.display = 'block';
                return false;
            }

            // Validate password strength
            const requirements = {
                length: password.length >= 8,
                uppercase: /[A-Z]/.test(password),
                lowercase: /[a-z]/.test(password),
                number: /[0-9]/.test(password),
                special: /[^A-Za-z0-9]/.test(password)
            };

            if (!Object.values(requirements).every(Boolean)) {
                errorMessage.textContent = 'Password does not meet all requirements';
                errorMessage.style.display = 'block';
                return false;
            }

            // Show loading state
            registerButton.disabled = true;
            loadingIndicator.style.display = 'block';

            // Submit form
            fetch(form.action, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams(new FormData(form))
            })
            .then(response => {
                if (response.ok) {
                    window.location.href = '${pageContext.request.contextPath}/login?registered=true';
                } else {
                    return response.text().then(text => {
                        throw new Error(text);
                    });
                }
            })
            .catch(error => {
                errorMessage.textContent = 'Registration failed. Please try again.';
                errorMessage.style.display = 'block';
                registerButton.disabled = false;
                loadingIndicator.style.display = 'none';
            });

            return false;
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