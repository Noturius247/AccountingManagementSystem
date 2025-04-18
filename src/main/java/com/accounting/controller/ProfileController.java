package com.accounting.controller;

import com.accounting.model.User;
import com.accounting.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/profile")
public class ProfileController {
    
    @Autowired
    private UserService userService;
    
    @GetMapping
    public String viewProfile(Model model, Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }
        
        String username = authentication.getName();
        User user = userService.findByUsernameWithCollections(username);
        
        model.addAttribute("pageTitle", "User Profile");
        model.addAttribute("profile", user);
        return "user/profile";
    }
    
    @PostMapping
    public String updateProfile(@ModelAttribute User userData, 
                              Model model, 
                              Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }
        
        String username = authentication.getName();
        userService.updateProfile(username, userData);
        
        model.addAttribute("success", "Profile updated successfully");
        model.addAttribute("profile", userService.findByUsernameWithCollections(username));
        return "user/profile";
    }
} 