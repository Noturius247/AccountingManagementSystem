package com.accounting.servlet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class BaseServlet extends HttpServlet {
    
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