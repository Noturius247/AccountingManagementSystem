<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="title" value="Library Fee Payment"/>
<c:set var="actionUrl" value="/kiosk/payment/library/process"/>
<c:set var="amount" value="500.00"/>

<c:set var="additionalFields">
    <div class="mb-3">
        <label for="feeType" class="form-label">Fee Type</label>
        <select class="form-control" id="feeType" name="feeType" required>
            <option value="">Select Fee Type</option>
            <option value="MEMBERSHIP">Library Membership</option>
            <option value="LATE_FEE">Late Return Fee</option>
            <option value="DAMAGE_FEE">Damage Fee</option>
            <option value="LOST_BOOK">Lost Book Replacement</option>
        </select>
    </div>
    
    <div class="mb-3">
        <label for="description" class="form-label">Description</label>
        <textarea class="form-control" id="description" name="description" rows="2" placeholder="Enter additional details about the fee"></textarea>
    </div>
</c:set>

<%@ include file="base-payment.jsp" %>

<script>
    document.getElementById('feeType').addEventListener('change', function() {
        const feeType = this.value;
        const amountInput = document.getElementById('amount');
        
        switch(feeType) {
            case 'MEMBERSHIP':
                amountInput.value = '500.00';
                break;
            case 'LATE_FEE':
                amountInput.value = '50.00';
                break;
            case 'DAMAGE_FEE':
                amountInput.value = '100.00';
                break;
            case 'LOST_BOOK':
                amountInput.value = '1000.00';
                break;
            default:
                amountInput.value = '500.00';
        }
    });
</script> 