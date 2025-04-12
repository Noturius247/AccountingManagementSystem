package com.accounting.service;

import java.util.List;
import java.util.Map;

public interface BaseService<T> {
    
    /**
     * Updates an entity with the provided data
     * @param id The ID of the entity to update
     * @param entity The updated entity data
     * @return The updated entity
     */
    T update(Long id, T entity);
    
    /**
     * Updates specific fields of an entity
     * @param id The ID of the entity to update
     * @param updates Map of field names to new values
     * @return The updated entity
     */
    T updateFields(Long id, Map<String, Object> updates);
    
    /**
     * Updates the status of an entity
     * @param id The ID of the entity to update
     * @param status The new status
     * @return The updated entity
     */
    T updateStatus(Long id, String status);
    
    /**
     * Validates an entity before update
     * @param entity The entity to validate
     * @throws IllegalArgumentException if validation fails
     */
    void validate(T entity);
} 