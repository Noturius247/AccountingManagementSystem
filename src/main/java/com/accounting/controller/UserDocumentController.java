package com.accounting.controller;

import com.accounting.model.Document;
import com.accounting.service.DocumentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/user/documents")
public class UserDocumentController {

    @Autowired
    private DocumentService documentService;

    @GetMapping
    public String listDocuments(Authentication authentication, Model model) {
        String username = authentication.getName();
        List<Document> documents = documentService.getDocumentsByUser(username);
        model.addAttribute("documents", documents);
        return "user/documents";
    }
} 