<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="title" value="Laboratory Fee Payment" />
<c:set var="actionUrl" value="${pageContext.request.contextPath}/kiosk/payment/lab/process" />

<c:set var="additionalFields">
    <div class="form-group">
        <label for="labType">Laboratory Type<span class="required">*</span></label>
        <select class="form-control" id="labType" name="labType" required>
            <option value="">Select Laboratory</option>
            <option value="Computer">Computer Laboratory</option>
            <option value="Science">Science Laboratory</option>
            <option value="Chemistry">Chemistry Laboratory</option>
            <option value="Physics">Physics Laboratory</option>
        </select>
    </div>
</c:set>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        document.getElementById('labType').addEventListener('change', function() {
            const labType = this.value;
            let amount = 1500.00;
            
            switch(labType) {
                case 'Computer':
                    amount = 2000.00;
                    break;
                case 'Science':
                    amount = 1500.00;
                    break;
                case 'Chemistry':
                    amount = 1800.00;
                    break;
                case 'Physics':
                    amount = 1700.00;
                    break;
            }
            
            document.getElementById('amount').value = amount.toFixed(2);
        });
    });
</script>

<jsp:include page="base-payment.jsp" /> 