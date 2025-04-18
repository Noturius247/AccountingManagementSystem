package com.accounting.controller;

import com.accounting.model.User;
import com.accounting.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import jakarta.persistence.EntityNotFoundException;

@Controller
@RequestMapping("/user/settings")
public class UserSettingsController {

    @Autowired
    private UserService userService;

    @GetMapping
    public String showSettings(Authentication authentication, Model model) {
        String username = authentication.getName();
        User user = userService.findByUsernameWithCollections(username);
        model.addAttribute("user", user);
        return "user/settings";
    }

    @PostMapping("/profile")
    public String updateProfile(@ModelAttribute User user, Authentication authentication, RedirectAttributes redirectAttributes) {
        String username = authentication.getName();
        userService.updateProfile(username, user);
        redirectAttributes.addFlashAttribute("success", "Profile updated successfully");
        return "redirect:/user/settings";
    }

    @PostMapping("/password")
    public String changePassword(@RequestParam String currentPassword,
                               @RequestParam String newPassword,
                               Authentication authentication,
                               RedirectAttributes redirectAttributes) {
        String username = authentication.getName();
        try {
            userService.changePassword(username, currentPassword, newPassword);
            redirectAttributes.addFlashAttribute("success", "Password changed successfully");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/user/settings";
    }

    @PostMapping("/notifications")
    public String updateNotificationSettings(@RequestParam(required = false) boolean emailNotifications,
                                           @RequestParam(required = false) boolean paymentNotifications,
                                           @RequestParam(required = false) boolean documentNotifications,
                                           Authentication authentication,
                                           RedirectAttributes redirectAttributes) {
        String username = authentication.getName();
        userService.updateNotificationSettings(username, emailNotifications, paymentNotifications, documentNotifications);
        redirectAttributes.addFlashAttribute("success", "Notification settings updated successfully");
        return "redirect:/user/settings";
    }
} 