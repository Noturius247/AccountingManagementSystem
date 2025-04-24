<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM dd, yyyy");
    request.setAttribute("dateFormatter", dateFormatter);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - Accounting System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/static/css/main.css" rel="stylesheet">
    <style>
        .dashboard-container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 2rem;
        }

        .welcome-section {
            background: white;
            border-radius: 10px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }

        .welcome-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1.5rem;
        }

        .welcome-header h1 {
            color: var(--primary-color);
            margin: 0;
        }

        .student-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .student-id-badge {
            background: var(--light-color);
            padding: 0.5rem 1rem;
            border-radius: 5px;
            font-weight: bold;
            color: var(--primary-color);
        }

        .info-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .info-card {
            background: white;
            border-radius: 10px;
            padding: 1.5rem;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }

        .info-card-header {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
        }

        .info-card-header i {
            font-size: 1.5rem;
            color: var(--primary-color);
            margin-right: 1rem;
        }

        .info-card-header h3 {
            color: var(--dark-color);
            margin: 0;
        }

        .info-card-content {
            color: var(--secondary-color);
        }

        .info-card-content p {
            margin: 0;
        }

        .info-card-content .value {
            font-size: 1.5rem;
            font-weight: bold;
            color: var(--primary-color);
            margin: 0.5rem 0;
        }

        .action-buttons {
            display: flex;
            gap: 1rem;
            margin-top: 1rem;
        }

        .btn {
            padding: 0.75rem 1.5rem;
            font-weight: 500;
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

        .registration-status {
            background: var(--light-color);
            padding: 1rem;
            border-radius: 5px;
            margin-top: 1rem;
        }

        .registration-status.completed {
            border-left: 4px solid var(--success-color);
        }

        .registration-status.pending {
            border-left: 4px solid var(--warning-color);
        }

        .registration-status h4 {
            margin: 0;
            color: var(--dark-color);
        }

        .registration-status p {
            margin: 0.5rem 0 0;
            color: var(--secondary-color);
        }

        .student-header {
            background: white;
            padding: 1rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }

        .student-header .container {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .student-header h1 {
            margin: 0;
            font-size: 1.5rem;
            color: var(--primary-color);
        }

        .student-header .user-actions {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .student-header .btn-logout {
            padding: 0.5rem 1rem;
            color: var(--danger-color);
            border: 1px solid var(--danger-color);
            border-radius: 4px;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .student-header .btn-logout:hover {
            background: var(--danger-color);
            color: white;
        }
    </style>
</head>
<body>
    <!-- Student Header with Logout -->
    <div class="student-header">
        <div class="container">
            <h1>Student Portal</h1>
            <div class="user-actions">
                <span>Welcome, ${studentName}</span>
                <form action="${pageContext.request.contextPath}/logout" method="post" style="display: inline;">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="btn-logout">
                        <i class="bi bi-box-arrow-right"></i> Logout
                    </button>
                </form>
            </div>
        </div>
    </div>

    <div class="dashboard-container">
        <div class="welcome-section">
            <div class="welcome-header">
                <h1>Welcome, ${studentName}!</h1>
                <div class="student-info">
                    <span class="student-id-badge">ID: ${studentId}</span>
                </div>
            </div>
            
            <div class="registration-status ${registrationStatus == 'APPROVED' ? 'completed' : registrationStatus == 'PENDING' ? 'pending' : 'rejected'}">
                <h4>Registration Status: ${registrationStatus}</h4>
                <c:if test="${registrationStatus == 'APPROVED'}">
                    <p>Your registration is complete. You can now access all student services.</p>
                </c:if>
                <c:if test="${registrationStatus == 'PENDING'}">
                    <p>Your registration is pending admin approval. Please wait for confirmation.</p>
                </c:if>
                <c:if test="${registrationStatus == 'REJECTED'}">
                    <p>Your registration has been rejected. Please contact the administration for more information.</p>
                </c:if>
                <c:if test="${registrationStatus != 'APPROVED' && registrationStatus != 'PENDING'}">
                    <div class="action-buttons">
                        <a href="${pageContext.request.contextPath}/student-registration" class="btn btn-primary">
                            <i class="bi bi-pencil-square"></i> Complete Registration
                        </a>
                    </div>
                </c:if>
            </div>
        </div>

        <div class="info-cards">
            <div class="info-card">
                <div class="info-card-header">
                    <i class="bi bi-mortarboard"></i>
                    <h3>Academic Information</h3>
                </div>
                <div class="info-card-content">
                    <p>Program</p>
                    <div class="value">${program}</div>
                    <p>Year Level</p>
                    <div class="value">${yearLevel}</div>
                    <p>Academic Year</p>
                    <div class="value">${academicYear}</div>
                    <p>Semester</p>
                    <div class="value">${semester}</div>
                </div>
            </div>

            <div class="info-card">
                <div class="info-card-header">
                    <i class="bi bi-cash-stack"></i>
                    <h3>Financial Status</h3>
                </div>
                <div class="info-card-content">
                    <p>Student ID</p>
                    <div class="value">${studentId}</div>
                    <p>Current Balance</p>
                    <div class="value">₱${currentBalance}</div>
                    <p>Last Payment</p>
                    <div class="value">₱${lastPayment}</div>
                    <p>Payment Due Date</p>
                    <div class="value">${dueDate}</div>
                    <p>Payment History</p>
                    <div class="table-responsive mt-3">
                        <table class="table table-sm">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Description</th>
                                    <th>Amount</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${recentPayments}" var="transaction">
                                    <tr>
                                        <td>${transaction.createdAt.format(dateFormatter)}</td>
                                        <td>${transaction.transactionNumber}</td>
                                        <td>₱${transaction.amount}</td>
                                        <td>
                                            <span class="badge ${transaction.status == 'COMPLETED' ? 'bg-success' : 
                                                              transaction.status == 'PENDING' ? 'bg-warning' : 'bg-danger'}">
                                                ${transaction.status}
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/payments" class="btn btn-primary">
                        <i class="bi bi-credit-card"></i> Make Payment
                    </a>
                    <a href="${pageContext.request.contextPath}/transactions" class="btn btn-secondary">
                        <i class="bi bi-receipt"></i> View Transactions
                    </a>
                </div>
            </div>

            <div class="info-card">
                <div class="info-card-header">
                    <i class="bi bi-file-earmark-text"></i>
                    <h3>Documents</h3>
                </div>
                <div class="info-card-content">
                    <p>Available Documents</p>
                    <div class="value">${documentCount}</div>
                    <p>Last Updated</p>
                    <div class="value">${lastDocumentUpdate}</div>
                </div>
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/documents" class="btn btn-primary">
                        <i class="bi bi-download"></i> View Documents
                    </a>
                </div>
            </div>
        </div>

        <div class="info-card">
            <div class="info-card-header">
                <i class="bi bi-clock-history"></i>
                <h3>Recent Activity</h3>
            </div>
            <div class="info-card-content">
                <c:if test="${not empty recentActivities}">
                    <c:forEach items="${recentActivities}" var="activity">
                        <div class="activity-item">
                            <p>${activity.description}</p>
                            <small class="text-muted">${activity.timestamp}</small>
                        </div>
                    </c:forEach>
                </c:if>
                <c:if test="${empty recentActivities}">
                    <p>No recent activities to display.</p>
                </c:if>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 