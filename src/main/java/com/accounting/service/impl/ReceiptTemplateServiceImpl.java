package com.accounting.service.impl;

import com.accounting.model.ReceiptTemplate;
import com.accounting.model.enums.ReceiptTemplateType;
import com.accounting.repository.ReceiptTemplateRepository;
import com.accounting.service.ReceiptTemplateService;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.thymeleaf.spring6.SpringTemplateEngine;
import org.thymeleaf.context.Context;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
@Transactional
public class ReceiptTemplateServiceImpl implements ReceiptTemplateService {
    private static final Logger logger = LoggerFactory.getLogger(ReceiptTemplateServiceImpl.class);
    private static final Pattern VARIABLE_PATTERN = Pattern.compile("\\{\\{\\s*(\\w+)\\s*\\}\\}");

    private final ReceiptTemplateRepository templateRepository;
    private final SpringTemplateEngine templateEngine;

    public ReceiptTemplateServiceImpl(ReceiptTemplateRepository templateRepository, SpringTemplateEngine templateEngine) {
        this.templateRepository = templateRepository;
        this.templateEngine = templateEngine;
    }

    @Override
    public ReceiptTemplate createTemplate(ReceiptTemplate template) {
        validateTemplate(template.getTemplateContent());
        template.setVariables(extractTemplateVariables(template.getTemplateContent()));
        return templateRepository.save(template);
    }

    @Override
    public ReceiptTemplate updateTemplate(Long id, ReceiptTemplate template) {
        ReceiptTemplate existingTemplate = templateRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Template not found with id: " + id));

        validateTemplate(template.getTemplateContent());
        
        existingTemplate.setName(template.getName());
        existingTemplate.setDescription(template.getDescription());
        existingTemplate.setTemplateContent(template.getTemplateContent());
        existingTemplate.setType(template.getType());
        existingTemplate.setActive(template.isActive());
        existingTemplate.setVariables(extractTemplateVariables(template.getTemplateContent()));
        
        return templateRepository.save(existingTemplate);
    }

    @Override
    public void deleteTemplate(Long id) {
        if (!templateRepository.existsById(id)) {
            throw new EntityNotFoundException("Template not found with id: " + id);
        }
        templateRepository.deleteById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<ReceiptTemplate> getTemplateById(Long id) {
        return templateRepository.findById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<ReceiptTemplate> getTemplateByName(String name) {
        return templateRepository.findByNameAndActiveTrue(name);
    }

    @Override
    @Transactional(readOnly = true)
    public List<ReceiptTemplate> getAllTemplates() {
        return templateRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public List<ReceiptTemplate> getTemplatesByType(ReceiptTemplateType type) {
        return templateRepository.findByType(type);
    }

    @Override
    @Transactional(readOnly = true)
    public List<ReceiptTemplate> getActiveTemplates() {
        return templateRepository.findByActiveTrue();
    }

    @Override
    public String renderTemplate(String templateName, Map<String, Object> variables) {
        ReceiptTemplate template = templateRepository.findByNameAndActiveTrue(templateName)
                .orElseThrow(() -> new EntityNotFoundException("Template not found with name: " + templateName));
        return renderTemplateContent(template.getTemplateContent(), variables);
    }

    @Override
    public String renderTemplate(Long templateId, Map<String, Object> variables) {
        ReceiptTemplate template = templateRepository.findById(templateId)
                .orElseThrow(() -> new EntityNotFoundException("Template not found with id: " + templateId));
        return renderTemplateContent(template.getTemplateContent(), variables);
    }

    @Override
    public void validateTemplate(String templateContent) {
        if (templateContent == null || templateContent.trim().isEmpty()) {
            throw new IllegalArgumentException("Template content cannot be empty");
        }

        try {
            // Try to render the template with empty variables to validate syntax
            renderTemplateContent(templateContent, new HashMap<>());
        } catch (Exception e) {
            throw new IllegalArgumentException("Invalid template syntax: " + e.getMessage());
        }
    }

    @Override
    public Map<String, String> extractTemplateVariables(String templateContent) {
        Map<String, String> variables = new HashMap<>();
        Matcher matcher = VARIABLE_PATTERN.matcher(templateContent);
        
        while (matcher.find()) {
            String variable = matcher.group(1);
            variables.put(variable, "Variable for " + variable);
        }
        
        return variables;
    }

    private String renderTemplateContent(String templateContent, Map<String, Object> variables) {
        Context context = new Context();
        variables.forEach(context::setVariable);
        
        // Add default variables
        context.setVariable("currentDate", new Date());
        context.setVariable("currentDateTime", new Date());
        
        return templateEngine.process(templateContent, context);
    }
} 