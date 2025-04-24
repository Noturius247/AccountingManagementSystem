<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <title>${title} - Accounting System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/static/css/main.css" rel="stylesheet" type="text/css">
    <link href="${pageContext.request.contextPath}/static/css/payment-forms.css" rel="stylesheet" type="text/css">
    <style>
        .loading {
            display: none;
            margin-left: 10px;
        }
        .loading .spinner {
            width: 20px;
            height: 20px;
            border: 2px solid #f3f3f3;
            border-top: 2px solid #3498db;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        .error-message {
            color: red;
            margin-top: 5px;
            display: none;
        }
        .student-info {
            margin: 20px 0;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #f9f9f9;
        }
        .input-wrapper {
            display: flex;
            align-items: center;
        }
    </style>
    <script src="${pageContext.request.contextPath}/static/js/student-autofill.js"></script>
</head>
<body>
    <div class="container">
        <div class="payment-form">
            <h2 class="text-center mb-4">${title}</h2>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="bi bi-exclamation-circle"></i> ${error}
                </div>
            </c:if>

            <form id="paymentForm" method="post" action="${actionUrl}" data-verify-url="${pageContext.request.contextPath}/kiosk/verify-student" novalidate>
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                
                <c:if test="${empty skipStudentVerification}">
                    <div class="form-group">
                        <label for="studentId">Student ID<span class="required">*</span></label>
                        <div class="input-wrapper">
                            <input type="text" class="form-control input-field" id="studentId" name="studentId" required>
                            <div class="loading">
                                <div class="spinner"></div>
                            </div>
                        </div>
                        <div class="error-message"></div>
                    </div>

                    <div class="student-info" style="display: none;">
                        <h3>Student Information</h3>
                        <p>Name: <span id="studentName"></span></p>
                        <p>Program: <span id="program"></span></p>
                        <p>Year Level: <span id="yearLevel"></span></p>
                        <p>Academic Year: <span id="academicYear"></span></p>
                        <p>Semester: <span id="semester"></span></p>
                    </div>
                </c:if>

                ${additionalFields}

                <div class="form-group">
                    <label for="notes">Notes</label>
                    <textarea class="form-control" id="notes" name="notes" rows="3" placeholder="Enter any additional notes or comments"></textarea>
                </div>

                <div class="form-group">
                    <label for="amount">Amount<span class="required">*</span></label>
                    <div class="input-group">
                        <span class="input-group-text">₱</span>
                        <input type="number" class="form-control input-field" id="amount" name="amount" step="0.01" value="${amount}" required>
                    </div>
                </div>

                <div class="d-grid gap-2 mt-4">
                    <button type="submit" class="btn btn-primary submit-btn" disabled>Process Payment</button>
                    <a href="${pageContext.request.contextPath}/kiosk" class="btn btn-secondary">Back to Kiosk</a>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    ${additionalScripts}
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            initializeStudentAutofill('paymentForm');
            
            // Handle form submission
            document.getElementById('paymentForm').addEventListener('submit', function(e) {
                e.preventDefault();
                const form = this;
                const formData = new FormData(form);
                
                // Get CSRF token from hidden input field
                const csrfToken = document.querySelector('input[name="_csrf"]').value;
                
                fetch(form.action, {
                    method: 'POST',
                    headers: {
                        'X-CSRF-TOKEN': csrfToken,
                        'Accept': 'text/html,application/xhtml+xml,application/xml'
                    },
                    body: formData,
                    credentials: 'include'
                })
                .then(response => {
                    if (!response.ok) {
                        if (response.status === 403) {
                            window.location.href = '${pageContext.request.contextPath}/login';
                            return;
                        }
                        throw new Error('Network response was not ok');
                    }
                    if (response.redirected) {
                        window.location.href = response.url;
                    } else {
                        return response.text().then(html => {
                            document.documentElement.innerHTML = html;
                        });
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Failed to process payment. Please try again.');
                });
            });
        });
    </script>
</body>
</html> 