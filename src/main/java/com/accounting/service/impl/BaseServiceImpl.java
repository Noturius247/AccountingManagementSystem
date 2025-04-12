package com.accounting.service.impl;

import com.accounting.service.BaseService;
import jakarta.persistence.EntityNotFoundException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.ReflectionUtils;

import java.lang.reflect.Field;
import java.time.LocalDateTime;
import java.util.Map;

@Slf4j
public abstract class BaseServiceImpl<T> implements BaseService<T> {

    protected abstract JpaRepository<T, Long> getRepository();
    protected abstract Class<T> getEntityClass();

    @Override
    @Transactional
    public T update(Long id, T entity) {
        log.debug("Updating {} with id: {}", getEntityClass().getSimpleName(), id);
        validate(entity);
        
        T existingEntity = getRepository().findById(id)
                .orElseThrow(() -> new EntityNotFoundException(
                        getEntityClass().getSimpleName() + " not found with id: " + id));
        
        updateEntityFields(existingEntity, entity);
        updateTimestamps(existingEntity);
        
        return getRepository().save(existingEntity);
    }

    @Override
    @Transactional
    public T updateFields(Long id, Map<String, Object> updates) {
        log.debug("Updating fields for {} with id: {}", getEntityClass().getSimpleName(), id);
        
        T entity = getRepository().findById(id)
                .orElseThrow(() -> new EntityNotFoundException(
                        getEntityClass().getSimpleName() + " not found with id: " + id));
        
        updates.forEach((key, value) -> {
            Field field = ReflectionUtils.findField(getEntityClass(), key);
            if (field != null) {
                field.setAccessible(true);
                ReflectionUtils.setField(field, entity, value);
            }
        });
        
        updateTimestamps(entity);
        validate(entity);
        
        return getRepository().save(entity);
    }

    @Override
    @Transactional
    public T updateStatus(Long id, String status) {
        log.debug("Updating status for {} with id: {} to {}", 
                getEntityClass().getSimpleName(), id, status);
        
        T entity = getRepository().findById(id)
                .orElseThrow(() -> new EntityNotFoundException(
                        getEntityClass().getSimpleName() + " not found with id: " + id));
        
        try {
            Field statusField = ReflectionUtils.findField(getEntityClass(), "status");
            if (statusField != null) {
                statusField.setAccessible(true);
                ReflectionUtils.setField(statusField, entity, status);
            }
        } catch (Exception e) {
            log.error("Error updating status", e);
            throw new RuntimeException("Failed to update status", e);
        }
        
        updateTimestamps(entity);
        validate(entity);
        
        return getRepository().save(entity);
    }

    protected void updateEntityFields(T existing, T updated) {
        // This method should be overridden by specific services to handle entity-specific updates
        throw new UnsupportedOperationException("updateEntityFields must be implemented by specific services");
    }

    protected void updateTimestamps(T entity) {
        try {
            Field updatedAtField = ReflectionUtils.findField(getEntityClass(), "updatedAt");
            if (updatedAtField != null) {
                updatedAtField.setAccessible(true);
                ReflectionUtils.setField(updatedAtField, entity, LocalDateTime.now());
            }
        } catch (Exception e) {
            log.error("Error updating timestamps", e);
        }
    }

    @Override
    public void validate(T entity) {
        // This method should be overridden by specific services to implement entity-specific validation
        throw new UnsupportedOperationException("validate must be implemented by specific services");
    }
} 