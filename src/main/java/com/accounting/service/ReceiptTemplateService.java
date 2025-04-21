package com.accounting.service;

import com.accounting.model.ReceiptTemplate;
import com.accounting.model.enums.ReceiptTemplateType;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public interface ReceiptTemplateService {
    ReceiptTemplate createTemplate(ReceiptTemplate template);
    ReceiptTemplate updateTemplate(Long id, ReceiptTemplate template);
    void deleteTemplate(Long id);
    Optional<ReceiptTemplate> getTemplateById(Long id);
    Optional<ReceiptTemplate> getTemplateByName(String name);
    List<ReceiptTemplate> getAllTemplates();
    List<ReceiptTemplate> getTemplatesByType(ReceiptTemplateType type);
    List<ReceiptTemplate> getActiveTemplates();
    String renderTemplate(String templateName, Map<String, Object> variables);
    String renderTemplate(Long templateId, Map<String, Object> variables);
    void validateTemplate(String templateContent);
    Map<String, String> extractTemplateVariables(String templateContent);
} 