<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="<c:url value='/resources/css/admin.css'/>">
</head>
<body>
    <div class="admin-container">
        <jsp:include page="partials/header.jsp"/>
        <div class="admin-content">
            <jsp:include page="partials/sidebar.jsp"/>
            <main class="main-content">
                <c:choose>
                    <c:when test="${contentPage == 'dashboard'}">
                        <jsp:include page="partials/dashboard.jsp" />
                    </c:when>
                    <c:when test="${contentPage == 'users'}">
                        <jsp:include page="partials/users.jsp" />
                    </c:when>
                    <c:when test="${contentPage == 'managers'}">
                        <jsp:include page="managers.jsp" />
                    </c:when>
                    <c:when test="${contentPage == 'transactions'}">
                        <jsp:include page="partials/transactions.jsp" />
                    </c:when>
                    <c:otherwise>
                        <jsp:include page="partials/dashboard.jsp" />
                    </c:otherwise>
                </c:choose>
            </main>
        </div>
    </div>
</body>
</html> 