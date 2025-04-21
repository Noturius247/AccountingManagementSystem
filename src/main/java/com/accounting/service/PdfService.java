package com.accounting.service;

public interface PdfService {
    /**
     * Generate a PDF from text content
     * @param content The text content to convert to PDF
     * @return The PDF content as a byte array
     */
    byte[] generatePdf(String content);
    
    /**
     * Generate a PDF with custom formatting
     * @param content The content to convert to PDF
     * @param template The template name to use for formatting
     * @return The PDF content as a byte array
     */
    byte[] generatePdf(String content, String template);
    
    /**
     * Generate a PDF with custom formatting and metadata
     * @param content The content to convert to PDF
     * @param template The template name to use for formatting
     * @param metadata Additional metadata for the PDF
     * @return The PDF content as a byte array
     */
    byte[] generatePdf(String content, String template, java.util.Map<String, String> metadata);
} 