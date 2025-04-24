<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="title" value="Graduation Fee Payment"/>
<c:set var="actionUrl" value="${pageContext.request.contextPath}/kiosk/payment/graduation/process"/>
<c:set var="amount" value="3000.00"/>

<c:set var="additionalFields">
    <div class="form-group">
        <label for="graduationType">Graduation Type<span class="required">*</span></label>
        <select class="form-control" id="graduationType" name="graduationType" required>
            <option value="">Select Graduation Type</option>
            <option value="REGULAR">Regular Graduation</option>
            <option value="HONORS">Honors Graduation</option>
            <option value="SUMMA_CUM_LAUDE">Summa Cum Laude</option>
            <option value="MAGNA_CUM_LAUDE">Magna Cum Laude</option>
            <option value="CUM_LAUDE">Cum Laude</option>
        </select>
    </div>
    
    <div class="form-group">
        <label for="graduationDate">Graduation Date<span class="required">*</span></label>
        <input type="date" class="form-control" id="graduationDate" name="graduationDate" required>
    </div>
    
    <div class="form-group">
        <label for="description">Additional Notes</label>
        <textarea class="form-control" id="description" name="description" rows="2" 
                  placeholder="Any special requests or notes for graduation"></textarea>
    </div>
</c:set>

<c:set var="additionalScripts">
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('graduationType').addEventListener('change', function() {
                const type = this.value;
                const amountInput = document.getElementById('amount');
                
                switch(type) {
                    case 'REGULAR':
                        amountInput.value = '3000.00';
                        break;
                    case 'HONORS':
                        amountInput.value = '3500.00';
                        break;
                    case 'SUMMA_CUM_LAUDE':
                    case 'MAGNA_CUM_LAUDE':
                    case 'CUM_LAUDE':
                        amountInput.value = '4000.00';
                        break;
                    default:
                        amountInput.value = '3000.00';
                }
            });
        });
    </script>
</c:set>

<jsp:include page="base-payment.jsp" /> 