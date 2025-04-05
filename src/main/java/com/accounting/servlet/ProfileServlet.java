package com.accounting.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/profile")
public class ProfileServlet extends BaseServlet {
    private static final long serialVersionUID = 1L;
    
    // Mock user profile data
    private static final Map<String, Map<String, String>> userProfiles = new HashMap<>();
    
    static {
        // Initialize mock profile for admin user
        Map<String, String> adminProfile = new HashMap<>();
        adminProfile.put("fullName", "Admin User");
        adminProfile.put("email", "admin@example.com");
        adminProfile.put("phone", "+1234567890");
        adminProfile.put("department", "Administration");
        adminProfile.put("role", "System Administrator");
        adminProfile.put("joinDate", "2024-01-01");
        userProfiles.put("admin", adminProfile);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String username = (String) session.getAttribute("user");
        Map<String, String> userProfile = userProfiles.get(username);
        
        request.setAttribute("pageTitle", "User Profile");
        request.setAttribute("profile", userProfile);
        forwardToJsp(request, response, "/jsp/profile.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String username = (String) session.getAttribute("user");
        Map<String, String> profile = userProfiles.get(username);
        
        // Update profile with form data
        profile.put("fullName", request.getParameter("fullName"));
        profile.put("email", request.getParameter("email"));
        profile.put("phone", request.getParameter("phone"));
        profile.put("department", request.getParameter("department"));
        
        request.setAttribute("success", "Profile updated successfully");
        request.setAttribute("profile", profile);
        forwardToJsp(request, response, "/jsp/profile.jsp");
    }
} 