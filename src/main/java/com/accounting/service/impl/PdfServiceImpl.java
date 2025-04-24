package com.accounting.service.impl;

import com.accounting.service.PdfService;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.draw.LineSeparator;
import org.springframework.stereotype.Service;
import java.io.ByteArrayOutputStream;
import java.util.Map;

@Service
public class PdfServiceImpl implements PdfService {

    private static final Font TITLE_FONT = new Font(Font.FontFamily.HELVETICA, 16, Font.BOLD);
    private static final Font HEADER_FONT = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
    private static final Font NORMAL_FONT = new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL);
    private static final Font SMALL_FONT = new Font(Font.FontFamily.HELVETICA, 8, Font.NORMAL);

    @Override
    public byte[] generatePdf(String content) {
        try {
            Document document = new Document(PageSize.A6); // Receipt size paper
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            PdfWriter.getInstance(document, outputStream);
            
            document.open();
            
            // Add school logo or header
            Paragraph header = new Paragraph("School Payment System", TITLE_FONT);
            header.setAlignment(Element.ALIGN_CENTER);
            document.add(header);
            
            // Add line separator
            LineSeparator separator = new LineSeparator();
            document.add(new Chunk(separator));
            
            // Add content with proper formatting
            String[] lines = content.split("\n");
            for (String line : lines) {
                if (line.startsWith("===")) {
                    document.add(new Chunk(separator));
                } else if (line.trim().equals("PAYMENT RECEIPT")) {
                    Paragraph title = new Paragraph(line.trim(), HEADER_FONT);
                    title.setAlignment(Element.ALIGN_CENTER);
                    title.setSpacingBefore(10);
                    title.setSpacingAfter(10);
                    document.add(title);
                } else if (line.contains(":")) {
                    String[] parts = line.split(":", 2);
                    Paragraph p = new Paragraph();
                    p.add(new Chunk(parts[0].trim() + ": ", HEADER_FONT));
                    p.add(new Chunk(parts[1].trim(), NORMAL_FONT));
                    document.add(p);
                } else {
                    Paragraph p = new Paragraph(line.trim(), NORMAL_FONT);
                    document.add(p);
                }
            }
            
            // Add footer
            document.add(new Chunk(separator));
            Paragraph footer = new Paragraph("Keep this receipt for your records", SMALL_FONT);
            footer.setAlignment(Element.ALIGN_CENTER);
            document.add(footer);
            
            document.close();
            return outputStream.toByteArray();
        } catch (DocumentException e) {
            throw new RuntimeException("Error generating PDF", e);
        }
    }

    @Override
    public byte[] generatePdf(String content, String template) {
        // For now, we'll use the same generation method
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