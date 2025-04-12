package com.accounting.controller;

import com.accounting.model.Document;
import com.accounting.service.SearchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/documents")
public class DocumentController {

    @Autowired
    private SearchService searchService;

    @GetMapping
    public ResponseEntity<List<Map<String, Object>>> searchDocuments(@RequestParam String query) {
        return ResponseEntity.ok(searchService.search(query, "documents"));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Map<String, Object>> getDocument(@PathVariable Long id) {
        List<Map<String, Object>> documents = searchService.search("id:" + id, "documents");
        return !documents.isEmpty() ? ResponseEntity.ok(documents.get(0)) : ResponseEntity.notFound().build();
    }

    @PostMapping
    public ResponseEntity<Map<String, Object>> createDocument(@RequestBody Document document) {
        // Implementation would depend on your document storage system
        return ResponseEntity.ok(Map.of("status", "success", "message", "Document created"));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Map<String, Object>> updateDocument(
            @PathVariable Long id,
            @RequestBody Document document) {
        // Implementation would depend on your document storage system
        return ResponseEntity.ok(Map.of("status", "success", "message", "Document updated"));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteDocument(@PathVariable Long id) {
        // Implementation would depend on your document storage system
        return ResponseEntity.ok().build();
    }

    @GetMapping("/stats")
    public ResponseEntity<Map<String, Object>> getDocumentStatistics() {
        return ResponseEntity.ok(searchService.getSearchStatistics());
    }
} 