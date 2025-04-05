package com.accounting.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public abstract class BaseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Common request processing logic
        request.setAttribute("pageTitle", "Accounting Management System");
        request.setAttribute("bootstrapVersion", "5.3.0");
    }

    protected void forwardToJsp(HttpServletRequest request, HttpServletResponse response, String jspPath) 
            throws ServletException, IOException {
        request.getRequestDispatcher(jspPath).forward(request, response);
    }
} 