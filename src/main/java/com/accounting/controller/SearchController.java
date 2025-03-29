package com.accounting.controller;

import com.accounting.service.SearchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/search")
public class SearchController {

    @Autowired
    private SearchService searchService;

    @GetMapping("/payment-items")
    public ResponseEntity<?> searchPaymentItems(
            @RequestParam(required = false) String query,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String sortBy,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        return ResponseEntity.ok(searchService.searchPaymentItems(query, category, sortBy, page, size));
    }

    @GetMapping("/faq")
    public ResponseEntity<?> searchFAQ(
            @RequestParam(required = false) String query,
            @RequestParam(required = false) String category) {
        return ResponseEntity.ok(searchService.searchFAQ(query, category));
    }

    @GetMapping("/help-topics")
    public ResponseEntity<?> getHelpTopics() {
        return ResponseEntity.ok(searchService.getHelpTopics());
    }

    @GetMapping("/transaction-guides")
    public ResponseEntity<?> getTransactionGuides() {
        return ResponseEntity.ok(searchService.getTransactionGuides());
    }

    @GetMapping("/categories")
    public ResponseEntity<?> getCategories() {
        return ResponseEntity.ok(searchService.getCategories());
    }
} 