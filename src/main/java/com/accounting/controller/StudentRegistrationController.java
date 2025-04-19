package com.accounting.controller;

import com.accounting.model.Student;
import com.accounting.model.User;
import com.accounting.service.StudentService;
import com.accounting.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/student-registration")
public class StudentRegistrationController {

    @Autowired
    private StudentService studentService;

    @Autowired
    private UserService userService;

    @GetMapping
    public String showRegistrationForm(Authentication authentication, Model model) {
        String username = authentication.getName();
        model.addAttribute("username", username);
        return "student/registration-form";
    }

    @PostMapping
    public String registerStudent(
            @RequestParam String username,
            @RequestParam String program,
            @RequestParam Integer yearLevel,
            Model model) {
        try {
            User user = userService.getUserByUsername(username);
            Student student = studentService.registerStudent(user, program, yearLevel);
            model.addAttribute("studentId", student.getStudentId());
            return "student/registration-success";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("username", username);
            return "student/registration-form";
        }
    }
} 