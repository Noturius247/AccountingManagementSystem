package com.accounting.service;

import com.accounting.model.PaymentItem;
import com.accounting.model.FAQ;
import com.accounting.model.HelpTopic;
import org.springframework.stereotype.Service;
import java.util.*;

@Service
public class SearchService {
    
    // In-memory storage (replace with database in production)
    private final Map<String, PaymentItem> paymentItems = new HashMap<>();
    private final Map<String, FAQ> faqs = new HashMap<>();
    private final Map<String, HelpTopic> helpTopics = new HashMap<>();
    private final Set<String> categories = new HashSet<>();

    public Map<String, Object> searchPaymentItems(String query, String category, String sortBy, int page, int size) {
        List<PaymentItem> results = paymentItems.values().stream()
            .filter(item -> matchesQuery(item, query))
            .filter(item -> category == null || item.getCategory().equals(category))
            .sorted(getComparator(sortBy))
            .toList();

        int total = results.size();
        int start = page * size;
        int end = Math.min(start + size, total);
        
        return Map.of(
            "items", results.subList(start, end),
            "total", total,
            "page", page,
            "size", size
        );
    }

    public List<FAQ> searchFAQ(String query, String category) {
        return faqs.values().stream()
            .filter(faq -> matchesQuery(faq, query))
            .filter(faq -> category == null || faq.getCategory().equals(category))
            .toList();
    }

    public List<HelpTopic> getHelpTopics() {
        return new ArrayList<>(helpTopics.values());
    }

    public List<Map<String, Object>> getTransactionGuides() {
        // Implementation for transaction guides
        return new ArrayList<>();
    }

    public Set<String> getCategories() {
        return categories;
    }

    private boolean matchesQuery(PaymentItem item, String query) {
        if (query == null || query.trim().isEmpty()) {
            return true;
        }
        String searchQuery = query.toLowerCase();
        return item.getName().toLowerCase().contains(searchQuery) ||
               item.getDescription().toLowerCase().contains(searchQuery);
    }

    private boolean matchesQuery(FAQ faq, String query) {
        if (query == null || query.trim().isEmpty()) {
            return true;
        }
        String searchQuery = query.toLowerCase();
        return faq.getQuestion().toLowerCase().contains(searchQuery) ||
               faq.getAnswer().toLowerCase().contains(searchQuery);
    }

    private Comparator<PaymentItem> getComparator(String sortBy) {
        return switch (sortBy) {
            case "amount" -> Comparator.comparingDouble(PaymentItem::getAmount);
            case "category" -> Comparator.comparing(PaymentItem::getCategory);
            default -> Comparator.comparing(PaymentItem::getName);
        };
    }
} 