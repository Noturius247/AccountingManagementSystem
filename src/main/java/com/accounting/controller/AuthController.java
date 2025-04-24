package com.accounting.controller;

import com.accounting.model.User;
import com.accounting.model.RegistrationStatus;
import com.accounting.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Controller
public class AuthController {

    private static final Logger logger = LoggerFactory.getLogger(AuthController.class);

    @Autowired
    private UserService userService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @GetMapping("/")
    public String home() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        logger.debug("Home page accessed. Authentication: {}", auth);
        
        if (auth == null || auth.getName().equals("anonymousUser")) {
            logger.debug("User not authenticated, redirecting to login");
            return "redirect:/login";
        }

        if (auth.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_ADMIN"))) {
            return "redirect:/admin/dashboard";
        } else if (auth.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_MANAGER"))) {
            return "redirect:/manager/dashboard";
        } else if (auth.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_USER"))) {
            return "redirect:/user/dashboard";
        } else if (auth.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_STUDENT"))) {
            return "redirect:/student/dashboard";
        }

        logger.warn("User has no recognized role, redirecting to login");
        return "redirect:/login";
    }

    @GetMapping("/login")
    public String loginPage(Model model, 
                          @RequestParam(required = false) String error,
                          @RequestParam(required = false) String logout) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        
        if (auth != null && auth.isAuthenticated() && !auth.getName().equals("anonymousUser")) {
            logger.debug("Already authenticated user accessing login page. User: {}", auth.getName());
            return "redirect:/";
        }

        if (error != null) {
            model.addAttribute("error", "Invalid username or password");
            logger.debug("Login error message added to model");
        }

        if (logout != null) {
            model.addAttribute("message", "You have been logged out successfully");
            logger.debug("Logout message added to model");
        }

        return "login";
    }

    @GetMapping("/register")
    public String registerPage(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        
        if (auth != null && auth.isAuthenticated() && !auth.getName().equals("anonymousUser")) {
            logger.debug("Already authenticated user accessing register page. User: {}", auth.getName());
            return "redirect:/";
        }

        model.addAttribute("user", new User());
        return "register";
    }

    @PostMapping("/register")
    public String registerUser(@ModelAttribute User user, Model model) {
        try {
            logger.debug("Attempting to register new user: {}", user.getUsername());
            
            // Set default values for required fields
            user.setRole(user.getRole() == null ? "ROLE_USER" : user.getRole());
            user.setEnabled(true);
            user.setAccountNonExpired(true);
            user.setAccountNonLocked(true);
            user.setCredentialsNonExpired(true);
            user.setOnlineStatus(false);
            user.setBalance(BigDecimal.ZERO);
            user.setRegistrationStatus(RegistrationStatus.PENDING);
            
            // Set timestamps
            LocalDateTime now = LocalDateTime.now();
            user.setCreatedAt(now);
            user.setUpdatedAt(now);
            user.setLastActivity(now);
            
            // Encode the password before saving
            user.setPassword(passwordEncoder.encode(user.getPassword()));
            
            // Validate required fields
            if (user.getUsername() == null || user.getUsername().trim().isEmpty() ||
                user.getEmail() == null || user.getEmail().trim().isEmpty() ||
                user.getPassword() == null || user.getPassword().trim().isEmpty()) {
                throw new IllegalArgumentException("Username, email and password are required");
            }
            
            // Save the user
            userService.registerUser(user);
            
            logger.info("Successfully registered new user: {}", user.getUsername());
            return "redirect:/login?registered=true";
        } catch (Exception e) {
            logger.error("Registration failed for user: {}. Error: {}", user.getUsername(), e.getMessage());
            model.addAttribute("error", "Registration failed: " + e.getMessage());
            return "register";
        }
    }
} 