<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.ZoneId" %>
<%@ page import="java.util.Date" %>
<%
    LocalDateTime createdAt = ((com.accounting.model.Payment) request.getAttribute("payment")).getCreatedAt();
    Date date = Date.from(createdAt.atZone(ZoneId.systemDefault()).toInstant());
    request.setAttribute("formattedDate", date);
    
    LocalDateTime processedAt = ((com.accounting.model.Payment) request.getAttribute("payment")).getProcessedAt();
    if (processedAt != null) {
        Date processedDate = Date.from(processedAt.atZone(ZoneId.systemDefault()).toInstant());
        request.setAttribute("formattedProcessedDate", processedDate);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Details - Accounting Management System</title>
    <link rel="stylesheet" href="../../css/main.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        :root {
            --primary-color: #3498db;
            --success-color: #2ecc71;
            --danger-color: #e74c3c;
            --warning-color: #f39c12;
            --info-color: #17a2b8;
            --dark-color: #2c3e50;
            --light-color: #ecf0f1;
        }

        body {
            background-color: #f5f7fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .payment-details {
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .payment-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .payment-header h1 {
            color: var(--dark-color);
            margin: 0;
        }

        .payment-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }

        .payment-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .info-item {
            margin-bottom: 15px;
        }

        .info-label {
            font-size: 14px;
            color: #666;
            margin-bottom: 5px;
        }

        .info-value {
            font-size: 16px;
            font-weight: 500;
            color: var(--dark-color);
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
            display: inline-block;
        }

        .status-pending {
            background: #fff3cd;
            color: #856404;
        }

        .status-completed {
            background: #d4edda;
            color: #155724;
        }

        .status-failed {
            background: #f8d7da;
            color: #721c24;
        }

        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .btn:hover {
            opacity: 0.9;
        }

        .btn-primary {
            background: var(--primary-color);
            color: white;
        }

        .btn-success {
            background: var(--success-color);
            color: white;
        }

        .btn-danger {
            background: var(--danger-color);
            color: white;
        }

        .btn-warning {
            background: var(--warning-color);
            color: white;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <%@ include file="../includes/manager-header.jsp" %>
    
    <div class="payment-details">
        <div class="payment-header">
            <h1>Payment Details</h1>
            <a href="${pageContext.request.contextPath}/manager/payments" class="btn btn-primary">
                <i class="fas fa-arrow-left"></i> Back to Payments
            </a>
        </div>

        <div class="payment-card">
            <div class="payment-info">
                <div class="info-item">
                    <div class="info-label">Payment ID</div>
                    <div class="info-value">${payment.id}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">User</div>
                    <div class="info-value">${payment.user.username}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Amount</div>
                    <div class="info-value"><fmt:formatNumber value="${payment.amount}" type="currency"/></div>
                </div>
                <div class="info-item">
                    <div class="info-label">Type</div>
                    <div class="info-value">${payment.type}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Status</div>
                    <div class="info-value">
                        <span class="status-badge status-${fn:toLowerCase(payment.status)}">
                            ${payment.status}
                        </span>
                    </div>
                </div>
                <div class="info-item">
                    <div class="info-label">Date</div>
                    <div class="info-value"><fmt:formatDate value="${formattedDate}" pattern="MMM dd, yyyy HH:mm"/></div>
                </div>
                <c:if test="${not empty payment.processedAt}">
                    <div class="info-item">
                        <div class="info-label">Processed At</div>
                        <div class="info-value"><fmt:formatDate value="${formattedProcessedDate}" pattern="MMM dd, yyyy HH:mm"/></div>
                    </div>
                </c:if>
            </div>

            <c:if test="${payment.status.name() == 'PENDING'}">
                <div class="action-buttons">
                    <button class="btn btn-success" onclick="approvePayment('${payment.id}')">
                        <i class="fas fa-check"></i> Approve Payment
                    </button>
                    <button class="btn btn-danger" onclick="rejectPayment('${payment.id}')">
                        <i class="fas fa-times"></i> Reject Payment
                    </button>
                </div>
            </c:if>
        </div>
    </div>

    <script>
        // Utility functions
        const utils = {
            showLoading: function() {
                const overlay = document.createElement('div');
                overlay.id = 'loadingOverlay';
                overlay.style.cssText = 'position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(255,255,255,0.8); display: flex; justify-content: center; align-items: center; z-index: 9999;';
                overlay.innerHTML = '<div class="spinner-border text-primary" role="status"><span class="sr-only">Loading...</span></div>';
                document.body.appendChild(overlay);
            },
            
            hideLoading: function() {
                const overlay = document.getElementById('loadingOverlay');
                if (overlay) {
                    overlay.remove();
                }
            },
            
            showSuccess: function(message) {
                const toast = document.createElement('div');
                toast.className = 'alert alert-success alert-dismissible fade show position-fixed';
                toast.style.cssText = 'top: 20px; right: 20px; z-index: 9999;';
                toast.innerHTML = `
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                `;
                document.body.appendChild(toast);
                setTimeout(() => toast.remove(), 3000);
            },
            
            showError: function(message) {
                const toast = document.createElement('div');
                toast.className = 'alert alert-danger alert-dismissible fade show position-fixed';
                toast.style.cssText = 'top: 20px; right: 20px; z-index: 9999;';
                toast.innerHTML = `
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                `;
                document.body.appendChild(toast);
                setTimeout(() => toast.remove(), 5000);
            }
        };

        // Payment management functions
        async function approvePayment(paymentId) {
            if (!confirm('Are you sure you want to approve this payment?')) {
                return;
            }

            try {
                utils.showLoading();
                const response = await fetch(`${pageContext.request.contextPath}/manager/payments/${paymentId}/approve`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]')?.content
                    }
                });

                if (!response.ok) {
                    throw new Error('Failed to approve payment');
                }

                utils.showSuccess('Payment approved successfully');
                setTimeout(() => window.location.reload(), 1000);
            } catch (error) {
                utils.showError(error.message || 'Failed to approve payment');
            } finally {
                utils.hideLoading();
            }
        }

        async function rejectPayment(paymentId) {
            if (!confirm('Are you sure you want to reject this payment?')) {
                return;
            }

            try {
                utils.showLoading();
                const response = await fetch(`${pageContext.request.contextPath}/manager/payments/${paymentId}/reject`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]')?.content
                    }
                });

                if (!response.ok) {
                    throw new Error('Failed to reject payment');
                }

                utils.showSuccess('Payment rejected successfully');
                setTimeout(() => window.location.reload(), 1000);
            } catch (error) {
                utils.showError(error.message || 'Failed to reject payment');
            } finally {
                utils.hideLoading();
            }
        }

        // Initialize tooltips and popovers if using Bootstrap
        document.addEventListener('DOMContentLoaded', function() {
            if (typeof bootstrap !== 'undefined') {
                const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                tooltipTriggerList.map(function (tooltipTriggerEl) {
                    return new bootstrap.Tooltip(tooltipTriggerEl);
                });
            }
        });
    </script>
    <script src="${pageContext.request.contextPath}/static/js/manager_dashboard.js"></script>
</body>
</html> 