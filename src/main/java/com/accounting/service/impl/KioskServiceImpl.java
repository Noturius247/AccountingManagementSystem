package com.accounting.service.impl;

import com.accounting.service.KioskService;
import org.springframework.stereotype.Service;
import java.util.*;

@Service
public class KioskServiceImpl implements KioskService {
    
    // Mock data for payment categories
    private final List<Map<String, String>> categories = Arrays.asList(
        createCategory("Tuition Fee", "Regular and special term tuition payments", "fas fa-graduation-cap"),
        createCategory("Library Fee", "Library access and resource fees", "fas fa-book"),
        createCategory("Laboratory Fee", "Laboratory and equipment usage fees", "fas fa-flask"),
        createCategory("Miscellaneous", "Other school-related payments", "fas fa-list-alt"),
        createCategory("Documents", "Transcript and certification requests", "fas fa-file-alt"),
        createCategory("Events", "School events and activities", "fas fa-calendar")
    );

    // Mock data for payment items
    private final List<Map<String, Object>> paymentItems = Arrays.asList(
        createPaymentItem(1L, "First Semester Tuition", "Regular term tuition payment", 25000.00, "2024-06-30"),
        createPaymentItem(2L, "Library Access Fee", "Semester library access", 500.00, "2024-05-15"),
        createPaymentItem(3L, "Chemistry Lab Fee", "Laboratory equipment and materials", 1500.00, "2024-05-20"),
        createPaymentItem(4L, "Student ID Replacement", "Lost ID replacement fee", 150.00, "2024-04-30"),
        createPaymentItem(5L, "Graduation Fee", "Graduation ceremony and documents", 3000.00, "2024-07-15"),
        createPaymentItem(6L, "Transcript Request", "Official transcript processing", 200.00, "2024-05-01")
    );

    private Map<String, String> createCategory(String name, String description, String icon) {
        Map<String, String> category = new HashMap<>();
        category.put("name", name);
        category.put("description", description);
        category.put("icon", icon);
        return category;
    }

    private Map<String, Object> createPaymentItem(Long id, String name, String description, 
            double amount, String dueDate) {
        Map<String, Object> item = new HashMap<>();
        item.put("id", id);
        item.put("name", name);
        item.put("description", description);
        item.put("amount", amount);
        item.put("dueDate", dueDate);
        return item;
    }

    @Override
    public List<Map<String, String>> getAllCategories() {
        return categories;
    }

    @Override
    public List<Map<String, Object>> getAllPaymentItems() {
        return paymentItems;
    }

    @Override
    public Map<String, Object> getPaymentItem(Long id) {
        return paymentItems.stream()
                .filter(item -> id.equals(item.get("id")))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("Payment item not found"));
    }

    @Override
    public List<Map<String, Object>> searchPaymentItems(String query) {
        if (query == null || query.trim().isEmpty()) {
            return paymentItems;
        }
        
        String lowercaseQuery = query.toLowerCase();
        return paymentItems.stream()
                .filter(item -> 
                    item.get("name").toString().toLowerCase().contains(lowercaseQuery) ||
                    item.get("description").toString().toLowerCase().contains(lowercaseQuery))
                .toList();
    }
} 