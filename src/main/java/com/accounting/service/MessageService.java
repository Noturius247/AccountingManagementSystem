package com.accounting.service;

import org.springframework.stereotype.Service;

@Service
public class MessageService {

    public String getMessage() {
        return "Hello, welcome to the Accounting Management System!";
    }
} 