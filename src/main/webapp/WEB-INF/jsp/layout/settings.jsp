<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Settings - Manager Dashboard</title>
    <link rel="stylesheet" href="../../css/main.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <style>
        .settings-management {
            padding: 20px;
            max-width: 1400px;
            margin: 0 auto;
        }

        .settings-tabs {
            margin-bottom: 20px;
        }

        .settings-section {
            background: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .settings-section h3 {
            margin-bottom: 20px;
            color: #2c3e50;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            font-weight: 500;
            margin-bottom: 8px;
            display: block;
        }

        .form-group .form-text {
            color: #6c757d;
            font-size: 0.875rem;
            margin-top: 4px;
        }

        .toggle-switch {
            position: relative;
            display: inline-block;
            width: 60px;
            height: 34px;
        }

        .toggle-switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }

        .toggle-slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            transition: .4s;
            border-radius: 34px;
        }

        .toggle-slider:before {
            position: absolute;
            content: "";
            height: 26px;
            width: 26px;
            left: 4px;
            bottom: 4px;
            background-color: white;
            transition: .4s;
            border-radius: 50%;
        }

        input:checked + .toggle-slider {
            background-color: #2196F3;
        }

        input:checked + .toggle-slider:before {
            transform: translateX(26px);
        }

        .settings-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
        }

        .integration-card {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
        }

        .integration-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .integration-status {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
        }

        .status-active {
            background-color: #d4edda;
            color: #155724;
        }

        .status-inactive {
            background-color: #f8d7da;
            color: #721c24;
        }
    </style>
