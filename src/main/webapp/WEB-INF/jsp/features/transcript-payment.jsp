<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Transcript Payment</title>
    <jsp:include page="../includes/header.jsp" />
    <style>
        .payment-form {
            max-width: 600px;
            margin: 20px auto;
            padding: 20px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        .form-group {
            margin-bottom: 20px;
        }
        .error-message {
            color: #dc3545;
            margin-top: 10px;
            padding: 10px;
            border-radius: 4px;
            background-color: #f8d7da;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="payment-form">
            <h2 class="text-center mb-4">Transcript Request Payment</h2>
            
            <c:if test="${not empty error}">
                <div class="error-message">
                    ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/payment/transcript/process" method="post">
                <div class="form-group">
                    <label for="studentId">Student ID:</label>
                    <input type="text" class="form-control" id="studentId" name="studentId" 
                           value="${studentId}" required>
                </div>

                <div class="form-group">
                    <label for="copies">Number of Copies:</label>
                    <select class="form-control" id="copies" name="copies" required>
                        <option value="">Select number of copies</option>
                        <c:forEach begin="1" end="10" var="i">
                            <option value="${i}" ${copies == i ? 'selected' : ''}>${i}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="purpose">Purpose:</label>
                    <select class="form-control" id="purpose" name="purpose" required>
                        <option value="">Select purpose</option>
                        <option value="EMPLOYMENT" ${purpose == 'EMPLOYMENT' ? 'selected' : ''}>Employment</option>
                        <option value="FURTHER_STUDIES" ${purpose == 'FURTHER_STUDIES' ? 'selected' : ''}>Further Studies</option>
                        <option value="BOARD_EXAM" ${purpose == 'BOARD_EXAM' ? 'selected' : ''}>Board Examination</option>
                        <option value="PERSONAL" ${purpose == 'PERSONAL' ? 'selected' : ''}>Personal Use</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Base Price per Copy:</label>
                    <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text">₱</span>
                        </div>
                        <input type="text" class="form-control" value="200.00" readonly>
                    </div>
                </div>

                <div class="form-group">
                    <label>Total Amount:</label>
                    <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text">₱</span>
                        </div>
                        <input type="text" class="form-control" name="amount" id="totalAmount" readonly>
                    </div>
                </div>

                <div class="text-center">
                    <button type="submit" class="btn btn-primary">Proceed to Payment</button>
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>
    </div>

    <script>
        document.getElementById('copies').addEventListener('change', function() {
            calculateTotal();
        });

        function calculateTotal() {
            const copies = document.getElementById('copies').value || 0;
            const basePrice = 200.00;
            const total = copies * basePrice;
            document.getElementById('totalAmount').value = total.toFixed(2);
        }

        // Calculate initial total
        calculateTotal();
    </script>

    <jsp:include page="../includes/footer.jsp" />
</body>
</html> 