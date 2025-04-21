<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<header class="admin-header">
    <div class="header-content">
        <div class="logo">
            <h1>Accounting Management System</h1>
        </div>
        <div class="user-info">
            <sec:authorize access="isAuthenticated()">
                <span>Welcome, <sec:authentication property="principal.username"/></span>
                <form action="<c:url value='/logout'/>" method="post" style="display: inline;">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="logout-btn">Logout</button>
                </form>
            </sec:authorize>
        </div>
    </div>
</header> 