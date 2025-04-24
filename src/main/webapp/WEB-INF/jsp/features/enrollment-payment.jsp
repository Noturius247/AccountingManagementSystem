<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="title" value="New Student Enrollment Payment" />
<c:set var="actionUrl" value="${pageContext.request.contextPath}/kiosk/payment/enrollment/process" />
<c:set var="amount" value="25000.00" />
<c:set var="skipStudentVerification" value="true" />

<c:set var="additionalFields">
    <div class="form-group">
        <label for="fullName">Full Name<span class="required">*</span></label>
        <input type="text" class="form-control" id="fullName" name="fullName" required>
    </div>

    <div class="form-group">
        <label for="email">Email Address<span class="required">*</span></label>
        <input type="email" class="form-control" id="email" name="email" required>
    </div>

    <div class="form-group">
        <label for="contactNumber">Contact Number<span class="required">*</span></label>
        <input type="tel" class="form-control" id="contactNumber" name="contactNumber" required>
    </div>

    <div class="form-group">
        <label for="program">Intended Program<span class="required">*</span></label>
        <select class="form-control" id="program" name="program" required>
            <option value="">Select Program</option>
            <option value="BSCS">BS Computer Science</option>
            <option value="BSIT">BS Information Technology</option>
            <option value="BSIS">BS Information Systems</option>
            <option value="BSCE">BS Computer Engineering</option>
        </select>
    </div>

    <div class="form-group">
        <label for="academicYear">Academic Year<span class="required">*</span></label>
        <select class="form-control" id="academicYear" name="academicYear" required>
            <option value="">Select Academic Year</option>
            <option value="2024-2025">2024-2025</option>
            <option value="2025-2026">2025-2026</option>
        </select>
    </div>

    <div class="form-group">
        <label for="semester">Semester<span class="required">*</span></label>
        <select class="form-control" id="semester" name="semester" required>
            <option value="">Select Semester</option>
            <option value="FIRST">First Semester</option>
            <option value="SECOND">Second Semester</option>
            <option value="SUMMER">Summer</option>
        </select>
    </div>

    <div class="alert alert-info mt-3">
        <i class="bi bi-info-circle"></i>
        <small>Note: After successful payment, you will receive a reference number for your enrollment registration.</small>
    </div>
</c:set>

<jsp:include page="base-payment.jsp" /> 