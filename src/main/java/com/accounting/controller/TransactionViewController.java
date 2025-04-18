package com.accounting.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import com.accounting.service.TransactionService;
import java.util.List;
import com.accounting.model.Transaction;

@Controller
@RequestMapping
public class TransactionViewController {

    @Autowired
    private TransactionService transactionService;

    @GetMapping("/transactions")
    public String transactions(Model model) {
        model.addAttribute("transactions", transactionService.getAllTransactions());
        return "user/transactions";
    }
} 