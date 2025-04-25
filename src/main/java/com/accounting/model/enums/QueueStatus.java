package com.accounting.model.enums;

/**
 * Represents the possible states of a queue entry.
 */
public enum QueueStatus {
    PENDING,    // Initial state when queue entry is created   // Queue entry is waiting for processing
    PROCESSING, // Queue entry is being processed
    COMPLETED,  // Queue entry has been completed
    CANCELLED   // Queue entry has been cancelled
}