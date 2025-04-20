<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Academic Information Management</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-4">
        <h2>Academic Information Management</h2>
        
        <div class="mb-3">
            <a href="<c:url value='/admin/academic-info/new' />" class="btn btn-primary">Add New Academic Information</a>
        </div>

        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Academic Year</th>
                    <th>Semester</th>
                    <th>Program</th>
                    <th>Year Level</th>
                    <th>Created By</th>
                    <th>Created At</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${academicInfoList}" var="info">
                    <tr>
                        <td>${info.academicYear}</td>
                        <td>${info.semester}</td>
                        <td>${info.program}</td>
                        <td>${info.yearLevel}</td>
                        <td>${info.createdBy}</td>
                        <td><fmt:formatDate value="${info.createdAt}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                        <td>
                            <a href="<c:url value='/admin/academic-info/${info.id}/edit' />" class="btn btn-sm btn-warning">Edit</a>
                            <form action="<c:url value='/admin/academic-info/${info.id}/delete' />" method="post" style="display: inline;">
                                <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure you want to delete this academic information?')">Delete</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html> 