</head>
<body>
    <%@ include file="../includes/manager-header.jsp" %>
    
    <div class="settings-management">
        <div class="content-header">
            <h1>System Settings</h1>
        </div>

        <div class="error-message" id="errorMessage"></div>
        <div class="success-message" id="successMessage"></div>

        <!-- System Configuration -->
        <div class="settings-section">
            <h3>System Configuration</h3>
            <form id="systemConfigForm">
                <div class="form-group">
                    <label for="systemName">System Name</label>
                    <input type="text" class="form-control" id="systemName" value="${settings.systemName}">
                </div>
                <div class="form-group">
                    <label for="timezone">Timezone</label>
                    <select class="form-control" id="timezone">
                        <c:forEach items="${timezones}" var="tz">
                            <option value="${tz}" ${settings.timezone == tz ? 'selected' : ''}>${tz}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="dateFormat">Date Format</label>
                    <select class="form-control" id="dateFormat">
                        <c:forEach items="${dateFormats}" var="format">
                            <option value="${format}" ${settings.dateFormat == format ? 'selected' : ''}>${format}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="currency">Default Currency</label>
                    <select class="form-control" id="currency">
                        <c:forEach items="${currencies}" var="curr">
                            <option value="${curr.code}" ${settings.currency == curr.code ? 'selected' : ''}>
                                ${curr.code} - ${curr.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </form>
        </div>

        <!-- Notification Settings -->
        <div class="settings-section">
            <h3>Notification Settings</h3>
            <form id="notificationForm">
                <div class="form-group">
                    <label>Email Notifications</label>
                    <div class="toggle-switch">
                        <input type="checkbox" id="emailNotifications" ${settings.emailNotifications ? 'checked' : ''}>
                        <span class="toggle-slider"></span>
                    </div>
                    <div class="form-text">Receive notifications via email</div>
                </div>
                <div class="form-group">
                    <label>Push Notifications</label>
                    <div class="toggle-switch">
                        <input type="checkbox" id="pushNotifications" ${settings.pushNotifications ? 'checked' : ''}>
                        <span class="toggle-slider"></span>
                    </div>
                    <div class="form-text">Receive push notifications in the browser</div>
                </div>
                <div class="form-group">
                    <label>Notification Types</label>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="notifyTransactions" 
                               ${settings.notifyTransactions ? 'checked' : ''}>
                        <label class="form-check-label" for="notifyTransactions">
                            New Transactions
                        </label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="notifyPayments" 
                               ${settings.notifyPayments ? 'checked' : ''}>
                        <label class="form-check-label" for="notifyPayments">
                            Payment Updates
                        </label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="notifySystem" 
                               ${settings.notifySystem ? 'checked' : ''}>
                        <label class="form-check-label" for="notifySystem">
                            System Updates
                        </label>
                    </div>
                </div>
            </form>
        </div>

        <!-- Security Settings -->
        <div class="settings-section">
            <h3>Security Settings</h3>
            <form id="securityForm">
                <div class="form-group">
                    <label for="sessionTimeout">Session Timeout (minutes)</label>
                    <input type="number" class="form-control" id="sessionTimeout" 
                           value="${settings.sessionTimeout}" min="5" max="120">
                </div>
                <div class="form-group">
                    <label>Password Policy</label>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="requireComplexPassword" 
                               ${settings.requireComplexPassword ? 'checked' : ''}>
                        <label class="form-check-label" for="requireComplexPassword">
                            Require complex passwords
                        </label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="passwordExpiry" 
                               ${settings.passwordExpiry ? 'checked' : ''}>
                        <label class="form-check-label" for="passwordExpiry">
                            Enable password expiry
                        </label>
                    </div>
                    <div class="form-group">
                        <label for="passwordExpiryDays">Password Expiry Period (days)</label>
                        <input type="number" class="form-control" id="passwordExpiryDays" 
                               value="${settings.passwordExpiryDays}" min="30" max="365">
                    </div>
                </div>
            </form>
        </div>

        <!-- Integration Settings -->
        <div class="settings-section">
            <h3>Integration Settings</h3>
            <div class="integration-card">
                <div class="integration-header">
                    <h5>Payment Gateway</h5>
                    <span class="integration-status ${settings.paymentGatewayEnabled ? 'status-active' : 'status-inactive'}">
                        ${settings.paymentGatewayEnabled ? 'Active' : 'Inactive'}
                    </span>
                </div>
                <form id="paymentGatewayForm">
                    <div class="form-group">
                        <label for="paymentGateway">Select Gateway</label>
                        <select class="form-control" id="paymentGateway">
                            <c:forEach items="${paymentGateways}" var="gateway">
                                <option value="${gateway.id}" ${settings.paymentGateway == gateway.id ? 'selected' : ''}>
                                    ${gateway.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="apiKey">API Key</label>
                        <input type="password" class="form-control" id="apiKey" value="${settings.paymentGatewayApiKey}">
                    </div>
                    <div class="form-group">
                        <label for="apiSecret">API Secret</label>
                        <input type="password" class="form-control" id="apiSecret" value="${settings.paymentGatewayApiSecret}">
                    </div>
                </form>
            </div>

            <div class="integration-card">
                <div class="integration-header">
                    <h5>Email Service</h5>
                    <span class="integration-status ${settings.emailServiceEnabled ? 'status-active' : 'status-inactive'}">
                        ${settings.emailServiceEnabled ? 'Active' : 'Inactive'}
                    </span>
                </div>
                <form id="emailServiceForm">
                    <div class="form-group">
                        <label for="smtpHost">SMTP Host</label>
                        <input type="text" class="form-control" id="smtpHost" value="${settings.smtpHost}">
                    </div>
                    <div class="form-group">
                        <label for="smtpPort">SMTP Port</label>
                        <input type="number" class="form-control" id="smtpPort" value="${settings.smtpPort}">
                    </div>
                    <div class="form-group">
                        <label for="smtpUsername">SMTP Username</label>
                        <input type="text" class="form-control" id="smtpUsername" value="${settings.smtpUsername}">
                    </div>
                    <div class="form-group">
                        <label for="smtpPassword">SMTP Password</label>
                        <input type="password" class="form-control" id="smtpPassword" value="${settings.smtpPassword}">
                    </div>
                </form>
            </div>
        </div>

        <div class="settings-actions">
            <button class="btn btn-secondary" onclick="resetSettings()">Reset</button>
            <button class="btn btn-primary" onclick="saveSettings()">Save Changes</button>
        </div>
    </div>

    <script>
        function saveSettings() {
            const settings = {
                systemConfig: {
                    systemName: document.getElementById('systemName').value,
                    timezone: document.getElementById('timezone').value,
                    dateFormat: document.getElementById('dateFormat').value,
                    currency: document.getElementById('currency').value
                },
                notifications: {
                    email: document.getElementById('emailNotifications').checked,
                    push: document.getElementById('pushNotifications').checked,
                    types: {
                        transactions: document.getElementById('notifyTransactions').checked,
                        payments: document.getElementById('notifyPayments').checked,
                        system: document.getElementById('notifySystem').checked
                    }
                },
                security: {
                    sessionTimeout: document.getElementById('sessionTimeout').value,
                    passwordPolicy: {
                        complex: document.getElementById('requireComplexPassword').checked,
                        expiry: document.getElementById('passwordExpiry').checked,
                        expiryDays: document.getElementById('passwordExpiryDays').value
                    }
                },
                integrations: {
                    paymentGateway: {
                        gateway: document.getElementById('paymentGateway').value,
                        apiKey: document.getElementById('apiKey').value,
                        apiSecret: document.getElementById('apiSecret').value
                    },
                    emailService: {
                        host: document.getElementById('smtpHost').value,
                        port: document.getElementById('smtpPort').value,
                        username: document.getElementById('smtpUsername').value,
                        password: document.getElementById('smtpPassword').value
                    }
                }
            };

            // Save settings implementation
            // This would typically involve an AJAX call to your backend
            console.log('Saving settings:', settings);
        }

        function resetSettings() {
            if (confirm('Are you sure you want to reset all settings to their default values?')) {
                // Reset settings implementation
                location.reload();
            }
        }

        // Password expiry toggle
        document.getElementById('passwordExpiry').addEventListener('change', function() {
            document.getElementById('passwordExpiryDays').disabled = !this.checked;
        });
    </script>
</body>
</html> 