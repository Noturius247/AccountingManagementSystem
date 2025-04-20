<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="admin-content" id="queue-content">
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2">Queue Management</h1>
        <div class="btn-toolbar mb-2 mb-md-0">
            <button type="button" class="btn btn-warning me-2" onclick="resetQueue()">
                <i class="bi bi-arrow-counterclockwise"></i> Reset Queue
            </button>
            <button type="button" class="btn btn-primary" onclick="nextQueue()">
                <i class="bi bi-arrow-right"></i> Next Queue
            </button>
        </div>
    </div>

    <!-- Current Queue Status -->
    <div class="row mb-4">
        <div class="col-md-4">
            <div class="card shadow">
                <div class="card-body text-center">
                    <h5 class="card-title">Current Queue</h5>
                    <h2 class="display-4">#${currentQueue}</h2>
                    <p class="text-muted">Currently Serving</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card shadow">
                <div class="card-body text-center">
                    <h5 class="card-title">Total in Queue</h5>
                    <h2 class="display-4">${totalInQueue}</h2>
                    <p class="text-muted">Waiting</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card shadow">
                <div class="card-body text-center">
                    <h5 class="card-title">Average Wait Time</h5>
                    <h2 class="display-4">15 min</h2>
                    <p class="text-muted">Estimated</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Queue List -->
    <div class="card shadow">
        <div class="card-header">
            <h5 class="mb-0">Waiting List</h5>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Position</th>
                            <th>User</th>
                            <th>Type</th>
                            <th>Time</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="queueTableBody">
                        <c:forEach items="${waitingList}" var="queue">
                            <tr>
                                <td>#${queue.position}</td>
                                <td>${queue.user.username}</td>
                                <td>${queue.type}</td>
                                <td><fmt:formatDate value="${queue.createdAt}" pattern="HH:mm"/></td>
                                <td>
                                    <span class="badge bg-${queue.status == 'WAITING' ? 'warning' : 
                                                          queue.status == 'PROCESSING' ? 'info' : 'success'}">
                                        ${queue.status}
                                    </span>
                                </td>
                                <td>
                                    <button class="btn btn-sm btn-primary" onclick="processQueue('${queue.id}')">
                                        <i class="bi bi-check-circle"></i>
                                    </button>
                                    <button class="btn btn-sm btn-danger" onclick="cancelQueue('${queue.id}')">
                                        <i class="bi bi-x-circle"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Queue History -->
    <div class="card shadow mt-4">
        <div class="card-header">
            <h5 class="mb-0">Queue History</h5>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Queue #</th>
                            <th>User</th>
                            <th>Type</th>
                            <th>Start Time</th>
                            <th>End Time</th>
                            <th>Duration</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${queueHistory}" var="history">
                            <tr>
                                <td>#${history.queueNumber}</td>
                                <td>${history.user.username}</td>
                                <td>${history.type}</td>
                                <td><fmt:formatDate value="${history.startTime}" pattern="HH:mm"/></td>
                                <td><fmt:formatDate value="${history.endTime}" pattern="HH:mm"/></td>
                                <td>${history.duration} min</td>
                                <td>
                                    <span class="badge bg-${history.status == 'COMPLETED' ? 'success' : 'danger'}">
                                        ${history.status}
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script>
    function nextQueue() {
        fetch(`${pageContext.request.contextPath}/admin/queue/next`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        })
        .then(response => {
            if (response.ok) {
                window.location.reload();
            } else {
                throw new Error('Failed to process next queue');
            }
        })
        .catch(error => {
            alert(error.message);
        });
    }

    function resetQueue() {
        if (confirm('Are you sure you want to reset the queue? This will clear all waiting users.')) {
            fetch(`${pageContext.request.contextPath}/admin/queue/reset`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                }
            })
            .then(response => {
                if (response.ok) {
                    window.location.reload();
                } else {
                    throw new Error('Failed to reset queue');
                }
            })
            .catch(error => {
                alert(error.message);
            });
        }
    }

    function processQueue(queueId) {
        fetch(`${pageContext.request.contextPath}/admin/queue/${queueId}/process`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        })
        .then(response => {
            if (response.ok) {
                window.location.reload();
            } else {
                throw new Error('Failed to process queue');
            }
        })
        .catch(error => {
            alert(error.message);
        });
    }

    function cancelQueue(queueId) {
        if (confirm('Are you sure you want to cancel this queue?')) {
            fetch(`${pageContext.request.contextPath}/admin/queue/${queueId}/cancel`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                }
            })
            .then(response => {
                if (response.ok) {
                    window.location.reload();
                } else {
                    throw new Error('Failed to cancel queue');
                }
            })
            .catch(error => {
                alert(error.message);
            });
        }
    }
</script> 