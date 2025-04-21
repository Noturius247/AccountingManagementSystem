package com.accounting.service.impl;

import com.accounting.service.PdfService;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfWriter;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.util.Map;

@Service
public class PdfServiceImpl implements PdfService {

    @Override
    public byte[] generatePdf(String content) {
        try {
            Document document = new Document();
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            PdfWriter.getInstance(document, outputStream);
            
            document.open();
            document.add(new Paragraph(content));
            document.close();
            
            return outputStream.toByteArray();
        } catch (DocumentException e) {
            throw new RuntimeException("Error generating PDF", e);
        }
    }

    @Override
    public byte[] generatePdf(String content, String template) {
        // TODO: Implement template-based PDF generation
        // For now, just use the basic PDF generation
        return generatePdf(content);
    }

    @Override
    public byte[] generatePdf(String content, String template, Map<String, String> metadata) {
        try {
            Document document = new Document();
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            PdfWriter writer = PdfWriter.getInstance(document, outputStream);
            
            document.open();
            
            // Add metadata if provided
            if (metadata != null) {
                for (Map.Entry<String, String> entry : metadata.entrySet()) {
                    document.add(new Paragraph(entry.getKey() + ": " + entry.getValue()));
                }
                document.add(new Paragraph("\n")); // Add a blank line after metadata
            }
            
            document.add(new Paragraph(content));
            document.close();
            
            return outputStream.toByteArray();
        } catch (DocumentException e) {
            throw new RuntimeException("Error generating PDF with metadata", e);
        }
    }
} 