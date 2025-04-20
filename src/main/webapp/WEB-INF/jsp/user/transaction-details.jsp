<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transaction Details - Accounting System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/static/css/main.css" rel="stylesheet">
    <style>
        .transaction-details {
            max-width: 800px;
            margin: 2rem auto;
            padding: 2rem;
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }

        .transaction-header {
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid var(--light-color);
        }

        .transaction-id {
            color: var(--secondary-color);
            font-size: 0.9rem;
        }

        .transaction-status {
            padding: 0.5rem 1rem;
            border-radius: 5px;
            font-weight: 500;
        }

        .status-completed {
            background-color: var(--success-light);
            color: var(--success-color);
        }

        .status-pending {
            background-color: var(--warning-light);
            color: var(--warning-color);
        }

        .status-failed {
            background-color: var(--danger-light);
            color: var(--danger-color);
        }

        .transaction-amount {
            font-size: 2rem;
            font-weight: bold;
            color: var(--primary-color);
            margin: 1rem 0;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            padding: 1rem 0;
            border-bottom: 1px solid var(--light-color);
        }

        .detail-label {
            color: var(--secondary-color);
            font-weight: 500;
        }

        .detail-value {
            color: var(--dark-color);
        }
    </style>
</head>
<body>
    <div class="transaction-details">
        <div class="transaction-header">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2>Transaction Details</h2>
                    <div class="transaction-id">ID: ${transaction.id}</div>
                </div>
                <div class="transaction-status status-${transaction.status.toLowerCase()}">
                    ${transaction.status}
                </div>
            </div>
            <div class="transaction-amount">
                <fmt:formatNumber value="${transaction.amount}" type="currency"/>
            </div>
        </div>

        <div class="detail-row">
            <div class="detail-label">Transaction Type</div>
            <div class="detail-value">${transaction.type}</div>
        </div>

        <div class="detail-row">
            <div class="detail-label">Date</div>
            <div class="detail-value">
                <fmt:formatDate value="${transaction.createdAt}" pattern="MMMM dd, yyyy HH:mm:ss"/>
            </div>
        </div>

        <c:if test="${not empty transaction.notes}">
            <div class="detail-row">
                <div class="detail-label">Notes</div>
                <div class="detail-value">${transaction.notes}</div>
            </div>
        </c:if>

        <c:if test="${not empty transaction.receiptId}">
            <div class="detail-row">
                <div class="detail-label">Receipt ID</div>
                <div class="detail-value">${transaction.receiptId}</div>
            </div>
        </c:if>

        <div class="detail-row">
            <div class="detail-label">Priority</div>
            <div class="detail-value">${transaction.priority}</div>
        </div>

        <c:if test="${transaction.status == 'COMPLETED'}">
            <div class="mt-4">
                <a href="${pageContext.request.contextPath}/user/transactions/${transaction.id}/receipt" 
                   class="btn btn-primary">
                    <i class="bi bi-download"></i> Download Receipt
                </a>
            </div>
        </c:if>

        <div class="mt-4">
            <a href="${pageContext.request.contextPath}/user/transactions" class="btn btn-secondary">
                <i class="bi bi-arrow-left"></i> Back to Transactions
            </a>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 