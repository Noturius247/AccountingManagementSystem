package com.accounting.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/register")
public class RegisterServlet extends BaseServlet {
    private static final long serialVersionUID = 1L;
    
    // Mock user storage
    private static final List<String> registeredUsers = new ArrayList<>();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setAttribute("pageTitle", "Register");
        forwardToJsp(request, response, "/jsp/register.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        
        // Basic validation
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required");
            forwardToJsp(request, response, "/jsp/register.jsp");
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            forwardToJsp(request, response, "/jsp/register.jsp");
            return;
        }
        
        if (registeredUsers.contains(username)) {
            request.setAttribute("error", "Username already exists");
            forwardToJsp(request, response, "/jsp/register.jsp");
            return;
        }
        
        // Mock registration
        registeredUsers.add(username);
        request.setAttribute("success", "Registration successful! Please login.");
        response.sendRedirect(request.getContextPath() + "/login");
    }
} 