<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="title" value="Chemistry Laboratory Fee Payment"/>
<c:set var="actionUrl" value="/kiosk/payment/chemistry/process"/>
<c:set var="amount" value="1500.00"/>

<c:set var="additionalFields">
    <div class="mb-3">
        <label for="labType" class="form-label">Laboratory Type</label>
        <select class="form-control" id="labType" name="labType" required>
            <option value="">Select Laboratory Type</option>
            <option value="ORGANIC">Organic Chemistry Lab</option>
            <option value="INORGANIC">Inorganic Chemistry Lab</option>
            <option value="ANALYTICAL">Analytical Chemistry Lab</option>
            <option value="PHYSICAL">Physical Chemistry Lab</option>
        </select>
    </div>
    
    <div class="mb-3">
        <label for="semester" class="form-label">Semester</label>
        <select class="form-control" id="semester" name="semester" required>
            <option value="">Select Semester</option>
            <option value="1">First Semester</option>
            <option value="2">Second Semester</option>
            <option value="3">Summer</option>
        </select>
    </div>
    
    <div class="mb-3">
        <label for="academicYear" class="form-label">Academic Year</label>
        <input type="text" class="form-control" id="academicYear" name="academicYear" 
               placeholder="e.g., 2023-2024" required>
    </div>
</c:set>

<%@ include file="base-payment.jsp" %> 