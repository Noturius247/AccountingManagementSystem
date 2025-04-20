package com.accounting.controller;

import com.accounting.model.Document;
import com.accounting.model.enums.DocumentStatus;
import com.accounting.model.enums.DocumentType;
import com.accounting.service.DocumentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/manager/documents")
@PreAuthorize("hasRole('MANAGER')")
public class ManagerDocumentController {

    @Autowired
    private DocumentService documentService;

    @GetMapping
    public String listDocuments(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "uploadedAt") String sort,
            @RequestParam(defaultValue = "desc") String direction,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String type,
            @RequestParam(required = false) String search,
            Model model) {
        
        // Create pageable object
        Sort.Direction sortDirection = Sort.Direction.fromString(direction);
        PageRequest pageable = PageRequest.of(page, size, Sort.by(sortDirection, sort));
        
        // Get filtered documents
        Page<Document> documents;
        if (search != null && !search.isEmpty()) {
            documents = documentService.searchDocuments(search, pageable);
        } else if (status != null && !status.isEmpty() && type != null && !type.isEmpty()) {
            documents = documentService.findByStatusAndType(
                DocumentStatus.valueOf(status),
                DocumentType.valueOf(type),
                pageable
            );
        } else if (status != null && !status.isEmpty()) {
            documents = documentService.findByStatus(
                DocumentStatus.valueOf(status),
                pageable
            );
        } else if (type != null && !type.isEmpty()) {
            documents = documentService.findByType(
                DocumentType.valueOf(type),
                pageable
            );
        } else {
            documents = documentService.findAll(pageable);
        }
        
        // Get document statistics
        Map<String, Object> statistics = new HashMap<>();
        statistics.put("totalDocuments", documentService.getDocumentCount());
        statistics.put("pendingDocuments", documentService.countDocumentsByStatus(DocumentStatus.PENDING));
        statistics.put("approvedDocuments", documentService.countDocumentsByStatus(DocumentStatus.APPROVED));
        statistics.put("rejectedDocuments", documentService.countDocumentsByStatus(DocumentStatus.REJECTED));
        
        model.addAttribute("documents", documents);
        model.addAttribute("statistics", statistics);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", documents.getTotalPages());
        model.addAttribute("sort", sort);
        model.addAttribute("direction", direction);
        model.addAttribute("status", status);
        model.addAttribute("type", type);
        model.addAttribute("search", search);
        
        return "manager/documents";
    }

    @GetMapping("/{id}")
    @ResponseBody
    public Document getDocument(@PathVariable Long id) {
        return documentService.getDocumentById(id);
    }

    @PostMapping("/{id}/approve")
    @ResponseBody
    public Map<String, Object> approveDocument(@PathVariable Long id, @RequestParam(required = false) String comment) {
        Document document = documentService.updateDocumentStatus(id, DocumentStatus.APPROVED, comment);
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Document approved successfully");
        response.put("document", document);
        return response;
    }

    @PostMapping("/{id}/reject")
    @ResponseBody
    public Map<String, Object> rejectDocument(@PathVariable Long id, @RequestParam(required = false) String reason) {
        Document document = documentService.updateDocumentStatus(id, DocumentStatus.REJECTED, reason);
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Document rejected successfully");
        response.put("document", document);
        return response;
    }

    @PostMapping("/bulk-approve")
    @ResponseBody
    public Map<String, Object> bulkApproveDocuments(@RequestBody List<Long> documentIds, @RequestParam(required = false) String comment) {
        for (Long id : documentIds) {
            documentService.updateDocumentStatus(id, DocumentStatus.APPROVED, comment);
        }
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Documents approved successfully");
        return response;
    }

    @PostMapping("/bulk-reject")
    @ResponseBody
    public Map<String, Object> bulkRejectDocuments(@RequestBody List<Long> documentIds, @RequestParam(required = false) String reason) {
        for (Long id : documentIds) {
            documentService.updateDocumentStatus(id, DocumentStatus.REJECTED, reason);
        }
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Documents rejected successfully");
        return response;
    }

    @GetMapping("/{id}/history")
    @ResponseBody
    public List<Map<String, Object>> getDocumentHistory(@PathVariable Long id) {
        return documentService.getDocumentHistory(id);
    }

    @PostMapping("/{id}/comment")
    @ResponseBody
    public Map<String, Object> addComment(@PathVariable Long id, @RequestParam String comment) {
        documentService.addComment(id, comment);
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Comment added successfully");
        return response;
    }

    @GetMapping("/statistics")
    @ResponseBody
    public Map<String, Object> getDocumentStatistics() {
        Map<String, Object> statistics = new HashMap<>();
        statistics.put("totalDocuments", documentService.getDocumentCount());
        statistics.put("pendingDocuments", documentService.countDocumentsByStatus(DocumentStatus.PENDING));
        statistics.put("approvedDocuments", documentService.countDocumentsByStatus(DocumentStatus.APPROVED));
        statistics.put("rejectedDocuments", documentService.countDocumentsByStatus(DocumentStatus.REJECTED));
        statistics.put("byType", documentService.countDocumentsByType(DocumentType.RECEIPT));
        return statistics;
    }
} 