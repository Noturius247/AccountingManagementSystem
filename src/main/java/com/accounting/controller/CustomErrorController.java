package com.accounting.controller;

import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;

@Controller
public class CustomErrorController implements ErrorController {
    
    @RequestMapping("/error")
    public String handleError(HttpServletRequest request, Model model) {
        Object status = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);
        String errorMessage = "An error occurred";
        String viewName = "error/error";
        
        if (status != null) {
            int statusCode = Integer.parseInt(status.toString());
            switch (statusCode) {
                case 404:
                    errorMessage = "Page not found";
                    viewName = "error/404";
                    break;
                case 403:
                    errorMessage = "Access denied";
                    viewName = "error/403";
                    break;
                case 500:
                    errorMessage = "Internal server error";
                    viewName = "error/500";
                    break;
            }
        }
        
        model.addAttribute("errorMessage", errorMessage);
        return viewName;
    }
} 