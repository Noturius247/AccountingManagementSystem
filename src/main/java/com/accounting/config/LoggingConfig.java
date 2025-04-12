package com.accounting.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.filter.CommonsRequestLoggingFilter;

@Configuration
public class LoggingConfig {

    @Bean
    public CommonsRequestLoggingFilter requestLoggingFilter() {
        CommonsRequestLoggingFilter filter = new CommonsRequestLoggingFilter();
        filter.setIncludeQueryString(true);
        filter.setIncludePayload(true);
        filter.setMaxPayloadLength(10000);
        filter.setIncludeHeaders(true);
        filter.setAfterMessagePrefix("REQUEST DATA : ");
        return filter;
    }

    @Bean
    public Logger transactionLogger() {
        return LoggerFactory.getLogger("com.accounting.transaction");
    }

    @Bean
    public Logger securityLogger() {
        return LoggerFactory.getLogger("com.accounting.security");
    }

    @Bean
    public Logger performanceLogger() {
        return LoggerFactory.getLogger("com.accounting.performance");
    }

    @Bean
    public Logger errorLogger() {
        return LoggerFactory.getLogger("com.accounting.error");
    }
} 