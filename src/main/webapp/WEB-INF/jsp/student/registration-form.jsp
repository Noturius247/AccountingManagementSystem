<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Registration - Accounting System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/static/css/main.css" rel="stylesheet">
    <style>
        .registration-container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 2rem;
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }

        .registration-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .registration-header h1 {
            color: var(--primary-color);
            margin-bottom: 1rem;
        }

        .registration-header p {
            color: var(--secondary-color);
        }

        .steps-indicator {
            display: flex;
            justify-content: space-between;
            margin-bottom: 2rem;
            padding: 0 1rem;
        }

        .step {
            text-align: center;
            flex: 1;
            position: relative;
        }

        .step:not(:last-child)::after {
            content: '';
            position: absolute;
            top: 20px;
            right: -50%;
            width: 100%;
            height: 2px;
            background: var(--primary-color);
            z-index: 1;
        }

        .step-number {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--light-color);
            color: var(--dark-color);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 0.5rem;
            position: relative;
            z-index: 2;
        }

        .step.active .step-number {
            background: var(--primary-color);
            color: white;
        }

        .step.completed .step-number {
            background: var(--success-color);
            color: white;
        }

        .step-text {
            font-size: 0.9rem;
            color: var(--secondary-color);
        }

        .step.active .step-text {
            color: var(--primary-color);
            font-weight: bold;
        }

        .form-section {
            margin-bottom: 2rem;
        }

        .form-section h3 {
            color: var(--primary-color);
            margin-bottom: 1.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--light-color);
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            font-weight: 500;
            color: var(--dark-color);
            margin-bottom: 0.5rem;
        }

        .form-control {
            border-radius: 5px;
            padding: 0.75rem 1rem;
            border: 1px solid var(--light-color);
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(var(--primary-rgb), 0.25);
        }

        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            padding: 0.75rem 2rem;
            font-weight: 500;
        }

        .btn-primary:hover {
            background-color: var(--primary-dark);
            border-color: var(--primary-dark);
        }

        .alert {
            border-radius: 5px;
            padding: 1rem;
            margin-bottom: 1.5rem;
        }

        .alert-danger {
            background-color: var(--danger-light);
            border-color: var(--danger-color);
            color: var(--danger-color);
        }

        .program-options {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 1rem;
        }

        .program-option {
            border: 2px solid var(--light-color);
            border-radius: 8px;
            padding: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .program-option:hover {
            border-color: var(--primary-color);
            background-color: var(--primary-light);
        }

        .program-option.selected {
            border-color: var(--primary-color);
            background-color: var(--primary-light);
        }

        .program-option i {
            font-size: 2rem;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }

        .program-option h4 {
            margin-bottom: 0.5rem;
            color: var(--dark-color);
        }

        .program-option p {
            color: var(--secondary-color);
            font-size: 0.9rem;
            margin: 0;
        }
    </style>
</head>
<body>
    <div class="registration-container">
        <div class="registration-header">
            <h1>Student Registration</h1>
            <p>Complete your student profile to access all features</p>
        </div>

        <div class="steps-indicator">
            <div class="step completed">
                <div class="step-number">
                    <i class="bi bi-check"></i>
                </div>
                <div class="step-text">Account</div>
            </div>
            <div class="step active">
                <div class="step-number">2</div>
                <div class="step-text">Program</div>
            </div>
            <div class="step">
                <div class="step-number">3</div>
                <div class="step-text">Confirmation</div>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <i class="bi bi-exclamation-circle"></i> ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/student-registration" method="post">
            <input type="hidden" name="username" value="${username}">
            <sec:csrfInput />
            
            <div class="form-section">
                <h3>Select Your Program</h3>
                <div class="program-options">
                    <div class="program-option" onclick="selectProgram('BSCS')">
                        <i class="bi bi-code-square"></i>
                        <h4>BS Computer Science</h4>
                        <p>Bachelor of Science in Computer Science</p>
                    </div>
                    <div class="program-option" onclick="selectProgram('BSIT')">
                        <i class="bi bi-laptop"></i>
                        <h4>BS Information Technology</h4>
                        <p>Bachelor of Science in Information Technology</p>
                    </div>
                    <div class="program-option" onclick="selectProgram('BSIS')">
                        <i class="bi bi-diagram-3"></i>
                        <h4>BS Information Systems</h4>
                        <p>Bachelor of Science in Information Systems</p>
                    </div>
                    <div class="program-option" onclick="selectProgram('BSCE')">
                        <i class="bi bi-cpu"></i>
                        <h4>BS Computer Engineering</h4>
                        <p>Bachelor of Science in Computer Engineering</p>
                    </div>
                </div>
                <input type="hidden" name="program" id="selectedProgram" required>
            </div>

            <div class="form-section">
                <h3>Year Level</h3>
                <div class="form-group">
                    <label class="form-label">Select your year level</label>
                    <select class="form-control" name="yearLevel" required>
                        <option value="">Select Year Level</option>
                        <option value="1">1st Year</option>
                        <option value="2">2nd Year</option>
                        <option value="3">3rd Year</option>
                        <option value="4">4th Year</option>
                    </select>
                </div>
            </div>

            <div class="form-section">
                <h3>Current Academic Information</h3>
                <div class="form-group">
                    <label class="form-label">Academic Year</label>
                    <select class="form-control" name="academicYear" required>
                        <option value="">Select Academic Year</option>
                        <c:forEach var="year" begin="2020" end="2030">
                            <option value="${year}-${year+1}" ${currentAcademicYear == year.toString().concat('-').concat((year+1).toString()) ? 'selected' : ''}>${year}-${year+1}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Semester</label>
                    <select class="form-control" name="semester" required>
                        <option value="">Select Semester</option>
                        <option value="1ST" ${currentSemester == '1ST' ? 'selected' : ''}>First Semester</option>
                        <option value="2ND" ${currentSemester == '2ND' ? 'selected' : ''}>Second Semester</option>
                        <option value="SUMMER" ${currentSemester == 'SUMMER' ? 'selected' : ''}>Summer</option>
                    </select>
                </div>
            </div>

            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-primary">
                    <i class="bi bi-check-circle"></i> Complete Registration
                </button>
            </div>
        </form>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function selectProgram(program) {
            // Remove selected class from all options
            document.querySelectorAll('.program-option').forEach(option => {
                option.classList.remove('selected');
            });
            
            // Add selected class to clicked option
            event.currentTarget.classList.add('selected');
            
            // Set the hidden input value
            document.getElementById('selectedProgram').value = program;
        }

        // Add form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const program = document.getElementById('selectedProgram').value;
            const yearLevel = document.querySelector('select[name="yearLevel"]').value;
            
            if (!program) {
                e.preventDefault();
                alert('Please select a program');
                return;
            }
            
            if (!yearLevel) {
                e.preventDefault();
                alert('Please select your year level');
                return;
            }
        });
    </script>
</body>
</html> 