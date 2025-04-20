package com.accounting.controller;

import com.accounting.model.User;
import com.accounting.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/user/profile")
public class UserProfileController {

    @Autowired
    private UserService userService;

    @GetMapping
    public String showProfile(Authentication authentication, Model model) {
        String username = authentication.getName();
        User user = userService.findByUsernameWithCollections(username);
        model.addAttribute("user", user);
        return "user/profile";
    }
} 