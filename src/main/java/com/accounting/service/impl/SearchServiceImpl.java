package com.accounting.service.impl;

import com.accounting.model.*;
import com.accounting.repository.*;
import com.accounting.service.SearchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class SearchServiceImpl implements SearchService {
    
    private static final Logger logger = LoggerFactory.getLogger(SearchServiceImpl.class);
    
    @Autowired
    private TransactionRepository transactionRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private PaymentRepository paymentRepository;
    @Autowired
    private FAQRepository faqRepository;
    @Autowired
    private HelpTopicRepository helpTopicRepository;
    @Autowired
    private HelpArticleRepository helpArticleRepository;

    // In-memory storage (replace with database in production)
    private final Map<String, PaymentItem> paymentItems = new HashMap<>();
    private final Map<String, FAQ> faqs = new HashMap<>();
    private final Map<String, HelpTopic> helpTopics = new HashMap<>();
    private final Set<String> categories = new HashSet<>();

    @Override
    public Map<String, Object> searchPaymentItems(String query, String category, String sortBy, int page, int size) {
        List<Payment> payments = paymentRepository.findByDescriptionContaining(query);
        Map<String, Object> result = new HashMap<>();
        result.put("items", payments.stream()
                .map(this::convertPaymentToMap)
                .collect(Collectors.toList()));
        result.put("total", payments.size());
        return result;
    }

    @Override
    public List<FAQ> searchFAQ(String query, String category) {
        return faqRepository.findByQuestionContainingOrAnswerContaining(query);
    }

    @Override
    public List<HelpTopic> getHelpTopics() {
        return helpTopicRepository.findAll();
    }

    @Override
    public List<Map<String, Object>> getTransactionGuides() {
        return helpArticleRepository.findAll().stream()
                .map(this::convertHelpArticleToMap)
                .collect(Collectors.toList());
    }

    @Override
    public Set<String> getCategories() {
        return new HashSet<>(Arrays.asList("Payment", "Transaction", "User", "FAQ", "Help"));
    }

    @Override
    public List<Map<String, Object>> search(String query, String type) {
        switch (type.toLowerCase()) {
            case "transactions":
                return searchTransactions(query);
            case "users":
                return searchUsers(query);
            case "payments":
                return searchPayments(query);
            default:
                return Collections.emptyList();
        }
    }

    @Override
    public List<Map<String, Object>> searchTransactions(String query) {
        return transactionRepository.findByNotesContaining(query).stream()
                .map(t -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("id", t.getId());
                    map.put("description", t.getNotes());
                    map.put("amount", t.getAmount());
                    return map;
                })
                .collect(Collectors.toList());
    }

    @Override
    public List<Map<String, Object>> searchUsers(String query) {
        return userRepository.findByUsernameContaining(query).stream()
                .map(u -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("id", u.getId());
                    map.put("username", u.getUsername());
                    map.put("email", u.getEmail());
                    return map;
                })
                .collect(Collectors.toList());
    }

    @Override
    public List<Map<String, Object>> searchPayments(String query) {
        return paymentRepository.findByDescriptionContaining(query).stream()
                .map(this::convertPaymentToMap)
                .collect(Collectors.toList());
    }

    @Override
    public Map<String, Object> getSearchStatistics() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalTransactions", transactionRepository.count());
        stats.put("totalUsers", userRepository.count());
        stats.put("totalPayments", paymentRepository.count());
        return stats;
    }

    @Override
    public Map<String, Object> getSearchSuggestions(String query) {
        Map<String, Object> suggestions = new HashMap<>();
        suggestions.put("transactions", transactionRepository.findTop5ByNotesContainingOrderByCreatedAtDesc(query));
        suggestions.put("users", userRepository.findTop5ByUsernameContaining(query));
        suggestions.put("payments", paymentRepository.findTop5ByDescriptionContainingOrderByCreatedAtDesc(query));
        return suggestions;
    }

    @Override
    public List<Transaction> searchByDescription(String description) {
        return transactionRepository.findByNotesContaining(description);
    }

    @Override
    public List<Transaction> advancedSearch(Map<String, Object> criteria) {
        // Implementation would perform advanced search based on multiple criteria
        return new ArrayList<>();
    }

    @Override
    public List<Transaction> searchByDateRange(String startDate, String endDate) {
        // Implementation would search transactions within date range
        return new ArrayList<>();
    }

    @Override
    public List<Transaction> searchByAmountRange(BigDecimal minAmount, BigDecimal maxAmount) {
        // Implementation would search transactions within amount range
        return new ArrayList<>();
    }

    @Override
    public List<Transaction> searchByCategory(String category) {
        // Implementation would search transactions by category
        return new ArrayList<>();
    }

    @Override
    public List<Transaction> searchTransactionsByQuery(String query) {
        return transactionRepository.findByNotesContaining(query);
    }

    @Override
    public List<User> searchUsersByQuery(String query) {
        return userRepository.findByUsernameContaining(query);
    }

    @Override
    public List<Payment> searchPaymentsByQuery(String query) {
        return paymentRepository.findByDescriptionContaining(query);
    }

    @Override
    public BigDecimal sumTransactionAmounts(String query) {
        return transactionRepository.findByNotesContaining(query).stream()
                .map(Transaction::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    @Override
    public long countTransactions(String query) {
        return transactionRepository.countByNotesContaining(query);
    }

    @Override
    public long countUsers(String query) {
        return userRepository.countByUsernameContaining(query);
    }

    @Override
    public long countPayments(String query) {
        return paymentRepository.countByDescriptionContaining(query);
    }

    private Map<String, Object> convertPaymentToMap(Payment payment) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", payment.getId());
        map.put("description", payment.getDescription());
        map.put("amount", payment.getAmount());
        return map;
    }

    private Map<String, Object> convertHelpArticleToMap(HelpArticle article) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", article.getId());
        map.put("title", article.getTitle());
        map.put("content", article.getContent());
        return map;
    }
} 