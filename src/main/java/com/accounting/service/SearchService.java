package com.accounting.service;

import com.accounting.model.PaymentItem;
import com.accounting.model.FAQ;
import com.accounting.model.HelpTopic;
import com.accounting.model.Transaction;
import com.accounting.model.User;
import com.accounting.model.Payment;
import java.math.BigDecimal;
import java.util.*;

public interface SearchService {
    Map<String, Object> searchPaymentItems(String query, String category, String sortBy, int page, int size);
    
    List<FAQ> searchFAQ(String query, String category);
    
    List<HelpTopic> getHelpTopics();
    
    List<Map<String, Object>> getTransactionGuides();
    
    Set<String> getCategories();
    
    List<Map<String, Object>> search(String query, String type);
    
    List<Map<String, Object>> searchTransactions(String query);
    
    List<Map<String, Object>> searchUsers(String query);
    
    List<Map<String, Object>> searchPayments(String query);
    
    Map<String, Object> getSearchStatistics();
    
    Map<String, Object> getSearchSuggestions(String query);
    
    List<Transaction> searchTransactionsByQuery(String query);
    
    List<User> searchUsersByQuery(String query);
    
    List<Payment> searchPaymentsByQuery(String query);
    
    BigDecimal sumTransactionAmounts(String query);
    
    long countTransactions(String query);
    
    long countUsers(String query);
    
    long countPayments(String query);
    
    List<Transaction> advancedSearch(Map<String, Object> criteria);
    
    List<Transaction> searchByDateRange(String startDate, String endDate);
    
    List<Transaction> searchByAmountRange(BigDecimal minAmount, BigDecimal maxAmount);
    
    List<Transaction> searchByCategory(String category);
    
    List<Transaction> searchByDescription(String description);
} 