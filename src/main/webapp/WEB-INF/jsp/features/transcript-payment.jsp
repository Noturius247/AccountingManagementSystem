<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="title" value="Transcript Request Payment"/>
<c:set var="actionUrl" value="/kiosk/payment/transcript/process"/>
<c:set var="amount" value="200.00"/>

<c:set var="additionalFields">
    <div class="mb-3">
        <label for="copies" class="form-label">Number of Copies</label>
        <input type="number" class="form-control" id="copies" name="copies" 
               min="1" max="10" value="1" required>
        <div class="form-text">Each copy costs ₱200.00</div>
    </div>
    
    <div class="mb-3">
        <label for="purpose" class="form-label">Purpose</label>
        <select class="form-control" id="purpose" name="purpose" required>
            <option value="">Select Purpose</option>
            <option value="SCHOLARSHIP">Scholarship Application</option>
            <option value="TRANSFER">School Transfer</option>
            <option value="EMPLOYMENT">Employment</option>
            <option value="GRADUATE_SCHOOL">Graduate School Application</option>
            <option value="OTHER">Other</option>
        </select>
    </div>
    
    <div class="mb-3">
        <label for="deliveryMethod" class="form-label">Delivery Method</label>
        <select class="form-control" id="deliveryMethod" name="deliveryMethod" required>
            <option value="">Select Delivery Method</option>
            <option value="PICKUP">Pick Up</option>
            <option value="COURIER">Courier Delivery (Additional ₱100.00)</option>
        </select>
    </div>
</c:set>

<%@ include file="base-payment.jsp" %>

<script>
    document.getElementById('copies').addEventListener('change', function() {
        const copies = parseInt(this.value);
        const deliveryMethod = document.getElementById('deliveryMethod').value;
        const amountInput = document.getElementById('amount');
        const basePrice = 200.00;
        const courierFee = 100.00;
        
        let totalAmount = copies * basePrice;
        if (deliveryMethod === 'COURIER') {
            totalAmount += courierFee;
        }
        
        amountInput.value = totalAmount.toFixed(2);
    });
    
    document.getElementById('deliveryMethod').addEventListener('change', function() {
        const copies = parseInt(document.getElementById('copies').value);
        const amountInput = document.getElementById('amount');
        const basePrice = 200.00;
        const courierFee = 100.00;
        
        let totalAmount = copies * basePrice;
        if (this.value === 'COURIER') {
            totalAmount += courierFee;
        }
        
        amountInput.value = totalAmount.toFixed(2);
    });
</script> 