<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="title" value="Tuition Payment" />
<c:set var="actionUrl" value="${pageContext.request.contextPath}/kiosk/payment/tuition/process" />
<c:set var="amount" value="25000.00" />

<c:set var="additionalFields">
            <div class="form-group">
        <label for="semester">Semester<span class="required">*</span></label>
        <select class="form-control input-field" id="semester" name="semester" required>
            <option value="">Select Semester</option>
            <option value="FIRST">First Semester</option>
            <option value="SECOND">Second Semester</option>
            <option value="SUMMER">Summer</option>
        </select>
            </div>

            <div class="form-group">
        <label for="academicYear">Academic Year<span class="required">*</span></label>
        <select class="form-control input-field" id="academicYear" name="academicYear" required>
            <option value="">Select Academic Year</option>
            <c:forEach var="year" begin="2023" end="2030">
                <option value="${year}-${year+1}">${year}-${year+1}</option>
            </c:forEach>
                </select>
            </div>

            <div class="form-group">
        <label for="notes">Notes</label>
        <textarea class="form-control" id="notes" name="notes" rows="3" placeholder="Enter any additional notes or comments"></textarea>
    </div>
</c:set>

<jsp:include page="base-payment.jsp" /> 