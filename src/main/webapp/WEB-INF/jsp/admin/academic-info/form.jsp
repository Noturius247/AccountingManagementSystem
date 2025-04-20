<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
<head>
    <title>${empty academicInfo.id ? 'Create' : 'Edit'} Academic Information</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-4">
        <h2>${empty academicInfo.id ? 'Create' : 'Edit'} Academic Information</h2>
        
        <form:form modelAttribute="academicInfo" method="post" cssClass="mt-4">
            <form:hidden path="id" />
            
            <div class="form-group">
                <form:label path="academicYear">Academic Year</form:label>
                <form:select path="academicYear" cssClass="form-control" required="true">
                    <form:option value="">Select Academic Year</form:option>
                    <c:forEach var="year" begin="2020" end="2030">
                        <form:option value="${year}-${year+1}">${year}-${year+1}</form:option>
                    </c:forEach>
                </form:select>
                <form:errors path="academicYear" cssClass="text-danger" />
            </div>
            
            <div class="form-group">
                <form:label path="semester">Semester</form:label>
                <form:select path="semester" cssClass="form-control" required="true">
                    <form:option value="">Select Semester</form:option>
                    <form:option value="1ST">First Semester</form:option>
                    <form:option value="2ND">Second Semester</form:option>
                    <form:option value="SUMMER">Summer</form:option>
                </form:select>
                <form:errors path="semester" cssClass="text-danger" />
            </div>
            
            <div class="form-group">
                <form:label path="program">Program</form:label>
                <form:input path="program" cssClass="form-control" required="true" />
                <form:errors path="program" cssClass="text-danger" />
            </div>
            
            <div class="form-group">
                <form:label path="yearLevel">Year Level</form:label>
                <form:select path="yearLevel" cssClass="form-control" required="true">
                    <form:option value="">Select Year Level</form:option>
                    <form:option value="1">First Year</form:option>
                    <form:option value="2">Second Year</form:option>
                    <form:option value="3">Third Year</form:option>
                    <form:option value="4">Fourth Year</form:option>
                </form:select>
                <form:errors path="yearLevel" cssClass="text-danger" />
            </div>
            
            <div class="form-group">
                <button type="submit" class="btn btn-primary">${empty academicInfo.id ? 'Create' : 'Update'}</button>
                <a href="<c:url value='/admin/academic-info' />" class="btn btn-secondary">Cancel</a>
            </div>
        </form:form>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html> 