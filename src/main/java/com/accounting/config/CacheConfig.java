package com.accounting.config;

import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.cache.concurrent.ConcurrentMapCacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.cache.interceptor.KeyGenerator;
import org.springframework.cache.interceptor.SimpleKeyGenerator;

import java.util.Arrays;

@Configuration
@EnableCaching
public class CacheConfig {

    @Bean
    public CacheManager cacheManager() {
        ConcurrentMapCacheManager cacheManager = new ConcurrentMapCacheManager();
        cacheManager.setCacheNames(Arrays.asList(
            "transactions",
            "users",
            "settings",
            "queue",
            "notifications",
            "reports"
        ));
        return cacheManager;
    }

    @Bean
    public KeyGenerator keyGenerator() {
        return new SimpleKeyGenerator();
    }

    // Cache configuration for specific caches
    @Bean
    public org.springframework.cache.Cache transactionsCache() {
        return cacheManager().getCache("transactions");
    }

    @Bean
    public org.springframework.cache.Cache usersCache() {
        return cacheManager().getCache("users");
    }

    @Bean
    public org.springframework.cache.Cache settingsCache() {
        return cacheManager().getCache("settings");
    }

    @Bean
    public org.springframework.cache.Cache queueCache() {
        return cacheManager().getCache("queue");
    }

    @Bean
    public org.springframework.cache.Cache notificationsCache() {
        return cacheManager().getCache("notifications");
    }

    @Bean
    public org.springframework.cache.Cache reportsCache() {
        return cacheManager().getCache("reports");
    }
} 