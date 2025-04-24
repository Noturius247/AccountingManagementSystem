<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="title" value="Student ID Payment"/>
<c:set var="actionUrl" value="${pageContext.request.contextPath}/kiosk/payment/id/process"/>
<c:set var="amount" value="150.00"/>

<c:set var="additionalFields">
    <div class="form-group">
        <label for="reason">Reason for ID Request<span class="required">*</span></label>
        <select class="form-control" id="reason" name="reason" required>
            <option value="">Select Reason</option>
            <option value="LOST">Lost ID</option>
            <option value="DAMAGED">Damaged ID</option>
            <option value="NEW">New Student</option>
            <option value="REPLACEMENT">Replacement (Other)</option>
        </select>
    </div>
    
    <div class="form-group">
        <label for="description">Additional Details</label>
        <textarea class="form-control" id="description" name="description" rows="2" 
                  placeholder="Please provide additional details about your ID request"></textarea>
    </div>
</c:set>

<jsp:include page="base-payment.jsp" /> 