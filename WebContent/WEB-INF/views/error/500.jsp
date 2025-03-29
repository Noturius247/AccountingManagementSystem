<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Internal Server Error</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 0;
        }
        .error-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            padding: 2rem;
            text-align: center;
            width: 100%;
            max-width: 500px;
        }
        .error-icon {
            font-size: 5rem;
            color: #764ba2;
            margin-bottom: 1rem;
        }
        .error-code {
            font-size: 3rem;
            font-weight: bold;
            color: #764ba2;
            margin-bottom: 1rem;
        }
        .error-message {
            color: #666;
            margin-bottom: 2rem;
        }
        .btn-home {
            background: #764ba2;
            border: none;
            border-radius: 8px;
            padding: 0.8rem 2rem;
            color: white;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        .btn-home:hover {
            background: #667eea;
            transform: translateY(-2px);
            color: white;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <i class="fas fa-exclamation-triangle error-icon"></i>
        <div class="error-code">500</div>
        <div class="error-message">
            <h2>Internal Server Error</h2>
            <p>Something went wrong on our end. We're working to fix the issue. Please try again later.</p>
        </div>
        <a href="${pageContext.request.contextPath}/" class="btn btn-home">
            <i class="fas fa-home me-2"></i>Go to Homepage
        </a>
    </div>
</body>
</html> 