package com.accounting.service.impl;

import com.accounting.model.ReceiptTemplate;
import com.accounting.model.enums.ReceiptTemplateType;
import com.accounting.repository.ReceiptTemplateRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;
import org.springframework.util.StreamUtils;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

@Component
public class ReceiptTemplateInitializer {

    private final ReceiptTemplateRepository templateRepository;

    @Autowired
    public ReceiptTemplateInitializer(ReceiptTemplateRepository templateRepository) {
        this.templateRepository = templateRepository;
    }

    @EventListener(ApplicationReadyEvent.class)
    public void initializeDefaultTemplates() throws IOException {
        if (!templateRepository.findByName("default-html").isPresent()) {
            createDefaultHtmlTemplate();
        }
        
        if (!templateRepository.findByName("default-thermal").isPresent()) {
            createDefaultThermalTemplate();
        }
    }

    private void createDefaultHtmlTemplate() throws IOException {
        ClassPathResource resource = new ClassPathResource("templates/default-receipt.html");
        String templateContent = StreamUtils.copyToString(resource.getInputStream(), StandardCharsets.UTF_8);
        
        ReceiptTemplate template = new ReceiptTemplate();
        template.setName("default-html");
        template.setDescription("Default HTML receipt template");
        template.setTemplateContent(templateContent);
        template.setType(ReceiptTemplateType.HTML);
        template.setActive(true);
        
        templateRepository.save(template);
    }

    private void createDefaultThermalTemplate() throws IOException {
        ClassPathResource resource = new ClassPathResource("templates/thermal-receipt.txt");
        String templateContent = StreamUtils.copyToString(resource.getInputStream(), StandardCharsets.UTF_8);
        
        ReceiptTemplate template = new ReceiptTemplate();
        template.setName("default-thermal");
        template.setDescription("Default thermal printer receipt template");
        template.setTemplateContent(templateContent);
        template.setType(ReceiptTemplateType.THERMAL_PRINTER);
        template.setActive(true);
        
        templateRepository.save(template);
    }
} 