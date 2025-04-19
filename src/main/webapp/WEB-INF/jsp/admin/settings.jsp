<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="admin-content">
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2">System Settings</h1>
        <div class="btn-toolbar mb-2 mb-md-0">
            <button type="button" class="btn btn-primary" onclick="saveSettings()">
                <i class="bi bi-save"></i> Save Changes
            </button>
        </div>
    </div>

    <!-- System Settings -->
    <div class="row">
        <!-- General Settings -->
        <div class="col-md-6">
            <div class="card shadow mb-4">
                <div class="card-header">
                    <h5 class="mb-0">General Settings</h5>
                </div>
                <div class="card-body">
                    <form id="generalSettings">
                        <div class="mb-3">
                            <label class="form-label">System Name</label>
                            <input type="text" class="form-control" name="systemName" value="${settings.systemName}">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">System Email</label>
                            <input type="email" class="form-control" name="systemEmail" value="${settings.systemEmail}">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Time Zone</label>
                            <select class="form-select" name="timeZone">
                                <c:forEach items="${timeZones}" var="zone">
                                    <option value="${zone}" ${settings.timeZone == zone ? 'selected' : ''}>${zone}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Date Format</label>
                            <select class="form-select" name="dateFormat">
                                <option value="MM/dd/yyyy" ${settings.dateFormat == 'MM/dd/yyyy' ? 'selected' : ''}>MM/DD/YYYY</option>
                                <option value="dd/MM/yyyy" ${settings.dateFormat == 'dd/MM/yyyy' ? 'selected' : ''}>DD/MM/YYYY</option>
                                <option value="yyyy-MM-dd" ${settings.dateFormat == 'yyyy-MM-dd' ? 'selected' : ''}>YYYY-MM-DD</option>
                            </select>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Security Settings -->
        <div class="col-md-6">
            <div class="card shadow mb-4">
                <div class="card-header">
                    <h5 class="mb-0">Security Settings</h5>
                </div>
                <div class="card-body">
                    <form id="securitySettings">
                        <div class="mb-3">
                            <label class="form-label">Password Policy</label>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="requireUpperCase" 
                                    ${settings.passwordPolicy.requireUpperCase ? 'checked' : ''}>
                                <label class="form-check-label">Require uppercase letters</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="requireNumbers" 
                                    ${settings.passwordPolicy.requireNumbers ? 'checked' : ''}>
                                <label class="form-check-label">Require numbers</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="requireSpecialChars" 
                                    ${settings.passwordPolicy.requireSpecialChars ? 'checked' : ''}>
                                <label class="form-check-label">Require special characters</label>
                            </div>
                            <div class="mb-3 mt-2">
                                <label class="form-label">Minimum Password Length</label>
                                <input type="number" class="form-control" name="minPasswordLength" 
                                    value="${settings.passwordPolicy.minLength}" min="6" max="32">
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Session Timeout (minutes)</label>
                            <input type="number" class="form-control" name="sessionTimeout" 
                                value="${settings.sessionTimeout}" min="5" max="1440">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Maximum Login Attempts</label>
                            <input type="number" class="form-control" name="maxLoginAttempts" 
                                value="${settings.maxLoginAttempts}" min="1" max="10">
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Notification Settings -->
        <div class="col-md-6">
            <div class="card shadow mb-4">
                <div class="card-header">
                    <h5 class="mb-0">Notification Settings</h5>
                </div>
                <div class="card-body">
                    <form id="notificationSettings">
                        <div class="mb-3">
                            <label class="form-label">Email Notifications</label>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="emailNewUser" 
                                    ${settings.notifications.emailNewUser ? 'checked' : ''}>
                                <label class="form-check-label">New user registration</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="emailTransaction" 
                                    ${settings.notifications.emailTransaction ? 'checked' : ''}>
                                <label class="form-check-label">New transactions</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="emailSystemAlert" 
                                    ${settings.notifications.emailSystemAlert ? 'checked' : ''}>
                                <label class="form-check-label">System alerts</label>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">SMS Notifications</label>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="smsTransaction" 
                                    ${settings.notifications.smsTransaction ? 'checked' : ''}>
                                <label class="form-check-label">Transaction alerts</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="smsSystemAlert" 
                                    ${settings.notifications.smsSystemAlert ? 'checked' : ''}>
                                <label class="form-check-label">System alerts</label>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Backup Settings -->
        <div class="col-md-6">
            <div class="card shadow mb-4">
                <div class="card-header">
                    <h5 class="mb-0">Backup Settings</h5>
                </div>
                <div class="card-body">
                    <form id="backupSettings">
                        <div class="mb-3">
                            <label class="form-label">Backup Frequency</label>
                            <select class="form-select" name="backupFrequency">
                                <option value="DAILY" ${settings.backup.frequency == 'DAILY' ? 'selected' : ''}>Daily</option>
                                <option value="WEEKLY" ${settings.backup.frequency == 'WEEKLY' ? 'selected' : ''}>Weekly</option>
                                <option value="MONTHLY" ${settings.backup.frequency == 'MONTHLY' ? 'selected' : ''}>Monthly</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Backup Time</label>
                            <input type="time" class="form-control" name="backupTime" value="${settings.backup.time}">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Retention Period (days)</label>
                            <input type="number" class="form-control" name="retentionPeriod" 
                                value="${settings.backup.retentionPeriod}" min="1" max="365">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Backup Location</label>
                            <input type="text" class="form-control" name="backupLocation" value="${settings.backup.location}">
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function saveSettings() {
        const settings = {
            general: Object.fromEntries(new FormData(document.getElementById('generalSettings'))),
            security: Object.fromEntries(new FormData(document.getElementById('securitySettings'))),
            notifications: Object.fromEntries(new FormData(document.getElementById('notificationSettings'))),
            backup: Object.fromEntries(new FormData(document.getElementById('backupSettings')))
        };

        fetch(`${pageContext.request.contextPath}/admin/settings`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(settings)
        })
        .then(response => {
            if (response.ok) {
                alert('Settings saved successfully');
                window.location.reload();
            } else {
                throw new Error('Failed to save settings');
            }
        })
        .catch(error => {
            alert(error.message);
        });
    }
</script> 