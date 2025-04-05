package com.accounting.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends BaseServlet {
    private static final long serialVersionUID = 1L;
    
    // Mock credentials
    private static final String MOCK_USERNAME = "admin";
    private static final String MOCK_PASSWORD = "password";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        
        request.setAttribute("pageTitle", "Login");
        forwardToJsp(request, response, "/jsp/login.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        if (MOCK_USERNAME.equals(username) && MOCK_PASSWORD.equals(password)) {
            HttpSession session = request.getSession(true);
            session.setAttribute("user", username);
            session.setAttribute("role", "ADMIN");
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            request.setAttribute("error", "Invalid username or password");
            request.setAttribute("pageTitle", "Login");
            forwardToJsp(request, response, "/jsp/login.jsp");
        }
    }
} 