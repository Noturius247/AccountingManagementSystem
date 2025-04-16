<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Student Registration</title>
    <link rel="stylesheet" href="/css/styles.css">
</head>
<body>
    <div class="container">
        <h2>Student Registration</h2>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <form action="/student-registration" method="post">
            <input type="hidden" name="username" value="${username}">
            
            <div class="form-group">
                <label for="program">Program:</label>
                <select name="program" id="program" required>
                    <option value="">Select Program</option>
                    <option value="BSCS">BS Computer Science</option>
                    <option value="BSIT">BS Information Technology</option>
                    <option value="BSIS">BS Information Systems</option>
                    <option value="BSCE">BS Computer Engineering</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="yearLevel">Year Level:</label>
                <select name="yearLevel" id="yearLevel" required>
                    <option value="">Select Year Level</option>
                    <option value="1">1st Year</option>
                    <option value="2">2nd Year</option>
                    <option value="3">3rd Year</option>
                    <option value="4">4th Year</option>
                </select>
            </div>
            
            <button type="submit" class="btn btn-primary">Register</button>
        </form>
    </div>
</body>
</html> 