<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>School Payment Kiosk</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css">
    <style>
        .kiosk-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            text-align: center;
        }

        .kiosk-header {
            text-align: center;
            margin-bottom: 40px;
            padding: 20px 0;
            border-bottom: 3px solid #800000;
        }

        .kiosk-title {
            font-size: 36px;
            color: #800000;
            text-transform: uppercase;
            margin: 0;
            font-weight: bold;
            letter-spacing: 1px;
        }

        .payment-options {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 40px;
            padding: 0 20px;
        }

        .payment-option {
            background-color: white;
            border: 2px solid #800000;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            transition: all 0.3s ease;
            cursor: pointer;
            text-decoration: none;
            color: #333;
        }

        .payment-option:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(128, 0, 0, 0.2);
            background-color: #800000;
            color: white;
        }

        .payment-option h3 {
            font-size: 24px;
            margin: 10px 0;
        }

        .payment-option p {
            font-size: 16px;
            color: inherit;
            margin: 10px 0;
        }

        .payment-icon {
            font-size: 48px;
            color: #800000;
            margin-bottom: 15px;
        }

        .payment-option:hover .payment-icon {
            color: white;
        }

        .queue-status-link {
            display: inline-block;
            margin-top: 40px;
            padding: 15px 30px;
            background-color: #800000;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 18px;
            transition: background-color 0.3s;
        }

        .queue-status-link:hover {
            background-color: #600000;
        }
    </style>
</head>
<body>
    <div class="kiosk-container">
        <div class="kiosk-header">
            <h1 class="kiosk-title">School Payment Kiosk</h1>
        </div>

        <div class="payment-options">
            <a href="${pageContext.request.contextPath}/kiosk/payment/enrollment" class="payment-option">
                <div class="payment-icon">📝</div>
                <h3>Enrollment</h3>
                <p>New student enrollment and registration fees</p>
            </a>

            <a href="${pageContext.request.contextPath}/kiosk/payment/tuition" class="payment-option">
                <div class="payment-icon">💰</div>
                <h3>Tuition</h3>
                <p>Pay your tuition fees</p>
            </a>

            <a href="${pageContext.request.contextPath}/kiosk/payment/library" class="payment-option">
                <div class="payment-icon">📚</div>
                <h3>Library</h3>
                <p>Library fees and penalties</p>
            </a>

            <a href="${pageContext.request.contextPath}/kiosk/payment/lab" class="payment-option">
                <div class="payment-icon">🔬</div>
                <h3>Laboratory</h3>
                <p>Laboratory and equipment fees</p>
            </a>

            <a href="${pageContext.request.contextPath}/kiosk/payment/chemistry" class="payment-option">
                <div class="payment-icon">⚗️</div>
                <h3>Chemistry Lab</h3>
                <p>Chemistry laboratory fees and equipment</p>
            </a>

            <a href="${pageContext.request.contextPath}/kiosk/payment/id" class="payment-option">
                <div class="payment-icon">🪪</div>
                <h3>ID Card</h3>
                <p>ID replacement and validation</p>
            </a>

            <a href="${pageContext.request.contextPath}/kiosk/payment/graduation" class="payment-option">
                <div class="payment-icon">🎓</div>
                <h3>Graduation</h3>
                <p>Graduation fees and requirements</p>
            </a>

            <a href="${pageContext.request.contextPath}/kiosk/payment/transcript" class="payment-option">
                <div class="payment-icon">📄</div>
                <h3>Transcript</h3>
                <p>Request official transcript</p>
            </a>
        </div>

        <a href="${pageContext.request.contextPath}/kiosk/queue/status" class="queue-status-link">View Queue Status</a>
    </div>
</body>
</html> 