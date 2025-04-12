package com.accounting.controller;

import com.accounting.model.FAQ;
import com.accounting.model.HelpTopic;
import com.accounting.service.SearchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Set;

@RestController
@RequestMapping("/api/help")
public class HelpController {

    @Autowired
    private SearchService searchService;

    @GetMapping("/topics")
    public ResponseEntity<List<HelpTopic>> getAllTopics() {
        return ResponseEntity.ok(searchService.getHelpTopics());
    }

    @GetMapping("/topics/{topicId}/articles")
    public ResponseEntity<List<Map<String, Object>>> getArticlesByTopic(@PathVariable Long topicId) {
        return ResponseEntity.ok(searchService.getTransactionGuides());
    }

    @GetMapping("/faq")
    public ResponseEntity<List<FAQ>> searchFAQ(
            @RequestParam(required = false) String query,
            @RequestParam(required = false) String category) {
        return ResponseEntity.ok(searchService.searchFAQ(query, category));
    }

    @GetMapping("/categories")
    public ResponseEntity<Set<String>> getCategories() {
        return ResponseEntity.ok(searchService.getCategories());
    }

    @GetMapping("/search")
    public ResponseEntity<List<Map<String, Object>>> search(
            @RequestParam String query,
            @RequestParam String type) {
        return ResponseEntity.ok(searchService.search(query, type));
    }

    @GetMapping("/suggestions")
    public ResponseEntity<Map<String, Object>> getSuggestions(@RequestParam String query) {
        return ResponseEntity.ok(searchService.getSearchSuggestions(query));
    }
} 