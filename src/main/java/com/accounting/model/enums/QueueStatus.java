package com.accounting.model.enums;

/**
 * Represents the possible states of a queue entry.
 */
public enum QueueStatus {
    PENDING,    // Initial state when queue entry is created   // Queue entry is waiting for processing
    PROCESSED, // Queue entry is being processed
    FAILED,  // Queue entry has been completed
    REFUNDED   // Queue entry has been cancelled
}