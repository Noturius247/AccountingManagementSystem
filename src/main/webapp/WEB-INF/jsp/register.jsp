<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Accounting Management System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../../css/main.css">
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
            --warning-color: #f39c12;
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
        
        .register-container {
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 550px;
            margin: 20px;
            position: relative;
            overflow: hidden;
            border: 1px solid var(--secondary-color);
        }
        
        .register-container::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
        }
        
        .register-header {
            text-align: center;
            margin-bottom: 35px;
            position: relative;
        }
        
        .register-header h1 {
            color: var(--primary-color);
            margin: 0;
            font-size: 28px;
            font-weight: 600;
        }
        
        .register-header .logo {
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
        
        .register-header p {
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
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 0;
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
        
        .btn-register {
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
        
        .btn-register:hover {
            background: var(--primary-dark);
        }
        
        .btn-register:disabled {
            background: var(--medium-gray);
            cursor: not-allowed;
        }
        
        .register-footer {
            text-align: center;
            margin-top: 25px;
            color: var(--medium-gray);
            font-size: 15px;
        }
        
        .register-footer a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
        }
        
        .register-footer a:hover {
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
        
        .password-strength {
            margin-top: 8px;
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
            background-color: var(--error-color);
            width: 25%;
        }
        
        .password-strength-medium {
            background-color: var(--warning-color);
            width: 50%;
        }
        
        .password-strength-good {
            background-color: var(--success-color);
            width: 75%;
        }
        
        .password-strength-strong {
            background-color: #27ae60;
            width: 100%;
        }
        
        .password-requirements {
            margin-top: 10px;
            font-size: 13px;
            color: var(--medium-gray);
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 6px;
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
            color: var(--success-color);
        }
        
        .requirement.invalid {
            color: var(--error-color);
        }
        
        .loading {
            display: none;
            text-align: center;
            margin-top: 10px;
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
        
        .accounting-icon-small {
            width: 28px;
            height: 28px;
            background: #FFF8E1;
            border: 1px solid var(--secondary-color);
            border-radius: 6px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: var(--secondary-color);
            font-size: 14px;
            margin-right: 10px;
        }
        
        .steps-indicator {
            display: flex;
            justify-content: center;
            margin-bottom: 20px;
        }
        
        .step {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin: 0 15px;
        }
        
        .step-number {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            border: 2px solid var(--primary-color);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            color: var(--primary-color);
            background-color: white;
            margin-bottom: 8px;
        }
        
        .step.active .step-number {
            background-color: var(--primary-color);
            color: white;
        }
        
        .step-text {
            font-size: 13px;
            color: var(--medium-gray);
        }
        
        .step.active .step-text {
            color: var(--primary-color);
            font-weight: 500;
        }
        
        .system-info {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid var(--border-color);
            font-size: 13px;
            color: var(--medium-gray);
        }
        
        .error-message {
            background-color: #f8d7da;
            border-left: 4px solid var(--error-color);
            color: #721c24;
            padding: 14px;
            margin-bottom: 20px;
            border-radius: 6px;
            display: none;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="page-decoration decoration-1"></div>
        <div class="page-decoration decoration-2"></div>
        
        <div class="register-header">
            <div class="logo">
                <i class="fas fa-calculator"></i>
            </div>
            <h1>Create Account</h1>
            <p>Join the Accounting Management System</p>
        </div>
        
        <div class="steps-indicator">
            <div class="step">
                <div class="step-number">1</div>
                <div class="step-text">Account</div>
            </div>
            <div class="step active">
                <div class="step-number">2</div>
                <div class="step-text">Personal Info</div>
            </div>
            <div class="step">
                <div class="step-number">3</div>
                <div class="step-text">Confirmation</div>
            </div>
        </div>

        <div class="error-message" id="errorMessage"></div>

        <form id="registerForm" action="${pageContext.request.contextPath}/register" method="POST" onsubmit="return handleSubmit(event)">
            <sec:csrfInput />
            <div class="form-row">
                <div class="form-group">
                    <label for="firstName">First Name *</label>
                    <div class="input-group">
                        <i class="fas fa-user input-icon"></i>
                        <input type="text" id="firstName" name="firstName" class="form-control" required 
                            placeholder="Enter your first name">
                    </div>
                </div>
                <div class="form-group">
                    <label for="lastName">Last Name *</label>
                    <div class="input-group">
                        <i class="fas fa-user input-icon"></i>
                        <input type="text" id="lastName" name="lastName" class="form-control" required 
                            placeholder="Enter your last name">
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label for="email">Email Address *</label>
                <div class="input-group">
                    <i class="fas fa-envelope input-icon"></i>
                    <input type="email" id="email" name="email" class="form-control" required 
                        placeholder="Enter your email address"
                        pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$">
                </div>
            </div>

            <div class="form-group">
                <label for="username">Username *</label>
                <div class="input-group">
                    <i class="fas fa-id-badge input-icon"></i>
                    <input type="text" id="username" name="username" class="form-control" required 
                        placeholder="Choose a username"
                        pattern="[a-zA-Z0-9_]{4,20}"
                        title="Username must be 4-20 characters long and can only contain letters, numbers, and underscores">
                </div>
            </div>

            <div class="form-group">
                <label for="phoneNumber">Phone Number</label>
                <div class="input-group">
                    <i class="fas fa-phone input-icon"></i>
                    <input type="tel" id="phoneNumber" name="phoneNumber" class="form-control"
                        placeholder="Enter your phone number"
                        pattern="[0-9]{10,}"
                        title="Please enter a valid phone number">
                </div>
            </div>

            <div class="form-group">
                <label for="address">Address</label>
                <div class="input-group">
                    <i class="fas fa-home input-icon"></i>
                    <textarea id="address" name="address" class="form-control" 
                        placeholder="Enter your address" rows="3"></textarea>
                </div>
            </div>

            <div class="form-group">
                <label for="password">Password *</label>
                <div class="input-group password-input">
                    <i class="fas fa-lock input-icon"></i>
                    <input type="password" id="password" name="password" class="form-control" required 
                        placeholder="Enter your password"
                        onkeyup="checkPasswordStrength()">
                    <button type="button" class="toggle-password" onclick="togglePassword()">
                        <i id="toggleIcon" class="fas fa-eye"></i>
                    </button>
                </div>
                <div class="password-strength">
                    <div id="passwordStrengthBar" class="password-strength-bar"></div>
                </div>
                <div class="password-requirements">
                    <div id="lengthReq" class="requirement">At least 8 characters</div>
                    <div id="uppercaseReq" class="requirement">At least one uppercase letter</div>
                    <div id="lowercaseReq" class="requirement">At least one lowercase letter</div>
                    <div id="numberReq" class="requirement">At least one number</div>
                    <div id="specialReq" class="requirement">At least one special character</div>
                </div>
            </div>

            <div class="form-group">
                <label for="confirmPassword">Confirm Password *</label>
                <div class="input-group password-input">
                    <i class="fas fa-lock input-icon"></i>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required 
                        placeholder="Confirm your password">
                    <button type="button" class="toggle-password" onclick="toggleConfirmPassword()">
                        <i id="toggleConfirmIcon" class="fas fa-eye"></i>
                    </button>
                </div>
            </div>

            <div class="form-group">
                <div class="form-check">
                    <input type="checkbox" id="termsAccepted" name="termsAccepted" class="form-check-input" required>
                    <label class="form-check-label" for="termsAccepted">
                        I agree to the Terms and Conditions *
                    </label>
                </div>
            </div>

            <button type="submit" id="registerButton" class="btn-register">
                <span>Create Account</span>
                <div id="loadingIndicator" class="spinner" style="display: none;"></div>
            </button>
        </form>

        <div class="register-footer">
            Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in here</a>
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

        function toggleConfirmPassword() {
            const confirmPasswordInput = document.getElementById('confirmPassword');
            const toggleIcon = document.getElementById('toggleConfirmIcon');
            
            if (confirmPasswordInput.type === 'password') {
                confirmPasswordInput.type = 'text';
                toggleIcon.classList.remove('fa-eye');
                toggleIcon.classList.add('fa-eye-slash');
            } else {
                confirmPasswordInput.type = 'password';
                toggleIcon.classList.remove('fa-eye-slash');
                toggleIcon.classList.add('fa-eye');
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

            if (strength === 0) {
                strengthClass = '';  // Empty password
            } else if (strength <= 2) {
                strengthClass = 'password-strength-weak';
            } else if (strength <= 3) {
                strengthClass = 'password-strength-medium';
            } else if (strength === 4) {
                strengthClass = 'password-strength-good';
            } else if (strength === 5) {
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
            const buttonText = registerButton.querySelector('span');

            // Hide any existing error message
            errorMessage.style.display = 'none';

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
            buttonText.textContent = 'Creating account...';

            // Submit form
            const token = document.querySelector('input[name="_csrf"]').value;
            fetch(form.action, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-CSRF-TOKEN': token
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
                buttonText.textContent = 'Create Account';
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

        document.getElementById('confirmPassword').addEventListener('input', () => {
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