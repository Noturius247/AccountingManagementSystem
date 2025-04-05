package com.accounting.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/search")
public class SearchServlet extends BaseServlet {
    private static final long serialVersionUID = 1L;
    
    // Mock search data
    private static final List<Map<String, String>> mockData = new ArrayList<>();
    
    static {
        // Initialize mock search data
        Map<String, String> item1 = new HashMap<>();
        item1.put("type", "transaction");
        item1.put("id", "TR001");
        item1.put("description", "Payment for Invoice #123");
        item1.put("amount", "$1000.00");
        mockData.add(item1);
        
        Map<String, String> item2 = new HashMap<>();
        item2.put("type", "invoice");
        item2.put("id", "INV123");
        item2.put("description", "Monthly Service Fee");
        item2.put("amount", "$500.00");
        mockData.add(item2);
        
        Map<String, String> item3 = new HashMap<>();
        item3.put("type", "user");
        item3.put("id", "USR001");
        item3.put("description", "John Doe");
        item3.put("department", "Accounting");
        mockData.add(item3);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String query = request.getParameter("q");
        String type = request.getParameter("type");
        
        List<Map<String, String>> results = new ArrayList<>();
        
        if (query != null && !query.trim().isEmpty()) {
            // Mock search logic
            for (Map<String, String> item : mockData) {
                if (type != null && !type.isEmpty() && !item.get("type").equals(type)) {
                    continue;
                }
                
                if (item.get("description").toLowerCase().contains(query.toLowerCase()) ||
                    item.get("id").toLowerCase().contains(query.toLowerCase())) {
                    results.add(item);
                }
            }
        }
        
        request.setAttribute("pageTitle", "Search Results");
        request.setAttribute("query", query);
        request.setAttribute("type", type);
        request.setAttribute("results", results);
        forwardToJsp(request, response, "/jsp/search.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
} 