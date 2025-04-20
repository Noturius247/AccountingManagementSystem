package com.accounting.controller;

import com.accounting.model.Document;
import com.accounting.model.enums.DocumentStatus;
import com.accounting.service.DocumentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

@Controller
@RequestMapping("/user/documents")
public class UserDocumentController {

    @Autowired
    private DocumentService documentService;

    @GetMapping
    public String listDocuments(Authentication authentication, Model model) {
        String username = authentication.getName();
        List<Document> documents = documentService.getDocumentsByUser(username);
        
        // Add statistics
        Map<String, Object> statistics = new HashMap<>();
        statistics.put("totalDocuments", documentService.countDocumentsByUser(username));
        statistics.put("draftDocuments", documentService.countDocumentsByStatus(DocumentStatus.DRAFT));
        
        model.addAttribute("documents", documents);
        model.addAttribute("statistics", statistics);
        return "user/documents";
    }
} 