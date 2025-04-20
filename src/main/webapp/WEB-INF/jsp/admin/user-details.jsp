<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">User Details</h3>
                    <div class="card-tools">
                        <a href="/admin/users" class="btn btn-sm btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back to Users
                        </a>
                    </div>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h4>Basic Information</h4>
                            <table class="table table-bordered">
                                <tr>
                                    <th>Username:</th>
                                    <td>${user.username}</td>
                                </tr>
                                <tr>
                                    <th>Email:</th>
                                    <td>${user.email}</td>
                                </tr>
                                <tr>
                                    <th>Full Name:</th>
                                    <td>${user.fullName}</td>
                                </tr>
                                <tr>
                                    <th>Role:</th>
                                    <td>${user.role}</td>
                                </tr>
                                <tr>
                                    <th>Status:</th>
                                    <td>
                                        <span class="badge ${user.enabled ? 'badge-success' : 'badge-danger'}">
                                            ${user.enabled ? 'Active' : 'Inactive'}
                                        </span>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="col-md-6">
                            <h4>Activity Summary</h4>
                            <table class="table table-bordered">
                                <tr>
                                    <th>Total Transactions:</th>
                                    <td>${user.transactions.size()}</td>
                                </tr>
                                <tr>
                                    <th>Total Documents:</th>
                                    <td>${user.documents.size()}</td>
                                </tr>
                                <tr>
                                    <th>Unread Notifications:</th>
                                    <td>${user.notifications.stream().filter(n -> !n.isRead()).count()}</td>
                                </tr>
                            </table>
                        </div>
                    </div>

                    <div class="row mt-4">
                        <div class="col-12">
                            <h4>Recent Transactions</h4>
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Date</th>
                                            <th>Type</th>
                                            <th>Amount</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${user.transactions}" var="transaction" end="5">
                                            <tr>
                                                <td><fmt:formatDate value="${transaction.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                                                <td>${transaction.type}</td>
                                                <td><fmt:formatNumber value="${transaction.amount}" type="currency"/></td>
                                                <td>
                                                    <span class="badge ${transaction.status == 'COMPLETED' ? 'badge-success' : 
                                                                        transaction.status == 'PENDING' ? 'badge-warning' : 'badge-danger'}">
                                                        ${transaction.status}
                                                    </span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <div class="row mt-4">
                        <div class="col-12">
                            <h4>Recent Documents</h4>
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Document Type</th>
                                            <th>Upload Date</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${user.documents}" var="document" end="5">
                                            <tr>
                                                <td>${document.documentType}</td>
                                                <td><fmt:formatDate value="${document.uploadDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                                                <td>
                                                    <span class="badge ${document.status == 'APPROVED' ? 'badge-success' : 
                                                                        document.status == 'PENDING' ? 'badge-warning' : 'badge-danger'}">
                                                        ${document.status}
                                                    </span>
                                                </td>
                                                <td>
                                                    <a href="/documents/${document.id}/download" class="btn btn-sm btn-primary">
                                                        <i class="fas fa-download"></i> Download
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div> 