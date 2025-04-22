package com.accounting.service;

import java.util.List;
import java.util.Map;

public interface KioskService {
    List<Map<String, String>> getAllCategories();
    List<Map<String, Object>> getAllPaymentItems();
    Map<String, Object> getPaymentItem(Long id);
    List<Map<String, Object>> searchPaymentItems(String query);
} 